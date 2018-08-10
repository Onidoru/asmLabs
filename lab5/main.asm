.586
.model flat, stdcall
ExitProcess PROTO, dwExitCode:DWORD

include mult_prec.inc
include convert.inc
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

  ;arrA DWORD 20 dup(0)
  ;arrB DWORD 20 dup(0)

  arrC DWORD 20 dup(0)
  arrBuf DWORD 20 dup(0)
  
  arrBuf1 DWORD 20 dup(0)
  arrC_ptr DWORD ?

  count DWORD 0 
  limit DWORD 0
  currentB DWORD 0
  currentN DWORD 0

  
  arrA DWORD 0FFFFFFFFh, 0FFFFFFFFh, 0FFFFFFFFh, 0FFFFFFFFh, 16 dup(0)
  arrB DWORD 11111111h, 11111111h, 11111111h, 11111111h, 16 dup(0)
  T3 DWORD 0FFFFFFFFh
  N DWORD 0Fh
  toOut DB 64 dup(?)

.code

main PROC
	
	; Test procedure
	push OFFSET arrA
	push OFFSET arrB
	push OFFSET arrC
	push LENGTHOF arrC
	call mult_prec_add_three

	; Convert result to HEX toOut
	push OFFSET toOut
	push OFFSET arrC
	push 256
	call convert_hex_to_strhex
	INVOKE MessageBoxA, 0, ADDR toOut, ADDR CaptionOut, 0

	INVOKE ExitProcess,0
main ENDP
END main
