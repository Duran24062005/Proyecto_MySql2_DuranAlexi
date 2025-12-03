-- ================================= 35
-- Creación de la base de datos
-- =================================

-- Eliminar la base de datos si existe
DROP DATABASE pizzeria_piccolo_db;

-- Creación de la base de datos
CREATE DATABASE pizzeria_piccolo_db;


-- Uso de la base de datos
use PiccoloPizzeriaDB;


-- ================================= 35
-- Creación de las tablas
-- =================================

-- Tabla Personas (entidad base)
CREATE TABLE Personas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    telefono VARCHAR(20),
    correo VARCHAR(100),
    direccion VARCHAR(100),
    fecha_creado DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizado DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla Clientes
CREATE TABLE Clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    persona_id INT NOT NULL,
    FOREIGN KEY (persona_id) REFERENCES Personas(id) ON DELETE CASCADE
);

-- Tabla users (usuarios del sistema)
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    persona_id INT NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(100) NOT NULL,
    FOREIGN KEY (persona_id) REFERENCES Personas(id) ON DELETE CASCADE
);

-- Tabla Zonas
CREATE TABLE Zonas (
    id_zona INT AUTO_INCREMENT PRIMARY KEY,
    nombre_zona VARCHAR(50) NOT NULL,
    costo_base_envio DOUBLE NOT NULL,
    costo_por_km DOUBLE NOT NULL,
    tiempo_estim_min INT NOT NULL,
    estado BOOLEAN DEFAULT TRUE
);

-- Tabla Domiciliarios
CREATE TABLE Domiciliarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    persona_id INT NOT NULL,
    zona_asignada INT NOT NULL,
    estado ENUM('disponible', 'ocupado', 'inactivo') DEFAULT 'disponible',
    FOREIGN KEY (persona_id) REFERENCES Personas(id) ON DELETE CASCADE,
    FOREIGN KEY (zona_asignada) REFERENCES Zonas(id_zona)
);

-- Tabla Pedidos
CREATE TABLE Pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    fecha_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    metodo_pago ENUM('efectivo', 'tarjeta', 'transferencia', 'wallet') NOT NULL,
    total DOUBLE NOT NULL,
    iva_pct DECIMAL(5,2) DEFAULT 19.00,
    user_id INT,
    tipo_pedido ENUM('local', 'domicilio', 'llevar') NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES Clientes(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Tabla Domicilios
CREATE TABLE Domicilios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    zona_id INT NOT NULL,
    domiciliario_id INT NOT NULL,
    pedido_id INT NOT NULL,
    hora_salida TIME,
    hora_entrega TIME,
    distancia_km DOUBLE,
    costo_envio DOUBLE NOT NULL,
    FOREIGN KEY (zona_id) REFERENCES Zonas(id_zona),
    FOREIGN KEY (domiciliario_id) REFERENCES Domiciliarios(id),
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(id) ON DELETE CASCADE
);

-- Tabla Pizzas
CREATE TABLE Pizzas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_pizza VARCHAR(50) NOT NULL,
    tamaño ENUM('pequeña', 'mediana', 'grande', 'familiar') NOT NULL,
    precio_base DOUBLE NOT NULL,
    tipo_pizza ENUM('tradicional', 'vegetariana', 'premium', 'especial') NOT NULL,
    descripcion VARCHAR(250),
    activo BOOLEAN DEFAULT TRUE,
    fecha_creado DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla Ingredientes
CREATE TABLE Ingredientes (
    id_ingrediente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    unidad VARCHAR(30) NOT NULL,
    costo_unitario DOUBLE NOT NULL,
    stock DOUBLE NOT NULL,
    stock_minimo DOUBLE NOT NULL
);

-- Tabla pizza_ingrediente (relación muchos a muchos)
CREATE TABLE pizza_ingrediente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pizzas_id INT NOT NULL,
    ingrediente_id INT NOT NULL,
    cantidad INT NOT NULL,
    FOREIGN KEY (pizzas_id) REFERENCES Pizzas(id) ON DELETE CASCADE,
    FOREIGN KEY (ingrediente_id) REFERENCES Ingredientes(id_ingrediente)
);

-- Tabla detalle_pedido_item
CREATE TABLE detalle_pedido_item (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    pizza_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DOUBLE NOT NULL,
    subtotal DOUBLE NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(id) ON DELETE CASCADE,
    FOREIGN KEY (pizza_id) REFERENCES Pizzas(id)
);

-- Tabla pagos
CREATE TABLE pagos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    metodo ENUM('efectivo', 'tarjeta', 'transferencia', 'wallet') NOT NULL,
    referencia VARCHAR(100),
    fecha_pago DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id) ON DELETE CASCADE
);

-- Tabla costo_pedido
CREATE TABLE costo_pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    costo_total_ingredientes DOUBLE NOT NULL,
    costo_real_envio DOUBLE DEFAULT 0,
    total_costos DOUBLE NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(id) ON DELETE CASCADE
);

-- Tabla historial_precios
CREATE TABLE historial_precios (
    id_hist INT AUTO_INCREMENT PRIMARY KEY,
    id_pizza INT NOT NULL,
    precio_antiguo DOUBLE NOT NULL,
    precio_nuevo DOUBLE NOT NULL,
    fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_pizza) REFERENCES Pizzas(id)
);