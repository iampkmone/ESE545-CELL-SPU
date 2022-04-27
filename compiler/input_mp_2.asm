ila 0 0
ilh 10 -1
ilh 30 12 // use to shift by 12byte
ilh 31 8 // use to shift by 8 byte
ilh 32 4 // use to shift by 8 bytes
shlqby 20 10 30 // generate FFFFFFFF ins first word
lqd 1 0(0) // load maxtr1[0]
lqd 2 1(0) // load maxtr1[1]
lqd 3 2(0) // load maxtr1[2]
lqd 4 3(0) // load maxtr1[3]
lqd 5 4(0) // load matrix2[0]
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
rotqby 29 7 32 // rotate lefy by 4
and 29 29 20 // loading matrix2[1][0] in reg 21
ilh 30 4
rotqby 29 29 30
xor 16 16 29 / reg 16 will have elemnt for column 2 matrix2
rotqby 26 26 32 //Column 3
and 17 26 20 // reg 16 will hold col2 of matrix2
rotqby 27 27 33 // rotate lefy by 8
and 27 27 20 // loading matrix2[1][0] in reg 21
ilh 30 12
rotqby 27 27 31
xor 17 17 27 // storing matrix2[1][1] in reg 16 2nd posistion
rotqby 28 7 31// rotate left by 8
and 28 28 20 // loading matrix2[2][0] shiftef right
ilh 30 8 //
rotqby 28 28 31
xor 17 17 28 // reg 16 will have elemnt for column 1 matrix2
rotqby 29 7 31 // rotate lefy by 8
and 29 29 20 // loading matrix2[1][0] in reg 21
ilh 30 4
rotqby 29 29 30
xor 17 17 29 // reg 17 will have elemnt for column 3 matrix2
rotqby 26 5 30 // //Column 4
and 18 26 20 // reg 16 will hold col2 of matrix2
rotqby 27 6 30 // rotate lefy by 12
and 27 27 20 // loading matrix2[1][0] in reg 21
ilh 30 12
rotqby 27 27 30
xor 18 18 27
rotqby 28 7 30 // rotate left by 12
and 28 28 20 // loading matrix2[2][0] shiftef right
ilh 30 8 //
rotqby 28 28 30
xor 18 18 28
rotqby 29 7 30 // rotate left by 4
and 29 29 20 // loading matrix2[3][3]
ilh 30 4
rotqby 29 29 30
xor 18 18 29 // reg 18 will have elements for column 4s matrix2
ilh 10 3
ila 0 10
lqd 2 0(0) // load maxtr1[1]
mpya 60 15 0 60 // matrix1[0] x matrix2 column
mpya 61 16 0 61 // matrix1[0] x matrix2 column
mpya 62 17 0 62 // matrix1[0] x matrix2 column
mpya 63 18 0 63 // matrix1[0] x matrix2 column
sfi 10 10 1
brnz 10 81