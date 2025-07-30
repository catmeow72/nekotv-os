#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y git rsync sddm pipx
export PIPX_{,GLOBAL_}HOME=/var/cache/pipx
export PIPX_{,GLOBAL_}BIN_DIR="$PIPX_HOME/bin" PIPX_{,GLOBAL_}_MAN_DIR="$PIPX_HOME/share/man"
mkdir -p "$PIPX_HOME"
pipx install pipenv
mkdir -p /var/cache/{src,build,logs}

kde-builder --install-distro-packages --install-dir /usr --source-dir /var/cache/src --build-dir /var/cache/build --persietent-data-file /var/cache/kde-builder-persistent-data.json --no-install-login-session --log-dir /var/cache/logs plasma-bigscreen aura-browser plank-player
cp /container-data/session.desktop /usr/share/wayland-sessions/default.desktop
useradd -mU user
cat << EOF > /etc/sddm.conf.d/autologin.conf
[Autologin]
Relogin=true
Session=default
User=user
EOF

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
