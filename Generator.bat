@echo off
set /p scriptname="Script name: "
set /p scriptdescription="Script description: "
mkdir %scriptname%
echo fx_version 'adamant' > %scriptname%/fxmanifest.lua
echo game 'gta5' >> %scriptname%/fxmanifest.lua
echo description '%scriptdescription%' >> %scriptname%/fxmanifest.lua
echo version '1.0.0' >> %scriptname%/fxmanifest.lua
echo shared_scripts { >> %scriptname%/fxmanifest.lua
echo    './shared/config.lua' >> %scriptname%/fxmanifest.lua
echo } >> %scriptname%/fxmanifest.lua
echo server_scripts { >> %scriptname%/fxmanifest.lua
echo 	'./server/sv_main.lua' >> %scriptname%/fxmanifest.lua
echo } >> %scriptname%/fxmanifest.lua
echo client_scripts { >> %scriptname%/fxmanifest.lua
echo 	'./client/cl_main.lua', >> %scriptname%/fxmanifest.lua
echo } >> %scriptname%/fxmanifest.lua

cd %scriptname%
mkdir client
mkdir server
mkdir shared

cd client
copy NUL cl_main.lua
echo ESX = ESX > cl_main.lua
echo QBCore = QBCore >> cl_main.lua
echo if Config.Framework == "esx" then >> cl_main.lua
echo    CreateThread(function() >> cl_main.lua
echo        while ESX == nil do >> cl_main.lua
echo        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) >> cl_main.lua
echo        Wait(0) >> cl_main.lua
echo    end >> cl_main.lua
echo end) >> cl_main.lua

echo elseif Config.Framework == "qbcore" then >> cl_main.lua
echo    exports['qb-core']:GetCoreObject() >> cl_main.lua
echo else >> cl_main.lua
echo    print("Framework not set in Config.lua") >> cl_main.lua
echo end >> cl_main.lua

cd ..
echo ESX = ESX > server/sv_main.lua
echo QBCore = QBCore >> server/sv_main.lua
echo if Config.Framework == "esx" then >> server/sv_main.lua
echo        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) >> server/sv_main.lua
echo else >> server/sv_main.lua
echo        exports['qb-core']:GetCoreObject() >> server/sv_main.lua
echo end >> server/sv_main.lua

echo Config = {} or Config > shared/config.lua
echo Config.Framework = "esx" -- or "qbcore" >> shared/config.lua
