org 100h
include "emu8086.inc"

.code
    jmp start

    start:
        ; Print input prompt
        mov AH, 09
        mov DX,  offset prompt
        int 21h

        mov CX, 10000 ; Loop counter
        get_input:
            ; Get std input
            mov AH, 07
            int 21h

            ; CTRL^C -> Terminate
            cmp AL, 03
            je terminate

            ; For Carriage returns, print a new line
            cmp AL, 0xd
            jne print_c

            print_new_line_label:
                mov DL, 0xa
                mov AH, 2
                int 21h

                mov DL, 0xd
                mov AH, 2
                int 21h

            print_c:
                ; Print character
                ; Stored in AL
                
                 mov char, AL
                 call @randomize_char

            ; Create infinite loop
            ; If CX = 1, set to to 10000 again
            cmp CX, 1
            jg continue_loop
            mov CX, 10000
            

        continue_loop:
            loop get_input

    jmp @exit

@randomize_char proc
    mov AL, char
    cmp AL, 'A'
    jl not_alphabet
    
    cmp AL, 'Z'
    jg lower_case
    
    mov upper_b, 090
    mov lower_b, 065
    jmp make_cmp
    
    lower_case:
        cmp AL, 'a'
        jl not_alphabet
        
        cmp AL, 'z'
        jg not_alphabet
                
        mov upper_b, 122
        mov lower_b, 097
    
    make_cmp:
    
        mov BL, upper_b
        mov DL, lower_b

        sub BL, DL
        
        sub upper_b, AL
        mov AL, upper_b
        ; div BL
    
        add AL, lower_b ; random (mod) BL + lower_b
        
        
        ; Avoid non chars between 090 and 097
        cmp AL, 090
        jle print_chr
        
        
        check_if_char:
            cmp AL, 097
            jl add_char
            
            jmp print_chr
        
        add_char:
            add AL, 20
        
        
         print_chr:
            mov AH, 02
            mov DL, AL
            int 21h
    
            jmp end_rand
    
    ; Print non-alphabets without change
    not_alphabet:
        mov AH, 02
        mov DL, AL
        int 21h

    end_rand:
        ret
@randomize_char endp

; Terminates program
terminate:
   mov AH, 09
   lea DX, prompt_term
   int 21h

   jmp @exit


.data
    prompt db "Yo! Start typing  [Press Control+C to terminate]", 0xa, 0xd, 0xa, 0xd, "$"
    prompt_term db 0xa, 0xd, 0xa, 0xd, 09, "** Process terminated by user. Bye dude/dudelady **" , 0xa, 0xd, "$"
    char db ?
    upper_b db ?
    lower_b db ?

@exit:
    ret
    end
