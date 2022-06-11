FROM archlinux
MAINTAINER Tru Huynh <tru@pasteur.fr>

RUN pacman -Syu --noconfirm --needed base-devel
# root can not build, using a user with sudo priv.
RUN useradd --no-create-home --shell=/bin/false build && usermod -L build
RUN echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER build
RUN curl 'https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=fdm-git' > PKGBUILD && makepkg 
USER root
RUN pacman -U *.pkg.tar.xz

RUN date +"%Y-%m-%d-%H%M" > /last_update
