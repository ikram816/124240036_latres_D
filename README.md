# Toko Awikwok - Latihan Responsi Praktikum Pemrograman Aplikasi Mobile (SI-D)

Aplikasi e-commerce berbasis **Flutter** bernama **Toko Awikwok** yang dikembangkan untuk memenuhi tugas **Latihan Responsi Praktikum Pemrograman Aplikasi Mobile Kelas SI-D**. Aplikasi ini mengimplementasikan arsitektur modern menggunakan state management **GetX**, penyimpanan lokal menggunakan **Hive** dan **SharedPreferences**, serta konsumsi REST API menggunakan paket **http**.

---

## 👤 Identitas Mahasiswa & Aplikasi

- **Nama Aplikasi**: Toko Awikwok
- **Mata Kuliah**: Praktikum Pemrograman Aplikasi Mobile
- **Kelas**: Sistem Informasi D (SI-D)
- **NIM**: 124240036
- **Kredensial Login Default**:
  - **Username**: Bebas (tidak boleh kosong, contoh: `ikram`)
  - **Password**: `124240036`

---

## 🚀 Fitur Utama Aplikasi

1. **Autentikasi & Validasi**:
   - Validasi input login: username tidak boleh kosong dan password wajib sama dengan NIM (`124240036`).
   - Penanganan error dengan `Get.snackbar` di bagian bawah layar berwarna merah.
2. **Auto-Login**:
   - Pengecekan status login tersimpan di `SharedPreferences`. Jika user sudah login sebelumnya, aplikasi langsung diarahkan ke Halaman Utama tanpa perlu login ulang.
3. **Katalog Produk Dinamis**:
   - Mengambil data produk secara real-time dari REST API DummyJSON (`https://dummyjson.com/products`).
   - Indikator loading, penanganan error, serta tampilan kartu produk yang rapi dengan thumbnail, judul, kategori, dan harga.
4. **Detail Produk & Kuantiti**:
   - Menampilkan gambar produk, judul, merek, kategori, harga hijau tebal, rating bintang, stok, dan deskripsi produk.
   - Kontrol kuantiti (`-` dan `+`) yang dibatasi sesuai stok yang tersedia (`1 <= qty <= stock`).
5. **Keranjang Belanja Multi-User (Hive)**:
   - Data keranjang disimpan secara lokal di database NoSQL Hive (`cartBox`).
   - Setiap data keranjang terikat dengan `username` yang sedang login (data keranjang terisolasi antar-user).
   - Penambahan kuantiti otomatis jika item yang sama dimasukkan kembali tanpa melebihi stok.
   - Hapus item keranjang belanja secara instan dengan ikon tempat sampah.
   - Perhitungan total belanja otomatis secara reaktif dengan dua angka di belakang koma.
6. **Profil Pengguna & Logout**:
   - Menampilkan avatar, username aktif, pesan & kesan pembelajaran Flutter dengan GetX dan Hive.
   - Tombol logout yang menghapus sesi di `SharedPreferences` dan mengarahkan kembali ke halaman login tanpa menghapus data keranjang di Hive.

---

## 📦 Library & Dependensi yang Digunakan

| Library | Versi | Fungsi / Kegunaan |
| :--- | :--- | :--- |
| **`get` (GetX)** | `^4.6.6` | Digunakan sebagai solusi utama untuk **State Management** reaktif (`.obs` & `Obx`), **Route Management** / navigasi antar halaman tanpa `BuildContext`, serta menampilkan dialog/snackbar kustom (`Get.snackbar`). |
| **`hive`** | `^2.2.3` | Database NoSQL lokal berbasis key-value yang sangat cepat dan ringan untuk menyimpan data item keranjang belanja (`cartBox`) secara offline. |
| **`hive_flutter`** | `^1.1.0` | Ekstensi Hive khusus ekosistem Flutter untuk mempermudah inisialisasi penyimpanan lokal di perangkat (`Hive.initFlutter()`). |
| **`shared_preferences`** | `^2.2.2` | Penyimpanan lokal berbasis key-value sederhana untuk menyimpan sesi login pengguna (`isLoggedIn` dan `username`), mendukung fitur **Auto-Login**. |
| **`http`** | `^1.2.0` | HTTP Client untuk melakukan permintaan jaringan (REST API GET) ke endpoint publik `https://dummyjson.com/products`. |
| **`cupertino_icons`** | `^1.0.8` | Kumpulan ikon bergaya iOS untuk kebutuhan visual pelengkap antarmuka. |

---

## 🛠️ Cara Menjalankan Aplikasi

### Prasyarat
- Pastikan **Flutter SDK** telah terpasang di komputer Anda (versi 3.13.0 atau yang lebih baru).
- Pastikan Anda telah mengonfigurasi emulator Android, simulator iOS, Google Chrome (Web), atau perangkat fisik dengan USB Debugging aktif.

### Langkah-langkah
1. **Buka Direktori Proyek**:
   Buka terminal atau PowerShell pada folder root proyek:
   ```bash
   cd "d:\SISTEM INFORMASI\latres_ikram_d"
   ```

2. **Unduh Seluruh Dependensi**:
   Jalankan perintah berikut untuk mengunduh semua library yang tertera di `pubspec.yaml`:
   ```bash
   flutter pub get
   ```

3. **Verifikasi Kualitas Kode**:
   Pastikan tidak ada kesalahan sintaks atau dependensi:
   ```bash
   flutter analyze
   ```

4. **Jalankan Aplikasi**:
   Eksekusi aplikasi ke emulator atau perangkat yang terhubung:
   ```bash
   flutter run
   ```

---

## 📂 Struktur Folder `lib/` dan Penjelasan File

Struktur folder di dalam direktori `lib/` dirancang dengan arsitektur yang terpisah antara data model, logika bisnis (controllers), layanan jaringan (services), antarmuka (views), dan perutean (routes):

```text
lib/
├── controllers/
│   ├── auth_controller.dart
│   ├── cart_controller.dart
│   └── product_controller.dart
├── models/
│   ├── cart_model.dart
│   └── product_model.dart
├── routes/
│   ├── app_pages.dart
│   └── app_routes.dart
├── services/
│   └── api_service.dart
├── views/
│   ├── cart_view.dart
│   ├── detail_view.dart
│   ├── home_view.dart
│   ├── login_view.dart
│   ├── main_view.dart
│   └── profile_view.dart
└── main.dart
```

### Penjelasan Lengkap Setiap File

#### 1. File Utama (`lib/main.dart`)
- **[`main.dart`](file:///d:/SISTEM%20INFORMASI/latres_ikram_d/lib/main.dart)**:
  - Merupakan entry point aplikasi Flutter.
  - Menginisialisasi `WidgetsFlutterBinding.ensureInitialized()`.
  - Menginisialisasi database Hive (`Hive.initFlutter()`) dan mendaftarkan adapter manual `CartItemAdapter()`.
  - Membuka box Hive `'cartBox'` sebelum `runApp()`.
  - Memeriksa sesi login di `SharedPreferences` untuk menentukan halaman awal secara otomatis (`/main` jika user sudah login, atau `/login` jika belum).
  - Mengonfigurasi `GetMaterialApp` dengan tema warna biru (`Colors.blue` / `#2196F3`), rute, dan binding.

#### 2. Models (`lib/models/`)
- **[`product_model.dart`](file:///d:/SISTEM%20INFORMASI/latres_ikram_d/lib/models/product_model.dart)**:
  - Berisi kelas `Product` untuk mem-parsing data JSON dari API DummyJSON.
  - Memiliki field: `id`, `title`, `description`, `price`, `rating`, `stock`, `brand`, `category`, dan `thumbnail`.
  - Dilengkapi factory method `fromJson` dengan penanganan nilai null yang aman serta method `toJson`.
- **[`cart_model.dart`](file:///d:/SISTEM%20INFORMASI/latres_ikram_d/lib/models/cart_model.dart)**:
  - Berisi struktur data `CartItem` untuk item keranjang belanja.
  - Memiliki field: `username`, `productId`, `title`, `price`, `thumbnail`, dan `quantity`.
  - Menyediakan method `toMap()` dan `fromMap()` untuk penyimpanan fleksibel di Hive.
  - Dilengkapi adapter manual `CartItemAdapter extends TypeAdapter<CartItem>` tanpa memerlukan code generator `build_runner`.

#### 3. Services (`lib/services/`)
- **[`api_service.dart`](file:///d:/SISTEM%20INFORMASI/latres_ikram_d/lib/services/api_service.dart)**:
  - Menyediakan fungsi statis `getProducts()` untuk melakukan HTTP GET request ke `https://dummyjson.com/products`.
  - Mengonversi data JSON yang diterima menjadi list objek `List<Product>`.

#### 4. Controllers (`lib/controllers/`)
- **[`auth_controller.dart`](file:///d:/SISTEM%20INFORMASI/latres_ikram_d/lib/controllers/auth_controller.dart)**:
  - Mengelola state login dan sesi pengguna menggunakan GetX.
  - Menangani validasi username dan pencocokan password dengan NIM `124240036`.
  - Menyimpan status `isLoggedIn = true` dan `username` ke `SharedPreferences` saat login berhasil.
  - Mengelola fungsi `logout()` untuk menghapus sesi dan mengarahkan kembali ke halaman login.
- **[`product_controller.dart`](file:///d:/SISTEM%20INFORMASI/latres_ikram_d/lib/controllers/product_controller.dart)**:
  - Mengelola pengambilan data produk dari `ApiService`.
  - Menyediakan variabel observabel: `isLoading`, `productList`, dan `errorMessage`.
- **[`cart_controller.dart`](file:///d:/SISTEM%20INFORMASI/latres_ikram_d/lib/controllers/cart_controller.dart)**:
  - Mengelola operasi CRUD pada Hive box `'cartBox'`.
  - Memfilter daftar keranjang berdasarkan `username` yang sedang login.
  - Menyediakan logika `addToCart()` (mengecek jika item sudah ada, menambah kuantiti tanpa melampaui stok, kembali ke halaman katalog, dan memicu snackbar sukses).
  - Menyediakan fungsi `removeFromCart()` untuk menghapus item tertentu.
  - Menghitung total harga belanja (`totalPrice`) secara otomatis.

#### 5. Views (`lib/views/`)
- **[`login_view.dart`](file:///d:/SISTEM%20INFORMASI/latres_ikram_d/lib/views/login_view.dart)**:
  - Halaman login dengan tampilan putih bersih terpusat (centered).
  - Ikon tas belanja biru besar (`Icons.shopping_bag`, size 80) dan teks tebal `'Toko Awikwok'`.
  - Form input username (ikon `person`) dan password (ikon `lock`, sensor teks).
  - Tombol login berbentuk stadium/pill biru selebar layar.
  - Menampilkan snackbar merah di bagian bawah jika validasi gagal.
- **[`main_view.dart`](file:///d:/SISTEM%20INFORMASI/latres_ikram_d/lib/views/main_view.dart)**:
  - Menampung navigasi utama menggunakan `BottomNavigationBar` dengan 2 tab: **Home** (`Icons.home`) dan **Profile** (`Icons.person`).
  - Menggunakan `IndexedStack` agar state halaman tetap terjaga saat berpindah tab.
- **[`home_view.dart`](file:///d:/SISTEM%20INFORMASI/latres_ikram_d/lib/views/home_view.dart)**:
  - Menampilkan AppBar biru dengan salam `'Hi, [username]'` dan ikon keranjang di kanan atas.
  - Menampilkan daftar produk menggunakan `ListView.builder` dalam bentuk kartu putih membulat (`borderRadius: 12`).
  - Menampilkan thumbnail, nama produk, kategori, dan harga. Mengarahkan ke halaman detail saat kartu ditekan.
- **[`detail_view.dart`](file:///d:/SISTEM%20INFORMASI/latres_ikram_d/lib/views/detail_view.dart)**:
  - Menampilkan gambar produk di bagian atas tengah (tinggi 220), judul, merek, kategori, harga hijau tebal, rating bintang kuning, stok, dan deskripsi produk.
  - Bagian bawah menampilkan sticky bar untuk pengaturan kuantiti (`-` dan `+` dengan batas stok) dan tombol biru `'Add to Cart'`.
- **[`cart_view.dart`](file:///d:/SISTEM%20INFORMASI/latres_ikram_d/lib/views/cart_view.dart)**:
  - Menampilkan daftar produk yang ada di dalam keranjang user saat ini.
  - Setiap kartu menampilkan thumbnail, nama produk, kuantiti, harga satuan, dan ikon tempat sampah merah untuk menghapus item.
  - Footer sticky menampilkan label `'Total:'` dan jumlah keseluruhan harga dalam warna hijau tebal.
- **[`profile_view.dart`](file:///d:/SISTEM%20INFORMASI/latres_ikram_d/lib/views/profile_view.dart)**:
  - Menampilkan avatar lingkaran biru dengan ikon orang putih, nama username aktif, dan garis pembatas tipis.
  - Menampilkan section **Kesan** dan **Pesan** terkait pembelajaran Flutter, GetX, dan Hive.
  - Tombol merah berbentuk stadium selebar layar bertuliskan `'Logout'` untuk keluar dari sesi.

#### 6. Routes (`lib/routes/`)
- **[`app_routes.dart`](file:///d:/SISTEM%20INFORMASI/latres_ikram_d/lib/routes/app_routes.dart)**:
  - Mendefinisikan konstanta rute string seperti `/login`, `/main`, `/home`, `/detail`, `/cart`, dan `/profile`.
- **[`app_pages.dart`](file:///d:/SISTEM%20INFORMASI/latres_ikram_d/lib/routes/app_pages.dart)**:
  - Berisi daftar `GetPage` yang memetakan konstanta rute ke halaman view masing-masing.
  - Menyertakan `BindingsBuilder` untuk inisialisasi controller (`lazyPut` dengan mode `fenix: true`) agar efisien dalam penggunaan memori.

---

## 🧪 Pengujian & Analisis Kode

Aplikasi telah divalidasi menggunakan linter resmi Flutter:
```bash
flutter analyze
```
Hasil:
```text
Analyzing latres_ikram_d...
No issues found!
```
Semua file terbebas dari peringatan (*warnings*) maupun galat (*errors*).
