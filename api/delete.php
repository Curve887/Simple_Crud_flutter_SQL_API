<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Content-Type: application/json; charset=UTF-8");

$koneksi = new mysqli('localhost', 'root', '', 'db_produk');

$id_produk = $_POST['id_produk'];

$data = mysqli_query($koneksi, "delete from tb_produk where id_produk='$id_produk'");

if ($data) {
    echo json_encode([
        'status' => 'success',
        'pesan' => 'Sukses delete'
    ]);
} else {
    echo json_encode([
        'status' => 'error',
        'pesan' => 'Gagal delete'
    ]);
}
