
.686p
.model flat,stdcall
.nolist
option casemap:none
;OPTION PROC:export


include 	..\..\..\masm32\Macros\Strings.mac

include windows.inc
include user32.inc 
include kernel32.inc 
includelib user32.lib 
includelib kernel32.lib
include msvcrt.inc
includelib msvcrt.lib


include ws2_32.inc
includelib ws2_32.lib

IDD_DLG1 EQU 1000

IDC_EDT1 EQU 1001
IDC_EDT2 EQU 1004
IDC_EDT3 EQU 1003
IDC_EDT4 EQU 1006
IDC_EDT5 EQU 1008
IDC_EDT6 EQU 1011
IDC_EDT7 EQU 1012

IDC_BTN1 EQU 1002
IDC_BTN2 EQU 1009
IDC_BTN3 EQU 1010



.data
	C2cmd   byte MAX_PATH dup(0)
	asmcmd  byte MAX_PATH dup(0)
	asmpath byte MAX_PATH dup(0)
	incpath byte MAX_PATH dup(0)
	asmfile byte MAX_PATH dup(0)
	tagfile byte MAX_PATH dup(0)
.code

DlgBuildAsmCmd proc hDlg:HWND
	invoke crt_sprintf,offset asmcmd ,$CTA0("%s %s %s %s & pause"),offset asmpath,offset incpath,offset asmfile,offset tagfile
	invoke SetDlgItemText,hDlg,IDC_EDT5,offset asmcmd
	ret
DlgBuildAsmCmd endp

DlgInit proc hDlg:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	invoke SetDlgItemText,hDlg,IDC_EDT1,offset C2cmd
	invoke SetDlgItemText,hDlg,IDC_EDT3,offset asmpath
	invoke SetDlgItemText,hDlg,IDC_EDT4,offset incpath
	invoke SetDlgItemText,hDlg,IDC_EDT6,offset asmfile
	invoke DlgBuildAsmCmd,hDlg
	ret
DlgInit endp

DlgCmd proc hDlg:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM

	mov eax, wParam
	and eax,0ffffh
	
	.if eax == IDC_BTN1
		invoke GetDlgItemText,hDlg,IDC_EDT1,offset C2cmd,MAX_PATH
		invoke crt_system,offset C2cmd 
		
	.elseif eax == IDC_BTN2
		invoke crt_system,offset asmcmd 
	.elseif eax == IDC_BTN3
		invoke DlgBuildAsmCmd,hDlg
	.endif
	
	ret
DlgCmd endp

DlgProc proc hDlg:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM

	mov eax, uMsg

	.if eax == WM_INITDIALOG
		invoke DlgInit, hDlg, uMsg, wParam, lParam
		mov eax,TRUE
	.elseif eax == WM_COMMAND
		invoke DlgCmd, hDlg, uMsg, wParam, lParam
	.elseif eax == WM_CLOSE
		invoke EndDialog, hDlg, 0
		mov eax,TRUE
		
	.else
		mov eax, FALSE
		
	.endif
	
   	ret
DlgProc endp


_main proc 

	invoke GetCommandLine
	invoke crt_sprintf,offset C2cmd ,$CTA0("org\\%s -Fa foo.asm & pause"),eax
	invoke crt_sprintf,offset asmpath ,$CTA0("..\\masm32\\bin\\ML.EXE /c /coff /Cp /nologo")
	invoke crt_sprintf,offset incpath ,$CTA0("/I..\\masm32\\include\\ /I..\\masm32\\macros\\")
	invoke crt_sprintf,offset asmfile ,$CTA0(".\\Module2\\Module2.asm")
	invoke crt_sprintf,offset tagfile ,$CTA0("-Fo.\\Module2.OBJ")
	
	invoke GetModuleHandle,NULL
	invoke DialogBoxParam,eax,IDD_DLG1,NULL,DlgProc,0
	
	;invoke MessageBox,NULL,addr buf,NULL,MB_OK
	;invoke crt_system,addr buf
	ret
_main endp

end _main