@echo off
:: ========================================================================
::
:: НАЗВАНИЕ:    path.cmd
:: ОПИСАНИЕ:    Создание переменных для дальнейшего использования в скриптах.
:: АВТОР:       Наиль Марков
:: ВЕРСИЯ:      2.0 (07.07.2026)
:: 
:: ТРЕБОВАНИЯ:  Windows / Windows Server. Наличие прав на чтение/запуск в папках.
:: ЛОГИКА:      Отсутствует.
::
:: ========================================================================

:: ==== PATHS OR DIRECTORIES ====

:: ==== Paths ===
set "DIR_CURRENT=D:\cmd\operation_error"
set "DIR_LOGS=%DIR_CURRENT%\logs"
set "DIR_FILES=D:\cmd\test_dir"

:: ==== Directories ====
:: Список директорий для проверки (разделять точкой с запятой)
set "DIRS_TO_CHECK=%DIR_FILES%\In;%DIR_FILES%\Out;%DIR_FILES%\AnyWay;%DIR_FILES%\Error"

:: ==== FILES ====

:: ==== txt ====
set FILE_LOG=%DIR_LOGS%\process_log.txt
