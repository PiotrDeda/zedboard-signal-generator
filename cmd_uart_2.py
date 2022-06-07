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


def choice1():
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
    b = bytes([64 + ex])
    print("-", b)
    port.write(b)


def choice4():
    cls()
    b = bytes([0b00111100])
    print("-", b)
    port.write(b)


def main():
    try:
        is_running = True

        while is_running:
            choice = main_menu()
            is_running = match_set(choice)
    except Exception as e:
        print(e)
        os.system("pause")

    return 0


if __name__ == '__main__':
    main()
