# Development
We use a Feature-Driven Development Strategy that ensures that all our code is modular and seperated.
This allows as to develop and test each feature seperately and in parallel.

# Testing Strategy
We use Bottom up testing as we believe that mocks slow down development process. 

# Types of Tests

- Widget Tests - Flutter Widget Test Package
- e2e Tests Maestro
- Integration Tests - Flutter Integration Test package
- API Testing - Pytest
- Coverage - Sonarcube
- Load Testing - k6

# Rules
- All features are to be committed alongside tests, otherwise they won't be merged.
- Do not use artificial intelligence to generate tests themselves (however you may use it to give you ideas about need testing)
