; Tab Character: 09
org 100h
include "emu8086.inc"

.code
    jmp start

    start:
        ; Print input prompt to stdout
        mov AH, 9
        mov DX, offset msg_prompt
        int 21h

        ; Read number
        ; Stored in CX
        call scan_num

        ; Print column header to stdout
        mov AH, 9
        mov DX, offset col_header
        int 21h

        mov number, CX
        
        print_and_mul:
            call @print_new_line


            ; Multiple the number (X * X)
            call muliply_


        inc count ; count ++

        ; If count <= number, multiply and print
        cmp count, CX
        jle print_and_mul

        
     jmp @exit


;Multiplication procedure
muliply_ proc
        mov AX, count
        push AX ; Preserve AX. Calling @print_tab overwrites AX
        call print_num ; Print X
        
        call @print_tab ; Print tab

        pop AX
        MUL count ; X * X

        ; Print X^2 from AX
        call print_num
    ret
muliply_ endp


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

; Prints a tab character
@print_tab proc
    mov DL, 09
    mov AH, 2
    int 21h

    ret

@print_tab endp

.data
    msg_prompt db "Enter max value: $", 0xa, 0xd
    col_header db 0xa, 0xd, 0xa, 0xd, "x      x**2", "$"
    number dw ?
    count dw 1


@exit:
    ret

    DEFINE_SCAN_NUM
    DEFINE_PRINT_NUM
    DEFINE_PRINT_NUM_UNS

    end

; Highest number giving result = 2^16
; Registers (AX) store 16 bit values. However, if this program was using a signed
; representation, the maximum would be (2^16)/2 = 32,767

; For a 32bit answer, the result is placed in DX:AX or effectively in EAX (32 bit)
; This program does compute the answer upto a max of 65,556 therefore
; but since we are only printing from AX, and haven't manually implemented
; printing from DX:AX, the maximum result we get is similar to that of a signed value.

; WHAT CAN BE DONE TO IMPROVE THE LIMIT?
; Print the entire result from EAX for a 2^16 value. Beyond that, we can't go as the addresses
; only access 64KB of addressible memory
