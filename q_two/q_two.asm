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

    mov ascii_input, AL
    ; Convert ascii character to dec

    mov DL, 0 ; This is a flag used by the below callee
    call @get_equivalent_ascii
    
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

    ; Mov read value to variable
    ; CX [CL] will be used for loop
    mov dec_input, CX

    mov DL, 1 ; Flag used by below callee
    call @get_equivalent_ascii
    
    jmp @exit


; Prints out Error and  halts process
; for decimal values beyond 255
illegal_dec:
    mov AH, 09
    mov DX, offset illegal_dec_p
    int 21h

    jmp @exit


; Prints a tab character
@print_tab proc
    mov DL, 09
    mov AH, 2
    int 21h

    ret

@print_tab endp


; Prints a new line
@print_new_line proc

        mov DL, 0xa
        mov AH, 2
        int 21h

        mov DL, 0xd
        mov AH, 2
        int 21h

        ret
@print_new_line endp


; Finds the ASCII equivalent of DECIMAL
; Loops through all ASCII characters
; O(n) Time complexity where n is 255
@get_equivalent_ascii proc
    
    mov BX, dec_counter ; For comparison, store addr in 16-bit reg
    mov CL, char ; ASCII 255 controls loop

    do_it:
        ; DL = 0 -> ASCII to DEC, DL = 1 -> DEC to ASCII
        cmp DL, 0
        je cmp_character

        ; Check if BX matches input
        ; Yes? Break loop, print matching Char
        ; No? Try next character
        cmp BX, dec_input
        je print_answ

        jmp dec_step ; skip the cmp character part since we are doing
                     ; DEC to ASCII

        cmp_character:
            cmp CL, ascii_input
            je print_answ

        dec_step:
            dec BX

    loop do_it

    print_answ:
       call @print_new_line
       ; Print the character the loop stopped at
        mov AH, 2
        mov DL, CL
        int 21h
        
        mov AH, 09
        mov DX, offset space_eq
        int 21h

        ; Print its DEC equivalent
        mov AX, BX
        call print_num
        
        ret
@get_equivalent_ascii endp

.data
    msg_prompt db 0xa, 0xd, "Choose one option below [e.g 1:] $"
    unknown_prompt db 0xa, 0xd, "That's a strange choice dude/dudelady. GoodBye", 0xa, 0xd, "$"
    choice_prompt dw 0xa, 0xd, "1. ASCII to Decimal", 0xa, 0xd, "2. Decimal to ASCII", 0xa, 0xd, "$"
    choice_in db 0xa, 0xd, "Your choice: ", "$"
    illegal_dec_p db 0xa, 0xd, 0xa, 0xd, "Oopsy! ASCII shouldn't exceed 255D$"
    space_eq db " == $"
    
    choice db ?
    char db 255d
    dec_counter dw 255d

    ; Stores user inputs
    dec_input dw ?
    ascii_input db ?

    a_d_prompt db 0xa, 0xd, "Enter ascii character: $"
    d_to_a_prompt db 0xa, 0xd, "Enter decimal value of character: $"


@exit:
    ret

    DEFINE_SCAN_NUM
    DEFINE_PRINT_NUM
    DEFINE_PRINT_NUM_UNS


    end
