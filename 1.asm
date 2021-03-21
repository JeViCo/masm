.586 ; модель процессора
.model flat, stdcall ; flat - плоская модель памяти, stdcall - соглашение для вызова ф-ций WinAPI

; Включаем библиотеки для работы функций
includelib C:\masm32\lib\kernel32.lib
includelib C:\masm32\lib\user32.lib

; Включаем сами функции (прототипы для проверки количества и типа передаваемых параметров)
ExitProcess PROTO STDCALL :DWORD
MessageBoxA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD

data segment

headm db "My awesome header", 0
textm db "Test text", 0

data ends
text segment
start:

; Передаем параметры через стек (передаются в обратном порядке)
push 0 ; Тип иконки
push offset headm ; Заголовок
push offset textm ; Текст
push 0 ; Родительское окно

call MessageBoxA ; Открываем окно

push 0 ; Передаем код выхода
call ExitProcess ; Завершаем процесс

ret
text ends
end start

;ml /c /coff last.asm
;link /subsystem:windows last.obj