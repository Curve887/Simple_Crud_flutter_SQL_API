import 'package:app_produk/halaman_produk.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UbahProduk extends StatefulWidget {
  final Map ListData;
  const UbahProduk({super.key, required this.ListData});

  @override
  State<UbahProduk> createState() => _UbahProdukState();
}

class _UbahProdukState extends State<UbahProduk> {
  final formKey = GlobalKey<FormState>();
  TextEditingController id_produk = TextEditingController();
  TextEditingController nama_produk = TextEditingController();
  TextEditingController harga_produk = TextEditingController();

  Future<bool> _ubah() async {
    try {
      final respon = await http.post(
        Uri.parse('http://192.168.1.14/api_produk/edit.php'),
        body: {
          'id_produk': id_produk.text,
          'nama_produk': nama_produk.text,
          'harga_produk': harga_produk.text,
        },
      );

      if (respon.statusCode == 200) {
        return true;
      } else {
        print("Gagal menyimpan: ${respon.body}");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    id_produk.text = widget.ListData['id_produk'];
    nama_produk.text = widget.ListData['nama_produk'];
    harga_produk.text = widget.ListData['harga_produk'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Ubah produk'),
      ),
      body: Form(
          key: formKey,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                TextFormField(
                  controller: nama_produk,
                  decoration: InputDecoration(
                      hintText: 'nama_produk',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      )),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Nama Produk tidak Boleh kosong!";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: harga_produk,
                  decoration: InputDecoration(
                      hintText: 'harga_produk',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      )),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Harga Produk tidak Boleh kosong!";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        )),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        _ubah().then((value) {
                          if (value) {
                            final snackBar = SnackBar(
                              content: const Text('Data Berhasil Diubah'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            return false;
                          }
                        });
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => HalamanProduk())),
                            (Route) => false);
                      }
                    },
                    child: Text(
                      'Ubah',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          )),
    );
  }
}
