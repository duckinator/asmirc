%include 'macros.asm'
%include 'socket.asm'

section .data
  newline: db `\n`

  strStackSetupStart: string 'Setting up stack...'
  strStackSetupEnd:   string 'Cleaning up stack...'
  strSocketInit:      string 'Initializing socket...'
  strSocketClose:     string 'Closing socket...'
  strExit:            string 'Exiting...'
  strDone:            string 'Done.'

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
  stackSetupStart 16

  ; Initialize socket
  print strSocketInit
  socketInit
  println strDone


  ; close socket
  print strSocketClose
  socketClose
  println strDone

  stackSetupEnd 16

  ; exit(0)
  println strExit
  mov eax, 1
  mov ebx, 0
  int 0x80
