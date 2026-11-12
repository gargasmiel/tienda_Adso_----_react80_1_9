-- Punto 1: Insertar proveedores y asignarlos a productos según su categoría

insert into proveedores (nit, razon_social, telefono, email, ciudad, activo)
values (900.123.456-1, 'Nexsys Colombia S.A.S.', '(601) 743-2000', 'contacto@nexsysla.com', 'Bogotá', 1),
       (901.654.321-6, 'DonBodegón Mayorista S.A.S.', '(604) 511-3344', 'comercial@donbodegon.com', 'Medellín', 1),
       (900.554.433-9, 'Distri Universal Ltda.', '(607) 630-7788', 'contacto@distriuniversal.com.co', 'Bucaramanga', 1);

--proveedor de tecnologia
update productos
set id_proveedor = '1'
where id_categoria = (select id_categoria from categorias where nombre = 'Tecnologia');

--proveedor de hogar

update productos
set id_proveedor = '2'
where id_categoria = (select id_categoria from categorias where nombre = 'Hogar');

--proveedor de papeleria

update productos
set id_proveedor = '3'
where id_categoria = (select id_categoria from categorias where nombre = 'Papeleria');

select * from proveedores;

--Punto 2: en listar todos los productos con su categoria y el nombre del proveedor hasta los q no tiene proveedor

select c.nombre as categoria, pr.nombre as producto, pv.razon_social as proveedor 
from productos pr 
right join categorias c on c.id_categoria = pr.id_categoria
left join proveedores pv on pv.id_proveedor = pr.id_proveedor
order by c.nombre; 

--punto 3: mostrar total vendido por ciudad del cliente  sin cancelado mayor a menor 

    SELECT CONCAT(cl.ciudad) AS ciudad,
       COUNT(pe.id_pedido) AS numero_pedidos,
       SUM(pe.total) AS total_vendido,
       pe.estado as estado 
FROM clientes cl
INNER JOIN pedidos pe ON pe.id_cliente = cl.id_cliente
WHERE pe.estado <> 'Cancelado'
GROUP BY cl.id_cliente, cl.ciudad
ORDER BY total_vendido DESC;

--punto 4: cual es el producto mas vendido usar limit

SELECT pr.nombre, SUM(d.cantidad) AS producto_mas_vendido
FROM detalle_pedido d
INNER JOIN productos pr ON pr.id_producto = d.id_producto
INNER JOIN pedidos pe ON pe.id_pedido = d.id_pedido
WHERE pe.estado <> 'Cancelado'
GROUP BY pr.id_producto, pr.nombre
ORDER BY producto_mas_vendido DESC
limit 1;


--punto 5: listar a los clientes cuyo total comprado es mayor al promedio de compra de los clientes

 SELECT cl.id_cliente as id_cliente,
        CONCAT(cl.nombre, ' ', cl.apellido) AS cliente,
        SUM(pe.total) AS total_comprado
    FROM clientes cl
    INNER JOIN pedidos pe ON pe.id_cliente = cl.id_cliente
    WHERE pe.estado <> 'Cancelado'
    GROUP BY cl.id_cliente, cl.nombre, cl.apellido
    HAVING SUM(pe.total) < (SELECT AVG(total_comprado) 
    FROM (SELECT SUM(total) AS total_comprado 
    FROM pedidos 
    WHERE estado <> 'Cancelado' 
    GROUP BY id_cliente) AS promedio);


--punto 6: listar categorias que no tienen productos

SELECT c.*
FROM categorias c
WHERE NOT EXISTS (
    SELECT 1
    FROM productos p
    INNER JOIN detalle_pedido d ON d.id_producto = p.id_producto
    WHERE p.id_categoria = c.id_categoria
);

--punto 7: subir el precio de los productos de la categoria papeleria en un 10% y mostrar los productos de esa categoria con su nuevo precio, luego hacer rollback para que no se afecte la base de datos
start transaction;
update productos
set precio = round(precio * 1.10,0)
where id_categoria = (select id_categoria
from categorias where nombre = "papeleria" );

select nombre, precio from productos where id_categoria = 3;

rollback;

select id_producto, nombre, precio from productos where id_categoria = 3;

--punto 8: eliminar los pedidos que esten cancelados y verificar que su detalle tambien se elimino(on delete cascade)

delete from pedidos where estado = 'cancelado';

select * from pedidos where estado = 'cancelado';

SELECT d.* 
FROM detalle_pedido d
JOIN pedidos p ON d.id_pedido = p.id_pedido
WHERE p.estado = 'cancelado';