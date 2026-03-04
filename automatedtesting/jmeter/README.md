# JMeter Performance Test Suites

This directory contains comprehensive performance test suites for the FakeRestAPI application using Apache JMeter.

## 📋 Test Suites Overview

### 1. **StressTest.jmx** - Stress Testing
Tests system behavior under **high load for a short duration** to identify breaking points and maximum capacity.

**Configuration:**
- **Duration:** 60 seconds
- **Thread Groups:**
  - Activities API: 30 concurrent users, 10 loops
  - Books API: 20 concurrent users, 8 loops
- **Ramp-up Time:** 30 seconds (Activities), 20 seconds (Books)
- **Think Time:** 100ms between requests
- **Purpose:** Find system limits, identify bottlenecks

**Tested Endpoints:**
- GET /api/Activities
- GET /api/Activities/{id}
- POST /api/Activities
- PUT /api/Activities/{id}
- GET /api/Books
- GET /api/Books/{id}

### 2. **EnduranceTest.jmx** - Endurance Testing
Tests system stability under **moderate load for an extended period** to identify memory leaks and performance degradation.

**Configuration:**
- **Duration:** 300 seconds (5 minutes) - configurable via DURATION variable
- **Thread Groups:**
  - Activities API: 10 concurrent users, infinite loops
  - Books & Authors API: 8 concurrent users, infinite loops
- **Ramp-up Time:** 60 seconds per thread group
- **Think Time:** 500ms (Activities), 800ms (Books/Authors)
- **Purpose:** Test stability, memory leaks, resource exhaustion

**Tested Endpoints:**
- GET /api/Activities
- GET /api/Activities/{id}
- POST /api/Activities
- PUT /api/Activities/{id}
- GET /api/Books
- GET /api/Books/{id}
- GET /api/Authors
- GET /api/Users

### 3. **Starter.jmx** - Basic Test
Simple baseline test for API validation.

## 🚀 Running the Tests

### Prerequisites

1. **Install Apache JMeter:**
   ```bash
   # macOS
   brew install jmeter
   
   # Or download from https://jmeter.apache.org/download_jmeter.cgi
   ```

2. **Verify Installation:**
   ```bash
   jmeter -v
   ```

### Option 1: JMeter GUI Mode (Development/Debugging)

```bash
# Navigate to jmeter directory
cd automatedtesting/jmeter

# Run Stress Test
jmeter -t StressTest.jmx

# Run Endurance Test
jmeter -t EnduranceTest.jmx
```

**GUI Mode Steps:**
1. Open JMeter GUI
2. File → Open → Select test plan (StressTest.jmx or EnduranceTest.jmx)
3. Update BASE_URL variable with your Azure App Service URL
4. Click green "Start" button (▶️)
5. View results in listeners (Summary Report, View Results Tree, etc.)

### Option 2: CLI Mode (CI/CD/Production)

**Stress Test:**
```bash
jmeter -n -t StressTest.jmx \
  -JBASE_URL=your-app-name.azurewebsites.net \
  -l stress-test-results.jtl \
  -e -o stress-test-html-report
```

**Endurance Test:**
```bash
jmeter -n -t EnduranceTest.jmx \
  -JBASE_URL=your-app-name.azurewebsites.net \
  -JDURATION=300 \
  -l endurance-test-results.jtl \
  -e -o endurance-test-html-report
```

**Parameters:**
- `-n` : Non-GUI mode
- `-t` : Test plan file
- `-J` : Define JMeter property (e.g., BASE_URL, DURATION)
- `-l` : Log file for results (.jtl format)
- `-e` : Generate HTML report after test
- `-o` : Output folder for HTML report

### Option 3: Azure DevOps Pipeline

```yaml
- task: Bash@3
  displayName: 'Run JMeter Stress Test'
  inputs:
    targetType: 'inline'
    script: |
      # Install JMeter
      wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.6.3.tgz
      tar -xzf apache-jmeter-5.6.3.tgz
      
      # Run Stress Test
      apache-jmeter-5.6.3/bin/jmeter -n \
        -t $(System.DefaultWorkingDirectory)/automatedtesting/jmeter/StressTest.jmx \
        -JBASE_URL=$(appServiceUrl) \
        -l $(Build.ArtifactStagingDirectory)/stress-test-results.jtl \
        -e -o $(Build.ArtifactStagingDirectory)/stress-test-report

- task: Bash@3
  displayName: 'Run JMeter Endurance Test'
  inputs:
    targetType: 'inline'
    script: |
      # Run Endurance Test
      apache-jmeter-5.6.3/bin/jmeter -n \
        -t $(System.DefaultWorkingDirectory)/automatedtesting/jmeter/EnduranceTest.jmx \
        -JBASE_URL=$(appServiceUrl) \
        -JDURATION=180 \
        -l $(Build.ArtifactStagingDirectory)/endurance-test-results.jtl \
        -e -o $(Build.ArtifactStagingDirectory)/endurance-test-report

- task: PublishBuildArtifacts@1
  displayName: 'Publish JMeter Reports'
  inputs:
    PathtoPublish: '$(Build.ArtifactStagingDirectory)'
    ArtifactName: 'jmeter-reports'
```

## 📊 Understanding Test Results

### Key Metrics

#### 1. **Response Time**
- **Average:** Mean response time across all requests
- **Median:** 50th percentile response time
- **90th Percentile:** 90% of requests completed within this time
- **95th Percentile:** 95% of requests completed within this time
- **99th Percentile:** 99% of requests completed within this time

**Acceptable Values:**
- ✅ Average < 1000ms
- ✅ 90th Percentile < 2000ms
- ⚠️ 95th Percentile < 3000ms
- ❌ Any > 5000ms needs investigation

#### 2. **Throughput**
- Requests per second the server can handle
- Higher is better
- Monitor for degradation during endurance tests

#### 3. **Error Rate**
- Percentage of failed requests
- ✅ Target: < 1%
- ⚠️ Warning: 1-5%
- ❌ Critical: > 5%

#### 4. **Latency**
- Time to first byte
- Indicates server processing time
- Should remain consistent during endurance tests

### Analyzing Results

**Stress Test Success Criteria:**
- System handles peak load without crashes
- Error rate < 1%
- Response times within acceptable limits
- System recovers after load is removed

**Endurance Test Success Criteria:**
- No memory leaks (consistent memory usage)
- Response times don't degrade over time
- No resource exhaustion
- Error rate remains stable
- System remains responsive throughout duration

## 🔧 Customization

### Adjusting Load

**Stress Test - Increase Load:**
```xml
<!-- In StressTest.jmx, modify ThreadGroup -->
<stringProp name="ThreadGroup.num_threads">50</stringProp>  <!-- Increase from 30 -->
<stringProp name="LoopController.loops">20</stringProp>     <!-- Increase from 10 -->
```

**Endurance Test - Increase Duration:**
```bash
# Use DURATION parameter (in seconds)
jmeter -n -t EnduranceTest.jmx -JDURATION=600  # 10 minutes
jmeter -n -t EnduranceTest.jmx -JDURATION=1800 # 30 minutes
jmeter -n -t EnduranceTest.jmx -JDURATION=3600 # 1 hour
```

### Adding New Endpoints

1. Open test plan in JMeter GUI
2. Right-click on ThreadGroup → Add → Sampler → HTTP Request
3. Configure:
   - Server Name: `${BASE_URL}`
   - Protocol: `${PROTOCOL}`
   - Path: `/api/YourEndpoint`
   - Method: GET/POST/PUT/DELETE
4. Add Response Assertion
5. Save and export

### Configuring Assertions

**Response Code Assertion:**
```xml
<ResponseAssertion>
  <stringProp name="49586">200</stringProp>  <!-- Expected code -->
  <stringProp name="Assertion.test_field">Assertion.response_code</stringProp>
</ResponseAssertion>
```

**Duration Assertion (Endurance Tests):**
```xml
<DurationAssertion>
  <stringProp name="DurationAssertion.duration">5000</stringProp>  <!-- Max ms -->
</DurationAssertion>
```

## 📈 Best Practices

### 1. **Test Environment**
- Use dedicated test environment
- Ensure consistent baseline (no other load)
- Monitor system resources (CPU, memory, network)

### 2. **Data Management**
- Use random data to simulate realistic load
- Clean up test data after execution
- Avoid hardcoded IDs

### 3. **Incremental Testing**
- Start with low load and increase gradually
- Baseline → Stress → Endurance
- Document results for comparison

### 4. **Monitoring**
- Monitor Azure App Service metrics during tests
- Check Application Insights for errors
- Monitor database performance

### 5. **CI/CD Integration**
- Run tests on dedicated agents
- Set acceptable thresholds
- Fail pipeline if thresholds exceeded
- Archive results for trending

## 🐛 Troubleshooting

### Issue: Connection Timeouts
**Solution:** 
- Increase timeout values in HTTP Samplers
- Check network connectivity
- Verify App Service is running

### Issue: High Error Rate
**Solution:**
- Check App Service logs
- Verify endpoints are correct
- Reduce concurrent users
- Check for rate limiting

### Issue: Memory Errors in JMeter
**Solution:**
```bash
# Increase JMeter heap size
export HEAP="-Xms1g -Xmx1g"
jmeter -n -t EnduranceTest.jmx ...
```

### Issue: CSV File Not Generated
**Solution:**
- Check write permissions in output directory
- Ensure path specified in `-l` parameter exists
- Use absolute paths

## 📝 Test Plan Structure

### Stress Test Components
- 2 Thread Groups (Activities, Books)
- 6 HTTP Samplers
- Response Assertions on all requests
- 3 Result Listeners (Summary, Tree, Table)
- Parameterized BASE_URL

### Endurance Test Components
- 2 Thread Groups with infinite loops
- 8 HTTP Samplers
- Response Code Assertions
- Duration Assertions (5-6 seconds max)
- 4 Result Listeners (Summary, Graph, Tree, Table)
- Configurable DURATION parameter

## 🔗 Additional Resources

- [Apache JMeter Documentation](https://jmeter.apache.org/usermanual/index.html)
- [JMeter Best Practices](https://jmeter.apache.org/usermanual/best-practices.html)
- [Performance Testing Guidance](https://docs.microsoft.com/en-us/azure/architecture/best-practices/performance-testing)

## 📊 Sample Results Interpretation

**Good Results:**
```
Summary Report:
- Samples: 1500
- Average: 450ms
- Min: 120ms
- Max: 1800ms
- Std Dev: 250ms
- Error %: 0.13%
- Throughput: 25.0/sec
```

**Warning Signs:**
```
Summary Report:
- Samples: 1500
- Average: 2500ms      ⚠️ High average
- Min: 150ms
- Max: 15000ms        ⚠️ Very high max
- Std Dev: 2800ms     ⚠️ High variance
- Error %: 4.5%       ⚠️ High error rate
- Throughput: 8.5/sec ⚠️ Low throughput
```

**Action Required:**
- Investigate slow endpoints
- Check for bottlenecks
- Review error logs
- Optimize database queries
- Scale resources if needed
