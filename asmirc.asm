%include 'utils.asm'
%include 'macros.asm'
%include 'socket.asm'

section .bss
  fd: resb 4 ; File descriptor for the socket (dword, 4 bytes)

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
