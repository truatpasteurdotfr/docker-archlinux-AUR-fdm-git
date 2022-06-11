FROM archlinux as build
MAINTAINER Tru Huynh <tru@pasteur.fr>

RUN pacman -Syu --noconfirm --needed base-devel
# root can not build, using a user with sudo priv.
RUN useradd build && usermod -L build
RUN echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
# fdm-git build requirements:
RUN pacman -Syu --noconfirm tdb git
USER build
RUN cd /tmp && curl 'https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=fdm-git' > PKGBUILD && makepkg 
# /tmp/fdm-git-20220601.fe7bc35-1-x86_64.pkg.tar.zst
#RUN rm -rf ~build && userdel build 
#
# copy to target container
USER root
FROM archlinux
COPY --from=build /tmp/fdm-git*.x86_64.pkg.tar.zst .
# install in target container
RUN pacman -Syu --noconfirm 
RUN pacman -U fdm-git*
RUN date +"%Y-%m-%d-%H%M" > /last_update
