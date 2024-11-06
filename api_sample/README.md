# REST API template

This directory contains numerous JSON files for data exchange via REST.

All JSON files contain comment that ensure **JSON with Comments** is selected in "Language mode" if using VSCode.
Normally, it will apply automatically as I pushed VSCode workspace configuration already (`.vscode/` at the root of this repo)
and ensure this configuration exists in `.vscode/settings.json`:

```json
{
    "files.associations": {
        "**/api_sample/**/*.json": "jsonc"
    }
}
```
