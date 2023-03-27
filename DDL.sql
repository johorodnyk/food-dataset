-- Create new database
CREATE DATABASE food;

-- Table: customers

-- DROP TABLE IF EXISTS customers;
CREATE TABLE IF NOT EXISTS customers
(
    id integer NOT NULL DEFAULT nextval('customers_id_seq'::regclass),
    first_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    last_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    city character varying(50) COLLATE pg_catalog."default",
    referral_customer_id integer,
    CONSTRAINT customers_pkey PRIMARY KEY (id)
) TABLESPACE pg_default;
    
-- Table: order_item

-- DROP TABLE IF EXISTS order_item;
CREATE TABLE IF NOT EXISTS order_item
(
    id integer NOT NULL DEFAULT nextval('order_item_id_seq'::regclass),
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    price integer,
    item_quantity integer,
    CONSTRAINT order_item_pkey PRIMARY KEY (id)
) TABLESPACE pg_default;

-- Table: orders

-- DROP TABLE IF EXISTS orders;
CREATE TABLE IF NOT EXISTS orders
(
    id integer NOT NULL DEFAULT nextval('orders_id_seq'::regclass),
    created_at date,
    updated_status date,
    customer_id integer NOT NULL,
    tips integer,
    rating integer,
    CONSTRAINT orders_pkey PRIMARY KEY (id)
) TABLESPACE pg_default;

 -- Table: product
 
 -- DROP TABLE IF EXISTS product;
CREATE TABLE IF NOT EXISTS product
(
    id integer NOT NULL DEFAULT nextval('product_id_seq'::regclass),
    name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    price money NOT NULL DEFAULT 0,
    description character varying(200) COLLATE pg_catalog."default" NOT NULL,
    cost money NOT NULL DEFAULT 0,
    CONSTRAINT product_pkey PRIMARY KEY (id)
) TABLESPACE pg_default;
