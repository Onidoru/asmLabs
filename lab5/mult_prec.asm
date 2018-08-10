.586
.model flat, c

.data? 
	arrA DWORD ?
	arrB DWORD ?
	arrC DWORD ?
	arrBuf DWORD ?
	arrBuf1 DWORD ?

	arrC_ptr DWORD ?
 
	limit DWORD ?
	currentB DWORD ?
	buf DWORD ?

	count DWORD ? 
	countIn DWORD ?
	countOut DWORD ?

	N DWORD ?
	currentN DWORD ?

	op1  dd 0
	sz   dd 0

.code 

	; Add two arrays, store result in the third one
	; arrC = arrA + arrB 
	; mult_prec_add_three(OFFSET arrA, OFFSET arrB, OFFSET arrC, LENGTHOF arrC)
	mult_prec_add_three PROC

		push ebp
		mov ebp,esp

		mov ecx, [ebp + 8]		; LENGTHOF arrC
		mov ebx, [ebp + 12]		; OFFSET arrC
		mov esi, [ebp + 16]		; OFFSET arrB
		mov edi, [ebp + 20]		; OFFSET arrA

		clc
		pushfd
	
		L1:
		
			mov eax, [edi]      ; Copy current arrA element to eax
			popfd
			adc eax, [esi]      ; Add current arrB element to eax
			pushfd
		
			add edi, TYPE arrA  ; Move pointer to the next arrA element
			add esi, TYPE arrB  ; Move pointer to the next arrB element

			mov [ebx], eax      ; Move current eax value to current arrC element
			add ebx, TYPE arrC  ; Move pointer to the next arrC element
		
		loop L1	

		popfd
		pop ebp
		ret 16

	mult_prec_add_three ENDP


	; Add two arrays, store result in the second one
	; arrB = arrA + arrB
	; mult_prec_add_two(OFFSET arrA, OFFSET arrB, LENGTHOF arrA or arrB)
	mult_prec_add_two PROC

		push ebp
		mov ebp,esp

		mov ecx, [ebp + 8]		; Length of arrA/arrB
		mov ebx, [ebp + 12]		; OFFSET of arrB
		mov edi, [ebp + 16]		; OFFSET of arrA

		clc
		pushfd

		L1:

			mov eax, [edi]			; Add current arrA to eax

			popfd
			adc eax, [ebx]			; Add current arrB element to eax
			pushfd

			mov [ebx], eax			; Move current eax value to current arrB element

			add edi, TYPE arrA		; Move pointer to the next arrA element

			add ebx, TYPE arrB		; Move pointer to the next arrB element

		loop L1

		popfd
		pop ebp
		ret 12

	mult_prec_add_two ENDP

	; Subtract two arrays, write result to third one
	; arrC = arrA - arrB
	; mult_prec_sub(OFFSET arrA, OFFSET arrB, OFFSET arrC, LENGTHOF arrA or arrB or arrC )
	mult_prec_sub PROC

		push ebp
		mov ebp,esp

		mov ecx, [ebp + 8]
		mov ebx, [ebp + 12]
		mov esi, [ebp + 16]
		mov edi, [ebp + 20]

		clc
		pushfd

		L1:
			mov eax, [edi]      ; Copy current arrA element to eax
			popfd
			sbb eax, [esi]      ; Add current arrB element to eax
			pushfd
		
			add edi, TYPE arrA  ; Move pointer to the next arrA element
			add esi, TYPE arrB  ; Move pointer to the next arrB element

			mov [ebx], eax      ; Move current eax value to current arrC element
			add ebx, TYPE arrC  ; Move pointer to the next arrC element
		
			loop L1	

		popfd
		pop ebp
		ret 16

	mult_prec_sub ENDP

	; Multiply multi precious arrA to x32 N , store result in arrC
	; arrC = arrA * N
	; mult_prec_mul_N_32(OFFSET arrA, OFFSET N, OFFSET arrC, LENGTHOF arrA)
	mult_prec_mul_N_32 PROC

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
			adc eax, [ebx]			; Add with CF flag
    		pushfd

			mov [ebx], eax			; Move current eax value to current arrC element
			mov [ebx+4], edx
			add ebx, TYPE arrBuf	; Move pointer to the next arrC element

			loop L1

		popfd
	
		pop ebp
		ret 16

	mult_prec_mul_N_32 ENDP

	; Multiply two multi precious numbers, store result in the third array
	; arrC = arrA * arrB
	; mult_prec_mul_N_N(dword op1_ptr, dword op2_ptr, dword prod_ptr, dword size_in_dwords)
	mult_prec_mul_N_N proc

		push ebp
		mov ebp, esp	

		mov eax, dword ptr[ebp+8]		; OFFSET arrA
		mov dword ptr[op1], eax			

		mov eax, dword ptr[ebp+20]		; LENGTHOF arrC
		mov dword ptr[sz], eax

		mov ecx, dword ptr[ebp+12]		; OFFSET arrB
		mov edi, dword ptr[ebp+16]		; OFFSET arrC
		
		mov ebx, 0
		
		cycle:

			mov esi, 0
			clc
			pushfd
			mov ebp, 0

			cycle2:

				mov eax, dword ptr[op1]
				mov eax, dword ptr[eax+4*esi]
				mul dword ptr[ecx+4*ebx]
				popfd
				adc dword ptr[edi+4*esi], eax		; Add with carry
				pushfd

				mov eax, ebp
				sahf								; Download status flag from ah
				adc dword ptr[edi+4*esi+4], edx		; Add with flag as a carry
				lahf								; Upload status flag to ah
				mov ebp, eax
				inc esi								
				cmp esi, dword ptr[sz]				; Loop the cycle2

			jl cycle2

			popfd
			adc dword ptr[edi+4*esi], 0
			add edi, 4
			inc ebx
			cmp ebx, dword ptr[sz]					; Loop the cycle

		jl cycle
	
		pop ebp
		ret 16

	mult_prec_mul_N_N endp



end