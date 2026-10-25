#!/bin/sh
# Run inside a fresh Debian trixie amd64 container as root.
set -eu
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends \
  gcc libc6-dev libglib2.0-bin python3 python3-gi gir1.2-gtk-3.0 libgtk-3-bin librsvg2-common \
  cryptsetup-bin dmsetup gdisk parted udev dosfstools e2fsprogs util-linux \
  psmisc openssl sbsigntool initramfs-tools-core squashfs-tools cpio gzip zstd \
  coreutils dash findutils grep sed tar ca-certificates fonts-dejavu-core \
  adwaita-icon-theme gsettings-desktop-schemas shared-mime-info dpkg-dev \
  xvfb xauth dbus-x11
useradd --create-home builder
cp -a /source /home/builder/source
chown -R builder:builder /home/builder/source
runuser -u builder -- sh -eu -c '
  cd /home/builder/source
  xvfb-run -a dbus-run-session -- python3 -B -m unittest discover -s local/installer/tests
  python3 -B local/installer/build-package.py --output dist
  python3 -B local/installer/build-portable.py --output dist
  dist/bloom-*-linux-amd64/bloom --portable-check
  dist/bloom-*-linux-amd64/bloom --help
  mkdir -p "/home/builder/relocated app"
  tar -xzf dist/bloom-*-linux-amd64.tar.gz -C "/home/builder/relocated app"
  "/home/builder/relocated app/"bloom-*-linux-amd64/bloom --portable-check
  (cd dist && sha256sum -c ./*.sha256)
'
mkdir -p /output
cp /home/builder/source/dist/*.deb /home/builder/source/dist/*.tar.gz \
   /home/builder/source/dist/*.sha256 /output/
