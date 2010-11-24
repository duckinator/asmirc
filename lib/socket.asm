; nasm socket library

%ifndef socket_asm
%define socket_asm

%include 'utils.asm'

SECTION .bss
  fd: resb 4 ; File descriptor for the socket (dword, 4 bytes)
__SECT__:


SYS_SOCKETCALL equ 102

; commands for sys_socketcall
; /usr/include/linux/in.h
SYS_SOCKET	   equ 1
SYS_BIND	     equ 2
SYS_CONNECT	   equ 3
SYS_LISTEN	   equ 4
SYS_ACCEPT	   equ 5
SYS_SEND	     equ 9
SYS_RECV	     equ 10

PF_INET        equ 1
AF_INET        equ 2
SOCK_STREAM    equ 1
INADDR_ANY     equ 0 ; /usr/include/linux/in.h

STDIN          equ 0
STDOUT         equ 1

MSG_WAITALL equ 256
FLAGS       equ MSG_WAITALL & 0x1

struc sockaddr_in
    .sin_family resw 1
    .sin_port   resw 1
    .sin_addr   resd 1
    .sin_zero   resb 8
endstruc

%macro socketInit 0
  ; Parameters for socket(2)
  mov dword [ebp - 12], AF_INET
  mov dword [ebp - 8],  SOCK_STREAM
  mov dword [ebp - 4],  INADDR_ANY

  mov eax, SYS_SOCKETCALL
  mov ebx, SYS_SOCKET
  lea ecx, [ebp - 12]  ; address of parameter array
  int 0x80
  mov [fd], eax
%endmacro

%macro socketClose 0
  mov dword eax, 6          ; close
  mov dword ebx, fd         ; load socket fd
  int 0x80
%endmacro


%macro socketBind 0
  ; Parameters for bind(2)
;  mov dword [ebp - 12], 2 ; PF_INET
;  mov dword [ebp - 8],  1 ; SOCK_STREAM
;  mov dword [ebp - 4],  0

  mov eax, 102    ; socketcall
  mov ebx, 2      ; bind
  lea ecx, [ebp - 12]  ; address of parameter array
  int 0x80
%endmacro

%macro socketConnect 0
  ; Parameters for connect(2)
;  mov dword [ebp - 12], 2 ; PF_INET
;  mov dword [ebp - 8],  1 ; SOCK_STREAM
;  mov dword [ebp - 4],  0

;  mov dword [ebp - 12], sockaddr_in

  mov eax, 102    ; socketcall
  mov ebx, 3      ; connect
  lea ecx, [ebp - 12]  ; address of parameter array
  int 0x80
%endmacro


%macro send 1
; %1 == buffer
; ssize_t send(int socket, const void *buffer, size_t length, int flags);
  mov ebx, %1    ; The string is the first argument here,
                 ; but second to _fd_send
  mov eax, [fd]  ; Use fd saved in socketInit
  call _fd_write
%endmacro

%macro recv 1
; %1 == buffer
; ssize_t recv(int socket, void *buffer, size_t length, int flags);
%endmacro

%endif ; socket_asm
