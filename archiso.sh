# https://wiki.archlinux.org/title/Archiso

# 1 Copy base specs to our archlive directory.
cp -r /usr/share/archiso/configs/releng/ ./archlive




# Login Manager
ls -l /etc/systemd/system/display-manager.service
ln -s /usr/lib/systemd/system/gdm.service ./archlive/airootfs/etc/systemd/system/display-manager.service

# Create Networking Services WiFi and Bluetooth
ln -s /usr/lib/systemd/system/NetworkManager.service ./archlive/airootfs/etc/systemd/system/multi-user.target.wants/NetworkManager.service
ln -s /usr/lib/systemd/system/bluetooth.service ./archlive/airootfs/etc/systemd/system/multi-user.target.wants/bluetooth.service




# Nvidia
# Enable NVIDIA Kernel Modules: Ensure the NVIDIA kernel modules are loaded at boot by creating a modprobe file in your ArchISO configuration:
mkdir -p ./archlive/airootfs/etc/modules-load.d/
echo "nvidia nvidia_modeset nvidia_uvm nvidia_drm" > ./archlive/airootfs/etc/modules-load.d/nvidia.conf
# Enable DRM Kernel Mode Setting (KMS): Add a configuration file for NVIDIA to enable DRM KMS, which is essential for using the NVIDIA GPU with Wayland:
echo "options nvidia_drm modeset=1" > ./archlive/airootfs/etc/modprobe.d/nvidia.conf
# Configure Xorg: If you’re using Xorg as a fallback, you’ll need an Xorg configuration file to specify the NVIDIA GPU. Place it under airootfs/etc/X11/xorg.conf.d/:
mkdir -p airootfs/etc/X11/xorg.conf.d
echo -e 'Section "Device"\n    Identifier "NVIDIA Card"\n    Driver "nvidia"\nEndSection' > airootfs/etc/X11/xorg.conf.d/20-nvidia.conf




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




# Creating local repositories from AUR packages
mkdir -p ./temp/aur-local && cd ./temp

# 1 Build the AUR Packages Locally: Download and build the desired AUR packages (brave-bin and visual-studio-code-bin in this case):

# Brave Browser
git clone https://aur.archlinux.org/brave-bin.git
cd brave-bin && makepkg -si --noconfirm
cd ..
mv brave-bin/*.pkg.tar.zst ./aur-local/

# Visual Studio Code
git clone https://aur.archlinux.org/visual-studio-code-bin.git
cd visual-studio-code-bin && makepkg -si --noconfirm
cd ..
mv visual-studio-code-bin/*.pkg.tar.zst ./aur-local/

# GitHub Desktop
git clone https://aur.archlinux.org/github-desktop-bin.git
cd github-desktop-bin && makepkg -si --noconfirm
cd ..
mv github-desktop-bin/*.pkg.tar.zst ./aur-local/

# Dash to Dock
git clone https://aur.archlinux.org/gnome-shell-extension-dash-to-dock.git
cd gnome-shell-extension-dash-to-dock && makepkg -si --noconfirm
cd ..
mv gnome-shell-extension-dash-to-dock/*.pkg.tar.zst ./aur-local/

# System Monitor
git clone https://aur.archlinux.org/gnome-shell-extension-system-monitor.git
cd gnome-shell-extension-system-monitor && makepkg -si --noconfirm
cd ..
mv gnome-shell-extension-system-monitor/*.pkg.tar.zst ./aur-local/

# Launch new Instance
git clone https://aur.archlinux.org/gnome-shell-extension-launch-new-instance.git
cd gnome-shell-extension-launch-new-instance && makepkg -si --noconfirm
cd ..
mv gnome-shell-extension-launch-new-instance/*.pkg.tar.zst ./aur-local/

# Rounded Window Corners Reborn
git clone https://aur.archlinux.org/gnome-shell-extension-rounded-window-corners-reborn-git.git
cd gnome-shell-extension-rounded-window-corners-reborn-git && makepkg -si --noconfirm
cd ..
mv gnome-shell-extension-rounded-window-corners-reborn-git/*.pkg.tar.zst ./aur-local/

# Tiling Shell
git clone https://aur.archlinux.org/gnome-shell-extension-tilingshell.git
cd gnome-shell-extension-tilingshell && makepkg -si --noconfirm
cd ..
mv gnome-shell-extension-tilingshell/*.pkg.tar.zst ./aur-local/

# Just 
git clone https://aur.archlinux.org/gnome-shell-extension-just-perfection-desktop.git
cd gnome-shell-extension-just-perfection-desktop && makepkg -si --noconfirm
cd ..
mv gnome-shell-extension-just-perfection-desktop/*.pkg.tar.zst ./aur-local/

# 3 Generate a Database for the Repository: Inside the /temp/customrepo directory, generate a repository database:
repo-add ./aur-local/aur-local.db.tar.gz ./aur-local/*.pkg.tar.zst

# 4 Update pacman.conf to Include the Custom Repository: Add your custom repository to archlive/pacman.conf to allow mkarchiso to use it during the image build process:
# [aur-local]
# SigLevel = Optional TrustAll
# Server = file:///temp/aur-local




# 2 Build the iso
sudo mkarchiso -v -w ./build -o ./iso ./archlive

# Lastly run and test in qemu
run_archiso -u -i ./iso/archlinux-2024.11.10-x86_64.iso






# Nvidia drivers
linux-headers
nvidia-open-dkms
nvidia-utils
nvidia-settings