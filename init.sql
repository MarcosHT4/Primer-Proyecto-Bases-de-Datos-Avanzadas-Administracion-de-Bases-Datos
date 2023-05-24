CREATE USER "mydb_slave_user"@"%" IDENTIFIED BY "mydb_slave_pwd"; GRANT REPLICATION SLAVE ON *.* TO "mydb_slave_user"@"%"; FLUSH PRIVILEGES;

CREATE DATABASE vivero;
USE vivero;

CREATE TABLE `vivero`.`sembrado` (
  `idSembrado` INT NOT NULL,
  `cantidad` INT NULL,
  `fechaInicial` DATE NULL,
  `estado` VARCHAR(45) NULL,
  PRIMARY KEY (`idSembrado`));

CREATE TABLE `vivero`.`abono` (
  `idAbono` INT NOT NULL,
  `nombre` VARCHAR(45) NULL,
  `marca` VARCHAR(45) NULL,
  `tipo` VARCHAR(45) NULL,
  `cantidadEnStock` INT NULL,
  PRIMARY KEY (`idAbono`));

CREATE TABLE `vivero`.`venta` (
  `idVenta` INT NOT NULL,
  `cantidadVendida` INT NULL,
  `fechaVenta` DATE NULL,
  PRIMARY KEY (`idVenta`));

CREATE TABLE `vivero`.`proveedor` (
  `idProveedor` INT NOT NULL,
  `nombre` VARCHAR(45) NULL,
  `correo` VARCHAR(45) NULL,
  `direccion` VARCHAR(200) NULL,
  `telefono` VARCHAR(45) NULL,
  PRIMARY KEY (`idProveedor`));

CREATE TABLE `vivero`.`planta` (
  `idPlanta` INT NOT NULL,
  `nombreComun` VARCHAR(45) NULL,
  `nombreCientifico` VARCHAR(100) NULL,
  `descripcion` VARCHAR(200) NULL,
  `precio` DOUBLE NULL,
  PRIMARY KEY (`idPlanta`));

CREATE TABLE `vivero`.`usuario` (
  `idUsuario` INT NOT NULL,
  `nombreDeUsuario` VARCHAR(45) NULL,
  `contrasena` VARCHAR(45) NULL,
  PRIMARY KEY (`idUsuario`));

CREATE TABLE `vivero`.`cliente` (
  `ciCliente` VARCHAR(45) NOT NULL,
  `nombre` VARCHAR(45) NULL,
  `apellido` VARCHAR(45) NULL,
  `correo` VARCHAR(45) NULL,
  `direccion` VARCHAR(200) NULL,
  `telefono` VARCHAR(45) NULL,
  PRIMARY KEY (`ciCliente`));

CREATE TABLE `vivero`.`empleado` (
  `ciEmpleado` VARCHAR(45) NOT NULL,
  `nombre` VARCHAR(45) NULL,
  `apellido` VARCHAR(45) NULL,
  `correo` VARCHAR(45) NULL,
  `direccion` VARCHAR(200) NULL,
  `telefono` VARCHAR(45) NULL,
  PRIMARY KEY (`ciEmpleado`));

CREATE TABLE `vivero`.`reporte` (
  `idReporte` INT NOT NULL,
  `titulo` VARCHAR(45) NULL,
  `contenido` VARCHAR(200) NULL,
  `fechaReporte` DATE NULL,
  `tipo` VARCHAR(100) NULL,
  PRIMARY KEY (`idReporte`));

CREATE TABLE `vivero`.`sembradoabono` (
  `idSembrado` INT NOT NULL,
  `idAbono` INT NOT NULL,
  PRIMARY KEY (`idSembrado`, `idAbono`),
  INDEX `idAbono_idx` (`idAbono` ASC) VISIBLE,
  CONSTRAINT `sembradoabono_idSembrado`
    FOREIGN KEY (`idSembrado`)
    REFERENCES `vivero`.`sembrado` (`idSembrado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `sembradoabono_idAbono`
    FOREIGN KEY (`idAbono`)
    REFERENCES `vivero`.`abono` (`idAbono`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


CREATE TABLE `vivero`.`sembradoplanta` (
  `idSembrado` INT NOT NULL,
  `idPlanta` INT NOT NULL,
  PRIMARY KEY (`idSembrado`, `idPlanta`),
  INDEX `idPlanta_idx` (`idPlanta` ASC) VISIBLE,
  CONSTRAINT `sembradoplanta_idSembrado`
    FOREIGN KEY (`idSembrado`)
    REFERENCES `vivero`.`sembrado` (`idSembrado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `sembradoplanta_idPlanta`
    FOREIGN KEY (`idPlanta`)
    REFERENCES `vivero`.`planta` (`idPlanta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE TABLE `vivero`.`ventaplanta` (
  `idVenta` INT NOT NULL,
  `idPlanta` INT NOT NULL,
  PRIMARY KEY (`idVenta`, `idPlanta`),
  INDEX `idPlanta_idx` (`idPlanta` ASC) VISIBLE,
  CONSTRAINT `ventaplanta_idVenta`
    FOREIGN KEY (`idVenta`)
    REFERENCES `vivero`.`venta` (`idVenta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ventaplanta_idPlanta`
    FOREIGN KEY (`idPlanta`)
    REFERENCES `vivero`.`planta` (`idPlanta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

ALTER TABLE `vivero`.`abono` 
ADD COLUMN `idProveedor` INT NULL AFTER `cantidadEnStock`,
ADD INDEX `idProveedor_idx` (`idProveedor` ASC) VISIBLE;
;
ALTER TABLE `vivero`.`abono` 
ADD CONSTRAINT `abono_idProveedor`
  FOREIGN KEY (`idProveedor`)
  REFERENCES `vivero`.`proveedor` (`idProveedor`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `vivero`.`venta` 
ADD COLUMN `ciCliente` VARCHAR(45) NULL AFTER `fechaVenta`,
ADD COLUMN `ciEmpleado` VARCHAR(45) NULL AFTER `ciCliente`,
ADD INDEX `ciCliente_idx` (`ciCliente` ASC) VISIBLE,
ADD INDEX `ciEmpleado_idx` (`ciEmpleado` ASC) VISIBLE;
;
ALTER TABLE `vivero`.`venta` 
ADD CONSTRAINT `venta_ciCliente`
  FOREIGN KEY (`ciCliente`)
  REFERENCES `vivero`.`cliente` (`ciCliente`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `venta_ciEmpleado`
  FOREIGN KEY (`ciEmpleado`)
  REFERENCES `vivero`.`empleado` (`ciEmpleado`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;


ALTER TABLE `vivero`.`cliente` 
ADD COLUMN `idUsuario` INT NULL AFTER `telefono`,
ADD INDEX `idUsuario_idx` (`idUsuario` ASC) VISIBLE;
;
ALTER TABLE `vivero`.`cliente` 
ADD CONSTRAINT `cliente_idUsuario`
  FOREIGN KEY (`idUsuario`)
  REFERENCES `vivero`.`usuario` (`idUsuario`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;


ALTER TABLE `vivero`.`empleado` 
ADD COLUMN `idUsuario` INT NULL AFTER `telefono`,
ADD INDEX `idUsuario_idx` (`idUsuario` ASC) VISIBLE;
;
ALTER TABLE `vivero`.`empleado` 
ADD CONSTRAINT `empleado_idUsuario`
  FOREIGN KEY (`idUsuario`)
  REFERENCES `vivero`.`usuario` (`idUsuario`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `vivero`.`reporte` 
ADD COLUMN `ciEmpleado` VARCHAR(45) NULL AFTER `tipo`,
ADD INDEX `ciEmpleado_idx` (`ciEmpleado` ASC) VISIBLE;
;
ALTER TABLE `vivero`.`reporte` 
ADD CONSTRAINT `reporte_ciEmpleado`
  FOREIGN KEY (`ciEmpleado`)
  REFERENCES `vivero`.`empleado` (`ciEmpleado`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

INSERT INTO `vivero`.`sembrado` (`idSembrado`, `cantidad`, `fechaInicial`, `estado`) VALUES ('1', '20', '2020-02-14', 'Saludable');

INSERT INTO `vivero`.`sembrado` (`idSembrado`, `cantidad`, `fechaInicial`, `estado`) VALUES ('2', '15', '2021-05-10', 'Creciendo');

INSERT INTO `vivero`.`sembrado` (`idSembrado`, `cantidad`, `fechaInicial`, `estado`) VALUES ('3', '10', '2022-01-03', 'Enfermo');

INSERT INTO `vivero`.`sembrado` (`idSembrado`, `cantidad`, `fechaInicial`, `estado`) VALUES ('4', '8', '2023-03-15', 'Saludable');

INSERT INTO `vivero`.`sembrado` (`idSembrado`, `cantidad`, `fechaInicial`, `estado`) VALUES ('5', '12', '2022-11-22', 'Creciendo');

INSERT INTO `vivero`.`sembrado` (`idSembrado`, `cantidad`, `fechaInicial`, `estado`) VALUES ('6', '25', '2023-04-01', 'Enfermo');


INSERT INTO `vivero`.`proveedor` (`idProveedor`, `nombre`, `correo`, `direccion`, `telefono`) VALUES ('1', 'Banferbol', 'banferbolsrl@hotmail.com', 'Av. Chillani Nro 2334 Zona Juan Az', '978 52000');
INSERT INTO `vivero`.`proveedor` (`idProveedor`, `nombre`, `correo`, `direccion`, `telefono`) VALUES ('2', 'Arados del Oriente', 'aradosdeloriente@gmail.com', 'Camatindi Nro 100 Z/ Sencata', '72000342');
INSERT INTO `vivero`.`proveedor` (`idProveedor`, `nombre`, `correo`, `direccion`, `telefono`) VALUES ('3', 'Fertibol', 'fertibolsrl@hotmail.com', 'Av. Estanislao Torrez 1814 El Alto', '772 13815');
INSERT INTO `vivero`.`proveedor` (`idProveedor`, `nombre`, `correo`, `direccion`, `telefono`) VALUES ('4', 'Biofuel', 'biofuelbolivia@gmail.com', 'Cuarto anillo esq. Camba Soto Radial 13', '3567534');
INSERT INTO `vivero`.`proveedor` (`idProveedor`, `nombre`, `correo`, `direccion`, `telefono`) VALUES ('5', 'Calliope Bolivia', 'calliopebolivia@gmail.com', 'Km. 6 carretera al Norte s/n, Zona Nueva Jerusalen', '3427543');

INSERT INTO `vivero`.`abono` (`idAbono`, `nombre`, `marca`, `tipo`, `cantidadEnStock`, `idProveedor`) VALUES ('1', 'Tecnoplus NK', 'HerograGroup', 'Nitrato potasico', '50', '2');
INSERT INTO `vivero`.`abono` (`idAbono`, `nombre`, `marca`, `tipo`, `cantidadEnStock`, `idProveedor`) VALUES ('2', 'Fertilmax', 'AgroFert', 'Fertilizante líquido', '25', '3');
INSERT INTO `vivero`.`abono` (`idAbono`, `nombre`, `marca`, `tipo`, `cantidadEnStock`, `idProveedor`) VALUES ('3', 'OrganoGrow', 'BioAgri', 'Fertilizante orgánico', '10', '1');
INSERT INTO `vivero`.`abono` (`idAbono`, `nombre`, `marca`, `tipo`, `cantidadEnStock`, `idProveedor`) VALUES ('4', 'NitroGrow', 'GreenFields', 'Nitrógeno líquido', '15', '4');
INSERT INTO `vivero`.`abono` (`idAbono`, `nombre`, `marca`, `tipo`, `cantidadEnStock`, `idProveedor`) VALUES ('5', 'FosfatoMax', 'AgroFert', 'Fertilizante fosfatado', '30', '2');

INSERT INTO `vivero`.`planta` (`idPlanta`, `nombreComun`, `nombreCientifico`, `descripcion`, `precio`) VALUES ('1', 'Quinua', 'Chenopodium quinoa', 'Grano nutritivo, sin gluten y versátil en la cocina saludable.', '250');
INSERT INTO `vivero`.`planta` (`idPlanta`, `nombreComun`, `nombreCientifico`, `descripcion`, `precio`) VALUES ('2', 'Rosa', 'Rosa spp.', 'Flor clásica y romántica para decorar jardines y ramos.', '15');
INSERT INTO `vivero`.`planta` (`idPlanta`, `nombreComun`, `nombreCientifico`, `descripcion`, `precio`) VALUES ('3', 'Tomate', 'Solanum lycopersicum', 'Fruto jugoso y versátil en la cocina para salsas y ensaladas.', '5');
INSERT INTO `vivero`.`planta` (`idPlanta`, `nombreComun`, `nombreCientifico`, `descripcion`, `precio`) VALUES ('4', 'Lavanda', 'Lavandula spp.', 'Planta aromática con propiedades relajantes y ornamentales.', '8');
INSERT INTO `vivero`.`planta` (`idPlanta`, `nombreComun`, `nombreCientifico`, `descripcion`, `precio`) VALUES ('5', 'Orquídea', 'Orchidaceae spp.', 'Flor exótica y elegante apreciada por su belleza y rareza.', '20');
INSERT INTO `vivero`.`planta` (`idPlanta`, `nombreComun`, `nombreCientifico`, `descripcion`, `precio`) VALUES ('6', 'Cactus', 'Cactaceae spp.', 'Planta suculenta resistente y decorativa para interiores y exteriores.', '12');


INSERT INTO `vivero`.`usuario` (`idUsuario`, `nombreDeUsuario`, `contrasena`) VALUES ('1', 'marcossimon', 'e$#bfdf*uw3!h');
INSERT INTO `vivero`.`usuario` (`idUsuario`, `nombreDeUsuario`, `contrasena`) VALUES ('2', 'lauragomez', 'vfh#fr!2f');
INSERT INTO `vivero`.`usuario` (`idUsuario`, `nombreDeUsuario`, `contrasena`) VALUES ('3', 'juanperez', 'kdu&hg45!@');
INSERT INTO `vivero`.`usuario` (`idUsuario`, `nombreDeUsuario`, `contrasena`) VALUES ('4', 'mariarodriguez', 'weyf&#!ik3');
INSERT INTO `vivero`.`usuario` (`idUsuario`, `nombreDeUsuario`, `contrasena`) VALUES ('5', 'pedrogomez', 'ldc$#!dj54');

INSERT INTO `vivero`.`usuario` (`idUsuario`, `nombreDeUsuario`, `contrasena`) VALUES ('6', 'anacastillo', 'kgk!6dh%h');
INSERT INTO `vivero`.`usuario` (`idUsuario`, `nombreDeUsuario`, `contrasena`) VALUES ('7', 'jorgesoto', 'kmh#@fj34f11');
INSERT INTO `vivero`.`usuario` (`idUsuario`, `nombreDeUsuario`, `contrasena`) VALUES ('8', 'martalopez', 'Ploy56*!@mjn23');
INSERT INTO `vivero`.`usuario` (`idUsuario`, `nombreDeUsuario`, `contrasena`) VALUES ('9', 'carlosruiz', 'kio65@###112');
INSERT INTO `vivero`.`usuario` (`idUsuario`, `nombreDeUsuario`, `contrasena`) VALUES ('10', 'luciasanchez', 'Sbhfje@!**fnw');

INSERT INTO `vivero`.`cliente` (`ciCliente`, `nombre`, `apellido`, `correo`, `direccion`, `telefono`, `idUsuario`) VALUES ('8512332LP', 'Marcos', 'Simon', 'marcossimon@gmail.com', 'Av. Arce #45', '7541125', '1');
INSERT INTO `vivero`.`cliente` (`ciCliente`, `nombre`, `apellido`, `correo`, `direccion`, `telefono`, `idUsuario`) VALUES ('521154LP', 'Laura', 'Gomez', 'lauragomez@gmail.com', 'Calle 123', '1234567', '2');
INSERT INTO `vivero`.`cliente` (`ciCliente`, `nombre`, `apellido`, `correo`, `direccion`, `telefono`, `idUsuario`) VALUES ('9655441SCZ', 'Juan', 'Perez', 'juanperez@gmail.com', 'Avenida Principal', '9876543', '3');
INSERT INTO `vivero`.`cliente` (`ciCliente`, `nombre`, `apellido`, `correo`, `direccion`, `telefono`, `idUsuario`) VALUES ('741125CBBA', 'Maria', 'Rodriguez', 'mariarodriguez@gmail.com', 'Calle Secundaria', '4567890', '4');
INSERT INTO `vivero`.`cliente` (`ciCliente`, `nombre`, `apellido`, `correo`, `direccion`, `telefono`, `idUsuario`) VALUES ('6598554LP', 'Pedro', 'Gomez', 'pedrogomez@gmail.com', 'Avenida Central', '9876543', '5');

INSERT INTO `vivero`.`empleado` (`ciEmpleado`, `nombre`, `apellido`, `correo`, `direccion`, `telefono`, `idUsuario`) VALUES ('5478224LP', 'Ana', 'Castillo', 'anacastillo@gmail.com', 'Calle Principal', '9876543', '6');
INSERT INTO `vivero`.`empleado` (`ciEmpleado`, `nombre`, `apellido`, `correo`, `direccion`, `telefono`, `idUsuario`) VALUES ('7654321LP', 'Jorge', 'Soto', 'jorgesoto@gmail.com', 'Avenida Secundaria', '1234567', '7');
INSERT INTO `vivero`.`empleado` (`ciEmpleado`, `nombre`, `apellido`, `correo`, `direccion`, `telefono`, `idUsuario`) VALUES ('9876543LP', 'Marta', 'Lopez', 'martalopez@gmail.com', 'Calle Principal', '4567890', '8');
INSERT INTO `vivero`.`empleado` (`ciEmpleado`, `nombre`, `apellido`, `correo`, `direccion`, `telefono`, `idUsuario`) VALUES ('4567890LP', 'Carlos', 'Ruiz', 'carlosruiz@gmail.com', 'Avenida Central', '9876543', '9');
INSERT INTO `vivero`.`empleado` (`ciEmpleado`, `nombre`, `apellido`, `correo`, `direccion`, `telefono`, `idUsuario`) VALUES ('6543210LP', 'Lucia', 'Sanchez', 'luciasanchez@gmail.com', 'Calle Principal', '1234567', '10');

INSERT INTO `vivero`.`reporte` (`idReporte`, `titulo`, `contenido`, `fechaReporte`, `tipo`, `ciEmpleado`) VALUES ('1', 'Venta de tomates', 'Venta de tomates de la ultima decada', '2022-05-16', 'Reporte de ventas', '4567890LP');
INSERT INTO `vivero`.`reporte` (`idReporte`, `titulo`, `contenido`, `fechaReporte`, `tipo`, `ciEmpleado`) VALUES ('2', 'Producción de flores', 'Análisis de la producción de flores del mes pasado', '2022-06-10', 'Reporte de produccion', '5478224LP');
INSERT INTO `vivero`.`reporte` (`idReporte`, `titulo`, `contenido`, `fechaReporte`, `tipo`, `ciEmpleado`) VALUES ('3', 'Análisis de ventas mensuales', 'Informe detallado de las ventas del último mes', '2022-06-30', 'Reporte de ventas', '7654321LP');
INSERT INTO `vivero`.`reporte` (`idReporte`, `titulo`, `contenido`, `fechaReporte`, `tipo`, `ciEmpleado`) VALUES ('4', 'Análisis de clientes frecuentes', 'Identificación de los clientes más frecuentes del trimestre', '2022-07-15', 'Reporte de clientes', '9876543LP');
INSERT INTO `vivero`.`reporte` (`idReporte`, `titulo`, `contenido`, `fechaReporte`, `tipo`, `ciEmpleado`) VALUES ('5', 'Inventario de productos', 'Informe completo del inventario de productos actualizado', '2022-07-31', 'Reporte de productos', '6543210LP');

INSERT INTO `vivero`.`venta` (`idVenta`, `cantidadVendida`, `fechaVenta`, `ciCliente`, `ciEmpleado`) VALUES ('1', '20', '2023-03-12', '521154LP', '9876543LP');
INSERT INTO `vivero`.`venta` (`idVenta`, `cantidadVendida`, `fechaVenta`, `ciCliente`, `ciEmpleado`) VALUES ('2', '15', '2021-06-23', '741125CBBA', '6543210LP');
INSERT INTO `vivero`.`venta` (`idVenta`, `cantidadVendida`, `fechaVenta`, `ciCliente`, `ciEmpleado`) VALUES ('3', '25', '2020-04-05', '9655441SCZ', '9876543LP');
INSERT INTO `vivero`.`venta` (`idVenta`, `cantidadVendida`, `fechaVenta`, `ciCliente`, `ciEmpleado`) VALUES ('4', '14', '2023-04-25', '6598554LP', '5478224LP');
INSERT INTO `vivero`.`venta` (`idVenta`, `cantidadVendida`, `fechaVenta`, `ciCliente`, `ciEmpleado`) VALUES ('5', '30', '2018-06-12', '8512332LP', '7654321LP');

INSERT INTO `vivero`.`sembradoabono` (`idSembrado`, `idAbono`) VALUES ('1', '1');
INSERT INTO `vivero`.`sembradoabono` (`idSembrado`, `idAbono`) VALUES ('1', '2');
INSERT INTO `vivero`.`sembradoabono` (`idSembrado`, `idAbono`) VALUES ('1', '3');
INSERT INTO `vivero`.`sembradoabono` (`idSembrado`, `idAbono`) VALUES ('2', '4');
INSERT INTO `vivero`.`sembradoabono` (`idSembrado`, `idAbono`) VALUES ('2', '5');
INSERT INTO `vivero`.`sembradoabono` (`idSembrado`, `idAbono`) VALUES ('3', '1');
INSERT INTO `vivero`.`sembradoabono` (`idSembrado`, `idAbono`) VALUES ('3', '3');
INSERT INTO `vivero`.`sembradoabono` (`idSembrado`, `idAbono`) VALUES ('3', '5');
INSERT INTO `vivero`.`sembradoabono` (`idSembrado`, `idAbono`) VALUES ('4', '1');
INSERT INTO `vivero`.`sembradoabono` (`idSembrado`, `idAbono`) VALUES ('4', '2');
INSERT INTO `vivero`.`sembradoabono` (`idSembrado`, `idAbono`) VALUES ('5', '1');
INSERT INTO `vivero`.`sembradoabono` (`idSembrado`, `idAbono`) VALUES ('5', '2');
INSERT INTO `vivero`.`sembradoabono` (`idSembrado`, `idAbono`) VALUES ('5', '3');
INSERT INTO `vivero`.`sembradoabono` (`idSembrado`, `idAbono`) VALUES ('5', '5');
INSERT INTO `vivero`.`sembradoabono` (`idSembrado`, `idAbono`) VALUES ('6', '4');

INSERT INTO `vivero`.`sembradoplanta` (`idSembrado`, `idPlanta`) VALUES ('1', '2');
INSERT INTO `vivero`.`sembradoplanta` (`idSembrado`, `idPlanta`) VALUES ('2', '5');
INSERT INTO `vivero`.`sembradoplanta` (`idSembrado`, `idPlanta`) VALUES ('3', '6');
INSERT INTO `vivero`.`sembradoplanta` (`idSembrado`, `idPlanta`) VALUES ('4', '1');
INSERT INTO `vivero`.`sembradoplanta` (`idSembrado`, `idPlanta`) VALUES ('5', '3');
INSERT INTO `vivero`.`sembradoplanta` (`idSembrado`, `idPlanta`) VALUES ('6', '4');

INSERT INTO `vivero`.`ventaplanta` (`idVenta`, `idPlanta`) VALUES ('2', '3');
INSERT INTO `vivero`.`ventaplanta` (`idVenta`, `idPlanta`) VALUES ('2', '5');
INSERT INTO `vivero`.`ventaplanta` (`idVenta`, `idPlanta`) VALUES ('1', '1');
INSERT INTO `vivero`.`ventaplanta` (`idVenta`, `idPlanta`) VALUES ('1', '2');
INSERT INTO `vivero`.`ventaplanta` (`idVenta`, `idPlanta`) VALUES ('1', '3');
INSERT INTO `vivero`.`ventaplanta` (`idVenta`, `idPlanta`) VALUES ('3', '6');
INSERT INTO `vivero`.`ventaplanta` (`idVenta`, `idPlanta`) VALUES ('4', '5');
INSERT INTO `vivero`.`ventaplanta` (`idVenta`, `idPlanta`) VALUES ('5', '4');







