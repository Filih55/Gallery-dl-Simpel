import subprocess
import time
import signal
import sys

# ================================
# 🔧 KONFIGURASI
# ================================
# Anda bisa menambahkan konfigurasi lain di sini jika diperlukan.

LOGO_FILIH_ASCII = """
    ███████╗██╗██╗     ██╗██╗  ██╗
    ██╔════╝██║██║     ██║██║  ██║
    █████╗  ██║██║     ██║███████║
    ██╔══╝  ██║██║     ██║██╔══██║
    ██║     ██║███████╗██║██║  ██║
    ╚═╝     ╚═╝╚══════╝╚═╝╚═╝  ╚═╝
"""

def tampilkan_menu_utama():
    """
    Menampilkan header, logo, dan menu pilihan utama.
    """
    print(LOGO_FILIH_ASCII)
    print("----------------------------------------------------")
    print("      🚀 Menjalankan GALLERY-DL                     ")
    print("----------------------------------------------------")
    print("\nPilih platform yang ingin Anda unduh:")
    print("1. x.com (Twitter)")
    print("2. Instagram.com")
    print("3. Masukkan URL manual")
    print("4. Keluar")

def signal_handler(sig, frame):
    """
    Menangani sinyal Ctrl+C untuk menampilkan menu keluar/lanjut.
    """
    print("\n\n----------------------------------------------------")
    print("      ⚠️ Program diinterupsi! Pilih opsi berikut:")
    print("      1. Jalankan lagi")
    print("      2. Keluar dari program")
    print("----------------------------------------------------")
    
    pilihan = input("Masukkan pilihan Anda (1/2): ")
    if pilihan == '1':
        print("\nMemulai ulang program...")
        return
    elif pilihan == '2':
        print("\nKeluar dari program. Sampai jumpa!")
        sys.exit(0)
    else:
        print("Pilihan tidak valid. Silakan coba lagi.")
        signal_handler(sig, frame)

def tampilkan_menu_selesai():
    """
    Menampilkan menu setelah proses unduhan selesai.
    """
    print("\n\n----------------------------------------------------")
    print("      ✅ Tugas selesai! Pilih opsi berikut:")
    print("      1. Jalankan lagi")
    print("      2. Keluar dari program")
    print("----------------------------------------------------")
    
    pilihan = input("Masukkan pilihan Anda (1/2): ")
    return pilihan

def jalankan_gallery_dl():
    """
    Menjalankan program gallery-dl dengan menu pilihan.
    """
    while True:
        tampilkan_menu_utama()
        pilihan = input("Masukkan pilihan Anda (1/2/3/4): ")

        perintah_lengkap = None

        if pilihan == '1':
            user_id = input("Masukkan nama pengguna x.com (@tanpa-tanda): ")
            perintah_lengkap = ["gallery-dl", f"https://x.com/{user_id}"]
        elif pilihan == '2':
            user_id = input("Masukkan nama pengguna Instagram: ")
            perintah_lengkap = ["gallery-dl", f"https://instagram.com/{user_id}"]
        elif pilihan == '3':
            url_manual = input("Masukkan URL atau perintah lengkap: ")
            perintah_lengkap = ["gallery-dl"] + url_manual.split()
        elif pilihan == '4':
            print("Keluar dari program. Sampai jumpa!")
            break
        else:
            print("Pilihan tidak valid. Silakan coba lagi.")
            time.sleep(1)
            continue
        
        if perintah_lengkap:
            try:
                print("\nMemproses...")
                subprocess.run(perintah_lengkap, check=True)
                print("\n✅ Perintah selesai dijalankan.")
            except FileNotFoundError:
                print("\n❌ Error: 'gallery-dl' tidak ditemukan.")
                print("Pastikan Anda sudah menginstal gallery-dl dan menambahkannya ke PATH.")
            except subprocess.CalledProcessError as e:
                print(f"\n❌ Perintah gagal dengan kode error: {e.returncode}")
                print("Silakan periksa kembali perintah atau nama pengguna Anda.")
            except Exception as e:
                print(f"\n❌ Terjadi kesalahan tak terduga: {e}")
        
        pilihan_selesai = tampilkan_menu_selesai()
        if pilihan_selesai == '2':
            print("\nKeluar dari program. Sampai jumpa!")
            sys.exit(0)
        elif pilihan_selesai != '1':
            print("Pilihan tidak valid. Memulai ulang program.")
            time.sleep(1)
        
if __name__ == "__main__":
    signal.signal(signal.SIGINT, signal_handler)
    jalankan_gallery_dl()