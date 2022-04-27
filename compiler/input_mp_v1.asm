ila 0 0
lqd 5 4(0)
ilhu 10 65535
roti 11 10 16
or 10 10 11
ilh 30 31
shlqby 20 10 30
shlqby 20 20 30
shlqby 20 20 30
ilh 30 3
lqd 1 0(0)
shlqby 20 20 30 // generate F ins first word
and 15 5 20 // reg 15 slot 1 has matrix[0][0]
lqd 6 5(0) // loading matrix2[1] row
and 21 6 20 // loading matrix2[1][0] in reg 21
ilh 30 12
rotqby 21 21 30 // moved matrix2[1][0] to 2nd word slot
xor 15 15 21 // reg 15 will have elemnt for column 0 matrix2
lqd 7 6(0) // loading matrix2[2] row
and 22 7 20 // loading matrix2[2][0] in reg 22
ilh 30 8
rotqby 22 22 30
xor 15 15 22 // moved matrix2[2][0] to 3rd word slot
lqd 8 7(0)
and 23 8 20 // loading matrix2[2][0] in reg 23
ilh 30 8
rotqby 23 23 30
xor 15 15 23 // moved matrix2[3][0] to 4rd word slot
ilh 60 0 // result[0][0]
ilh 61 -1 // load all ones
ilh 90 0 // result[0][0]
mpya 60 15 1 60 // matrix1[0] x matrix2 column
and 90 60 20 // extract first word
a 80 80 90 //result[0][0]
shlqby 60 60 30 // shift left by 4 byte
shlqby 61 61 30 // shift left by 4 byte
brnz 11 33 // adds all the word



mpya 64 15 2 64 // matrix1[0] x matrix2 column
mpya 65 16 2 65 // matrix1[0] x matrix2 column
mpya 66 17 2 66 // matrix1[0] x matrix2 column
mpya 67 18 2 67 // matrix1[0] x matrix2 column
mpya 68 15 3 68 // matrix1[0] x matrix2 column
mpya 69 16 3 69 // matrix1[0] x matrix2 column
mpya 70 17 3 70 // matrix1[0] x matrix2 column
mpya 71 18 3 71 // matrix1[0] x matrix2 column
mpya 72 15 4 72 // matrix1[0] x matrix2 column
mpya 72 16 4 73 // matrix1[0] x matrix2 column
mpya 74 17 4 74 // matrix1[0] x matrix2 column
mpya 75 18 4 75 // matrix1[0] x matrix2 column