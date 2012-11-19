%include 'macros.asm'
%define _networkNBO ; temporary. we're defining networkNBO later.

%include 'socket.asm'
%include 'time.asm'
%include 'hacks.asm'

;section .bss
;  networkNBO: resd 1

section .data
  strStackSetupStart: string 'Setting up stack...'
  strStackSetupEnd:   string 'Cleaning up stack...'
  strSocketInit:      string 'Initializing socket...'
  strSocketConnect:   string 'Connecting to '
  strSocketClose:     string 'Closing socket...'
  strExit:            string 'Exiting...'
  strDone:            string 'Done.'
  strElipsis:         string '...'
  strAs:              string ' as '

  ircUser: string "USER asmirc * * :IRC bot using asmirc"
  strNick: string "NICK "

  nickname: string 'asmirc'
  network:  string "72.14.179.233" ; Convert this to something able to be placed in socketaddr_in.sin_addr
  strJoin: string "JOIN #bots"

  hack: dd 0
  strBusyLoop: string 'Running busy loop...'
  strEmpty: string ''

section .text
global _start

_start:
  ; Set up stack frame for file descriptor + socket + params for socket call
  stackSetupStart 16


  port equ htons(6667)
  networkNBO equ iptol(72, 14, 179, 233)

  ; Initialize socket
  print strSocketInit
  socketInit
  println strDone


  ; Connect socket
  ; prints "Connecting to [network] as [nickname]..."
  print strSocketConnect, network, strAs, nickname, strElipsis
  
  socketConnect
  println strDone
  
  ;sleep 5
  busyloop 10000000 ; ~3.5s on my desktop
  
  ; Log in
  sendln ircUser
  sendln strNick, nickname

  busyloop 10000000 ; ~3.5s on my desktop

  sendln strJoin
  
  busyloop 10000000 ; ~3.5s on my desktop

  ; close socket
  print strSocketClose
  socketClose
  println strDone

  stackSetupEnd 16

  println strExit
  
  ; exit(0)
  mov eax, 1
  mov ebx, 0
  int 0x80
