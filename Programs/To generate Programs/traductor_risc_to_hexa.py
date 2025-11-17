instr_input = input("¿Qué instrucción quieres codificar? (Por ejemplo: jal): ")

instr_info = {
    # FMT_R
    "add":  {"type": "R", "opcode": "0110011", "funct3": "000", "funct7": "0000000"},
    "sub":  {"type": "R", "opcode": "0110011", "funct3": "000", "funct7": "0100000"},
    "xor":  {"type": "R", "opcode": "0110011", "funct3": "100", "funct7": "0000000"},
    "or":   {"type": "R", "opcode": "0110011", "funct3": "110", "funct7": "0000000"},
    "and":  {"type": "R", "opcode": "0110011", "funct3": "111", "funct7": "0000000"},
    "sll":  {"type": "R", "opcode": "0110011", "funct3": "001", "funct7": "0000000"},
    "srl":  {"type": "R", "opcode": "0110011", "funct3": "101", "funct7": "0000000"},
    "sra":  {"type": "R", "opcode": "0110011", "funct3": "101", "funct7": "0100000"},
    "slt":  {"type": "R", "opcode": "0110011", "funct3": "010", "funct7": "0000000"},

    # FMT_Iimm
    "addi": {"type": "I", "opcode": "0010011", "funct3": "000"},
    "xori": {"type": "I", "opcode": "0010011", "funct3": "100"},
    "ori":  {"type": "I", "opcode": "0010011", "funct3": "110"},
    "andi": {"type": "I", "opcode": "0010011", "funct3": "111"},
    "slli": {"type": "I", "opcode": "0010011", "funct3": "001", "funct7": "0000000"},
    "srli": {"type": "I", "opcode": "0010011", "funct3": "101", "funct7": "0000000"},
    "srai": {"type": "I", "opcode": "0010011", "funct3": "101", "funct7": "0100000"},
    "slti": {"type": "I", "opcode": "0010011", "funct3": "010"},

    # FMT_Iload
    "lb":   {"type": "I", "opcode": "0000011", "funct3": "000"},
    "lw":   {"type": "I", "opcode": "0000011", "funct3": "010"},
    "lbu":  {"type": "I", "opcode": "0000011", "funct3": "100"},

    # FMT_S
    "sb":   {"type": "S", "opcode": "0100011", "funct3": "000"},
    "sw":   {"type": "S", "opcode": "0100011", "funct3": "010"},

    # FMT_B
    "beq":  {"type": "B", "opcode": "1100011", "funct3": "000"},
    "bne":  {"type": "B", "opcode": "1100011", "funct3": "001"},
    "blt":  {"type": "B", "opcode": "1100011", "funct3": "100"},
    "bge":  {"type": "B", "opcode": "1100011", "funct3": "101"},
    "bltu": {"type": "B", "opcode": "1100011", "funct3": "110"},
    "bgeu": {"type": "B", "opcode": "1100011", "funct3": "111"},

    # FMT_jal
    "jal":  {"type": "J", "opcode": "1101111"},

    # FMT_jalr
    "jalr": {"type": "I", "opcode": "1100111", "funct3": "000"}
}

# Validar que la instrucción exista
if instr_input not in instr_info:
    print("Instrucción no reconocida.")

else:
    info = instr_info[instr_input]
    tipo = info["type"]
    opcode = info["opcode"]
    funct3 = info.get("funct3")  # get() evita error si no existe
    funct7 = info.get("funct7")

    print(f"Tipo: {tipo}")
    print(f"Opcode: {opcode}")
    if funct3 is not None:
        print(f"Funct3: {funct3}")
    if funct7 is not None:
        print(f"Funct7: {funct7}")

#####################################################################################################################################################################
#####################################################################################################################################################################
#####################################################################################################################################################################

if tipo == "R":
    rd = int(input("rd (ej: 1 para x1): "))
    rs1 = int(input("rs1 (ej: 2 para x2): "))
    rs2 = int(input("rs2 (ej: 3 para x3): "))

    # Convertir a binario de 5 bits
    rd_bin  = format(rd,  '05b')
    rs1_bin = format(rs1, '05b')
    rs2_bin = format(rs2, '05b')
    print("rd_bin :", rd_bin)
    print("rs1_bin:", rs1_bin)
    print("rs2_bin:", rs2_bin)

    # Construir instrucción binaria
    binary_instr = funct7 + rs2_bin + rs1_bin + funct3 + rd_bin + opcode

elif tipo == "I":
    rd  = int(input("rd  (ej: 1 para x1): "))
    rs1 = int(input("rs1 (ej: 2 para x2): "))
    imm = int(input("imm (decimal entre -2048 y 2047): "))

    # Convertir a binario
    rd_bin  = format(rd,  '05b')
    rs1_bin = format(rs1, '05b')

    # Inmediato con signo (12 bits)
    if imm < 0:
        imm_bin = format((1 << 12) + imm, '012b')  # complemento a 2
    else:
        imm_bin = format(imm, '012b')

    print("rd_bin  :", rd_bin)
    print("rs1_bin :", rs1_bin)
    print("imm_bin :", imm_bin)

    # Construir instrucción binaria
    binary_instr = imm_bin + rs1_bin + funct3 + rd_bin + opcode
    
elif tipo == "S":
    rs1 = int(input("rs1 (ej: 1 para x1): "))
    imm = int(input("imm (decimal entre -2048 y 2047): "))
    rs2 = int(input("rs2 (ej: 2 para x2): "))

    # Inmediato con signo (12 bits)
    if imm < 0:
        imm_bin = format((1 << 12) + imm, '012b')  # complemento a 2
    else:
        imm_bin = format(imm, '012b')

    imm_11_5 = imm_bin[:7]   # bits [11:5]
    imm_4_0  = imm_bin[7:]   # bits [4:0]

    rs1_bin = format(rs1, '05b')
    rs2_bin = format(rs2, '05b')

    print("imm_11_5:", imm_11_5)
    print("rs2_bin :", rs2_bin)
    print("rs1_bin :", rs1_bin)
    print("imm_4_0 :", imm_4_0)

    # Construir instrucción binaria
    binary_instr = imm_11_5 + rs2_bin + rs1_bin + funct3 + imm_4_0 + opcode

#####################################################################################################################################################################
#####################################################################################################################################################################
#####################################################################################################################################################################

elif tipo == "B": #Comprobado bne y beq con hexa positivo
    rs1 = int(input("rs1 (ej: 1 para x1): "))
    rs2 = int(input("rs2 (ej: 2 para x2): "))
    imm_hex = input("imm (hex entre -0x800 y 0x7FF, ej: 0xFF0 o -0x10): ")

    imm = int(imm_hex, 16) if not imm_hex.startswith("-") else -int(imm_hex[3:], 16)
    if imm < -2048 or imm > 2047:
        print("Error: imm fuera de rango (-2048 a 2047)")
        exit()

    imm_bin = format((imm + (1 << 12)) if imm < 0 else imm, '012b')

    # Reordenar bits para tipo B
    imm_12   = imm_bin[0]       # bit 12
    imm_10_5 = imm_bin[1:7]     # bits [10:5]
    imm_4_1  = imm_bin[7:11]    # bits [4:1]
    imm_11   = imm_bin[11]      # bit 11

    rs1_bin = format(rs1, '05b')
    rs2_bin = format(rs2, '05b')

    print("imm_12  :", imm_12)
    print("imm_10_5:", imm_10_5)
    print("rs2_bin :", rs2_bin)
    print("rs1_bin :", rs1_bin)
    print("imm_4_1 :", imm_4_1)
    print("imm_11  :", imm_11)

    binary_instr = imm_12 + imm_10_5 + rs2_bin + rs1_bin + funct3 + imm_4_1 + imm_11 + opcode

elif tipo == "J":
    rd = int(input("rd (ej: 1 para x1): "))
    imm_hex = input("imm (hex entre -0x800 y 0x7FF, ej: 0x400 o -0x10): ")

    imm = int(imm_hex, 16) if not imm_hex.startswith("-") else -int(imm_hex[3:], 16)
    if imm < -2048 or imm > 2047:
        print("Error: imm fuera de rango (-2048 a 2047)")
        exit()

    imm_bin = format((imm + (1 << 21)) if imm < 0 else imm, '021b')

    # Reordenar para tipo J
    imm_20     = imm_bin[0]        # bit 20
    imm_10_1   = imm_bin[10:20]    # bits [10:1]
    imm_11     = imm_bin[9]        # bit 11
    imm_19_12  = imm_bin[1:9]      # bits [19:12]

    rd_bin = format(rd, '05b')

    print("imm_20    :", imm_20)
    print("imm_10_1  :", imm_10_1)
    print("imm_11    :", imm_11)
    print("imm_19_12 :", imm_19_12)
    print("rd_bin    :", rd_bin)

    binary_instr = imm_20 + imm_10_1 + imm_11 + imm_19_12 + rd_bin + opcode
    

#####################################################################################################################################################################
#####################################################################################################################################################################
#####################################################################################################################################################################
       
hex_instr = hex(int(binary_instr, 2))[2:].zfill(8).upper()  
print(f"Instrucción codificada (hex): 0x{hex_instr}")
