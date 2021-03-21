.586
.model flat, stdcall
option casemap: none

ExitProcess proto stdcall :dword
MessageBoxA proto stdcall :dword, :dword, :dword, :dword
wsprintfA proto c :vararg

includelib C:\masm32\lib\user32.lib
includelib C:\masm32\lib\kernel32.lib

data segment

header db '���������� ����������', 0
format db '%d/%d * (%d+%d) - %d + %d = %d', 13, 10 ; \r\n - ����� ������ � CRLF
	db '((%d - %d) / (%d + %d)) * ((%d + %d) / ( %d - %d )) * %d/%d = %d', 0
buffer db 128 dup(0)

mas1 dd 21, 7, 2, 3, 5, 569 ; �������� 4 �����
mas2 dd 3415, 3205, 15, 6, 1410, 390, 100, 10, 1, 2

temp dd ?

data ends
text segment
start:
; ��������� 1
mov esi, 0

; 21/7
mov eax, mas1[esi] ; ������ AX �.�. 32-������ �����. rax - ��� 64-������
add esi, 4

cdq
div mas1[esi]

; 2 + 3
mov ebx, mas1[esi]
add esi, 4
add ebx, mas1[esi]
add esi, 4

; 21/7 * (2 + 3)
mul ebx
xor ebx, ebx

; 21/7 * (2 + 3) - 5
sub eax, mas1[esi]
add esi, 4

; 21/7 * (2 + 3) - 5 + 569
add eax, mas1[esi]
mov [temp], eax ; ���������

; ��������� 2
xor eax, eax
mov esi, 0

; 2950 - 950
mov eax, mas2[esi]
add esi, 4
sub eax, mas2[esi]
add esi, 4

; 15 + 6
mov ebx, mas2[esi]
add esi, 4
add ebx, mas2[esi]
add esi, 4
; cdq ??

; (2950 - 950) / (15 + 6)
div ebx
xchg eax, ebx ; ������������� ��������� � ebx

; 1410 + 390
mov eax, mas2[esi]
add esi, 4
add eax, mas2[esi]
add esi, 4

; 100 - 10
mov edx, mas2[esi]
add esi, 4
sub edx, mas2[esi]
add esi, 4

; (1410 + 390) / (100 - 10)
;cdq
div edx ; ��������� ������

; (2950 - 950) / (15 + 6) * (1410 + 390) / (100 - 10)
;mul ebx
;xchg eax, ebx ; ������������� ��������� � ebx

; 1/2
;mov eax, mas2[esi]
;add esi, 4
;cdq
;div mas2[esi]

; (2950 - 950) / (15 + 6) * (1410 + 390) / (100 - 10) * 1/2
;mul ebx
;xchg eax, ebx ; ��������� ������� ��������� � ebx

mov eax, [temp] ; ���������� ��������


invoke wsprintfA, addr buffer, addr format, mas1[0], mas1[4], mas1[8], mas1[12], mas1[16], mas1[20], eax,
	mas2[0], mas2[4], mas2[8], mas2[12], mas2[16], mas2[20], mas2[24], mas2[28], mas2[32], mas2[36], ebx
invoke MessageBoxA, 0, addr buffer, addr header, 0	
invoke ExitProcess, 0

ret
text ends
end start

;ml /c /coff 2.asm
;link /subsystem:windows 2.obj
;21/7 * (2+3) - 5 + 569
;���������� ������� ��������������� ��������� � ANSI (Cyryllic 1251)