ila 0 0
lqa 3 16
ila 4 128
lqa 4 20
ilh 8 -1
ilh 50 7
xor 8 8 50
lqa 5 24
ilh 9 -1
lnop
lqd 7 0(0)
ai 1 1 -1
shlqbi 11 7 8
ai 0 0 16
shlqbyi 11 7 8
and 13 7 9
shlqbyi 12 7 12
and 14 10 9
rotqmbyi 17 13 -4
and 15 11 9
rotqmbyi 18 13 -8
and 16 12 9
rotqmbyi 19 13 -12
or 13 13 17
rotqmbyi 20 14 -4
or 13 13 18
rotqmbyi 21 14 -8
or 13 13 19
rotqmbyi 22 14 -12
or 14 14 20
rotqmbyi 23 15 -4
or 14 14 21
rotqmbyi 24 15 -8
or 14 14 22
rotqmbyi 25 15 -12
or 15 15 23
rotqmbyi 26 16 -4
or 15 15 24
rotqmbyi 27 16 -8
or 15 15 25
rotqmbyi 28 16 -12
or 16 16 26
il 29 0
or 16 16 27
or 16 16 28
mpya 29 3 13 29
mpya 29 4 14 29
mpya 29 5 15 29
mpya 29 6 16 29
stqd 29 0(2)
brnz 1 -41
ai 2 2 16
stop