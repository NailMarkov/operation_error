@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: ====================================================================
::
:: НАЗВАНИЕ:    conclusions.cmd
:: ОПИСАНИЕ:    Очистка старых записей старше 30 дней.
:: АВТОР:       Наиль Марков
:: ВЕРСИЯ:      2.0 (20.07.2026)
::
:: ЛОГИКА:      1. Определяет текущий месяц/год и создаёт маркер вида "01.ММ.ГГГГ".
::              2. Построчно читает исходный файл: все строки ВЫШЕ маркера скидывает в ARCHIVE_FILE.
::              3. Как только маркер найден — он и все строки НИЖЕ него сохраняются в TEMP_FILE.
::              4. В конце TEMP_FILE заменяет собой исходный файл. Архив при этом дополняется.
::
:: ====================================================================

set "LOGGER=%DIR_LOGS%\logger.cmd"
:: set "FILE_CONCLUSIONS=D:\cmd\operation_error\data\conclusions.txt"
set "ARCHIVE_FILE=D:\cmd\operation_error\data\archive.txt"
set "TEMP_FILE=D:\cmd\operation_error\data\temp.txt"


:: Создаем маркер текущего месяца в формате 01.ММ.ГГГГ (например, 01.07.2026)
for /f "tokens=2 delims==" %%i in ('wmic os get localdatetime /value') do set "dt=%%i"
set "YYYY=%dt:~0,4%"
set "MM=%dt:~4,2%"
set "MARKER=21.%MM%.%YYYY%"

if not exist "%FILE_CONCLUSIONS%" (
  call "%LOGGER%" "ERROR" "Файл заключений не найден!"
  exit /b
)

:: Если на диске остался временный файл от прошлого запуска, удаляем его
if exist "%TEMP_FILE%" del "%TEMP_FILE%"

:: Создаем флаг-переключатель. 
set "FOUND_MARKER=0"

call "%LOGGER%" "INFO" "Начинаю поиск более ранних заключений..."

set "LINE_COUNT=0"
for /f "usebackq delims=" %%a in ("%FILE_CONCLUSIONS%") do (
  set "line=%%a"
  
  :: Проверяем: если текст текущей строки совпал с нашим маркером (01.ММ.ГГГГ),то переключаем в значение 1.
  if "!line!"=="%MARKER%" set "FOUND_MARKER=1"
  
  :: Проверяем состояние флага
  if "!FOUND_MARKER!"=="1" (
    echo !line!>>"%TEMP_FILE%"
  ) else (
    echo !line!>>"%ARCHIVE_FILE%"
    set /a LINE_COUNT+=1
  )
)
call "%LOGGER%" "INFO" "Перемещено в архив %LINE_COUNT% заключений"
:: Если маркер был найден, то временный файл успешно создался и наполнился новыми записями
if exist "%TEMP_FILE%" (
  :: Заменяем оригинальный рабочий файл временным файлом.
  move /y "%TEMP_FILE%" "%FILE_CONCLUSIONS%" >nul
)

:: Корректно завершаем сессию работы с переменными и закрываем скрипт
endlocal
exit /b
