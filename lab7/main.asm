.586
.model flat, stdcall
ExitProcess PROTO, dwExitCode:DWORD

include module.inc
include \Irvine\Irvine32.inc
includelib \Irvine\kernel32.lib
includelib \Irvine\user32.lib


.data
  CaptionOut BYTE "Last <<< --- First // ", 0
  CaptionCurrent BYTE "Current: ", 0
  CaptionCheckM BYTE "Check Mul:  ", 0
  CaptionCheckA BYTE "Check Add:  ", 0
  CaptionZ BYTE "Zero?:  ", 0

  ; First --->>> Last


  arrA DWORD 20 dup(0)
  arrB DWORD 20 dup(0)

  arrC DWORD 20 dup(0)
  arrBuf DWORD 20 dup(0)
  
  arrBuf1 DWORD 20 dup(0)
  arrC_ptr DWORD ?

  count DWORD 0 
  limit DWORD 0
  currentB DWORD 0
  currentN DWORD 0

  N DWORD 56, 39 dup(0)
  X DWORD 14
  M DWORD 1
  Y DWORD 0

  toOutD DB 512 dup(?)
  toOutH DB 64 dup(?)
  toOutY DB 64 dup(?)


.code
	
main PROC
; N! 
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

; Convert result to HEX toOut
	push OFFSET toOutH
	push OFFSET N
	push 512
	call StrHex_MY
	INVOKE MessageBoxA, 0, ADDR toOutH, ADDR CaptionOut, 0

; Convert N to decStr
	push OFFSET toOutD
	push 64
	push OFFSET N
	call hex_to_decStr
	INVOKE MessageBoxA, 0, ADDR toOutD, ADDR CaptionOut, 0


	mov eax, dword ptr[X]
	add M, 2
	mov cl, byte ptr[M]
	shl eax, cl
	xor edx, edx
	mov ebx, 7
	idiv ebx
	mov dword ptr[Y], eax

	push offset toOutY
	push 4
	push offset Y
	call hex_to_decStr
	INVOKE MessageBoxA, 0, ADDR toOutY, ADDR CaptionOut, 0

	INVOKE ExitProcess,0
main ENDP
END main
