# Postman Integration Test Suite

This directory contains comprehensive integration tests for the FakeRestAPI application.

## 📋 Test Suite Overview

### Test Collections
- **StarterAPIs.json**: Main test collection with Data Validation and Regression tests
- **TestEnvironment.json**: Environment configuration file

### Test Categories

#### 1. Data Validation Tests
These tests validate the structure, format, and integrity of API responses:

- **Get All Activities - Data Validation**: Validates response structure, data types, and required fields
- **Get Activity by ID - Data Validation**: Validates single activity retrieval and ID matching
- **Create Activity - Data Validation**: Validates POST operations and data persistence
- **Get All Books - Data Validation**: Validates books endpoint data structure
- **Get All Authors - Data Validation**: Validates authors endpoint data structure
- **Update Activity - Data Validation**: Validates PUT operations and data updates

**Key Validations:**
- ✅ Status code checks (200, 201)
- ✅ Response time validation (< 2000ms)
- ✅ Content-Type verification
- ✅ Response body structure validation
- ✅ Data type validation (number, string, boolean)
- ✅ Required fields presence
- ✅ Data persistence validation

#### 2. Regression Tests
These tests ensure existing functionality continues to work after changes:

- **Get All Activities - Regression**: Ensures endpoint stability and backward compatibility
- **Get All Books - Regression**: Validates books endpoint consistency
- **Get All Authors - Regression**: Ensures authors endpoint structure unchanged
- **Get All Users - Regression**: Validates users endpoint stability
- **Get All CoverPhotos - Regression**: Ensures cover photos endpoint functionality
- **CRUD Operations - Regression**: Validates POST operations stability
- **Delete Activity - Regression**: Ensures DELETE operations work correctly

**Key Checks:**
- ✅ API availability and responsiveness
- ✅ Backward compatibility of data structures
- ✅ Response time performance
- ✅ CRUD operations functionality
- ✅ Error handling consistency

## 🚀 Running the Tests

### Option 1: Using Postman GUI

1. **Import Collection:**
   - Open Postman
   - Click "Import" → Select `StarterAPIs.json`

2. **Import Environment:**
   - Click "Import" → Select `TestEnvironment.json`

3. **Configure Environment:**
   - Select "FakeRestAPI Test Environment" from the environment dropdown
   - Update `baseUrl` variable with your Azure App Service URL:
     ```
     https://your-app-service-name.azurewebsites.net
     ```

4. **Run Tests:**
   - Select the collection
   - Click "Run" to open Collection Runner
   - Select the environment
   - Click "Run FakeRestAPI - Integration Test Suite"

### Option 2: Using Newman (Postman CLI)

#### Installation

```bash
npm install -g newman
npm install -g newman-reporter-htmlextra
```

#### Run Tests

```bash
# Run with console output
newman run automatedtesting/postman/StarterAPIs.json \
  --environment automatedtesting/postman/TestEnvironment.json \
  --env-var "baseUrl=https://your-app-service-name.azurewebsites.net"

# Run with HTML report
newman run automatedtesting/postman/StarterAPIs.json \
  --environment automatedtesting/postman/TestEnvironment.json \
  --env-var "baseUrl=https://your-app-service-name.azurewebsites.net" \
  --reporters cli,htmlextra \
  --reporter-htmlextra-export ./test-results/postman-report.html
```

#### Run in Azure DevOps Pipeline

```yaml
- script: |
    npm install -g newman
    newman run $(System.DefaultWorkingDirectory)/automatedtesting/postman/StarterAPIs.json \
      --environment $(System.DefaultWorkingDirectory)/automatedtesting/postman/TestEnvironment.json \
      --env-var "baseUrl=$(appServiceUrl)" \
      --reporters cli,junit \
      --reporter-junit-export $(Build.ArtifactStagingDirectory)/postman-results.xml
  displayName: 'Run Postman Integration Tests'

- task: PublishTestResults@2
  inputs:
    testResultsFormat: 'JUnit'
    testResultsFiles: '$(Build.ArtifactStagingDirectory)/postman-results.xml'
    testRunTitle: 'Postman Integration Tests'
```

## 📊 Test Results Interpretation

### Success Criteria
- ✅ All status code validations pass
- ✅ Response times are within acceptable limits
- ✅ Data structures match expected schemas
- ✅ No backward compatibility breaks
- ✅ All CRUD operations work correctly

### Common Issues

**Issue: Status code 404**
- Solution: Verify the `baseUrl` is correct and the API is deployed

**Issue: Timeout errors**
- Solution: Check API performance and increase timeout in tests if needed

**Issue: Data validation failures**
- Solution: Review API response structure changes and update tests accordingly

## 🔧 Customization

### Adding New Tests

1. Open `StarterAPIs.json` in Postman
2. Add request to appropriate folder (Data Validation or Regression Tests)
3. Add test scripts in the "Tests" tab
4. Export the collection

### Modifying Test Assertions

Tests use the Postman testing framework (Chai assertions):

```javascript
// Status code validation
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});

// Response time validation
pm.test("Response time is acceptable", function () {
    pm.expect(pm.response.responseTime).to.be.below(2000);
});

// Data structure validation
pm.test("Has required field", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData).to.have.property('id');
});
```

## 📈 Test Coverage

| Endpoint | Data Validation | Regression | CRUD |
|----------|----------------|------------|------|
| Activities | ✅ | ✅ | ✅ |
| Books | ✅ | ✅ | - |
| Authors | ✅ | ✅ | - |
| Users | - | ✅ | - |
| CoverPhotos | - | ✅ | - |

## 🔗 API Endpoints Tested

- `GET /api/Activities` - Retrieve all activities
- `GET /api/Activities/{id}` - Retrieve specific activity
- `POST /api/Activities` - Create new activity
- `PUT /api/Activities/{id}` - Update activity
- `DELETE /api/Activities/{id}` - Delete activity
- `GET /api/Books` - Retrieve all books
- `GET /api/Authors` - Retrieve all authors
- `GET /api/Users` - Retrieve all users
- `GET /api/CoverPhotos` - Retrieve all cover photos

## 📝 Notes

- Tests are designed to run independently without dependencies
- Environment variables are used for dynamic values
- Tests include both positive and negative scenarios
- All tests include detailed assertions with clear failure messages
- Response time validations ensure performance requirements are met
