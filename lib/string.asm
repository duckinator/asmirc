%ifndef string_asm
%define string_asm

%include 'utils.asm'

%macro string 1
  %strlen count %1
  dd count
  db %1
%endmacro

%macro print 1-*
  preserve_start

  %rep %0
  mov ebx, %1  ; The string is the first argument here,
               ; but second to _fd_send
  mov eax, 1   ; Use fd 1 (stdout)
  call _fd_write

  %rotate 1
  %endrep

  preserve_end
%endmacro

%macro println 1-*
  %rep %0
  print %1

  preserve_start
  mov eax, 4
  mov ebx, 1
  mov ecx, newline
  mov dword edx, 1
  int 0x80
  preserve_end
  %rotate 1
  %endrep
%endmacro

%endif
