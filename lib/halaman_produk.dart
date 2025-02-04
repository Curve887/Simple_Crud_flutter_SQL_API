import 'dart:convert';
import 'package:app_produk/detail_produk.dart';
import 'package:app_produk/edit_produk.dart';
import 'package:app_produk/tambah_produk.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HalamanProduk extends StatefulWidget {
  const HalamanProduk({super.key});

  @override
  State<HalamanProduk> createState() => _HalamanProdukState();
}

class _HalamanProdukState extends State<HalamanProduk> {
  List _listdata = [];
  bool _loading = true;

  Future _getdata() async {
    setState(() {
      _loading = true; // Pastikan loading aktif sebelum mulai fetch data
    });

    try {
      final respon =
          await http.get(Uri.parse('http://192.168.1.14/api_produk/read.php'));

      if (respon.statusCode == 200) {
        final jsonResponse = jsonDecode(respon.body);

        if (jsonResponse is Map &&
            jsonResponse.containsKey('status') &&
            jsonResponse['status'] == 'success') {
          setState(() {
            _listdata = jsonResponse['data'] ?? []; // Pastikan selalu List
            _loading = false; // Matikan loading setelah data dimuat
          });
        } else {
          print("Error: Format JSON tidak sesuai atau status gagal.");
          setState(() {
            _loading = false; // Tetap matikan loading meskipun data gagal
          });
        }
      } else {
        print("Server Error: ${respon.statusCode}");
        setState(() {
          _loading = false; // Matikan loading jika server error
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        _loading = false; // Tetap matikan loading jika terjadi error
      });
    }
  }

  Future<bool> _hapus(String id) async {
    try {
      final respon = await http.post(
        Uri.parse('http://192.168.1.14/api_produk/delete.php'),
        body: {"id_produk": id},
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
      );

      if (respon.statusCode == 200) {
        final jsonResponse = jsonDecode(respon.body);
        if (jsonResponse['status'] == 'success') {
          print("Produk berhasil dihapus");
          return true;
        } else {
          print("Gagal menghapus produk: ${jsonResponse['pesan']}");
          return false;
        }
      } else {
        print("Server Error: ${respon.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error saat menghapus produk: $e");
      return false;
    }
  }

  @override
  void initState() {
    _getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Produk'),
        backgroundColor: Colors.deepOrange,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _listdata.length,
              itemBuilder: ((context, index) {
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailProduk(
                                    ListData: {
                                      'id_produk': _listdata[index]
                                          ['id_produk'],
                                      'nama_produk': _listdata[index]
                                          ['nama_produk'],
                                      'harga_produk': _listdata[index]
                                          ['harga_produk'],
                                    },
                                  )));
                    },
                    child: ListTile(
                      title: Text(_listdata[index]['nama_produk']),
                      subtitle: Text("Rp ${_listdata[index]['harga_produk']}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UbahProduk(
                                              ListData: {
                                                'id_produk': _listdata[index]
                                                    ['id_produk'],
                                                'nama_produk': _listdata[index]
                                                    ['nama_produk'],
                                                'harga_produk': _listdata[index]
                                                    ['harga_produk'],
                                              },
                                            )));
                              },
                              icon: Icon(Icons.edit)),
                          IconButton(
                              onPressed: () {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: ((context) {
                                      return AlertDialog(
                                        content: Text('Hapus Data Ini ?'),
                                        actions: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.deepOrange,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            onPressed: () async {
                                              bool berhasil = await _hapus(
                                                  _listdata[index]
                                                      ['id_produk']);

                                              if (berhasil) {
                                                // Navigasi ke HalamanProduk dan menghapus riwayat halaman sebelumnya
                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          HalamanProduk()),
                                                  (Route<dynamic> route) =>
                                                      false, // Menghapus semua halaman sebelumnya
                                                );

                                                // Tampilkan snackbar setelah navigasi
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                          'Produk berhasil dihapus')),
                                                );
                                              }
                                            },
                                            child: Text(
                                              'Hapus',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.deepOrange),
                                              child: Text(
                                                style: TextStyle(
                                                    color: Colors.white),
                                                "Batal",
                                              )),
                                        ],
                                      );
                                    }));
                              },
                              icon: Icon(Icons.delete))
                        ],
                      ), // Sesuaikan dengan API
                    ),
                  ),
                );
              }),
            ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepOrange,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TambahProduk()));
          }),
    );
  }
}
