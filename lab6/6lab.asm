.model tiny 
.186
.code

org 80h
cmd_len db ?
cmd_line db ?

org 2Ch
envseg dw ?

org 100h 

lal: 
    jmp main
    sy db 'g'
    old_handler dd ?
    s2 db 50 dup ('$')
    vowels db "aAqQoOiIuUyYeE"
    active dw ?

int21h_handler proc

    pushf
    call cs:old_handler
    push ax
    mov ax, cs:active
    cmp ax, 6969
    jz denka
    pop ax
    iret
denka:
	pop ax
    cmp ah, 0ah
    jz additional
    iret
	additional:
        pusha
        pushf
        
        mov di, offset s2
        mov si, dx

        mov al, [si]
        mov [di], al
        mov al, [si + 1]
        mov [di + 1], al

        xor cx, cx
        mov cl, [si + 1]
        add si, 2
        add di, 2

        gogo:
            mov al, [si]
            mov [di], al
            inc di
            inc si
        loop gogo

        mov di, offset s2
        mov si, dx

        mov cl, [di + 1]
        add di, 2
        add si, 2

        rororo:
            mov al, [di]
            push cx
            push di
            mov cx, 14
            mov di, offset vowels
        loooop:
            cmp al, byte ptr cs:[di]
            jz vowel
            inc di
        loop loooop
            pop di
            pop cx
            mov [si], al
            inc si
            inc di
            loop rororo
            jmp here
            vowel:
            	pop di
            	pop cx
                mov [si], al
                inc si
                mov [si], al
                inc si
                inc di
                push si
                    mov si, dx
                    mov al, [si + 1]
                    inc al
                    mov [si + 1], al
                pop si
        loop rororo
        here:
        mov al, '$'
        mov [si], al

        popf
        popa
	iret
int21h_handler endp

eol db 10, 13, '$'                   
as db 50 dup('$')
string db 60 dup ('$')


main:

jmp codee
    already_have db "Already installed.$"
    sucsess db "Successfully installed.$"
    remov db "Successfully removed.$"
    not_already db "Don't already installed.$"
    erroor db "Error.$"

codee:
    mov ax, 3521h
    int 21h
    mov word ptr old_handler, bx
    mov word ptr old_handler + 2, es
    
    mov dl,cmd_len
    cmp dl, 0
    jnz parara

    mov ax, es:active
    cmp ax, 6969
    jz inst

 	mov ax, 6969
 	mov active, ax

    mov ah, 09h
    mov dx, offset sucsess
    int 21h

    mov ax, 2521h
    mov dx, offset int21h_handler
    int 21h

    mov dx, offset main 
    int 27h 
    ret

inst:
	mov ah, 09h
	mov dx, offset already_have
	int 21h
	ret

parara:
	mov di, offset cmd_line
	mov al, byte ptr [di+1]
	cmp al, '-'
	jnz err1
	mov al, byte ptr [di+2]
	cmp al, 'd'
	jnz err1

	mov ax, es:active
    cmp ax, 6969
    jnz non

    mov ax, 9696
    mov es:active, ax

    mov ah, 09h
	mov dx, offset remov
	int 21h
	ret

non:
	mov ah, 09h
	mov dx, offset not_already
	int 21h
	ret

err1:
	mov ah, 09h
	mov dx, offset erroor
	int 21h
	
	ret

end lal
