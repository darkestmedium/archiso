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
WantedBy=sysinit.target" > ./archlive/airootfs/etc/systemd/system/plymouth-start.service



















# 2 Build the iso
sudo mkarchiso -v -w ./build -o ./iso ./archlive
