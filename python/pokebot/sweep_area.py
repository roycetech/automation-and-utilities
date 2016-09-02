from pyautogui import *
import time


# duration is in seconds


def moveNorth(duration):
    move('w', duration)

def moveSouth(duration):
    move('s', duration)

def moveEast(duration):
    move('d', duration)

def moveWest(duration):
    move('a', duration)


def move(key, duration):
    print('Pressing down: ' + key);
    keyDown(key)
    doQuit = False
    while duration > 0:
        time.sleep(1)

        if position()[0] == 0:
            doQuit = True
            break;

        duration -= 1
    keyUp(key)
    if doQuit:
        print("Stopping script")
        import sys
        sys.exit()


print("Starting in 1 Second...")
time.sleep(1)
# click bluestack app from the taskbar
bspos = locateCenterOnScreen("images/blue_stacks_task_icon.png")
print(bspos)
click(bspos)
# click(1000, 1055)


flag = True
while (flag):
    moveNorth(8)
    moveEast(8)
    moveSouth(8)
    moveEast(8)
    moveNorth(8)
    moveEast(8)
    moveSouth(20)
    moveWest(8)
    moveNorth(8)
    moveWest(8)
    moveSouth(8)
    moveWest(8)
    moveNorth(8)
    moveWest(8)
    moveSouth(8)
    moveWest(8)
    moveNorth(20)
    moveEast(8)
    moveSouth(8)
    moveEast(8)

    # flag = False
    print("Back to Origin")
	
	
	

