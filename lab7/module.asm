.586
.model flat, c

.data?
	arrA DWORD ?
	arrB DWORD ?
	arrBuf DWORD ?
	countIn DWORD ?
	countOut DWORD ?

.code

		HexSymbol_MY proc
			and al, 0Fh
			add al, 48			; For 0-9
			cmp al, 58
			jl Finish
			add al, 7			; For A-F
			Finish:
			ret
		HexSymbol_MY endp


	StrHex_MY proc
		push ebp
		mov ebp,esp
		mov ecx, [ebp+8] ; number of bits
		cmp ecx, 0
		jle Finish
		shr ecx, 3 ; number of bits
		mov esi, [ebp+12] ; number ptr
		mov ebx, [ebp+16] ; buf pt
		L1:
			mov dl, byte ptr[esi+ecx-1] ; each byte is two first hex digits
			mov al, dl
			shr al, 4 ; the last digit
			call HexSymbol_MY
			mov byte ptr[ebx], al
			mov al, dl ; the first digit
			call HexSymbol_MY
			mov byte ptr[ebx+1], al
			mov eax, ecx
			cmp eax, 4
			jle L2
			dec eax
			and eax, 3 ; separate nibbles, each nibble is 8 digits
			cmp al, 0
			jne L2
			mov byte ptr[ebx+2], 32 ; symbol code
			inc ebx
		L2:
			add ebx, 2
			dec ecx
			jnz L1
			mov byte ptr[ebx], 0
		Finish:
			pop ebp
			ret 12
		StrHex_MY endp

		hex_to_decStr PROC
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
					cmp ecx, ebx					; check each byte, if all zero - end cycle
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
		hex_to_decStr ENDP

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
		and ah, 1111b					; Clear highest 4 ax bits
		mov bl, 00010000b				; Write Mask to first half
		xor bh, bh						; CLear highest bits
		cycle:
			cmp bl, 1

			ja bl_g_the_1
				mov al, byte ptr[esi+ecx-2]
			bl_g_the_1:
			and ah, 00011111b			; Zero 3 highest bits
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

	div_10_2 proc
		push ebp
		mov ebp, esp

		push edx
		push esi
		push edi

		mov esi, dword ptr[ebp+8]		; Source number
		mov ecx, dword ptr[ebp+12]		; Byte size
		mov edi, dword ptr[ebp+16]		; Result

		mov al, 0
		mov ah, 0
		mov dl, 0ah

		L1:
			add al, byte ptr[esi+ecx-1]
			div dl
			mov byte ptr[edi+ecx-1], al
			shr ax, 8
		loop L1

		mov al, ah

		pop edi
		pop esi
		pop edx

		pop ebp
		ret 12

	div_10_2 endp


end
