# Enable pyserial extensions
import os
import pyftdi.serialext

count = 0
brate = 230400
url = 'ftdi://ftdi:232:AB0JNVIE/1'
port = pyftdi.serialext.serial_for_url(url,
                                    baudrate=brate,
                                    bytesize=8,
                                    stopbits=1,
                                    parity='N',
                                    xonxoff=False,
                                    rtscts=False)


def cls():
    os.system('cls' if os.name == 'nt' else 'clear')


def main_menu():
    cls()
    print("============ MAIN MENU ============")
    print("||  Choose generator properties: ||")
    print("||  (1) - waveform               ||")
    print("||  (2) - amplitude              ||")
    print("||  (3) - frequency              ||")
    print("||  (4) - turn current off       ||")
    print("||  (0) Exit                     ||")
    return int(input())

def match_set(choice: int):
    if choice == 1:
        choice1()
        os.system("pause")
        return True
    elif choice == 2:
        choice2()
        os.system("pause")
        return True
    elif choice == 3:
        choice3()
        os.system("pause")
        return True
    elif choice == 4:
        choice4()
        os.system("pause")
        return True
    elif choice == 0:
        return False
    else:
        print('Unexpected choice')
        return True


def choice1 ():
    state = True
    while state:
        cls()
        print("================= Waveform =====================")
        print("||  Choose which waveform you want to create:")
        print("||  (1) saw")
        print("||  (2) triangle")
        print("||  (3) sinusoidal")
        print("||  (4) exponential")
        print("||  (0) Exit ")
        ex = int(input())
        if ex == 1:
            b = bytes([0b10000000])
            print("-", b)
            port.write(b)
        elif ex == 2:
            b = bytes([0b10000001])
            print("-", b)
            port.write(b)
        elif ex == 3:
            b = bytes([0b10000010])
            print("-", b)
            port.write(b)
        elif ex == 4:
            b = bytes([0b10000011])
            print("-", b)
            port.write(b)
        else:
            state = False
def choice2():
    cls()
    print("============== amplitude ==================")
    print("||  Chose value [0, 63]")
    ex = int(input())
    b = bytes([192 + ex])
    print("-", b)
    port.write(b)

def choice3():
    cls()
    print("============== frequency ==================")
    print("||  Chose value [0, 63]")
    ex = int(input())
    b = bytes([192 + ex])
    print("-", b)
    port.write(b)

def main():
    is_running = True

    while is_running:
        choice = main_menu()
        is_running = match_set(choice)
    return 0


if __name__ == '__main__':
    main()


# Open a serial port on the second FTDI device interface (IF/2) @ 3Mbaud

#115200
#9600
#230400
#shockley
#url  = 'ftdi://ftdi:232:AQ00RVQC/1'
#UBUNTU at home
# Send bytes
# print("Transmition at", brate)
'''
cb = 0b00000000
cbs = []
for i in range(2 ** 8 - 1):
	cbs.append(cb)
	cb += 1
b = bytes(cbs)
'''
# b = bytes([0b10000010])
#b = bytes([0x33, 0x35, 0x92, 0x32, 0x4c, 0x31, 0x36, 0x35, 0x37, 0x32, 0x4c, 0x31, 0x36, 0x35, 0x37, 0x32, 0x4c, 0x31, 0x36, 0x35, 0x37, 0x80, 0xd2])
# print("-", b)
# port.write(b)
#for line in lines:
#	x = chr(int(line, 16))
#	port.write(x)
#	count += 1
#	print(count, '-', line, x)

#line = 'c5'
#x = chr(int(line, 16))
#port.write(x)
#print('-', line, x)
'''
# Receive bytes
nb = 8
print("Receiving at", brate)
print(nb, "bytes")
data = port.read(nb)
print('-', data)
#
'''
