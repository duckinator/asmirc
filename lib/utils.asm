; Misc utility functions for asmirc, mostly abstracted away via macros.asm

%ifndef utils_asm
%define utils_asm

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

; Pointer to a string put in ebx, length output in ecx
strlen:
  push ebx
  mov ecx, 0
  dec ebx
  count:
    inc ecx
    inc ebx
    cmp byte[ebx], 0
    jnz count
  dec ecx
  pop ebx
  ret

%endif ; utils_asm
