import math

SAMPLES = 200

def generate_sin():
    file = open ("sin.mem", 'w')
    x = 2 * math.pi / SAMPLES
    for i in range (SAMPLES):
        file.write(f'{math.floor(math.sin(i*x) * 124) + 124:0{2}x}' + '\n')
    file.close()
def generate_exponential():
    file = open ("exp.mem", 'w')
    x = 5.57 / SAMPLES
    for i in range (SAMPLES):
        file.write(f'{math.floor(math.exp(i * x)):0{2}x}' + '\n')
if __name__ == '__main__':
    generate_sin()
    generate_exponential()