ila 0 0
ilh 10 -1
ilh 30 12 // use to shift by 12byte
ilh 31 8 // use to shift by 8 byte
ilh 32 4 // use to shift by 8 bytes
ilh 33 12 // use to shift by 8 bytes
shlqby 20 10 30 // generate FFFFFFFF ins first word
lqd 1 0(0) // load maxtr1[1]
lqd 2 1(0) // load maxtr1[1]
lqd 3 2(0) // load maxtr1[2]
lqd 4 3(0) // load maxtr1[3]
lqd 5 4(0) // load matrix2[0] Column 1
and 15 5 20 // reg 15 slot 1 has matrix[0][0]
lqd 6 5(0) // loading matrix2[1] row
and 26 6 20 // loading matrix2[1][0] in reg 21
ilh 30 12
rotqby 26 26 30 // moved matrix2[1][0] to 2nd word slot
xor 15 15 26 // reg 15 will have elemnt for column 0 matrix2
lqd 7 6(0) // loading matrix2[2] row
and 27 7 20 // loading matrix2[2][0] in reg 22
ilh 30 8
rotqby 27 27 30
xor 15 15 27 // moved matrix2[2][0] to 3rd word slot
lqd 8 7(0)
and 28 8 20 // loading matrix2[2][0] in reg 23
ilh 30 4
rotqby 28 28 30
xor 15 15 28 // moved matrix2[3][0] to 4rd word slot
rotqby 26 5 32 //Column 2
and 16 26 20 // reg 16 will hold col2 of matrix2
rotqby 27 6 32 // rotate lefy by 4
and 27 27 20 // loading matrix2[1][0] in reg 21
ilh 30 12
rotqby 27 27 30
xor 16 16 27 // storing matrix2[1][1] in reg 16 2nd posistion
rotqby 28 7 32 // rotate left by 4
and 28 28 20 // loading matrix2[2][0] shiftef right
ilh 30 8 //
rotqby 28 28 30
xor 16 16 28 // reg 16 will have elemnt for column 2 matrix2
rotqby 29 8 32 // rotate lefy by 4
and 29 29 20 // loading matrix2[1][0] in reg 21
ilh 30 4
rotqby 29 29 30
xor 16 16 29 / reg 16 will have elemnt for column 2 matrix2
rotqby 26 5 31 //Column 3
and 17 26 20 // reg 16 will hold col2 of matrix2
rotqby 27 6 31 // rotate lefy by 8
and 27 27 20 // loading matrix2[1][0] in reg 21
ilh 30 12
rotqby 27 27 30
xor 17 17 27 // storing matrix2[1][1] in reg 16 2nd posistion
rotqby 28 7 31// rotate left by 8
and 28 28 20 // loading matrix2[2][0] shiftef right
ilh 30 8 //
rotqby 28 28 30
xor 17 17 28 // reg 16 will have elemnt for column 1 matrix2
rotqby 29 8 31 // rotate lefy by 8
and 29 29 20 // loading matrix2[1][0] in reg 21
ilh 30 4
rotqby 29 29 30
xor 17 17 29 // reg 17 will have elemnt for column 3 matrix2
rotqby 26 5 33 // //Column 4
and 18 26 20 // reg 16 will hold col2 of matrix2
rotqby 27 6 33 // rotate by 12
and 27 27 20 // loading matrix2[1][0] in reg 21
ilh 30 12
rotqby 27 27 30
xor 18 18 27
rotqby 28 7 33 // rotate left by 12
and 28 28 20 // loading matrix2[2][0] shiftef right
ilh 30 8 //
rotqby 28 28 30
xor 18 18 28
rotqby 29 8 33 // rotate left by 4
and 29 29 20 // loading matrix2[3][3]
ilh 30 4
rotqby 29 29 30
xor 18 18 29 // reg 18 will have elements for column 4s matrix2
ilh 69 4
mpya 60 15 1 60 // matrix1[0] x matrix2 column
mpya 61 16 1 61 // matrix1[0] x matrix2 column
mpya 62 17 1 62 // matrix1[0] x matrix2 column
mpya 63 18 1 63 // matrix1[0] x matrix2 column
and 70 60 20
a 81 81 70
shlqby 60 60 30
and 72 61 20
a 82 82 72
shlqby 61 61 30
ahi 69 69 -1
brnz 69 84
lnop
ilh 26 4
lnop
and 74 61 20
a 83 83 74
shlqby 61 61 30
ahi 26 26 -1
brnz 26 95
lnop
ilh 27 4
lnop
and 74 62 20
a 84 84 74
shlqby 62 62 30
ahi 27 27 -1
brnz 27 103
lnop
ilh 28 4
lnop
and 76 63 20
a 85 85 76
shlqby 63 63 30
ahi 28 28 -1
brnz 28 109