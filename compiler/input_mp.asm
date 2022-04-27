ila 0 0
ilh 10 -1
ilh 30 12			// use to shift by 12byte
ilh 31 8			// use to shift by 8 byte
ilh 32 4 			// use to shift by 8 bytes
ilh 33 12			// use to shift by 8 bytes
shlqby 20 10 30 	// generate FFFFFFFF ins first word
lqd 5 4(0) 			// load matrix2[0] Column 1
and 15 5 20 		// reg 15 slot 1 has matrix[0][0]
lqd 6 5(0) 			// loading matrix2[1] row
and 26 6 20 		// loading matrix2[1][0] in reg 21
ilh 30 12
rotqby 26 26 30 	// moved matrix2[1][0] to 2nd word slot
xor 15 15 26 		// reg 15 will have elemnt for column 0 matrix2
lqd 7 6(0) 			// loading matrix2[2] row
and 27 7 20 		// loading matrix2[2][0] in reg 22
ilh 30 8
rotqby 27 27 30
xor 15 15 27 		// moved matrix2[2][0] to 3rd word slot
lqd 8 7(0)
and 28 8 20 		// loading matrix2[2][0] in reg 23
ilh 30 4
rotqby 28 28 30
xor 15 15 28 		// moved matrix2[3][0] to 4rd word slot
rotqby 26 5 32 		//Column 2
and 16 26 20 		// reg 16 will hold col2 of matrix2
rotqby 27 6 32 		// rotate lefy by 4
and 27 27 20 		// loading matrix2[1][0] in reg 21
ilh 30 12
rotqby 27 27 30
xor 16 16 27 		// storing matrix2[1][1] in reg 16 2nd posistion
rotqby 28 7 32 		// rotate left by 4
and 28 28 20 		// loading matrix2[2][0] shiftef right
ilh 30 8 			//
rotqby 28 28 30
xor 16 16 28 		// reg 16 will have elemnt for column 2 matrix2
rotqby 29 8 32 		// rotate lefy by 4
and 29 29 20 		// loading matrix2[1][0] in reg 21
ilh 30 4
rotqby 29 29 30
xor 16 16 29 		// reg 16 will have elemnt for column 2 matrix2
rotqby 26 5 31 		//Column 3
and 17 26 20 		// reg 16 will hold col2 of matrix2
rotqby 27 6 31 		// rotate lefy by 8
and 27 27 20 		// loading matrix2[1][0] in reg 21
ilh 30 12
rotqby 27 27 30
xor 17 17 27 		// storing matrix2[1][1] in reg 16 2nd posistion
rotqby 28 7 31		// rotate left by 8
and 28 28 20 		// loading matrix2[2][0] shiftef right
ilh 30 8 			//
rotqby 28 28 30
xor 17 17 28 		// reg 16 will have elemnt for column 1 matrix2
rotqby 29 8 31 		// rotate lefy by 8
and 29 29 20 		// loading matrix2[1][0] in reg 21
ilh 30 4
rotqby 29 29 30
xor 17 17 29 		// reg 17 will have elemnt for column 3 matrix2
rotqby 26 5 33 		//Column 4
and 18 26 20 		// reg 16 will hold col2 of matrix2
rotqby 27 6 33 		// rotate by 12
and 27 27 20 		// loading matrix2[1][0] in reg 21
ilh 30 12
rotqby 27 27 30
xor 18 18 27
rotqby 28 7 33 		// rotate left by 12
and 28 28 20 		// loading matrix2[2][0] shiftef right
ilh 30 8 			//
rotqby 28 28 30
xor 18 18 28
rotqby 29 8 33 		// rotate left by 4
and 29 29 20 		// loading matrix2[3][3]
ilh 30 4
rotqby 29 29 30
xor 18 18 29 		// reg 18 will have elements for column 4s matrix2
ila 0 4 			// i=4
ai 0 0 -1 			// i--;
lqd 1 0(0) 			// load maxtr1[i]
mpya 60 15 1 60 	// matrix1[i] x matrix2 column computes a(i)xb(i) a(i+1)xb(i+1) ...
mpya 61 16 1 61 	// matrix1[i] x matrix2 column
mpya 62 17 1 62 	// matrix1[i] x matrix2 column
mpya 63 18 1 63 	// matrix1[i] x matrix2 column
and 70 60 20 		// reg 70 maxtrix3[i][0]
a 81 81 70 			// adding extract aixbi to reg 81
shlqby 60 60 30 	// shift by a 4 bytes to bring int a(i+1)xb(i+1)
and 70 60 20
a 81 81 70
shlqby 60 60 30
and 70 60 20
a 81 81 70
shlqby 60 60 30
and 70 60 20
a 81 81 70 			// reg 81 will have the sum of the products for a cell
shlqby 60 60 30
and 71 61 20 		// reg 71 maxtrix3[i][1]
a 82 82 71
shlqby 61 61 30
and 71 61 20
a 82 82 71
shlqby 61 61 30
and 71 61 20
a 82 82 71
shlqby 61 61 30
and 71 61 20
a 82 82 71
shlqby 61 61 30
and 72 62 20 		// reg 72 maxtrix3[i][2]
a 83 83 72
shlqby 62 62 30
and 72 62 20
a 83 83 72
shlqby 62 62 30
and 72 62 20
a 83 83 72
shlqby 62 62 30
and 72 62 20
a 83 83 72
shlqby 62 62 30
and 73 63 20 		// reg 73 maxtrix3[i][3]
a 84 84 73
shlqby 63 63 30
and 73 63 20
a 84 84 73
shlqby 63 63 30
and 73 63 20
a 84 84 73
shlqby 63 63 30
and 73 63 20
a 84 84 73
rotqby 82 82 33 	// aliging reg to slot in quadword to indicated row
rotqby 83 83 31
rotqby 84 84 32
or 80 80 81 		// building the quad word to reg 80
or 80 80 82
or 80 80 83
or 80 80 84
stqd 80 10(0)
ilh 60 0 			// clearing register
ilh 61 0
ilh 62 0
ilh 63 0
ilh 70 0
ilh 71 0
ilh 72 0
ilh 73 0
ilh 80 0
ilh 81 0
ilh 82 0
ilh 83 0
ilh 84 0
brnz 0 -74
stop