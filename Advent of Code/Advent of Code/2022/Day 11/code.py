import time, os, pathlib, math

filePath = os.path.join(pathlib.Path(__file__).parent.absolute(), 'input.txt')

begin = time.time()

currentRound = 0
monkeys = []

class Monkey:
	monkeyId = 0
	items = []
	operation = ('', 0) # (Operator, factor)
	test = [0,0,0] # (Divisible by #, if true send to monkey #, if false send to monkey #)
	inspectedItems = 0

	def processItem(self, item, worryNot = True):
		newWorryLevel = item
		
		if self.operation[0] == '+':
			newWorryLevel += self.operation[1] if self.operation[1] != 'old' else newWorryLevel
		elif self.operation[0] == '*':
			newWorryLevel *= self.operation[1] if self.operation[1] != 'old' else newWorryLevel

		if worryNot:
			newWorryLevel = math.floor(newWorryLevel / 3)

		if newWorryLevel % self.test[0] == 0:
			return (self.test[1], newWorryLevel)
		else:
			return (self.test[2], newWorryLevel)

	def display(self):
		print('MONKEY')
		print('├ ID: %i' % self.monkeyId)
		print('├ ITEMS: %s' % self.items)
		print('├ OPERATION: %s %s' % (self.operation[0], self.operation[1]))
		print('├ TEST: divisible by %i | give to %i if true else to %i\n' % (self.test[0], self.test[1], self.test[2]))

def resetSim():
	simMonkeys = []

	with open(filePath, 'r') as file:
		test = []

		for line in file.read().split('\n'):
			if line[:6] == 'Monkey':
				simMonkeys.append(Monkey())
				simMonkeys[-1].monkeyId = int(line.strip(':').split()[1])
			elif line[:16] == '  Starting items':
				itemsList = []

				for item in [x.strip(',') for x in line.split()[2:]]:
					itemsList.append(int(item))

				simMonkeys[-1].items = itemsList
			elif line[:11] == '  Operation':
				simMonkeys[-1].operation = (line.split(' ')[6],'old' if line.split(' ')[7] == 'old' else int(line.split(' ')[7]))
			elif line[:6] == '  Test':
				test.append(int(line.split(' ')[-1]))
			elif line[:11] == '    If true':
				test.append(int(line.split(' ')[-1]))
			elif line[:12] == '    If false':
				test.append(int(line.split(' ')[-1]))
				simMonkeys[-1].test = test
				test = []

	greateastCommonDivisor = 1

	for monkey in simMonkeys:
		greateastCommonDivisor *= monkey.test[0]

	return (simMonkeys, greateastCommonDivisor)

monkeys, greateastCommonDivisor = resetSim()

for i in range(20):
	currentRound += 1

	for i in range(len(monkeys)):
		for item in monkeys[i].items.copy():
			(giveTo, newWorryLevel) = monkeys[i].processItem(item)
			monkeys[i].inspectedItems += 1
			monkeys[giveTo].items.append(newWorryLevel)
			monkeys[i].items.pop(0)

resultA = sorted([x.inspectedItems for x in monkeys], reverse=True)[0] * sorted([x.inspectedItems for x in monkeys], reverse=True)[1]

currentRound = 0

monkeys, greateastCommonDivisor = resetSim()

for i in range(10000):
	currentRound += 1

	for i in range(len(monkeys)):
		for item in monkeys[i].items.copy():
			(giveTo, newWorryLevel) = monkeys[i].processItem(item, worryNot=False)
			monkeys[i].inspectedItems += 1
			monkeys[giveTo].items.append(newWorryLevel % greateastCommonDivisor)
			monkeys[i].items.pop(0)

resultB = sorted([x.inspectedItems for x in monkeys], reverse=True)[0] * sorted([x.inspectedItems for x in monkeys], reverse=True)[1]

print('Result 1 : %i - Result 2 : %s' % (resultA, resultB))

print('\nExecution time: ' + '{:.3f}'.format((time.time() - begin) * 1000) + ' ms')