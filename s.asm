%define LDI(op1)    db 00000000b, op1
%define LD(addr)    db 00101000b, addr
%define ST(addr)    db 00110000b, addr
%define ADD(op1)    db 10000000b, op1
%define SUB(op1)    db 10001000b, op1
%define OR(op1)     db 10011000b, op1
%define XOR(op1)    db 10100000b, op1
%define NOT         db 10101000b, 0
%define LR          db 10111000b, 0
%define RR          db 11000000b, 0
%define JMP(addr)   db 00001000b, addr
%define JMPZ(addr)  db 00010000b, addr

section .data
restart:
LDI(1)
rotate:
LR
lab:
JMPZ(restart)
JMP(rotate)
