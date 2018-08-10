.586
.model flat, c

.data?
	arrBuf DWORD ?
	arrC DWORD ?
	arrC_ptr DWORD ?

.code

longAdd PROC
	push ebp
	mov ebp,esp

	mov ecx, [ebp + 8]		; Length of arrBuf
	mov ebx, [ebp + 12]		; arrC_ptr
	mov edi, [ebp + 16]		; OFFSET of arrBuf

	clc
	pushfd

	L1:

		mov eax, [edi]			; Add current arrBuf to eax

		popfd
		adc eax, [ebx]			; Add current arrC element to eax
		pushfd

		mov [ebx], eax			; Move current eax value to current arrC element
		add edi, TYPE arrBuf	; Move pointer to the next arrBuf element
		add ebx, TYPE arrC		; Move pointer to the next arrC element

  loop L1

	popfd
	pop ebp
	ret 16

longAdd ENDP
end
