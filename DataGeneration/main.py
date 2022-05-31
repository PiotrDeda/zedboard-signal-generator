import math

SAMPLES = 200

def generate_sin():
    file = open ("sin.dat", 'w')
    x = 2 * math.pi / SAMPLES
    for i in range (SAMPLES):
        file.write(f'{math.floor(math.sin(i*x) * 124) + 124:0{2}x}' + '\n')

if __name__ == '__main__':
    generate_sin()