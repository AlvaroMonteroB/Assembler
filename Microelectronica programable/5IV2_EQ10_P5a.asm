;INSTITUTO POLITECNICO NACIONAL.
 ;CECYT 9 JUAN DE DIOS BATIZ.
 ; 
 ;PRACTICA: EXAMEN PARCIAL
 ;
 ;
 ;
 ;GRUPO: 5IV2.  
 ;
 ;INTEGRANTES: 
 ;1.- Montero Barraza Alvaro David.

 
 ; 
 ;
;---------------------------------------------------------------------------------------------
 list p=16f877A
  
;#include "c:\Archivos de programa\Microchip\MPSA Suite\p16f877a.inc";
;#include "c:\Archivos de Programa (x86)\microchip\mpasm suite\p16f877a.inc";  
#include<p16f877a.inc>

;Bits de configuraci�n.
 __config _XT_OSC & _WDT_OFF & _PWRTE_ON & _BODEN_OFF & _LVP_OFF & _CP_OFF; ALL 
;---------------------------------------------------------------------------------------------
;
;fosc = 4 Mhz.
;Ciclo de trabajo del PIC = (1/fosc)*4 = 1 �s.
;t int =(256-R)*(P)*((1/3579545)*4) = 1.0012 ms  ;// Tiempo de interrupcion.
;R=249,  P=128.
;frec int = 1/ t int = 874 Hz.
;---------------------------------------------------------------------------------------------
;
; Registros de proposito general Banco 0 de memoria RAM.
;
; Registros propios de estructura del programa
; Variables. 

unidades      equ        0x20;
decenas       equ        0x21;
temporal      equ        0x22;
Uni_7seg      equ        0x23;
Dec_7seg      equ        0x24;
Contador1     equ        0x25; // 
Contador2     equ        0x26; // 
Contador3     equ        0x27; // 
Contador4     equ        0x28;
centenas      equ   	 0x29;
millar	      equ        0x30;
cent_7seg     equ        0x31;
mill_7seg     equ		 0x32;




;---------------------------------------------------------------------------------------------
;
;Constantes.

O			  equ      	  .79;
PP			  equ		   .3;
Q			  equ		   .4;



;Constantes de caracteres en siete segmentos.
;                   PGFEDCBA
Car_A         equ b'01110111'; Caracter A en siete segmentos.
Car_b         equ b'01111100'; Caracter b en siete segmentos.
Car_C         equ b'00111001'; Caracter C en siete segmentos.
Car_cc        equ b'01011000'; Caracter c en siete segmentos.
Car_d         equ b'01011110'; Caracter d en siete segmentos.
Car_E         equ b'01111001'; Caracter E en siete segmentos.
Car_F         equ b'01110001'; Caracter F en siete segmentos.
Car_G         equ b'01111101'; Caracter G en siete segmentos.
Car_gg        equ b'01101111'; Caracter g en siete segmentos.
Car_H         equ b'01110110'; Caracter H en siete segmentos.
Car_hh        equ b'01110100'; Caracter h en siete segmentos.
Car_i         equ b'00000110'; Caracter i en siete segmentos.
Car_J         equ b'00001110'; Caracter J en siete segmentos.
Car_L         equ b'00111000'; Caracter L en siete segmentos.
Car_n         equ b'01010100'; Caracter n en siete segmentos.
Car_o         equ b'01011100'; Caracter o en siete segmentos.
Car_P         equ b'01110011'; Caracter P en siete segmentos.
Car_q         equ b'01100111'; Caracter q en siete segmentos.
Car_r         equ b'01010000'; Caracter r en siete segmentos.
Car_S         equ b'01101101'; Caracter S en siete segmentos.
Car_t         equ b'01111000'; Caracter t en siete segmentos.
Car_U         equ b'00111110'; Caracter U en siete segmentos.
Car_uu        equ b'00011100'; Caracter u en siete segmentos.
Car_y         equ b'01101110'; Caracter y en siete segmentos.
Car_Z         equ b'01011011'; Caracter Z en siete segmentos.
Car_0         equ b'00111111'; Caracter 0 en siete segmentos.
Car_1         equ b'00000110'; Caracter 1 en siete segmentos.
Car_2         equ b'01011011'; Caracter 2 en siete segmentos.
Car_3         equ b'01001111'; Caracter 3 en siete segmentos.
Car_4         equ b'01100110'; Caracter 4 en siete segmentos.
Car_5         equ b'01101101'; Caracter 5 en siete segmentos.
Car_6         equ b'01111101'; Caracter 6 en siete segmentos.
Car_7         equ b'00000111'; Caracter 7 en siete segmentos.
Car_8         equ b'01111111'; Caracter 8 en siete segmentos.
Car_9         equ b'01100111'; Caracter 9 en siete segmentos.

Car__         equ b'01000000'; Caracter _ en siete segmentos.
Car_null      equ b'00000000'; Caracter nulo en siete segmentos.
;---------------------------------------------------------------------------------------------
; 
;Asignaci�n de los bits de los puertos de I/O.
;Puerto A.
Sin_UsoRA0    equ          .0; // Sin Uso RA0.
Sin_UsoRA1    equ          .1; // Sin Uso RA1.
Sin_UsoRA2    equ          .2; // Sin Uso RA2.
Sin_UsoRA3    equ          .3; // Sin Uso RA3.
Sin_UsoRA4    equ          .4; // Sin Uso RA4.
Sin_UsoRA5    equ          .5; // Sin Uso RA5.
  
proga         equ   b'111111'; // Programaci�n inicial del puerto A.

;Puerto B.
Seg_a         equ          .0; // Salida para controlar el segmento a.
Seg_b         equ          .1; // Salida para controlar el segmento b.
Seg_c         equ          .2; // Salida para controlar el segmento c.
Seg_d         equ          .3; // Salida para controlar el segmento d.
Seg_e         equ          .4; // Salida para controlar el segmento e.
Seg_f         equ          .5; // Salida para controlar el segmento f.
Seg_g         equ          .6; // Salida para controlar el segmento g.
Seg_dp        equ          .7; // Salida para controlar el segmento dp.

progb         equ b'00000000'; // Programaci�n inicial del puerto B.

;Puerto C.
Com_Disp0     equ          .0; // Bit que controla el comun del display 0.
Com_Disp1     equ          .1; // Bit que controla el comun del display 1.
Com_Disp2     equ          .2; // Bit que controla el comun del display 2.
Com_Disp3     equ          .3; // Bit que controla el comun del display 3.
Com_Disp4     equ          .4; // Bit que controla el comun del display 4.
Com_Disp5     equ          .5; // Bit que controla el comun del display 5.
Com_Disp6     equ          .6; // Bit que controla el comun del display 6.
Com_Disp7     equ          .7; // Bit que controla el comun del display 7.


progc         equ b'00000000'; // Programaci�n inicial del puerto C.

;Puerto D.
bit0_num    equ          .0; // Sin Uso RD2.
bit1_num    equ          .1; // Sin Uso RD3.
bit2_num    equ          .2; // Sin Uso RD2.
bit3_num    equ          .3; // Sin Uso RD3.
bit4_num    equ          .4; // Sin Uso RD4.
bit5_num    equ          .5; // Sin Uso RD5.
bit6_num    equ          .6; // Sin Uso RD6.
bit7_num    equ          .7; // Sin Uso RD7.

progd         equ b'11111111'; // Programaci�n inicial del puerto D como entradas.
 
;Puerto E.
aa5           equ          .0; // Sin Uso RE0.
Most_num      equ          .1; // Sin Uso RE1.
Led_Op        equ          .2; // Led Op.

proge         equ      b'011'; // Programaci�n inicial del puerto E.
;---------------------------------------------------------------------------------------------
 
                 ;====================
                 ;==  Vector reset  ==
                 ;====================
                 org 0x0000;         
vec_reset        clrf pclath; Asegura la pagina cero de la mem: de prog.         
                 goto prog_prin; 
;---------------------------------------------------------------------------------------------

                 ;============================== 
                 ;==  Vector de interrupcion  ==
                 ;==============================
                 org 0x0004;                  
vec_int          nop;

                 retfie;               
;---------------------------------------------------------------------------------------------
                 
                 ;===========================
                 ;==  Subrutina de inicio  ==
                 ;===========================
prog_ini         bsf status,rp0; selec. el bco. 1 de ram.
                 movlw 0x81;                       
                 movwf option_reg ^0x80;
                 movlw proga;                                 
                 movwf trisa ^0x80;
                 movlw progb;                       
                 movwf trisb ^0x80;
                 movlw progc;                       
                 movwf trisc ^0x80;
                 movlw progd;                       
                 movwf trisd ^0x80;
                 movlw proge;                        
                 movwf trise ^0x80;
                 movlw 0x06;                       
                 movwf adcon1 ^0x80;conf. el pto. a como salidas i/o.
                 bcf status,rp0; reg. bc0. ram.
				
				 ; Inicializaci�n de registros y/o variables.
                 clrf portb;
                 bsf portc,com_disp0;
                 nop;
                 bsf portc,com_disp1;
				 nop;
				 bsf portc,com_disp2;
				 nop;
				 bsf portc,com_disp3;
				 nop;
				 bsf portc,com_disp4;
				 nop;
				 bsf portc,com_disp5;
				 nop;
				 bsf portc,com_disp6;
				 nop;
				 bsf portc,com_disp7;
			
                 bsf porte,Led_Op; Apaga el LED.
                                                    
                 return;                          
;---------------------------------------------------------------------------------------------
                                                  
                 ;==========================
                 ;==  Programa principal  ==
                 ;==========================
prog_prin        call prog_ini;

				 bcf porte,Led_Op;
                 call retardo2; 
                 bsf porte,Led_Op;
   				 call retardo2; 
				 bcf porte,Led_Op;
                 call retardo2; 
                 bsf porte,Led_Op;
   				 call retardo2;
				 bcf porte,Led_Op;
                 call retardo2; 
                 bsf porte,Led_Op;
   				 call retardo2;
				
loop_prin        call cuenta;
                 call conv_var7seg;
                 call mues_cuenta;
                 goto loop_prin;
;---------------------------------------------------------------------------------------------

                 ;===========================
                 ;==  Subrutina de cuenta  ==
                 ;===========================
cuenta           
				 
				 incf unidades,f;  unidades <-- unidades + 1
                 movlw .10;
                 subwf unidades,w;
                 btfss status,Z;
                 goto salte_ctatime;
                 clrf unidades;

                 incf decenas,f;  
                 movlw .10;
                 subwf decenas,w;
                 btfss status,Z;
                 goto salte_ctatime; 
                 clrf decenas;

				 incf centenas,f;
				 movlw .10;
				 subwf centenas,w;
				 btfss status,Z;
				 goto salte_ctatime;
				 clrf centenas;

			    btfss millar,.1;
			    incf millar,f;	
				 
chanfle
				 movlw .1;
				 subwf millar,w;
				 btfss status,z;
				 goto salte_ctatime;
				 movlw .9;
				 subwf centenas,w;
				 btfss status,z;
				 goto salte_ctatime;
				 movlw .9;
				 subwf decenas,w;
				 btfss status,z;
				 goto salte_ctatime;
				 movlw .9;
				 subwf unidades,w;
				 btfss status,z;
				 goto salte_ctatime
				 


				 clrf millar;
				 clrf centenas;
				 clrf decenas;
				 clrf unidades;
                                 
salte_ctatime    return;
;---------------------------------------------------------------------------------------------

                 ;===================================================
                 ;==  Subrutina de conversion binario 7 segmentos  ==
                 ;===================================================
conv_var7seg   
			
			     movf unidades,w;
                 movwf temporal;
                 call conv_7seg;
                 movf temporal,w;
                 movwf Uni_7seg; 

                 movf decenas,w;
                 movwf temporal;
                 call conv_7seg;
                 movf temporal,w;
                 movwf Dec_7seg; 

				 movf centenas,w;
				 movwf temporal;
				 call conv_7seg;
				 movf temporal,w;
				 movwf cent_7seg;

			 	 movf millar,w;
				 movwf temporal;
				 call conv_7seg;
				 movf temporal,w;
				 movwf mill_7seg;
		
				
		
				
                                  
                 return;
;---------------------------------------------------------------------------------------------       

                 ;===================================================
                 ;==  Subrutina de conversion binario 7 segmentos  ==
                 ;===================================================
conv_7seg        movlw .0;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_cero;
                 movlw .1;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_uno; 
                 movlw .2;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_dos; 
                 movlw .3;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_tres; 
                 movlw .4;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_cuatro;
                 movlw .5;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_cinco; 
                 movlw .6;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_seis; 
                 movlw .7;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_siete; 
                 movlw .8;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_ocho; 
                 movlw .9;
                 subwf temporal,w;
                 btfsc status,Z;
                 goto fue_nueve; 

fue_cero         movlw Car_0;
                 movwf temporal;
                 goto sal_conv;

fue_uno          movlw Car_1;
                 movwf temporal;
                 goto sal_conv;

fue_dos          movlw Car_2;
                 movwf temporal;
                 goto sal_conv;

fue_tres         movlw Car_3;
                 movwf temporal;
                 goto sal_conv;  

fue_cuatro       movlw Car_4;
                 movwf temporal;
                 goto sal_conv;  

fue_cinco        movlw Car_5;
                 movwf temporal;
                 goto sal_conv; 

fue_seis         movlw Car_6;
                 movwf temporal;
                 goto sal_conv; 

fue_siete        movlw Car_7;
                 movwf temporal;
                 goto sal_conv;  

fue_ocho         movlw Car_8;
                 movwf temporal;
                 goto sal_conv; 

fue_nueve        movlw Car_9;
                 movwf temporal;
                                  
sal_conv         return;
;---------------------------------------------------------------------------------------------       

                 ;========================================
                 ;==  Subrutina de mostrado del tiempo  ==
                 ;========================================
mues_cuenta      movlw .24;
                 movwf Contador4;
men              
				 movf mill_7seg,w;
                 movwf portb;
                 bcf portc,Com_Disp0;
                 call retardo;
                 bsf portc,Com_Disp0; 
                 nop;
                 movf cent_7seg,w;
                 movwf portb;
                 bcf portc,Com_Disp1;
                 call retardo;
                 bsf portc,Com_Disp1; 
                 nop;
                 movf dec_7seg,w;
                 movwf portb;
                 bcf portc,Com_Disp2;
                 call retardo;
                 bsf portc,Com_Disp2; 
                 nop;
                 movf uni_7seg,w;
                 movwf portb;
                 bcf portc,Com_Disp3;
                 call retardo;
                 bsf portc,Com_Disp3; 
                 nop;
                 
                 decfsz Contador4,f;
                 goto men;

                 return;
;---------------------------------------------------------------------------------------------

            
                 ;=============================================
                 ;==  Subrutina de retardo de medio segundo  ==
                 ;=============================================
retardo2         movlw .41;
                 movwf Contador3;
Loop32           movlw .167;
                 movwf Contador2;
Loop22           movlw .23;                   
                 movwf Contador1;   
Loop12           decfsz Contador1,f;  
                 goto Loop12;
                 decfsz Contador2,f;
                 goto Loop22; 
                 decfsz Contador3,f;
                 goto Loop32;

                 return;


  				 ;=============================================
                 ;==  Subrutina de retardo de 4 milisegs  ==
                 ;=============================================
retardo          movlw O;
                 movwf Contador3;
Loop33           movlw PP;
                 movwf Contador2;
Loop23 	         movlw Q;                   
                 movwf Contador1;   
Loop13           decfsz Contador1,f;  
                 goto Loop13;
                 decfsz Contador2,f;
                 goto Loop23; 
                 decfsz Contador3,f;
                 goto Loop33;

                 return;
;---------------------------------------------------------------------------------------------
   			end
                