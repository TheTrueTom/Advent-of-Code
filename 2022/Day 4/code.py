import time, os, pathlib
filePath = os.path.join(pathlib.Path(__file__).parent.absolute(), 'input.txt')

begin = time.time()

with open(filePath, 'r') as file:

	countA = 0
	countB = 0

	for line in file:
		line = line.strip('\n')
		pair = [[int(i) for i in line.split(',')[0].split('-')], [int(i) for i in line.split(',')[1].split('-')]]

		if pair[0][0] <= pair[1][0] and pair[0][1] >= pair[1][1]:
			countA += 1
		elif pair[1][0] <= pair[0][0] and pair[1][1] >= pair[0][1]:
			countA += 1
		elif pair[0][0] in range(pair[1][0], pair[1][1] + 1) or pair[0][1] in range(pair[1][0], pair[1][1] + 1):
			countB += 1
		elif pair[1][0] in range(pair[0][0], pair[0][1] + 1) or pair[1][1] in range(pair[0][0], pair[0][1] + 1):
			countB += 1

	print('Result 1 : %i - Result 2 : %i' % (countA, countB))

print('Execution time: ' + '{:.3f}'.format((time.time()-begin)*1000) + ' ms')