# SMG-language
hi! this is a programming language i made. note, that there is a help.md or whatever i named it in the explanation folder.

info:
Always, when you are linking it, remember!
you need gcc. the command im talking about is
gcc data.obj -o data.exe -nostdlib -Wl,-e,main -lkernel32
you need... msys2
so first
install msys2
then, open the mingw32 terminal (SMG is x86!)
then, install the packages using
pacman -S mingw-w64-i686-gcc
cd into smgcompiler, and then source
after that, make a .smg file
welp, now you can code :D
FIRST, do
glb main
main:
.txt is optional, like
glb main
.txt
main:

after that, u can do
set eax, 6
plus ebx, 7
minux eax, 3
and more
this is the 1.0.0 version, so expect bugs and yes, 15 keywords
after that, run

./SMGcompiler -f yourFile.smg

after that you will see the .obj
after that, link with gcc using 
gcc data.obj -o data.exe -nostdlib -Wl,-e,main -lkernel32
and u have a native assembly speed executable!

its pretty much assembly but more readable, the same speed, and cooler
though note this!
NEVER PULL OUT SMGCOMPILER WITHOUT NASM! u can add nasm to path, and maybe smgcompiler will like you
well more info is in the help.md
bye :D

also, the logo was made in Paint (win 11 25H2)
so dont be confused if it looks bad
