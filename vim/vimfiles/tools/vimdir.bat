:: 
:: Convenience script
::

@echo off
call vim_setenv.bat unset
call vim_setenv.bat

:: getopts
if "%1" == "cd" (
    set cmd=cd /d
    goto cdparms
) else if "%1" == "explorer" (
    set cmd=explorer
    goto cdparms
) else if "%1" == "edit" (
    if "%2" == "config"                     set edit_vim_config_file=t
    if "%2" == ".vimrc"                     set edit_vim_config_file=t
    if "%2" == "vimdir.bat"                 set edit_vimdir_bat_file=t
    if "%2" == "vimdir"                     set edit_vimdir_bat_file=t
    if "%2" == "setenv"                     set edit_vim_setenv_bat_file=t
) 
goto do_opts

:cdparms
    if "%2" == "home"                       set cd_home_dir=t
    if "%2" == "bin"                        set cd_home_dir=t
    if "%2" == "config"                     set cd_config_dir=t
    if "%2" == "vimfiles"                   set cd_vimfiles_dir=t
    if "%2" == "tools"                      set cd_tools_dir=t

:: do opts
:do_opts

if "%cd_home_dir%" == "t"                   %cmd% "%VIM_HOME%"
if "%cd_config_dir%" == "t"                 %cmd% "%VIM_CONFIG_DIR%"
if "%cd_vimfiles_dir%" == "t"               %cmd% "%VIM_CONFIG_DIR%\vimfiles"
if "%cd_tools_dir%" == "t"                  %cmd% "%VIM_CONFIG_DIR%\vimfiles\tools"

if "%edit_vim_config_file%" == "t"          cmd /c gvim "%VIM_CONFIG_FILE%"
if "%edit_vimdir_bat_file%" == "t"          cmd /c gvim "%VIM_BATCH_DIR%\vimdir.bat"
if "%edit_vim_setenv_bat_file%" == "t"      cmd /c gvim "%VIM_BATCH_DIR%\vim_setenv.bat"

:: unset env
call vim_setenv.bat unset

set edit_vim_config_file=
set edit_vimdir_bat_file=
set edit_vim_setenv_bat_file=

set cd_home_dir=
set cd_config_dir=
set cd_vimfiles_dir=
