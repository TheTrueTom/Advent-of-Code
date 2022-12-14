import time, os, pathlib, sys

filePath = os.path.join(pathlib.Path(__file__).parent.absolute(), 'input.txt')

begin = time.time()

grid = []

heightValues = ['S'] + [chr(i) for i in range(97,123)] + ['E']

directions = [(1,0), (-1,0), (0,1), (0,-1)]

startPosition = ''
endPosition = ''

def findPath(grid, start, target):
	visited = set([start])
	toVisit = list([(start, 0)])

	while toVisit:
		(posX, posY), distance = toVisit.pop(0)

		for direction in directions:
			futureX, futureY = posX + direction[0], posY + direction[1]

			if (futureX, futureY) == target:
				return distance + 1

			if (0 <= futureX < len(grid) 
				and 0 <= futureY < len(grid[0])
				and (futureX, futureY) not in visited
				and grid[futureX][futureY] <= grid[posX][posY] + 1):
					toVisit.append(((futureX, futureY), distance + 1))
					visited.add((futureX, futureY))

	return sys.maxsize

with open(filePath, 'r') as file:
	for index, line in enumerate(file):
		if 'S' in line:
			startPosition = (index, line.index('S'))

		if 'E' in line:
			endPosition = (index, line.index('E'))

		heightLine = [heightValues.index(x) for x in line.strip().replace('S', 'a').replace('E','z')]
		grid.append(heightLine)

		lowerPositions = []

		for XPos, line in enumerate(grid):
			for YPos, height in enumerate(line):
				if height == 1:
					lowerPositions.append((XPos, YPos))

	resultA = findPath(grid, startPosition, endPosition)
	resultB = min([findPath(grid, x, endPosition) for x in lowerPositions])

print('Result 1 : %i - Result 2 : %s' % (resultA, resultB))

print('\nExecution time: ' + '{:.3f}'.format((time.time() - begin) * 1000) + ' ms')