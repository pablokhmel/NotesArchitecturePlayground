# Unit Test Issues for MVC Target

This document outlines the issues for adding comprehensive unit tests to the NotesMVC target. The MVC target currently has no unit test coverage, and these issues detail what needs to be tested.

## Infrastructure Setup

### Issue #1: Create NotesMVC Unit Test Target
**Priority:** High  
**Labels:** testing, infrastructure, mvc

**Description:**
Set up the basic unit testing infrastructure for the NotesMVC target.

**Tasks:**
- Create a new unit test target in Xcode for NotesMVC
- Configure the test target to link with the NotesMVC app and Core framework
- Add necessary testing frameworks (XCTest)
- Create basic test file structure following iOS conventions
- Verify the test target builds and can run basic tests

**Acceptance Criteria:**
- Unit test target exists and builds successfully
- Can run a simple passing test
- Test target has access to NotesMVC classes marked as `@testable`
- CI/CD pipeline (if exists) runs the tests

---

## View Controller Tests

### Issue #2: Unit Tests for NoteListViewController
**Priority:** High  
**Labels:** testing, view-controller, mvc

**Description:**
Create comprehensive unit tests for `NoteListViewController` to verify its data management, table view configuration, and navigation logic.

**Test Cases to Implement:**
1. **Test Initial State**
   - Verify `notes` array is empty initially
   - Verify table view is configured correctly

2. **Test Data Loading**
   - Test that notes are fetched on `viewDidLoad`
   - Mock `NoteManager.fetchNotes()` to return test data
   - Verify `notes` array is populated with fetched data
   - Verify table view reloads when notes are updated

3. **Test Table View Data Source**
   - Test `numberOfSections` returns 1
   - Test `numberOfRowsInSection` returns correct count based on notes array
   - Test `heightForRowAt` returns 80
   - Test `cellForRowAt` dequeues correct cell type
   - Test cell configuration with note data

4. **Test Navigation**
   - Test `prepare(for:sender:)` for "ShowNoteDetail" segue
   - Verify correct note model is passed to `NoteDetailsViewController`
   - Test "AddNote" segue configuration
   - Verify delegate is set correctly

5. **Test Delete Functionality**
   - Test swipe actions configuration
   - Test `deleteNote(at:)` removes note from array
   - Mock `NoteManager.deleteNote` to verify it's called with correct ID
   - Verify table view is updated after deletion

6. **Test NoteEditorDelegate Implementation**
   - Test `editedNote(_:)` updates correct note in array
   - Verify notes are re-sorted after edit
   - Test `createdNote(_:)` adds note to array
   - Verify notes are re-sorted after creation

**Technical Considerations:**
- Use mocking for `NoteManager` async methods
- Consider using dependency injection to make testing easier
- Test async/await code properly
- Mock `LoadingView` to avoid UI dependencies

**Acceptance Criteria:**
- All test cases pass
- Code coverage for NoteListViewController > 80%
- Tests run quickly (no actual network delays)
- Tests are isolated and don't depend on UserDefaults

---

### Issue #3: Unit Tests for NoteEditorViewController
**Priority:** High  
**Labels:** testing, view-controller, mvc, validation

**Description:**
Create comprehensive unit tests for `NoteEditorViewController` to verify mode handling, validation logic, and save functionality.

**Test Cases to Implement:**
1. **Test Mode Configuration**
   - Test `.add` mode sets title to "New Note"
   - Test `.add` mode clears text fields
   - Test `.edit` mode sets title to note name
   - Test `.edit` mode populates fields with note data
   - Test mode changes update UI correctly

2. **Test Validation - Name Field**
   - Test `validateName()` throws `.nameEmpty` for empty/nil input
   - Test `validateName()` throws `.nameEmpty` for whitespace-only input
   - Test `validateName()` throws `.nameTooShort` for input < 3 characters
   - Test `validateName()` passes for valid input (>= 3 characters)
   - Test name is trimmed of whitespace

3. **Test Validation - Note Field**
   - Test `validateNote()` throws `.noteEmpty` for empty/nil input
   - Test `validateNote()` throws `.noteEmpty` for whitespace-only input
   - Test `validateNote()` throws `.noteTooShort` for input < 5 characters
   - Test `validateNote()` passes for valid input (>= 5 characters)
   - Test note is trimmed of whitespace

4. **Test Save - Add Mode**
   - Test creating new note with valid data
   - Mock `NoteManager.saveNote` to verify it's called
   - Verify delegate's `createdNote` is called with correct note
   - Test navigation controller pops after successful save
   - Test error handling shows alert for validation errors

5. **Test Save - Edit Mode**
   - Test updating existing note with valid data
   - Verify `editedDate` is set to current date
   - Mock `NoteManager.updateNote` to verify it's called
   - Verify delegate's `editedNote` is called with updated note
   - Test navigation controller pops after successful update

6. **Test Error Handling**
   - Test `showErrorAlert` displays correct message for each ValidationError
   - Test LoadingView error callback is triggered on validation failure

**Technical Considerations:**
- Mock delegate to verify callback methods
- Mock NoteManager async operations
- Mock navigation controller to verify navigation
- Test `trimmed(_:)` helper method

**Acceptance Criteria:**
- All test cases pass
- Code coverage for NoteEditorViewController > 85%
- All validation logic is thoroughly tested
- Tests don't depend on actual UI alert presentation

---

### Issue #4: Unit Tests for NoteDetailsViewController
**Priority:** Medium  
**Labels:** testing, view-controller, mvc

**Description:**
Create unit tests for `NoteDetailsViewController` to verify display logic and navigation.

**Test Cases to Implement:**
1. **Test Model Setting**
   - Test `setModel(_:)` stores the note model
   - Test calling `setModel` before view loads works correctly
   - Test calling `setModel` after view loads triggers configuration

2. **Test Configuration**
   - Test title is set to note name
   - Test note text label displays note text
   - Test created date is formatted correctly
   - Test edited date is shown when present
   - Test edited date is hidden when nil
   - Verify `NoteDateFormatter` is used correctly

3. **Test View Lifecycle**
   - Test `configure()` is called on `viewDidLoad`
   - Test `configure()` is called on `viewWillAppear`
   - Test `configure()` handles nil model gracefully

4. **Test Navigation**
   - Test "EditNote" segue configuration
   - Verify editor mode is set to `.edit` with correct model
   - Verify delegate is set on editor view controller

5. **Test NoteEditorDelegate**
   - Test `editedNote(_:)` updates the model
   - Test `editedNote(_:)` propagates to parent delegate
   - Test UI is updated after edit

**Technical Considerations:**
- Mock `NoteDateFormatter` for consistent date testing
- Mock delegate to verify propagation
- Don't test actual label text rendering

**Acceptance Criteria:**
- All test cases pass
- Code coverage for NoteDetailsViewController > 80%
- Tests verify delegation chain works correctly

---

## View Tests

### Issue #5: Unit Tests for NoteListTableViewCell
**Priority:** Medium  
**Labels:** testing, view, mvc

**Description:**
Create unit tests for `NoteListTableViewCell` to verify cell configuration with note data.

**Test Cases to Implement:**
1. **Test Configuration with Full Note Data**
   - Test name label displays note name
   - Test created date label displays formatted created date
   - Test edited date label displays formatted edited date when present
   - Test edited date label is visible when edited date exists

2. **Test Configuration with Note Without Edit Date**
   - Test name label displays note name
   - Test created date label displays formatted created date
   - Test edited date label is hidden when edited date is nil

3. **Test Date Formatting**
   - Verify `NoteDateFormatter` is used correctly
   - Test date format matches expected pattern

**Technical Considerations:**
- Create mock `NoteModel` instances for testing
- Mock `NoteDateFormatter` for predictable output
- Test only logic, not actual UI rendering

**Acceptance Criteria:**
- All test cases pass
- Code coverage for NoteListTableViewCell > 80%
- Tests verify correct data binding

---

### Issue #6: Unit Tests for LoadingView
**Priority:** Medium  
**Labels:** testing, view, mvc, async

**Description:**
Create unit tests for `LoadingView` static methods to verify loading state management and error handling.

**Test Cases to Implement:**
1. **Test Loading View Initialization**
   - Test view is created from NIB correctly
   - Test view constraints are set up properly
   - Test initial alpha is 0

2. **Test `startLoading` - Success Path**
   - Test loading view is added to view hierarchy
   - Test action is executed
   - Test loading view is removed after completion
   - Test alpha animations (show/hide)

3. **Test `startLoading` - Error Path**
   - Test action throwing error triggers `onError` callback
   - Test loading view is removed on error
   - Verify error is passed to error handler

4. **Test View Hierarchy**
   - Test loading view is added to navigation controller view when available
   - Test loading view falls back to window when no nav controller
   - Test loading view falls back to view controller's view when no window
   - Test constraints are set correctly for each case

5. **Test User Interaction**
   - Test loading view blocks user interaction (`isUserInteractionEnabled = true`)

**Technical Considerations:**
- Mock UIViewController and navigation hierarchy
- Test async/await behavior
- Don't test actual animations, test that animation methods are called
- Consider using XCTestExpectation for async tests

**Acceptance Criteria:**
- All test cases pass
- Code coverage for LoadingView > 75%
- Async behavior is tested correctly
- Tests don't depend on actual UI rendering

---

## Protocol Tests

### Issue #7: Unit Tests for NoteEditorDelegate
**Priority:** Low  
**Labels:** testing, protocol, mvc

**Description:**
Create tests to verify `NoteEditorDelegate` protocol and its default implementation.

**Test Cases to Implement:**
1. **Test Default Implementation**
   - Verify default `editedNote(_:)` can be called without error
   - Verify default `createdNote(_:)` can be called without error

2. **Test Protocol Conformance**
   - Create a test class that conforms to protocol
   - Verify both methods are callable
   - Test that conforming types can override defaults

**Technical Considerations:**
- Create mock conforming classes for testing
- This is a simple protocol, so tests should be minimal

**Acceptance Criteria:**
- Protocol behavior is documented with tests
- Default implementations are verified

---

## Core Module Tests (Shared with MVC)

### Issue #8: Unit Tests for NoteModel
**Priority:** High  
**Labels:** testing, core, model

**Description:**
Create unit tests for `NoteModel` struct to verify initialization, Codable conformance, and data integrity.

**Test Cases to Implement:**
1. **Test Initialization**
   - Test creating model with all required parameters
   - Test default values (id is unique UUID, editedDate is nil)
   - Test all properties are set correctly

2. **Test Codable - Encoding**
   - Test encoding to JSON data
   - Verify all properties are encoded
   - Test encoded data can be decoded back

3. **Test Codable - Decoding**
   - Test decoding from JSON data
   - Test all properties are decoded correctly
   - Test UUID consistency after encode/decode cycle

4. **Test Property Mutation**
   - Test `name` can be updated (var)
   - Test `text` can be updated (var)
   - Test `editedDate` can be updated (var)
   - Test `createdDate` cannot be changed (let)
   - Test `id` is consistent after creation

**Acceptance Criteria:**
- All test cases pass
- Code coverage for NoteModel > 90%
- Codable conformance is verified

---

### Issue #9: Unit Tests for NoteManager
**Priority:** High  
**Labels:** testing, core, persistence

**Description:**
Create comprehensive unit tests for `NoteManager` to verify CRUD operations and data persistence.

**Test Cases to Implement:**
1. **Test Fetch Notes**
   - Test fetching notes when UserDefaults is empty returns empty array
   - Test fetching notes returns decoded array from UserDefaults
   - Test corrupted data returns empty array
   - Mock delay to verify async behavior

2. **Test Save Note**
   - Test saving new note adds it to UserDefaults
   - Test saved notes are sorted by date (newest first)
   - Test multiple saves accumulate notes
   - Verify encoding works correctly

3. **Test Update Note**
   - Test updating existing note by ID
   - Test updated note replaces old version
   - Test updating non-existent note does nothing
   - Test notes remain sorted after update

4. **Test Get Note**
   - Test getting note by ID returns correct note
   - Test getting non-existent ID returns nil
   - Test getting from empty storage returns nil

5. **Test Delete Note**
   - Test deleting note by ID removes it
   - Test deleting non-existent note does nothing
   - Test deleting from empty storage does nothing
   - Verify remaining notes are still sorted

6. **Test Sorting Logic**
   - Test notes sorted by editedDate when present
   - Test notes sorted by createdDate when editedDate is nil
   - Test mixed notes (some with editedDate, some without) sort correctly
   - Test sorting is consistent across all operations

7. **Test Concurrency**
   - Test multiple concurrent operations don't corrupt data
   - Verify async/await is used correctly

**Technical Considerations:**
- Mock or clear UserDefaults before each test
- Use a test-specific UserDefaults suite to avoid affecting real data
- Test async methods properly with async/await
- Consider removing/mocking the artificial delay for faster tests

**Acceptance Criteria:**
- All test cases pass
- Code coverage for NoteManager > 85%
- Tests are isolated and don't affect production data
- Tests run quickly (delays are mocked or minimal)

---

### Issue #10: Unit Tests for NoteDateFormatter
**Priority:** Medium  
**Labels:** testing, core, formatting

**Description:**
Create unit tests for `NoteDateFormatter` to verify date formatting logic.

**Test Cases to Implement:**
1. **Test Created Date Formatting**
   - Test `createdDate(from:)` returns correct format
   - Verify format is "Created: dd.MM.yyyy, hh:mm"
   - Test with various dates
   - Test timezone handling

2. **Test Updated Date Formatting**
   - Test `updatedDate(from:)` returns correct format
   - Verify format is "Updated: dd.MM.yyyy, hh:mm"
   - Test with various dates
   - Test timezone handling

3. **Test Date Format Consistency**
   - Verify both methods use the same DateFormatter
   - Test that format string is correctly applied

**Technical Considerations:**
- Use fixed dates for predictable testing
- Consider timezone differences in CI environments
- Test edge cases (very old dates, future dates)

**Acceptance Criteria:**
- All test cases pass
- Code coverage for NoteDateFormatter > 90%
- Date format is verified to match specification

---

### Issue #11: Unit Tests for ValidationError
**Priority:** Medium  
**Labels:** testing, core, validation

**Description:**
Create unit tests for `ValidationError` enum to verify error messages.

**Test Cases to Implement:**
1. **Test Error Messages**
   - Test `.nameEmpty` returns "Name cannot be empty"
   - Test `.nameTooShort(min: 3)` returns "Name must be at least 3 characters"
   - Test `.noteEmpty` returns "Note cannot be empty"
   - Test `.noteTooShort(min: 5)` returns "Note must be at least 5 characters"
   - Test various min values produce correct message format

2. **Test Error Type**
   - Verify all cases conform to Error protocol
   - Test errors can be thrown and caught

**Acceptance Criteria:**
- All test cases pass
- Code coverage for ValidationError > 95%
- All error messages are verified

---

## Integration Tests

### Issue #12: Integration Tests for MVC Data Flow
**Priority:** Medium  
**Labels:** testing, integration, mvc

**Description:**
Create integration tests that verify the complete data flow in the MVC target from view controllers through to Core module.

**Test Cases to Implement:**
1. **Test Complete Note Creation Flow**
   - Start in NoteListViewController
   - Trigger add note
   - Fill in NoteEditorViewController with valid data
   - Save note
   - Verify note appears in list
   - Verify note is persisted in NoteManager

2. **Test Complete Note Edit Flow**
   - Start with existing note in list
   - Navigate to details
   - Edit note
   - Save changes
   - Verify changes reflected in list
   - Verify changes persisted

3. **Test Complete Note Delete Flow**
   - Start with existing note
   - Delete note
   - Verify note removed from list
   - Verify note removed from persistence

4. **Test Validation Integration**
   - Attempt to save invalid note
   - Verify error is shown
   - Verify note is not saved
   - Verify can correct and save

**Technical Considerations:**
- Use real Core module (not mocked) for integration tests
- Use test UserDefaults suite
- Clean up after each test
- May be slower than unit tests due to real async operations

**Acceptance Criteria:**
- All integration tests pass
- Tests verify complete workflows
- Tests clean up properly
- Tests are independent

---

## Test Documentation

### Issue #13: Create Testing Documentation
**Priority:** Low  
**Labels:** documentation, testing

**Description:**
Create comprehensive documentation for the test suite.

**Tasks:**
- Create README.md in test directory explaining test structure
- Document how to run tests (Xcode, command line)
- Document mocking strategy and patterns used
- Document test data factories/helpers
- Add code coverage goals
- Document CI/CD integration for tests

**Acceptance Criteria:**
- Documentation is clear and complete
- New developers can understand and run tests
- Testing patterns are documented

---

## Summary

**Total Issues:** 13

**Priority Breakdown:**
- High Priority: 5 issues (#1, #2, #3, #8, #9)
- Medium Priority: 7 issues (#4, #5, #6, #7, #10, #11, #12)
- Low Priority: 1 issue (#13)

**Recommended Implementation Order:**
1. Issue #1 - Infrastructure setup (required for all other tests)
2. Issue #8, #9, #10, #11 - Core module tests (foundation)
3. Issue #2, #3, #4 - View controller tests (main logic)
4. Issue #5, #6 - View tests
5. Issue #7 - Protocol tests
6. Issue #12 - Integration tests (after unit tests complete)
7. Issue #13 - Documentation

**Estimated Effort:**
- Infrastructure: 2-4 hours
- Core module tests: 6-8 hours
- View controller tests: 10-12 hours
- View tests: 3-4 hours
- Protocol tests: 1-2 hours
- Integration tests: 4-6 hours
- Documentation: 2-3 hours
- **Total: ~28-39 hours**

**Code Coverage Goal:** 80%+ overall coverage for the MVC target
