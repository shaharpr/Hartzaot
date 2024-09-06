@echo off
rmdir /s/q hartzaot-orig
rmdir /s/q docs
mkdir docs
tar -axf "%~dp1"
ren "ספר הרצאות" hartzaot-orig
copy hartzaot-orig docs\
cd docs
setlocal ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
set /a count = 0

for /r %%i in (*) do (
    set /a count += 1
    echo Processing %%i
    pushd %%~dpi && pandoc -t gfm "%%~fi" -o "%%~dpni.md" --extract-media "images-!count!" && del "%%~fi" && popd
)
echo Done processing !count! files
endlocal