@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

:: ====================================================================
::
:: НАЗВАНИЕ:    main.cmd
:: ОПИСАНИЕ:    Главный скрипт-диспетчер.
:: АВТОР:       Наиль Марков
:: ВЕРСИЯ:      2.0 (08.07.2026)
::
:: ТРЕБОВАНИЯ:  Windows / Windows Server. Наличие прав на чтение/запуск в папках.
:: ЛОГИКА:      Проверяет заданные директории на наличие файлов.
::              Считает общее количество найденных файлов и их суммарный размер. 
::              Если файлы найдены — запускает целевой скрипт обработки. 
::              Ведет логирование всех действий в отдельный файл.
::
:: ====================================================================



:: 1. ПОДКЛЮЧЕНИЕ МОДУЛЕЙ ИЗ ПОДПАПОК
if exist "%~dp0config\settings.cmd" (
  call "%~dp0config\settings.cmd"
) else (
    echo [КРИТИЧЕСКАЯ ОШИБКА] Файл конфигурации config\settings.cmd не найден!
    exit /b 1
)

echo %DIR_LOGS%
@REM :: НАСТРОЙКИ
@REM set "LOG_FILE=%~dp0process_log.txt"
@REM set "TARGET_SCRIPT=%~dp0worker.cmd"

@REM :: Список директорий для проверки (разделять точкой с запятой)
@REM set "DIRS_TO_CHECK=C:\TargetDir1;C:\TargetDir2;D:\DataFolder"

@REM :: СБРОС СЧЕТЧИКОВ
@REM set /a TOTAL_FILES=0
@REM set /a TOTAL_SIZE_MB=0

@REM :: Инициализация лога
@REM echo =================================================== >> "%LOG_FILE%"
@REM echo [%DATE% %TIME%] ЗАПУСК ПРОВЕРКИ ДИРЕКТОРИЙ >> "%LOG_FILE%"
@REM echo =================================================== >> "%LOG_FILE%"

@REM :: ЦИКЛ ПЕРЕБОРА ДИРЕКТОРИЙ
@REM for %%D in ("%DIRS_TO_CHECK:;=" "%") do (
@REM     set "CURRENT_DIR=%%~D"
    
@REM     if exist "!CURRENT_DIR!" (
@REM         echo [%DATE% %TIME%] Проверка директории: !CURRENT_DIR! >> "%LOG_FILE%"
        
@REM         :: Внутренний цикл подсчета файлов в текущей папке
@REM         for /f "tokens=*" %%F in ('dir "!CURRENT_DIR!" /b /a-d 2^>nul') do (
@REM             set /a TOTAL_FILES+=1
            
@REM             :: Получаем размер файла в байтах
@REM             set "FILE_PATH=!CURRENT_DIR!\%%F"
@REM             for %%I in ("!FILE_PATH!") do (
@REM                 set /a FILE_SIZE_BYTES=%%~zI
@REM                 :: Переводим байты в мегабайты (грубое округление для CMD)
@REM                 set /a FILE_SIZE_MB=!FILE_SIZE_BYTES! / 1024 / 1024
@REM                 set /a TOTAL_SIZE_MB+=!FILE_SIZE_MB!
@REM             )
@REM         )
@REM     ) else (
@REM         echo [%DATE% %TIME%] [ПРЕДУПРЕЖДЕНИЕ] Директория не найдена: !CURRENT_DIR! >> "%LOG_FILE%"
@REM     )
@REM )

@REM :: ЗАПИСЬ ИТОГОВ В ЛОГ
@REM echo [%DATE% %TIME%] Найдено файлов всего: %TOTAL_FILES% >> "%LOG_FILE%"
@REM echo [%DATE% %TIME%] Общий размер (примерно): %TOTAL_SIZE_MB% МБ >> "%LOG_FILE%"

@REM :: ПРОВЕРКА НАЛИЧИЯ ФАЙЛОВ И ЗАПУСК СКРИПТАОБРАБОТКИ
@REM if %TOTAL_FILES% gtr 0 (
@REM     echo [%DATE% %TIME%] Файлы обнаружены. Запуск обработчика: %TARGET_SCRIPT% >> "%LOG_FILE%"
    
@REM     :: Запуск внешнего скрипта с перехватом ошибки
@REM     call "%TARGET_SCRIPT%"
    
@REM     if !errorlevel! neq 0 (
@REM         echo [%DATE% %TIME%] [ОШИБКА] Скрипт обработки завершился с кодом !errorlevel! >> "%LOG_FILE%"
@REM         goto :error_exit
@REM     )
@REM     echo [%DATE% %TIME%] Обработка успешно завершена. >> "%LOG_FILE%"
@REM ) else (
@REM     echo [%DATE% %TIME%] Файлы не найдены. Запуск обработчика отменен. >> "%LOG_FILE%"
@REM )

@REM echo [%DATE% %TIME%] ЗАВЕРШЕНИЕ РАБОТЫ СКРИПТА >> "%LOG_FILE%"
@REM exit /b 0

@REM :error_exit
@REM echo [%DATE% %TIME%] СКРИПТ ЗАВЕРШЕН С ОШИБКАМИ >> "%LOG_FILE%"
@REM exit /b 1