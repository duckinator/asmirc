; Misc macros for asmirc
; Requires utils.asm

%ifndef macros_asm
%define macros_asm

%include 'string.asm'

SECTION .data
newline: db `\n`
__SECT__:

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
