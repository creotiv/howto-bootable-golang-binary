[org 0x7c00]
mov ah, 0x0e
mov bx, hello 

print:
    mov al, [bx]
    cmp al, 0
    je end
    int 0x10
    inc bx
    jmp print
end:

jmp $

hello:     
    db 'Hello world!',0

times 510-($-$$) db 0  
dw 0xaa55       ; this bytes should end boot sector