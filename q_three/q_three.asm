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
                mov AH, 02
                mov DL, AL
                int 21h

            ; Create infinite loop
            ; If CX = 1, set to to 10000 again
            cmp CX, 1
            jg continue_loop
            mov CX, 10000
            

        continue_loop:
            loop get_input

    jmp @exit

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

@exit:
    ret
    end
