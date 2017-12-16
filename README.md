# CPTR 280 : Computer Organization and Assembly Language

Prompt:

Using QTSpim or MARS, write and test a program that disassembles itself. Your program looks at program memory starting at the default address, determines what instruction is present, and prints to the console windowa line-by-line output of the program that currently exists in program memory (which happens to be the program that is currently running).

#### notes
 
Rather calculating correct addresses for instructions like bne or j, it prints the immediate number represented in the instruction. Namely it does not print PC-relative or Pseudo-direct addresses correctly.
It should be noted that the solution to this issue should be fairly simple. It would involve only shifts, basic arithmetic, and the ability to get the current instruction's address. The address of the current instruction being analyzed could be used, possibly with some constant offset, in place of the PC's value.

this is information about addresssing for future reference (in case I come back to finish this project): https://web.archive.org/web/20170508195755/https://www.cs.umd.edu/class/sum2003/cmsc311/Notes/Mips/addr.html
