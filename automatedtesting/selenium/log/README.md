# Log Directory

This directory contains Selenium test execution logs.

Log files are automatically created with timestamps when tests are run:
- Format: `selenium-test-YYYY-MM-DD_HH-MM-SS.log`
- Contains: All test execution details, timestamps, and results

## Log File Contents

Each log file includes:
- Test suite start/end timestamps
- Individual test case execution details
- Browser initialization logs
- Element interaction logs (locating, clicking, entering text)
- Success/failure messages
- Error details and stack traces (if any)
- Test execution summary

## Sample Log Entry

```
2026-02-18 10:30:45 - INFO - ********************************************************************************
2026-02-18 10:30:45 - INFO - SELENIUM FUNCTIONAL UI TEST SUITE - STARTING
2026-02-18 10:30:45 - INFO - Test execution started at: 2026-02-18 10:30:45
2026-02-18 10:30:45 - INFO - ********************************************************************************
2026-02-18 10:30:45 - INFO - ================================================================================
2026-02-18 10:30:45 - INFO - TEST CASE 1: Successful Login with Valid Credentials
2026-02-18 10:30:45 - INFO - ================================================================================
2026-02-18 10:30:45 - INFO - Initializing Chrome WebDriver...
2026-02-18 10:30:46 - INFO - Chrome WebDriver initialized successfully
2026-02-18 10:30:46 - INFO - Attempting to login with username: standard_user
...
```

## Azure Log Analytics Integration

These log files can be ingested into Azure Log Analytics for monitoring and analysis.
See the main project documentation for Log Analytics configuration.
