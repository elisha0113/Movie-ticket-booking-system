ORG 100h

.MODEL small

.STACK 100h

.DATA 

; Welcome page
a1 db 10,13,'               *********************************************$'
a2 db 10,13,'               **           Welcome to City Cineplex      **$'
a3 db 10,13,'               **               Ticket Booking            **$'
a4 db 10,13,'               *********************************************$'

; for login
welcome_msg db 10,13,"Welcome to City Cineplex Ticketing System!$",0Dh,0Ah
enterName_msg db 10,13,"Please enter your username: $",0Dh,0Ah
enterPwd_msg db 10,13,"Please enter your password: $" ,0Dh,0Ah
username_buffer db 20, ?      
password_buffer db 20, ?

menu: DB 10,13,10,13,"1- Movie details",0Dh,0Ah
      DB             "2- Book a ticket",0Dh,0Ah
      DB             "3- Exit the application",0Dh,0Ah,
      DB "Please choose: ", '$'
      
      invalid_choice_msg db 10,13,"Invalid choice! Please enter again: $"

CrLf db 13,10,'$'    

totalbill: DB 0Dh,0Ah,"The price is: ",'$'
withtax: DB 0Dh,0Ah,"The price with 5% Sales and Service tax: ",'$'

theaters_info:
     DB 0Dh,0Ah,0Dh,0Ah,"***Movie name***               **Genre**          **Duration**",0Dh,0Ah
     DB 10,13,"The Lord of Rings              Adventure          2 hours     ",0Dh,0Ah
     DB "SuperGood                      Comedy             1 hour 45 mins",0Dh,0Ah
     DB "Happy Max:Fury Road            Action             2 hours 15 mins",0Dh,0Ah
     DB "Inception                      Thriller           2 hours 5 mins",0Dh,0Ah
     DB "The Conjuring                  Horror             1 hours 50 mins",0Dh,0Ah,'$'
                                                          
;put it together so it can display it clearly
adventurecomedy_theater:
     DB 10,13,"1- The Lord of Rings                   2- SuperGood",0Dh,0Ah,
     DB "**Ticket**          **Price**          **Ticket**          **Price**",0Dh,0Ah
     DB "Students             RM 12             Students             RM 15",0Dh,0Ah
     DB "Adults               RM 20             Adults               RM 23",0Dh,0Ah
     DB "Seniors              RM 15             Seniors              RM 17",0Dh,0Ah,'$'


actionthriller_theater:
     DB 10,13,"3- Happy Max:Fury Road                 4- Inception",0Dh,0Ah,
     DB "Ticket               Price             Ticket               Price ",0Dh,0Ah
     DB "Students             RM 18             Students             RM 14",0Dh,0Ah
     DB "Adults               RM 26             Adults               RM 19",0Dh,0Ah
     DB "Seniors              RM 21             Seniors              RM 16 ",0Dh,0Ah,'$'


horror_theater:
     DB 10,13,"5- The Conjuring",0Dh,0Ah,
     DB "Ticket               Price ",0Dh,0Ah
     DB "Students             RM 11 ",0Dh,0Ah
     DB "Adults               RM 20 ",0Dh,0Ah
     DB "Seniors              RM 15 ",0Dh,0Ah,'$'

theaters: DB 0Dh,0Ah,"What theater would you like to go to (1-Adventure, 2-Comedy, 3-Action, 4-Thriller, 5-Horror)? ",'$'
ticket: DB 0Dh,0Ah,"What ticket would you like to buy (1-student, 2-adult, 3-seniors)? ",'$'
ticket_number: DB 0Dh,0Ah,"How many tickets do you want to buy: ",'$'  

student_adventure DD 12 ; student Price for adventure theater       
adult_adventure DD 20 ; adult Price for adventure theater
seniors_adventure DD 15 ; seniors Price for adventure theater  

student_comedy DD 15 ; student Price for comedy theater       
adult_comedy DD 23 ; adult Price for comedy theater
seniors_comedy DD 17 ; seniors Price for comedy theater

student_action DD 18  ; student Price for action theater       
adult_action DD 26 ; adult Price for action theater
seniors_action DD 21 ; seniors Price for action theater 

student_thriller DD 14  ; student Price for thriller theater       
adult_thriller DD 19 ; adult Price for thriller theater
seniors_thriller DD 16 ; seniors Price for thriller theater 

student_horror DD 11  ; student Price for horror theater       
adult_horror DD 20 ; adult Price for horror theater
seniors_horror DD 15 ; seniors Price for horror theater

theater_type DB 0
ticket_type DB 0
ticket_num DD 0
ticket_price DD 0   
result DD 0
tax DD 5     
divide DD 100  

proceed_payment_msg db 10,13,"Do you want to proceed to payment?(Y=yes/N=no): $"
credit_card_msg db 10,13,"Please enter your credit card number : $"
credit_card_buffer db 20, ?   
invalid_credit_card_msg db 10,13,"Invalid credit card number! Please enter again!$"
payment_success_msg db 10,13,"Payment successful.Thank you for purchasing our ticket! Enjoy your movie!$"                                                                 
continue_prompt db 10,13,10,13,"Do you want to continue use this app?(Y=yes/N=no)?" ,'$'                                                        

.CODE

BEGIN:
    MOV AX, @DATA
    MOV DS, AX 

    ; Display welcome page
    MOV AH, 09h
    LEA DX, a1
    INT 21h
    LEA DX, a2
    INT 21h
    LEA DX, a3
    INT 21h
    LEA DX, a4
    INT 21h

    ; Jump to the login prompt
    JMP LOGIN_PROMPT

LOGIN_PROMPT:
    ; Display message asking for username
    MOV AH, 09h
    LEA DX, enterName_msg
    INT 21h

    ; Read username input
    MOV AH, 0Ah
    MOV DX, OFFSET username_buffer
    INT 21h

    ; Display message asking for password
    MOV AH, 09h
    LEA DX, enterPwd_msg
    INT 21h

    ; Read password input
    MOV AH, 0Ah
    MOV DX, OFFSET password_buffer
    INT 21h  

    ; Jump to the start of the program after login
    JMP START

START:
    ; Code to display the menu  
    
    MOV DX, OFFSET CrLf
    MOV AH, 9
    INT 21H
    
    MOV AH, 09h
    MOV DX, OFFSET menu
    INT 21h

    ; code to choose one choice from the menu
GET_CHOICE:
    MOV AH, 1
    INT 21h
    
     ; Check if the choice is within valid range (1-3)
    CMP AL, '1'
    JL INVALID_CHOICE
    CMP AL, '3'
    JG INVALID_CHOICE
    
    ; first choice
    CMP AL, '1'
    JE FIRST_CHOICE

    ; second choice
    CMP AL, '2'
    JE SECOND_CHOICE

    ; third choice
    CMP AL, '3'
    JE THIRD_CHOICE

    JMP GET_CHOICE
    
    
INVALID_CHOICE:
    ; Display error message
    MOV AH, 09h
    LEA DX, invalid_choice_msg
    INT 21h

    JMP GET_CHOICE

FIRST_CHOICE:
    ; Code to display the theaters_info message
    MOV DX, OFFSET theaters_info
    MOV AH, 9
    INT 21h

    ; return to menu
    JMP START

SECOND_CHOICE:
    ; Code to display the theater type message
    MOV DX, OFFSET adventurecomedy_theater
    MOV AH, 9
    INT 21h  

    MOV DX, OFFSET actionthriller_theater
    MOV AH, 9
    INT 21h  

    MOV DX, OFFSET horror_theater
    MOV AH, 9
    INT 21h  

    ; Get the theater type
    MOV DX, OFFSET theaters
    MOV AH, 9
    INT 21h

    ; Get the theater type 
    MOV AH, 1
    INT 21H
    MOV theater_type, AL

    ; Validate input
    CMP theater_type, '1'
    JL Choose_theater
    CMP theater_type, '5'
    JG Invalid_movie_choice

    ; Code to display the ticket_type message
    MOV DX, OFFSET ticket
    MOV AH, 9
    INT 21h    

Choose_theater:
    ; Get the ticket type 
    MOV AH, 1
    INT 21H
    MOV ticket_type, AL

    ; Validate input
    CMP ticket_type, '1'
    JL Choose_ticket
    CMP ticket_type, '3'
    JG Choose_ticket

    ; Code to display the ticket_number message
    MOV DX, OFFSET ticket_number
    MOV AH, 9
    INT 21h

Choose_ticket:
    ; Get the ticket number      
    CALL INDEC
    MOV ticket_num, AX

    ; Validate input
    CMP ticket_num, 1
    JL Choose_ticket

    ; Calculate price
    CMP theater_type, '1'
    JE adventure_cinema
    CMP theater_type, '2'
    JE comedy_cinema 
    CMP theater_type, '3'
    JE action_cinema 
    CMP theater_type, '4'
    JE thriller_cinema 
    CMP theater_type, '5'
    JE horror_cinema

    JMP SECOND_CHOICE

Invalid_movie_choice:
    ; Display error message for invalid movie choice
    MOV AH, 09h
    LEA DX, invalid_choice_msg
    INT 21h

    JMP SECOND_CHOICE



; Code for the adventure theaters
adventure_cinema:
    ; Student ticket
    CMP ticket_type, '1'
    JNE adult_ticket_adventure
    MOV AX, student_adventure
    MOV ticket_price, AX
    JMP calculate

adult_ticket_adventure:
    ; Adult ticket
    CMP ticket_type, '2'
    JNE seniors_ticket_adventure
    MOV AX, adult_adventure
    MOV ticket_price, AX
    JMP calculate

seniors_ticket_adventure:
    ; Seniors ticket
    CMP ticket_type, '3'
    JNE SECOND_CHOICE
    MOV AX, seniors_adventure
    MOV ticket_price, AX
    JMP calculate 

; Code for the comedy theaters
comedy_cinema:
    ; Student ticket
    CMP ticket_type, '1'
    JNE adult_ticket_comedy
    MOV AX, student_comedy
    MOV ticket_price, AX
    JMP calculate

adult_ticket_comedy:
    ; Adult ticket
    CMP ticket_type, '2'
    JNE seniors_ticket_comedy
    MOV AX, adult_comedy
    MOV ticket_price, AX
    JMP calculate

seniors_ticket_comedy:
    ; Seniors ticket
    CMP ticket_type, '3'
    JNE SECOND_CHOICE
    MOV AX, seniors_comedy
    MOV ticket_price, AX
    JMP calculate

; Code for the action theaters
action_cinema:
    ; Student ticket
    CMP ticket_type, '1'
    JNE adult_ticket_action
    MOV AX, student_action
    MOV ticket_price, AX
    JMP calculate

adult_ticket_action:
    ; Adult ticket
    CMP ticket_type, '2'
    JNE seniors_ticket_action
    MOV AX, adult_action
    MOV ticket_price, AX
    JMP calculate

seniors_ticket_action:
    ; Seniors ticket
    CMP ticket_type, '3'
    JNE SECOND_CHOICE
    MOV AX, seniors_action
    MOV ticket_price, AX
    JMP calculate  

; Code for the thriller theaters
thriller_cinema:
    ; Student ticket
    CMP ticket_type, '1'
    JNE adult_ticket_thriller
    MOV AX, student_thriller
    MOV ticket_price, AX
    JMP calculate

adult_ticket_thriller:
    ; Adult ticket
    CMP ticket_type, '2'
    JNE seniors_ticket_thriller
    MOV AX, adult_thriller
    MOV ticket_price, AX
    JMP calculate

seniors_ticket_thriller:
    ; Seniors ticket
    CMP ticket_type, '3'
    JNE SECOND_CHOICE
    MOV AX, seniors_thriller
    MOV ticket_price, AX
    JMP calculate

; Code for the horror theaters
horror_cinema:
    ; Student ticket
    CMP ticket_type, '1'
    JNE adult_ticket_horror
    MOV AX, student_horror
    MOV ticket_price, AX
    JMP calculate

adult_ticket_horror:
    ; Adult ticket
    CMP ticket_type, '2'
    JNE seniors_ticket_horror
    MOV AX, adult_horror
    MOV ticket_price, AX
    JMP calculate

seniors_ticket_horror:
    ; Seniors ticket
    CMP ticket_type, '3'
    JNE SECOND_CHOICE
    MOV AX, seniors_horror
    MOV ticket_price, AX
    
    JMP calculate

calculate:
    MOV CX, ticket_num
    MOV AX, ticket_price
    MUL CX  ; ticket_num * ticket_price
    MOV result, AX

    ; Code to display the total bill message
    MOV DX, OFFSET totalbill
    MOV AH, 9
    INT 21H      

    MOV AX, result
    CALL OUTDEC

    MOV DX, OFFSET CrLf
    MOV AH, 9
    INT 21H
    
    ; Prompt user to continue payment or not
    MOV DX, OFFSET proceed_payment_msg
    MOV AH, 9
    INT 21h

    ; Get user's choice
    MOV AH, 01h
    INT 21h

    ; Check user's choice
    CMP AL, 'Y'
    JE CAL_TAX
    CMP AL, 'y'
    JE CAL_TAX
    JMP START

CAL_TAX:    
 ; Code to display price with tax
   ;; Calculate tax
MOV AX, result     ; Move the result (total price) to AX
MOV BX, tax        ; Move the tax rate to BX
MUL BX             ; Multiply AX by BX, result in DX:AX
DIV divide         ; Divide DX:AX by 100 to get the integer part of the division
ADD AX, result     ; Add the tax to the original price (in AX)
MOV result, AX     ; Store the updated result back

; Code to display price with tax
; Code to display price with tax
MOV DX, OFFSET withtax
MOV AH, 9
INT 21H

MOV AX, result     ; Move the updated result (with tax) to AX
CALL OUTDEC

; Prompt the user to enter credit card number
    MOV AH,09h
    LEA DX, credit_card_msg
    INT 21h

    ; Get credit card number input
    MOV AH, 0Ah
    MOV DX, OFFSET credit_card_buffer
    INT 21h


PAYMENT_SUCCESS:
    ; Code to process payment
    ; Display payment success message
    MOV DX, OFFSET payment_success_msg
    MOV AH, 9
    INT 21h

    ; Prompt user to continue or exit
    MOV DX, OFFSET continue_prompt
    MOV AH, 9
    INT 21h

    ; Get user's choice
    MOV AH, 01h
    INT 21h

    ; Check user's choice
    CMP AL, 'Y'
    JE START
    CMP AL, 'y'
    JE START
    JMP EXIT_PROGRAM

THIRD_CHOICE:
    ; Exit the program
    JMP EXIT_PROGRAM

EXIT_PROGRAM:
    MOV AH, 4Ch
    INT 21h

INDEC PROC

   PUSH BX
   PUSH CX
   PUSH DX

   JMP @READ

   @SKIP_BACKSPACE:
   MOV AH, 2
   MOV DL, 20H
   INT 21H

   @READ:
   XOR BX, BX
   XOR CX, CX
   XOR DX, DX

   MOV AH, 1
   INT 21H

   CMP AL, '-'
   JE @MINUS

   CMP AL, '+'
   JE @PLUS

   JMP @SKIP_INPUT

   @MINUS:
   MOV CH, 1
   INC CL
   JMP @INPUT

   @PLUS:
   MOV CH, 2
   INC CL

   @INPUT:
     MOV AH, 1
     INT 21H

     @SKIP_INPUT:

     CMP AL, 0DH
     JE @END_INPUT

     CMP AL, 8H
     JNE @NOT_BACKSPACE

     CMP CH, 0
     JNE @CHECK_REMOVE_MINUS

     CMP CL, 0
     JE @SKIP_BACKSPACE
     JMP @MOVE_BACK

     @CHECK_REMOVE_MINUS:

     CMP CH, 1
     JNE @CHECK_REMOVE_PLUS

     CMP CL, 1
     JE @REMOVE_PLUS_MINUS

     @CHECK_REMOVE_PLUS:

     CMP CL, 1
     JE @REMOVE_PLUS_MINUS
     JMP @MOVE_BACK

     @REMOVE_PLUS_MINUS:
       MOV AH, 2
       MOV DL, 20H
       INT 21H

       MOV DL, 8H
       INT 21H

       JMP @READ

     @MOVE_BACK:

     MOV AX, BX
     MOV BX, 10
     DIV BX
     MOV BX, AX

     MOV AH, 2
     MOV DL, 20H
     INT 21H

     MOV DL, 8H
     INT 21H

     XOR DX, DX
     DEC CL

     JMP @INPUT

     @NOT_BACKSPACE:

     INC CL

     CMP AL, 30H
     JL @ERROR

     CMP AL, 39H
     JG @ERROR

     AND AX, 000FH

     PUSH AX

     MOV AX, 10
     MUL BX
     MOV BX, AX

     POP AX

     ADD BX, AX
     JS @ERROR
   JMP @INPUT

   @ERROR:

   MOV AH, 2
   MOV DL, 7H
   INT 21H

   XOR CH, CH

   @CLEAR:
     MOV DL, 8H
     INT 21H

     MOV DL, 20H
     INT 21H

     MOV DL, 8H
     INT 21H
   LOOP @CLEAR

   JMP @READ

   @END_INPUT:

   CMP CH, 1
   JNE @EXIT
   NEG BX

   @EXIT:

   MOV AX, BX

   POP DX
   POP CX
   POP BX

   RET
INDEC ENDP

OUTDEC PROC
   PUSH BX
   PUSH CX
   PUSH DX

   CMP AX, 0
   JGE @START

   PUSH AX

   MOV AH, 2
   MOV DL, '-'
   INT 21H
   POP AX
   NEG AX

   @START:

   XOR CX, CX
   MOV BX, 10

   @OUTPUT:
     XOR DX, DX
     DIV BX
     PUSH DX
     INC CX
     OR AX, AX
   JNE @OUTPUT

   MOV AH, 2

   @DISPLAY:
     POP DX
     OR DL, 30H
     INT 21H
   LOOP @DISPLAY
   POP DX
   POP CX
   POP BX
   RET
OUTDEC ENDP

HLT


