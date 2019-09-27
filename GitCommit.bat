rem @echo off
if not exist "%1" echo %S
cd %S
git add --all
git commit -m 'update'
git push
rem @echo on

pause