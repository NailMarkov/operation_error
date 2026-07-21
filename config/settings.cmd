@echo off

:: ========================================================================
::
:: НАЗВАНИЕ:    settings.cmd
:: ОПИСАНИЕ:    Создание переменных для дальнейшего использования в скриптах.
:: АВТОР:       Наиль Марков
:: ВЕРСИЯ:      2.0 (07.07.2026)
:: 
:: ОПИСАНИЕ:    Отсутствует.
::
:: ========================================================================

:: ==== PATHS OR DIRECTORIES ====

:: ==== Paths ===
set "DIR_CURRENT=D:\cmd\operation_error"
set "DIR_ARCHIVE=%DIR_CURRENT%\archive"
set "DIR_DATA=%DIR_CURRENT%\data"
set "DIR_LOGS=%DIR_CURRENT%\logs"
set "DIR_TEMP=%DIR_DATA%\temp"
set "DIR_FILES=D:\cmd\test_dir"

:: ==== Directories ====

set "DIR_TO_CHECK=D:\cmd\test_dir"

:: ==== FILES ====

:: ==== cmd ====

:: ==== txt ====
set "FILE_CONCLUSIONS=%DIR_DATA%\conclusions.txt"
set "FILE_CONCLUSIONS_OLD=%DIR_ARCHIVE%\conclusions_old.txt"
set "FILE_CONCLUSIONS_TEMP=%DIR_TEMP%\conclusions_temp.txt"