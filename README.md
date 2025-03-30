# PLAN Interpreter

## Author
**Shristi Keshri**

## Overview
This project is an interpreter for the PLAN functional language, implemented in Scheme. It includes a set of functions to execute and test various cases for the language.

## Execution Instructions
Follow these steps to run the interpreter and test the functions:

1. **Make the test script executable**
   ```sh
   chmod +x TestMyfns.scm
   ```

2. **Run the test script**
   ```sh
   ./TestMyfns.scm
   ```

3. **Start Scheme48**
   ```sh
   scheme48
   ```

4. **Load the main function definitions**
   ```scheme
   (load "myfns.scm")
   ```

5. **Load the test cases**
   ```scheme
   (load "cases.scm")
   ```

6. **Run a test case** (replace `x` with a number between 1 and 14)
   ```scheme
   (test x)
   ```

7. **Load additional test cases**
   ```scheme
   (load "extra.scm")
   ```

8. **Run an extra test case** (replace `x` with a number between 1 and 4)
   ```scheme
   (test x)
   ```

## Notes
- Ensure Scheme48 is installed on your system before running the interpreter.
- The test cases in `cases.scm` cover the primary functionalities, while `extra.scm` provides additional test scenarios.
- If encountering any errors, verify that all required files are in the same directory and properly formatted.



