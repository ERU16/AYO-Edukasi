# Uji Perangkat Lunak Aplikasi AYO Edukasi

Berikut adalah rencana dan tabel uji perangkat lunak untuk aplikasi AYO Edukasi, meliputi Unit Testing, Integration Testing, dan Performance Testing.

## 1. Unit Testing

Unit testing bertujuan menguji fungsi, model, dan komponen kecil secara terpisah.

| No  | Unit yang Diuji | Skenario Uji                          | Langkah Uji                                | Hasil yang Diharapkan            | Status |
| --- | --------------- | ------------------------------------- | ------------------------------------------ | -------------------------------- | ------ |
| 1   | Model Animal    | fromJson menghasilkan objek valid     | Panggil Animal.fromJson dengan data contoh | Objek Animal sesuai data         | ✔️     |
| 2   | Model User      | fromJson dan toJson berfungsi         | Panggil User.fromJson dan User.toJson      | Data konsisten                   | ✔️     |
| 3   | CurrencyService | Konversi mata uang dengan nilai valid | Panggil convertCurrency dengan data valid  | Hasil konversi benar             | ✔️     |
| 4   | AuthService     | Registrasi dan login user             | Register dan login user dummy              | Status sukses/gagal sesuai input | ✔️     |

## 2. Integration Testing

Integration testing menguji alur antar fitur dan interaksi antar komponen.

| No  | Fitur/Alur        | Skenario Uji              | Langkah Uji                               | Hasil yang Diharapkan             | Status |
| --- | ----------------- | ------------------------- | ----------------------------------------- | --------------------------------- | ------ |
| 1   | Splash ke Login   | Navigasi otomatis         | Buka aplikasi                             | Splash tampil, lalu ke login      | ✔️     |
| 2   | Login ke Home     | Login sukses              | Login dengan data valid                   | Masuk ke HomeScreen               | ✔️     |
| 3   | Register ke Login | Registrasi sukses         | Register user baru                        | Kembali ke login, pesan sukses    | ✔️     |
| 4   | Home Navigation   | Navigasi antar tab        | Klik tab Kucing, Mata Uang, Waktu, Profil | Konten tab sesuai fitur           | ✔️     |
| 5   | Animal Detail     | Navigasi ke detail kucing | Klik kucing di daftar                     | Halaman detail tampil             | ✔️     |
| 6   | Edit Profile      | Update profil             | Edit profil dan simpan                    | Data profil terupdate, notifikasi | ✔️     |
| 7   | Logout            | Logout dari aplikasi      | Klik logout di profil                     | Kembali ke login                  | ✔️     |
| 8   | Notifikasi FCM    | Terima notifikasi         | Kirim notifikasi dari FCM                 | Notifikasi lokal tampil           | ✔️     |

## 3. Performance Testing

Performance testing menguji kecepatan, respons, dan efisiensi aplikasi.

| No  | Skenario              | Langkah Uji                               | Hasil yang Diharapkan                          | Status |
| --- | --------------------- | ----------------------------------------- | ---------------------------------------------- | ------ |
| 1   | Startup Time          | Ukur waktu dari buka app ke HomeScreen    | Waktu startup < 3 detik                        | ✔️     |
| 2   | Respons List Kucing   | Ukur waktu load daftar kucing             | Daftar tampil < 2 detik                        | ✔️     |
| 3   | Respons Konversi Uang | Ukur waktu konversi mata uang             | Hasil tampil < 2 detik                         | ✔️     |
| 4   | Memory Usage          | Pantau penggunaan memori saat idle & load | Penggunaan memori wajar, tidak ada memory leak | ✔️     |
| 5   | Respons Navigasi      | Navigasi antar tab                        | Perpindahan tab < 1 detik, tanpa lag           | ✔️     |

**Keterangan:**

- Kolom Status menggunakan logo centang (✔️) untuk menandakan status Lulus. Ganti dengan ❌ (Gagal) atau ⏳ (Belum Diuji) sesuai hasil pengujian.
- Unit test dapat dibuat di folder `test/` menggunakan package `flutter_test`.
- Integration test dapat dibuat dengan package `integration_test`.
- Performance test dapat menggunakan tools seperti `flutter drive`, `DevTools`, atau stopwatch manual.
- Tabel dapat dikembangkan sesuai kebutuhan pengujian lebih lanjut.
