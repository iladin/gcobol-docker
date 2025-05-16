FROM almalinux:9.5

ENV GCC_VERSION=15.1.0

# Install build dependencies
RUN dnf groupinstall -y "Development Tools" && \
    dnf install -y \
    wget \
    tar \
    gcc \
    gcc-c++ \
    gmp-devel \
    mpfr-devel \
    libmpc-devel \
    flex \
    bison \
    ncurses-devel \
    gettext \
    autoconf \
    automake \
    libtool \
    make \
    git \
    byacc \
    glibc-devel \
    zlib-devel \
    which
    #    texinfo \
    #    isl-devel \ 

WORKDIR /usr/local/src

# Download and build GCC 15.1
RUN wget https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.xz && \
    tar -xf gcc-${GCC_VERSION}.tar.xz && \
    cd gcc-${GCC_VERSION} && \
    ./contrib/download_prerequisites && \
    mkdir ../gcc-build && cd ../gcc-build && \
    ../gcc-${GCC_VERSION}/configure \
        --prefix=/usr/local/gcc-${GCC_VERSION} \
        --disable-multilib \
        --enable-languages=c,c++,cobol \
        --disable-bootstrap && \
    make -j$(nproc) && \
    make install && \
    cd .. && { rm -rf gcc* || true; }
