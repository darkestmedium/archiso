# https://wiki.archlinux.org/title/Archiso

# 1 Copy base specs to our archlive directory
cp -r /usr/share/archiso/configs/releng/ ./archlive

# Login manager
ln -s /usr/lib/systemd/system/gdm.service ./archlive/airootfs/etc/systemd/system/display-manager.service




# 2 Build the iso
sudo mkarchiso -v -w ./build -o ./iso ./archlive
