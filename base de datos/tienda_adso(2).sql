-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 15-10-2026 a las 00:03:33
-- Versión del servidor: 10.4.28-MariaDB
-- Versión de PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `tienda_adso`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `id_categoria` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` (`id_categoria`, `nombre`, `descripcion`) VALUES
(1, 'tecnologia', 'computadores, perifericos, accesorios'),
(2, 'hogar', 'electrodomesticos y articulos para el hogar'),
(3, 'papeleria', 'utiles escolares y oficina'),
(4, ' deportes', 'implementos deportivos'),
(5, 'juguetes', 'categoria nueva, aun sin productos');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `id_cliente` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `apellido` varchar(50) NOT NULL,
  `tipo_documento` varchar(50) NOT NULL DEFAULT 'CC',
  `numero_documento` varchar(20) NOT NULL,
  `email` varchar(30) NOT NULL,
  `telefono` varchar(50) DEFAULT NULL,
  `ciudad` varchar(50) NOT NULL,
  `fecha_de_registro` datetime NOT NULL DEFAULT current_timestamp()
) ;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id_cliente`, `nombre`, `apellido`, `tipo_documento`, `numero_documento`, `email`, `telefono`, `ciudad`, `fecha_de_registro`) VALUES
(17, 'Ana Maria', 'Gomez Ruiz', 'CC', '1001001001', 'ana.gomez@correo.com', '3001112233', 'Medellin', '2026-10-14 17:03:07'),
(18, 'Carlos Andres', 'Perez Diaz', 'CC', '1002002002', 'carlos.perez@correo.com', '3002223344', 'Bogota', '2026-10-14 17:03:07'),
(19, 'Luisa Fernanda', 'Martinez Rios', 'CC', '1003003003', 'luisa.martinez@correo.com', '3003334455', 'Cali', '2026-10-14 17:03:07'),
(20, 'Juan David', 'Restrepo Toro', 'CC', '1004004004', 'juan.restrepo@correo.com', '3004445566', 'Medellin', '2026-10-14 17:03:07'),
(21, 'Valentina', 'Hernandez Lopez', 'CC', '1005005005', 'valentina.hernandez@correo.com', '3005556677', 'Barranquilla', '2026-10-14 17:03:07'),
(22, 'Santiago', 'Ramirez Castro', 'CC', '1006006006', 'santiago.ramirez@correo.com', '3006667788', 'Bogota', '2026-10-14 17:03:07'),
(23, 'Daniela', 'Ospina Vargas', 'CC', '1007007007', 'daniela.ospina@correo.com', '3007778899', 'Medellin', '2026-10-14 17:03:07'),
(24, 'Mateo', 'Londoño Giraldo', 'CC', '1008008008', 'mateo.londoño@correo.com', NULL, 'Pereira', '2026-10-14 17:03:07');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_pedido`
--

CREATE TABLE `detalle_pedido` (
  `id_detalle` int(11) NOT NULL,
  `id_pedido` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `cantidad` varchar(200) NOT NULL DEFAULT '0',
  `precio_unitario` decimal(12,2) NOT NULL
) ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `dirreciones_envio`
--

CREATE TABLE `dirreciones_envio` (
  `id_direccion` int(11) NOT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `direccion` varchar(30) NOT NULL,
  `barrio` varchar(30) NOT NULL,
  `ciudad` varchar(30) NOT NULL,
  `es_principal` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedidos`
--

CREATE TABLE `pedidos` (
  `id_pedido` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `fecha_pedido` datetime NOT NULL DEFAULT current_timestamp(),
  `estado` varchar(20) NOT NULL DEFAULT 'Pendiente',
  `total` varchar(60) NOT NULL DEFAULT '0'
) ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id_producto` int(11) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `id_proveedor` int(11) DEFAULT NULL,
  `nombre` varchar(100) NOT NULL,
  `precio` decimal(12,2) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT 0,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `fecha_registro` datetime NOT NULL DEFAULT current_timestamp()
) ;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id_producto`, `id_categoria`, `id_proveedor`, `nombre`, `precio`, `stock`, `activo`, `fecha_registro`) VALUES
(1, 1, NULL, 'portatil lenovo Ideapad', 2500000.00, 15, 1, '2026-10-14 15:37:37'),
(2, 1, NULL, 'Mouse inalambrico', 45000.00, 120, 1, '2026-10-14 15:37:37'),
(3, 1, NULL, 'Teclado mecanico', 180000.00, 40, 1, '2026-10-14 15:37:37'),
(4, 1, NULL, 'Monitor 24 pulgadas', 650000.00, 25, 1, '2026-10-14 15:37:37'),
(5, 2, NULL, 'Licuadora Oster', 220000.00, 30, 1, '2026-10-14 15:37:37'),
(6, 2, NULL, 'Juego de ollas', 310000.00, 18, 1, '2026-10-14 15:37:37'),
(7, 2, NULL, 'Lampara led', 60000.00, 75, 1, '2026-10-14 15:37:37'),
(8, 3, NULL, 'Cuaderno 100 hojas', 8500.00, 500, 1, '2026-10-14 15:37:37'),
(9, 3, NULL, 'Resma de papel carta', 22000.00, 200, 1, '2026-10-14 15:37:37'),
(10, 3, NULL, 'Kit marcadores', 15000.00, 150, 1, '2026-10-14 15:37:37'),
(11, 4, NULL, 'Balon de futbol ', 85000.00, 60, 1, '2026-10-14 15:37:37'),
(12, 4, NULL, 'Bicicleta estatica', 1200000.00, 5, 1, '2026-10-14 15:37:37');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedores`
--

CREATE TABLE `proveedores` (
  `id_proveedor` int(11) NOT NULL,
  `nit` varchar(100) NOT NULL,
  `razon_social` varchar(200) NOT NULL,
  `telefono` varchar(10) NOT NULL,
  `email` varchar(30) NOT NULL,
  `ciudad` varchar(30) NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `nombre_usuario` varchar(50) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password_dash` char(64) NOT NULL,
  `salt` char(32) NOT NULL,
  `rol` varchar(20) NOT NULL DEFAULT 'cliente',
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `intentos_fallidos` int(11) NOT NULL DEFAULT 0,
  `bloqueado` tinyint(1) NOT NULL DEFAULT 0,
  `ultimo_acceso` datetime DEFAULT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT current_timestamp()
) ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`id_categoria`),
  ADD UNIQUE KEY `uq_categorias_nombre` (`nombre`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id_cliente`),
  ADD UNIQUE KEY `uq_clientes_email` (`email`),
  ADD UNIQUE KEY `uq_clientes_documento` (`numero_documento`),
  ADD KEY `idx_clientes_ciudad` (`ciudad`);

--
-- Indices de la tabla `detalle_pedido`
--
ALTER TABLE `detalle_pedido`
  ADD PRIMARY KEY (`id_detalle`),
  ADD UNIQUE KEY `uq_detalle_pedido_producto` (`id_pedido`,`id_producto`),
  ADD KEY `fk_detalle_productos` (`id_producto`);

--
-- Indices de la tabla `dirreciones_envio`
--
ALTER TABLE `dirreciones_envio`
  ADD PRIMARY KEY (`id_direccion`),
  ADD KEY `fk_dirreciones_envio_clientes` (`id_cliente`);

--
-- Indices de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD PRIMARY KEY (`id_pedido`),
  ADD KEY `fk_pedidos_clientes` (`id_cliente`),
  ADD KEY `idx_productos_pedidos` (`fecha_pedido`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id_producto`),
  ADD KEY `fk_productos_categorias` (`id_categoria`),
  ADD KEY `idx_productos_nombre` (`nombre`),
  ADD KEY `fk_productos_proveedores` (`id_proveedor`);

--
-- Indices de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  ADD PRIMARY KEY (`id_proveedor`),
  ADD UNIQUE KEY `uq_proveedor_nit` (`nit`),
  ADD UNIQUE KEY `uq_proveedor_telefono` (`telefono`),
  ADD UNIQUE KEY `uq_proveedor_email` (`email`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `uq_usuarios_nombre` (`nombre_usuario`),
  ADD UNIQUE KEY `uq_usuarios_email` (`email`),
  ADD KEY `fk_usuarios_clientes` (`id_cliente`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id_categoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id_cliente` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detalle_pedido`
--
ALTER TABLE `detalle_pedido`
  MODIFY `id_detalle` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `dirreciones_envio`
--
ALTER TABLE `dirreciones_envio`
  MODIFY `id_direccion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  MODIFY `id_pedido` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id_producto` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  MODIFY `id_proveedor` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `detalle_pedido`
--
ALTER TABLE `detalle_pedido`
  ADD CONSTRAINT `fk_detalle_pedidos` FOREIGN KEY (`id_pedido`) REFERENCES `pedidos` (`id_pedido`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_detalle_productos` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`);

--
-- Filtros para la tabla `dirreciones_envio`
--
ALTER TABLE `dirreciones_envio`
  ADD CONSTRAINT `fk_dirreciones_envio_clientes` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`) ON DELETE CASCADE;

--
-- Filtros para la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD CONSTRAINT `fk_pedidos_clientes` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `productos`
--
ALTER TABLE `productos`
  ADD CONSTRAINT `fk_productos_categorias` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id_categoria`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_productos_proveedores` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedores` (`id_proveedor`) ON DELETE SET NULL;

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_usuarios_clientes` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
