################################################################################
# Copyright (c) 2011-2013, Pacific Biosciences of California, Inc.
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# * Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
# * Neither the name of Pacific Biosciences nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
#
# NO EXPRESS OR IMPLIED LICENSES TO ANY PARTY'S PATENT RIGHTS ARE GRANTED BY
# THIS LICENSE.  THIS SOFTWARE IS PROVIDED BY PACIFIC BIOSCIENCES AND ITS
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
# PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL PACIFIC BIOSCIENCES OR
# ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
# IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
################################################################################
uninstall:
	echo $@; \
	rm -rf x64 i386

all: i386 x64

i386:
	@ \
        export    CPP="i686-w64-mingw32-cpp"                  \
                  CXX="i686-w64-mingw32-g++      -m32"        \
                   CC="i686-w64-mingw32-gcc      -m32"        \
                   FC="i686-w64-mingw32-gfortran -m32"        \
                  F90="i686-w64-mingw32-gfortran -m32"        \
               RANLIB="i686-w64-mingw32-ranlib"            && \
        cd zlib-1.2.8                                      && \
        test -e Makefile && make distclean || true         && \
        ./configure --static                                  \
                    --prefix=$$HOME/mingw64/i386           && \
        make install                                       && \
        cd ../szip-2.1                                     && \
        test -e Makefile && make distclean || true         && \
        ./configure --disable-shared                          \
                    --prefix=$$HOME/mingw64/i386              \
                    --host=i686-w64-mingw32                && \
        make install                                       && \
        cd ../hdf5-1.8.13                                  && \
        test -e Makefile && make distclean || true         && \
        CFLAGS="-DH5_HAVE_WIN32_API -DH5_BUILT_AS_STATIC_LIB" \
          LIBS="-lws2_32"                                     \
        ./configure --disable-shared                          \
            --disable-cxx                                     \
            --disable-fortran                                 \
            --enable-static-exec                              \
                --prefix=$$HOME/mingw64/i386                  \
             --with-zlib=$$HOME/mingw64/i386                  \
            --with-szlib=$$HOME/mingw64/i386                  \
            --host=i686-w64-mingw32                        && \
        make install
x64:
	@ \
        export    CPP=x86_64-w64-mingw32-cpp                  \
                  CXX="x86_64-w64-mingw32-g++      -m64"      \
                   CC="x86_64-w64-mingw32-gcc      -m64"      \
                   FC="x86_64-w64-mingw32-gfortran -m64"      \
                  F90="x86_64-w64-mingw32-gfortran -m64"      \
               RANLIB=x86_64-w64-mingw32-ranlib            && \
        cd zlib-1.2.8                                      && \
        test -e Makefile && make distclean || true         && \
        ./configure --static                                  \
                    --prefix=$$HOME/mingw64/x64            && \
        make install                                       && \
        cd ../szip-2.1                                     && \
        test -e Makefile && make distclean || true         && \
        ./configure --disable-shared                          \
                    --prefix=$$HOME/mingw64/x64               \
                    --host=x86_64-w64-mingw32              && \
        make install                                       && \
        cd ../hdf5-1.8.13                                  && \
        test -e Makefile && make distclean || true         && \
        CFLAGS="-DH5_HAVE_WIN32_API -DH5_BUILT_AS_STATIC_LIB" \
          LIBS="-lws2_32"                                     \
        ./configure --disable-shared                          \
            --disable-cxx                                     \
            --disable-fortran                                 \
            --enable-static-exec                              \
                --prefix=$$HOME/mingw64/x64                   \
             --with-zlib=$$HOME/mingw64/x64                   \
            --with-szlib=$$HOME/mingw64/x64                   \
            --host=x86_64-w64-mingw32                      && \
        make install
