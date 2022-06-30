# v 0.1
# Dockerfile for building the fastp image

# This image uses the Apline Linux operating system
FROM alpine

# Because the Alpine Linux is a bare-bones system, first thing we need to do is
# use the APK package manager to install the basic requirements for building
# software from source code:
RUN  apk add --no-cache --update autoconf \
        automake \
        libtool \ 
        nasm \
        yasm \
        git \
        build-base \
        ; \
    \
    # Fastp has two dependencies `isa-l` and `libdeflate` that are not
    # available from the APK package repository, so we must build them
    # from the source code on Github:
    git clone https://github.com/intel/isa-l.git; \
    cd isa-l && ./autogen.sh; \
    ./configure --prefix=/usr --libdir=/usr/lib64 && make && make install; \
    \
    git clone https://github.com/ebiggers/libdeflate.git; \
    cd libdeflate && make && make install; \
    \
    #Now we can download, build and install fastp from the Github source code:
    git clone https://github.com/OpenGene/fastp.git; \
    cd fastp && make && make install; \
    cd

# This sets an environmental variable so that fastp knows where the `isa-l`
# library is installed
ENV LD_LIBRARY_PATH /usr/lib64
# This next command defines the command that is issued when the image is run:
ENTRYPOINT ["fastp"]
