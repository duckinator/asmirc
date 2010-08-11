%macro string 1
  %strlen count %1
  dd count
  db %1
%endmacro

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

%macro print 1
  preserve_start

  mov eax, %1
  call _print

  preserve_end
%endmacro

%macro println 1
  print %1

  preserve_start
  mov eax, 4
  mov ebx, 1
  mov ecx, newline
  mov dword edx, 1
  int 0x80
  preserve_end
%endmacro


section .data
  newline: db `\n`

  hello: string 'Hello world!'
  strStackSetup: string 'Setting up stack.'
  strSocketParams: string 'Setting socket parameters.'
  strSocketCall: string 'Invoking socketcall.'
  strSocketClose: string 'Closing socket.'

  network: string 'irc.ninthbit.net'
  port: dd 6667

section .text
global _start

_print:
  mov ecx, eax         ; Put the first arg in ecx,
                       ; it needs to be there for the syscall
  mov eax, 4           ; ?
  mov ebx, 1           ; ?
  mov dword edx, [ecx] ; Put length in edx
  add ecx, 4           ; Increment ecx by 4,
                       ; so we get the string instead of the length
  int 80h              ; Syscall
  ret                  ; Return

_start:
  ; Set up stack frame for file descriptor + socket + params for socket call
  println strStackSetup
  push dword ebp
  mov  ebp, esp
  sub  esp, 16

  ; Parameters for socket(2)
  println strSocketParams
  mov dword [ebp - 12], 2 ; PF_INET
  mov dword [ebp - 8],  1 ; SOCK_STREAM
  mov dword [ebp - 4],  0

  ; invoke socketcall
  println strSocketCall
  mov eax, 102    ; socketcall
  mov ebx, 1      ; socket
  lea ecx, [ebp - 12]  ; address of parameter array
  int 0x80
  mov dword [ebp - 16], eax


  ; close socket
  println strSocketClose
  mov dword eax, 6          ; close
  mov dword ebx, [ebp - 16] ; load socket fd
  int 0x80

  add dword esp, 16
  pop dword ebp

  println hello

  ; exit(0)
  mov eax, 1
  mov ebx, 0
  int 0x80
