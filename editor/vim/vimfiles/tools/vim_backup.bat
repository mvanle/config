@echo off
call vim_setenv.bat unset
call vim_setenv.bat

zip -ur9S vim_config.zip "%VIM_CONFIG_DIR%\*vim*"
zip -ur9S vim_config.zip "%VIM_BATCH_DIR%"

call vim_setenv.bat unset
