import 'package:flutter/material.dart';

void main() {
  runApp(const LaporPakApp());
}

// ==========================================
// STATE DATA REALTIME (GLOBAL)
// ==========================================
List<String> listPengumuman = [
  'Pohon tumbang di gang tengah sedang dievakuasi.',
  'Iuran bulanan RT paling lambat dibayarkan tanggal 10.',
];

List<Map<String, String>> listLaporanMasuk = [
  {'judul': 'Lampu Jalan Mati', 'deskripsi': 'Lampu di gang 3 mati total sejak kemarin malam.', 'status': 'Diproses'},
  {'judul': 'Sampah Menumpuk', 'deskripsi': 'Bak sampah depan pos ronda penuh belum diangkut.', 'status': 'Baru'},
];

List<Map<String, String>> listWargaBaruMendaftar = [
  {'nama': 'Andi Wijaya', 'alamat': 'Gang 4 No. 12', 'status': 'Pending'},
  {'nama': 'Siti Rahma', 'alamat': 'Gang 1 No. 05', 'status': 'Pending'},
];

List<Map<String, String>> listWargaDaruratSOS = [
  {'nama': 'Pak Joko', 'alamat': 'Gang 2 No. 08'},
  {'nama': 'Bu Sri', 'alamat': 'Gang 5 No. 14'},
];

// DATA MASTER: SEMUA WARGA TERDAFTAR RT
List<Map<String, String>> listSemuaWarga = [
  {'nama': 'Lela', 'alamat': 'Gang 2 No. 03', 'statusIuran': 'Lunas'},
  {'nama': 'Pak Joko', 'alamat': 'Gang 2 No. 08', 'statusIuran': 'Lunas'},
  {'nama': 'Bu Sri', 'alamat': 'Gang 5 No. 14', 'statusIuran': 'Belum Lunas'},
  {'nama': 'Budi Santoso', 'alamat': 'Gang 3 No. 11', 'statusIuran': 'Belum Lunas'},
  {'nama': 'Hendra', 'alamat': 'Gang 1 No. 02', 'statusIuran': 'Lunas'},
];

class LaporPakApp extends StatelessWidget {
  const LaporPakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LAPOR PAK!',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DynamicDeviceFrame(child: LoginPage(isAdmin: false)),
    );
  }
}

// ==========================================================
// WIDGET BINGKAI DINAMIS
// ==========================================================
class DynamicDeviceFrame extends StatelessWidget {
  final Widget child;
  const DynamicDeviceFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E24), 
      body: Center(
        child: Container(
          width: deviceWidth,
          height: deviceHeight,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(deviceHeight * 0.05), 
            border: Border.all(color: const Color(0xFF3A3A3C), width: deviceWidth * 0.03),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 10)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(deviceHeight * 0.04), 
            child: Stack(
              children: [
                Positioned.fill(child: child),
                Positioned(
                  top: deviceHeight * 0.015,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: deviceWidth * 0.28,
                      height: deviceHeight * 0.032,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 1. SPLASH SCREEN
// ==========================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DynamicDeviceFrame(child: LoginPage(isAdmin: false))),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB4C3B9),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('LAPOR PAK!', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'serif')),
            const SizedBox(height: 8),
            const Text('Aplikasi Laporan Warga & RT', textAlign: TextAlign.center, style: TextStyle(fontSize: 13)),
            const SizedBox(height: 30),
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.thumb_up, size: 45, color: Colors.black),
            ),
            const SizedBox(height: 40),
            const SizedBox(width: 140, child: LinearProgressIndicator(backgroundColor: Colors.white, minHeight: 4)),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 2. HALAMAN LOGIN
// ==========================================
class LoginPage extends StatefulWidget {
  final bool isAdmin;
  const LoginPage({super.key, this.isAdmin = false});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _showResetPasswordDialog(BuildContext context) {
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isAdmin 
                ? 'Masukkan email dinas Admin RT Anda untuk menerima link pemulihan.' 
                : 'Masukkan nomor HP atau Email Warga Terdaftar Anda.',
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email / No. HP', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Link instruksi reset password berhasil dikirim!')),
              );
            },
            child: const Text('Kirim'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCE6F1),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.isAdmin ? 'SELAMAT DATANG\nPORTAL ADMIN RT' : 'SELAMAT DATANG\nLAPOR PAK! (WARGA)', 
              textAlign: TextAlign.center, 
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 0.5)
            ),
            const SizedBox(height: 24),
            Icon(widget.isAdmin ? Icons.admin_panel_settings : Icons.supervised_user_circle, size: 65, color: Colors.blueGrey[700]),
            const SizedBox(height: 30),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person), 
                labelText: 'USERNAME', 
                filled: true, 
                fillColor: Colors.white, 
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))
              )
            ),
            const SizedBox(height: 12),
            TextField(
              obscureText: true, 
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock), 
                labelText: 'PASSWORD', 
                filled: true, 
                fillColor: Colors.white, 
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))
              )
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => _showResetPasswordDialog(context),
                child: const Text('Forgot Password?', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE5989B)),
                onPressed: () {
                  String namaLogin = _usernameController.text.trim();
                  if (namaLogin.isEmpty) {
                    namaLogin = widget.isAdmin ? 'Admin RT' : 'Warga';
                  }

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DynamicDeviceFrame(
                        child: widget.isAdmin 
                            ? const AdminDashboard() 
                            : WargaDashboard(namaWarga: namaLogin),
                      ),
                    ),
                    (route) => false,
                  );
                },
                child: Text(widget.isAdmin ? 'LOGIN ADMIN' : 'LOGIN WARGA', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 35),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DynamicDeviceFrame(child: LoginPage(isAdmin: !widget.isAdmin))),
                );
              },
              child: Text(
                widget.isAdmin ? 'Masuk Sebagai Warga Lingkungan' : 'Masuk Sebagai Admin / Ketua RT',
                style: TextStyle(color: Colors.blueGrey[800], fontWeight: FontWeight.w600, decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 3. DASHBOARD WARGA
// ==========================================
class WargaDashboard extends StatefulWidget {
  final String namaWarga;
  const WargaDashboard({super.key, required this.namaWarga});

  @override
  State<WargaDashboard> createState() => _WargaDashboardState();
}

class _WargaDashboardState extends State<WargaDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LAPOR PAK! - WARGA', style: TextStyle(fontSize: 16)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DynamicDeviceFrame(child: const LoginPage(isAdmin: false))), (route) => false),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20), 
            Text('HALO, ${widget.namaWarga.toUpperCase()}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            const Text('WARGA RT 02 / RW 01', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildMenuCard(Icons.assignment, 'BUAT LAPORAN', Colors.blue[100]!, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DynamicDeviceFrame(child: BuatLaporanPage())));
                })),
                const SizedBox(width: 12),
                Expanded(child: _buildMenuCard(Icons.monetization_on, 'CEK IURAN', Colors.green[100]!, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DynamicDeviceFrame(child: CekIuranPage())));
                })),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildMenuCard(Icons.campaign, 'PAPAN PENGUMUMAN', Colors.orange[100]!, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DynamicDeviceFrame(child: PapanPengumumkanPage())));
                })),
                const SizedBox(width: 12),
                Expanded(child: InkWell(
                  onTap: () => _showSOSDialog(),
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center, 
                      children: [
                        Icon(Icons.warning, size: 28, color: Colors.white),
                        Text('TOMBOL SOS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))
                      ],
                    ),
                  ),
                )),
              ],
            ),
            const SizedBox(height: 20),
            const Text('PENGUMUMAN TERBARU:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.grey[200]!, blurRadius: 4)]),
              child: Text(listPengumuman.isNotEmpty ? listPengumuman.last : 'Belum ada pengumuman baru.', style: const TextStyle(fontSize: 12)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(IconData icon, String title, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 90,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            Icon(icon, size: 28, color: Colors.black54),
            const SizedBox(height: 4),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  void _showSOSDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('DARURAT SOS!'),
        content: const Text('Kirim sinyal bahaya ke Ketua RT sekarang?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red), 
            onPressed: () {
              setState(() {
                listWargaDaruratSOS.add({'nama': widget.namaWarga, 'alamat': 'RT 02 / RW 01'});
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sinyal darurat berhasil disiarkan!')));
            }, 
            child: const Text('KIRIM', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}

// SUB PAGES WARGA
class BuatLaporanPage extends StatelessWidget {
  const BuatLaporanPage({super.key});
  @override
  Widget build(BuildContext context) {
    final title = TextEditingController();
    final desc = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Buat Laporan', style: TextStyle(fontSize: 16))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: title, decoration: const InputDecoration(labelText: 'Judul Keluhan', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: desc, maxLines: 3, decoration: const InputDecoration(labelText: 'Detail Keluhan', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (title.text.isNotEmpty) {
                  listLaporanMasuk.add({'judul': title.text, 'deskripsi': desc.text, 'status': 'Baru'});
                  Navigator.pop(context);
                }
              },
              child: const Text('Kirim'),
            )
          ],
        ),
      ),
    );
  }
}

class CekIuranPage extends StatelessWidget {
  const CekIuranPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Iuran Anda', style: TextStyle(fontSize: 16))),
      body: ListView(
        padding: const EdgeInsets.all(12), 
        children: const [
          Card(
            child: ListTile(
              title: Text('Juni 2026'), 
              trailing: Text('LUNAS', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}

class PapanPengumumkanPage extends StatelessWidget {
  const PapanPengumumkanPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengumuman RT', style: TextStyle(fontSize: 16))),
      body: ListView.builder(
        padding: const EdgeInsets.all(12), 
        itemCount: listPengumuman.length, 
        itemBuilder: (context, i) => Card(
          child: Padding(
            padding: const EdgeInsets.all(12), 
            child: Text(listPengumuman[i]),
          ),
        ),
      ),
    );
  }
}

// =========================================================
// 4. DASHBOARD ADMIN (RT)
// =========================================================
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;
  final List<String> _views = ['STATUS', 'IURAN WARGA', 'DATA WARGA', 'SIAR PENGUMUMAN'];

  void _tampilkanDetailKeluhanWarga() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.assignment, color: Colors.blue),
              SizedBox(width: 8),
              Text('Daftar Keluhan Warga', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: listLaporanMasuk.isEmpty
                ? const Center(child: Text('Tidak ada keluhan masuk.', style: TextStyle(fontSize: 13, color: Colors.grey)))
                : ListView.builder(
                    itemCount: listLaporanMasuk.length,
                    itemBuilder: (context, index) {
                      final lap = listLaporanMasuk[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(lap['judul']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          subtitle: Text(lap['deskripsi']!, style: const TextStyle(fontSize: 11)),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 8)),
                            onPressed: () {
                              setState(() {
                                listLaporanMasuk.removeAt(index);
                              });
                              setModalState(() {});
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Laporan ditandai selesai!')));
                            },
                            child: const Text('Selesai', style: TextStyle(color: Colors.white, fontSize: 10)),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup'))
          ],
        ),
      ),
    ).then((value) => setState(() {}));
  }

  void _tampilkanDetailWargaSOS() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 8),
              Text('Warga Butuh Bantuan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 250,
            child: listWargaDaruratSOS.isEmpty
                ? const Center(child: Text('Aman, tidak ada warga yang darurat.', style: TextStyle(fontSize: 13, color: Colors.grey)))
                : ListView.builder(
                    itemCount: listWargaDaruratSOS.length,
                    itemBuilder: (context, index) {
                      final wargaSOS = listWargaDaruratSOS[index];
                      return Card(
                        color: Colors.red[50],
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(wargaSOS['nama']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.red)),
                          subtitle: Text('Lokasi: ${wargaSOS['alamat']!}', style: const TextStyle(fontSize: 11)),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, padding: const EdgeInsets.symmetric(horizontal: 8)),
                            onPressed: () {
                              setState(() {
                                listWargaDaruratSOS.removeAt(index);
                              });
                              setModalState(() {});
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Status darurat warga telah diatasi.')));
                            },
                            child: const Text('Selesai Atasi', style: TextStyle(color: Colors.white, fontSize: 10)),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup'))
          ],
        ),
      ),
    ).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_views[_currentIndex], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DynamicDeviceFrame(child: const LoginPage(isAdmin: true))), (route) => false),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildMainContent(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Status'),
          BottomNavigationBarItem(icon: Icon(Icons.monetization_on), label: 'Iuran'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Data Warga'),
          BottomNavigationBarItem(icon: Icon(Icons.campaign), label: 'Siar'),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    // VIEW 1: IURAN WARGA
    if (_views[_currentIndex] == 'IURAN WARGA') {
      List<Map<String, String>> wargaLunas = listSemuaWarga.where((w) => w['statusIuran'] == 'Lunas').toList();
      List<Map<String, String>> wargaBelumLunas = listSemuaWarga.where((w) => w['statusIuran'] == 'Belum Lunas').toList();

      return DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: 'LUNAS', icon: Icon(Icons.check_circle, color: Colors.green)),
                Tab(text: 'BELUM LUNAS', icon: Icon(Icons.cancel, color: Colors.red)),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TabBarView(
                children: [
                  wargaLunas.isEmpty 
                    ? const Center(child: Text('Belum ada data.'))
                    : ListView.builder(
                        itemCount: wargaLunas.length,
                        itemBuilder: (context, i) => Card(
                          child: ListTile(
                            leading: const Icon(Icons.person, color: Colors.green),
                            title: Text(wargaLunas[i]['nama']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            subtitle: Text(wargaLunas[i]['alamat']!, style: const TextStyle(fontSize: 11)),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: Colors.green[100], borderRadius: BorderRadius.circular(12)),
                              child: const Text('LUNAS', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ),
                  wargaBelumLunas.isEmpty 
                    ? const Center(child: Text('Semua warga sudah lunas.'))
                    : ListView.builder(
                        itemCount: wargaBelumLunas.length,
                        itemBuilder: (context, i) => Card(
                          child: ListTile(
                            leading: const Icon(Icons.person, color: Colors.red),
                            title: Text(wargaBelumLunas[i]['nama']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            subtitle: Text(wargaBelumLunas[i]['alamat']!, style: const TextStyle(fontSize: 11)),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, padding: const EdgeInsets.symmetric(horizontal: 8)),
                              onPressed: () {
                                setState(() {
                                  int indexAsli = listSemuaWarga.indexWhere((w) => w['nama'] == wargaBelumLunas[i]['nama']);
                                  if (indexAsli != -1) {
                                    listSemuaWarga[indexAsli]['statusIuran'] = 'Lunas';
                                  }
                                });
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Iuran ${wargaBelumLunas[i]['nama']} diperbarui jadi LUNAS!')));
                              },
                              child: const Text('Bayar', style: TextStyle(color: Colors.white, fontSize: 11)),
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // VIEW 2: DATA WARGA
    if (_views[_currentIndex] == 'DATA WARGA') {
      return DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: 'SEMUA WARGA', icon: Icon(Icons.groups)),
                Tab(text: 'PERMINTAAN BARU', icon: Icon(Icons.person_add)),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TabBarView(
                children: [
                  ListView.builder(
                    itemCount: listSemuaWarga.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue[300],
                            child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                          ),
                          title: Text(listSemuaWarga[index]['nama']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          subtitle: Text(listSemuaWarga[index]['alamat']!, style: const TextStyle(fontSize: 12)),
                        ),
                      );
                    },
                  ),
                  listWargaBaruMendaftar.isEmpty
                      ? const Center(child: Text('Tidak ada pendaftaran baru.', style: TextStyle(color: Colors.grey, fontSize: 12)))
                      : ListView.builder(
                          itemCount: listWargaBaruMendaftar.length,
                          itemBuilder: (context, index) {
                            final warga = listWargaBaruMendaftar[index];
                            return Card(
                              child: ListTile(
                                leading: const CircleAvatar(backgroundColor: Colors.blueGrey, child: Icon(Icons.person, color: Colors.white)),
                                title: Text(warga['nama']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                subtitle: Text(warga['alamat']!, style: const TextStyle(fontSize: 12)),
                                trailing: ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 10)),
                                  onPressed: () {
                                    setState(() {
                                      listSemuaWarga.add({'nama': warga['nama']!, 'alamat': warga['alamat']!, 'statusIuran': 'Belum Lunas'});
                                      listWargaBaruMendaftar.removeAt(index);
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Warga ${warga['nama']} resmi ditambahkan!')));
                                  },
                                  child: const Text('ACC', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // VIEW 3: SIAR PENGUMUMAN
    if (_views[_currentIndex] == 'SIAR PENGUMUMAN') {
      final textController = TextEditingController();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Buat Pengumuman Baru:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          TextField(controller: textController, maxLines: 3, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Ketik pesan...')),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                setState(() {
                  listPengumuman.add(textController.text);
                });
                textController.clear();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pengumuman berhasil disiarkan!')));
              }
            },
            child: const Text('Publikasikan'),
          )
        ],
      );
    }

    // VIEW 4: STATUS (MAIN DASHBOARD)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text('Selamat Datang, Pak RT', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildStatCard('TOTAL KELUHAN', '${listLaporanMasuk.length}', Colors.blue[50]!, () {
              _tampilkanDetailKeluhanWarga();
            })),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'TOTAL WARGA', 
                '${listSemuaWarga.length}', 
                Colors.green[50]!, 
                () {
                  setState(() {
                    _currentIndex = 2;
                  });
                }
              )
            ),
          ],
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () => _tampilkanDetailWargaSOS(),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Menerima laporan darurat SOS (Klik Detail)', 
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 12,
                  child: Text(
                    '${listWargaDaruratSOS.length}', 
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 11)
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String count, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[300]!)),
        child: Column(
          children: [
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(count, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}