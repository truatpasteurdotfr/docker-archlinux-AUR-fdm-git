FROM archlinux
MAINTAINER Tru Huynh <tru@pasteur.fr>

RUN pacman -Syu --noconfirm --needed base-devel
# root can not build, using a user with sudo priv.
RUN useradd build && usermod -L build
RUN echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
# fdm-git build requirements:
RUN pacman -Syu --noconfirm tdb git
USER build
RUN cd /tmp && curl 'https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=fdm-git' > PKGBUILD && makepkg 
USER root
#RUN pacman -U /tmp/*.pkg.tar.xz
#RUN rm -rf ~build && userdel build 
RUN date +"%Y-%m-%d-%H%M" > /last_update
