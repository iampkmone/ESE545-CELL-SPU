import sys
class Assembler:
    def __init__(self,ins_list_name,input_file,output_file) -> None:
        self.ins_list_name =  ins_list_name
        self.ins_opcode_mapping = dict()
        self.opcode_ins_mapping = dict()
        self.output_file = output_file
        self.input_file =  input_file
        self.load_mapping()


    def load_mapping(self):

        with open(self.ins_list_name,'r') as ins_lst:
            for line in ins_lst.readlines():
                # #print(line)
                ins,opcode =  line.split("\t")
                memonic = ins.split(" ")[0]
                opcode = opcode.strip()
                self.ins_opcode_mapping[memonic]=opcode
                if "rt, ra, rb" in ins:
                    self.opcode_ins_mapping[opcode]=[0,ins]
                elif "rt, ra, rb, rc" in ins:
                    self.opcode_ins_mapping[opcode]=[1,ins]
                elif "rt, ra, imm7" in ins:
                    self.opcode_ins_mapping[opcode]=[2,ins]
                elif "rt, ra, imm8" in ins:
                    self.opcode_ins_mapping[opcode]=[3,ins]
                elif "rt, ra, imm10" in ins or "rt, imm10(ra)" in ins :
                    self.opcode_ins_mapping[opcode]=[4,ins]
                elif "rt, imm16" in ins or "imm16" in ins :
                    self.opcode_ins_mapping[opcode]=[5,ins]
                elif "rt, imm18" in ins:
                    self.opcode_ins_mapping[opcode]=[6,ins]
                else:
                    if "nop" in ins:
                        self.opcode_ins_mapping[opcode]=[7,ins]
                    elif "stop" in ins:
                        self.opcode_ins_mapping[opcode]=[7,ins]

                # #print(ins,opcode)
        # #print(self.opcode_ins_mapping)
        # #print(self.ins_opcode_mapping)


    def parse_input(self):
        with open(self.input_file,'r') as ins_lst, open(self.output_file,'w') as object:
            for line in ins_lst.readlines():
                line = line.strip()
                ins = line.split(" ")
                memonic = ins[0]
                #print(memonic)
                opcode = self.ins_opcode_mapping[memonic]
                #print(opcode)
                format = self.opcode_ins_mapping[opcode]
                #print("format ",format)
                binary = self.compute(format,opcode,ins)
                object.write(binary+"\n")


    def compute(self,format,opcode,ins):
        ins_binary = "".zfill(32)
        #print(ins_binary,len(ins_binary))
        #print("ins {}".format(ins))
        if format[0] == 0:
            # opcode rt ra rb
            # op[0-10]rb[11-17]ra[18-24]rt[25-31]
            rt = bin(int(ins[1])).replace("0b","")
            ra = bin(int(ins[2])).replace("0b","")
            rb = bin(int(ins[3])).replace("0b","")
            #print(rt,ra,rb)
            rt = self.fill(rt,7)
            ra = self.fill(ra,7)
            rb = self.fill(rb,7)
            #print(rt,ra,rb)
            ins_binary = opcode+rb+ra+rt

        elif format[0] == 1:
            # opcode rt,ra,rb,rc
            # op[0-3]rt[4-10]rb[11-17]ra[18-24]rc[25-31]
            rt = bin(int(ins[1])).replace("0b","")
            ra = bin(int(ins[2])).replace("0b","")
            rb = bin(int(ins[3])).replace("0b","")
            rc = bin(int(ins[4])).replace("0b","")
            #print(rt,ra,rb)
            rt = self.fill(rt,7)
            ra = self.fill(ra,7)
            rb = self.fill(rb,7)
            rc = self.fill(rc,7)
            #print(rt,ra,rb,rc)
            ins_binary = opcode+rt+rb+ra+rc
        elif format[0] == 2:
            # opcode rt,ra,imm7
            # op[0-10]imm7[11-17]ra[18-24]rt[25-31]

            rt = bin(int(ins[1])).replace("0b","")
            ra = bin(int(ins[2])).replace("0b","")
            imm7 = bin(int(ins[3])).replace("0b","")

            rt = self.fill(rt,7)
            ra = self.fill(ra,7)
            imm7 = self.fill(imm7,7)
            ins_binary = opcode+rt+ra+imm7

        elif format[0] == 3:
            # opcode rt,ra,imm8
            # op[0-9]imm8[10-17]ra[18-24]rt[25-31]

            rt = bin(int(ins[1])).replace("0b","")
            ra = bin(int(ins[2])).replace("0b","")
            imm8 = bin(int(ins[3])).replace("0b","")
            rt = self.fill(rt,7)
            ra = self.fill(ra,7)
            imm8 = self.fill(imm8,8)
            ins_binary = opcode+rt+ra+imm8


        elif format[0] == 4:
            # opcode rt,ra,value
            # op[0-7]imm10[8-17]ra[18-24]rt[25-31]
            rt = bin(int(ins[1])).replace("0b","")
            rt = self.fill(rt,7)
            if '(' in format[1]:
                # opcode rt, symbol(ra)
                imm10 = ins[2].split('(')[0]
                ra = ins[2].split('(')[1][:-1]
            else:
                # opcode rt,ra,value
                imm10 = ins[3]
                ra = ins[2]

            #print(imm10,ra)
            imm10 = bin(int(imm10)).replace("0b","")
            imm10 = self.fill(imm10,10)

            ra = bin(int(ra)).replace("0b","")
            ra = self.fill(ra,7)
            ins_binary = opcode+imm10+ra+rt
        elif format[0] == 5:

            if len(ins)==3:
                rt = bin(int(ins[1])).replace("0b","")
                imm16 = bin(int(ins[2])).replace("0b","")
            else:
                rt="0"
                imm16 = bin(int(ins[1])).replace("0b","")
            rt = self.fill(rt,7)
            imm16 = self.fill(imm16,16)

            ins_binary = opcode+imm16+rt
        elif format[0] == 6:
            # opcode rt,value
            # op[0-8]imm16[9-24]rt[25-31]
            rt = bin(int(ins[1])).replace("0b","")
            rt = self.fill(rt,7)

            imm18 = bin(int(ins[2])).replace("0b","")
            imm18 = self.fill(imm18,18)
            ins_binary = opcode+imm18+rt
        else:
            ins_binary = opcode + self.fill("",32-len(opcode))



        #print(ins_binary,len(ins_binary))
        return ins_binary
    def fill(self,seq,width):
        neg = False
        if len(seq) > 0 and seq[0]=='-':
            neg = True
        seq =  seq.replace("-","")
        wide_seq = seq.zfill(width)

        if neg:
            wide_seq=str(1)+wide_seq[1:]
        return wide_seq



if len(sys.argv) ==1:
    print("Please mention the asm file: python assembler <input>.asm -o <out>")
    sys.exit(0)
input_file_name = sys.argv[1]
output_file_name = "out"
if len(sys.argv) > 3 and sys.argv[2] =='-o':
    output_file_name = sys.argv[3]

asm = Assembler(ins_list_name="instructions.lst", input_file=input_file_name,
                output_file=output_file_name)


asm.parse_input()