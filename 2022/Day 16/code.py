import time, os, pathlib

filePath = os.path.join(pathlib.Path(__file__).parent.absolute(), 'input.txt')

begin = time.time()

def dijkstra(graph, source):
	nodes = list(graph.keys())

	distances = {node: 99 for node in graph}
	distances[source] = 0

	while nodes:
		current = min(nodes, key=distances.get)
		nodes.remove(current)

		for link in graph[current][1]:
			pathLength = distances[current] + 1

			if pathLength < distances[link]:
				distances[link] = pathLength

	return distances

def DFS(valve, time):
	paths = []

	def _dfs(valve, time, visited):
		if time <= 0:
			return

		for next_valve, distance in distances[valve].items():
			if not valves[next_valve][0]:
				continue

			if next_valve in visited:
				continue

			if time - distance - 1 <= 0:
				continue

			_dfs(next_valve, time - distance - 1, [*visited, next_valve])

		paths.append(visited)

	_dfs(valve, time, [])

	return paths

def pathScore(path, t):
	score = 0

	for valve, next_valve in zip(["AA", *path], path):
		t -= distances[valve][next_valve] + 1
		score += t * valves[next_valve][0]

	return score

def pairPathScore(pathA, pathB):
	if set(pathA).isdisjoint(set(pathB)):
		return pathScore(pathA, 26) + pathScore(pathB, 26)
	else:
		return 0

valves = {}

with open(filePath, 'r') as file:
	for line in file:
		words = line.split()

		name = words[1]
		flow = int(words[4][5:-1])
		links = [x.strip(',') for x in words[9:]]

		valves[name] = (flow, links)

distances = {valve: dijkstra(valves, valve) for valve in valves}
paths = DFS("AA", 30)

scoredPaths = {tuple(path): pathScore(path, 30) for path in paths}
resultA = max(scoredPaths.values())

resultsB = []

for pathA in paths:
	for pathB in paths:
		if pathA != pathB:
			resultsB.append(pairPathScore(pathA, pathB))

resultB = max(resultsB)

print('Result 1 : %i - Result 2 : %i' % (resultA, resultB))
		
print('Execution time: ' + '{:.3f}'.format((time.time()-begin)*1000) + ' ms')
