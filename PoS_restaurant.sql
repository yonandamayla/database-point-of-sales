
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
    shift VARCHAR (100),
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

-- karena sebelumnya belum ada atribut tanggal untuk pengeluaran, maka kita tambahkan atribut tanggal pada tabel expense
ALTER TABLE expense ADD COLUMN expense_date DATE;




INSERT INTO supplier_item (id, quantity, price, no_telp, name) VALUES 
    (300, 20, 4000, 089635247835, 'Roida'),
    (301, 25, 5000, 089753268632, 'Rozi'),
    (302, 10, 6000, 089782658735, 'Hainan');

-- menampilkan supplier siapa saja yang menitipkan item
SELECT * FROM supplier_item;

/*10* = makanan dan minuman owner
13* = makanan dan minuman supplier*/
INSERT INTO item (id, name, price, supplier_item_id) VALUES 
    (101, 'Chicken Crispy', 6000, NULL),
    (102, 'Telur dadar', 3000, NULL),
    (131, 'Empal daging', 5000, 300),
    (132, 'Trili', 6000, 301),
    (133, 'Telur gulung', 7000, 302),
    (103, 'Es teh', 3000, NULL);

-- menampilkan item yang dijual di warung makan (makanan, minuman), baik dari supplier maupun buatan sendiri
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
    (001, '2024-06-01 07:01:00', 'Cash', 30000, 50000, 20000, 002),
    (002, '2024-06-01 10:01:00', 'Qris', 50000, 50000, 0, 002),
    (003, '2024-06-01 11:05:00', 'Cash', 48000, 100000, 52000, 002),
    (004, '2024-05-04 15:00:20', 'Qris', 45000, 45000, 0, 002),
    (005, '2024-05-05 18:00:00', 'Cash', 70000, 100000, 30000, 005),
    (006, '2024-05-05 18:10:59', 'Qris', 6000, 6000, 0, 005);

-- menampilkan data order / pesanan dari customer
SELECT * FROM `order`;

-- menampilkan transaksi yang menggunakan metode pembayaran Qris
SELECT * FROM `order` WHERE payment_method = 'Qris';

-- menampilkan transaksi yang menggunakan metode pembayaran Cash
SELECT * FROM `order` WHERE payment_method = 'Cash';

-- menampilkan transaksi berdasarkan id ordernya
SELECT * FROM `order` WHERE id = 1;

-- menampilkan transaksi berdasarkan employee id 002
SELECT * FROM `order` WHERE employee_id = 002;

-- menampilkan transaksi berdasarkan employee id 005
SELECT * FROM `order` WHERE employee_id = 005;

-- menampilkan item yang paling sering dibeli / banyak diorder
SELECT item_id, COUNT(item_id) as TotalOrder FROM detail_order GROUP BY item_id ORDER BY TotalOrder DESC LIMIT 1;

-- menampilkan item yang dibeli dan total orderannya
SELECT item_id, COUNT(item_id) as TotalOrder FROM detail_order GROUP BY item_id ORDER BY TotalOrder DESC;

-- menghitung order dengan total transaksi terbanyak
SELECT order_id, SUM(price_unit * quantity) as TotalTransaction FROM detail_order GROUP BY order_id ORDER BY TotalTransaction DESC LIMIT 1;

-- mengurutkan order dengan total transkasaksi terbanyak ke terendah
SELECT order_id, SUM(price_unit * quantity) as TotalTransaction FROM detail_order GROUP BY order_id ORDER BY TotalTransaction DESC;

-- menampilkan transaksi per hari (SOLUSI) --> karena sebelumnya masih berdasarkan perkiraan
SELECT DATE(time) as Date, COUNT(*) as TotalTransactions
FROM `order`
GROUP BY DATE(time)
ORDER BY Date;

-- menampilkan transaksi per bulan
SELECT DATE_FORMAT(time, '%Y-%m') as Month, COUNT(*) as TotalTransactions
FROM `order`
GROUP BY DATE_FORMAT(time, '%Y-%m')
ORDER BY Month;

INSERT INTO detail_order (id, price_unit, quantity, item_id, order_id) VALUES
    (001, 6000, 5, 101, 001),
    (002, 5000, 10, 102, 002),
    (003, 6000, 8, 131, 003),
    (004, 3000, 15, 132, 004),
    (005, 7000, 10, 133, 005),
    (006, 3000, 2, 103, 006);

-- menampilkan detail order / detail pesanan dari customer
SELECT * FROM detail_order;

INSERT INTO attendance (id, shift, attendace_date, attendance_status, employee_id) VALUES
    (111, '07:00 - 17:00', '2024-05-01','Hadir', 001),
    (222, '10:00 - 22:00', '2024-05-02','Hadir', 001),
    (333, '07:00 - 17:00', '2024-06-01','Hadir', 002),
    (444, '10:00 - 22:00', '2024-06-03','Hadir', 003),
    (555, '07:00 - 17:00', '2024-05-04','Hadir', 004),
    (666, '10:00 - 22:00', '2024-05-05','Hadir', 005);

-- menampilkan presensi pegawai
SELECT * FROM attendance;

INSERT INTO ingredients (id, description, price, quantity, name) VALUES
    (200, 'Toko Sanjaya Pak Iwan', 30000, '10 kg', 'Ayam'),
    (201, 'Toko Bu Anna(Tepung terigu lancana merah) ', 10000, '25 kg', 'Tepung Terigu'),
    (202, 'Toko Bu Anna(Bimoli) ', 20000, '18 L', 'Minyak Goreng'),
    (203, 'Toko Sanjaya Pak Iwan', 30000, '10 kg', 'Telur');

-- menampilkan ingredients / bahan mentah untuk masakan milik owner
SELECT * FROM ingredients;

INSERT INTO expense (id, category, total, employee_id, ingredients_id, expense_date) VALUES
    (1540, 'Buy ingredients', 300000, NULL, 200, '2024-05-01'),
    (1541, 'Buy ingredients', 250000, NULL, 201,'2024-05-01'),
    (1542, 'Buy ingredients', 360000, NULL, 202, '2024-05-01'),
    (1543, 'Gaji Pegawai', 130000, 001, NULL, '2024-05-01'),
    (25430, 'Buy ingredients', 300000, NULL, 203, '2024-05-02'),
    (25431, 'Gaji Pegawai', 130000, 002, NULL, '2024-05-02'),
    (1544, 'Sewa Tempat', 1000000, NULL, NULL, '2024-06-01'),
    (1545, 'Gaji Pegawai', 100000, 002, NULL, '2024-06-01'),
    (3540, 'Gaji Pegawai', 90000, 003, NULL, '2024-06-03'),
    (4540, 'Gaji Pegawai', 90000, 004, NULL, '2024-05-04'),
    (5540, 'Gaji Pegawai', 110000, 005, NULL, '2024-05-05');

-- menghitung jumlah pengeluaran per hari beserta tanggal pengeluaran (tapi, mitra masih manual, soalnya tidak ada pencatatan)
SELECT expense_date, SUM(total) as TotalExpense FROM expense GROUP BY expense_date;

-- menampilkan pengeluaran
SELECT * FROM expense;

-- fungsi untuk menghitung total pengeluaran per hari beserta apa saja yang dikeluarkan
DELIMITER //
CREATE FUNCTION `calculate_daily_expense`(date DATE) RETURNS TEXT
BEGIN
    DECLARE expense_list TEXT;
    DECLARE total_expense INT;

    -- Get the total expense for the given date
    SELECT SUM(total) INTO total_expense
    FROM expense
    WHERE expense_date = date;

    -- Get the list of expenses for the given date
    SELECT GROUP_CONCAT(CONCAT('ID: ', id, ', Category: ', category, ', Total: ', total) SEPARATOR '\n')
    INTO expense_list
    FROM expense
    WHERE expense_date = date;

    -- Return the result
    RETURN CONCAT('Total Expense for ', date, ': ', total_expense, '\n', expense_list);
END//
DELIMITER ;

-- menampilkan total pengeluaran per hari beserta apa saja yang dikeluarkan
SELECT `calculate_daily_expense`('2024-05-01');

-- fungsi untuk menghitung total pengeluaran per bulan beserta apa saja yang dikeluarkan
DELIMITER //
CREATE FUNCTION `calculate_monthly_expense`(month DATE) RETURNS TEXT
BEGIN
    DECLARE expense_list TEXT;
    DECLARE total_expense INT;

    -- Get the total expense for the given month
    SELECT SUM(total) INTO total_expense
    FROM expense
    WHERE MONTH(expense_date) = MONTH(month) AND YEAR(expense_date) = YEAR(month);

    -- Get the list of expenses for the given month
    SELECT GROUP_CONCAT(CONCAT('ID: ', id, ', Category: ', category, ', Total: ', total) SEPARATOR '\n')
    INTO expense_list
    FROM expense
    WHERE MONTH(expense_date) = MONTH(month) AND YEAR(expense_date) = YEAR(month);

    -- Return the result
    RETURN CONCAT('Total Expense for ', DATE_FORMAT(month, '%Y-%m'), ': ', total_expense, '\n', expense_list);
END//
DELIMITER ;

DROP FUNCTION IF EXISTS `calculate_monthly_expense`;

-- menampilkan total pengeluaran per bulan beserta apa saja yang dikeluarkan
SELECT `calculate_monthly_expense`('2024-06-01');

-- menghitung keuntungan item yang diambil dari harga supplier
DELIMITER //
CREATE FUNCTION `calculate_item_profit`(item_id INT) RETURNS DECIMAL(10,2)
BEGIN
    DECLARE item_price DECIMAL(10,2);
    DECLARE supplier_price DECIMAL(10,2);
    DECLARE profit DECIMAL(10,2);

    -- Get the price of the item from the item table
    SELECT price INTO item_price
    FROM item
    WHERE id = item_id;

    -- Get the supplier price of the item from the supplier_item table
    SELECT price INTO supplier_price
    FROM supplier_item
    WHERE id = (SELECT supplier_item_id FROM item WHERE id = item_id);

    -- Calculate the profit
    SET profit = item_price - supplier_price;

    RETURN profit;
END//
DELIMITER ;

SELECT `calculate_item_profit`(132);

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

-- perhitungan laba bersih per hari (pendapatan - pengeluaran/ total order - expense)
-- DELIMITER //
-- CREATE FUNCTION `calculate_daily_hpp`(date DATE) RETURNS DECIMAL(10,2)
-- BEGIN
--     DECLARE total_income DECIMAL(10,2);
--     DECLARE total_expense DECIMAL(10,2);
--     DECLARE hpp DECIMAL(10,2);

--     -- Get the total income for the given date
--     SELECT SUM(total) INTO total_income
--     FROM `order`
--     WHERE DATE(time) = date;

--     -- Get the total expense for the given date
--     SELECT SUM(total) INTO total_expense
--     FROM expense
--     WHERE expense_date = date;

--     -- Calculate the HPP
--     SET hpp = total_income - total_expense;

--     RETURN hpp;
-- END//
-- DELIMITER ;

-- -- menampilkan laba bersih per hari+

-- SELECT `calculate_daily_hpp`('2024-05-01');