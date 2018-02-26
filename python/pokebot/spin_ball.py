import time
import math
import autopy3


# click bluestack app from the taskbar
# pyautogui.click(pyautogui.locateCenterOnScreen("images/blue_stacks_task_icon.png"))

# pyautogui.mouseDown(1400, 560)

def getX(angle, radius):
    return int(centerx + radius * math.cos(math.radians(angle)))


def getY(angle, radius):
    return int(centery + radius * math.sin(math.radians(angle)))


centerx = 500
centery = 500

autopy3.mouse.move(centerx, centery)

print('Iikot!')
# pyautogui.mouseDown(1400, 575)


def spin(times):
    for j in range(0, times + 1):
        for i in range(0, 360, 10):
            x = getX(i, 50)
            y = getY(i, 50)
            autopy3.mouse.move(x, y)
            time.sleep(0.005)


spin(13)

time.sleep(2)
