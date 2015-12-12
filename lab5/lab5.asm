.model small
.stack 200h
.data

rows        dw ?
cols        dw ?
array       dw 10*10 dup (?)    ;rows * cols
array1      dw 10*10 dup (?)
array2      dw 10*10 dup (?)
crlf        db 13,10,'$'
buf         db 10 dup ('$')
txt         db 13,10,'Press any key...$'
row         db 'Input count of rows : $'
colum       db 'Input count of columns : $'
elem        db 13,10,'Input elements: ',13,10,'$'
txt1        db 'The first matrix : $'
txt2        db 'The second matrix : $'
txt3        db 'The result : $'
error1 db "put the correct input$"

 
.code
main:

    mov ax,@data
    mov ds,ax

    mov dx, offset row
    mov ah, 09h
    int 21h

    mov dx, 0
    call input
    mov rows, ax
    test ax, ax
    jns next1
    jmp error

    next1:
    test ax, ax
    jnz next11
    jmp error

    next11:

    mov dx, offset colum
    mov ah, 09h
    int 21h

    mov dx, 0
    call input
    mov cols, ax
    
    test ax, ax
    jns next2
    jmp error

    next2:
    test ax, ax
    jnz next22
    jmp error

    next22:

    mov dx, offset elem
    mov ah, 09h
    int 21h

    push cx
    push ax
    call input_matrix

    mov dx, offset txt1
    mov ah, 09h
    int 21h

    call output_matrix
    mov ax, rows
    mul cols
    mov cx, ax
    mov si, offset array
    mov di, offset array1

    mov dx, offset crlf
    mov ah, 09h
    int 21h 


    push dx
    looooop1:
        mov dx, [si]
        mov [di], dx
        add si, 2
        add di, 2
    loop looooop1
    pop dx  
    pop ax  
    pop cx

    mov dx, offset crlf
    mov ah, 09h
    int 21h 

    call input_matrix

    mov dx, offset txt2
    mov ah, 09h
    int 21h 

    call output_matrix

    mov dx, offset crlf
    mov ah, 09h
    int 21h 


    mov dx, offset crlf
    mov ah, 09h
    int 21h 

    mov ax, rows
    mul cols
    mov cx, ax
    mov si, offset array
    mov di, offset array1

    push dx
    looooop2:
        mov dx, [di]
        cmp dx, [si]
        jng goto1
        mov [si], dx
    goto1:    
        add si, 2
        add di, 2
    loop looooop2
    pop dx 

    mov dx, offset txt3
    mov ah, 09h
    int 21h 

    call output_matrix

    mov dx, offset crlf
    mov ah, 09h
    int 21h 

    mov dx, offset txt
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h

    mov ax,4c00h
    int 21h

input_matrix proc
                           ;ввод матрицы
    lea bx, array
    mov cx, rows
    in1:                       ;цикл по строкам
        push cx
        mov cx, cols
        mov si, 0
    in2:                       ;цикл по колонкам
        call input 
        mov [bx][si], ax
        add si, 2
    loop in2
        add bx, cols
        add bx, cols
        pop cx
    loop in1
    ret
input_matrix endp



output_matrix proc
;вывод массива на экран
    lea bx, array
    mov cx, rows
    out1:                      ;цикл по строкам
        push cx
        mov cx, cols
        mov si, 0
 
        mov dx, offset crlf
        mov ah, 09h
        int 21h  
    
    out2:                       ;цикл по колонкам
        mov ax, [bx][si]        ;Выводимое число в регисте AX
        call output_num   
        add si, 2
        mov ah, 02h
        mov dl, ' '
        int 21h
    loop out2
 
        add bx,cols
        add bx,cols
        pop cx
    loop out1
    ret
output_matrix endp


output_num proc
    push cx
    push dx
    push bx
    push ax

    xor bx, bx
    xor cx, cx

    mov bx, 10
    xor cx, cx

    test ax, ax
    js negative

    outputstr1:
        xor dx,dx
        div bx
        push dx
        inc cx
        test ax, ax
        jnz outputstr1
        mov ah, 02h
    outputstr2:
        pop dx
        add dl, '0'
        int 21h

        loop outputstr2
        jmp end12
    negative:
        push ax
        xor ax, ax
        mov ah, 02h
        mov dl, '-'
        int 21h

        pop ax
        neg ax
        jmp outputstr1

    end12:
        pop ax
        pop bx
        pop dx
        pop cx
    ret
output_num endp
 
input proc
    push cx
    push dx
    push bx
    push si 
    push bp

    mov ah,0ah
    xor di,di
    mov dx,offset buf
    int 21h


    mov dl,0ah
    mov ah,02
    int 21h

    mov si,offset buf+2
    xor dx, dx
    xor ax, ax
    xor bp, bp
    mov bx, 10

    if_1:
        mov cl,[si]
        cmp ax, 0
        jne if_3
    if_2:
        cmp cl, '-'
        jne else_2
        mov bp, 1
        inc si
        jmp if_1

    else_2:
        cmp cl,0dh
        jz end1
        cmp cl,'0'         
        jl error
        cmp cl,'9'  
        ja error
        sub cl,'0'
        mul bx
        jc error
        add ax,cx
        cmp bp, 1
        jnc negative_input
            cmp ax, 32768 
            jnc error
            jmp positive_input
        negative_input:
            cmp ax, 32769
            jnc error
        positive_input:
        inc si
        jmp if_1
    if_3: 
        cmp cl, '-'
        jne else_2
        mov dx, offset error1
        mov ah,09h
        int 21h
        mov ax,4c00h

    end1:
        cmp bp, 1
        jne end2
        neg ax
    end2:
        pop bp
        pop si
        pop bx
        pop dx
        pop cx
        ret
    error:  
        mov dx, offset error1
        mov ah,09h
        int 21h
        mov ax,4c00h    
        int 21h
input endp

end main
