/*clase 3 seguridad en base de datos objectivos:
evidenciar que las contraseñas esten encriptadas (hash y salt) y aplicar practicas de seguridad sobre los datos


1 hash vs cifrado teoria
2 contraseñas con hash + salt (SHA2)
3 procedimiento para registrar usurios, hacer login y cambiar clave 
4 cifrado reversible para datos sensibles (AES)
5 auditorias con TRIGGER 
6 vistas que olcultan datos sensibles 
7 usuariso y roles de mysql con minimo privilegio (GRANT / REVOKE)
8 prevencion de sql injeccion con consultas preparadas 
*/
/*
--1 hash vs cifrado para las contraseñas 
-convirte un texto en una hulla de longitud fija 
-no se puede revertir. Para validar el login se calcula el hash de la clave escrita y se compara con el guardado

-Salt texto aleatorio distinto para cada usuario que se mezcla con la clave antes del hash asi dos usurios con la misma clave tiene hashesh diferentes y se frustra la redundancia en la tablas


-cifrado ( dos vias) para datos sensibles que hay que volver a leer 
-con llave se cifra y con la misma llave se descifra 
*nunca guardar contraseñas en segunfdo plano*
*/

--Demostracion del texto siempre da el mismo hash 

select  SHA2('Clave123*', 256)as hash_1;
select  SHA2('Clave123*', 256)as hash_2;

--domostracion utilizando salt misma clave, salt distinto = hash distinto
select SHA2(concat('a1b2c3', 'Clave123*')) as hash_usuario_A;
select SHA2(concat('a9y8x7', 'Clave123*')) as hash_usuario_B;


--generar un salt aleatoriode 32 caracteres hexadecimal 
--Mezclamos UUID (identificardor unico) + RAND ()(numero al azar) + la hora con milisegundos y 
--tomamos los 32 caracteres del resultado
--en mysql 8 exiten  hex(Randon_bytes(16)) mas robusto pero mariadb no lo tiene

select left (SHA2(concat(UUID(),RAND(),NOW(6)),256),32)as salt_aleatorio;

/*2 lo que nunca se debe de hacer con contraseñas (solo para mostrar el riesgo)
si alguien roba la base de datos o un empledo curioso consulta la tabla veria clave de todos
insert into usuarios(...) Values(...,'Miclave123',...);--¡Mal!
*/

/*3 procedimientos almacenados de autnticacion 
-Centralizar la logica de seguridad en procedimientos la aplicacion nunca toca directamente el hash solo llama a estos procedimientos delimiter cambia el fin de la secuencia a// para poder usar ; dentro del procedimiento 
*/

drop procedure if exists sp_registrar_usuario;
drop procedure if exists sp_login_usuario;
drop procedure if exists sp_cambiar_password;

--3.1
DELIMITER //

CREATE PROCEDURE sp_registrar_usuario(
    IN p_nombre_usuario VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_password VARCHAR(100),
    IN p_rol VARCHAR(20),
    IN p_id_cliente INT
)
BEGIN
    DECLARE v_salt CHAR(32);

    IF CHAR_LENGTH(p_password) < 8
       OR CAST(p_password AS BINARY) = CAST(LOWER(p_password) AS BINARY)
       OR p_password NOT REGEXP '[0-9]' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La contraseña debe tener mínimo 8 caracteres, una mayúscula y un número';
    END IF;

    -- genera un salt aleatorio de 32 caracteres
    SET v_salt = LEFT(SHA2(CONCAT(UUID(), RAND(), NOW(6)), 256), 32);

    INSERT INTO usuarios (id_cliente, nombre_usuario, email, password_hash, salt, rol)
    VALUES (
        p_id_cliente,
        p_nombre_usuario,
        p_email,
        SHA2(CONCAT(v_salt, p_password), 256), -- se guarda el hash, no la clave
        v_salt,
        p_rol
    );
END//

--3.2
CREATE PROCEDURE sp_login(
    IN p_nombre_usuario VARCHAR(50),
    IN p_password VARCHAR(100),
    OUT p_resultado VARCHAR(100)
)
BEGIN
    DECLARE v_id INT DEFAULT NULL;
    DECLARE v_hash CHAR(64);
    DECLARE v_salt CHAR(32);
    DECLARE v_bloqueado BOOLEAN;
    DECLARE v_intentos INT;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_id = NULL;

    SELECT id_usuario, password_hash, salt, bloqueado, intentos_fallidos
    INTO v_id, v_hash, v_salt, v_bloqueado, v_intentos
    FROM usuarios
    WHERE nombre_usuario = p_nombre_usuario AND activo = TRUE;

    IF v_id IS NULL THEN
        -- mismo mensaje que clave incorrecta: no le decimos al atacante si el usuario existe
        SET p_resultado = 'Usuario o contraseña incorrectos';

    ELSEIF v_bloqueado THEN
        SET p_resultado = 'Usuario bloqueado. Contacte al administrador';

    ELSEIF v_hash = SHA2(CONCAT(v_salt, p_password), 256) THEN
        UPDATE usuarios
        SET intentos_fallidos = 0, ultimo_acceso = NOW()
        WHERE id_usuario = v_id;
        SET p_resultado = 'Acceso concedido';

    ELSE
        UPDATE usuarios
        SET intentos_fallidos = v_intentos + 1,
            bloqueado = (v_intentos + 1 >= 3) -- al tercer intento se bloquea
        WHERE id_usuario = v_id;
        SET p_resultado = 'Usuario o contraseña incorrectos';
    END IF;
END//

DELIMITER ;


--3.3 cambiar contraseña: exige la clave actual y genera salt nuevo 
delimiter //

create procedure sp_cambia_password(
  in p_nombre_usuario varchar(50),
  in p_password_actual varchar(100),
  in p_password_nueva varchar (100),
  out p_resultado varchar(100)
) 
begin 
declare v_salt_nueva char(32);

if not exists(select 1 from usuario
    where nombre_usuario = p_nombre_usuario
    and password_hash  = SHA(Concat(salt, p_password_actual), 256)) then 
    set p_resultado = 'La contraseña actual no es correcta';

    ELSEIF char_length(p_password_nueva) < 8
    or cast(p_password_nueva as binary) = cast(lower(p_password nueva)as binary)
    or p_password_nueva not regexp '[0-9]' then 
    set p_resultado = 'La contraseña no cumple la politica';
    
    else 
    set v_salt_nuevo = left(SHA2(concat(UUID(),RAND(), NOW(6)),256), 32);
    update usuarios
       set salt = v_salt_nuevo, 
       password_hash = SHA2(concat(v_salt_nuevo, p_password_nueva),256)
     where nombre_usuario = p_nombre_usuario;
     set p_resultado = 'contraseña actualizada'
     end if;
end//

delimiter ;
-- lunes 9-11-26
CREATE TABLE IF NOT EXISTS auditoria_usuarios (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    accion VARCHAR(30) NOT NULL,
    detalle VARCHAR(255) NULL,
    usuario_bd VARCHAR(100) NOT NULL,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE = InnoDB;

DROP TRIGGER IF EXISTS trg_usuarios_auditoria;

DELIMITER //
CREATE TRIGGER trg_usuarios_auditoria
AFTER UPDATE ON usuarios
FOR EACH ROW
BEGIN
    IF NEW.password_hash <> OLD.password_hash THEN
        INSERT INTO auditoria_usuarios (id_usuario, accion, detalle, usuario_bd)
        VALUES (NEW.id_usuario, 'CAMBIO_PASSWORD', 'se cambio la contraseña', CURRENT_USER());
    END IF;

    IF NEW.bloqueado = TRUE AND OLD.bloqueado = FALSE THEN
        INSERT INTO auditoria_usuarios (id_usuario, accion, detalle, usuario_bd)
        VALUES (NEW.id_usuario, 'bloqueo', 'bloqueado por 3 intentos fallidos', CURRENT_USER());
    END IF;
END //
DELIMITER ;

-- Registro de usuarios y pruebas (Clase 3)
CALL sp_registrar_usuario('admin', 'admin@tienda.com', 'Admin*2026Seguro', 'ADMIN', NULL);
CALL sp_registrar_usuario('vendedor', 'ventas@tienda.com', 'Ventas#2026', 'VENDEDOR', NULL);
CALL sp_registrar_usuario('ana.gomez', 'ana.gomez@tienda.com', 'AnaGomez2026', 'CLIENTE', 1);
CALL sp_registrar_usuario('carlos.perez', 'carlos.perez@tienda.com', 'CarlosPerez2026', 'CLIENTE', 2);

select id_usuarios, nombre_usuario, rol,salt, password_hash
from usuarios;

CALL sp_login('ana.gomez', 'AnaGomez2026', @resultado);

CALL sp_login('carlos.perez', 'clave_maala', @r1);
CALL sp_login('carlos.perez', 'clave_maala', @r2);
CALL sp_login('carlos.perez', 'clave_maala', @r3);
CALL sp_login('carlos.perez', 'Carlos2026!', @r4);

select @r1, @r2, @r3, @r4;

CALL sp_cambiar_password('ana.gomez', 'AnaGomez2026', 'NuevaClave2026', @r);
select @r as cambio_clave;

select nombre_usuario, intentos_fallidos, bloquedado from usuarios;

