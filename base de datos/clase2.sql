/*
 crear, consultar, modificar, eliminar
 realizar consultas con select con filtros orden y limites 
 joins(inner, left, right, full emulado)
 agragaciones count, sum, avs, min, max, group by having subconsultas
 insertar datos de prueba y verificar que existen 
 DML = lenguaje manipulacion de datos*/

 /*insertar datos de prueba (crud - c = crear)
 si se insertan datos en una tabla se debe tener
 en cuenta el orden de los campos, el tipo de campos y la llave foranea*/

 insert into categorias (nombre, descripcion) values ('tecnologia','computadores, perifericos, accesorios');

 INSERT INTO `categorias`(`nombre`, `descripcion`) 
 VALUES ( 'hogar','electrodomesticos y articulos para el hogar');

 INSERT INTO `categorias`(`nombre`, `descripcion`) 
 VALUES ( 'papeleria', 'utiles escolares y oficina');

 INSERT INTO `categorias`(`nombre`, `descripcion`) 
 VALUES ( ' deportes' ,  'implementos deportivos');

 INSERT INTO `categorias`(`nombre`, `descripcion`) 
 VALUES ( 'juguetes', 'categoria nueva, aun sin productos');


 /* insertar datos en una tabla con relacion*/

 insert into productos(id_categoria, nombre, precio, stock) 
 values (1,'portatil lenovo Ideapad', 2500000, 15),
        (1,'Mouse inalambrico',45000, 120),
        (1,'Teclado mecanico',180000, 40),
        (1,'Monitor 24 pulgadas', 650000, 25),
        (2,'Licuadora Oster', 220000, 30),
        (2,'Juego de ollas', 310000, 18),
        (2,'Lampara led',60000 , 75),
        (3,'Cuaderno 100 hojas', 8500, 500),
        (3,'Resma de papel carta', 22000, 200),
        (3,'Kit marcadores', 15000, 150),
        (4,'Balon de futbol ', 85000, 60),
        (4,'Bicicleta estatica', 1200000, 5);


        INSERT into clientes (tipo_documento, numero_documento,nombre, apellido, email, telefono, ciudad)
        values ('CC', '1001001001', 'Ana Maria', 'Gomez Ruiz', 'ana.gomez@correo.com', '3001112233', 'Medellin'),
                ('CC', '1002002002', 'Carlos Andres', 'Perez Diaz', 'carlos.perez@correo.com', '3002223344', 'Bogota'),
                ('CC', '1003003003', 'Luisa Fernanda', 'Martinez Rios', 'luisa.martinez@correo.com', '3003334455', 'Cali'),
                ('CC', '1004004004', 'Juan David', 'Restrepo Toro', 'juan.restrepo@correo.com', '3004445566', 'Medellin'),
                ('CC', '1005005005', 'Valentina', 'Hernandez Lopez', 'valentina.hernandez@correo.com', '3005556677', 'Barranquilla'),
                ('CC', '1006006006', 'Santiago', 'Ramirez Castro', 'santiago.ramirez@correo.com', '3006667788', 'Bogota'),
                ('CC', '1007007007', 'Daniela', 'Ospina Vargas', 'daniela.ospina@correo.com', '3007778899', 'Medellin'),
                ('CC', '1008008008', 'Mateo', 'Londoño Giraldo', 'mateo.londoño@correo.com', null, 'Pereira');

                /*pedido vamos a realizar pedidos de prueba con 2 relaciones, clientes y productos*/


INSERT INTO pedidos (id_cliente, fecha_pedido, estado, total) VALUES 
    (1, '2026-08-01 10:15:00', 'Pagado', 2590000),
    (2, '2026-08-03 14:30:00', 'Enviado', 1345000),
    (1, '2026-08-02 09:00:00', 'Enviado', 175000),
    (3, '2026-08-02 16:45:00', 'Pagado', 340000),
    (4, '2026-08-03 11:20:00', 'Cancelado', 8500),
    (5, '2026-08-03 08:10:00', 'Pendiente', 400000),
    (6, '2026-08-04 19:00:00', 'Pagado', 3195000),
    (2, '2026-08-04 12:00:00', 'Pagado', 245000),
    (7, '2026-08-01 17:30:00', 'Enviado', 420000),
    (3, '2026-08-01 10:05:00', 'Pendiente',5660000);

/*ajuste de tabla pedidos*/

alter table pedidos modify column total decimal(12,2) not null default 0;
alter table pedidos drop constraint if exists ck_pedido_total;
alter table pedidos add constraint ck_pedido_total check (total >= 0);

insert into detalle_pedido(id_pedido, id_producto, cantidad, precio_unitario) values
(1,1,1,2500000),(1,2,2,45000),
(2,4,2,650000),(2,3,1,45000),
(3,8,10,8500),(3,9,5,22000),
(4,5,1,220000),(4,7,2,60000),
(5,11,1,85000),
(6,6,1,310000),(6,2,2,45000),
(7,1,1,2500000),(7,4,1,650000),(7,2,1,45000),
(8,10,5,15000),(8,8,20,8500),
(9,3,2,1800000),
(10,11,2,250000),(10,9,3,22000);

--like: % = cualquier cantidad de caracteres, exactamente 

select nombre, apellido, email from clientes where apellido like 'R%';

--is null/ is not null: se considera el valor nulo de las comparacioneses
select nombre, apellido from clientes where telefono is null;



--order by ordena los resultados de una consulta de manera ascendente o descendente, por defecto es ascendente
 select nombre, precio, from productos 
 order by precio desc;
 limit 3;

 --distinct: elimina los registros duplicados de una consulta
 select distinct ciudad from clientes 
 order by ciudad;

--colimnas calculada y funcion de texto 
select concat(nombre,'', apellido) as cliente_completo, 
upper(ciudad)as ciudad_mayuscula,
char_length(email) as longitud_email
from clientes;

--case: logica condicional dentro de una consulta 

select nombre, stock,
case
when stock < 20 then 'Bajo'
when stock < 100 then 'Medio'
else 'Alto'
end as nivel_stock
from productos;

/*joins consulta entre varias tablas 
inner join: devuelve los registros que tienen coincidencias en ambas tablas
right join: devuelve todas las filas de la tabla derecha y los registros coincidentes de la tabla izquierda
left join: devuelve todas las filas de la tabla izquierda y los registros coincidentes de la tabla
full join: devuelve todas las filas cuando hay una coincidencia en una de las tablas(emulado con union)
se usan alias cortos para no reperitir el nombre de las tablas en las consultas*/

--inner join productos con el mismo nombre de categoria

select p.nombre as producton , c.nombre as categoria, p.precio
from productos p
inner join categorias c on p.id_categoria = c.id_categoria
order by c.nombre, p.nombre;

--inner join pedidos con el mismo nombre de clientes mio

select c.nombre as clientes, p.estado as pedidos
 from clientes c
 inner join pedidos p on c.id_cliente = p.id_pedido 
 order by c.nombre , p.estado;

 --inner join pedidos con el mismo nombre de clientes profe

 select pe.id_pedido ,pe.fecha_pedido, pe.estado, pe.total,
        concat(cl.nombre,'', cl.apellido) as clientes 
        from pedidos pe
        inner join clientes cl on cl.id_cliente = pe.id_cliente 
        order by pe.fecha_pedido;

--factura detallada de un pedido con inner join entre 4 tablas

select pe.id_pedido,
concat(cl.nombre,'', cl.apellido) as clientes,
pr.nombre as productos,
d.cantidad,
d.precio_unitario,
d.cantidad * d.precio_unitario as subtotal
from pedidos pe
inner join clientes cl on cl.id_cliente = pe.id_cliente 
inner join detalle_pedido d on d.id_pedido = pe.id_pedido
inner join productos pr on pr.id_producto = d.id_producto
order by pe.id_pedido, pr.nombre;

--left join todo los clientes que tengan o no pedidos

select cl.nombre, cl.apellido, pe.id_pedido, pe.total
from clientes cl 
left join pedidos pe on pe.id_cliente = cl.id_cliente
order by cl.id_cliente;

--left join + is null productos q nunca se han enviado 
select pr.nombre, pr.stock
from productos pr 
left join detalle_pedido d on d.id_producto = pr.id_producto 
where d.id_detalle in null;

--right join todas las categorias aunque no tengan productos 
select c.nombre as categoria, pr.nombre as producto
from productos pr 
right join categorias c on c.id_categoria = pr.id_categoria
order by c.nombre; 

--full outer join emulado es decir une (left join y right join)

select c.nombre as categoria, pr.nombre as producto 
from categorias c left join productos pr on pr.id_categoria = c.id_categoria 
union 
select c.nombre, p.nombre 
from categorias c right join productos pr on pr.id_categoria = c.id_categoria
order by categoria, producto;



/*
COUNT()	Cuenta el número de filas o valores no nulos.	Cualquier tipo
SUM()	Suma todos los valores de la columna.	Numérico
AVG()	Calcula el promedio (media aritmética).	Numérico
MIN()	Devuelve el valor más bajo.	Números, fechas y texto
MAX()	Devuelve el valor más alto.	Números, fechas y texto

*/
-- 5.1 Resumen general de productos

SELECT COUNT(*) AS total_productos,
       SUM(stock) AS unidades_en_bodega,
       ROUND(AVG(precio), 2) AS precio_promedio,
       MIN(precio) AS precio_minimo,
       MAX(precio) AS precio_maximo
FROM productos;


-- 5.2 Cantidad de productos y valor del inventario por categoría

SELECT c.nombre AS categoria,
       COUNT(pr.id_producto) AS cantidad_productos,
       SUM(pr.precio * pr.stock) AS valor_inventario
FROM categorias c
LEFT JOIN productos pr ON pr.id_categoria = c.id_categoria
GROUP BY c.nombre
ORDER BY valor_inventario DESC;


-- 5.3 Total comprado por cliente (sin pedidos cancelados)
SELECT CONCAT(cl.nombre, ' ', cl.apellido) AS cliente,
       COUNT(pe.id_pedido) AS numero_pedidos,
       SUM(pe.total) AS total_comprado
FROM clientes cl
INNER JOIN pedidos pe ON pe.id_cliente = cl.id_cliente
WHERE pe.estado <> 'Cancelado'
GROUP BY cl.id_cliente, cl.nombre, cl.apellido
ORDER BY total_comprado DESC;


-- 5.4 HAVING: clientes que han comprado más de 1.000.000

SELECT CONCAT(cl.nombre, ' ', cl.apellido) AS cliente,
       SUM(pe.total) AS total_comprado
FROM clientes cl
INNER JOIN pedidos pe ON pe.id_cliente = cl.id_cliente
WHERE pe.estado <> 'Cancelado'
GROUP BY cl.id_cliente, cl.nombre, cl.apellido
HAVING SUM(pe.total) > 1000000;

-- 5.5 Ventas por mes

SELECT DATE_FORMAT(fecha_pedido, '%Y-%m') AS mes,
       COUNT(*) AS pedidos,
       SUM(total) AS ventas
FROM pedidos
WHERE estado <> 'Cancelado'
GROUP BY DATE_FORMAT(fecha_pedido, '%Y-%m')
ORDER BY mes;


-- 5.6 Unidades vendidas por producto

SELECT pr.nombre, SUM(d.cantidad) AS unidades_vendidas
FROM detalle_pedido d
INNER JOIN productos pr ON pr.id_producto = d.id_producto
INNER JOIN pedidos pe ON pe.id_pedido = d.id_pedido
WHERE pe.estado <> 'Cancelado'
GROUP BY pr.id_producto, pr.nombre
ORDER BY unidades_vendidas DESC;


-- 5.7 Pedidos por estado

SELECT estado, COUNT(*) AS cantidad, SUM(total) AS valor
FROM pedidos
GROUP BY estado;

/*subconsultas una consulta dentro de otra */

--subconsultas en where (valor unico) productos mas caros que el promedio 

select nombre, precio 
from productos 
where precio > (select avg(precio)from productos);

--subconsulyas con in (lista) clientes que han hecho al menos in pedido 

select nombre, apellido
from clientes 
where id_cliente in (select id_cliente from pedidos);


--nor exists: categoria que no tiene productos 
select c.nombre
from categorias c
where not exists(select 1 from productos p where p.id_categoria = c.id_categoria);

---subconsulta escalar en select: numero de pedidos de cada cliente 

select cl.nombre , cl.apellido,
(select count(*) from pedidos pe where pe.id_cliente = cl.id_cliente) as cantidad_pedidos
from clientes cl;

--subconsulta en from (tabla derivada) promedio compra cliente

select round(avg(t.total_cliente), 2) AS promedio_compra_por_cliente
FROM(SELECT id_cliente, sum(total) as total_cliente
from pedidos
where estado <> 'Cancelado'
group by id_cliente) as t;
--en mysql una tabla derivada necesita un alias en este caso "t" y no se puede usar el alias en la misma consultapor eso se hace una subconsulta en from
 
--subconsulta  correlacionada productos mas caros que el promedio de su categoria 

select pr.nombre, pr.precio, pr.id_categoria
from productos pr
where pr.precio >(select avg(pr2.precio)
from productos pr2
where pr2.id_categoria = pr.id_categoria);

--subconsulta el pedido de mayor valor con max 

select id_pedido, id_cliente, total
from pedidos
where total =(select max(total)from pedidos);



/* CRUD completo + transacciones
una transaccion agrupa varias sentencias en una sola unidad o se guardan TODAS en un commit o no se guarda ninguna en rollback
propiedades: ACID: atomicidad, consistencia, aislamiento, durabilidad*/

--C=create registrar un cliente nuevo

insert into clientes (tipo_documento, numero_documento, nombre, apellido, email, telefono, ciudad)
values('CC','1009009009', 'Sofia', 'Cardona Mejia','sofia.cardona@correo.com', '3109990000', 'Manizales');

--R = read consultarlo 

select * from clientes where numero_documento = '1009009009';

--U = update modificar un cliente existente

update cliente 
set telefono = '3201234567', 
ciudad = 'Armenia'
where numero_documento ='1009009009';

--D delete eliminar siempre con where por que sin where elimina toda la tabla 

delete from clientes where numero_documento = '1009009009';

--transacciones : conn rollback simulamos una venta y nos arrepentimos de la venta y no se guarda nada en la base de datos 

start transaction;
insert into pedidos (id_cliente, estado)
values (8,'Pendiente');
set @nuevo_pedido_id = LAST_INSERT_ID();--ID generado por el ultimo insert

insert into detalle_pedido(id_pedido, id_producto,
cantidad, precio_unitario)
values(@nuevo_pedido_id,12,1,120000);

update productos set stock = stock -1 where id_producto = 12;

select * from pedidos where id_pedido = @nuevo_pedido_id; --dento de la transaccion se puede consultar lo que se ha hecho pero no se ve desde fuera

rollback;--deshacer la transaccion y no se guarda nada en la base de datos 

select * from pedidos where id_pedido = @nuevo_pedido_id; --ya no existe

select * from productos where id_producto = 12;--el stock debe de seguir en 5

--tansaccion con commit: subir el 5% del precio de deportes 
start transaction;
update productos
set precio = Round(precio * 1.05, 0 )
where id_categoria = (select id_categoria
from categorias where nombre = 'Deportes');
commit;

--confirma el cambio de forma permanente
select nombre, precio from productos where id_categoria = 4;

--Delete en cascada: al borrar un pedido se borran sus detalles 

insert into pedidos (id_cliente, estado)
values (8, 'Pendiente');
set @pedido_tem = LAST_INSERT_ID();
insert into detalle_pedido(id_pedido, id_producto, cantidad, precio_unitario)
values (@pedido_tem, 2, 1, 45000);

select count(*) as detalle_antes from detalle_pedido
where id_pedido = @pedido_tem; --1
delete from pedidos where id_pedido = @pedido_tem;
select count(*) as detalles_despues from detalle_pedido where id_pedido = @pedido_tem;--0

on delete cascade