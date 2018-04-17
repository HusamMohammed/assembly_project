bits 16
org 0x7C00

	cli

        mov ah,0x02
        mov al,8
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
        xor ecx, ecx
	mov edi, 0xB8000;
	xor edx,edx
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;mov ax,1003h
;        mov bl,0h
;        int 10h
        
        ;mov ebp,0xB8001
;        mov ecx,2000
;        mov al,0xF0
       ; white:
;        mov [ebp],al
;        add ebp,2
;        loop white
        
        
        check:
        
        
        mov esi,check
        mov ebx, ScanCode
        in al, 0x64
        test al, 1
        jz check
        in al, 0x60
        
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
        je check
        cmp al,0x52    ;0
        je check
        cmp al,0x4F     ;1
        je End
        cmp al,0x50      ;2
        je check
        cmp al,0x51    ;3
        je check
        cmp al,0x4B    ;4
        je left
        cmp al,0x4C     ;5
        je check
        cmp al,0x4D      ;6
        je right
        cmp al,0x47      ;7
        je Home
        cmp al,0x48     ;8
        je check
        cmp al,0x49      ;9
        je check
        
              
       cmp al, 0x81
        ja check
        
        
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
        mov al, 70h
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
        mov al, 70h
        cmp [edx+1], al
        jne HASHRet
;        ;;;;;;;;;;;;;;;;
        
        
        mov al, 00h
        mov [edx+1], al
        mov byte[edx+1], 00000111b
       
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
        

;        
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
        
        xlat
        nnn:
        mov [edi], al
        add edi, 2
        add ecx, 2
        
        inc dl
         
        mmm:
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
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
        mov al, 70h
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
        mov al, 70h
        cmp [edx+1], al
        jne HASHRet1
;        ;;;;;;;;;;;;;;;;
        
        
        mov al, 00h
        mov [edx+1], al
        mov byte[edx+1], 00000111b
       
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
        ;BKL5:
;        mov al, 0x20
;        cmp [edi], al
;        jne BKLD5
;        
;        sub ecx, 2
;        dec dl
;        
;        sub edi, 2
;        jmp BKL5
;        BKLD5:
       ; mov ah,2
;        mov bh,0
;        int 10h
        
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
        
       ; ;sub edi, 2
;;        mov al, 0x20
;;        mov [edi], al
;;        sub ecx,2
;        dec dl
;;        mov ah,2
;;        mov bh,0
;;        int 10h
;;        cmp dl,0
;;        jne return
;;        xor ecx, ecx
;;        mov ecx,160
;;        dec dh 
;;        mov dl,79
;        mov ah,2
;        mov bh,0
;        int 10h
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
        
        
        
        ;push edi
;        push ebp
;        push ecx
;        push edx
;        push esi
;        push eax
;        
;        
;        mov edx, 0xB8000
;        ASL2:
;        cmp edx, 0xB8FA0
;        je Aret2
;        mov al, 70h
;        cmp [edx+1], al
;        jne ASLN2
;        MOV edi, edx
;        jmp Aret2
;        ASLN2:
;        add edx, 2
;        jmp ASL2
;        
;        Aret2:
;        xor edx, edx
;        mov edx, 0xB8000
;        
;        
;        
;        HASHL2:
;        cmp edx, 0xB8FA0
;        je HASHD2
;        mov al, 70h
;        cmp [edx+1], al
;        jne HASHRet2
;;        ;;;;;;;;;;;;;;;;
;        
;        
;        mov al, 00h
;        mov [edx+1], al
;        mov byte[edx+1], 00000111b
;       
;        mov esi, HASHL2       
;        jmp MDel
;;        
;        HASHRet2:
;        add edx, 2
;        jmp HASHL2
;        HASHD2:
;        
;        pop eax
;        pop esi
;        pop edx
;        pop ecx
;        pop ebp
;        pop edi
;        
;        
        
        
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
        
;        SUB ESI, 158
;        SUB ESI, 160
        mov edi, esi
        add edi, 160
        
        XOR ECX, ECX
        
        NL1:
        cmp esi, ebp
        jle NLD1
;        
        NL:
        cmp ecx, 160
        je NLD
;        
        mov al, [esi+ecx]
        mov [edi+ecx], al
        
;        
        add ecx, 2
        jmp NL
;        
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
;        
        mov al, 0x20
        mov [edi], al
        
        add edi, 2
        add ecx, 2
        jmp NL2
;        
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
;        
        mov al, [esi]
        mov [edi], al
        mov al, 0x20
        mov [esi], al
        
        add esi, 2
        add edi, 2
        add ecx, 2
        jmp NL3
;        
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
        
        dec edi           ;;
;        mov al, 70h          ;;
;        mov [edi], al        ;;
        dec edi              ;;
        
        inc ebp
        cmp dl,0
        je case2
        dec dl
        mov ah,2
        mov bh,0
        int 10h
        
        ;sub edi,2
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
        mov dl,0
        inc dh
        mov ah,2
        mov bh,0
        int 10h
        add edi,2
        add ecx,2
        jmp esi
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        Up:
        cmp dh,0
        je c1
        dec dh
        mov ah,2
        mov bh,0
        int 10h
        
        sub edi,160
        ;add ecx,2
        jmp esi
       ; c:
;        mov dl,0
;        inc dh
;        mov ah,2
;        mov bh,0
;        int 10h
;        add edi,2
;        add ecx,2
        c1:
        jmp esi
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        Down:
        cmp dh,24
        je c2
        inc dh
        mov ah,2
        mov bh,0
        int 10h
        
        add edi,160
        ;add ecx,2
        jmp esi
       ; c:
;        mov dl,0
;        inc dh
;        mov ah,2
;        mov bh,0
;        int 10h
;        add edi,2
;        add ecx,2
        c2:
        jmp esi
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        leftS:
        cmp ebp,0
        jne K
        mov [index],edi
        K:       
        inc ebp
        
        inc edi
        mov al, 70h          ;;
        mov [edi], al        ;;
        dec edi
        
        dec edi           ;;
        mov al, 70h          ;;
        mov [edi], al        ;;
        sub edi, 1
        
        cmp dl,0
        je case3
        dec dl
        
        
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
        
        ;dec edi
;        mov al, 70h          ;;
;        mov [edi], al        ;;
;        inc edi
        
        ;inc edi           ;;
        mov al, 70h          ;;
        cmp [edi+1], al        ;;
        jne T2
        mov al, 00h
        mov [edi+1], al
        mov byte [edi+1],00000111b
        add edi,2
        jmp T3
        T2:
        mov [edi+1], al
        add edi,2
        T3:
        cmp dl,79
        je case4
        inc dl
        mov ah,2
        mov bh,0
        int 10h
        jmp esi
        case4:
        mov dl,0
        inc dh
        mov ah,2
        mov bh,0
        int 10h
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
        mov al, 70h          ;;
        mov [edi], al        ;;
        dec edi
        
        dec edi           ;;
        mov al, 70h          ;;
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
        mov al, 70h          ;;
        mov [edi], al        ;;
        INC edi
        
        INC edi           ;;
        mov al, 70h          ;;
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
        
        cmp al,0x1E
        je controlA
        
        cmp al,0x2E
        je Copy
        
        cmp al,0x2D
        je Cut
        
        
        jmp Ctrl
        
        ;;;;;;;;;;;;;;;;;;;;;;;
        controlA:
        push esi
        
        mov esi,0xB8000
        
        newCA:
        cmp esi,0xB8FA0
        je endCA
        
        mov al, 0x20
        cmp [esi], al
        je W
        inc esi
        
        mov al,37h
        mov [esi],al
        dec esi
        W:
        add esi,2
        jmp newCA
        endCA:
        pop esi
        mov dword[pair],1
        
        jmp controlAA
        ;;;;;;;;;;;;;;;;;;;;
           
        
controlAA:
        in al,0x64
        and al,0x1
        jz controlAA
        
        in al,0x60
        
        cmp al,81
        ja controlAA
        
        ;cmp al,0x1D
;        je newcontrol

        cmp al,0x1D
        je newcontrol
        
        cmp al, 0x0E
        je NewBackSpace
        
        xlat
        
        mov [copy] ,al
        
        mov ah, 06h
        mov al, 00h
        mov bh, 07h
        xor ecx, ecx
        mov dh, 24
        mov dl, 79
        int 10h
        
        mov edi, 0xB8000;
        mov ebx,[ScanCode]
        xor ecx,ecx
        xor dl,dl
        xor dh,dh
         mov ah,2
        mov bh,0
        int 10h
        mov al,[copy]
        mov dword[pair],0
        jmp nnn
        
        ;;;;;;;;;;;;;;;;;
              
NewBackSpace:
 mov ah, 06h
        mov al, 00h
        mov bh, 07h
        xor ecx, ecx
        mov dh, 24
        mov dl, 79
        int 10h
        
        mov ah,09h
        mov cx,1000h
        mov al,20h
        mov bl,00h
        int 10h
        
        cli
        xor ebp,ebp
        xor ax,ax
	mov ss,ax
        xor ecx, ecx
	mov edi, 0xB8000;
	xor edx,edx
         
         mov dword[pair],0
jmp check
;jmp Start
        ;;;;;;;;;;;;;;;
        
        newcontrol:
        in al,0x64
        and al,0x1
        jz newcontrol
        
        cmp al,0x9D
        je controlAA
        
        in al,0x60
        
        cmp al,0x81
        ja newcontrol
        
        cmp al,0x1D
        je newcontrol
        
        ;cmp al,0x2F
;        je newPaste
;        
;        cmp al,0x2E
;        je newCopy
;        
;        cmp al,0x2D
;        je newCut
        ;;;;;;;;;;;;;;;;;;;;;;;
        Copy:
        ;push edx
;        xor eax,eax
;        xor edx,edx
;        mov edx,edi
;        ;cmp edi,[index]
;        ;jg Com
;        For:
;        cmp eax,ebp
;        jge endC
;        mov bl,[edx]
;        mov [sav+eax],bl
;        inc eax
;        add edx,2
;        jmp For
        
        ;Com:
;        xor eax,eax
;        ;mov eax, ebp
;        ;mov edx,[index]
;        Lcom:
;        cmp eax,ebp
;        jle endC
;        mov bl,[edx]
;        mov [sav+eax],bl
;        inc eax
;        sub edx,2
;        jmp Lcom
        ;endC:
;        pop edx
;        jmp Ctrl
;       
         push edx
         push ecx
         xor eax, eax
         xor edx, edx
         xor ecx,ecx
         mov edx, 0xB8000
         Coo:
         cmp edx, 0xB8FA0
         jge EndCoo
         mov al, 70h
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
        cmp al,70h
        jne lwq1 
        mov al,00000111b
        mov [edx+1],al
        lwq1:        
        add edx,2
        jmp lwq
        lwq2:
        pop edx
        pop ecx
        jmp check   
        Paste:
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
        
        Cut:
        xor eax,eax
        mov edx,edi
        For3:
        cmp eax,ebp
        jge endCt
        mov bl,[edx]
        mov [sav+eax],bl
        mov byte [edx],0x20
        mov byte [edx+1],00000111b
        add edx,2
        inc eax
        jmp For3
        endCt:
        ;sub edi,ebp
        ;add edi,ebp
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
      ;  
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
        
        jmp Num
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        BackSlash:
        mov al, 0x2F
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
        hlt
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        copy: db 'o',0
        ScanCode: db "//1234567890-=//qwertyuiop[]//asdfghjkl;'#'/zxcvbnm,.//// /",0,0,0,0,0,0,0
        ShiftTable: db "//!@£$%^&*()_+//QWERTYUIOP{}//ASDFGHJKL:'~|/ZXCVBNM<>?/// /",0,0,0,0,0,0,0,0,0
        ShiftTable2: db "//!@£$%^&*()_+//qwertyuiop{}//asdfghjkl:'~|/zxcvbnm<>?/// /",0
        ScanCode2: db "//1234567890-=//QWERTYUIOP[]//ASDFGHJKL;'#'/ZXCVBNM,.//// /",0
        m: db 'o',0
        sav: times(1000) db 0
        max: dd 0
        pair: dd 0
        
        index: dd 0
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