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
:: ОПИСАНИЕ:    1. Определяет текущий месяц/год и создаёт маркер вида "01.ММ.ГГГГ".
::              2. Построчно читает исходный файл: все строки ВЫШЕ маркера скидывает в conclusions_old.txt.
::              3. Как только маркер найден — он и все строки НИЖЕ него сохраняются в conclusions_temp.txt.
::              4. В конце conclusions_temp.txt заменяет собой исходный файл. Архив при этом дополняется.
::
:: ====================================================================

set "LOGGER=%DIR_UTILS%\logger.cmd"
set "LINE_COUNT=0" 
set "FOUND_MARKER=0"

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
if exist "%FILE_CONCLUSIONS_TEMP%" del "%FILE_CONCLUSIONS_TEMP%"

call "%LOGGER%" "INFO" "Начинаю поиск более ранних заключений..."

for /f "usebackq delims=" %%a in ("%FILE_CONCLUSIONS%") do (
  set "line=%%a"
  
  :: Проверяем: если текст текущей строки совпал с нашим маркером (01.ММ.ГГГГ),то переключаем в значение 1.
  if "!line!"=="%MARKER%" set "FOUND_MARKER=1"
  
  :: Проверяем состояние флага
  if "!FOUND_MARKER!"=="1" (
    echo !line!>>"%FILE_CONCLUSIONS_TEMP%"
  ) else (
    echo !line!>>"%FILE_CONCLUSIONS_OLD%"
    set /a LINE_COUNT+=1
  )
)
call "%LOGGER%" "INFO" "Перемещено в архив %LINE_COUNT% заключений"

:: Если маркер был найден, то временный файл успешно создался и наполнился новыми записями
if exist "%FILE_CONCLUSIONS_TEMP%" (
  :: Заменяем оригинальный рабочий файл временным файлом.
  move /y "%FILE_CONCLUSIONS_TEMP%" "%FILE_CONCLUSIONS%" >nul
  call "%LOGGER%" "INFO" "Файл заключений обновлен"
)

call "%LOGGER%" "INFO" "Поиск более ранних заключений завершен"
endlocal
exit /b
