.586
.model flat, stdcall

include module.inc
include longop.inc

include \Irvine\Irvine32.inc
includelib \Irvine\kernel32.lib
includelib \Irvine\user32.lib

.data
n		   dd 9
x		   dd 2.0
a		   dd 1.1, 2.2, 3.3, 4.4, 5.5, 6.6, 7.7, 8.8, 9.9
res		   dd ?

res_str	   db 20 dup(0)
caption	   db "Lab 8", 0

.code
main:
	lea esi, res
	sub esi, 4
	fld dword ptr[esi]
	mov ecx, n
	dec ecx
	cycle:
		fmul x
		sub esi, 4
		fld dword ptr[esi]
		faddp
	loop cycle
	fst res

    ; convert float to str
	push offset res_str
	push res
	call StrFloat32

	invoke MessageBox, 0, addr res_str, addr caption, 0

	invoke ExitProcess, 0
end main