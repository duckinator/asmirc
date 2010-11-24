; Misc utility functions for asmirc, mostly abstracted away via macros.asm

_fd_write:
  mov ecx, ebx         ; Move string to ecx,
                       ; it needs to be there for the syscall
  mov ebx, eax         ; Move fd number to ebx,
                       ; it needs to be there for the syscall
  mov eax, 4           ; syscall #4
  mov dword edx, [ecx] ; Put length in edx
  add ecx, 4           ; Increment ecx by 4,
                       ; so we get the string instead of the length
  int 0x80             ; Syscall
  ret                  ; Return

_print:
  mov ebx, eax ; The string is the first argument here,
               ; but second to _fd_send
  mov eax, 1   ; Use fd 1 (stdout)
  call _fd_write
  ret

