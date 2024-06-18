-- SQLBook: Code
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
    attendace_date VARCHAR (100),
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
    (300, 20, 4000, 089635247835, 'Roida'),
    (301, 25, 5000, 089753268632, 'Rozi'),
    (302, 10, 6000, 089782658735, 'Hainan');

-- menampilkan item dari supplier dan siapa suppliernya
SELECT * FROM supplier_item;

/*10* = makanan dan minuman owner
13* = makanan dan minuman supplier*/
INSERT INTO item (id, name, price, supplier_item_id) VALUES 
    (101, 'Ayam Krispy', 6000, NULL),
    (102, 'Telur Dadar', 3000, NULL),
    (131, 'Empal Daging', 5000, 300),
    (132, 'Trili', 6000, 301),
    (133, 'Telur Gulung', 7000, 302),
    (103, 'Es Teh', 3000, NULL);

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
    (001, 'Ilham Maulana', 085876542787, 'Juru Masak', '2022-01-01', 130000, 'Laki - Laki', 'Jl. Senggani No.22'),
    (002, 'Ayla Zahra', 0896432685423, 'Kasir', '2023-05-05', 100000, 'Perempuan', 'Jl. Remujung Barat No.78'),
    (003, 'Nurul Hidayah', 0897423864388, 'Pelayan', '2023-11-06', 90000, 'Perempuan', 'Jl. Soekarno No. 12'),
    (004, 'Sodikin', 0897624384659, 'Pelayan', '2023-12-06', 90000, 'Laki - Laki', 'Jl. Hatta No. 32'),
    (005, 'Aisyha', 0897643857354, 'Kasir', '2022-12-07', 110000, 'Perempuan', 'Jl. Buah Manggis No. 34');

-- menampilkan data pegawai
SELECT * FROM employee;

INSERT INTO `order` (id, time, payment_method, total, payment, money_change, employee_id) VALUES
    (001, '2024-05-01 07:01:00', 'Cash', 30000, 50000, 20000, 002),
    (002, '2024-05-01 10:01:00', 'Qris', 50000, 50000, NULL, 002),
    (003, '2022-05-03 11:05:00', 'Cash', 48000, 100000, 52000, 002),
    (004, '2022-05-04 15:00:20', 'Qris', 45000, 45000, NULL, 002),
    (005, '2022-05-05 18:00:00', 'Cash', 70000, 100000, 30000, 005),
    (006, '2022-05-02 18:10:59', 'Qris', 6000, 6000, NULL, 005);

-- menampilkan data order / pesanan dari customer
SELECT * FROM `order`;

-- menampilkan transaksi yang menggunakan metode pembayaran Qris
SELECT * FROM `order` WHERE payment_method = 'Qris';

-- menampilkan transaksi yang menggunakan metode pembayaran Cash
SELECT * FROM `order` WHERE payment_method = 'Cash';

-- menampilkan transaksi berdasarkan id 1
SELECT * FROM `order` WHERE id = 1;

-- menampilkan transaksi berdasarkan employee id 002
SELECT * FROM `order` WHERE employee_id = 002;

-- menampilkan transaksi berdasarkan employee id 005
SELECT * FROM `order` WHERE employee_id = 005;

-- menampilkan item yang paling sering dibeli
SELECT item_id, COUNT(item_id) as TotalItem FROM detail_order GROUP BY item_id ORDER BY TotalItem DESC LIMIT 1;

-- menghitung order dengan total transaksi terbanyak
SELECT order_id, SUM(price_unit * quantity) as TotalTransaction FROM detail_order GROUP BY order_id ORDER BY TotalTransaction DESC LIMIT 1;

-- mengurutkan order dengan total transkasaksi terbanyak ke terendah
SELECT order_id, SUM(price_unit * quantity) as TotalTransaction FROM detail_order GROUP BY order_id ORDER BY TotalTransaction DESC;

INSERT INTO detail_order (id, price_unit, quantity, item_id, order_id) VALUES
    (001, 6000, 5, 101, 001),
    (002, 5000, 10, 102, 002),
    (003, 6000, 8, 131, 003),
    (004, 3000, 15, 132, 004),
    (005, 7000, 10, 133, 001),
    (006, 3000, 2, 103, 002);

-- menampilkan detail order / detail pesanan dari customer
SELECT * FROM detail_order;

-- menampilkan total transaksi per hari

-- menampilkan total jumlah transaksi per bulan

INSERT INTO attendance (id, shift, attendace_date, attendance_status, employee_id) VALUES
    (111, '07:00 - 17:00', '2024-05-01','Hadir', 001),
    (222, '07:00 - 17:00', '2024-05-01','Hadir', 002),
    (333, '10:00 - 22:00', '2024-05-03','Hadir', 003),
    (444, '07:00 - 17:00', '2024-05-04','Hadir', 004),
    (555, '10:00 - 22:00', '2024-05-05','Hadir', 005),
    (666, '10:00 - 22:00', '2024-05-02','Hadir', 001);

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

INSERT INTO expense (id, category, total, employee_id, ingredients_id) VALUES
    (001, 'Gaji Karyawan', 3000000, 004, NULL),
    (002, 'Gaji Karyawan', 2500000, 005, NULL),
    (003, 'Gaji Karyawan', 3900000, 006, NULL),
    (004, 'Gaji Karyawan', 3900000, 007, NULL),
    (005, 'Listrik', 500000, NULL, NULL),
    (006, 'Air', 300000, NULL, NULL),
    (007, 'Gas', 200000, NULL, NULL),
    (008, 'Sewa Bangunan', 1000000, NULL, NULL),
    (009, 'Ingredients', 500000, NULL, 001),
    (010, 'Ingredients', 600000, NULL, 002),
    (011, 'Ingredients', 1200000, NULL, 003),
    (012, 'Ingredients', 1500000, NULL, 004),
    (013, 'Ingredients', 200000, NULL, 005),
    (014, 'Ingredients', 600000, NULL, 006),
    (015, 'Ingredients', 2000000, NULL, 007),
    (016, 'Ingredients', 2000000, NULL, 008),
    (017, 'Ingredients', 500000, NULL, 009),
    (018, 'Ingredients', 600000, NULL, 010);

-- menampilkan pengeluaran
SELECT * FROM expense;

-- fungsi untuk menghitung total pengeluaran per hari

-- fungsi untuk menghitung total pengeluaran per bulan

-- perhitungan laba bersih per hari (pendapatan - pengeluaran/ total order - expense)

-- menghitung keuntungan dari supplier

-- menghitung keuntungan owner


-- fungsi untuk membuat struk pembayaran
DELIMITER //
CREATE FUNCTION generate_receipt(order_id INT)
RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE receipt TEXT;
    SELECT GROUP_CONCAT(CONCAT('Order ID: ', o.id, '\nItem: ', i.name, '\nQuantity: ', do.quantity, '\nTotal Price: ', do.quantity * i.price, '\n-------------------') SEPARATOR '\n')
    INTO receipt
    FROM `order` o
    INNER JOIN detail_order do ON o.id = do.order_id
    INNER JOIN item i ON do.item_id = i.id
    WHERE o.id = order_id;
    RETURN receipt;
END//
DELIMITER ;

DROP FUNCTION IF EXISTS generate_receipt;

-- menampilkan struk pembayaran untuk order dengan id 1
SELECT generate_receipt(1);