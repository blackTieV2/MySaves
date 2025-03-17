## Simple Batch file to bypass UAC Admin for installing programs in Windows. 

### Version 1

```bash
Set __COMPAT_LAYER=RUNASINVOKER
Start demo.exe ; Name of the PE that you want to install
```

### Version 2

```bash
cmd /min /C "set __COMPAT_LAYER=RUNASINVOKER && start "" %1"
```


### Version 3

```batch
@echo off
REM Check if an argument was provided
if "%~1"=="" (
    echo Error: No target executable specified.
    goto :eof
)

REM Check if the file exists
if not exist "%~1" (
    echo Error: The file "%~1" does not exist.
    goto :eof
)

REM Set the compatibility layer to bypass elevation prompts
set __COMPAT_LAYER=RUNASINVOKER

REM Launch the executable with all provided arguments
start "" "%~1" %*
if errorlevel 1 (
    echo Error: Failed to launch "%~1".
) else (
    echo Successfully launched "%~1".
)
```

### Explanation of Enhancements

- **Parameter Validation:**  
  The script now checks if `%~1` is empty and if the specified file exists before proceeding.

- **Proper Quoting:**  
  `%~1` removes any surrounding quotes that might interfere with path processing, and the path is re-quoted to preserve spaces.

- **Error Handling and Logging:**  
  After attempting to launch the executable with `start`, the script checks the error level to provide a message indicating success or failure.

- **Support for Additional Arguments:**  
  Using `%*` passes any additional arguments supplied to the batch file along with the target executable.

Implementing these improvements makes the script safer, more reliable, and user-friendly while retaining the core functionality of running an executable under the `RUNASINVOKER` compatibility layer.
