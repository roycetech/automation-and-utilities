import pyautogui
import time
import math

# click bluestack app from the taskbar
pyautogui.click(pyautogui.locateCenterOnScreen("images/blue_stacks_task_icon.png"))

pyautogui.mouseDown(1400, 560)

def getX(angle, radius):
    return centerx + radius * math.cos(math.radians(angle))

def getY(angle, radius):
    return centery + radius * math.sin(math.radians(angle))

centerx=1400
centery=490


pyautogui.mouseDown(1400, 575)
for i in range(0, 360, 90):
    x = getX(i, 50)
    y = getY(i, 50)
    pyautogui.moveTo(x, y)
for i in range(0, 360, 90):
    x = getX(i, 50)
    y = getY(i, 50)
    pyautogui.moveTo(x, y)

time.sleep(2)



