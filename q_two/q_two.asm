org 100h
include "emu8086.inc"

.code
    jmp start

    start:
        ; Print input prompt to stdout
        mov AH, 9
        mov DX, offset msg_prompt
        int 21h

        ; Print choice menu
        mov AH, 9
        mov DX, offset choice_prompt
        int 21h

        ; Print choice_in final prompt
        mov AH, 9
        mov DX, offset choice_in
        int 21h

        ; Read number
        ; Stored in CX
        ; call scan_num

        ; Read user choice
        ; Char stored in AL
        mov AH, 01h
        int 21h
         
        ; This part was testing inc & printing of ascii chars
        ;mov CL,  char
           
        ;do_it:
        ;    mov AH, 2
        ;    mov DL, CL
        ;    int 21h
        ;
        ;    mov AX, dec_counter
        ;    call print_num

        ;    inc dec_counter
        
        ;loop do_it
        

        call @process_choice
        
        jmp @exit


; Determine the selected user mode
@process_choice proc
    cmp AL, '1'
    je ascii_to_dec

    cmp AL, '2'
    je dec_to_ascii

    jmp unknown_entry

    ret
@process_choice endp


unknown_entry:
   mov AH, 09
   mov DX, offset unknown_prompt
   int 21h
   
   jmp @exit
   
ascii_to_dec:
    mov AH, 09
    mov DX, offset a_d_prompt
    int 21h

    ; read character
    ; Stored in AL
    mov AH, 1
    int 21h

    ; Convert ascii character to dec
    
    jmp @exit

    

dec_to_ascii:
    mov AH, 09
    mov DX, offset d_to_a_prompt
    int 21h

    ; Read number
    ; Stored in CX
    call scan_num

    ; Beyond 255? Err
    cmp CX, 255
    jg illegal_dec

    mov dec_counter, CX
    
    jmp @exit


; Prints out Error and  halts process
; for decimal values beyond 255
illegal_dec:
    mov AH, 09
    mov DX, offset illegal_dec_p
    int 21h

    jmp @exit


.data
    msg_prompt db 0xa, 0xd, "Choose one option below [e.g 1:] $"
    unknown_prompt db 0xa, 0xd, "That's a strange choice dude/dudelady. GoodBye", 0xa, 0xd, "$"
    choice_prompt dw 0xa, 0xd, "1. ASCII to Decimal", 0xa, 0xd, "2. Decimal to ASCII", 0xa, 0xd, "$"
    choice_in db 0xa, 0xd, "Your choice: ", "$"
    illegal_dec_p db 0xa, 0xd, 0xa, 0xd, "Oopsy! ASCII shouldn't exceed 255D$"
    
    choice db ?
    char db 255d
    dec_counter dw 255d

    a_d_prompt db 0xa, 0xd, "Enter ascii character: $"
    d_to_a_prompt db 0xa, 0xd, "Enter decimal value of character: $"


@exit:
    ret

    DEFINE_SCAN_NUM
    DEFINE_PRINT_NUM
    DEFINE_PRINT_NUM_UNS


    end
