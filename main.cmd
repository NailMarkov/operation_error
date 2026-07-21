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
:: ОПИСАНИЕ:      Проверяет заданные директории на наличие файлов.
::              Считает общее количество найденных файлов и их суммарный размер. 
::              Если файлы найдены — запускает целевой скрипт обработки. 
::              Ведет логирование всех действий в отдельный файл.
::
:: ====================================================================

:: Подключение зависимостей
if exist "%~dp0config\settings.cmd" (
  call "%~dp0config\settings.cmd"
) else (
  echo %DATE%_%TIME% [КРИТИЧЕСКАЯ ОШИБКА] Файл конфигурации config\settings.cmd не найден! > logs\error_start.txt
  exit
)

:: Форматирование даты для имени файла (ДД-ММ-ГГГГ)
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set "dt=%%I"
set "FILE_LOG=%DIR_LOGS%\process_log_%dt:~6,2%-%dt:~4,2%-%dt:~0,4%.log"
set "CURRENT_DATE=%dt:~6,2%.%dt:~4,2%.%dt:~0,4%"

:: Проверяет наличие лог файла
if NOT EXIST %FILE_LOG% call :function_write_start

call "%~dp0logs\logger.cmd" "INFO" "Запуск процесса обработки..."

call "%~dp0logs\logger.cmd" "INFO" "Проверяю наличие файлов в директории %DIR_TO_CHECK%"

:: Цикл FOR /R находит абсолютно все подпапки (включая вложенные)
for /r "%DIR_TO_CHECK%" %%D in (.) do (
  set "CURRENT_DIR=%%~fD"
    
  if /i not "!CURRENT_DIR!"=="%DIR_TO_CHECK%" (  
    :: Сбрасываем счетчики для каждой папки
    set "FILE_COUNT=0"
    set "TOTAL_SIZE=0"

    :: Цикл FOR /F считает файлы только в ТЕКУЩЕЙ подпапке (без ухода глубже)
    for /f "delims=" %%F in ('dir "!CURRENT_DIR!" /b /a-d 2^>nul') do (
      set /a FILE_COUNT+=1

      :: Получаем размер конкретного файла
      for %%I in ("!CURRENT_DIR!\%%F") do (
        set /a TOTAL_SIZE+=%%~zI
      )
    )

    :: Если в текущей папке есть файлы, выводим данные и запускаем скрипт
    if !FILE_COUNT! gtr 0 (
      call "%~dp0logs\logger.cmd" "INFO" "Найдена папка с файлами: !CURRENT_DIR!"
      call "%~dp0logs\logger.cmd" "INFO" "Количество файлов в папке: !FILE_COUNT!"
      call "%~dp0logs\logger.cmd" "INFO" "Размер файлов: !TOTAL_SIZE! байт"

    ) else (
      call "%~dp0logs\logger.cmd" "WARNING" "В папке !CURRENT_DIR! файлы отсутствуют"
    )
  )
)

if "%CURRENT_DATE%"=="21.07.2026" (
  call "%~dp0utils\conclusions.cmd"
)
call "%~dp0logs\logger.cmd" "INFO" "Запуск процесса обработки завершен"
goto :eof

:: Создает файл логирования
:function_write_start

echo :: ===================================== > "%FILE_LOG%"
echo :: Старт логирования в файл >> "%FILE_LOG%"
echo :: Путь к файлу - "%FILE_LOG%" >> "%FILE_LOG%"
echo :: Дата создания - %DATE% >> "%FILE_LOG%"
echo :: ===================================== >> "%FILE_LOG%"
echo. >> "%FILE_LOG%"

goto :eof