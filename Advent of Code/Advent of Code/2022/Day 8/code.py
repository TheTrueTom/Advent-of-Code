import time, os, pathlib

filePath = os.path.join(pathlib.Path(__file__).parent.absolute(), 'input.txt')

begin = time.time()

forest = []
countA = 0

directions = ((1,0), (0,1), (-1,0), (0,-1))

with open(filePath, 'r') as file:
	for line in file:
		forest.append(list(line.strip()))

	xLength = len(forest)
	yLength = len(forest[0])

	for xindex in range(xLength):
		for yindex in range(yLength):
			
			visible = False

			for direction in directions:
				xpos = xindex
				ypos = yindex
				vis = True

				while vis and not visible:
					xpos += direction[0]
					ypos += direction[1]

					if not (0 <= xpos < xLength and 0 <= ypos < yLength):
						break

					if forest[xpos][ypos] >= forest[xindex][yindex]:
						vis = False
						break

				if vis:
					visible = True

			if visible:
				countA += 1

	resultB = 0

	for xindex in range(xLength):
		for yindex in range(yLength):

			score = 1

			for direction in directions:
				xpos = xindex + direction[0]
				ypos = yindex + direction[1]

				distance = 1

				while True:
					if not (0 <= xpos < xLength and 0 <= ypos < yLength):
						distance -= 1
						break

					if forest[xpos][ypos] >= forest[xindex][yindex]:
						break

					distance += 1
					xpos += direction[0]
					ypos += direction[1]

				score *= distance

			resultB = max(resultB, score)

print('Result 1 : %i - Result 2 : %i' % (countA, resultB))

print('Execution time: ' + '{:.3f}'.format((time.time() - begin) * 1000) + ' ms')