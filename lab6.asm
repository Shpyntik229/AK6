TITLE Lab6

IDEAL
MODEL SMALL
STACK 512

DATASEG

text db "Group 3, Sachko, Sachko, Horduz$"
oldint dw 0, 0

CODESEG
;---Процедура - обробник переривання--------------------------------------
PROC Interuption
;---Підготовчий блок обробника--------------------------------------------
	cli				;Забороняємо апаратні переривання
	push ax			;Зберігаємо регістри
	push dx
;---Виведення рядка text--------------------------------------------------
	mov ah, 09h
	mov dx, offset text
	int 21h
;---Завершальний блок обробника-------------------------------------------
	pop dx			;Відновлюємо регістри
	pop ax
	sti				;Дозволяємо апаратні переривання
	iret			;Команда повернення з обробника
ENDP
;---Точка входу у програму------------------------------------------------
Start:
;---Ініціалізація датасегмента та додаткового сегмента--------------------
	mov ax, @data
	mov ds, ax
	mov es, ax
;---Зберігаємо старий обробник переривання 53h за допомогою функції 35h---
	push es
	mov ah, 35h
	mov al, 53h
	int 21h ;Адреса обробника переривання №[al] зберігається у es:bx
	mov [oldint], bx
	mov [oldint + 2], es
	pop es
;---Записуємо новий обробник переривання 53h за допомогою функції 25h-----
	push ds
	push cs
	pop ds
	mov ah, 25h
	mov al, 53h
	mov dx, offset Interuption
	int 21h ;Адреса нового обробника переривання №[al] переписується з ds:dx до таблиці векторів переривань
	pop ds
;---Запуск нашого переривання---------------------------------------------
	int 53h
;---Відновлення старого обробника переривання 53h за домогою функції 25h--
	push ds
	mov dx, [oldint]
	mov ds, [oldint + 2]
	mov ah, 25h
	mov al, 53h
	int 21h
	pop ds
;---Завершення програми---------------------------------------------------
	mov ah, 4ch
	mov al, 0
	int 21h
end Start