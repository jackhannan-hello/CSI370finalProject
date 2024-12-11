
_printString Proto
_getPlayerDecission PROTO
_getInt PROTO
_shuffleDeck PROTO
_createTablePlayer PROTO
_printResult PROTO
_createTableDealer PROTO
_getGameDecission PROTO

.DATA
align 16
playerMoney QWORD 0.0		;player money
wagerAMT QWORD 0.0			;bet amount
deck QWORD 2,3,4,5,6,7,8,9,10,"J","Q","K","A"
deckSize QWORD 13
deckPosition Qword 4
deals QWORD 0				;games delt without shuffle
playerSize QWORD 2
dealerSize QWORD 2
playerScore QWORD 0
dealerScore QWORD 0
won QWORD 0
lost QWORD 0
player QWORD 0,0,0,0,0
dealer QWORD 0,0,0,0,0

promtString BYTE "Enter how money you want to have(Only DOLLARS): ", 0
wagerMessage BYTE "Enter how much you want bet on each hand(Only DOLLARS): ", 0
loserMessage BYTE "You ran out of money. ", 0
blackjackMessage BYTE "YOU WIN you got BLACKJACK, you WIN $", 0
bustMessage BYTE "YOU BUSTED and LOST, went over 21, you lose $", 0
beatDealerMeassage BYTE "You were closer to 21 than the dealer so YOU WIN $", 0
dealerBustMessage BYTE "The Dealer Busted so YOU WIN $", 0
lostMessage BYTE "The dealer was closer to 21 than you so you lost $", 0
pushMessage BYTE "You had the same score as the dealer so its a push.", 0
goodbyeMessage BYTE "THANK YOU for playing have a good day.", 0

.CODE
_asmMain PROC
push rbp
sub rsp, 20h
lea rbp, [rsp + 20h]
	
lea rcx, promtString		; pass char* to print
call _printString
call _getInt			; get and store amountNeeded
mov playerMoney, rax

lea rcx, promtString		; pass char* to print
call _printString
call _getInt			; get and store amountNeeded
mov wagerAMT, rax

	
newGame:
lea rcx, deck
mov rdx, deckSize
call _shuffleDeck

mov playerSize, 2
mov dealerSize, 2
mov deckPosition, 4

lea rcx, deck
call _deal

lea rcx, player
mov rdx, playerSize
lea r8, dealer
mov r9, dealerSize
call _createTablePlayer


lea rcx, deck
lea rdx, player
lea r8, dealer
call _playerTurn

cmp lost, 1
je askNewGame
	
lea rcx, deck
lea rdx, player
lea r8, dealer
call _dealerTurns

cmp won, 1
je askNewGame

call _gameResult

askNewGame:
mov rcx, playerMoney
call _getGameDecission
call _getInt
cmp rax, 1
je newGame

lea rcx, goodbyeMessage
call _printString

lea rsp, [rbp]
pop rbp
ret
_asmMain ENDP

_gameResult PROC
push rbp
push rbx
sub rsp, 20h
lea rbp, [rsp + 20h]

cmp dealerScore, 21
ja dealerBust
mov rax, dealerScore
cmp playerScore, rax
ja winner
cmp playerScore, rax
jb loser

lea rcx, pushMessage
mov rdx, 0
jmp done

loser:
lea rcx, lostMessage
mov rax, wagerAMT
sub playerMoney, rax
mov rdx, wagerAMT
call _printResult
jmp done

winner:
lea rcx, beatDealerMeassage
mov rax, wagerAMT
add playerMoney, rax
mov rdx, wagerAMT
call _printResult
jmp done

dealerBust:
lea rcx, dealerBustMessage
mov rax, wagerAMT
add playerMoney, rax
mov rdx, wagerAMT
call _printResult
	

done:
lea rsp, [rbp]
pop rbx
pop rbp
ret 
_gameResult ENDP

_playerTurn PROC
push rbp
push rbx
sub rsp, 20h
lea rbp, [rsp + 20h]


lea rcx, player
call _checkPlayerScore
cmp playerScore, 21
jne noBlackjack
mov rax, wagerAMT
mov rbx, 2
mul bx
add playerMoney, rax
lea rcx, blackjackMessage
mov rdx, rax
call _printResult
mov won, 1
jmp done

noBlackjack:

rehit:
mov rcx, wagerAMT
mov rdx, playerMoney
call _getPlayerDecission
call _getInt
cmp rax, 0
je done
cmp rax, 2
je double

lea rcx, player
lea r10, deck
mov r9, deckPosition
mov r13, playerSize
mov rax, [r10 + r9*8]
mov [rcx + r13*8], rax
inc deckPosition
inc playerSize
	
mov rdx, playerSize
lea r8, dealer
mov r9, dealerSize
call _createTablePlayer

lea rcx, player
call _checkPlayerScore
cmp playerScore, 21
jnae rehit
lea rcx, bustMessage
mov rax, wagerAMT
sub playerMoney, rax
mov rdx, WagerAMT
call _printResult
mov lost, 1
jmp done
	
double:
lea rcx, player
lea r10, deck
mov r9, deckPosition
mov r13, playerSize
mov rax, [r10 + r9*8]
mov [rcx + r13*8], rax
inc deckPosition
inc playerSize
	
mov rdx, playerSize
lea r8, dealer
mov r9, dealerSize
call _createTablePlayer
	
lea rcx, player
call _checkPlayerScore
cmp playerScore, 21
jbe done
lea rcx, bustMessage
mov rax, wagerAMT
mov rbx, 2
mul bx
sub playerMoney, rax
mov rdx, wagerAMT
call _printResult
mov lost, 1

done:
lea rsp, [rbp]
pop rbx
pop rbp
ret 
_playerTurn ENDP

_dealerTurns PROC
push rbp
push rbx
sub rsp, 20h
lea rbp, [rsp + 20h]

lea rcx, dealer
call _checkDealerScore
lea rcx, player
mov rdx, playerSize
lea r8, dealer
mov r9, dealerSize
call _createTableDealer
cmp dealerScore, 17
jl done

mov r10, rcx
mov r11, rdx
mov r13, 2

rehit:

lea rcx, dealer
lea r10, deck
mov r9, deckPosition
mov r13, deckSize
mov rax, [r10 + r9*8]
mov [rcx + r13*8], rax
inc deckPosition
inc dealerSize
	
lea rcx, player
mov rdx, playerSize
lea r8, dealer
mov r9, dealerSize
call _createTableDealer

lea rcx, dealer
call _checkDealerScore
cmp dealerScore, 17
jl rehit

done:
lea rsp, [rbp]
pop rbx
pop rbp
ret 
_dealerTurns ENDP

_checkPlayerScore PROC
push rbp
push rbx
sub rsp, 20h
lea rbp, [rsp + 20h]

mov playerScore, 0
mov rbx, 0	
sum:		
mov rax, [rcx + rbx*8]
cmp rax, 10
jle num
cmp rax, 65
je ace
add playerScore, 10
jmp done

ace:
mov r12, playerScore
add r12, 11
cmp r12, 21
jle good
add playerScore, 1
jmp done
good:
add playerScore, 11
jmp done

num:
add playerScore, rax
done:
inc rbx
cmp playerSize, rbx
ja sum

lea rsp, [rbp]
pop rbx
pop rbp
ret 
_checkPlayerScore ENDP

_checkDealerScore PROC
push rbp
push rbx
sub rsp, 20h
lea rbp, [rsp + 20h]
mov dealerScore, 0
mov rbx, 0
	
sum:		
mov rax, [rcx + rbx*8]
cmp rax, 10
jle num
cmp rax, 65
je ace
add dealerScore, 10
jmp done

ace:
mov r12, dealerScore
add r12, 11
cmp r12, 21
jle good
add dealerScore, 1
jmp done
good:
add dealerScore, 11
jmp done

num:
add dealerScore, rax
done:
inc rbx
cmp dealerSize, rbx
ja sum

lea rsp, [rbp]
pop rbx
pop rbp
ret 
_checkDealerScore ENDP

_deal PROC
push rbp
push rbx
sub rsp, 20h
lea rbp, [rsp + 20h]
lea r8, player
lea r9, dealer
mov rax, [rcx]
mov [r8], rax

mov rax, [rcx + 8]
mov [r9], rax

mov rax, [rcx + 16]
mov [r8 + 8], rax

mov rax, [rcx + 24]
mov [r9 + 8], rax

lea rsp, [rbp]
pop rbx
pop rbp
ret 
_deal ENDP

END