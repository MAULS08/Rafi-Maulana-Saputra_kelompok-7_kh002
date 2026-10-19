
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

// Function ini untuk membuat aplikasi dan mengatur tema.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pencatatan Stok Barang',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

// Function ini untuk menampilkan form pencatatan stok barang.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  final namaController = TextEditingController();
  final masukController = TextEditingController();
  final keluarController = TextEditingController();
  final kodeController = TextEditingController();
  final stokController = TextEditingController();

  bool sedangMenyimpan = false;

  // Function ini untuk memvalidasi kode barang.
  // NIM ganjil 20240801195: tiga digit terakhir adalah 195.
  // Contoh kode: 123.195 (enam digit angka).
  String? validasiKode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Kode barang wajib diisi';
    }

    final kode = value.trim();
    final pola = RegExp(r'^\d+\.\d+$');

    if (!pola.hasMatch(kode)) {
      return 'Gunakan format desimal, contoh 123.195';
    }

    final bagian = kode.split('.');
    final jumlahDigit =
        bagian[0].length + bagian[1].length;

    if (jumlahDigit < 6) {
      return 'Kode barang minimal 6 digit angka';
    }

    if (bagian[1].length != 3 ||
        bagian[1] != '195') {
      return 'Tiga digit desimal harus berakhir dengan 195';
    }

    if (double.tryParse(kode) == null) {
      return 'Kode barang tidak valid';
    }

    return null;
  }

  // Function ini untuk memvalidasi jumlah stok.
  String? validasiStok(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Jumlah stok wajib diisi';
    }

    final stok = int.tryParse(value.trim());

    if (stok == null) {
      return 'Jumlah stok harus bilangan bulat';
    }

    if (stok < 0) {
      return 'Jumlah stok tidak boleh negatif';
    }

    return null;
  }

  // Function ini untuk menyimpan data ke Firestore.
  Future<void> simpanBarang() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      sedangMenyimpan = true;
    });

    try {
      final String nama = namaController.text.trim();
      final String tanggalMasuk =
      masukController.text.trim();
      final String tanggalKeluar =
      keluarController.text.trim();

      // Konversi kode barang menjadi angka desimal.
      final double kode =
      double.parse(kodeController.text.trim());

      // Konversi jumlah stok menjadi integer.
      final int stok =
      int.parse(stokController.text.trim());

      await FirebaseFirestore.instance
          .collection('stok_barang')
          .add({
        'nama_barang': nama,
        'tanggal_masuk': tanggalMasuk,
        'tanggal_keluar': tanggalKeluar,
        'kode_barang': kode,
        'jumlah_stok': stok,
        'waktu': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      // Kosongkan seluruh input setelah berhasil.
      namaController.clear();
      masukController.clear();
      keluarController.clear();
      kodeController.clear();
      stokController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Barang berhasil disimpan!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan barang: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          sedangMenyimpan = false;
        });
      }
    }
  }

  // Function ini untuk membuat komponen input.
  Widget buatField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType keyboard = TextInputType.text,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          prefixIcon: const Icon(Icons.inventory_2_outlined),
        ),
      ),
    );
  }

  // Function ini untuk membebaskan controller saat halaman ditutup.
  @override
  void dispose() {
    namaController.dispose();
    masukController.dispose();
    keluarController.dispose();
    kodeController.dispose();
    stokController.dispose();
    super.dispose();
  }

  // Function ini untuk menampilkan seluruh form aplikasi.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stok Barang'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.inventory_2,
                size: 64,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 12),
              const Text(
                'Form Pencatatan Stok Barang',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              buatField(
                label: 'Nama Barang',
                hint: 'Contoh: R - Buku Tulis',
                controller: namaController,
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Nama barang wajib diisi';
                  }
                  return null;
                },
              ),

              buatField(
                label: 'Tanggal Masuk Barang',
                hint: 'Contoh: 16-10-2026',
                controller: masukController,
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Tanggal masuk wajib diisi';
                  }
                  return null;
                },
              ),

              buatField(
                label: 'Tanggal Keluar Barang',
                hint: 'Contoh: 20-10-2026',
                controller: keluarController,
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Tanggal keluar wajib diisi';
                  }
                  return null;
                },
              ),

              buatField(
                label: 'Kode Barang',
                hint: 'Contoh: 123.195',
                controller: kodeController,
                keyboard: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: validasiKode,
              ),

              buatField(
                label: 'Jumlah Stok',
                hint: 'Contoh: 25',
                controller: stokController,
                keyboard: TextInputType.number,
                validator: validasiStok,
              ),

              const SizedBox(height: 8),

              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: sedangMenyimpan
                      ? null
                      : simpanBarang,
                  icon: sedangMenyimpan
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                      : const Icon(Icons.save),
                  label: Text(
                    sedangMenyimpan
                        ? 'Menyimpan...'
                        : 'Simpan Barang',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
