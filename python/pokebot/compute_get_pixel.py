import time
import pyautogui


import datetime 
print(datetime.datetime.now())

im = pyautogui.screenshot()

im.getpixel((1260, 500))
im.getpixel((1320, 500))
im.getpixel((1380, 500))
im.getpixel((1420, 500))
im.getpixel((1500, 500))

print(datetime.datetime.now())
