import math

SAMPLES = 200

def generate_sin():
    file = open ("sin.mem", 'w')
    x = 2 * math.pi / SAMPLES
    for i in range (SAMPLES):
        file.write(f'{round(math.sin(i*x) * 124) + 124:0{2}x}' + '\n')
    file.close()
def generate_exponential():
    file = open ("exp.mem", 'w')
    x = 5.57 / SAMPLES
    for i in range (SAMPLES):
        file.write(f'{round(math.exp(i * x)):0{2}x}' + '\n')
    file.close()

def generate_saw():
    file = open("saw.mem", 'w')
    x = 255 / SAMPLES
    for i in range (SAMPLES):
        file.write(f'{round(i * x):0{2}x}' + '\n')
    file.close()
def generate_triangles():
    file = open("tri.mem", 'w')
    x = 255 / SAMPLES * 2
    for i in range(math.ceil(SAMPLES/2)):
        file.write(f'{round(i * x):0{2}x}' + '\n')
    for i in range(math.ceil(SAMPLES/2)):
        file.write(f'{round((x*SAMPLES/2) - (i * x)):0{2}x}' + '\n')
    file.close()

if __name__ == '__main__':
    generate_sin()
    generate_exponential()
    generate_saw()
    generate_triangles()
