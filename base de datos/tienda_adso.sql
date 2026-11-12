-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 12-11-2026 a las 17:29:36
-- Versión del servidor: 10.11.16-MariaDB
-- Versión de PHP: 8.3.36

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

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_cambiar_password` (IN `p_nombre_usuario` VARCHAR(50), IN `p_password_actual` VARCHAR(100), IN `p_password_nueva` VARCHAR(100), OUT `p_resultado` VARCHAR(100))   BEGIN
    DECLARE v_salt_nuevo CHAR(32);

    IF NOT EXISTS (SELECT 1 FROM usuarios
        WHERE nombre_usuario = p_nombre_usuario
        AND password_hash = SHA2(CONCAT(salt, p_password_actual), 256)) THEN
        SET p_resultado = 'la contraseña actual no es correcta';
    ELSEIF CHAR_LENGTH(p_password_nueva) < 8
        OR CAST(p_password_nueva AS BINARY) = CAST(LOWER(p_password_nueva) AS BINARY)
        OR p_password_nueva NOT REGEXP '[0-9]' THEN
        SET p_resultado = 'la nueva contraseña no cumple la politica';
    ELSE
        SET v_salt_nuevo = LEFT(SHA2(CONCAT(UUID(), RAND(), NOW(6)), 256), 32);
        UPDATE usuarios
        SET salt = v_salt_nuevo,
            password_hash = SHA2(CONCAT(v_salt_nuevo, p_password_nueva), 256)
        WHERE nombre_usuario = p_nombre_usuario;
        SET p_resultado = 'contraseña actualizada';
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_login` (IN `p_nombre_usuario` VARCHAR(50), IN `p_password` VARCHAR(100), OUT `p_resultado` VARCHAR(100))   BEGIN
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
        SET p_resultado = 'usuario o contraseña incorrectos';
    ELSEIF v_bloqueado THEN
        SET p_resultado = 'usuario bloqueado, conectate con el administrador';
    ELSEIF v_hash = SHA2(CONCAT(v_salt, p_password), 256) THEN
        UPDATE usuarios
        SET intentos_fallidos = 0, ultimo_acceso = NOW()
        WHERE id_usuario = v_id;
        SET p_resultado = 'acceso concedido';
    ELSE
        UPDATE usuarios
        SET intentos_fallidos = v_intentos + 1,
            bloqueado = (v_intentos + 1 >= 3)
        WHERE id_usuario = v_id;
        SET p_resultado = 'usuario o contraseña incorrectos';
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_usuario` (IN `p_nombre_usuario` VARCHAR(50), IN `p_email` VARCHAR(100), IN `p_password` VARCHAR(100), IN `p_rol` VARCHAR(20), IN `p_id_cliente` INT)   BEGIN
    DECLARE v_salt CHAR(32);

    IF CHAR_LENGTH(p_password) < 8
       OR CAST(p_password AS BINARY) = CAST(LOWER(p_password) AS BINARY)
       OR p_password NOT REGEXP '[0-9]' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La contraseña debe tener mínimo 8 caracteres, una mayúscula y un número';
    END IF;

    SET v_salt = LEFT(SHA2(CONCAT(UUID(), NOW(6)), 256), 32);

    INSERT INTO usuarios (id_cliente, nombre_usuario, email, password_hash, salt, rol)
    VALUES (p_id_cliente, p_nombre_usuario, p_email, SHA2(CONCAT(v_salt, p_password), 256), v_salt, p_rol);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auditoria_usuarios`
--

CREATE TABLE `auditoria_usuarios` (
  `id_auditoria` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `accion` varchar(30) NOT NULL,
  `detalle` varchar(255) DEFAULT NULL,
  `usuario_bd` varchar(100) NOT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `auditoria_usuarios`
--

INSERT INTO `auditoria_usuarios` (`id_auditoria`, `id_usuario`, `accion`, `detalle`, `usuario_bd`, `fecha`) VALUES
(1, 4, 'bloqueo', 'bloqueado por 3 intentos fallidos', 'root@localhost', '2026-11-10 14:23:28'),
(2, 3, 'CAMBIO_PASSWORD', 'se cambio la contraseña', 'root@localhost', '2026-11-10 14:23:28');

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
(1, 'Ana Maria', 'Gomez Ruiz', 'CC', '1001001001', 'ana.gomez@correo.com', '3001112233', 'Medellin', '2026-11-10 14:23:28'),
(2, 'Carlos Andres', 'Perez Diaz', 'CC', '1002002002', 'carlos.perez@correo.com', '3002223344', 'Bogota', '2026-11-10 14:23:28'),
(3, 'Luisa Fernanda', 'Martinez Rios', 'CC', '1003003003', 'luisa.martinez@correo.com', '3003334455', 'Cali', '2026-11-10 14:23:28'),
(4, 'Juan David', 'Restrepo Toro', 'CC', '1004004004', 'juan.restrepo@correo.com', '3004445566', 'Medellin', '2026-11-10 14:23:28'),
(5, 'Valentina', 'Hernandez Lopez', 'CC', '1005005005', 'valentina.hernandez@correo.com', '3005556677', 'Barranquilla', '2026-11-10 14:23:28'),
(6, 'Santiago', 'Ramirez Castro', 'CC', '1006006006', 'santiago.ramirez@correo.com', '3006667788', 'Bogota', '2026-11-10 14:23:28'),
(7, 'Daniela', 'Ospina Vargas', 'CC', '1007007007', 'daniela.ospina@correo.com', '3007778899', 'Medellin', '2026-11-10 14:23:28'),
(8, 'Mateo', 'Londoño Giraldo', 'CC', '1008008008', 'mateo.londoño@correo.com', NULL, 'Pereira', '2026-11-10 14:23:28');

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

--
-- Volcado de datos para la tabla `detalle_pedido`
--

INSERT INTO `detalle_pedido` (`id_detalle`, `id_pedido`, `id_producto`, `cantidad`, `precio_unitario`) VALUES
(1, 1, 1, '1', 2500000.00),
(2, 1, 2, '2', 45000.00),
(3, 2, 4, '2', 650000.00),
(4, 2, 3, '1', 45000.00),
(5, 3, 8, '10', 8500.00),
(6, 3, 9, '5', 22000.00),
(7, 4, 5, '1', 220000.00),
(8, 4, 7, '2', 60000.00),
(9, 5, 11, '1', 85000.00),
(10, 6, 6, '1', 310000.00),
(11, 6, 2, '2', 45000.00),
(12, 7, 1, '1', 2500000.00),
(13, 7, 4, '1', 650000.00),
(14, 7, 2, '1', 45000.00),
(15, 8, 10, '5', 15000.00),
(16, 8, 8, '20', 8500.00),
(17, 9, 3, '2', 1800000.00),
(18, 10, 11, '2', 250000.00),
(19, 10, 9, '3', 22000.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `direcciones_envio`
--

CREATE TABLE `direcciones_envio` (
  `id_direccion` int(11) NOT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `direccion` varchar(30) NOT NULL,
  `ciudad` varchar(30) NOT NULL,
  `barrio` varchar(30) NOT NULL,
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
  `total` decimal(12,2) NOT NULL DEFAULT 0.00
) ;

--
-- Volcado de datos para la tabla `pedidos`
--

INSERT INTO `pedidos` (`id_pedido`, `id_cliente`, `fecha_pedido`, `estado`, `total`) VALUES
(1, 1, '2026-08-01 10:15:00', 'Pagado', 2590000.00),
(2, 2, '2026-08-03 14:30:00', 'Enviado', 1345000.00),
(3, 1, '2026-08-02 09:00:00', 'Enviado', 175000.00),
(4, 3, '2026-08-02 16:45:00', 'Pagado', 340000.00),
(5, 4, '2026-08-03 11:20:00', 'Cancelado', 8500.00),
(6, 5, '2026-08-03 08:10:00', 'Pendiente', 400000.00),
(7, 6, '2026-08-04 19:00:00', 'Pagado', 3195000.00),
(8, 2, '2026-08-04 12:00:00', 'Pagado', 245000.00),
(9, 7, '2026-08-01 17:30:00', 'Enviado', 420000.00),
(10, 3, '2026-08-01 10:05:00', 'Pendiente', 5660000.00);

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
(1, 1, 1, 'portatil lenovo Ideapad', 2500000.00, 15, 1, '2026-11-10 14:23:28'),
(2, 1, 1, 'Mouse inalambrico', 45000.00, 120, 1, '2026-11-10 14:23:28'),
(3, 1, 1, 'Teclado mecanico', 180000.00, 40, 1, '2026-11-10 14:23:28'),
(4, 1, 1, 'Monitor 24 pulgadas', 650000.00, 25, 1, '2026-11-10 14:23:28'),
(5, 2, 2, 'Licuadora Oster', 220000.00, 30, 1, '2026-11-10 14:23:28'),
(6, 2, 2, 'Juego de ollas', 310000.00, 18, 1, '2026-11-10 14:23:28'),
(7, 2, 2, 'Lampara led', 60000.00, 75, 1, '2026-11-10 14:23:28'),
(8, 3, 3, 'Cuaderno 100 hojas', 8500.00, 500, 1, '2026-11-10 14:23:28'),
(9, 3, 3, 'Resma de papel carta', 22000.00, 200, 1, '2026-11-10 14:23:28'),
(10, 3, 3, 'Kit marcadores', 15000.00, 150, 1, '2026-11-10 14:23:28'),
(11, 4, NULL, 'Balon de futbol ', 85000.00, 60, 1, '2026-11-10 14:23:28'),
(12, 4, NULL, 'Bicicleta estatica', 1200000.00, 5, 1, '2026-11-10 14:23:28');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedores`
--

CREATE TABLE `proveedores` (
  `id_proveedor` int(11) NOT NULL,
  `nit` varchar(100) NOT NULL,
  `razon_social` varchar(200) NOT NULL,
  `telefono` varchar(20) NOT NULL,
  `email` varchar(50) NOT NULL,
  `ciudad` varchar(30) NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `proveedores`
--

INSERT INTO `proveedores` (`id_proveedor`, `nit`, `razon_social`, `telefono`, `email`, `ciudad`, `activo`) VALUES
(1, '900.123.456-1', 'Nexsys Colombia S.A.S.', '(601) 743-2000', 'contacto@nexsysla.com', 'Bogotá', 1),
(2, '901.654.321-6', 'DonBodegón Mayorista S.A.S.', '(604) 511-3344', 'comercial@donbodegon.com', 'Medellín', 1),
(3, '900.554.433-9', 'Distri Universal Ltda.', '(607) 630-7788', 'contacto@distriuniversal.com.co', 'Bucaramanga', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `nombre_usuario` varchar(50) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password_hash` char(64) NOT NULL,
  `salt` char(32) NOT NULL,
  `rol` varchar(20) NOT NULL DEFAULT 'cliente',
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `intentos_fallidos` int(11) NOT NULL DEFAULT 0,
  `bloqueado` tinyint(1) NOT NULL DEFAULT 0,
  `ultimo_acceso` datetime DEFAULT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT current_timestamp()
) ;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `id_cliente`, `nombre_usuario`, `email`, `password_hash`, `salt`, `rol`, `activo`, `intentos_fallidos`, `bloqueado`, `ultimo_acceso`, `fecha_creacion`) VALUES
(1, NULL, 'admin', 'admin@tienda.com', 'b539ded5c382a3ac4169e3e430bce6990adebc023f82d8af34f3975f1fb043d9', '0090f2a0c394d5fb46c884f6df7f83d2', 'ADMIN', 1, 0, 0, NULL, '2026-11-10 14:23:28'),
(2, NULL, 'vendedor', 'ventas@tienda.com', '56a547d6c53cc295c215503e9112606d4a3880555b0769459d0e3f7a8ab55773', 'e5088fee64c14b2458ffd3687d47639d', 'VENDEDOR', 1, 0, 0, NULL, '2026-11-10 14:23:28'),
(3, 1, 'ana.gomez', 'ana.gomez@tienda.com', 'a6a66b58967ea549f27b566d6340a22335e77771bbb24822fac3d5df5f63fb95', '1d6af391aa17c2d716dd6eee76098e86', 'CLIENTE', 1, 0, 0, '2026-11-10 14:23:28', '2026-11-10 14:23:28'),
(4, 2, 'carlos.perez', 'carlos.perez@tienda.com', '53c0dfe2727a908850b9fee8286422ae1fe6e582a1b5cdf0c42357005fdd897a', '9a6e4dacaba07e250bbf0d5398ff1e16', 'CLIENTE', 1, 3, 1, NULL, '2026-11-10 14:23:28');

--
-- Disparadores `usuarios`
--
DELIMITER $$
CREATE TRIGGER `trg_usuarios_auditoria` AFTER UPDATE ON `usuarios` FOR EACH ROW BEGIN
    IF NEW.password_hash <> OLD.password_hash THEN
        INSERT INTO auditoria_usuarios (id_usuario, accion, detalle, usuario_bd)
        VALUES (NEW.id_usuario, 'CAMBIO_PASSWORD', 'se cambio la contraseña', CURRENT_USER());
    END IF;

    IF NEW.bloqueado = TRUE AND OLD.bloqueado = FALSE THEN
        INSERT INTO auditoria_usuarios (id_usuario, accion, detalle, usuario_bd)
        VALUES (NEW.id_usuario, 'bloqueo', 'bloqueado por 3 intentos fallidos', CURRENT_USER());
    END IF;
END
$$
DELIMITER ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `auditoria_usuarios`
--
ALTER TABLE `auditoria_usuarios`
  ADD PRIMARY KEY (`id_auditoria`);

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
  ADD KEY `idx_clientes_apellidos` (`apellido`,`nombre`),
  ADD KEY `idx_clientes_ciudad` (`ciudad`);

--
-- Indices de la tabla `detalle_pedido`
--
ALTER TABLE `detalle_pedido`
  ADD PRIMARY KEY (`id_detalle`),
  ADD UNIQUE KEY `uq_detalle_pedido_producto` (`id_pedido`,`id_producto`),
  ADD KEY `fk_detalle_productos` (`id_producto`);

--
-- Indices de la tabla `direcciones_envio`
--
ALTER TABLE `direcciones_envio`
  ADD PRIMARY KEY (`id_direccion`),
  ADD KEY `fk_direcciones_envio_cliente` (`id_cliente`);

--
-- Indices de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD PRIMARY KEY (`id_pedido`),
  ADD KEY `fk_pedido_clientes` (`id_cliente`),
  ADD KEY `idx_productos_pedidos` (`fecha_pedido`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id_producto`),
  ADD KEY `fk_productos_categorias` (`id_categoria`),
  ADD KEY `fk_productos_proveedores` (`id_proveedor`),
  ADD KEY `idx_productos_nombre` (`nombre`);

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
-- AUTO_INCREMENT de la tabla `auditoria_usuarios`
--
ALTER TABLE `auditoria_usuarios`
  MODIFY `id_auditoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id_categoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

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
-- AUTO_INCREMENT de la tabla `direcciones_envio`
--
ALTER TABLE `direcciones_envio`
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
  MODIFY `id_proveedor` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

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
-- Filtros para la tabla `direcciones_envio`
--
ALTER TABLE `direcciones_envio`
  ADD CONSTRAINT `fk_direcciones_envio_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`) ON DELETE CASCADE;

--
-- Filtros para la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD CONSTRAINT `fk_pedido_clientes` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`) ON UPDATE CASCADE;

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
