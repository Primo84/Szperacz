
TITLE S Z P E R A C Z	(szperacz.asm)


.model small

.stack 100h

.386
.Data

T1 db "Podaj dysk lub sciezke do przeszukania : ","$"
T2 db "Dalej.... t-tak : ","$"

bufor label byte

	max_l db 50
	licznik db 0
	Sciezka db 50 dup(0)


DTA db 43 dup(0)

DTAa dd ?

.Code


main proc

mov ax,@data
mov ds,ax

mov ah,09h
mov dx,offset T1
int 21h

mov ah,0Ah
mov dx,offset bufor
int 21h

call ent
mov cx,0
mov cl,licznik
mov bx,offset Sciezka
add bx,cx
mov byte ptr[bx],0

mov ah,2Fh
int 21h
mov si,offset DTAa
mov [si],bx
add si,2
mov [si],es

mov eax,DTAa

mov ah,1Ah
mov dx,offset DTA
int 21h

mov ah,2fh
int 21h


mov dx,offset Sciezka
mov cx,0
or cl,00010000b
mov si,offset DTA
call FindFile

push ds
mov dx,word ptr DTAa
mov ax,word ptr DTAa+2
mov ds,ax
mov ah,1Ah
int 21h

pop ds

mov ah,2fh
int 21h

mov ah,01h
int 21h


mov ax,4c00h
int 21h

main endp

ent proc

mov ah,02h
mov dl,10
int 21h
mov ah,02h
mov dl,13
int 21h
RET

ent endp

FindFile proc
mov bp,0
pushad

push cx
push dx

mov ah,4Eh
int 21h
jc KON
mov bp,1

WYP:

	mov di,si
	add di,1eh

	call ent

	mov cx,13

	PET:

		mov dl,byte ptr[di]
		cmp dl,0
		je SK2
		mov ah,02h
		int 21h

	SK2:
		inc di
		LOOP PET

	

call ent

mov ah,09h
mov dx,offset T2
int 21h
mov ah,01h
int 21h
cmp al,'t'
jne KON

call ent

mov ah,4fh
int 21h
jnc WYP

KON:

call ent
pop cx
pop dx
popad
RET
FindFile endp


end