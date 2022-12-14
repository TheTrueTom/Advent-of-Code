import time, os, pathlib
filePath = os.path.join(pathlib.Path(__file__).parent.absolute(), 'input.txt')

begin = time.time()

with open(filePath, 'r') as file:
	alphabet = [chr(x) for x in range(65,91)] + ['#']
	startingLines = []
	stacks9000 = [[],[],[],[],[],[],[],[],[]]
	stacks9001 = [[],[],[],[],[],[],[],[],[]]

	for line in file:
		if line[0] != 'm':
			if line[0:2] == ' 1':
				for line in reversed(startingLines):
					for index, thing in enumerate([x for x in line.replace('###', '#') if x in alphabet]):
						if thing != '#':
							stacks9000[index].append(thing)
							stacks9001[index].append(thing)
			else:
				startingLines.append(line.strip('\n').replace('    ', ' ###'))

		else:
			instructions = [int(x) for x in line.strip().split(' ') if x.isdigit()]
			
			stacks9001[instructions[2] - 1] = stacks9001[instructions[2] - 1] + stacks9001[instructions[1] - 1][-instructions[0]:]

			for x in range(0, instructions[0]):
				stacks9000[instructions[2] - 1].append(stacks9000[instructions[1] - 1].pop())
				stacks9001[instructions[1] - 1].pop()

resultA = "".join([x[-1:][0] for x in stacks9000])
resultB = "".join([x[-1:][0] for x in stacks9001])

print('Result 1 : %s - Result 2 : %s' % (resultA, resultB))

print('Execution time: ' + '{:.3f}'.format((time.time() - begin) * 1000) + ' ms')