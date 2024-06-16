DROP DATABASE PoS_restaurant;

CREATE DATABASE PoS_restaurant;

USE PoS_restaurant;
-- tabel untuk item yang dititipi oleh supplier
CREATE TABLE supplier_item (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    quantity INT,
    price INT,
    no_telp INT,
    name VARCHAR (100)
);
-- tabel untuk item yang dijual di warung makan (makanan, minuman, sambal), baik dari supplier maupun buatan sendiri
CREATE TABLE item (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR (100),
    price INT,
    supplier_item_id INT,
    FOREIGN KEY (supplier_item_id) REFERENCES supplier_item(id)
);
-- tabel untuk pegawai
CREATE TABLE employee (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR (100),
    no_telp INT,
    role ENUM ('Kasir', 'Pelayan', 'Juru Masak', 'Pembantu', 'Owner'),   
    entry_date DATE,
    salary INT,
    gender ENUM ('Laki - Laki', 'Perempuan'), 
    address VARCHAR (100)
);
-- tabel untuk order / pesanan
/*tidak ada tabel customer karena customer tidak perlu diidentifikasi secara individual untuk setiap transaksi.
customer hanya perlu memberikan pesanan dan membayar.
maka, tabel order berisi informasi tentang pesanan dan pembayaran*/
CREATE TABLE `order` (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    time DATE,
    payment_method ENUM ('Cash', 'Qris'),
    total INT,
    payment INT,
    money_change INT,
    employee_id INT,
    FOREIGN KEY (employee_id) REFERENCES employee(id)
);
-- tabel untuk detail order / detail pesanan
CREATE TABLE detail_order (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    price_unit INT,
    quantity INT,
    item_id INT,
    order_id INT,
    FOREIGN KEY (item_id) REFERENCES item(id),
    FOREIGN KEY (order_id) REFERENCES `order`(id)
);
-- tabel untuk absensi pegawai
CREATE TABLE attendance (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    shift ENUM ('Pagi', 'Sore'),
    attendace_date DATETIME,
    attendance_status ENUM ('Hadir', 'Absen'),
    employee_id INT,
    FOREIGN KEY (employee_id) REFERENCES employee(id)
);
-- tabel untuk bahan baku / bahan mentah yang akan dijadikan masakan oleh juru masak
CREATE TABLE ingredients (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    description VARCHAR (100),
    price INT,
    quantity VARCHAR (100),
    name VARCHAR (100)
);
-- tabel untuk pengeluaran
CREATE TABLE expense (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    category ENUM ('Gaji Karyawan', 'Listrik', 'Air', 'Gas', 'Sewa Bangunan', 'Ingredients', 'Lainnya'),
    total INT,
    employee_id INT,
    ingredients_id INT,
    FOREIGN KEY (employee_id) REFERENCES employee(id),
    FOREIGN KEY (ingredients_id) REFERENCES ingredients(id)
);

INSERT INTO supplier_item (id, quantity, price, no_telp, name) VALUES 
    (001, 100, 4000, 081234567890, 'Roida'),
    (002, 100, 5000, 081234567891, 'Roziqin'),
    (003, 100, 6000, 081234567892, 'Aisyah');

-- menampilkan item dari supplier dan siapa suppliernya
SELECT * FROM supplier_item;

/*10* = makanan owner
20* = minuman owner
30* = sambal owner
40* = makanan supplier
50* = minuman supplier*/
INSERT INTO item (id, name, price, supplier_item_id) VALUES 
    (101, 'Nasi Putih', 4000, NULL),
    (102, 'Pangsit', 1000, NULL),
    (103, 'Sayur Bayam', 2000, NULL),
    (104, 'Sayur Terong', 2000, NULL),
    (105, 'Sayur Buncis', 2000, NULL),
    (106, 'Ayam Krispy', 6000, NULL),
    (107, 'Ikan Tongkol', 2000, NULL),
    (108, 'Telur Goreng', 3000, NULL),
    (109, 'Sambal Goreng Tempe', 2000, NULL),
    (110, 'Tumis Kangkung', 2000, NULL),
    (111, 'Ikan Lele Krispy', 4000, NULL),
    (112, 'Ayam Bumbu Kuning', 4000, NULL),
    (113, 'Mie Goreng', 2000, NULL),
    (114, 'Tempe Goreng', 1000, NULL),
    (115, 'Usus', 2000, NULL),
    (116, 'Perkedel', 2000, NULL),
    (117, 'Telur Asin', 4000, NULL),
    (118, 'Telur Balado', 3000, NULL),
    (119, 'Ayam Kecap', 4000, NULL),
    (120, 'Tempe / Tahu Kecap', 1000, NULL),
    (121, 'Sayur Sop', 2000, NULL),
    (122, 'Sayur Asam', 2000, NULL),
    (123, 'Sayur Daun Singkong', 2000, NULL),
    (201, 'Teh Hangat / Es', 3000, NULL),
    (202, 'Jeruk Hangat / Es', 3000, NULL),
    (203, 'Hilo Anget / Es', 5000, NULL),
    (204, 'Nutrisari', 3000, NULL),
    (205, 'Milo', 6000, NULL),
    (206, 'Kopi', 3000, NULL),
    (207, 'Air Mineral', 2000, NULL),
    (301, 'Sambal Bawang', 1000, NULL),
    (302, 'Sambal Ijo', 1000, NULL),
    (303, 'Sambal Tomat', 1000, NULL),
    (304, 'Sambal Terasi', 1000, NULL),
    (401, 'Telur Gulung', 4000, 001),
    (402, 'Empal Sapi', 5000, 002),
    (501, 'Trily', 6000, 003);

-- menampilkan item yang dijual di warung makan (makanan, minuman, sambal), baik dari supplier maupun buatan sendiri
SELECT * FROM item;

-- mengurutkan daftar menu dari termurah ke termahal
SELECT * FROM item ORDER BY price ASC;

-- mengurutkan daftar menu dari termahal ke termurah
SELECT * FROM item ORDER BY price DESC;

-- menampilkan item yang dijual oleh owner saja
SELECT * FROM item WHERE supplier_item_id IS NULL;

-- menampilkan item yang dijual oleh supplier saja
SELECT * FROM item WHERE supplier_item_id IS NOT NULL;

INSERT INTO employee (id, name, no_telp, role, entry_date, salary, gender, address) VALUES
    (001, 'Mugik Hidayati', 081234567890, 'Owner', '2022-01-01', 3900000, 'Perempuan', 'Jl. Remujung No. 04'),
    (002, 'Aminin', 081234567891, 'Pembantu', '2022-05-02', 2500000, 'Laki - Laki', 'Jl. Remujung No. 04'),
    (003, 'Faizah', 081234567892, 'Pembantu', '2022-01-01', 2500000, 'Perempuan', 'Jl. Kembang Turip No. 03'),
    (004, 'Ilmi', 081234567893, 'Kasir', '2021-01-01', 3000000, 'Perempuan', 'Jl. Remujung No. 04'),
    (005, 'Sopiah', 081234567894, 'Pelayan', '2021-01-01', 3000000, 'Perempuan', 'Jl. Simbar Menjangan No. 05'),
    (006, 'Karminah', 081234567895, 'Juru Masak', '2022-01-01', 3900000, 'Perempuan', 'Jl. Raya Singosari No. 06'),
    (007, 'Siti', 081234567896, 'Juru Masak', '2022-01-01', 3900000, 'Perempuan', 'Jl. Simbar Menjangan No. 08');

-- menampilkan data pegawai
SELECT * FROM employee;

INSERT INTO `order` (id, time, payment_method, total, payment, money_change, employee_id) VALUES
    (001, '2024-06-06 07:30:00', 'Cash', 80000, 10000, 2000, 004),
    (002, '2024-06-06 09:00:00', 'Cash', 10000, 10000, NULL, 004),
    (003, '2022-06-06 10:30:00', 'Qris', 15000, 15000, NULL, 004),
    (004, '2022-06-06 14:00:00', 'Qris', 10000, 15000, NULL, 004),
    (005, '2022-06-06 20:30:00', 'Cash', 10000, 15000, 5000, 004),
    (006, '2022-06-07 12:00:00', 'Qris', 50000, 50000, NULL, 004),
    (007, '2022-06-07 15:45:00', 'Cash', 40000, 50000, 10000, 004),
    (008, '2022-06-07 18:55:00', 'Qris', 14000, 14000, NULL, 004),
    (009, '2022-06-08 08:00:00', 'Qris', 20000, 20000, NULL, 004),
    (010, '2022-06-08 15:00:00', 'Cash', 23000, 25000, 2000, 004);

-- menampilkan data order / pesanan dari customer
SELECT * FROM `order`;

INSERT INTO detail_order (id, price_unit, quantity, item_id, order_id) VALUES
    (001, 4000, 1, 101, 001),
    (002, 1000, 2, 102, 002),
    (003, 2000, 1, 103, 003),
    (004, 2000, 2, 104, 004),
    (005, 2000, 4, 105, 005),
    (006, 6000, 1, 106, 006),
    (007, 2000, 3, 107, 007),
    (008, 3000, 1, 108, 008),
    (009, 2000, 1, 109, 009),
    (010, 2000, 1, 110, 010);

-- menampilkan detail order / detail pesanan dari customer
SELECT * FROM detail_order;

INSERT INTO attendance (id, shift, attendace_date, attendance_status, employee_id) VALUES
    (001, 'Pagi', '2022-06-06 07:30:00', 'Hadir', 004),
    (002, 'Pagi', '2022-06-06 09:00:00', 'Hadir', 004),
    (003, 'Pagi', '2022-06-06 10:30:00', 'Hadir', 004),
    (004, 'Sore', '2022-06-06 12:00:00', 'Hadir', 004),
    (005, 'Sore', '2022-06-06 12:00:00', 'Hadir', 005),
    (006, 'Sore', '2022-06-06 12:00:00', 'Hadir', 006),
    (007, 'Sore', '2022-06-06 12:00:00', 'Absen', 007);

-- menampilkan presensi pegawai
SELECT * FROM attendance;

INSERT INTO ingredients (id, description, price, quantity, name) VALUES
    (001, 'Bawang Merah', 50000, '5 kg', 'Bawang Merah'),
    (002, 'Bawang Putih', 60000, '5 kg', 'Bawang Putih'),
    (003, 'Cabai Merah', 120000, '6 kg', 'Cabai Merah'),
    (004, 'Cabai Rawit', 150000, '5 kg', 'Cabai Rawit'),
    (005, 'Garam', 20000, '5 pcs', 'Garam'),
    (006, 'Gula', 60000, '5 kg', 'Gula'),
    (007, 'Kecap', 200000, '10 botol', 'Kecap'),
    (008, 'Minyak Goreng', 200000, '4 liter', 'Minyak Goreng'),
    (009, 'Tepung Terigu', 50000, '5 kg', 'Tepung Terigu'),
    (010, 'Telur', 60000, '5 kg', 'Telur');

-- menampilkan ingredients / bahan mentah untuk masakan milik owner
SELECT * FROM ingredients;

