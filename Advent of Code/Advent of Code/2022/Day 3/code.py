import time, os, pathlib
filePath = os.path.join(pathlib.Path(__file__).parent.absolute(), 'input.txt')

begin = time.time()

with open(filePath, 'r') as file:
	values = [''] + [chr(i) for i in range(97,123)] + [chr(i) for i in range(65,91)]
	scoreA = 0
	scoreB = 0

	currentGroup = []
	count = 0

	for line in file:
		cleanLine = line.strip()
		lineHalf = int(len(cleanLine)/2)
		
		containers = [cleanLine[:lineHalf], cleanLine[lineHalf:]]
		common = [value for value in containers[0] if value in containers[1]][0]
		scoreA += values.index(common)

		currentGroup.append(cleanLine)
		count += 1

		if count == 3:
			common = [value for value in currentGroup[0] if value in currentGroup[1] and value in currentGroup[2]][0]
			scoreB += values.index(common)
			currentGroup = []
			count = 0

	print('Result 1 : %i - Result 2 : %i' % (scoreA, scoreB))
		
print('Execution time: ' + '{:.3f}'.format((time.time()-begin)*1000) + ' ms')