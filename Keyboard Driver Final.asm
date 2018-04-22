bits 16
org 0x7C00

	cli
        mov ah,0x02
        mov al,20
        mov dl,0x80
        mov ch,0
        mov dh,0
        mov cl,2
        mov bx,Start
        int 0x13
        jmp Start
             
times (510 - ($ - $$)) db 0
db 0x55, 0xAA
        Start:
        cli
        xor ebp,ebp
        xor ax,ax
	mov ss,ax
        mov sp,0xffff
        xor ecx, ecx
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
       mov bh, 0							
       mov bl, 0xF5											
       mov cx, 22					
       mov al, 1					
       mov ah, 0x13		
       mov dh,20             
       mov dl,5   	
       int 0x10
       
       mov bp, tab3_int		
       mov bh, 0							
       mov bl, 0xF6											
       mov cx, 22					
       mov al, 1					
       mov ah, 0x13		
       mov dh,21             
       mov dl,5   	
       int 0x10	
       
       call _hide_cursor
      
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov edi, 0xB8000;
	xor edx,edx
        xor ebp,ebp
        xor ecx,ecx
      
checkk: 
        in al, 0x64
        test al, 1
        jz checkk
        xor eax,eax
        in al, 0x60
        cmp al,0x3B
        je tab1 
        cmp al,0x3c
        je tab2
        cmp al,0x3D
        je tab3
        
        jne checkk
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        check:
        
        mov esi,check
        mov ebx, ScanCode
        in al, 0x64
        test al, 1
        jz check
        in al, 0x60
        
        cmp al,0x3B
        je tab1_check 
        cmp al,0x3c
        je tab2_check
        cmp al,0x3D
        je tab3_check
        
        cmp al, 0x0E
        je BackSpace 
        cmp al, 0x1c
        je new_line
        cmp al,0x3A
        je Caps
        cmp al,0x45
        je Num
        cmp al, 0x2A
        je Shift1
        cmp al, 0x36
        je Shift1 
        cmp al,0x1D
        je Ctrl
              
        cmp al, 0xE0
        je M1  
        
        cmp al,0x37
        je Star
        cmp al,0x4A
        je Minus
        cmp al,0x4E
        je Plus
        cmp al,0x53    ;.
        je Delete
        cmp al,0x52    ;0
        je check
        cmp al,0x4F    ;1
        je End
        cmp al,0x50    ;2
        je Down
        cmp al,0x51    ;3
        je check
        cmp al,0x4B    ;4
        je left
        cmp al,0x4C    ;5
        je check
        cmp al,0x4D    ;6
        je right
        cmp al,0x47    ;7
        je Home
        cmp al,0x48    ;8
        je Up
        cmp al,0x49    ;9
        je check
          
       cmp al, 0x81
        ja check
        
        call CaseOfFindindingHash
        call ShiftingTextToWriteCharacter
        
        EasyPrint:
        xlat
        mov [edi], al
        add edi, 2
        add ecx, 2
        inc dl                 
        mov ah,2
        mov bh,0
        int 10h
        cmp ecx,160
        jl next
        xor ecx,ecx
        inc dh
        xor dl,dl
        
        next:
        jmp check
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                    
        MDel:           
        push edi
        push ecx
        
        add edi, 2
        mov al, 0x20
        mov [edi], al
        MDelL:
        cmp ecx, 160
        je MDelLD
        mov al, [edi+2]
        mov [edi], al
        mov al, 0x20
        mov [edi+2], al
        
        add edi, 2
        add ecx, 2
        jmp MDelL
        MDelLD:
        pop ecx
        pop edi
        jmp DelRet
        MDelRet:
        jmp esi
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        Caps:
        mov ebx,ScanCode2
        mov esi,Caps
        in al,0x64
        test al,1
        jz Caps
        in al,0x60
        
        cmp al,0x3A
	je check
        cmp al,0x81
        ja Caps
        cmp al,0x4B
        je left
        cmp al,0x4D
        je right
        cmp al,0x48
        je Up
        cmp al,0x50
        je Down
        
        cmp al, 0x2A
        je Shift2
        cmp al, 0x36
        je Shift2 
        
        cmp al, 0x1c
        je new_line
        cmp al, 0x0E
        je BackSpace
        
        call CaseOfFindindingHash
        call ShiftingTextToWriteCharacter
        
        xlat 
        mov [edi],al
        add edi,2
        add ecx,2
        inc dl
        mov ah,2
        mov bh,0
        int 10h
        cmp ecx,160
        jl next2
        xor ecx,ecx
        inc dh
        xor dl,dl
        
        next2:
        jmp Caps
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	BackSpace:
        cmp edi,0xB8000
        je return
        
        
        push edi
        push ebp
        push ecx
        push edx
        push esi
        push eax
        
        
        mov edx, 0xB8000
        ASL1:
        cmp edx, 0xB8FA0
        je Aret1
        mov al, 1Fh;70h
        cmp [edx+1], al
        jne ASLN1
        MOV edi, edx
        jmp Aret1
        ASLN1:
        add edx, 2
        jmp ASL1
        
        Aret1:
        xor edx, edx
        mov edx, 0xB8000
        
        
        
        HASHL1:
        cmp edx, 0xB8FA0
        je HASHD1
        mov al, 1Fh;70h
        cmp [edx+1], al
        jne HASHRet1
;        ;;;;;;;;;;;;;;;;
        
        
        mov al, 00h
        mov [edx+1], al
        mov byte[edx+1],11110000b ;00000111b
       
        mov esi, HASHL1       
        jmp MDel
;        
        HASHRet1:
        add edx, 2
        jmp HASHL1
        HASHD1:
        
        pop eax
        pop esi
        pop edx
        pop ecx
        pop ebp
        pop edi
        
        
        cmp ecx, 0
        je BKcase2
        
        push edi
        push ecx
        BKL:
        cmp ecx, 160
        je BKLD
        
        mov al, [edi+2]
        mov [edi], al
        
        add edi, 2
        add ecx, 2
        jmp BKL
        
        BKLD:
        pop ecx
        pop edi
        
        sub edi, 2
        sub ecx, 2
        dec dl
        mov ah,2
        mov bh,0
        int 10h
        jmp return
        
        
        BKcase2:
        
        mov ecx, 160
        dec dh
        mov dl, 79
        push edi
        
        
        pop edi
        
        push ebp
        push edi
        xor ebp, ebp
        BKL1:
        mov al, 0x20
        cmp [edi], al
        je BKLD1
        
        add ebp, 2
        
        add edi, 2
        jmp BKL1
        
        BKLD1:
        pop edi
        
        sub ecx, 2
        dec dl
        sub edi, 2
        BKL3:
        mov al, 0x20
        cmp [edi], al
        jne BKLD3
         
        
        push ebp         
        
        push edi
        
        
        
        BKL2:
        cmp ebp, 0
        je BKLD2
        
        mov al, [edi+2]
        mov [edi], al
        mov al, 0x20
        mov [edi+2], al
       
        
        add edi, 2
        sub ebp, 2
        jmp BKL2
        
        BKLD2:
        
        
        pop edi
        pop ebp
        
        sub edi, 2
        sub ecx, 2
        dec dl
        
        jmp BKL3
        
        BKLD3:
        
        push ebp         
        push edi
        
        
        
        BKL4:
        cmp ebp, 0
        je BKLD4
        
        mov al, [edi+2]
        mov [edi], al
        mov al, 0x20
        mov [edi+2], al
        add edi, 2
        sub ebp, 2
        jmp BKL4
        
        BKLD4:
        
        
        pop edi
        pop ebp
        
        sub edi, 2
        sub ecx, 2
        dec dl
        
         mov ah,2
        mov bh,0
        int 10h
        
        pop ebp
        jmp return
        
     
        return:
        jmp esi
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        Delete:
        cmp ecx,160
        je DelRet
   
        push edi
        push ecx
        
        add edi, 2
        mov al, 0x20
        mov [edi], al
        
        DelL:
        cmp ecx, 160
        je DelLD
        
        mov al, [edi+2]
        mov [edi], al
        mov al, 0x20
        mov [edi+2], al
        add edi, 2
        add ecx, 2
        jmp DelL
        DelLD:
        pop ecx
        pop edi
        mov ah,2
        mov bh,0
        int 10h
        jmp DelRet
        
        DelRet:
        jmp esi
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        Shift1:
        mov esi,Shift1
        in al, 0x64
        test al, 1
        jz Shift1
        in al, 0x60
       
        cmp al,0xAA
        je check
        cmp al,0xB6
        je check
        cmp al, 0x81
        ja Shift1
        cmp al, 0x2A
        je Shift1
        cmp al, 0x36
        je Shift1
        cmp al, 0x0E
        je BackSpace 
        cmp al, 0x1c
        je new_line
        mov ebx, ShiftTable
        
        push eax
        push edi
        push ecx
        push ebp
        push esi
        
        xor ebp, ebp
        SH1L1:
        mov al, 0x20
        cmp [edi], al
        je SH1LD1
        add ebp, 2
        add edi, 2
        jmp SH1L1
        
        SH1LD1:
        xor esi, esi
        mov esi, edi
        sub esi, 2
        SH1L2:
        cmp ebp, 0
        je SH1LD2
        mov al, [esi]
        mov [edi], al
        sub edi, 2
        sub esi, 2
        sub ebp, 2
        jmp SH1L2
        
        SH1LD2:
        pop esi
        pop ebp
        pop ecx
        pop edi
        pop eax
        
        xlat
        mov [edi], al
        add edi, 2
        add ecx, 2
        inc dl
        mov ah,2
        mov bh,0
        int 10h
        cmp ecx,160
        jl next3
        xor ecx,ecx
        inc dh
        xor dl,dl
        
        next3:
        jmp Shift1
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        Shift2:
        mov esi,Shift2
        in al, 0x64
        test al, 1
        jz Shift2
        in al, 0x60
        
        cmp al,0xAA
        je Caps
        cmp al,0xB6
        je Caps
        cmp al, 0x81
        ja Shift2
        cmp al, 0x2A
        je Shift2
        cmp al, 0x36
        je Shift2
        cmp al, 0x0E
        je BackSpace 
        cmp al, 0x1c
        je new_line
        mov ebx, ShiftTable2
        
        
         
        push eax
        push edi
        push ecx
        push ebp
        push esi
        
        xor ebp, ebp
        SH2L1:
        mov al, 0x20
        cmp [edi], al
        je SH2LD1
        
        add ebp, 2
        
        add edi, 2
        jmp SH2L1
        
        SH2LD1:
        xor esi, esi
        mov esi, edi
        sub esi, 2
        SH2L2:
        cmp ebp, 0
        je SH2LD2
        mov al, [esi]
        mov [edi], al
        sub edi, 2
        sub esi, 2
        sub ebp, 2
        jmp SH2L2
        
        SH2LD2:
        pop esi
        pop ebp
        pop ecx
        pop edi
        pop eax
        
        call CaseOfFindindingHash
        call ShiftingTextToWriteCharacter
        
        xlat
        mov [edi], al
        add edi, 2
        add ecx, 2
        inc dl
        mov ah,2
        mov bh,0
        int 10h
        cmp ecx,160
        jl next4
        xor ecx,ecx
        inc dh
        xor dl,dl
        
        next4:
        jmp Shift2
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        new_line:
        push ecx
        push ecx
        push eax
        push esi
        push ebp
        push edi
        
        mov esi, edi
        sub esi, ecx
        mov ebp, esi
        mov esi, 0xB8000
        add esi, 3680
        mov edi, esi
        add edi, 160
        XOR ECX, ECX
        NL1:
        cmp esi, ebp
        jle NLD1
        NL:
        cmp ecx, 160
        je NLD
        mov al, [esi+ecx]
        mov [edi+ecx], al
        add ecx, 2
        jmp NL
        
        NLD:
        xor ecx, ecx
        sub esi, 160
        sub edi, 160
        jmp NL1
        
        NLD1:
        pop edi
        pop ebp
        pop esi
        pop eax
        pop ecx        
        
        sub edi,ecx
        add edi,160
        push edi
        xor ecx, ecx
        
        NL2:
        cmp ecx, 160
        je NLD2
        mov al, 0x20
        mov [edi], al
        add edi, 2
        add ecx, 2
        jmp NL2
        
        NLD2:
        pop edi
        xor ecx,ecx
        pop ecx
        push edi
        push esi
        xor esi, esi
        mov esi, edi
        sub esi, 160
        add esi, ecx
        
        NL3:
        cmp ecx, 160
        je NLD3
        mov al, [esi]
        mov [edi], al
        mov al, 0x20
        mov [esi], al
        add esi, 2
        add edi, 2
        add ecx, 2
        jmp NL3
        
        NLD3:
        pop esi
        pop edi
        xor ecx,ecx
        inc dh
        xor dl,dl
        mov ah,2
        mov bh,0
        int 10h
        
        jmp esi
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        left:
        
        pushAD
        call _whitebackgound
        popAD
        
        dec edi           
        dec edi              
        
        inc ebp
        cmp dl,0
        je case2
        dec dl
        mov ah,2
        mov bh,0
        int 10h
        sub ecx,2
        jmp esi
        
        case2:
        cmp dh,0
        je L1
        dec dh
        mov dl,79
        mov ah,2
        mov bh,0
        int 10h
        sub edi,2
        sub ecx,2
        
        L1:
        jmp esi
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        right:
        
        pushAD
        call _whitebackgound
        popAD
        
        cmp dl,79
        je case
        inc dl
        mov ah,2
        mov bh,0
        int 10h
        add edi,2
        add ecx,2
        jmp esi
        
        case:
        cmp dh, 24
        je OutOfLoop
        mov dl,0
        inc dh
        mov ah,2
        mov bh,0
        int 10h
        add edi,2
        add ecx,2
        
        OutOfLoop:
        jmp esi
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        Up:
        
        pushAD
        call _whitebackgound
        popAD
        
        cmp dh,0
        je c1
        dec dh
        mov ah,2
        mov bh,0
        int 10h
        sub edi,160
        jmp esi
        
        c1:
        jmp esi
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        Down:
        pushAD
        call _whitebackgound
        popAD
        
        cmp dh,24
        je c2
        inc dh
        mov ah,2
        mov bh,0
        int 10h
        add edi,160
        jmp esi
      
        c2:
        jmp esi
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        leftS:
        cmp ebp,0
        jne K
        mov [index],edi
        K:       
        inc ebp
        mov [HashCount], ebp
        inc edi
        mov al,1Fh; 70h          ;;
        mov [edi], al        ;;
        dec edi
        dec edi           ;;
        mov al, 1Fh;70h          ;;
        mov [edi], al        ;;
        dec edi
             
        cmp dl,0
        je case3
        dec dl
        sub ecx, 2
        mov ah,2
        mov bh,0
        int 10h
        jmp esi
        case3:
        cmp dh,0
        je L2
        dec dh
        mov dl,79
        mov ah,2
        mov bh,0
        int 10h
        L2:
        jmp esi
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        rightS:
        cmp ebp,0
        jne Ted
        mov [index],edi
        
        Ted:
        inc ebp
        mov [HashCount], ebp
        mov al, 1Fh;70h          ;;
        cmp [edi+1], al        ;;
        jne T2
        mov al, 00h
        mov [edi+1], al
        mov byte [edi+1],11110000b;00000111b
        add edi,2
        jmp T3
        
        T2:
        mov [edi+1], al
        add edi,2
        
        T3:
        cmp dl,79
        je case4
        inc dl
        add ecx, 2
        mov ah,2
        mov bh,0
        int 10h
        jmp esi
        case4:
        cmp dh, 24
        je OutOfLoop2
        mov dl,0
        inc dh
        mov ah,2
        mov bh,0
        int 10h
        OutOfLoop2:
        jmp esi
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        UpS:
        cmp dh,0
        je UOut
        push ecx
        xor ecx, ecx
        
        ULoo:
        cmp ecx, 80
        je UD
        inc ebp
        inc edi
        mov al,1Fh; 70h          ;;
        mov [edi], al        ;;
        dec edi
        dec edi           ;;
        mov al,1Fh; 70h          ;;
        mov [edi], al        ;;
        sub edi, 1
        inc ecx
        jmp ULoo
        
        UD:
        pop ecx
        dec dh
        mov ah,2
        mov bh,0
        int 10h
        jmp esi
        
        UOut:
        jmp esi
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        DownS:
        cmp dh,79
        je DOut
        push ecx
        xor ecx, ecx
        DLoo:
        cmp ecx, 80
        je DDD
        DEC ebp
        
        DEC edi
        mov al,1Fh; 70h          ;;
        mov [edi], al        ;;
        INC edi
        
        INC edi           ;;
        mov al, 1Fh;70h          ;;
        mov [edi], al        ;;
        add edi, 1
        
        inc ecx
        jmp DLoo
        DDD:
        pop ecx
        INC dh
        mov ah,2
        mov bh,0
        int 10h
        jmp esi
        
        DOut:
        jmp esi
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        Ctrl:
        in al,0x64
        test al,1
        jz Ctrl
        in al,0x60
        cmp al,0x9D
        je EndCtrl
        cmp al,0x1D
        je Ctrl
        
        cmp al,0x2F
        je Paste
        cmp al,0x2E
        je Copy
        cmp al,0x2D
        je Cut
        
        jmp Ctrl
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
         Copy:       
         pushAD
         call ClearSavingFunction
         popAD
         
         push edx
         push ecx
         xor eax, eax
         xor edx, edx
         xor ecx,ecx
         mov edx, 0xB8000
         Coo:
         cmp edx, 0xB8FA0
         jge EndCoo
         mov al,1Fh; 70h
         cmp [edx+1], al
         jne Coo1
         mov al, [edx]
         mov [sav+ecx] , al
         inc ecx 
         
         Coo1:
         add edx, 2
         jmp Coo
         EndCoo:
         pop ecx
         pop edx
         jmp Ctrl
         ;;;;;;;;;;;;;;;;;;;;;;;;;
        EndCtrl:
        in al,0x64
        test al,1
        jz EndCtrl
        push ecx 
        push edx
        xor edx,edx
        xor ecx,ecx
        mov edx,0xB8000
        lwq:
        cmp edx,0xB8FA0
        jge lwq2
        mov al,[edx+1]
        cmp al,1Fh;70h
        jne lwq1 
        mov al,11110000b;00000111b
        mov [edx+1],al
        lwq1:        
        add edx,2
        jmp lwq
        lwq2:
        pop edx
        pop ecx
        jmp check 
        ;;;;;;;;;;;;;;;;;;;;;;;;;;  
        Paste:
        mov ebp, [HashCount]
        push esi 
        xor esi,esi
        
        For2:
        cmp esi,ebp
        jge endP
        
        mov bl,[sav+esi]
        mov [edi],bl
        inc esi
        cmp dl,79
        je new
        inc dl
        mov ah,2
        mov bh,0
        int 10h
        jmp Q
        new:
        mov dl,0
        inc dh
        mov ah,2
        mov bh,0
        int 10h
        Q:
        add edi,2
        add ecx,2
        jmp For2
        endP:
        mov ebp,0
        xor ebp,ebp
        pop esi
        jmp check
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        Cut:
        pushAD
         call ClearSavingFunction
         popAD
        push edx
        xor eax,eax
        mov edx,edi
        mov ebp, [HashCount]
        For3:
        cmp eax,ebp
        jge endCt
        mov bl,[edx]
        mov [sav+eax],bl
        mov byte [edx],0x20
        mov byte [edx+1],11110000b;00000111b
        add edx,2
        inc eax
        jmp For3
        endCt:
        
        pop edx
        mov ah,2
        mov bh,0
        int 10h
        
        jmp check
        
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        M1:
               in al, 0x64
               test al, 1
               jz check
               in al, 0x60
        
               cmp al, 0xAA
               je M2
               cmp al, 0xB6
               je M2
               cmp al,0x4B
               je left
               cmp al,0x4D
               je right
               cmp al,0x48
               je Up
               cmp al,0x50
               je Down
               cmp al,0x1C
               je new_line
               cmp al,0x53
               je Delete
               cmp al,0x47
               je Home
               cmp al,0x35
               je BackSlash
               cmp al,0x4F
               je End
               jmp check
               
          M2:
               in al, 0x64
               test al, 1
               jz check
               in al, 0x60
        
               cmp al, 0xE0
               je M3
               jmp check
          
           M3:
               in al, 0x64
               test al, 1
               jz check
               in al, 0x60
        
               cmp al, 0x4B
               je leftS
               cmp al, 0x4D
               je rightS
               cmp al,0x48
               je UpS
               cmp al,0x50
               je DownS
               jmp check
                       
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        Home:
               sub edi, ecx
               
               xor ecx, ecx
               mov dl,0
               mov ah,2
               mov bh,0
               int 10h
               jmp check
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        End:
               sub edi, ecx
               
               add edi, 160
               mov ecx, 160
               mov dl, 80
               sub edi, 2
               Lo:
               mov al, 0x20
               cmp [edi], al
               jne MyD
               sub edi, 2
               sub ecx, 2
               sub dl, 1
               jmp Lo
               MyD:
               mov ah,2
               mov bh,0
               int 10h
               add edi, 2
               
               jmp check
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        Num:
        mov ebx, ScanCode
        mov esi,Num
        in al,0x64
        test al,1
        jz Num
        in al,0x60
        
        cmp al,0x45
	je check
        cmp al,0x81
        ja Num
        
        cmp al,0xE0
        ja M1
        
        cmp al,0x37
        je Star
        cmp al,0x4A
        je Minus
        cmp al,0x4E
        je Plus
        cmp al,0x53
        je Dot
        cmp al,0x52
        je Zero
        cmp al,0x4F
        je One
        cmp al,0x50
        je Two
        cmp al,0x51
        je Three
        cmp al,0x4B
        je Four
        cmp al,0x4C
        je Five
        cmp al,0x4D
        je Six
        cmp al,0x47
        je Seven
        cmp al,0x48
        je Eight
        cmp al,0x49
        je Nine
        
        cmp al, 0x2A
        je Shift2
        
        cmp al, 0x36
        je Shift2 
        
        cmp al, 0x1c
        je new_line
        
        cmp al, 0x0E
        je BackSpace
        
        call CaseOfFindindingHash
        call ShiftingTextToWriteCharacter
        
        xlat 
        mov [edi],al
        add edi,2
        add ecx,2
        inc dl
        mov ah,2
        mov bh,0
        int 10h
        cmp ecx,160
        jl nx
        xor ecx,ecx
        inc dh
        xor dl,dl
        
        nx:
        jmp Num
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        BackSlash:
        mov al, 0x2F
        call CaseOfFindindingHash
        call ShiftingTextToWriteCharacter
        
        mov [edi], al
        add edi, 2
        add ecx, 2
        
        inc dl
        mov ah,2
        mov bh,0
        int 10h
        cmp ecx,160
        jl n1
        xor ecx,ecx
        inc dh
        xor dl,dl
        
        n1:
        jmp Num
         ;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        Star:
        mov al, '*'
        call CaseOfFindindingHash
        call ShiftingTextToWriteCharacter
        
        mov [edi], al
        add edi, 2
        add ecx, 2
        inc dl
         
        mov ah,2
        mov bh,0
        int 10h
        
        cmp ecx,160
        jl n2
        xor ecx,ecx
        inc dh
        xor dl,dl
        
        n2:
        jmp Num   
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        Plus:
        mov al, '+'
        call CaseOfFindindingHash
        call ShiftingTextToWriteCharacter
        
        mov [edi], al
        add edi, 2
        add ecx, 2
        
        inc dl
         
        
        mov ah,2
        mov bh,0
        int 10h
        
        cmp ecx,160
        jl n3
        xor ecx,ecx
        inc dh
        xor dl,dl
        
        n3:
        jmp Num
        ;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        Minus:
        mov al, '-'
        call CaseOfFindindingHash
        call ShiftingTextToWriteCharacter
        
        mov [edi], al
        add edi, 2
        add ecx, 2
        
        inc dl
         
        
        mov ah,2
        mov bh,0
        int 10h
        
        cmp ecx,160
        jl n4
        xor ecx,ecx
        inc dh
        xor dl,dl
        
        n4:
        jmp Num
        ;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        Zero:
        mov al, '0'
        call CaseOfFindindingHash
        call ShiftingTextToWriteCharacter
        
        mov [edi], al
        add edi, 2
        add ecx, 2
        
        inc dl
         
        
        mov ah,2
        mov bh,0
        int 10h
        
        cmp ecx,160
        jl n5
        xor ecx,ecx
        inc dh
        xor dl,dl
        
        n5:
        jmp Num
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;
        One:
        mov al, '1'
        call CaseOfFindindingHash
        call ShiftingTextToWriteCharacter
        
        mov [edi], al
        add edi, 2
        add ecx, 2
        
        inc dl
         
        
        mov ah,2
        mov bh,0
        int 10h
        
        cmp ecx,160
        jl n6
        xor ecx,ecx
        inc dh
        xor dl,dl
        
        n6:
        jmp Num
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
        Two:
        mov al, '2'
        call CaseOfFindindingHash
        call ShiftingTextToWriteCharacter
        
        mov [edi], al
        add edi, 2
        add ecx, 2
        
        inc dl
         
        
        mov ah,2
        mov bh,0
        int 10h
        
        cmp ecx,160
        jl n7
        xor ecx,ecx
        inc dh
        xor dl,dl
        
        n7:
        jmp Num
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
        Three:
        mov al, '3'
        call CaseOfFindindingHash
        call ShiftingTextToWriteCharacter
        
        mov [edi], al
        add edi, 2
        add ecx, 2
        
        inc dl
         
        
        mov ah,2
        mov bh,0
        int 10h
        
        cmp ecx,160
        jl n8
        xor ecx,ecx
        inc dh
        xor dl,dl
        
        n8:
        jmp Num
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
        Four:
        mov al, '4'
        call CaseOfFindindingHash
        call ShiftingTextToWriteCharacter
        
        mov [edi], al
        add edi, 2
        add ecx, 2
        
        inc dl
         
        
        mov ah,2
        mov bh,0
        int 10h
        
        cmp ecx,160
        jl n9
        xor ecx,ecx
        inc dh
        xor dl,dl
        
        n9:
        jmp Num
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
        Five:
        mov al, '5'
        call CaseOfFindindingHash
        call ShiftingTextToWriteCharacter
        
        mov [edi], al
        add edi, 2
        add ecx, 2
        
        inc dl
         
        
        mov ah,2
        mov bh,0
        int 10h
        
        cmp ecx,160
        jl n10
        xor ecx,ecx
        inc dh
        xor dl,dl
        
        n10:
        jmp Num
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
        Six:
        mov al, '6'
        call CaseOfFindindingHash
        call ShiftingTextToWriteCharacter
        
        mov [edi], al
        add edi, 2
        add ecx, 2
        
        inc dl
         
        
        mov ah,2
        mov bh,0
        int 10h
        
        cmp ecx,160
        jl n11
        xor ecx,ecx
        inc dh
        xor dl,dl
        
        n11:
        jmp Num
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
        Seven:
        mov al, '7'
        call CaseOfFindindingHash
        call ShiftingTextToWriteCharacter
        
        mov [edi], al
        add edi, 2
        add ecx, 2
        
        inc dl
         
        
        mov ah,2
        mov bh,0
        int 10h
        
        cmp ecx,160
        jl n12
        xor ecx,ecx
        inc dh
        xor dl,dl
        
        n12:
        jmp Num
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
        Eight:
        mov al, '8'
        call CaseOfFindindingHash
        call ShiftingTextToWriteCharacter
        
        mov [edi], al
        add edi, 2
        add ecx, 2
        
        inc dl
         
        
        mov ah,2
        mov bh,0
        int 10h
        
        cmp ecx,160
        jl n13
        xor ecx,ecx
        inc dh
        xor dl,dl
        
        n13:
        jmp Num
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
        Nine:
        mov al, '9'
        call CaseOfFindindingHash
        call ShiftingTextToWriteCharacter
        
        mov [edi], al
        add edi, 2
        add ecx, 2
        
        inc dl
         
        
        mov ah,2
        mov bh,0
        int 10h
        
        cmp ecx,160
        jl n14
        xor ecx,ecx
        inc dh
        xor dl,dl
        
        n14:
        jmp Num
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        Dot:
        mov al, '.'
        call CaseOfFindindingHash
        call ShiftingTextToWriteCharacter
        
        mov [edi], al
        add edi, 2
        add ecx, 2
        
        inc dl
         
        
        mov ah,2
        mov bh,0
        int 10h
        
        cmp ecx,160
        jl n15
        xor ecx,ecx
        inc dh
        xor dl,dl
        
        n15:
        jmp Num
        
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
      tab1_check:
      cmp byte [currentTab], 1
      jne tab1
      jmp check

      tab2_check:
      cmp byte [currentTab], 2
      jne tab2
      jmp check
      
      tab3_check:
      cmp byte [currentTab], 3
      jne tab3
      jmp check
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
       tab1: 
       cmp byte [currentTab],0
       je set1   
       cmp byte [currentTab],2     
       jne Dootab_3
    
       mov [tab2edi], edi
       mov [tab2Cursor],dx
       mov [tab2ecx],ecx
       
       pushad
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
       
       jmp continue_tab1
       
       
 Dootab_3:
 
       mov [tab3edi], edi
       mov [tab3Cursor],dx
       mov [tab3ecx],ecx
       pushad
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
       
continue_tab1:  
       
       call _clearscreen
       mov bp, ttab1		    
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
       
       popad
      
        mov edi,dword [tab1edi]
        mov ecx, [tab1ecx]
        mov dx,[tab1Cursor]
        
        mov ah,02
        mov bh,0
        int 10h       
       
       mov byte [currentTab],1
       jmp check
       
       set1:
      pushad  
      mov byte [currentTab],1  
      call _clearscreen 
      call _whitebackgound 
      popad
      
      mov ah,02
      mov bh,0
      int 10h
            
       jmp check

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     
       tab2:
       cmp byte [currentTab],0
       je set2
       cmp byte [currentTab],1     
       jne Dotab_3
      
       mov [tab1edi], edi
       mov [tab1Cursor],dx
       mov [tab1ecx],ecx
       
       pushad
       
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
       
       jmp continue_tab2
       
       
      Dotab_3:      
       
       mov [tab3edi], edi
       mov [tab3Cursor],dx
       mov [tab3ecx],ecx
       
       pushad

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
       
       continue_tab2:       
       
       call _clearscreen
       
       mov bp, ttab2
       call _delay
       
       xor ecx, ecx
       mov edi, 0xB8000
       mov ebp, savtab2
       
       restore_tab2:
       
       mov al,[ebp]
       mov [edi],al
       
       add edi,2
       inc ebp
       inc ecx
       cmp ecx,2000
       jl restore_tab2
    
        popad
        mov edi,dword [tab2edi]
        mov ecx, [tab2ecx]
        mov dx,[tab2Cursor]
        
        mov ah,02
        mov bh,0
        int 10h       
       
       mov byte [currentTab],2
       jmp check
       
       set2:
      pushad  
      mov byte [currentTab],2  
      call _clearscreen 
      call _whitebackgound 
      popad
      
      mov ah,02
      mov bh,0
      int 10h
            
       jmp check

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
       tab3:
 
       cmp byte [currentTab],0
       je set3
       cmp byte [currentTab],2     
       jne Dotab_1
     
       mov [tab2edi], edi
       mov [tab2Cursor],dx
       mov [tab2ecx],ecx
       
       pushad
       
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
       
       jmp continue_tab3
       
       
      Dotab_1:
       
       mov [tab1edi], edi
       mov [tab1Cursor],dx
       mov [tab1ecx],ecx
       
        pushad
    
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
       
       
       continue_tab3:
       
       call _clearscreen
       
       mov bp, ttab3
       call _delay
       
       xor ecx, ecx
       mov edi, 0xB8000
       mov ebp, savtab3
       
       restore_tab3:
       
       mov al,[ebp]
       mov [edi],al
       
       add edi,2
       inc ebp
       inc ecx
       cmp ecx,2000
       jl restore_tab3
    
        popad
        mov edi,dword [tab3edi]
        mov ecx, [tab3ecx]
        mov dx,[tab3Cursor]
        
        mov ah,02
        mov bh,0
        int 10h
 
    mov byte [currentTab],3
    jmp check
    
                    
      set3:
      pushad  
      mov byte [currentTab],3 
      call _clearscreen 
      call _whitebackgound 
      popad
      
      mov ah,02
      mov bh,0
      int 10h
            
       jmp check                
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        CaseOfFindindingHash:
        
        push edi
        push ebp
        push ecx
        push edx
        push esi
        push eax
        
        
        mov edx, 0xB8000
        ASL:
        cmp edx, 0xB8FA0
        je Aret
        mov al, 1Fh;70h
        cmp [edx+1], al
        jne ASLN
        MOV edi, edx
        jmp Aret
        ASLN:
        add edx, 2
        jmp ASL
        
        Aret:
        xor edx, edx
        mov edx, 0xB8000
        
        
        
        HASHL:
        cmp edx, 0xB8FA0
        je HASHD
        mov al, 1Fh;70h
        cmp [edx+1], al
        jne HASHRet
;        ;;;;;;;;;;;;;;;;
        
        
        mov al, 00h
        mov [edx+1], al
        mov byte[edx+1], 11110000b;00000111b
       
        mov esi, HASHL       
        jmp MDel
;        
        HASHRet:
        add edx, 2
        jmp HASHL
        HASHD:
        
        pop eax
        pop esi
        pop edx
        pop ecx
        pop ebp
        pop edi
        
        ret
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ShiftingTextToWriteCharacter:
        push eax
        push edi
        push ecx
        push ebp
        push esi
        
        xor ebp, ebp
        WRL1:
        mov al, 0x20
        cmp [edi], al
        je WRLD1
        
        add ebp, 2
        
        add edi, 2
        jmp WRL1
        
        WRLD1:
        xor esi, esi
        mov esi, edi
        sub esi, 2
        WRL2:
        cmp ebp, 0
        je WRLD2
        
        mov al, [esi]
        mov [edi], al
       
        
        sub edi, 2
        sub esi, 2
        
        sub ebp, 2
        jmp WRL2
        
        WRLD2:
        
        
        pop esi
        pop ebp
        pop ecx
        pop edi
        pop eax
        
        ret
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ClearSavingFunction:
        xor ecx, ecx
        ClearLoop:
        cmp ecx, 1000
        je ClearDone
        mov al, 0
        mov [sav+ecx], al
        inc ecx
        jmp ClearLoop
        ClearDone:
        ret
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        
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
      
      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      _delay:

      call _hide_cursor
     
      ;mov bp, message		; Offset of our message
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
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      
_hide_cursor:
     mov ah,02h
     mov dl, 80
     mov dh, 25
     mov bh,0
     int 10h 
     ret
      
      
      
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

tab1_int: db "PRESS F1 TO GO TO TAB1",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,   
        tab2_int: db "PRESS F2 TO GO TO TAB2",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        tab3_int: db "PRESS F3 TO GO TO TAB3",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,

ttab1: db "TAB1" ,0,0,0
ttab2: db "TAB2" ,0,0,0
ttab3: db "TAB3" ,0,0,0


        tab2edi: dd 0xB8000
        tab3edi: dd 0xB8000
        currentTab: db 0
        ScanCode: db "//1234567890-=//qwertyuiop[]//asdfghjkl;'#'/zxcvbnm,.//// /",0,0
        ShiftTable: db "//!@�$%^&*()_+//QWERTYUIOP{}//ASDFGHJKL:'~|/ZXCVBNM<>?/// /",0
        ShiftTable2: db "//!@�$%^&*()_+//qwertyuiop{}//asdfghjkl:'~|/zxcvbnm<>?/// /",0
        ScanCode2: db "//1234567890-=//QWERTYUIOP[]//ASDFGHJKL;'#'/ZXCVBNM,.//// /",0
        HashCount: dd 0
        sav: times(1000) db 0
        index: dd 0   
        tab1edi: dd 0xB8000
        tab1ecx: dd 0
        tab1Cursor: dw 0
        ;tab2edi: dd 0xB8000
        tab2ecx: dd 0
        tab2Cursor: dw 0   
        tab3ecx: dd 0
        tab3Cursor: dw 0     
        savtab1: times (2000) db 0
        savtab2: times (2000) db 0
        savtab3: times (2000) db 0              
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