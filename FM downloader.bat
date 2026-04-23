@echo off
chcp 437 >nul 2>nul
setlocal enabledelayedexpansion
title Gallery-dl ULTIMATE Pro v2.0
color 0F

:: =============================================================
:: Gallery-dl ULTIMATE Pro v2.0
:: Professional Multi-Platform Media Downloader
:: =============================================================

:: 1. Base Directories
set "BASE_DIR=%~dp0"
set "DL_DIR=%BASE_DIR%Downloads"
set "CONF_DIR=%BASE_DIR%Config"
set "LOG_DIR=%BASE_DIR%Logs"

:: 2. Folder Setup
if not exist "%DL_DIR%" mkdir "%DL_DIR%"
if not exist "%CONF_DIR%" mkdir "%CONF_DIR%"
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"
if not exist "%DL_DIR%\Twitter" mkdir "%DL_DIR%\Twitter"
if not exist "%DL_DIR%\TikTok" mkdir "%DL_DIR%\TikTok"
if not exist "%DL_DIR%\YouTube" mkdir "%DL_DIR%\YouTube"
if not exist "%DL_DIR%\Instagram" mkdir "%DL_DIR%\Instagram"
if not exist "%DL_DIR%\Reddit" mkdir "%DL_DIR%\Reddit"

:: 3. Dependency Check
where gallery-dl >nul 2>nul
if !errorlevel! neq 0 (
    cls
    echo.
    echo  ============================================================
    echo   [ERROR] gallery-dl TIDAK DITEMUKAN!
    echo  ============================================================
    echo.
    echo   gallery-dl tidak terdeteksi di PATH sistem.
    echo.
    echo   Solusi:
    echo   1. Download dari: github.com/mikf/gallery-dl/releases
    echo   2. Letakkan gallery-dl.exe di folder ini
    echo      atau tambahkan ke PATH sistem.
    echo.
    pause
    exit /b 1
)

:: 4. Global Settings
set "ARGS=--retries 3 --sleep 2-4"
set "COOKIE_FILE=%CONF_DIR%\cookies.txt"

:: 5. Create session log file using locale-proof timestamp
call :get_timestamp
set "LOG_FILE=!LOG_DIR!\session_!TS_FILE!.log"
call :log "=== Gallery-dl ULTIMATE Pro v2.0 - Session Started ==="

:: =============================================================
:: MAIN MENU
:: =============================================================

:menu
cls
echo.
echo  +=========================================================+
echo  :         GALLERY-DL ULTIMATE PRO v2.0                    :
echo  :         Professional Media Downloader                    :
echo  +=========================================================+
echo  :                                                          :
echo  :   [1]  Twitter / X Manager                               :
echo  :   [2]  TikTok Manager                                    :
echo  :   [3]  YouTube Manager                                   :
echo  :   [4]  Instagram Manager                                 :
echo  :   [5]  Reddit Manager                                    :
echo  :   [6]  Generic URL Download                              :
echo  :                                                          :
echo  :   [S]  Settings and Configuration                        :
echo  :   [L]  View Download Logs                                :
echo  :   [Q]  Exit Program                                      :
echo  :                                                          :
echo  +=========================================================+
echo.
set /p "choice=  Select Option: "

if /i "!choice!"=="1" call :twitter_menu
if /i "!choice!"=="2" call :tiktok_menu
if /i "!choice!"=="3" call :youtube_menu
if /i "!choice!"=="4" call :instagram_menu
if /i "!choice!"=="5" call :reddit_menu
if /i "!choice!"=="6" call :generic_download
if /i "!choice!"=="S" call :settings_menu
if /i "!choice!"=="L" call :view_logs
if /i "!choice!"=="Q" goto exit_program

goto menu

:: =============================================================
:: TWITTER / X
:: =============================================================

:twitter_menu
cls
echo.
echo  +=========================================================+
echo  :           TWITTER / X - DOWNLOAD OPTIONS                 :
echo  +=========================================================+
echo  :                                                          :
echo  :   [1]  Photos Only - JPG, PNG                            :
echo  :   [2]  Videos Only - MP4, MOV                            :
echo  :   [3]  All Media - Images + Video                        :
echo  :   [4]  Liked Posts - Requires Cookies                    :
echo  :   [5]  User Timeline - Full Profile                      :
echo  :   [6]  Twitter List Download                             :
echo  :                                                          :
echo  :   [0]  Back to Main Menu                                 :
echo  :                                                          :
echo  +=========================================================+
echo.
set /p "tw_opt=  Select Option: "
if "!tw_opt!"=="0" goto :eof

set /p "url=  Enter Twitter URL/Username: "
if "!url!"=="" goto tw_empty
goto tw_proceed
:tw_empty
echo  [X] URL tidak boleh kosong!
pause
goto :eof

:tw_proceed
set "PLAT_DIR=!DL_DIR!\Twitter"
call :log "TWITTER: Option=!tw_opt! URL=!url!"
echo.
echo  [*] Memulai unduhan ke !PLAT_DIR!...
echo  [*] Archive aktif - file duplikat akan dilewati.
echo  [*] Auto-retry: 3x / Sleep: 2-4 detik antar request
echo.

if "!tw_opt!"=="1" goto tw_photos
if "!tw_opt!"=="2" goto tw_videos
if "!tw_opt!"=="3" goto tw_all
if "!tw_opt!"=="4" goto tw_liked
if "!tw_opt!"=="5" goto tw_timeline
if "!tw_opt!"=="6" goto tw_list
goto tw_done

:tw_photos
echo  [MODE] Photos Only - Filter: JPG, PNG, JPEG
gallery-dl !ARGS! --download-archive "!CONF_DIR!\twitter_arch.txt" -D "!PLAT_DIR!" --filter "extension in ('jpg', 'png', 'jpeg')" "!url!"
goto tw_done

:tw_videos
echo  [MODE] Videos Only - Filter: MP4, MOV, WEBM
gallery-dl !ARGS! --download-archive "!CONF_DIR!\twitter_arch.txt" -D "!PLAT_DIR!" --filter "extension in ('mp4', 'mov', 'webm')" "!url!"
goto tw_done

:tw_all
echo  [MODE] All Media - No Filter Applied
gallery-dl !ARGS! --download-archive "!CONF_DIR!\twitter_arch.txt" -D "!PLAT_DIR!" "!url!"
goto tw_done

:tw_liked
echo  [MODE] Liked Posts - Menggunakan Cookies
call :check_cookies
if !errorlevel! neq 0 goto :eof
gallery-dl !ARGS! -C "!COOKIE_FILE!" --download-archive "!CONF_DIR!\twitter_liked_arch.txt" -D "!PLAT_DIR!\Liked" "!url!"
goto tw_done

:tw_timeline
echo  [MODE] User Timeline - Full Profile Scrape
gallery-dl !ARGS! --download-archive "!CONF_DIR!\twitter_arch.txt" -D "!PLAT_DIR!" "!url!"
goto tw_done

:tw_list
echo  [MODE] Twitter List Download
gallery-dl !ARGS! --download-archive "!CONF_DIR!\twitter_list_arch.txt" -D "!PLAT_DIR!\Lists" "!url!"
goto tw_done

:tw_done
call :log "TWITTER: Download completed."
echo.
echo  [OK] Unduhan selesai! Cek folder: !PLAT_DIR!
pause
goto :eof

:: =============================================================
:: TIKTOK
:: =============================================================

:tiktok_menu
cls
echo.
echo  +=========================================================+
echo  :           TIKTOK - DOWNLOAD OPTIONS                      :
echo  +=========================================================+
echo  :                                                          :
echo  :   [1]  Single Video                                      :
echo  :   [2]  All Videos from User Profile                      :
echo  :   [3]  User Liked Videos - Requires Cookies              :
echo  :   [4]  Download by Hashtag/Tag                           :
echo  :                                                          :
echo  :   [0]  Back to Main Menu                                 :
echo  :                                                          :
echo  +=========================================================+
echo.
set /p "tk_opt=  Select Option: "
if "!tk_opt!"=="0" goto :eof

set /p "url=  Enter TikTok URL/Username: "
if "!url!"=="" goto tk_empty
goto tk_proceed
:tk_empty
echo  [X] URL tidak boleh kosong!
pause
goto :eof

:tk_proceed
set "PLAT_DIR=!DL_DIR!\TikTok"
call :log "TIKTOK: Option=!tk_opt! URL=!url!"
echo.
echo  [*] Memulai unduhan ke !PLAT_DIR!...
echo.

if "!tk_opt!"=="1" goto tk_single
if "!tk_opt!"=="2" goto tk_profile
if "!tk_opt!"=="3" goto tk_liked
if "!tk_opt!"=="4" goto tk_hashtag
goto tk_done

:tk_single
echo  [MODE] Single Video
gallery-dl !ARGS! -D "!PLAT_DIR!" "!url!"
goto tk_done

:tk_profile
echo  [MODE] User Profile - All Videos
gallery-dl !ARGS! --download-archive "!CONF_DIR!\tiktok_arch.txt" -D "!PLAT_DIR!" "!url!"
goto tk_done

:tk_liked
echo  [MODE] Liked Videos - Menggunakan Cookies
call :check_cookies
if !errorlevel! neq 0 goto :eof
gallery-dl !ARGS! -C "!COOKIE_FILE!" --download-archive "!CONF_DIR!\tiktok_liked_arch.txt" -D "!PLAT_DIR!\Liked" "!url!"
goto tk_done

:tk_hashtag
echo  [MODE] Hashtag/Tag Download
gallery-dl !ARGS! --download-archive "!CONF_DIR!\tiktok_tag_arch.txt" -D "!PLAT_DIR!\Tags" "!url!"
goto tk_done

:tk_done
call :log "TIKTOK: Download completed."
echo.
echo  [OK] Unduhan selesai! Cek folder: !PLAT_DIR!
pause
goto :eof

:: =============================================================
:: YOUTUBE
:: =============================================================

:youtube_menu
cls
echo.
echo  +=========================================================+
echo  :           YOUTUBE - DOWNLOAD OPTIONS                     :
echo  +=========================================================+
echo  :                                                          :
echo  :   [1]  Single Video                                      :
echo  :   [2]  Full Playlist                                     :
echo  :   [3]  Channel Videos                                    :
echo  :   [4]  Shorts Only                                       :
echo  :                                                          :
echo  :   [0]  Back to Main Menu                                 :
echo  :                                                          :
echo  +=========================================================+
echo.
set /p "yt_opt=  Select Option: "
if "!yt_opt!"=="0" goto :eof

set /p "url=  Enter YouTube URL: "
if "!url!"=="" goto yt_empty
goto yt_proceed
:yt_empty
echo  [X] URL tidak boleh kosong!
pause
goto :eof

:yt_proceed
set "PLAT_DIR=!DL_DIR!\YouTube"
call :log "YOUTUBE: Option=!yt_opt! URL=!url!"
echo.
echo  [*] Memulai unduhan ke !PLAT_DIR!...
echo.

if "!yt_opt!"=="1" goto yt_single
if "!yt_opt!"=="2" goto yt_playlist
if "!yt_opt!"=="3" goto yt_channel
if "!yt_opt!"=="4" goto yt_shorts
goto yt_done

:yt_single
echo  [MODE] Single Video
gallery-dl !ARGS! -D "!PLAT_DIR!" "!url!"
goto yt_done

:yt_playlist
echo  [MODE] Full Playlist
gallery-dl !ARGS! --download-archive "!CONF_DIR!\youtube_arch.txt" -D "!PLAT_DIR!\Playlists" "!url!"
goto yt_done

:yt_channel
echo  [MODE] Channel Videos
gallery-dl !ARGS! --download-archive "!CONF_DIR!\youtube_arch.txt" -D "!PLAT_DIR!\Channels" "!url!"
goto yt_done

:yt_shorts
echo  [MODE] YouTube Shorts
gallery-dl !ARGS! --download-archive "!CONF_DIR!\youtube_shorts_arch.txt" -D "!PLAT_DIR!\Shorts" "!url!"
goto yt_done

:yt_done
call :log "YOUTUBE: Download completed."
echo.
echo  [OK] Unduhan selesai! Cek folder: !PLAT_DIR!
pause
goto :eof

:: =============================================================
:: INSTAGRAM
:: =============================================================

:instagram_menu
cls
echo.
echo  +=========================================================+
echo  :           INSTAGRAM - DOWNLOAD OPTIONS                   :
echo  +=========================================================+
echo  :                                                          :
echo  :   [1]  Single Post                                       :
echo  :   [2]  User Profile - All Posts                          :
echo  :   [3]  Stories - Requires Cookies                        :
echo  :   [4]  Reels Only                                        :
echo  :   [5]  Saved Posts - Requires Cookies                    :
echo  :                                                          :
echo  :   [0]  Back to Main Menu                                 :
echo  :                                                          :
echo  +=========================================================+
echo.
set /p "ig_opt=  Select Option: "
if "!ig_opt!"=="0" goto :eof

set /p "url=  Enter Instagram URL/Username: "
if "!url!"=="" goto ig_empty
goto ig_proceed
:ig_empty
echo  [X] URL tidak boleh kosong!
pause
goto :eof

:ig_proceed
set "PLAT_DIR=!DL_DIR!\Instagram"
call :log "INSTAGRAM: Option=!ig_opt! URL=!url!"
echo.
echo  [*] Memulai unduhan ke !PLAT_DIR!...
echo.

if "!ig_opt!"=="1" goto ig_single
if "!ig_opt!"=="2" goto ig_profile
if "!ig_opt!"=="3" goto ig_stories
if "!ig_opt!"=="4" goto ig_reels
if "!ig_opt!"=="5" goto ig_saved
goto ig_done

:ig_single
echo  [MODE] Single Post
gallery-dl !ARGS! -D "!PLAT_DIR!" "!url!"
goto ig_done

:ig_profile
echo  [MODE] User Profile - All Posts
gallery-dl !ARGS! -C "!COOKIE_FILE!" --download-archive "!CONF_DIR!\instagram_arch.txt" -D "!PLAT_DIR!" "!url!"
goto ig_done

:ig_stories
echo  [MODE] Stories - Menggunakan Cookies
call :check_cookies
if !errorlevel! neq 0 goto :eof
gallery-dl !ARGS! -C "!COOKIE_FILE!" --download-archive "!CONF_DIR!\instagram_stories_arch.txt" -D "!PLAT_DIR!\Stories" "!url!"
goto ig_done

:ig_reels
echo  [MODE] Reels Only
gallery-dl !ARGS! -C "!COOKIE_FILE!" --download-archive "!CONF_DIR!\instagram_reels_arch.txt" -D "!PLAT_DIR!\Reels" "!url!"
goto ig_done

:ig_saved
echo  [MODE] Saved Posts - Menggunakan Cookies
call :check_cookies
if !errorlevel! neq 0 goto :eof
gallery-dl !ARGS! -C "!COOKIE_FILE!" --download-archive "!CONF_DIR!\instagram_saved_arch.txt" -D "!PLAT_DIR!\Saved" "!url!"
goto ig_done

:ig_done
call :log "INSTAGRAM: Download completed."
echo.
echo  [OK] Unduhan selesai! Cek folder: !PLAT_DIR!
pause
goto :eof

:: =============================================================
:: REDDIT
:: =============================================================

:reddit_menu
cls
echo.
echo  +=========================================================+
echo  :           REDDIT - DOWNLOAD OPTIONS                      :
echo  +=========================================================+
echo  :                                                          :
echo  :   [1]  Single Post                                       :
echo  :   [2]  Subreddit - Top Posts                             :
echo  :   [3]  User Submissions                                  :
echo  :                                                          :
echo  :   [0]  Back to Main Menu                                 :
echo  :                                                          :
echo  +=========================================================+
echo.
set /p "rd_opt=  Select Option: "
if "!rd_opt!"=="0" goto :eof

set /p "url=  Enter Reddit URL: "
if "!url!"=="" goto rd_empty
goto rd_proceed
:rd_empty
echo  [X] URL tidak boleh kosong!
pause
goto :eof

:rd_proceed
set "PLAT_DIR=!DL_DIR!\Reddit"
call :log "REDDIT: Option=!rd_opt! URL=!url!"
echo.
echo  [*] Memulai unduhan ke !PLAT_DIR!...
echo.

if "!rd_opt!"=="1" goto rd_single
if "!rd_opt!"=="2" goto rd_subreddit
if "!rd_opt!"=="3" goto rd_user
goto rd_done

:rd_single
echo  [MODE] Single Post
gallery-dl !ARGS! -D "!PLAT_DIR!" "!url!"
goto rd_done

:rd_subreddit
echo  [MODE] Subreddit - Top Posts
gallery-dl !ARGS! --download-archive "!CONF_DIR!\reddit_arch.txt" -D "!PLAT_DIR!\Subreddits" "!url!"
goto rd_done

:rd_user
echo  [MODE] User Submissions
gallery-dl !ARGS! --download-archive "!CONF_DIR!\reddit_user_arch.txt" -D "!PLAT_DIR!\Users" "!url!"
goto rd_done

:rd_done
call :log "REDDIT: Download completed."
echo.
echo  [OK] Unduhan selesai! Cek folder: !PLAT_DIR!
pause
goto :eof

:: =============================================================
:: GENERIC DOWNLOAD
:: =============================================================

:generic_download
cls
echo.
echo  +=========================================================+
echo  :           GENERIC URL DOWNLOADER                         :
echo  +=========================================================+
echo  :                                                          :
echo  :  Masukkan URL dari situs manapun yang didukung           :
echo  :  gallery-dl. File akan disimpan di Downloads\Other.      :
echo  :                                                          :
echo  +=========================================================+
echo.
set /p "url=  Enter URL: "
if "!url!"=="" goto gen_empty
goto gen_proceed
:gen_empty
echo  [X] URL tidak boleh kosong!
pause
goto :eof

:gen_proceed
if not exist "!DL_DIR!\Other" mkdir "!DL_DIR!\Other"
call :log "GENERIC: URL=!url!"
echo.
echo  [*] Memulai unduhan...
echo.
gallery-dl !ARGS! --download-archive "!CONF_DIR!\generic_arch.txt" -D "!DL_DIR!\Other" "!url!"
call :log "GENERIC: Download completed."
echo.
echo  [OK] Unduhan selesai! Cek folder: !DL_DIR!\Other
pause
goto :eof

:: =============================================================
:: SETTINGS
:: =============================================================

:settings_menu
cls
echo.
echo  +=========================================================+
echo  :           SETTINGS and CONFIGURATION                     :
echo  +=========================================================+
echo  :                                                          :
echo  :   [1]  Update / Set Cookie File                          :
echo  :   [2]  Clear Download Archive - Reset Duplikat           :
echo  :   [3]  Check gallery-dl Version                          :
echo  :   [4]  Update gallery-dl                                 :
echo  :   [5]  Open Downloads Folder                             :
echo  :   [6]  Open Config Folder                                :
echo  :   [7]  View Current Configuration                        :
echo  :                                                          :
echo  :   [0]  Back to Main Menu                                 :
echo  :                                                          :
echo  +=========================================================+
echo.
set /p "set_opt=  Select Option: "
if "!set_opt!"=="0" goto :eof
if "!set_opt!"=="1" goto settings_cookies
if "!set_opt!"=="2" goto settings_clear_archive
if "!set_opt!"=="3" goto settings_version
if "!set_opt!"=="4" goto settings_update
if "!set_opt!"=="5" goto settings_open_dl
if "!set_opt!"=="6" goto settings_open_conf
if "!set_opt!"=="7" goto settings_view
goto :eof

:settings_cookies
cls
echo.
echo  -----------------------------------------------------------
echo   UPDATE COOKIE FILE
echo  -----------------------------------------------------------
echo.
echo  Cookie file saat ini: !CONF_DIR!\cookies.txt
echo.
if exist "!COOKIE_FILE!" (
    echo  [OK] Cookie file DITEMUKAN.
) else (
    echo  [--] Cookie file TIDAK DITEMUKAN.
)
echo.
echo  Cara mendapatkan cookie:
echo  1. Install ekstensi "Get cookies.txt LOCALLY" di browser
echo  2. Login ke platform yang diinginkan
echo  3. Export cookies dalam format Netscape
echo  4. Simpan sebagai: !CONF_DIR!\cookies.txt
echo.
echo  Atau drag-and-drop file cookie ke sini:
set /p "cookie_path=  Path ke file cookie (kosongkan untuk skip): "
if "!cookie_path!"=="" goto settings_cookies_end
copy "!cookie_path!" "!COOKIE_FILE!" >nul 2>nul
if !errorlevel! equ 0 (
    echo  [OK] Cookie file berhasil diperbarui!
) else (
    echo  [X] Gagal menyalin file. Periksa path yang dimasukkan.
)
:settings_cookies_end
pause
goto :eof

:settings_clear_archive
cls
echo.
echo  -----------------------------------------------------------
echo   CLEAR DOWNLOAD ARCHIVE
echo  -----------------------------------------------------------
echo.
echo  PERINGATAN: Ini akan menghapus semua catatan file
echo  yang sudah diunduh. gallery-dl akan mengunduh ulang
echo  semua file pada sesi berikutnya.
echo.
set /p "confirm=  Yakin? (Y/N): "
if /i "!confirm!" neq "Y" goto settings_clear_skip
del "!CONF_DIR!\*_arch.txt" 2>nul
del "!CONF_DIR!\archive.txt" 2>nul
echo  [OK] Archive berhasil di-reset!
call :log "SETTINGS: Archive cleared by user."
goto settings_clear_done
:settings_clear_skip
echo  [i] Operasi dibatalkan.
:settings_clear_done
pause
goto :eof

:settings_version
echo.
echo  [*] Checking gallery-dl version...
echo.
gallery-dl --version
echo.
pause
goto :eof

:settings_update
echo.
echo  [*] Updating gallery-dl...
echo.
pip install --upgrade gallery-dl
echo.
echo  [OK] Update selesai!
pause
goto :eof

:settings_open_dl
explorer "!DL_DIR!"
goto :eof

:settings_open_conf
explorer "!CONF_DIR!"
goto :eof

:settings_view
cls
echo.
echo  -----------------------------------------------------------
echo   CURRENT CONFIGURATION
echo  -----------------------------------------------------------
echo.
echo  Base Directory  : !BASE_DIR!
echo  Downloads Folder: !DL_DIR!
echo  Config Folder   : !CONF_DIR!
echo  Log Folder      : !LOG_DIR!
echo  Current Log     : !LOG_FILE!
echo.
echo  -- Global Arguments --
echo  Flags           : !ARGS!
echo.
echo  -- File Status --
if exist "!COOKIE_FILE!" (
    echo  Cookies         : [OK] Found
) else (
    echo  Cookies         : [--] Not Found
)
echo.
echo  -- Archive Files --
if exist "!CONF_DIR!\twitter_arch.txt" echo  Twitter Archive : [OK] Active
if exist "!CONF_DIR!\tiktok_arch.txt"  echo  TikTok Archive  : [OK] Active
if exist "!CONF_DIR!\youtube_arch.txt" echo  YouTube Archive : [OK] Active
if exist "!CONF_DIR!\instagram_arch.txt" echo  Instagram Archive: [OK] Active
if exist "!CONF_DIR!\reddit_arch.txt"  echo  Reddit Archive  : [OK] Active
echo.
pause
goto :eof

:: =============================================================
:: VIEW LOGS
:: =============================================================

:view_logs
cls
echo.
echo  +=========================================================+
echo  :           DOWNLOAD LOGS                                  :
echo  +=========================================================+
echo  :                                                          :
echo  :   [1]  View Current Session Log                          :
echo  :   [2]  Open Logs Folder                                  :
echo  :   [3]  Clear All Logs                                    :
echo  :                                                          :
echo  :   [0]  Back to Main Menu                                 :
echo  :                                                          :
echo  +=========================================================+
echo.
set /p "log_opt=  Select Option: "
if "!log_opt!"=="0" goto :eof
if "!log_opt!"=="1" goto logs_view
if "!log_opt!"=="2" goto logs_open
if "!log_opt!"=="3" goto logs_clear
goto :eof

:logs_view
cls
echo.
echo  -- Current Session Log --
echo.
if exist "!LOG_FILE!" (
    type "!LOG_FILE!"
) else (
    echo  [i] Log file belum tersedia untuk sesi ini.
)
echo.
pause
goto :eof

:logs_open
explorer "!LOG_DIR!"
goto :eof

:logs_clear
set /p "confirm=  Hapus semua log? (Y/N): "
if /i "!confirm!" neq "Y" goto logs_clear_skip
del "!LOG_DIR!\*.log" 2>nul
echo  [OK] Semua log berhasil dihapus!
goto logs_clear_done
:logs_clear_skip
echo  [i] Operasi dibatalkan.
:logs_clear_done
pause
goto :eof

:: =============================================================
:: UTILITY FUNCTIONS
:: =============================================================

:check_cookies
if exist "!COOKIE_FILE!" exit /b 0
echo.
echo  ============================================================
echo   [WARNING] Cookie file tidak ditemukan!
echo  ============================================================
echo   Fitur ini memerlukan cookies untuk berfungsi.
echo   Buka Settings - Update Cookie File untuk setup.
echo  ============================================================
echo.
set /p "cont=  Lanjutkan tanpa cookies? Y/N: "
if /i "!cont!"=="Y" exit /b 0
exit /b 1

:: Locale-proof timestamp using wmic
:get_timestamp
for /f "skip=1 tokens=1" %%a in ('wmic os get LocalDateTime 2^>nul') do (
    set "DT=%%a"
    goto :parse_ts
)
:parse_ts
set "TS=!DT:~0,4!-!DT:~4,2!-!DT:~6,2! !DT:~8,2!:!DT:~10,2!:!DT:~12,2!"
set "TS_FILE=!DT:~0,4!!DT:~4,2!!DT:~6,2!_!DT:~8,2!!DT:~10,2!"
goto :eof

:: Safe logging - silently skip if log file is unavailable
:log
call :get_timestamp
echo [!TS!] %~1 >> "!LOG_FILE!" 2>nul
goto :eof

:: =============================================================
:: EXIT
:: =============================================================

:exit_program
call :log "=== Session Ended ==="
cls
echo.
echo  +=========================================================+
echo  :                                                          :
echo  :   Terima kasih telah menggunakan                         :
echo  :   Gallery-dl ULTIMATE Pro v2.0                           :
echo  :                                                          :
echo  :   Log tersimpan di: Logs\                                :
echo  :   Download di: Downloads\                                :
echo  :                                                          :
echo  +=========================================================+
echo.
timeout /t 3 >nul
endlocal
exit /b 0