# HEHEHUB

This repo now uses a local, readable main script instead of remote `loadstring(game:HttpGet(...))()` chains.

## Entry Points

- `HEHEHUB.lua`
  The main script. This is the file to maintain and run.
- `HEHEHUB_load.lua`
  A compatibility launcher that only shows a local notice.
- `HEHEHUBPre.lua`
  Legacy bootstrap placeholder.
- `HEHEHUB_Loading_UI`
  Legacy bootstrap placeholder.

## What Changed

- Removed remote GitHub code execution from the bootstrap files.
- Replaced the obfuscated main file with a readable local hub script.
- Kept the project safe to review and easier to maintain.

## Next Steps

- Move any real game-specific features into `HEHEHUB.lua` in plain Lua.
- Delete unused legacy files once you no longer need compatibility placeholders.
