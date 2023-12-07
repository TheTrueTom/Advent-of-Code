import time, os, pathlib

filePath = os.path.join(pathlib.Path(__file__).parent.absolute(), 'input.txt')

begin = time.time()

with open(filePath, 'r') as file:
	currentPath = []
	diskContent = {}

	for line in file:
		command = line.strip().split(' ')

		if command[0] == '$': # Command			
			if command[1] == 'cd':
				if command[2] == '..':
					currentPath.pop()
				else:
					currentPath.append(command[2])

		elif command[0] != 'dir': # File
			for i in range(len(currentPath)):
				if ':'.join(currentPath[:i+1]) not in diskContent:
					diskContent[':'.join(currentPath[:i+1])] = int(command[0])
				else:
					diskContent[':'.join(currentPath[:i+1])] += int(command[0])
	
	resultA = sum(size for size in diskContent.values() if size <= 100000)

	requiredSpace = 30000000 - (70000000 - diskContent['/'])

	resultB = min(size for size in diskContent.values() if size >= requiredSpace)
			
print('Result 1 : %i - Result 2 : %i' % (resultA, resultB))

print('Execution time: ' + '{:.3f}'.format((time.time() - begin) * 1000) + ' ms')
