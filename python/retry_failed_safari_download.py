import pyautogui

original_position = None

while True:
    position = pyautogui.locateCenterOnScreen('safari_retry_icon_orange.png')
    if position:        
        print("Found retry button")
        original_position = pyautogui.position()
        pyautogui.click(position[0], position[1])
        # pyautogui.moveTo(original_position[0], original_position[1])
    else:
        print("Retry not found")
