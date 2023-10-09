@echo off
reg.exe query HKLM\System\CurrentControlSet\Control /v PEFirmwareType
echo.
echo.
echo PEFirmwareType = 0x1 = BIOS mode
echo PEFirmwareType = 0x2 = UEFI mode
echo.
echo.
pause
