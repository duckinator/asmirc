%ifndef time_asm
%define time_asm

SECTION .DATA
  struc timespec
    timespec.tv_sec     resd  1
    timespec.tv_nsec    resd  1
  endstruc

  t1 istruc timespec
  t2 istruc timespec
__SECT__:


SYS_NANOSLEEP equ 102

SECTION .TEXT

_nanosleep:
  ; int nanosleep(const struct timespec *rqtp, struct timespec *rmtp);
  push edx
  push ecx
  ;push ebx
  ;push eax
  
  mov dword [t1 + timespec.tv_sec],  eax ; seconds
  mov dword [t1 + timespec.tv_nsec], ebx ; nanoseconds
  
  mov dword [ebp - 4],  fd         ; load socket fd
  mov dword [ebp - 8],  ip4addr    ; load sockaddr
  mov dword [ebp - 12], ip4addrEnd - ip4addr
  
  mov eax, SYS_NANOSLEEP   ; nanosleep()
  mov ebx, t1              ; rqtp (first arg)
  mov ecx, t2              ; rmtp (second arg)
  int 0x80
  
  ;pop eax
  ;pop ebx
  pop ecx
  pop edx
  ret

; nanosleep seconds, nanoseconds
%macro nanosleep 2
  mov eax, %1 ; seconds
  mov ebx, %2 ; nanoseconds
  call _nanosleep
%endmacro

%macro usleep 1
  nanosleep (%1 / 1000000000), (%1 % 1000000000)
%endmacro

%macro sleep 1
  nanosleep (%1 / 1000000000), 0
%endmacro

%endif ; time_asm
