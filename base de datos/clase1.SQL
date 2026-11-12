--DDL lenguaje de definicion de datos 
--son los q nos permite crear modificar eliminar y consultar la estructura de la base de, mas no los daros q se utilizan en ella 
--create crear la base
--alter modificar la estructura
--drop eliminar la base o tablas 
-- truncate vaciar una base de datos y reiniciar el contador de auto incremento
--remane renombrar tablas o base

comandos MySQL
DROP DATABASE IF EXISTS tienda_adso;---Eliminar base de datos existente 
CREATE DATABASE tienda_adso
CHARACTER SET utf8mb4  --- caracteres especiales 
collate utf8mb4_unicode_ci;--- caracteres especiales


use tienda_adso--- utilizar base de datos creada 
CREATE TABLE categorias(
    id_categoria INT NOT null AUTO_INCREMENT,
    nombre varchar(50) not Null,
    descripcion varchar(255)null,
    CONSTRAINT pk_categorias PRIMARY KEY (id_categoria),
    CONSTRAINT uq_categorias_nombre UNIQUE (nombre) )




CREATE TABLE Productos (
    id_producto INT NOT NULL AUTO_INCREMENT,
    id_categoria INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL (12,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_productos PRIMARY KEY (id_producto),
    CONSTRAINT ck_productos_precio CHECK (precio>0),
    CONSTRAINT ck_productos_stock CHECK (stock>0),
    
    CONSTRAINT fk_productos_categorias FOREIGN KEY (id_categoria)
    REFERENCES categorias (id_categoria)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
    )ENGINE = INNODB;



CREATE TABLE clientes (
    id_clientes int not null AUTO_INCREMENT,
    nombre varchar (50) not null, 
    apellido varchar (50) not null,
    tipo_documento varchar(50) NOT null DEFAULT 'CC', 
    numero_documento varchar(20) NOT null, 
    email varchar(30) not null,
    telefono varchar(20) null,
    ciudad varchar(30)NOT null,
    
    fecha_de_registro datetime not null DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_clientes PRIMARY KEY (id_cliente),
  	CONSTRAINT uq_clientes_email UNIQUE(email),
    CONSTRAINT uq_clientes_documento UNIQUE(numero_documento),
	CONSTRAINT ck_clientes_tipo_doc CHECK(tipo_documento in ('CC', 'TI', 'CE', 'PASS'))
    ) ENGINE = InnoDB;

CREATE TABLE pedidos (
    id_pedido int not null AUTO_INCREMENT,
   	id_cliente int not null, 
    fecha_pedido datetime not null DEFAULT CURRENT_TIMESTAMP,
    estado varchar (200) not null DEFAULT 'Pendiente',
    total varchar(60) NOT null default 0 , 
  
    CONSTRAINT pk_pedido PRIMARY KEY (id_pedido),
  	CONSTRAINT ck_pedido_estado CHECK(estado in('Pendiente','Pagado', 'Enviado', 'Cancelado')),
   	CONSTRAINT ck_pedido_total CHECK (total > 0),
    CONSTRAINT fk_pedido_clientes FOREIGN KEY (id_clientes),
    REFERENCES clientes(id_cliente)
    on DELETE RESTRICT
    on UPDATE CASCADE
    ) ENGINE = InnoDB;

CREATE TABLE detalle_pedido (
    id_detalle int not null AUTO_INCREMENT,
   	id_pedido int not null,
    id_producto int not null,
    cantidad varchar (200) not null DEFAULT 0,
    precio_unitario decimal(12,2) NOT null, 
  
    CONSTRAINT pk_detalle PRIMARY KEY (id_detalle),
  	CONSTRAINT ck_detalle_cantidad CHECK(cantidad > 0),
   	CONSTRAINT ck_detalle_precio CHECK (precio_unitario > 0),
    CONSTRAINT uq_detalle_pedido_producto UNIQUE (id_pedido, id_producto),
    CONSTRAINT fk_detalle_pedidos FOREIGN KEY (id_pedido)
    REFERENCES pedidos(id_pedido)
    on DELETE CASCADE,
    CONSTRAINT fk_detalle_productos FOREIGN KEY (id_producto)
    REFERENCES productos(id_producto)
    on DELETE RESTRICT
    ) ENGINE = InnoDB;

CREATE TABLE usuarios(
    id_usuario int not null AUTO_INCREMENT,
    id_cliente int null,
    nombre_usuario varchar(50),
    email varchar (100),
    password_dash char(64) not null, 
    salt char(32) not null,---misma contraseña cambia encriptacion
    rol varchar(20) not null DEFAULT 'cliente',
    activo boolean not null DEFAULT true,
    intentos_fallidos int not null DEFAULT 0,
    bloqueado boolean not null DEFAULT false,
    ultimo_acceso datetime null,
    fecha_creacion datetime not null DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT pk_usuarios PRIMARY KEY (id_usuario),
    CONSTRAINT uq_usuarios_nombre UNIQUE (nombre_usuario),
    CONSTRAINT uq_usuarios_email UNIQUE(email),
    CONSTRAINT ck_usuarios_rol CHECK (rol IN ('admin', 'vendedor','cliente')),
    CONSTRAINT fk_usuarios_clientes FOREIGN KEY (id_cliente)
    REFERENCES clientes (id_cliente)
    on DELETE SET null
    )ENGINE = INNODB;

show TABLEs;---ver tablas
DESCRIBE productos;---DESCRIBE LA TABLA 

show CREATE TABLE productos;--- ver script de tabla

SELECT TABLE_NAME, Constraint_name, Constraint_type --- diccionario de datos
FROM information_schema.table_constraints
WHERE TABLE_schema = 'tienda_adso' 
ORDER by TABLE_NAME, CONSTRAINT_type;

---agregar columna a una tabla existente---
alter TABLE clientes 
ADD COLUMN fecha_nacimiento date null after apellidos;

---cambiar el tipo / tamaño de una columna ---
alter table clientes 
modify columna telefono varchar(50) null;

---renombrar una columna change columna pide nombre viejo y nombre nuevo y la definición de la columna completa---

alter table clientes 
change columna ciudad ciudad_residencia varchar(50) not null;

---eliminar una columna de una tabla---

alter table clientes
drop column fecha_nacimiento;

--agregar descripción a una tabla--
alter table productos
add constraint uq_productos_nombre unique (nombre);

---eliminar restricción de una tabla existente---
alter table productos 
drop  index uq_productos_nombre;

--crear índices para búsquedas mas rápidas--
CREATE index idx_productos_nombre on productos(nombre);
CREATE index idx_productos_pedidos on pedidos(fecha_pedido);
CREATE index idx_clientes_apellidos on clientes(apellidos, nombres);--índice compuesto por dos columnas

show index from productos;

---insertar datos en la tabla practica---
insert into  tabla_practica (detalle_producto) values ("fila1"),("fila1");

---borrar todas las filas de golpe y reinicia el auto increment---
truncate table tabla_practica;

--cambiar el nombre de una tabla
RENAME table tabla_practica to tabla_borrar

--eliminar tabla
drop table table_borrar;

--reiniciar auto incremento de una tabla
ALTER TABLE pedidos AUTO_INCREMENT = 1;

13/10/2026

-CREATE TABLE proveedores (
    id_proveedor int NOT null AUTO_INCREMENT,
    nit varchar (100) not null,
    razon_social varchar(200) not null, 
    telefono varchar(10) not null,
    email varchar(30) not null,
    ciudad varchar(30) not null,
    activo boolean not null DEFAULT true,
    
    CONSTRAINT pk_proveedor PRIMARY KEY (id_proveedor),
    CONSTRAINT uq_proveedor_nit UNIQUE (nit),
    CONSTRAINT uq_proveedor_telefono UNIQUE (telefono),
    CONSTRAINT uq_proveedor_email unique (email)
    )ENGINE = INNODB;

-alter table productos 
add id_proveedor int,
add constraint fk_productos_proveedor foreing key(id_proveedor);

CREATE table direcciones_envio(
id_direccion int not null auto-increment,
id_cliente int,
dirección varchar(30) not null,
ciudad varchar(30) not null,
barrio varchar(30) not null,
es_principal boolean default false,

constraint pk_direccion primary key(id_direccion),
constraint fk_direcciones_envio_cliente foreign key(id_cliente)
on delete cascade
)engine = innoDB;
  
alter table productos 
add constraint ck_productos_precio_max check (precio <=50000000)

CREATE index idx_clientes_ciudad on clientes(ciudad);

CREATE table prueba(
id_prueba int not null auto_increment,
descripción varchar(60) not null,
constraint pk_pruebas primary key (id_prueba)
)engine = innodb;

RENAME table prueba to pruebas_old;
 
drop table pruebas_old;

show tables;

on delete cascade