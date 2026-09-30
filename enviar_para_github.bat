@echo off
title Enviando Projeto para o GitHub
cd /d "C:\Users\Ycaro\Downloads\projeto_camera"
set "PATH=%LOCALAPPDATA%\MinGit\cmd;%PATH%"
echo ========================================================
echo   Enviando o projeto para https://github.com/yceaf/mobile-restaurante.git
echo ========================================================
echo.
echo Uma janela do navegador pode se abrir para autorizar o GitHub.
echo.
git push -u origin main --force
echo.
if %ERRORLEVEL% EQU 0 (
    echo ========================================================
    echo   [SUCESSO] Arquivos enviados com sucesso!
    echo   Acesse: https://yceaf.github.io/mobile-restaurante/
    echo ========================================================
) else (
    echo ========================================================
    echo   Ocorreu um erro no envio. Verifique o login no GitHub.
    echo ========================================================
)
echo.
pause
