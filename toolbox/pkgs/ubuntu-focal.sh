#!/bin/sh
# Query the linker version
ld -v || true

# Query the (g)libc version
ldd --version || true

# Unattended update, upgrade, and install
export DEBIAN_FRONTEND=noninteractive
export DEBIAN_PRIORITY=critical
apt-get -qy update
apt-get -qy \
  -o "Dpkg::Options::=--force-confdef" \
  -o "Dpkg::Options::=--force-confold" upgrade
apt-get -qy --no-install-recommends install apt-utils
apt-get -qy autoclean
apt-get -qy install \
 autoconf \
 bash \
 build-essential \
 clang-format \
 findutils \
 git \
 libaio-dev \
 libcunit1-dev \
 libncurses5-dev \
 libnuma-dev \
 libssl-dev \
 libtool \
 make \
 nasm \
 openssl \
 patch \
 pipx \
 pkg-config \
 python3 \
 python3-pip \
 python3-pyelftools \
 python3-venv \
 uuid-dev

# Install packages via the Python package-manager (pip)
python3 -m pip install --upgrade pip
python3 -m pip install \
 meson \
 ninja

# Clone, build and install liburing v2.2
git clone https://github.com/axboe/liburing.git
cd liburing
git checkout liburing-2.2
./configure
make
make install
cd ..

#
# Clone, build and install libvfn
#
# Assumptions:
#
# - These commands are executed with sufficient privileges (sudo/root)
#
git clone https://github.com/OpenMPDK/libvfn.git
cd libvfn
git checkout v2.0.2
meson setup builddir -Dlibnvme="disabled" -Ddocs="disabled" --prefix=/usr
meson compile -C builddir
meson install -C builddir
cd ..

