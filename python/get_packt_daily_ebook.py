#!/usr/bin/env python3.5


# Responsive nature of the web page makes it a little unpredictable to detect
# visible elements, that's why the following algo is used.
# 1. Click claim button to active the login form
# 2. Enter credentials
# 3. Click the claim button again, this time it will forward to your book
#  collection.


from config import CONFIG
email = CONFIG['email'];
password = CONFIG['password'];


from selenium import webdriver
from time import sleep

browser = webdriver.Firefox()
browser.get('https://www.packtpub.com/packt/offers/free-learning')

claim_button = browser.find_element_by_css_selector("div.book-claim-token-inner > input.form-submit")
claim_button.click()


email_field = browser.find_element_by_id("email")
email_field.send_keys(email)

pw_field = browser.find_element_by_id("password")
pw_field.send_keys(password)

email_field.submit()


# Cache have changed due to page reload, so re-fetch.
claim_button = browser.find_element_by_css_selector("div.book-claim-token-inner > input.form-submit")
claim_button.click()

browser.quit()

print('Program end.')