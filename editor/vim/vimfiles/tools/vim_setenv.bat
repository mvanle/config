@echo off
set VIM_HOME=C:\Program Files (x86)\Vim\vim74
set VIM_BATCH_DIR=c:\batch\vim
set VIM_CONFIG_DIR=%HOMEDRIVE%%HOMEPATH%
set VIM_CONFIG_FILE=%VIM_CONFIG_DIR%\_vimrc

if "%1" == "unset" (
	set VIM_HOME=
	set VIM_BATCH_DIR=
	set VIM_CONFIG_DIR=
	set VIM_CONFIG_FILE=
)
