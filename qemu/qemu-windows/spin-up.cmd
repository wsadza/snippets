@echo off
setlocal EnableDelayedExpansion

:: FETCHING - QEMU
:: -------------------

:: Set the URL and output path
set URL=https://qemu.weilnetz.de/w64/2023/qemu-w64-setup-20231224.exe
set QEMU_DOWNLOAD_PATH=%USERPROFILE%/Downloads/qemu-w64-setup-20231224.exe
set QEMU_BINARY_PATH=%USERPROFILE%\qemu_core

if not exist "%QEMU_BINARY_PATH%" (

  :: fetch iso 
  if not exist "%QEMU_DOWNLOAD_PATH%" (
    curl -A "Wget" -o "%QEMU_DOWNLOAD_PATH%" "%URL%"
  )
  :: unzip iso
  7z.exe x "%QEMU_DOWNLOAD_PATH%" -o%QEMU_BINARY_PATH% -y
)
:: MISCS
:: -------------------
set QEMU_MISC_PATH=%QEMU_BINARY_PATH%/misc
set QEMU_DISK_PATH=%QEMU_BINARY_PATH%/disks/%~n0/

:: create misc directory
if not exist "%QEMU_MISC_PATH%" (
  mkdir "%QEMU_MISC_PATH%"
)

:: create disk directory
if not exist "%QEMU_DISK_PATH%" (
  mkdir "%QEMU_DISK_PATH%"
)

:: FETCHING - ISO
:: -------------------
SET ISO_PATH=%QEMU_MISC_PATH%/debian-12.4.0-amd64-netinst.iso
SET URL=https://chuangtzu.ftp.acc.umu.se/cdimage/weekly-builds/amd64/iso-cd/debian-testing-amd64-netinst.iso

if not exist "%ISO_PATH%" (
	curl -A "Wget" -o %ISO_PATH% "%URL%"
)

:: --------------------------------------

:: FETCHING - BIOS
:: -------------------
:: https://github.com/BlankOn/ovmf-blobs/blob/master/bios64.bin

SET BIOS_PATH=%QEMU_MISC_PATH%/OVMF.fd
SET URL=https://github.com/kholia/OSX-KVM/raw/326053dd61f49375d5dfb28ee715d38b04b5cd8e/OVMF_CODE.fd

if not exist "%BIOS_PATH%" (
	curl -L "%URL%" -o %BIOS_PATH%
)

:: --------------------------------------

:: VIRTUAL-MACHINE
:: -------------------

:: DISKS
:: -------------------

:: disk - a
:: -------------------
set QEMU_VM_DISK_NAME=disk-a
set QEMU_VM_DISK_SIZE=150G
set QEMU_VM_DISK_A_PATH=%QEMU_DISK_PATH%/%QEMU_VM_DISK_NAME%
if not exist "%QEMU_VM_DISK_A_PATH%" (
  %QEMU_BINARY_PATH%/qemu-img create -f qcow2 %QEMU_VM_DISK_A_PATH% %QEMU_VM_DISK_SIZE%
)
:: disk - b
:: -------------------
:: set QEMU_VM_DISK_NAME=disk-b
:: set QEMU_VM_DISK_SIZE=150G
:: set QEMU_VM_DISK_B_PATH=%QEMU_DISK_PATH%/%QEMU_VM_DISK_NAME%
:: if not exist "%QEMU_VM_DISK_B_PATH%" (
::  %QEMU_BINARY_PATH%/qemu-img create -f qcow2 %QEMU_VM_DISK_B_PATH% %QEMU_VM_DISK_SIZE%
::)

:: INSTANCE
:: -------------------

set QEMU_VM_PORT_SSH=7000
:: set QEMU_VM_PORT_SSH=%~n0
set QEMU_VM_PORT_HTTP_A=80
set QEMU_VM_PORT_HTTP_B=6445
set QEMU_VM_PORT_HTTP_C=443

SET INVOKE=^
  %QEMU_BINARY_PATH%/qemu-system-x86_64.exe ^
  -accel whpx,kernel-irqchip=off ^
  -bios %BIOS_PATH% ^
  -machine q35 ^
  -m 8192 ^
  -boot d ^
  -smp 4 ^
  -cdrom %ISO_PATH% ^
  -net nic,model=virtio ^
  -hda %QEMU_VM_DISK_A_PATH% ^
  -net user,hostfwd=tcp::%QEMU_VM_PORT_SSH%-:22,hostfwd=tcp::%QEMU_VM_PORT_HTTP_A%-:80,hostfwd=tcp::%QEMU_VM_PORT_HTTP_B%-:6445,hostfwd=tcp::%QEMU_VM_PORT_HTTP_C%-:443

%INVOKE%
