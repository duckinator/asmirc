; nasm socket library

%ifndef socket_asm
%define socket_asm

%include 'utils.asm'

%define hton(x) ((x & 0xFF000000) >> 24) | ((x & 0x00FF0000) >>  8) | ((x & 0x0000FF00) <<  8) | ((x & 0x000000FF) << 24)
%define htons(x) ((x >> 8) & 0xFF) | ((x & 0xFF) << 8)
%define htonl(x) (((x & 0xff000000) >> 24) | \
                  ((x & 0x00ff0000) >> 8)  | \
                  ((x & 0x0000ff00) << 8)  | \
                  ((x & 0x000000ff) << 24))

%define iptol(a, b, c, d) (d + c * 256 + b * 65536 + a * 16777216)

SECTION .bss
  fd: resb 4 ; File descriptor for the socket (dword, 4 bytes)
  ip4addr:
    ip4addr.sin_family resw  1
    ip4addr.sin_port   resw  1
    ip4addr.sin_addr   resd  1
    ip4addr.sin_zero   resb  1
  ip4addrEnd:
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

;struc sockaddr_in
;    .sin_family resw 1
;    .sin_port   resw 1
;    .sin_addr   resd 1
;    .sin_zero   resb 8
;endstruc

SECTION .TEXT

%macro socketInit 0
  ; Parameters for socket(2)
  mov dword [ebp - 4],  INADDR_ANY
  mov dword [ebp - 8],  SOCK_STREAM
  mov dword [ebp - 12], AF_INET

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
;  mov dword [ebp - 4],  fd       ; load socket fd
;  mov dword [ebp - 8],  [ip4addr] ; load sockaddr
;  mov dword [ebp - 12], ip4addrEnd - ip4addr

  mov eax, SYS_SOCKETCALL    ; socketcall
  mov ebx, SYS_BIND          ; bind
  lea ecx, [ebp - 12]        ; address of parameter array
  int 0x80
%endmacro

%macro socketConnect 0
  ; Parameters for connect(2)
  push edx
  push ecx
  push ebx
  push eax
  
  mov dword [ip4addr.sin_addr], networkNBO
  mov dword [ip4addr.sin_port], port
  mov byte  [ip4addr.sin_zero], 0
  
  mov dword [ebp - 4],  fd         ; load socket fd
  mov dword [ebp - 8],  ip4addr    ; load sockaddr
  mov dword [ebp - 12], ip4addrEnd - ip4addr
  
  mov eax, SYS_SOCKETCALL    ; socketcall
  mov ebx, SYS_CONNECT       ; connect
  lea ecx, [ebp - 12]  ; address of parameter array
  int 0x80
  
  pop eax
  pop ebx
  pop ecx
  pop edx
%endmacro


_send:
; %1 == buffer
; ssize_t send(int socket, const void *buffer, size_t length, int flags);
  
  ;call _println
  
  push edx
  push ecx
  push eax

  mov edx, FLAGS ; Flags
  
  call strlen    ; Call strlen, which puts the length in ecx
  
  ;mov ebx, %1    ; The string is the first argument here,
                 ; but second to _fd_send
  mov eax, [fd]  ; Use fd saved in socketInit
  call _fd_write
  
  pop eax
  pop ecx
  pop edx
  ret

_sendln:
  push edx
  push ecx
  push eax
  
  ; Argument for _send is in ebx
  call _send
  
  push ebx
  
  mov ebx, newline
  call _send
  
  pop ebx
  
  pop eax
  pop ecx
  pop edx
  ret

%macro send 1-*
  %rep %0
  mov ebx, %1
  call _print
  mov ebx, %1
  call _send
  %rotate 1
  %endrep
%endmacro

%macro sendln 1-*
  %rep %0
  mov ebx, %1
  call _println
  mov ebx, %1
  call _sendln
  %rotate 1
  %endrep
  send newline
%endmacro

%macro recv 1
; %1 == buffer
; ssize_t recv(int socket, void *buffer, size_t length, int flags);
%endmacro

%endif ; socket_asm
