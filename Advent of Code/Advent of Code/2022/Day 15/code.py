import time, os, pathlib

filePath = os.path.join(pathlib.Path(__file__).parent.absolute(), 'input.txt')

begin = time.time()

def dist(A, B):
	return abs(A[0] - B[0]) + abs(A[1] - B[1])

def isValid(x, y, sensorList):
	for (sensorX, sensorY, distance) in sensorList:
		if dist((x, y), (sensorX, sensorY)) <= distance:
			return False

	return True

def checkFarther(sensors):
	for (sensorX, sensorY, distance) in sensors:
		targetDistance = distance + 1

		for Xdistance in range(targetDistance + 1):
			YDistance = targetDistance - Xdistance

			for x, y in [(1,1), (1,-1), (-1,1), (-1,-1)]:
				prospectX = sensorX + (Xdistance * x)
				prospectY = sensorY + (YDistance * y)

				if (0 <= prospectX <= 4000000 and 0 <= prospectY <= 4000000):
					if isValid(prospectX, prospectY, sensors):
						return prospectX * 4000000 + prospectY

sensors = set()
beacons = set()

with open(filePath, 'r') as file:
	for line in file:
		elts = line.split()

		sensorX = int(elts[2][2:-1])
		sensorY = int(elts[3][2:-1])

		beaconX = int(elts[8][2:-1])
		beaconY = int(elts[9][2:])

		distance = dist((sensorX, sensorY), (beaconX, beaconY))

		sensors.add((sensorX, sensorY, distance))
		beacons.add((beaconX, beaconY))

resultA = 0

maxDist = max([x[2] for x in sensors])
minX = min([x[0] for x in sensors]) - maxDist
maxX = max([x[0] for x in sensors]) + maxDist

for x in range(minX, maxX):
    y = int(2e6)

    if not isValid(x, y, sensors) and (x,y) not in beacons:
        resultA += 1

resultB = checkFarther(sensors)

print('Result 1 : %i - Result 2 : %i' % (resultA, resultB))
		
print('Execution time: ' + '{:.3f}'.format((time.time()-begin)*1000) + ' ms')