.RECIPEPREFIX = >

FLAGS = -f win64 $< -o $@

all: mandelbrot

debug: FLAGS += -g

mandelbrot: mandelbrot.obj rayview.obj
> /mnt/d/bin/GoLink.exe /entry start $^ C:/Windows/System32/kernel32.dll C:/Windows/System32/msvcrt.dll D:/work/raylib.dll

> chmod +x $@.exe

rayview.obj: rayview.asm
> nasm $(FLAGS)

mandelbrot.obj: framework.asm 
> nasm $(FLAGS)

clean:
> rm *.obj
> rm *.exe 
