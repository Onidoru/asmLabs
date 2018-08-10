.586
.model flat, c

include module.inc
include longop.inc

include \Irvine\Irvine32.inc
includelib \Irvine\kernel32.lib
includelib \Irvine\user32.lib

.code

StrFloat32 proc float: dword, dest: dword
	local bcd_temp: tbyte
	local scale: dword
	
	mov edi, dest
	mov esi, float

	test esi, 80000000h ; place a sign -- if any
	jz positive
		mov byte ptr[edi], "-"
		inc edi
	positive:
	
	and esi, 7FFFFFFFh  ; cut off a sign bit
	jz zero
	
	cmp esi, 7FFFFFh	; unnormalized number -- error
	jle err
	
	cmp esi, 7F800000h  ; if exp == E(max) then it's nan (unsigned) or inf (signed)
	ja nan
	je inf
	
	mov scale, esi
	fld scale
	mov scale, 1000000
	fimul scale
	fbstp bcd_temp
	
	mov ebx, edi
	lea edx, bcd_temp
	mov ecx, 9
	cycle:
		cmp ecx, 6
		jne @f
			mov byte ptr[edi], "."
			inc edi
		@@:
		xor ah, ah
		mov al, [edx]
		inc edx
		shl ax, 4
		shr al, 4
		add ax, 3030h
		mov [edi], al
		mov [edi+1], ah
		add edi, 2
	loop cycle
	
	dec edi
	skip_zeros:
		cmp byte ptr[edi], "0"
		jne next
		dec edi
	jmp skip_zeros

	next:
	push edi
	reverse:
		mov al, [edi]
		mov ah, [ebx]
		mov [edi], ah
		mov [ebx], al
		inc ebx
		dec edi
		cmp ebx, edi
	jbe reverse
	
	pop edi
	inc edi
	jmp exit
	
	inf:
		mov dword ptr[edi], "fni"
		jmp add3
		
	err:
		mov edi, [ebp+12]
		mov dword ptr[edi], "rre"
		jmp add3

	nan:
		mov edi, [ebp+12]
		mov dword ptr[edi], "nan"
		jmp add3
		
	zero:
		mov edi, [ebp+12]
		mov dword ptr[edi], "0.0"
		
	add3:
		add edi, 3
	exit:
		mov byte ptr[edi], 0
		
	ret
StrFloat32 endp

end
