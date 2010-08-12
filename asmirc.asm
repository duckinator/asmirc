%include 'macros.asm'
%include 'socket.asm'

; ssize_t send(int socket, const void *buffer, size_t length, int flags);
; ssize_t recv(int socket, void *buffer, size_t length, int flags);
; MSG_WAITALL = 256 ( & 0x1 which is 0)

section .data
  newline: db `\n`

  strStackSetup: string 'Setting up stack.'
  strSocketInit: string 'Initializing socket...'
  strSocketClose: string 'Closing socket...'
  strExit: string 'Exiting...'
  strDone: string 'Done.'

  nickname: string 'asmirc'
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

  ; Initialize socket
  print strSocketInit
  socketInit
  println strDone


  ; close socket
  print strSocketClose
  socketClose
  println strDone

  ; exit(0)
  println strExit
  mov eax, 1
  mov ebx, 0
  int 0x80
