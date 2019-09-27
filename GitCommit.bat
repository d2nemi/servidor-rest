rem @echo off
if not exist "%1" echo %1
cd %1
git add --all
git commit -m 'update'
git push
rem @echo on

pause