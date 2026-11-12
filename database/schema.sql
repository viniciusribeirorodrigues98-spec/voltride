CREATE DATABASE IF NOT EXISTS voltride
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE voltride;

CREATE TABLE IF NOT EXISTS users (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  email VARCHAR(190) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  role ENUM('customer', 'admin') NOT NULL DEFAULT 'customer',
  phone VARCHAR(30) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS scooters (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  slug VARCHAR(140) NOT NULL UNIQUE,
  brand VARCHAR(100) NOT NULL DEFAULT 'VoltRide',
  description TEXT NULL,
  image_url VARCHAR(500) NULL,
  price DECIMAL(10,2) NOT NULL,
  motor_watts SMALLINT UNSIGNED NOT NULL,
  range_km SMALLINT UNSIGNED NOT NULL,
  weight_kg DECIMAL(5,2) NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_scooters_active_price (is_active, price)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS components (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  component_type ENUM('motor','battery','controller','wheel','tire','brake') NOT NULL,
  description TEXT NULL,
  price DECIMAL(10,2) NOT NULL,
  specifications JSON NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_components_name (name),
  INDEX idx_components_type_active (component_type, is_active)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS accessories (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  description TEXT NULL,
  image_url VARCHAR(500) NULL,
  price DECIMAL(10,2) NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS scooter_component_compatibility (
  scooter_id BIGINT UNSIGNED NOT NULL,
  component_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (scooter_id, component_id),
  CONSTRAINT fk_scc_scooter FOREIGN KEY (scooter_id) REFERENCES scooters(id) ON DELETE CASCADE,
  CONSTRAINT fk_scc_component FOREIGN KEY (component_id) REFERENCES components(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS scooter_accessory_compatibility (
  scooter_id BIGINT UNSIGNED NOT NULL,
  accessory_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (scooter_id, accessory_id),
  CONSTRAINT fk_sac_scooter FOREIGN KEY (scooter_id) REFERENCES scooters(id) ON DELETE CASCADE,
  CONSTRAINT fk_sac_accessory FOREIGN KEY (accessory_id) REFERENCES accessories(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS configurations (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NULL,
  scooter_id BIGINT UNSIGNED NOT NULL,
  name VARCHAR(120) NULL,
  total_price DECIMAL(10,2) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_config_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
  CONSTRAINT fk_config_scooter FOREIGN KEY (scooter_id) REFERENCES scooters(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS configuration_components (
  configuration_id BIGINT UNSIGNED NOT NULL,
  component_id BIGINT UNSIGNED NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (configuration_id, component_id),
  CONSTRAINT fk_cc_configuration FOREIGN KEY (configuration_id) REFERENCES configurations(id) ON DELETE CASCADE,
  CONSTRAINT fk_cc_component FOREIGN KEY (component_id) REFERENCES components(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS configuration_accessories (
  configuration_id BIGINT UNSIGNED NOT NULL,
  accessory_id BIGINT UNSIGNED NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  quantity SMALLINT UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (configuration_id, accessory_id),
  CONSTRAINT fk_ca_configuration FOREIGN KEY (configuration_id) REFERENCES configurations(id) ON DELETE CASCADE,
  CONSTRAINT fk_ca_accessory FOREIGN KEY (accessory_id) REFERENCES accessories(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS carts (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NULL,
  guest_token CHAR(64) NULL UNIQUE,
  status ENUM('active','converted','abandoned') NOT NULL DEFAULT 'active',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_cart_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS cart_items (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  cart_id BIGINT UNSIGNED NOT NULL,
  scooter_id BIGINT UNSIGNED NOT NULL,
  configuration_id BIGINT UNSIGNED NULL,
  quantity SMALLINT UNSIGNED NOT NULL DEFAULT 1,
  unit_price DECIMAL(10,2) NOT NULL,
  configuration_snapshot JSON NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_cart_item_cart FOREIGN KEY (cart_id) REFERENCES carts(id) ON DELETE CASCADE,
  CONSTRAINT fk_cart_item_scooter FOREIGN KEY (scooter_id) REFERENCES scooters(id),
  CONSTRAINT fk_cart_item_configuration FOREIGN KEY (configuration_id) REFERENCES configurations(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS orders (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NOT NULL,
  order_number VARCHAR(32) NOT NULL UNIQUE,
  status ENUM('pending','paid','processing','shipped','delivered','cancelled') NOT NULL DEFAULT 'pending',
  subtotal DECIMAL(10,2) NOT NULL,
  shipping_total DECIMAL(10,2) NOT NULL DEFAULT 0,
  grand_total DECIMAL(10,2) NOT NULL,
  shipping_address JSON NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_order_user FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS order_items (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  order_id BIGINT UNSIGNED NOT NULL,
  scooter_id BIGINT UNSIGNED NULL,
  product_name VARCHAR(160) NOT NULL,
  quantity SMALLINT UNSIGNED NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  configuration_snapshot JSON NULL,
  CONSTRAINT fk_order_item_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  CONSTRAINT fk_order_item_scooter FOREIGN KEY (scooter_id) REFERENCES scooters(id) ON DELETE SET NULL
) ENGINE=InnoDB;
