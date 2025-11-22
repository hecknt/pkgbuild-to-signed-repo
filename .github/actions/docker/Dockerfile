FROM docker.io/archlinux/archlinux:base-devel

COPY system_files /

RUN pacman -Syu --noconfirm --needed git wget namcap sudo pacman-contrib namcap tree github-cli

# Create build user
RUN useradd -m --shell=/bin/bash build && usermod -L build && \
  echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
  echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

COPY scripts /

ENTRYPOINT ["/entrypoint.sh"]
