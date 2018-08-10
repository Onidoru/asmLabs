.586
.model flat, c

include \Irvine\Irvine32.inc
includelib \Irvine\kernel32.lib
includelib \Irvine\user32.lib


.data?
	arrA DWORD ?
	arrB DWORD ?
	arrBuf DWORD ?
	countIn DWORD ?
	countOut DWORD ?

.code

	HexSymbol_MY proc
		and al, 0Fh
		add al, 48			
		cmp al, 58
		jl Finish
		add al, 7
		Finish:
		ret
	HexSymbol_MY endp

	; Converts machine hex to string format hex number
	; convert_hex_to_strhex(OFFSET dest, OFFSET src, bits number)
	convert_hex_to_strhex proc
		push ebp
		mov ebp,esp
		mov ecx, [ebp+8]
		cmp ecx, 0
		jle Finish
		shr ecx, 3
		mov esi, [ebp+12]
		mov ebx, [ebp+16]
		L1:
			mov dl, byte ptr[esi+ecx-1]
			mov al, dl
			shr al, 4
			call HexSymbol_MY
			mov byte ptr[ebx], al
			mov al, dl
			call HexSymbol_MY
			mov byte ptr[ebx+1], al
			mov eax, ecx
			cmp eax, 4
			jle L2
			dec eax
			and eax, 3
			cmp al, 0
			jne L2
			mov byte ptr[ebx+2], 32
			inc ebx
		L2:
			add ebx, 2
			dec ecx
			jnz L1
			mov byte ptr[ebx], 0
		Finish:
			pop ebp
			ret 12
		convert_hex_to_strhex endp


		; Convert machine hex to string decimal
		; convert_hex_to_strdec(OFFSET dest, LENGTHOF arr, OFFSET arr) 
		convert_hex_to_strdec PROC
			push ebp
			mov ebp,esp

			push ebx
			push esi
			push edi

			mov esi, dword ptr[ebp+8]			; Source variable
			mov ebx, dword ptr[ebp+12]			; DWORD size
			mov edi, dword ptr[ebp+16]			; String

			cycle:
				push esi
				push ebx
				push esi
				call div_10_1

				add al, 48						; al - remainder, +48 - to string
				mov byte ptr[edi], al			; Write remainder
				inc edi

				xor ecx, ecx					; ecx = 0
				check:
					cmp ecx, ebx				; check each byte, if all zero - end cycle
					je endch
						add ecx, 1
						cmp byte ptr[esi+ecx-1], 0
					je check

			jmp cycle

			endch:
				mov byte ptr[edi], 0			; Terminate string
				mov esi, dword ptr[ebp+16]		; First number address
				dec edi

			Reverse:
				cmp esi, edi
				ja Finish
					mov bl, byte ptr[esi]
					mov bh, byte ptr[edi]
					mov byte ptr[esi], bh
					mov byte ptr[edi], bl
					inc esi
					dec edi
				jmp Reverse

			Finish:
				pop edi
				pop esi
				pop ebx


			pop ebp
			ret 16
		convert_hex_to_strdec ENDP


		; Div 10 procedure
		div_10_1 proc
			push ebp
			mov ebp, esp

			push ebx
			push esi
			push edi

			mov esi, dword ptr[ebp+8]		; Source number
			mov ecx, dword ptr[ebp+12]		; Byte size
			mov edi, dword ptr[ebp+16]		; Result

			mov al, byte ptr[esi+ecx-1]		; al = last byte
			shl ax, 4						; Place at the middle
			and ah, 1111b					; Clear hightest 4 ax bits
			mov bl, 00010000b				; Write Mask to first half
			xor bh, bh						; CLear hightest bits
			cycle:
				cmp bl, 1

				ja bl_g_the_1
					mov al, byte ptr[esi+ecx-2]
				bl_g_the_1:
				and ah, 00011111b			; Zero 3 hightest bits
				cmp ah, 1010b				; Compare with 10
				jl dec_10
					or bh, bl				; If => 10,
					sub ah, 1010b			; minus 10
				dec_10:
				shl ax, 1
				shr bl, 1
			jnz cycle

				mov byte ptr[edi+ecx-1], bh	; Part of number to result
				xor bh, bh
				or bl, 10000000b			; Move to next byte of result
				dec ecx
			jnz cycle

			xor al, al
			shr ah, 1
			mov al, ah						; Remainder

			pop edi
			pop esi
			pop ebx

			pop ebp
			ret 12
		div_10_1 endp

		; Copy one array to another one
		; copy_arr(OFFSET src, OFFSET dest, LENGTHOF size)
		copy_arr proc
			push ebp
			mov ebp, esp

			mov eax, dword ptr[ebp+8]
			mov ecx, dword ptr[ebp+16]
			mov ebp, dword ptr[ebp+12]

			cycle:

				mov dl, byte ptr[eax+ecx-1]
				mov byte ptr[ebp+ecx-1], dl

			loop cycle
			
			pop ebp
			ret 12
		copy_arr endp

end
