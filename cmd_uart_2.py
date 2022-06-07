# Enable pyserial extensions
import pyftdi.serialext


count = 0
# Open a serial port on the second FTDI device interface (IF/2) @ 3Mbaud
brate = 230400
#115200
#9600
#230400
#shockley
#url  = 'ftdi://ftdi:232:AQ00RVQC/1'
#UBUNTU at home
url = 'ftdi://ftdi:232:AB0JNVIE/1'
port = pyftdi.serialext.serial_for_url(url, baudrate=brate, bytesize=8, stopbits=1, parity='N', xonxoff=False, rtscts=False)

# Send bytes
print("Transmition at", brate)
'''
cb = 0b00000000
cbs = []
for i in range(2 ** 8 - 1):
	cbs.append(cb)
	cb += 1
b = bytes(cbs)
'''
b = bytes([0b10000010])
#b = bytes([0x33, 0x35, 0x92, 0x32, 0x4c, 0x31, 0x36, 0x35, 0x37, 0x32, 0x4c, 0x31, 0x36, 0x35, 0x37, 0x32, 0x4c, 0x31, 0x36, 0x35, 0x37, 0x80, 0xd2])
print("-", b)
port.write(b)
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
