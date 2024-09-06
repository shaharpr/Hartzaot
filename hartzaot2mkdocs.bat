@echo off
echo Cleaning...
rmdir /s/q hartzaot-orig > nul
rmdir /s/q docs > nul
rmdir /s/q temp > nul
rmdir /s/q hartzaot-pdf > nul

echo Creating directories...
mkdir docs
mkdir temp
echo Extracting the lectures...
:: A hacky solution to point to the hebrew directory without hebrew characters
tar -x -f "%1" -C temp
FOR /D %%i IN (temp\*) DO move "%%i" .\hartzaot-orig
rmdir /s/q temp

echo Starting conversion...

echo 1. MARKDOWN
xcopy hartzaot-orig docs /E > nul

cd docs
setlocal ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
set /a count = 0

for /r %%i in (*.docx) do (
    set /a count += 1
    echo Processing %%i
    pushd %%~dpi
    pandoc -t gfm "%%~fi" -o "%%~dpni.md" --extract-media "images-!count!"
    del "%%~fi"
    popd
)
echo Done processing !count! files
endlocal
cd ..

echo 2. PDF
mkdir hartzaot-pdf
xcopy hartzaot-orig hartzaot-pdf /E > nul
:: docx2pdf is not recursive, so we need to scan directories manually
FOR /D %%i IN (hartzaot-pdf hartzaot-pdf\*) DO (
    echo Processing %%i...
    docx2pdf "%%i"
)
echo Done.