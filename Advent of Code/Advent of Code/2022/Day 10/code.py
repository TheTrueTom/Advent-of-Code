import time, os, pathlib

filePath = os.path.join(pathlib.Path(__file__).parent.absolute(), 'input.txt')

begin = time.time()

register = 1
cycle = 0
tickTime = {'addx': 2, 'noop': 1}

screen = [[' ' for _ in range(40)] for _ in range(6)]

def handleTick(cycle, register, resultA):
	screenCycle = cycle - 1

	screen[screenCycle // 40][screenCycle % 40] = 'o' if abs(screenCycle % 40 - register) < 2 else ' '

	if cycle in [20, 60, 100, 140, 180, 220]:
		resultA += cycle * register

	return resultA

with open(filePath, 'r') as file:
	resultA = 0

	for line in file:
		command = line.strip().split()

		for i in range(tickTime[command[0]]):
			cycle += 1

			resultA = handleTick(cycle, register, resultA)

		register += int(command[1]) if command[0] == 'addx' else 0

	print('Result 1 : %i - Result 2 : %s' % (resultA, '\n'))

	for line in screen:
		print(''.join(line))

print('\nExecution time: ' + '{:.3f}'.format((time.time() - begin) * 1000) + ' ms')