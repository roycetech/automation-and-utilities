import time
import pyautogui


import datetime 
print(datetime.datetime.now())


def is_pokestop(position):
	pass

def activate_stop(xpos, ypos):
	pyautogui.moveTo(xpos, ypos)
	if pyautogui.pixelMatchesColor(xpos, 500, (50, 255, 255), tolerance=25) or\
		pyautogui.pixelMatchesColor(xpos, 500, (30, 100, 220), tolerance=25):
		pyautogui.click(xpos, ypos, button='left')
		time.sleep(1.5)
		pyautogui.moveTo(1290, 320)
		pyautogui.dragRel(170, 0, .2)

		time.sleep(1.5)
		pyautogui.click(1383, 590, button='left')

# activate_stop(None)


def is_pokestop_closeby():
	xlist = [x  for x in range(1260, 1501, 30)]
	ylist = [y  for y in range(400, 550, 10)]
	
	for xpos in xlist:
		if pyautogui.pixelMatchesColor(xpos, 500, (50, 255, 255), tolerance=25) or\
			pyautogui.pixelMatchesColor(xpos, 500, (30, 100, 220), tolerance=25):
			print("Pokestop Detected! %d, %d" % (xpos, 500))
			activate_stop(xpos, 500)
			break

	for ypos in ylist:
		if pyautogui.pixelMatchesColor(1430, ypos, (50, 255, 255), tolerance=25) or\
			pyautogui.pixelMatchesColor(1430, ypos, (30, 100, 220), tolerance=25):
			print("Pokestop Detected! %d, %d" % (1430, ypos))
			activate_stop(1430, ypos)
			break

	# return pyautogui.pixelMatchesColor(1260, 500, (50, 255, 255), tolerance=15) or\
	# 	pyautogui.pixelMatchesColor(1320, 500, (50, 255, 255), tolerance=15) or\
	# 	pyautogui.pixelMatchesColor(1380, 500, (50, 255, 255), tolerance=15) or\
	# 	pyautogui.pixelMatchesColor(1420, 500, (50, 255, 255), tolerance=15) or\
	# 	pyautogui.pixelMatchesColor(1500, 500, (50, 255, 255), tolerance=15)

# pokestop_closeby()

while True:
	is_pokestop_closeby()
	time.sleep(1)



