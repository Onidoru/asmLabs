.586
.model flat, c

include modFac.inc

.data?
	arrBuf DWORD ?
	arrC DWORD ?
	arrC_ptr DWORD ?

	N DWORD ?
	currentN DWORD ?

.code

factorial PROC
	push ebp
	mov ebp, esp
	
	mov edx, OFFSET N
	mov ecx, [edx]
	dec ecx
	mov currentN, ecx

	LC:	
		mov currentN, ecx

		push OFFSET N
		push OFFSET currentN
		push OFFSET arrBuf
		push LENGTHOF N
		call mul_N_32

		; Copy arrBuf to N
		mov eax, OFFSET arrBuf
		mov ebx, OFFSET N
		mov ecx, LENGTHOF N
		Copy:
			mov esi, [eax]
			mov [ebx], esi
			add eax, 4
			add ebx, 4
			loop Copy

		; Clear arrBuf for mul_N_32 
		mov eax, OFFSET arrBuf
		mov ebx, 00000000
		mov ecx, LENGTHOF arrBuf

		SetZero:
			mov [eax], ebx
			add eax, TYPE arrBuf
			loop SetZero

		mov ecx, currentN
		loop LC

		pop ebp
		ret 16
factorial ENDP
end