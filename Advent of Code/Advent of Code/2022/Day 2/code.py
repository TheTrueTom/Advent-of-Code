import time, os, pathlib
filePath = os.path.join(pathlib.Path(__file__).parent.absolute(), 'input.txt')

begin = time.time()

with open(filePath, 'r') as file:
	scoreA = 0
	scoreB = 0
	force = {'A': {'Z': 'loser', 'Y': 'winner', 'X': 'draw'}, 'B': {'X': 'loser', 'Z': 'winner', 'Y': 'draw'},'C': {'Y': 'loser', 'X': 'winner', 'Z': 'draw'}}
	points = {'X': 1, 'Y': 2, 'Z': 3}

	for line in file:
		play = line.strip('\n').split(' ')

		scoreA += points[play[1]]

		if force[play[0]][play[1]] == 'draw':
			scoreA += 3
		elif force[play[0]][play[1]] == 'winner':
			scoreA += 6

		if play[1] == 'X': # Loose
			scoreB += points[[i for i in force[play[0]] if force[play[0]][i] == 'loser'][0]]
		elif play[1] == 'Y': # Draw
			scoreB += points[[i for i in force[play[0]] if force[play[0]][i] == 'draw'][0]] + 3
		else: # Win
			scoreB += points[[i for i in force[play[0]] if force[play[0]][i] == 'winner'][0]] + 6

	print('Result 1 : %i - Result 2 : %i' % (scoreA, scoreB))

print('Execution time: ' + '{:.3f}'.format((time.time()-begin)*1000) + ' ms')