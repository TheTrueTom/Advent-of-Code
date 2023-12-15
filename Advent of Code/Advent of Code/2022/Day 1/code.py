import time, os, pathlib
filePath = os.path.join(pathlib.Path(__file__).parent.absolute(), 'input.txt')

begin = time.time()

with open(filePath, 'r') as file:
	elvesLoad = [0]

	for line in file:
		if line == "\n":
			elvesLoad.append(0)
		else:
			elvesLoad[len(elvesLoad) - 1] += int(line)

	elvesLoad.sort(reverse=True)

	print('Result 1 : %i - Result 2 : %i' % (max(elvesLoad), sum(elvesLoad[:3])))

print('Execution time: ' + '{:.3f}'.format((time.time()-begin)*1000) + ' ms')