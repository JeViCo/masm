; Вариант 15
.686
.model flat, stdcall
option casemap: none

includelib C:\masm32\lib\kernel32.lib
includelib C:\masm32\lib\user32.lib

ExitProcess PROTO STDCALL :DWORD
MessageBoxA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
wsprintfA PROTO C :VARARG

.data

	winTitle db 'Лабораторная 3', 0
	winFormat db 'Z = %d, Y = %d; Y1 = %d, Y2 = %d', 0
	winBuffer db 128 dup( 0 )
	
	A dd 18
	B dd 282
	X dd 193
	Z dd ?
	Y dd ?

	A1 dd 10
	A2 dd 5
	Y1 dd ?
	Y2 dd ?

.code
program:

; Процедура #1
; A + b
mov eax, A
add eax, B
; Z = (A + B)/10
mov ebx, 10
cdq
idiv ebx
mov [Z], eax
xor eax, eax
xor ebx, ebx

push Z
push offset Y
push Z

call varProc1

; Процедура #2
; A1/A2
mov eax, A1
cdq
idiv A2
; 100 + A1/A2
add eax, 100
; Y1 = (100 + A1/A2) * A1
cdq
imul A1
mov [Y1], eax
xor eax, eax

push offset Y2
push Y1

call varProc2
add esp, 8
push 0

; Вывод окна
invoke wsprintfA, addr winBuffer, addr winFormat, Z, Y, Y1, Y2
invoke MessageBoxA, 0, addr winBuffer, addr winTitle, 0
invoke ExitProcess,0

; Procedure 1
varProc1 proc
	
	mov eax, [esp + 4] ; X
	mov ebx, [esp + 12] ; Z
	
	.IF ebx < 0 && eax > 0 ; Z < 0 и X > 0
		xor eax, eax
		xor ebx, ebx
		mov ebx, 0
		mov eax, [esp + 8]
	
		mov [eax], ebx
	.ELSEIF ebx == 0 && eax == 0 ; Z = 0 и X = 0
		xor eax, eax
		xor ebx, ebx
		mov ebx, 1
		mov eax, [esp + 8]
	
		mov [eax], ebx
	.ELSEIF ebx > 0 && eax < 0 ; Z > 0 и X < 0
		xor eax, eax
		xor ebx, ebx
		mov ebx, 2
		mov eax, [esp + 8]
	
		mov [eax], ebx
	.ELSE
		xor eax, eax
		xor ebx, ebx
		mov ebx, 3
		mov eax, [esp + 8]
	
		mov [eax], ebx
	.ENDIF
	
	xor eax, eax
	xor ebx, ebx
	ret 12
varProc1 endp

; Procedure 2
varProc2 proc
	mov eax, [esp + 4] ; Y1
	mov ebx, [esp + 8] ; Y2
	
	.IF eax == 0 ; Y1 = 0
		xor eax, eax
		mov eax, 147
		mov [ebx], eax
	.ELSEIF eax != 0 ; Y1 <> 0
		xor eax, eax
		mov eax, 174
		mov [ebx], eax
	.ENDIF
	
	xor eax, eax
	xor ebx, ebx
	
	ret
varProc2 endp

end program

;ml /c /coff 3.asm
;link /subsystem:windows 3.obj
;Кракозябры лечатся преобразованием кодировки в ANSI (Windows 1251)