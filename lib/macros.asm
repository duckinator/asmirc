; Misc macros for asmirc
; Requires utils.asm

%ifndef macros_asm
%define macros_asm

%include 'string.asm'

SECTION .data
newline: db `\n`
__SECT__:

%macro preserve_start 0
  push edx
  push ecx
  push ebx
  push eax
%endmacro

%macro preserve_end 0
  pop eax
  pop ebx
  pop ecx
  pop edx
%endmacro

%macro stackSetupStart 1
  print strStackSetupStart

  push dword ebp
  mov  ebp, esp
  sub  esp, %1

  println strDone
%endmacro

%macro stackSetupEnd 1
  print strStackSetupEnd

  add dword esp, %1
  pop dword ebp

  println strDone
%endmacro


%endif ; macros_asm
