import time, os, pathlib, re
filePath = os.path.join(pathlib.Path(__file__).parent.absolute(), 'input.txt')

begin = time.time()

def definePattern(length):
	pattern = r''

	for i in range(0, length):
		pattern += r'(\w)'

		if i != 0:
			pattern += r'(?<!'
			for j in range(1,i+1):
				pattern += r'\%i'%j
				if j < i:
					pattern += r'|'

			pattern += r')'

	return pattern

with open(filePath, 'r') as file:
	for line in file:
		x = re.search(definePattern(4), line)
		y = re.search(definePattern(14), line)

		print('Result 1 : %i - Result 2 : %i' % (x.span()[1], y.span()[1]))

print('Execution time: ' + '{:.3f}'.format((time.time() - begin) * 1000) + ' ms')
