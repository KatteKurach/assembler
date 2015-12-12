.model   small
.stack   200h
.data      

    txt1 db "write the text:$" 
    txt2 db "result:$" 
    vowels db "AaEeIiOoUuYy" 
    buff db 100,100 dup ('$')     
    eol db 10, 13, "$"

.code

eol_1 proc
    push dx
    push ax

    mov dx, offset eol
    mov ah, 09h
    int 21h

    pop dx
    pop ax
    ret
eol_1 endp

delete_w proc
    push bx
    push di
    push si   
    push cx
    
    delete_word:
        push si
        xor cx, cx
        mov cl, buff + 1
        sub cl, dl
        mov di, si
        inc si
        rep movsb  
        pop si
        dec buff + 1

        xor cx, cx
        mov cl, [si]
        cmp dl, buff + 1
        jge break
        cmp cl, ' '
        jz break
        mov cx, 32767
    loop delete_word
    break:
    
    pop cx
    pop si
    pop di
    pop bx
    ret
delete_w endp

main:
    mov ax, @data
    mov ds, ax
    mov es, ax

    mov dx, offset txt1
    mov ah, 09h
    int 21h
    
    mov ah, 0ah
    xor di, di
    mov dx, offset buff
    int 21h

    call eol_1

    mov si, offset buff+2

    xor dx, dx
    xor cx, cx
    mov cl, buff + 1
    xor bp, bp

    label_for_1: 
        push cx
        xor ax, ax
        mov cl,[si]
        inc bp
        inc dx

        cmp cl, ' '
        jnz first_letter
        xor bp, bp
        jmp goto2

    first_letter:
        cmp bp, 1
        jnz goto2
        dec dx
        cld
        mov di, offset vowels
        mov al, [si]
        mov cx, 12l
        repne scasb
        jnz goto2
        call delete_w
        xor bp, bp
    goto2:
        pop cx
        inc si
        loop label_for_1

end_f:  
    mov dx, offset txt2
    mov ah, 09h
    int 21h

    mov ah,9
    lea dx,buff+2 ;output 
    int 21h

    mov ax, 4c00h
    int 21h

end     main
