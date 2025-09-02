# Gallery-dl
Program Gallery-dl.py ini adalah sebuah wrapper sederhana berbasis Python yang berfungsi untuk mempermudah penggunaan tool gallery-dl (sebuah downloader konten dari berbagai platform seperti Twitter/X, Instagram, dan lain-lain).

📝 Deskripsi Program

Program ini dibuat untuk memberikan antarmuka menu interaktif di terminal agar pengguna dapat lebih mudah menjalankan perintah gallery-dl tanpa harus mengetik manual sintaks panjang.

Menu Utama

Menampilkan logo ASCII dan daftar opsi.

Pengguna dapat memilih platform:

1. X.com (Twitter) → Unduh media dari akun Twitter/X.

2. Instagram.com → Unduh media dari akun Instagram.

3. URL manual → Memasukkan link langsung atau perintah kustom.

4. Keluar → Menghentikan program.

Proses Eksekusi

Program menerima input pengguna (username atau URL).

Membentuk perintah lengkap untuk menjalankan gallery-dl dengan subprocess.run().

Menangani kemungkinan error, seperti:

gallery-dl belum terinstal / tidak ada di PATH.

Username atau URL salah.

Error tak terduga lainnya.

Menu Setelah Unduhan

Setelah perintah selesai, muncul pilihan:

1. Jalankan lagi → Kembali ke menu utama.

2. Keluar → Mengakhiri program.

Penanganan Ctrl+C (SIGINT)

Jika pengguna menekan Ctrl+C, program tidak langsung keluar.

Akan muncul menu konfirmasi: jalankan ulang atau keluar dari program.

#📝 Deskripsi Program interaktif.py

Program ini adalah sebuah alat bantu interaktif berbasis Python yang digunakan untuk mengatur, menormalkan, dan mengubah ekstensi file dalam sebuah folder secara otomatis. Program juga dapat memindahkan file video ke dalam sub-folder khusus agar lebih rapi.

🔧 Fitur Utama

Input Path Folder

Program meminta pengguna untuk memasukkan path folder target.

Folder yang dimasukkan akan divalidasi. Jika salah, pengguna diminta mengulang.

Pemindaian File

Semua file dalam folder (dan sub-folder) akan dipindai.

Ditampilkan animasi spinner dan progress bar agar pengguna tahu status pemrosesan.

Normalisasi Nama dan Ekstensi

Program mendeteksi file dengan nama/ekstensi tidak standar (misalnya video001.mkv, gambar_123.jpeg, file.gif1).

Ekstensi akan diperbaiki:

File video → otomatis diubah ke .mp4.

File GIF → tetap .gif (jika diaktifkan).

File lain → diganti ke ekstensi default (.jpg).

Manajemen Folder Video

Jika opsi MOVE_TO_VIDEO_FOLDER = True, semua file video dipindahkan ke folder baru bernama video/ di dalam folder target.

Menghindari Duplikasi Nama

Jika nama file hasil konversi sudah ada, program akan menambahkan penomoran otomatis (contoh: video.mp4, video_1.mp4, video_2.mp4).

Menu Setelah Selesai

Setelah semua file diproses, pengguna diberikan dua pilihan:

Memproses folder lain.

Keluar dari program.

User Experience

Menampilkan logo ASCII saat dijalankan.

Menggunakan ikon dan log status (✅, ❌, 📁, 🔍, dll.) untuk memudahkan pengguna memahami proses.

Ada pesan kesalahan jika path salah atau file gagal diproses.
