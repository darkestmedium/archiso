# https://wiki.archlinux.org/title/Archiso

# 1 Copy base specs to our archlive directory.
cp -r /usr/share/archiso/configs/releng/ ./archlive




# Login Manager
ls -l /etc/systemd/system/display-manager.service
ln -s /usr/lib/systemd/system/gdm.service ./archlive/airootfs/etc/systemd/system/display-manager.service

# Create Networking Services WiFi and Bluetooth
ln -s /usr/lib/systemd/system/NetworkManager.service ./archlive/airootfs/etc/systemd/system/multi-user.target.wants/NetworkManager.service
ln -s /usr/lib/systemd/system/bluetooth.service ./archlive/airootfs/etc/systemd/system/multi-user.target.wants/bluetooth.service


# Plymouth
# 1 Edit mkinitcpio.conf: In the ArchISO profile, navigate to the
# airootfs/etc/mkinitcpio.conf.d/archiso.conf file.
# Edit the HOOKS line to include plymouth, just like on a regular system:
# HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont block plymouth filesystems fsck)

# 2 Edit syslinux.cfg or loader/entries/archiso.conf: If you are using syslinux as the bootloader,
# open the syslinux/archiso_sys.cfg file and add the quiet splash parameters to the kernel line:
# If you’re using systemd-boot, edit loader/entries/archiso.conf:
# title   Arch Linux ISO
# linux   /vmlinuz-linux
# initrd  /initramfs-linux.img
# options archisobasedir=arch archisolabel=ARCH_YYYYMM quiet splash

echo "[Unit]
Description=Plymouth Boot Screen
After=systemd-udev-trigger.service
DefaultDependencies=no

[Service]
ExecStart=/usr/bin/plymouthd --mode=boot
ExecStartPost=/usr/bin/plymouth --show-splash
ExecStopPost=/usr/bin/plymouth --quit

[Install]
WantedBy=sysinit.target" > ./archlive/airootfs/etc/systemd/system/sysinit.target.wants/plymouth.service

# Custom plymouth theme
mkdir -p ./archlive/airootfs/usr/share/plymouth/themes/YourTheme
cp -r /usr/share/plymouth/themes/YourTheme ./archlive/airootfs/usr/share/plymouth/themes/

mkdir -p ./archlive/airootfs/etc/plymouth/
echo "[Daemon]
Theme=logo-mac-style" > ./archlive/airootfs/etc/plymouth/plymouthd.conf


# Fonts
# Intel One Mono
wget https://github.com/intel/intel-one-mono/releases/download/V1.4.0/ttf.zip; unzip ttf.zip
sudo mkdir -p ./archlive/airootfs/usr/share/fonts/ttf/intel-one-mono
sudo cp ./ttf/*.ttf ./archlive/airootfs/usr/share/fonts/ttf/intel-one-mono;
sudo rm -r ./ttf.zip ./ttf

# IBM Plex
wget https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-sans%401.0.0/ibm-plex-sans.zip; unzip ibm-plex-sans.zip
sudo mkdir -p ./archlive/airootfs/usr/share/fonts/ttf/ibm-plex-sans
sudo cp ./ibm-plex-sans/fonts/complete/ttf/*.ttf ./archlive/airootfs/usr/share/fonts/ttf/ibm-plex-sans
sudo rm -r ./ibm-plex-sans ./ibm-plex-sans.zip


# Enable fractional scaling on all electron apps under wayland - requires reboot
# sudo mkdir -p ./archlive/airootfs/etc/environment
echo "ELECTRON_OZONE_PLATFORM_HINT=auto" | sudo tee -a ./archlive/airootfs/etc/environment














# 2 Build the iso
sudo mkarchiso -v -w ./build -o ./iso ./archlive


run_archiso -u -i ./iso/archlinux-2024.11.08-x86_64.iso

