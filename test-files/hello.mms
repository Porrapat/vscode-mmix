%       Hello World !

        LOC     Data_Segment
        GREG    @
Message BYTE    "Hello, World",10,0

        LOC     #100

Main    LDA     $255,Message
        TRAP    0,Fputs,StdOut
        SET     $255,0
        TRAP    0,Halt,0

