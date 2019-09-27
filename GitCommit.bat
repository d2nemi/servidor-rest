@echo off
if not exist "%1" exit 
cd %1

git add --all
git commit -m 'update'
git push

@echo on
