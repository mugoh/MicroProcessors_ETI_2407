; TEXT STARTS HERE

; What does the sketch do? What it's output?

; Short answer: The sketch divides 200 by 5 and prints the result to stdout
;               in binary form

; For detailed explanation, See Comments added in the sketch

; TEXT ENDS HERE

start:
    mov AL, 200 ; Store dividend in 8-bit register AL
                ; 11001000b

    mov CX, 1   ; Assign 1 to CX. The loop counter

    mov BL,5    ; Store divisor in in BL
                ; 00000101b

    div BL      ; Perform division  -> 200 / 5 -> AL / BL
                ; 40D -> 00101000b

    ; Move AL value to BL. Why? Printing to stdout
    ; requires a system call number in AH
    ; before calling an interrupt.
    ; That overwrites AL
    mov BL, AL  

    shl CX,3    ;  1 << 3 = 1000b = 8d = no. of bits in BL

somewhere:
    mov AH, 2       ; Call number to  write char to stdout
    mov DL, 30h     ; DL = '0'

    ; AND BL with 10000000b
    ; If MSB is zero, jmp to elsewhere
    test BL, 10000000b 
    jz elsewhere

    ; Else, MSB = 1
    ; DL = '1'
    mov DL, 31h

elsewhere:
    int 21h     ; Print ascii value in DL
    shl BL, 1   ; BL << 1. Test next MSB

    ; Repeat until CX = 0
    ; i.e 8d times
    loop somewhere

;  Final Stdoutput -> 00101000b [40d]
