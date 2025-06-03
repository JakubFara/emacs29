FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
  autoconf automake build-essential \
  libgtk-3-dev libgnutls28-dev libtiff-dev libgif-dev libjpeg-dev libxpm-dev \
  libncurses-dev libxml2-dev libjansson-dev libharfbuzz-dev libtree-sitter-dev \
  gcc-10 g++-10 libgccjit-10-dev libvterm-dev texinfo \
  x11-apps curl git sudo && \
  apt clean

# Add dev user
RUN useradd -ms /bin/bash dev && echo "dev ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER dev
WORKDIR /home/dev

# Symlink libgccjit.so so the linker finds it
RUN sudo ln -s /usr/lib/gcc/x86_64-linux-gnu/10/libgccjit.so /usr/lib/libgccjit.so

# Clone and build Emacs
RUN git clone --depth 1 --branch emacs-29.3 https://github.com/emacs-mirror/emacs.git emacs && \
    cd emacs && \
    export GCCJIT_INCLUDE="/usr/lib/gcc/x86_64-linux-gnu/10/include" && \
    export GCCJIT_LIB="/usr/lib/gcc/x86_64-linux-gnu/10" && \
    export CFLAGS="-I$GCCJIT_INCLUDE" && \
    export LDFLAGS="-L$GCCJIT_LIB" && \
    ./autogen.sh && \
    ./configure --with-native-compilation=aot \
                --with-json \
                --with-tree-sitter \
                --with-x-toolkit=gtk3 \
                --with-modules && \
    make -j$(nproc) && \
    sudo make install

# Setup home config
RUN mkdir -p /home/dev/.emacs.d && chown -R dev:dev /home/dev/.emacs.d

CMD ["bash"]
