FROM ubuntu:16.04
MAINTAINER Anthony Zhang <azhang9@gmail.com>

# this basically sets up a Docker image according to the instructions on https://www.student.cs.uwaterloo.ca/~build/common/Install161NonCS.html
# a copy of that page is also included in this repository in case the URL ever changes or goes down

# preliminary setup
RUN apt-get update
RUN apt-get install software-properties-common --yes
RUN apt-get update
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get install build-essential --yes
RUN apt-get install gcc-4.9 --yes
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 50 # compile everything with GCC 4.9

# step 1: download all of the files listed in the Step 1 table on the instructions page into the current folder

# step 2: install binutils for os161
ADD os161-binutils.tar.gz /build
WORKDIR /build/binutils-2.17+os161-2.0.1
RUN ./configure --nfp --disable-werror --target=mips-harvard-os161 --prefix=/sys161/tools
RUN make
RUN make install

# step 3: put sys161 stuff on the PATH
RUN mkdir /sys161/bin
ENV PATH /sys161/bin:/sys161/tools/bin:$PATH

# step 4: install GCC MIPS cross-compiler
ADD os161-gcc.tar.gz /build
WORKDIR /build/gcc-4.1.2+os161-2.0
RUN ./configure -nfp --disable-shared --disable-threads --disable-libmudflap --disable-libssp --target=mips-harvard-os161 --prefix=/sys161/tools
RUN make
RUN make install

# step 5: install GDB for os161
RUN apt-get install libncurses5-dev --yes
ADD os161-gdb.tar.gz /build
WORKDIR /build/gdb-6.6+os161-2.0
RUN ./configure --target=mips-harvard-os161 --prefix=/sys161/tools --disable-werror
RUN make
RUN make install

# step 6: install bmake for os161
ADD os161-bmake.tar.gz /build
ADD os161-mk.tar.gz /build
WORKDIR /build/bmake
RUN ./boot-strap --prefix=/sys161/tools | sed '1,/Commands to install into \/sys161\/tools\//d' | bash

# step 7: set up links for toolchain binaries
RUN mkdir --parents /sys161/bin
WORKDIR /sys161/tools/bin
RUN sh -c 'for i in mips-*; do ln -s /sys161/tools/bin/$i /sys161/bin/build-`echo $i | cut -d- -f4-`; done' 
RUN ln -s /sys161/tools/bin/bmake /sys161/bin/bmake

# step 8: install sys161
ADD sys161.tar.gz /build
WORKDIR /build/sys161-1.99.06
RUN ./configure --prefix=/sys161 mipseb
RUN make
RUN make install
RUN ln -s /sys161/share/examples/sys161/sys161.conf.sample /sys161/sys161.conf

# step 9: install os161
VOLUME /cs350-os161 # extracting the archive should be done on the host side

# step 10: clean up resources
RUN rm -r /build

# make sure to start commands in the os161 folder
WORKDIR /cs350-os161
