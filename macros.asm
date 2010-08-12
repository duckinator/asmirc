; Misc macros for asmirc

%macro string 1
  %strlen count %1
  dd count
  db %1
%endmacro

%macro preserve_start 0
  push edx
  push ecx
  push ebx
  push eax
%endmacro

%macro preserve_end 0
  pop eax
  pop ebx
  pop ecx
  pop edx
%endmacro

%macro print 1
  preserve_start

  mov eax, %1
  call _print

  preserve_end
%endmacro

%macro println 1
  print %1

  preserve_start
  mov eax, 4
  mov ebx, 1
  mov ecx, newline
  mov dword edx, 1
  int 0x80
  preserve_end
%endmacro
