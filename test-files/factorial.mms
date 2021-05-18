        LOC    Data_Segment
        GREG    @
F10     BYTE    "XXXXXXX",10,0

        LOC    #100

Main    SET    $0,10
        SET    $1,1
        SET    $2,1
        LDA    $255,F10

FLoop   MUL    $1,$1,$0
        SUB    $0,$0,$2
        BP     $0,FLoop

        LDA    $3,F10
        ADD    $3,$3,6

DLoop   DIV    $1,$1,10
        GET    $4,rR
        ADD    $4,$4,48
        STB    $4,$3,0
        SUB    $3,$3,1
        BP     $1,DLoop

        TRAP   0,Fputs,StdOut
        TRAP   0,Halt,0