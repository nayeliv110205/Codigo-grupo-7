org 100h   
include "emu8086.inc"
define_scan_num
define_clear_screen 
define_print_num 
define_print_num_uns
jmp inicio

    ;Variables que contendran los numeros
    num1 dw 0
    num2 dw 0
    num3 dw 0
    precision = 10 
    diez dw 10
    ;Variables que contendran los textos
    menu db 0Dh,0Ah,0Ah,"1. Suma"          ,0Dh,0Ah
         db             "2. Resta"         ,0Dh,0Ah
         db             "3. Multiplicacion",0Dh,0Ah
         db             "4. Division"      ,0Dh,0Ah
         db             "0. Salir"         ,0Dh,0Ah
         
         db 0Dh,0Ah,"Eliga una operacion: $",0Dh,0Ah     
         
    operacion db 0Dh,0Ah,0Ah,"Escribe un numero: $",0Dh,0Ah  
    
    sumas db 0Dh,0Ah,0Ah,"Suma de tres numeros$",0Dh,0Ah  
    
    restas db 0Dh,0Ah,0Ah,"Resta de tres numeros$",0Dh,0Ah 
    
    multiplicaciones db 0Dh,0Ah,0Ah,"Multiplicacion de tres numeros$",0Dh,0Ah 
    
    divisiones db 0Dh,0Ah,0Ah,"Division de tres numeros$",0Dh,0Ah   
    
    resultado db 0Dh,0Ah,0Ah,"El resultado es: $",0Dh,0Ah
    
    no_valida db 0Dh,0Ah,0Ah, "Escoja una opcion valida$",0Dh,0Ah
    
    infinito db 0Dh,0Ah, "La division para cero no esta definida$",0Dh,0Ah
    
    salida db 0Dh,0Ah,0Ah,"Saliendo del sistema...$",0Dh,0Ah 
    
    imprimir macro string
        mov dx, offset string
        mov ah, 9
        int 21h
    endm
    
    escribir macro
        mov ah,1
        int 21h
    endm
    
    
        mov ax, @data
        mov ds,ax
inicio:
        imprimir menu
        call scan_num
        call clear_screen
        
        cmp cx,1
        je sumaEt
        
        cmp cx,2
        je restEt
        
        cmp cx,3
        je multEt
        
        cmp cx,4
        je diviEt
        
        cmp cx,0 
        je exit   
        
        cmp cx,4
        ja error

sumaEt: call suma
        jmp inicio
        
restEt: call resta
        jmp inicio
        
multEt: call multiplicacion
        jmp inicio

diviEt: call division
        jmp inicio
          
        
    suma proc near 
        imprimir sumas  
        
        imprimir operacion
        call scan_num
        mov num1, cx
        
        imprimir operacion
        call scan_num
        mov num2, cx
        
        imprimir operacion
        call scan_num
        mov num3, cx 
        
        imprimir resultado
        mov ax, num1
        add ax, num2
        add ax, num3
        call print_num
        
        ret
        suma endp
    
    resta proc near 
        imprimir restas 
        
        imprimir operacion
        call scan_num
        mov num1, cx
        
        imprimir operacion
        call scan_num
        mov num2, cx
        
        imprimir operacion
        call scan_num
        mov num3, cx 
        
        imprimir resultado
        mov ax, num1
        sub ax, num2
        sub ax, num3
        call print_num
        
        ret
        resta endp
     
    multiplicacion proc near 
        imprimir multiplicaciones 
        
        imprimir operacion
        call scan_num
        mov num1, cx
        
        imprimir operacion
        call scan_num
        mov num2, cx
        
        imprimir operacion
        call scan_num
        mov num3, cx 
        
        imprimir resultado
        mov ax, num1
        imul num2
        imul num3
        call print_num
        
        ret
        multiplicacion endp
      
    division proc near 
        imprimir divisiones  
        
        imprimir operacion
        call scan_num
        mov num1, cx
        
        imprimir operacion
        call scan_num
        mov num2, cx
        
        imprimir operacion
        call scan_num
        mov num3, cx 
        
        imprimir resultado
        mov dx, 0
        mov ax, num2
        imul num3 
        mov bx, ax
        mov ax, num1
        call signo
        ret
        division endp   
     
    signo proc near   
        cmp bx,0
        je indefinido
        call a_positivo
        call a_negativo
        call print_division
        ret
        signo endp
    
    a_positivo proc near
        test ax,8000h
        jnz  finalizado
        test bx,8000h
        jz b_positivo
        jnz b_negativo
        
        menos:
        push dx
        mov dl,"-"
        call escribir1 
        pop dx
         
        b_positivo: 
        mov dx,0 
        div bx
        jmp finalizado
        
        b_negativo:
        mov dx,0 
        neg bx
        jmp menos 
        
        finalizado:
        ret
        
        a_positivo endp
    
    a_negativo proc near
        test ax,8000h
        jz  finalizado1
        test bx,8000h
        jz b_positivo1
        jnz b_negativo1
        
        menos1:
        push dx
        mov dl,"-"
        call escribir1 
        pop dx
        
        negar:
        neg ax
         
        b_positivo1: 
        mov dx,0
        test ax,8000h
        jnz menos1 
        div bx
        jmp finalizado1
        
        b_negativo1:
        mov dx,0 
        neg bx
        jmp negar
         
        finalizado1:
        ret
        
        a_negativo endp 
    
    print_division proc near
        push cx
        push dx
        
        revisado:
        call print_num
        cmp dx,0
        je terminado
        push dx
        mov dl, "."
        call escribir1
        pop dx
        mov cx, precision
        call print_decimal
        
        terminado:
        pop dx
        pop cx
        
        ret
        print_division endp
    
    print_decimal proc near
        push ax
        push dx
        
        siguiente_decimal:
        cmp cx,0
        jz acabado
        dec cx
        cmp dx,0
        je acabado
        mov ax,dx
        mul diez
        div bx
        call print_num_uns
        jmp siguiente_decimal
        
        acabado:
        pop dx
        pop ax
        ret
        
        print_decimal endp
        
        
    escribir1 proc near
        push    ax
        mov     ah, 02h
        int     21h
        pop     ax
        ret
        escribir1 endp 
    
    indefinido:
    imprimir infinito
    jmp inicio
        
    error:
    imprimir no_valida
    jmp inicio     
    
    exit: 
    imprimir salida    
    mov ah, 0
    int 16h
    
    ret

end