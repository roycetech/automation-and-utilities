from pyautogui import *
import time


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


# Program Start ===============
print("Starting in 2 Seconds...")
time.sleep(2)
# click bluestack app from the taskbar
click(locateCenterOnScreen("blue_stacks_task_icon.png"))

moveNorth(60*60)
