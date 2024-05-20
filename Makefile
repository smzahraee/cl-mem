# Change this path if the SDK was installed in a non-standard location
OPENCL_HEADERS = "/opt/poky/5.0.1/sysroots/cortexa55-poky-linux/usr/include/CL"
# By default libOpenCL.so is searched in default system locations, this path
# lets you adds one more directory to the search path.
LIBOPENCL = "/opt/poky/5.0.1/sysroots/cortexa55-poky-linux/usr/lib"
# Specify the sysroot
SYSROOT = "/opt/poky/5.0.1/sysroots/cortexa55-poky-linux"

# Cross-compiler tools
CROSS_COMPILE = aarch64-poky-linux-
CC = ${CROSS_COMPILE}gcc
CXX = ${CROSS_COMPILE}g++
AR = ${CROSS_COMPILE}ar

CPPFLAGS = -std=gnu99 -pedantic -Wextra -Wall -ggdb \
    -Wno-deprecated-declarations \
    -Wno-overlength-strings \
    -I${OPENCL_HEADERS}
CFLAGS = --sysroot=${SYSROOT} -march=armv8-a
LDFLAGS = --sysroot=${SYSROOT} -L${LIBOPENCL}
LDLIBS = -lOpenCL
OBJ = main.o
INCLUDES = config.h _kernel.h
EXE = cl-mem

all : ${EXE}

${EXE} : ${OBJ}
	${CC} ${CFLAGS} -o $@ ${OBJ} ${LDFLAGS} ${LDLIBS} -O2

${OBJ} : ${INCLUDES}

_kernel.h : input.cl config.h  
	echo 'const char *ocl_code = R"_mrb_(' >$@
	cpp $< >>$@
	echo ')_mrb_";' >>$@

clean :
	rm -f ${EXE} _kernel.h *.o _temp_*

re : clean all

.cpp.o :
	${CC} ${CPPFLAGS} ${CFLAGS} -o $@ -c $<
