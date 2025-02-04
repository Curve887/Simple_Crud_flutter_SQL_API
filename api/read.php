<?php
header("Access-Control-Allow-Origin: *"); // Izinkan akses dari semua domain
header("Access-Control-Allow-Methods: GET, POST, OPTIONS"); // Izinkan metode yang diperlukan
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8"); // Pastikan respons dalam format JSON

// Koneksi ke database
$koneksi = new mysqli('localhost', 'root', '', 'db_produk');

// Cek koneksi
if ($koneksi->connect_error) {
    die(json_encode(["status" => "error", "message" => "Koneksi database gagal: " . $koneksi->connect_error]));
}

// Query untuk mengambil data dari tabel tb_produk
$query = $koneksi->query("SELECT * FROM tb_produk");

// Cek apakah query berhasil
if ($query) {
    $data = $query->fetch_all(MYSQLI_ASSOC);
    echo json_encode(["status" => "success", "data" => $data], JSON_PRETTY_PRINT);
} else {
    echo json_encode(["status" => "error", "message" => "Gagal mengambil data"]);
}

// Tutup koneksi
$koneksi->close();
?>
