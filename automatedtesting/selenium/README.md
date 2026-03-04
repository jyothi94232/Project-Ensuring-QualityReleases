# Selenium Functional UI Test Suite

This directory contains comprehensive functional UI tests using Selenium WebDriver for the SauceDemo application. All test output is automatically logged to timestamped log files.

## 📋 Test Suite Overview

### Test Cases

#### 1. **Test Successful Login**
- **Purpose:** Verify login with valid credentials
- **User:** standard_user / secret_sauce
- **Validations:**
  - Browser launches successfully
  - Login form fields are accessible
  - Login button click triggers authentication
  - Redirect to products/inventory page
  - Products are displayed
- **Expected Result:** ✓ PASS

#### 2. **Test Invalid Login**
- **Purpose:** Verify error handling for invalid credentials
- **User:** invalid_user / invalid_password
- **Validations:**
  - Error message is displayed
  - Error message contains appropriate text
  - User remains on login page
- **Expected Result:** ✓ PASS

#### 3. **Test Locked User**
- **Purpose:** Verify locked out user cannot login
- **User:** locked_out_user / secret_sauce
- **Validations:**
  - Error message indicates user is locked out
  - Login is prevented
- **Expected Result:** ✓ PASS

#### 4. **Test Add to Cart**
- **Purpose:** Verify product can be added to shopping cart
- **User:** standard_user / secret_sauce
- **Validations:**
  - Login successful
  - Product can be clicked and added to cart
  - Cart badge displays correct count
- **Expected Result:** ✓ PASS

## 🚀 Setup and Installation

### Prerequisites

1. **Python 3.7+**
   ```bash
   python3 --version
   ```

2. **Google Chrome Browser**
   - Download from: https://www.google.com/chrome/

3. **ChromeDriver** (automatically managed by webdriver-manager)

### Installation Steps

1. **Navigate to selenium directory:**
   ```bash
   cd automatedtesting/selenium
   ```

2. **Create virtual environment (recommended):**
   ```bash
   python3 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

## 🏃 Running the Tests

### Option 1: Run All Tests (Recommended)

```bash
python login.py
```

This will:
- Execute all 4 test cases sequentially
- Create a timestamped log file in `log/` directory
- Display results in console and log file
- Generate test summary report

### Option 2: Run in Headless Mode (for CI/CD)

```bash
export HEADLESS=true
python login.py
```

Or inline:
```bash
HEADLESS=true python login.py
```

### Option 3: Azure DevOps Pipeline

```yaml
- task: Bash@3
  displayName: 'Install Chrome and Dependencies'
  inputs:
    targetType: 'inline'
    script: |
      sudo apt-get update
      sudo apt-get install -y chromium-browser
      pip3 install -r $(System.DefaultWorkingDirectory)/automatedtesting/selenium/requirements.txt

- task: Bash@3
  displayName: 'Run Selenium Tests'
  env:
    HEADLESS: true
  inputs:
    targetType: 'inline'
    script: |
      cd $(System.DefaultWorkingDirectory)/automatedtesting/selenium
      python3 login.py
      
- task: PublishBuildArtifacts@1
  displayName: 'Publish Selenium Logs'
  condition: always()
  inputs:
    PathtoPublish: '$(System.DefaultWorkingDirectory)/automatedtesting/selenium/log'
    ArtifactName: 'selenium-logs'
```

## 📊 Understanding Test Output

### Console Output

Tests output real-time progress to console:
```
2026-02-18 10:30:45 - INFO - ********************************************************************************
2026-02-18 10:30:45 - INFO - SELENIUM FUNCTIONAL UI TEST SUITE - STARTING
2026-02-18 10:30:45 - INFO - ********************************************************************************
2026-02-18 10:30:45 - INFO - ================================================================================
2026-02-18 10:30:45 - INFO - TEST CASE 1: Successful Login with Valid Credentials
2026-02-18 10:30:45 - INFO - ================================================================================
2026-02-18 10:30:45 - INFO - Initializing Chrome WebDriver...
2026-02-18 10:30:46 - INFO - Chrome WebDriver initialized successfully
2026-02-18 10:30:46 - INFO - Attempting to login with username: standard_user
2026-02-18 10:30:46 - INFO - Navigating to https://www.saucedemo.com/
2026-02-18 10:30:47 - INFO - Username "standard_user" entered successfully
2026-02-18 10:30:47 - INFO - Password entered successfully
2026-02-18 10:30:47 - INFO - Login button clicked
2026-02-18 10:30:48 - INFO - Login successful - Products page loaded
2026-02-18 10:30:48 - INFO - ✓ TEST PASSED: Successfully logged in and redirected to products page
```

### Log Files

Log files are automatically created in the `log/` directory with timestamps:
- Format: `selenium-test-YYYY-MM-DD_HH-MM-SS.log`
- Example: `selenium-test-2026-02-18_10-30-45.log`
- Contains complete test execution details
- Includes timestamps, log levels (INFO/ERROR), and messages

### Test Summary

After all tests complete, a summary report is displayed:
```
********************************************************************************
TEST EXECUTION SUMMARY
********************************************************************************
Test Successful Login: ✓ PASSED
Test Invalid Login: ✓ PASSED
Test Locked User: ✓ PASSED
Test Add to Cart: ✓ PASSED
--------------------------------------------------------------------------------
Total Tests: 4
Passed: 4
Failed: 0
Success Rate: 100.00%
********************************************************************************
```

## 📁 Project Structure

```
selenium/
├── login.py              # Main test suite with all test cases
├── requirements.txt      # Python dependencies
├── .gitignore           # Git ignore file
├── README.md            # This file
└── log/                 # Log files directory (auto-created)
    └── selenium-test-YYYY-MM-DD_HH-MM-SS.log
```

## 🔧 Configuration

### Environment Variables

| Variable | Description | Default | Options |
|----------|-------------|---------|---------|
| `HEADLESS` | Run browser in headless mode | `false` | `true`, `false` |

### Logging Configuration

Logging is configured in `setup_logging()` function:
- **Log Level:** INFO
- **Format:** `%(asctime)s - %(levelname)s - %(message)s`
- **Handlers:** File and Console (stdout)
- **Log Directory:** `log/`
- **File Naming:** Timestamped for each test run

### Timeouts

- **Explicit Wait Timeout:** 10 seconds
- **Page Load Timeout:** Default (Selenium's default)
- **Script Timeout:** Default

## 🐛 Troubleshooting

### Issue: ChromeDriver not found

**Solution:**
```bash
pip install webdriver-manager
```

The test suite uses webdriver-manager, but if issues persist:
```python
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.chrome.service import Service

service = Service(ChromeDriverManager().install())
driver = webdriver.Chrome(service=service, options=options)
```

### Issue: Chrome browser not found

**Solution:**
- Install Chrome browser: https://www.google.com/chrome/
- For Ubuntu/Debian:
  ```bash
  sudo apt-get update
  sudo apt-get install -y chromium-browser
  ```

### Issue: Tests fail in headless mode

**Solution:**
The test suite includes proper headless mode arguments:
- `--no-sandbox`
- `--disable-dev-shm-usage`
- `--disable-gpu`
- `--window-size=1920,1080`

If issues persist, check system resources and Chrome version compatibility.

### Issue: Element not found errors

**Solution:**
- Tests use explicit waits (WebDriverWait) for element presence
- Default timeout is 10 seconds
- Increase timeout if network is slow:
  ```python
  wait = WebDriverWait(driver, 20)  # Increase to 20 seconds
  ```

### Issue: Log files not created

**Solution:**
- Verify write permissions in current directory
- Log directory is auto-created if it doesn't exist
- Check disk space

## 📈 Best Practices Implemented

### ✅ Explicit Waits
- Uses WebDriverWait for reliable element interactions
- Waits for elements to be present/clickable before action
- Prevents race conditions and flaky tests

### ✅ Proper Exception Handling
- Try-except-finally blocks ensure cleanup
- Specific exception handling for different scenarios
- Graceful error messages

### ✅ Browser Cleanup
- Always closes browser in finally block
- Prevents zombie browser processes
- Ensures clean state for next test

### ✅ Comprehensive Logging
- All actions logged with timestamps
- Both successful and failed operations logged
- Easy debugging with detailed logs

### ✅ Page Object Model Ready
- Functions separated by responsibility
- Easy to extend with page objects
- Reusable helper functions

### ✅ CI/CD Compatible
- Headless mode support
- Exit codes for pass/fail (0/1)
- Environment variable configuration
- Log file artifacts

## 🔗 Additional Resources

- [Selenium Documentation](https://www.selenium.dev/documentation/)
- [Selenium with Python](https://selenium-python.readthedocs.io/)
- [WebDriver API](https://www.selenium.dev/documentation/webdriver/)
- [SauceDemo Test Site](https://www.saucedemo.com/)

## 📝 Extending the Test Suite

### Adding New Test Cases

1. Create a new function following the pattern:
   ```python
   def test_your_feature():
       """Test Case X: Description"""
       logger.info('=' * 80)
       logger.info('TEST CASE X: Your Test Name')
       logger.info('=' * 80)
       
       driver = None
       try:
           headless = os.getenv('HEADLESS', 'False').lower() == 'true'
           driver = get_driver(headless=headless)
           
           # Your test logic here
           
           logger.info('✓ TEST PASSED: Success message')
           return True
       except Exception as e:
           logger.error(f'✗ TEST FAILED: {str(e)}')
           return False
       finally:
           if driver:
               driver.quit()
   ```

2. Add to `run_all_tests()`:
   ```python
   test_results.append(('Test Your Feature', test_your_feature()))
   ```

### Implementing Page Object Model

Create page objects for better maintainability:
```python
class LoginPage:
    def __init__(self, driver):
        self.driver = driver
        self.username_field = (By.ID, 'user-name')
        self.password_field = (By.ID, 'password')
        self.login_button = (By.ID, 'login-button')
    
    def login(self, username, password):
        self.driver.find_element(*self.username_field).send_keys(username)
        self.driver.find_element(*self.password_field).send_keys(password)
        self.driver.find_element(*self.login_button).click()
```

## 🎯 Success Criteria

A test run is considered successful when:
- ✅ All 4 test cases pass
- ✅ No exceptions or errors in logs
- ✅ Exit code is 0
- ✅ Log file created successfully
- ✅ Success rate is 100%

## 📊 Test Metrics

| Metric | Target | Notes |
|--------|--------|-------|
| Success Rate | 100% | All tests should pass |
| Test Duration | < 60s | All 4 tests combined |
| Code Coverage | N/A | UI functional tests |
| Browser Support | Chrome | Can extend to Firefox, Edge |

## 🔐 Security Notes

- Passwords are logged as "Password entered successfully" (not actual password)
- Sensitive data is not written to logs
- Test credentials are demo site credentials only
- Do not use production credentials in automated tests
