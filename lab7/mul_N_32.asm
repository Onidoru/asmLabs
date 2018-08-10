.586
.model flat, c

.data?
	arrA DWORD ?
	arrB DWORD ?
	arrBuf DWORD ?
	countIn DWORD ?
	countOut DWORD ?

.code

mul_N_32 PROC
	push ebp
	mov ebp,esp

	mov ecx, [ebp + 8]		; Length of arrA
	mov ebx, [ebp + 12]		; OFFSET of arrC
	mov esi, [ebp + 16]		; OFFSET of N
	mov edi, [ebp + 20]		; OFFSET of arrA

	clc
	pushfd
	mov eax, 0

	L1:
		mov eax, [edi]			; Copy current arrA element to eax
		mov edx, [esi]			; Move current arrB element to esp
		mul edx					; Multiply current N element to eax
	
        add edi, TYPE arrA		; Move pointer to the next arrA element

        popfd
        adc eax, [ebx]
    	pushfd

	    mov [ebx], eax			; Move current eax value to current arrC element
        mov [ebx+4], edx
		add ebx, TYPE arrBuf	; Move pointer to the next arrC element

        loop L1

	popfd
	
	pop ebp
	ret 16
mul_N_32 ENDP
end