; taken from the CHAT

section .data
    player1_rating dd 1600  ; Initial rating for player 1
    player2_rating dd 1400  ; Initial rating for player 2
    k_factor dd 32          ; K-factor for Elo rating system

section .text
    global _start

_start:
    ; Compute expected scores
    fld dword [player1_rating]
    fld dword [player2_rating]
    fsub                ; Calculate rating difference (player1 - player2)
    fild dword [k_factor]
    fdiv                ; Divide by K-factor
    fld1                ; Load 1.0 onto the FPU stack
    fadd                ; Add 1.0 to the result
    fild dword 400      ; Load constant 400 onto the FPU stack
    fdiv                ; Divide by 400
    fyl2x               ; Compute the natural logarithm
    fld1                ; Load 1.0 onto the FPU stack
    fdiv                ; Divide by result
    fstp dword [expected_score_player1]  ; Store expected score for player 1

    fld dword [player2_rating]
    fld dword [player1_rating]
    fsub
    fild dword [k_factor]
    fdiv
    fld1
    fadd
    fild dword 400
    fdiv
    fyl2x
    fld1
    fdiv
    fstp dword [expected_score_player2]  ; Store expected score for player 2

    ; Update ratings based on actual scores
    mov eax, 1
    mov ebx, 0           ; Example: Player 1 wins, change this based on actual results
    call update_ratings  ; Call the update_ratings function

    ; Exit the program
    mov eax, 1           ; System call number for exit
    xor ebx, ebx         ; Exit code 0
    int 0x80             ; Make system call

update_ratings:
    ; Calculate rating changes
    fld dword [actual_score]         ; Load actual score onto FPU stack
    fld dword [expected_score_player1]  ; Load expected score for player 1
    fsub                             ; Subtract expected score from actual score
    fild dword [k_factor]            ; Load K-factor
    fmul                             ; Multiply the result by K-factor
    fxch                             ; Exchange the top two FPU stack elements
    fstp dword [rating_change_player1]  ; Store rating change for player 1

    fld dword [actual_score]
    fld dword [expected_score_player2]
    fsub
    fild dword [k_factor]
    fmul
    fxch
    fstp dword [rating_change_player2]  ; Store rating change for player 2

    ; Update ratings
    fld dword [player1_rating]
    fld dword [rating_change_player1]
    fadd
    fstp dword [player1_rating]  ; Update player 1's rating

    fld dword [player2_rating]
    fld dword [rating_change_player2]
    fadd
    fstp dword [player2_rating]  ; Update player 2's rating

    ret

section .bss
    expected_score_player1 resd 1
    expected_score_player2 resd 1
    actual_score resd 1
    rating_change_player1 resd 1
    rating_change_player2 resd 1