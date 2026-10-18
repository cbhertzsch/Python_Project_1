
CREATE TABLE IF NOT EXISTS customers (
    customer_id INTEGER PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(255),
    phone VARCHAR(30),
    city VARCHAR(100),
    registration_date DATE,
    customer_type VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS products (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(255),
    category VARCHAR(100),
    brand VARCHAR(100),
    unit_price NUMERIC(10,2),
    stock_quantity INTEGER,
    is_active BOOLEAN
);

CREATE TABLE IF NOT EXISTS orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    order_date TIMESTAMP,
    order_status VARCHAR(30),
    payment_method VARCHAR(50),
    total_amount NUMERIC(10,2),
    discount_amount NUMERIC(10,2),
    shipping_cost NUMERIC(10,2)
);
