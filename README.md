# xmake Task Resolution Issue Reproduction

## Issue Description

This issue demonstrates a bug in xmake's parameter validation system. When a custom task defines a parameter name that conflicts with xmake's built-in options (like "file" conflicting with `-F/--file`), xmake should either warn the user or throw an error during task definition. Instead, it silently accepts the conflicting parameter name and causes unpredictable runtime failures.

## Project Structure

```
.
├── xmake.lua           # Root config with includes("a/b")
├── a/
│   └── b/
│       ├── xmake.lua   # Contains custom task "run_main" with "file" parameter
│       └── c/
│           ├── xmake.lua   # Target definition for "main"
│           └── main.cpp    # Simple Hello World program
└── run.sh              # Test script
```

## Expected Behavior

The custom task `run_main` should accept a `file` parameter and work consistently across different directory contexts.

## Actual Behavior

### Test Results

1. **✅ Success**: `xmake run_main a/b/c.cpp` (from root directory)
   - Works correctly, builds and runs the target

2. **✅ Success**: `xmake run_main b/c.cpp` (from `a/` directory)  
   - Works correctly, builds and runs the target

3. **❌ Failure**: `xmake run_main a/b/c.cpp` (from root directory, second execution)
   - **Error**: `invalid task: run_main`
   - The custom task is not recognized even though it worked in step 1

## Root Cause Analysis

The issue is caused by inadequate parameter validation in xmake's task definition system:

1. **Parameter name conflict**: Custom task parameter `{nil, "file", "v", nil, "test arg"}` conflicts with xmake's built-in `-F/--file` option
2. **Missing validation**: xmake doesn't validate parameter names against built-in options during task definition

## Expected behavior

xmake should handle parameter name conflicts in one of two ways:

- Prohibit parameter override: throw an error with a clear message about the conflict
- Allow custom task parameters to override built-in options, with the built-in options no longer functioning for that task

## Technical Details

- **xmake version**: 3.0.0+20250615
- **Platform**: macOS (arm64)

## Reproduction Steps

```bash
./run.sh
```

See [action logs](https://github.com/YouXam/xmake-issue-reproduction/actions/runs/16264085953/job/45915740166).