// prompt.mms
// test blocking read
// assemble with: mmixal prompt.mms
// run with: mmix prompt
    LOC Data_Segment
    GREG @
// message buffer with space for 1-byte answer
msg BYTE "You entered: ",0,#A,0
msglen IS 13
    LOC #100
// print prompt
Main GETA $255,prompt
    TRAP 0,Fputs,StdOut
    // read 1 byte into destination inside msg
    GETA $255,0F
    TRAP 0,Fread,StdIn
    // print message
    LDA $255,msg
    TRAP 0,Fputs,StdOut
    TRAP 0,Halt,0
// parameters for Fread
0H OCTA msg+msglen,1
prompt BYTE "Please enter y or n: ",0