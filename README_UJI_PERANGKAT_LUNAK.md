# Uji Perangkat Lunak Aplikasi AYO Edukasi

Berikut adalah tabel uji perangkat lunak (software testing) untuk aplikasi AYO Edukasi. Tabel ini mencakup fitur utama, skenario pengujian, langkah uji, hasil yang diharapkan, dan status.

| No | Fitur                        | Skenario Uji                                      | Langkah Uji                                                                 | Hasil yang Diharapkan                                 | Status |
|----|------------------------------|---------------------------------------------------|----------------------------------------------------------------------------|--------------------------------------------------------|--------|
| 1  | Splash Screen                | Aplikasi menampilkan splash screen                 | Buka aplikasi                                                            | Splash screen tampil selama 3 detik, lalu ke login     |        |
| 2  | Login                        | Login dengan data valid                            | Masukkan username & password valid, klik Login                            | Masuk ke HomeScreen                                    |        |
| 3  | Login                        | Login dengan data tidak valid                      | Masukkan username/password salah, klik Login                              | Pesan error login muncul                               |        |
| 4  | Register                     | Registrasi akun baru                              | Klik Daftar, isi data, klik Daftar                                        | Pesan sukses, kembali ke login                         |        |
| 5  | Home Navigation              | Navigasi antar tab utama                          | Klik tab Kucing, Mata Uang, Waktu, Profil                                 | Konten tab sesuai fitur tampil                         |        |
| 6  | Animal List                  | Menampilkan daftar kucing                         | Pilih tab Kucing di HomeScreen                                            | Daftar kucing tampil                                   |        |
| 7  | Animal Detail                | Melihat detail kucing                             | Klik salah satu kucing                                                    | Halaman detail kucing tampil                           |        |
| 8  | Currency Converter           | Konversi mata uang                                | Pilih tab Mata Uang, isi jumlah, pilih mata uang, klik Konversi           | Hasil konversi tampil                                  |        |
| 9  | Currency Converter           | Fitur shake untuk random uang                     | Goyangkan device saat di tab Mata Uang                                    | Jumlah uang bertambah otomatis                         |        |
| 10 | Time Converter               | Konversi zona waktu                               | Pilih tab Waktu, pilih waktu & zona, klik Konversi                        | Hasil konversi tampil                                  |        |
| 11 | Profile View                 | Melihat profil pengguna                           | Pilih tab Profil                                                          | Data profil tampil                                      |        |
| 12 | Edit Profile                 | Mengubah data profil                              | Di tab Profil, klik Edit Profil, ubah data, simpan                         | Data profil terupdate, notifikasi sukses               |        |
| 13 | Feedback                     | Mengirim feedback/kesan pesan                     | Di tab Profil, klik ikon feedback                                         | Halaman feedback tampil                                |        |
| 14 | Logout                       | Logout dari aplikasi                              | Di tab Profil, klik ikon logout                                           | Kembali ke halaman login                               |        |
| 15 | Notifikasi                   | Menerima notifikasi FCM                           | Kirim notifikasi dari Firebase Cloud Messaging                             | Notifikasi lokal tampil di device                      |        |
| 16 | Permission                   | Izin notifikasi                                   | Buka aplikasi pertama kali                                                | Dialog izin notifikasi muncul                          |        |
| 17 | Geolokasi Profil             | Menampilkan lokasi pengguna                       | Di tab Profil, klik Tampilkan Lokasi Saya                                  | Lokasi (latitude, longitude) tampil di profil          |        |

**Keterangan:**
- Kolom Status dapat diisi: Lulus / Gagal / Belum Diuji
- Tabel ini dapat dikembangkan sesuai kebutuhan pengujian lebih lanjut
