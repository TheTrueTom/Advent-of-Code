import time, os, pathlib

filePath = os.path.join(pathlib.Path(__file__).parent.absolute(), 'input.txt')

begin = time.time()

Xlimits = [500, 500]
Ylimits = [0, 0]
paths = []
directions = ((0, 1), (-1, 1), (1, 1))

def display(grid):
	for line in grid:
		print(''.join(line))

	time.sleep(0.005)

	print('\n')

def buildGrid(gridXSize, gridYSize, paths, part):
	grid = [['.' for _ in range(gridXSize + 1)] for _ in range(gridYSize + 1)]

	for path in paths:
		currentPosition = path[0]
		
		for element in path[1:]:
			if element[0] == currentPosition[0]: # vertical line
				for y in range(min(currentPosition[1], element[1]), max(currentPosition[1], element[1]) + 1):
					grid[y][element[0]] = '#'
			else:
				for x in range(min(currentPosition[0], element[0]), max(currentPosition[0], element[0]) + 1):
					grid[element[1]][x] = '#'

			currentPosition = element

	grid[0][500] = 'o'

	if part == 2:
		grid[len(grid) - 1] = ['#' for _ in range(1000)]

	return grid

def getGrains(grid, part):
	targetReached = False # Either the abyss of (500, 0) depending on the part
	grains = 0

	while not targetReached:
		grainPosition = [500,0]
		grains += 1

		grainStopped = False

		while not targetReached and not grainStopped:
			stopped = True

			for direction in directions:
				prospectX = grainPosition[0] + direction[0]
				prospectY = grainPosition[1] + direction[1]

				if (0 <= prospectX < len(grid[0]) and 0 <= prospectY < len(grid)): # Tant qu'on reste dans la grille
					prospect = grid[prospectY][prospectX]

					if prospect in ['#', 'o']:
						continue
					elif prospect == '.':
						grid[prospectY][prospectX] = 'o'
						grid[grainPosition[1]][grainPosition[0]] = '.'
						grainPosition = [prospectX, prospectY]
						stopped = False
						break
				else:
					targetReached = True
					break

			grainStopped = stopped

			if grainStopped and grainPosition == [500, 0]:
				targetReached = True

	return grains

with open(filePath, 'r') as file:
	for line in file:
		points = [[int(y) for y in x.split(',')] for x in line.strip().split(' -> ')]

		paths.append(points)

		for point in points:
			Xlimits[0] = min(Xlimits[0], point[0])
			Xlimits[1] = max(Xlimits[1], point[0])

			Ylimits[0] = min(Ylimits[0], point[1])
			Ylimits[1] = max(Ylimits[1], point[1])

gridXSize = 1000
gridYSize = Ylimits[1] + 2

grid = buildGrid(gridXSize, gridYSize, paths, 1)
resultA = getGrains(grid, 1) - 1

grid = buildGrid(gridXSize, gridYSize, paths, 2)
resultB = getGrains(grid, 2)

print('Result 1 : %i - Result 2 : %i' % (resultA, resultB))
		
print('Execution time: ' + '{:.3f}'.format((time.time()-begin)*1000) + ' ms')