; Various hacks for asmirc

%ifndef hacks_asm
%define hacks_asm

_busyloop:
  ;mov [hack], dword %1
  print strBusyLoop
  @loop:
    print strEmpty
    dec dword [hack]
    jnz @loop
  println strDone
  ret

%macro busyloop 1
  mov [hack], dword %1
  call _busyloop
%endmacro

%endif ; hacks_asm
