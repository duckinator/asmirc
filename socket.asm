; Socket macros for asmirc

%macro socketInit 0
  ; Parameters for socket(2)
  mov dword [ebp - 12], 2 ; PF_INET
  mov dword [ebp - 8],  1 ; SOCK_STREAM
  mov dword [ebp - 4],  0

  mov eax, 102    ; socketcall
  mov ebx, 1      ; socket
  lea ecx, [ebp - 12]  ; address of parameter array
  int 0x80
  mov dword [ebp - 16], eax
%endmacro

%macro socketClose 0
  mov dword eax, 6          ; close
  mov dword ebx, [ebp - 16] ; load socket fd
  int 0x80

  add dword esp, 16
  pop dword ebp
%endmacro
