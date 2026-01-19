CREATE DATABASE IF NOT EXISTS db_toko_cctv;
USE db_toko_cctv;

-- 1. Tabel Kasir
-- Menyimpan informasi staf yang melayani transaksi
CREATE TABLE kasir (
    id_kasir INT AUTO_INCREMENT PRIMARY KEY,
    nama_kasir VARCHAR(100) NOT NULL,
    username VARCHAR(50) UNIQUE,
    telepon VARCHAR(15)
);

-- 2. Tabel Pelanggan
-- Menyimpan data pembeli
CREATE TABLE pelanggan (
    id_pelanggan INT AUTO_INCREMENT PRIMARY KEY,
    nama_pelanggan VARCHAR(100) NOT NULL,
    telepon VARCHAR(15),
    alamat TEXT
);

-- 3. Tabel Produk
-- Menyimpan daftar CCTV dan perlengkapannya
CREATE TABLE produk (
    id_produk INT AUTO_INCREMENT PRIMARY KEY,
    nama_produk VARCHAR(150) NOT NULL,
    merk VARCHAR(50),
    harga DECIMAL(12, 2) NOT NULL,
    stok INT DEFAULT 0
);

-- 4. Tabel Transaksi
-- Header transaksi (siapa yang beli, kapan, dan siapa yang melayani)
CREATE TABLE transaksi (
    id_transaksi INT AUTO_INCREMENT PRIMARY KEY,
    id_kasir INT,
    id_pelanggan INT,
    tanggal_transaksi DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_bayar DECIMAL(12, 2),
    FOREIGN KEY (id_kasir) REFERENCES kasir(id_kasir),
    FOREIGN KEY (id_pelanggan) REFERENCES pelanggan(id_pelanggan)
);

-- 5. Tabel Detail Transaksi
-- Rincian barang apa saja yang dibeli dalam satu struk
CREATE TABLE detail_transaksi (
    id_detail INT AUTO_INCREMENT PRIMARY KEY,
    id_transaksi INT,
    id_produk INT,
    jumlah INT NOT NULL,
    subtotal DECIMAL(12, 2) NOT NULL,
    FOREIGN KEY (id_transaksi) REFERENCES transaksi(id_transaksi),
    FOREIGN KEY (id_produk) REFERENCES produk(id_produk)
);

-- 6. Tabel Pembayaran
-- Informasi cara pembayaran (Cash/Transfer/Debit)
CREATE TABLE pembayaran (
    id_pembayaran INT AUTO_INCREMENT PRIMARY KEY,
    id_transaksi INT,
    metode_pembayaran ENUM('Tunai', 'Transfer', 'Debit', 'Kredit') NOT NULL,
    jumlah_uang_diterima DECIMAL(12, 2),
    kembalian DECIMAL(12, 2),
    status_pembayaran VARCHAR(20) DEFAULT 'Lunas',
    FOREIGN KEY (id_transaksi) REFERENCES transaksi(id_transaksi)
);

-- ==========================================
-- PENGISIAN DATA SAMPEL (DML)
-- ==========================================

-- Mengisi Data Kasir
INSERT INTO kasir (nama_kasir, username, telepon) VALUES 
('Ahmad Fauzi', 'ahmad_f', '081234567890'),
('Siti Aminah', 'sitia', '081298765432');

-- Mengisi Data Pelanggan
INSERT INTO pelanggan (nama_pelanggan, telepon, alamat) VALUES 
('Budi Santoso', '085511223344', 'Jl. Merdeka No. 10, Jakarta'),
('Ani Wijaya', '085577889900', 'Perum Indah Blok C, Tangerang');

-- Mengisi Data Produk CCTV
INSERT INTO produk (nama_produk, merk, harga, stok) VALUES 
('CCTV Indoor 2MP Dome', 'Hikvision', 350000.00, 50),
('CCTV Outdoor 5MP Bullet', 'Dahua', 650000.00, 30),
('DVR 4 Channel 1080P', 'Hikvision', 850000.00, 10),
('Harddisk 1TB WD Purple', 'Western Digital', 750000.00, 15),
('Kabel Coaxial RG59 + Power (100m)', 'BNC', 450000.00, 5);

-- Mengisi Data Transaksi (Struk 1)
INSERT INTO transaksi (id_kasir, id_pelanggan, tanggal_transaksi, total_bayar) 
VALUES (1, 1, '2023-10-25 10:30:00', 2200000.00);

-- Mengisi Detail Transaksi (Struk 1)
-- Budi membeli: 2 Indoor CCTV, 1 DVR, 1 Harddisk
INSERT INTO detail_transaksi (id_transaksi, id_produk, jumlah, subtotal) VALUES 
(1, 1, 2, 700000.00),
(1, 3, 1, 850000.00),
(1, 4, 1, 750000.00);

-- Mengisi Data Pembayaran (Struk 1)
INSERT INTO pembayaran (id_transaksi, metode_pembayaran, jumlah_uang_diterima, kembalian) 
VALUES (1, 'Tunai', 2500000.00, 300000.00);

-- ==========================================
-- QUERY UNTUK MENAMPILKAN STRUK
-- ==========================================
SELECT 
    t.id_transaksi AS 'No Struk',
    t.tanggal_transaksi AS 'Tanggal',
    k.nama_kasir AS 'Kasir',
    p.nama_pelanggan AS 'Pelanggan',
    pr.nama_produk AS 'Item',
    dt.jumlah AS 'Qty',
    dt.subtotal AS 'Subtotal',
    t.total_bayar AS 'Total',
    bayar.metode_pembayaran AS 'Metode',
    bayar.jumlah_uang_diterima AS 'Bayar',
    bayar.kembalian AS 'Kembali'
FROM transaksi t
JOIN kasir k ON t.id_kasir = k.id_kasir
JOIN pelanggan p ON t.id_pelanggan = p.id_pelanggan
JOIN detail_transaksi dt ON t.id_transaksi = dt.id_transaksi
JOIN produk pr ON dt.id_produk = pr.id_produk
JOIN pembayaran bayar ON t.id_transaksi = bayar.id_transaksi
WHERE t.id_transaksi = 1;