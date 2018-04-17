bits 16
org 0x7C00

   cli
   mov ah,0x02
   mov al,8
   mov dl,0x80
   mov dh,0
   mov ch,0
   mov cl, 2
   mov bx, START
   int 0x13
   jmp START
   
times (510 - ($ - $$)) db 0
db 0x55, 0xAA
  START:
   

	cli
       xor esi,esi
	xor eax,eax
       ;mov ds,ax
	;mov es,ax
	mov ss,ax
	mov sp,0xffff
       mov edi, 0xB8000;
	mov esi, ScanCodeTable 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Enabling all 16 colors
      mov ax,1003h
      mov bl,0h
      int 10h
          
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
 
      call _whitebackgound

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;WELCOME SCREEN

       mov bp, tab1_int		
       mov bh, 0							
       mov bl, 0xF3											
       mov cx, 22					
       mov al, 1					
       mov ah, 0x13		
       mov dh,19             
       mov dl,5   	
       int 0x10
       
       mov bp, tab2_int		
       mov	bh, 0							
       mov	bl, 0xF5											
       mov cx, 22					
       mov al, 1					
       mov ah, 0x13		
       mov dh,20             
       mov dl,5   	
       int 0x10
       
       mov bp, tab3_int		
       mov	bh, 0							
       mov	bl, 0xF6											
       mov cx, 22					
       mov al, 1					
       mov ah, 0x13		
       mov dh,21             
       mov dl,5   	
       int 0x10	
       
       call _hide_cursor
      
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
       
         xor ecx,ecx
       
       checkk: 
        in al, 0x64
        test al, 1
        jz checkk
        xor eax,eax
        ;call _clearscreen
        in al, 0x60
        ;call _clearscreen
        cmp al,0x3B
        je tab1 
        cmp al,0x3c
        je tab2
        cmp al,0x3D
        je tab3
        
        
        jne checkk
        		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        xor ecx,ecx
      cursor:
        mov ah,02h
        mov dl, ch  
        mov dh, cl
        mov bh,0
        int 10h
        ;mov ah, 00h
        ;int 16h
       check: 
        in al, 0x64
        test al, 1
        jz check
        xor eax,eax
        in al, 0x60
        cmp al,0x3B
        je tab1_check 
        cmp al,0x3c
        je tab2_check 
        cmp al,0x3D
        je tab3_check
        cmp al, 0x48
        je up
        cmp al, 0x50
        je down
        cmp al, 0x4B
        je left     
        cmp al,0x4D
        je right  
        cmp al, 0x0E
        je BackSpace      
        cmp al, 0x81
        ja check
        mov eax,[esi+eax]
        mov [edi], al
        add edi, 2
        ;add esi,2
        add ch, 01h
        jmp cursor
        
        
        tab1_check:
      
      cmp byte [tab1_toggle], 0
      jz tab1
      
      jmp cursor


      tab2_check:
      
      cmp byte [tab2_toggle], 0
      jz tab2
      
      jmp cursor
      
      
      tab3_check:
      
      cmp byte [tab3_toggle], 0
      jz tab3
      
      jmp cursor
      
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
       
        up:
        cmp cl, 0h
        je cursor
        sub cl, 01h
        sub edi,160
        jmp cursor
        down:
        cmp cl, 24d
        je cursor
        add cl, 01h
        add edi,160
        jmp cursor
        left:
        cmp ch, 0h
        je cursor
        sub ch, 01h
        sub edi, 2
        jmp cursor
        right:
        cmp ch, 79d
        je cursor
        add ch, 01h
        add edi, 2
        jmp cursor
        BackSpace:
        cmp ch, 0h
        jne nbegofl
        cmp cl,0h
        je cursor
        sub cl, 01h
        sub edi,160
        jmp cursor
        nbegofl:
        sub edi, 2
        mov al, 0x20
        mov [edi], al
        sub ch, 01h
        jmp cursor
        
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	tab1: ;tab1

mov byte [tab1_toggle],1
mov byte [tab2_toggle],0
mov byte [tab3_toggle],0
       
       cmp byte [currentTab],0
       je set1
       cmp byte [currentTab],2     
       jne Dootab_3

       mov [tab2Cursor], edi
       mov [tab2Cursor+4],cx
       xor ecx, ecx
       mov ebp, savtab2
       mov edi, 0xB8000
       
       savtab2_loop:
       
       mov al, [edi]
       mov [ebp], al
   
       add edi, 2
       inc ebp
       inc ecx
       cmp ecx, 2000
       jl savtab2_loop
       
 
       jmp contab1
       
       
 Dootab_3:
 
       mov [tab3Cursor], edi
       mov [tab3Cursor+4], cx
       xor ecx, ecx
       mov ebp, savtab3
       mov edi, 0xB8000
       
       
       savtab3_loop:
       
       mov al, [edi]
       mov [ebp], al
   
       add edi, 2
       inc ebp
       inc ecx
       cmp ecx, 2000
       jl savtab3_loop      
       
       
contab1:     

       call _clearscreen
       
       mov bp, ttab1		; Offset of our message     
       call _delay
     
    
       xor ecx, ecx
       mov edi, 0xB8000
       mov ebp, savtab1
       
       restore_tab1:
       
       mov al,[ebp]
       mov [edi],al
       
       add edi,2
       inc ebp
       inc ecx
       cmp ecx,2000
       jl restore_tab1
       
    
       mov edi,[tab1Cursor]
       mov cx,[tab1Cursor+4]
       
       mov byte [currentTab],1
       
       jmp cursor
       
  set1:
        
      mov byte [currentTab],1  
      call _clearscreen 
      call _whitebackgound  
            
       jmp cursor
       
       
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	tab2: ;tab2


mov byte [tab1_toggle],0
mov byte [tab2_toggle],1
mov byte [tab3_toggle],0
       
       cmp byte [currentTab],0
       je set2
       cmp byte [currentTab],1     
       jne Dotab_3
       
       mov [tab1Cursor], edi
       mov [tab1Cursor+4],cx
       xor ecx, ecx
       mov ebp, savtab1
       mov edi, 0xB8000
       
       
       savtab1_loop:
       
       mov al, [edi]
       mov [ebp], al
   
       add edi, 2
       inc ebp
       inc ecx
       cmp ecx, 2000
       jl savtab1_loop
       
       
       jmp conttab2
       
       
 Dotab_3:      
       
       mov [tab3Cursor], edi
       mov [tab3Cursor+4], cx
       xor ecx, ecx
       mov ebp, savtab3
       mov edi, 0xB8000
       
       
       savtab3_looop:
       
       mov al, [edi]
       mov [ebp], al
   
       add edi, 2
       inc ebp
       inc ecx
       cmp ecx, 2000
       jl savtab3_looop
       
conttab2:   

       call _clearscreen
       
       mov bp, ttab2
       call _delay       

       xor ecx, ecx
       mov edi, 0xB8000
       mov ebp,savtab2

       restore_tab2:
       
       mov al,[ebp]
       mov [edi],al
       
       add edi,2
       inc ebp
       inc ecx
       cmp ecx,2000
       jl restore_tab2
       
      
       mov edi,[tab2Cursor]
       mov cx,[tab2Cursor+4]
       
       mov byte [currentTab],2
       
       jmp cursor
       
  set2:
        
      mov byte [currentTab],2  
      call _clearscreen
      call _whitebackgound  
            
       jmp cursor
       
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


       tab3:
 
mov byte [tab1_toggle],0             
mov byte [tab2_toggle],0
mov byte [tab3_toggle],1       
       
       cmp byte [currentTab],0
       je set3
       cmp byte [currentTab],2     
       jne Dotab_1
       
       mov [tab2Cursor], edi
       mov [tab2Cursor+4], cx
       xor ecx, ecx
       mov ebp, savtab2
       mov edi, 0xB8000
       
       
       savtab2_looop:
       
       mov al, [edi]
       mov [ebp], al
   
       add edi, 2
       inc ebp
       inc ecx
       cmp ecx, 2000
       jl savtab2_looop
       
       jmp contab3
       
       
 Dotab_1:
       
       mov [tab1Cursor], edi
       mov [tab1Cursor+4], cx
       xor ecx, ecx
       mov ebp, savtab1
       mov edi, 0xB8000
       
       
       savtab1_looop:
       
       mov al, [edi]
       mov [ebp], al
   
       add edi, 2
       inc ebp
       inc ecx
       cmp ecx, 2000
       jl savtab1_looop
       
       
contab3:

       call _clearscreen
  
       
       mov bp, ttab3
       call _delay
      
       
       xor ecx, ecx
       mov edi, 0xB8000
       mov ebp,savtab3
       
       
       restore_tab3:
       
       mov al,[ebp]
       mov [edi],al
       
       add edi,2
       inc ebp
       inc ecx
       cmp ecx,2000
       jl restore_tab3
       
     
       mov edi,[tab3Cursor]
       mov cx, [tab3Cursor+4]
       
       mov byte [currentTab],3
       
       jmp cursor
       
  set3:
        
      mov byte [currentTab],3 
      call _clearscreen  
      call _whitebackgound  
            
       jmp cursor
       
       
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


_clearscreen:
       mov edi, 0xB8000
       xor ecx,ecx
       
       cleartab:
       mov al, 0x20
       mov [edi], al
       
       add edi, 2  
       inc ecx
       cmp ecx, 2000
       jl cleartab
       xor ecx,ecx
       mov edi, 0xB8000
       ret

_delay:

      call _hide_cursor
     
      ;mov bp, tab		; Offset of our message
      mov bh, 0			; Video page 0
      mov bl,0xF1; 00001111b	; Attributes:  Bright white foreground
									; on a black background, no flashing
      mov cx, 5	; String length
      mov al, 00h			; Bit zero is on: Update position
									; Bit one is off: No attributes in string
      mov ah, 0x13		; Function number
      mov dh,12            ; row to put string
      mov dl,38            ; column to put string
      int 0x10

     mov edx,9000
     haltin:
     mov ecx,10000
     delay_loop:
     nop
     nop
     nop
     nop
     loop delay_loop
     dec edx
     cmp edx,0
     jle done

     jmp haltin
    
     done:
     
     call _whitebackgound
     
     ret 
     
_whitebackgound:
      mov edi,0xB8001
      mov ecx,2000
      mov al,0xF0
      screen_background:
      mov  [edi],al
      add edi,2
      loop screen_background
      mov edi, 0xB8000;
      ret
      
_hide_cursor:
     mov ah,02h
     mov dl, 80
     mov dh, 25
     mov bh,0
     int 10h 
     ret
     
         
     
        
tab1_int: db "PRESS F1 TO GO TO TAB1",0   
tab2_int: db "PRESS F2 TO GO TO TAB2",0
tab3_int: db "PRESS F3 TO GO TO TAB3",0    
        
ttab1: db "TAB1" ,0
ttab2: db "TAB2" ,0
ttab3: db "TAB3" ,0
;length: db  (length - message)        


tab1_toggle: db 0d
tab2_toggle: db 0d
tab3_toggle: db 0d

ScanCodeTable: db "//1234567890-=//QWERTYUIOP[]//ASDFGHJKL;//'/ZXCVBNM,.//// /",0

currentTab: db 0

tab1Cursor: dd 0xB8000,0
tab2Cursor: dd 0xB8000,0
tab3Cursor: dd 0xB8000,0

savtab1: times 2000 db 0
savtab2: times 2000 db 0
savtab3: times 2000 db 0

times (0x400000 - 512) db 0

db 	0x63, 0x6F, 0x6E, 0x65, 0x63, 0x74, 0x69, 0x78, 0x00, 0x00, 0x00, 0x02
db	0x00, 0x01, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
db	0x20, 0x72, 0x5D, 0x33, 0x76, 0x62, 0x6F, 0x78, 0x00, 0x05, 0x00, 0x00
db	0x57, 0x69, 0x32, 0x6B, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00, 0x78, 0x04, 0x11
db	0x00, 0x00, 0x00, 0x02, 0xFF, 0xFF, 0xE6, 0xB9, 0x49, 0x44, 0x4E, 0x1C
db	0x50, 0xC9, 0xBD, 0x45, 0x83, 0xC5, 0xCE, 0xC1, 0xB7, 0x2A, 0xE0, 0xF2
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
db	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00