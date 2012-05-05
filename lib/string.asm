%ifndef string_asm
%define string_asm

%include 'utils.asm'

%macro string 1
  %strlen count %1
  dd count
  db %1
%endmacro

_print:
  ;push edx
  ;push ecx
  ;push eax
  
  ; String (second argument to _fd_send) is already in ebx
  
  mov eax, 1   ; Use fd 1 (stdout)
  call _fd_write
  
  ;preserve_end
  
  ;pop eax
  ;pop ecx
  ;pop edx
  ret

_println:
  call _print
  
  ;push edx
  ;push ecx
  ;push ebx
  ;push eax
  
  mov eax, 4
  mov ebx, 1
  mov ecx, newline
  mov dword edx, 1
  int 0x80
  
  ;pop eax
  ;pop ebx
  ;pop ecx
  ;pop edx
  ret


%macro print 1-*
  %rep %0
  mov ebx, %1
  call _print
  %rotate 1
  %endrep
%endmacro

%macro println 1-*
  %rep %0
  mov ebx, %1
  call _println
  %rotate 1
  %endrep
%endmacro


%endif
