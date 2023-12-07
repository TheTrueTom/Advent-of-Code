import time, os, pathlib

filePath = os.path.join(pathlib.Path(__file__).parent.absolute(), 'input.txt')

begin = time.time()

moves = {'R': (1, 0), 'L': (-1, 0), 'U': (0, 1), 'D': (0, -1)}

def getMoves(headPos, tailPos):
	move = ''

	if (abs(headPos[0] - tailPos[0]) > 1 or abs(headPos[1] - tailPos[1]) > 1): # diagonal
		if headPos[0] - tailPos[0] > 0: # Need to move to the right
			move += 'R'
		elif headPos[0] - tailPos[0] < 0: # Need to move to the left
			move += 'L'

		if headPos[1] - tailPos[1] > 0: # Need to go up
			move += 'U'
		elif headPos[1] - tailPos[1] < 0: # Need to go down
			move += 'D'

	for letter in move:
		tailPos = (tailPos[0] + moves[letter][0], tailPos[1] + moves[letter][1])

	return tailPos


with open(filePath, 'r') as file:
	longRopePos = [(0,0) for _ in range(10)]

	tailPositions = set(longRopePos)
	longRopeTailPositions = set(longRopePos)

	for line in file:
		command, amount = line.strip().split()

		for _ in range(int(amount)):
			longRopePos[0] = (longRopePos[0][0] + moves[command][0], longRopePos[0][1] + moves[command][1])

			for nodeIndex in range(1, len(longRopePos)):
				longRopePos[nodeIndex] = getMoves(longRopePos[nodeIndex - 1], longRopePos[nodeIndex])

				longRopeTailPositions.add(longRopePos[len(longRopePos) - 1])
				tailPositions.add(longRopePos[1])

print('Result 1 : %i - Result 2 : %i' % (len(tailPositions), len(longRopeTailPositions)))

print('Execution time: ' + '{:.3f}'.format((time.time() - begin) * 1000) + ' ms')