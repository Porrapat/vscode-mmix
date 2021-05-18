// printnum.mms
// run with MMIX simulator or visual debugger: https://mmix.cs.hm.edu

NUMBER      IS #FFFF
n        IS $4
y        IS $3
t        IS $255

// a register for extracting a digit
digit    IS $5
// a 16-byte buffer for the converted string
buf      OCTA 0

         LOC #100
Main     SET n,NUMBER %let n = 1
         ADD y,n,0 %add 1 to n and store the result in y

// convert y to ascii digits and store in bufmm

         GETA t,buf+16
// divide and set digit to the remainder register rR
1H       DIV y,y,10
         GET digit,rR
// convert digit to ascii character
         INCL digit,'0'
// fill buffer from the end
         SUB t,t,1
         STBU digit,t,0
// loop back to 1H for more digits
         PBNZ y,1B

// print the converted string
// this works because string offset is already in register $255
         TRAP 0,Fputs,StdOut

         TRAP 0,Halt,0