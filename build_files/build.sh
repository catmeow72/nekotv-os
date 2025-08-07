#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y git rsync sddm curl
#mkdir -p /var/cache/root
rsync -rPaEpl --mkpath --chown $(id -u):$(id -g) /etc/skel /var/cache/root
#rsync -rPaEpl --mkpath /ctx/root /var/cache
ln -sf /var/cache/root /root
mkdir -p /root/.local/bin /root/.config
export PATH="$HOME/.local/bin:$PATH"
mkdir -p /var/cache/{src,build,logs}
cd "$HOME"
curl 'https://invent.kde.org/sdk/kde-builder/raw/master/scripts/initial_setup.sh?ref_type=heads' > initial_setup.sh
{ yes || true ; } | bash initial_setup.sh
mv /ctx/container-data/kde-builder.yaml "$HOME/.config/kde-builder.yaml"
kde-builder --install-distro-packages --prompt-answer y plasma-bigscreen aura-browser plank-player plasma-remotecontrollers
cp /ctx/container-data/session.desktop /usr/share/wayland-sessions/default.desktop
useradd -mU user
cat << EOF > /etc/sddm.conf.d/autologin.conf
[Autologin]
Relogin=true
Session=default
User=user
EOF
FCAST_ARCH="build"
VACUUMTUBE_ARCH="build"
case "$(uname -m)" in
	x86_64)
		FCAST_ARCH="x64"
		VACUUMTUBE_ARCH="arm64"
		;;
	aarch64)
		FCAST_ARCH="arm64"
		VACUUMTUBE_ARCH="arm64"
		;;
	*)
		echo "Error: Unsupported architecture." >&2
		exit 1
		;;
esac

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging
FCAST_VERSION="$(git -c 'versionsort.suffix=-' ls-remote --tags --sort='v:refname' https://github.com/futo-org/fcast | grep "electron" | tail -n1 | cut -d/ -f3 | sed 's/^electron-//' | sed 's/^v//')"
dnf5 -y install "https://dl.fcast.org/electron/$FCAST_VERSION/rpm/$FCAST_ARCH/fcast-receiver-$FCAST_VERSION-linux-$FCAST_ARCH.rpm"
VERSION="$(git -c "versionsort.suffix=-" ls-remote --tags --sort='v:refname' https://github.com/shy1132/VacuumTube.git | tail -n1 | cut -d/ -f3)"
wget --continue "https://github.com/shy1132/VacuumTube/releases/download/$VERSION/VacuumTube-$VACUUMTUBE_ARCH.tar.gz" -O "/var/cache/VacuumTube-$VACUUMTUBE_ARCH-$VERSION.tar.gz"
mkdir -p /usr/lib/vacuum-tube
tar -xvf "/var/cache/VacuumTube-$VACUUMTUBE_ARCH-$VERSION.tar.gz" --strip-components 1 -C /usr/lib/vacuum-tube
cat << EOF > /usr/bin/startvacuumtube
#!/bin/sh
/usr/lib/vacuumtube "\$@"
EOF
mkdir -p /usr/share/icons/hicolor/scalable/apps
wget "https://github.com/shy1132/VacuumTube/blob/$VERSION/assets/icon.svg" -O "/var/cache/vacuumtube-icon-$VERSION.svg" --continue
wget "https://github.com/shy1132/VacuumTube/blob/$VERSION/flatpak/rocks.shy.VacuumTube.metainfo.xml" -O "/var/cache/rocks.shy.VacuumTube-$VERSION.metainfo.xml" --continue
wget "https://github.com/shy1132/VacuumTube/blob/$VERSION/flatpak/rocks.shy.VacuumTube.desktop" -O "/var/cache/rocks.shy.VacuumTube-$VERSION.desktop" --continue
cp "/var/cache/rocks.shy.VacuumTube-$VERSION.metainfo.xml" /usr/share/metainfo/rocks.shy.VacuumTube.metainfo.xml
cp "/var/cache/rocks.shy.VacuumTube-$VERSION.desktop" /usr/share/applications/rocks.shy.VacuumTube.desktop
cp "/var/cache/vacuumtube-icon-$VERSION.svg" /usr/share/icons/hicolor/scalable/apps/rocks.shy.VacuumTube.svg
#### Example for enabling a System Unit File
systemctl enable sddm
#systemctl enable podman.socket
rm -f /root
ln -sf var/roothome /root
systemctl enable getty@ttyS0.service
