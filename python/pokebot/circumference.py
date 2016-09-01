import math
import pyautogui
import datetime 

centerx=50
centery=50


def getX(angle, radius):
    return centerx + radius * math.cos(math.radians(angle))

def getY(angle, radius):
    return centery + radius * math.sin(math.radians(angle))

print(datetime.datetime.now())
im = pyautogui.screenshot('/Users/royce/Desktop/screenshot-small.png', region=(0,0, 100, 100))
print(datetime.datetime.now())
for i in range(0, 360, 5):
    x = getX(i, 10)
    y = getY(i, 10)
    im.getpixel((x, y))
for i in range(0, 360, 5):
    x = getX(i, 20)
    y = getY(i, 20)
    im.getpixel((x, y))
for i in range(0, 360, 5):
    x = getX(i, 30)
    y = getY(i, 30)
    im.getpixel((x, y))

print(datetime.datetime.now())

def pixelMatchesColor(image, x, y, expectedRGBColor, tolerance=0):
    r, g, b = screenshot().getpixel((x, y))
    exR, exG, exB = expectedRGBColor
    return (abs(r - exR) <= tolerance) and (abs(g - exG) <= tolerance) and\
        (abs(b - exB) <= tolerance)
