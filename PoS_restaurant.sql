DROP DATABASE PoS_restaurant;

CREATE DATABASE PoS_restaurant;

USE PoS_restaurant;

-- create tables
CREATE TABLE ingredients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(255),
    price INT,
    quantity INT,
    name VARCHAR(255)
);

CREATE TABLE supplier_item (
    id INT AUTO_INCREMENT PRIMARY KEY,
    quantity INT,
    price INT,
    no_telp VARCHAR(20),
    name VARCHAR(255)
);

CREATE TABLE item (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_supplier_item INT,
    name VARCHAR(255),
    price INT,
    FOREIGN KEY (id_supplier_item) REFERENCES supplier_item (id)
);

CREATE TABLE employee (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    position VARCHAR(100),
    entry_date DATE,
    salary INT,
    gender VARCHAR(10)
);

CREATE TABLE `order` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `id_employee` INT,
    `time` DATE,
    `payment_method` VARCHAR(50),
    `total` INT,
    `payment` VARCHAR(50),
    `change_amount` INT,
    FOREIGN KEY (`id_employee`) REFERENCES employee (`id`)
);

CREATE TABLE detail_order (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_item INT,
    id_order INT,
    price_unit INT,
    quantity INT,
    FOREIGN KEY (id_item) REFERENCES item (id),
    FOREIGN KEY (id_order) REFERENCES `order` (id)
);

CREATE TABLE expenses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(50),
    total INT,
    id_employee INT,
    id_produk INT,
    FOREIGN KEY (id_employee) REFERENCES employee (id),
    FOREIGN KEY (id_produk) REFERENCES item (id)
);

CREATE TABLE attendance (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_employee INT,
    shift VARCHAR(20),
    attendance_status VARCHAR(50),
    attendance_time BIGINT,
    FOREIGN KEY (id_employee) REFERENCES employee (id)
);

-- insert data
INSERT INTO
    ingredients (
        description,
        price,
        quantity,
        name
    )
VALUES ('Beras', 10000, 75, 'Beras');

INSERT INTO
    supplier_item (
        quantity,
        price,
        no_telp,
        name
    )
VALUES (
        100,
        10000,
        '081234567890',
        'Supplier Beras'
    );

INSERT INTO
    item (id_supplier_item, name, price)
VALUES (1, 'Beras', 10000);

INSERT INTO
    employee (
        name,
        position,
        entry_date,
        salary,
        gender
    )
VALUES (
        'Mugik Hidayati',
        'Owner',
        '2022-01-01',
        130000,
        'Female'
    ),
    (
        'Ida',
        'Kasir',
        '2022-01-01',
        90000,
        'Female'
    );

INSERT INTO
    `order` (
        `id_employee`,
        `time`,
        `payment_method`,
        `total`,
        `payment`,
        `change_amount`
    )
VALUES (
        2,
        '2022-01-01 07:00:00',
        'Cash',
        30000,
        50000,
        20000
    );

INSERT INTO
    detail_order (
        id_item,
        id_order,
        price_unit,
        quantity
    )
VALUES (1, 1, 10000, 3);

INSERT INTO
    expenses (
        category,
        total,
        id_employee,
        id_produk
    )
VALUES ('Gaji', 220000, 1, 1);

INSERT INTO
    attendance (
        id_employee,
        shift,
        attendance_status,
        attendance_time
    )
VALUES (
        1,
        'Morning',
        'Present',
        UNIX_TIMESTAMP('2022-01-01 07:00:00')
    ),
    (
        2,
        'Morning',
        'Present',
        UNIX_TIMESTAMP('2022-01-01 07:00:00')
    );

