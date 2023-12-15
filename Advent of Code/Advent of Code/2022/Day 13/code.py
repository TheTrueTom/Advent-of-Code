import time, os, pathlib, functools

filePath = os.path.join(pathlib.Path(__file__).parent.absolute(), 'input.txt')

begin = time.time()

def compare(left, right):
	if isinstance(left, int) and isinstance(right, int):
		return -1 if left < right else 1 if left > right else 0
	elif not isinstance(left, int) and not isinstance(right, int):
		i = 0

		while i < len(left) and i < len(right):
			result = compare(left[i], right[i])

			if result != 0:
				return result

			i += 1

		if len(left) < len(right):
			return -1
		elif len(right) < len(left):
			return 1
		else:
			return 0

	elif isinstance(left, int):
		return compare([left], right)
	else:
		return compare(left, [right])

allPackets = []

with open(filePath, 'r') as file:
	resultA = 0

	for index, group in enumerate(file.read().split('\n\n')):
		group = group.split('\n')
		left = eval(group[0])
		right = eval(group[1])

		allPackets.append(left)
		allPackets.append(right)

		if compare(left, right) == -1:
			resultA += index + 1

	allPackets.append([[2]])
	allPackets.append([[6]])

	allPackets = sorted(allPackets, key=functools.cmp_to_key(compare))

	resultB = (allPackets.index([[2]]) + 1 ) * (allPackets.index([[6]]) + 1)

	print('Result 1 : %i - Result 2 : %i' % (resultA, resultB))
		
print('Execution time: ' + '{:.3f}'.format((time.time()-begin)*1000) + ' ms')