; N * N  
; arrC = arrA * arrB

.586
.model flat, c

include \Irvine\Irvine32.inc
includelib \Irvine\kernel32.lib
includelib \Irvine\user32.lib
include modFac.inc

.data?
 
	arrA DWORD ?
	arrB DWORD ?

	arrC DWORD ?
	arrBuf DWORD ?
  
	arrBuf1 DWORD ?
	arrC_ptr DWORD ?
 
	count DWORD ? 
	limit DWORD ?
	currentB DWORD ?
	buf DWORD ?

.code

mul_N_N PROC	
; N * N  
; arrC = arrA * arrB

	push ebp
	mov ebp, esp


	mov eax, [ebp+8]	
	mov limit, eax
	mov eax, [ebp+12]
	mov eax, OFFSET arrB
	
	
	mov eax, [ebp+16]
	mov esi, [eax]
	mov currentB, esi		; Move first arrB element to currentB

	mov eax, OFFSET arrC
	mov arrC_ptr, eax		; Move OFFSET of arrC to arrC_ptr

	L1:
			
		mov eax, count  
		inc eax
		cmp eax, limit
		
		jg Exit_L1			; If eax > limit, jump to Exit_L1 point
		
		mov count, eax

; Clear arrBuf for mul_N_32 
		mov eax, OFFSET arrBuf
		mov ebx, 00000000
		mov ecx, LENGTHOF arrBuf

		SetZeroF:
			mov [eax], ebx
			add eax, TYPE arrBuf
			loop SetZeroF

		
; mul_N_32. Requires zero arrBuf
; arrBuf = arrA * currentB
; Uses: ecx, ebx, esi, edi, eax, ebp, esp
		push OFFSET arrA
		push OFFSET currentB
		push OFFSET arrBuf
		push LENGTHOF arrA
		call mul_N_32
		
; LongAdd
; arrC += arrBuf
; Uses: ecx, ebx, edi, eax, ebp, esi, esp
		push OFFSET arrBuf
		push arrC_ptr
		push LENGTHOF arrBuf
		call longAdd

; Change currentB
		mov eax, count
		mov eax, arrB[eax*4]
		mov currentB, eax

		add arrC_ptr, 4		; Shift arrC for next mult operation
		
		jmp L1
Exit_L1:
	pop ebp
	ret 16
mul_N_N ENDP
end