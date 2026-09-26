# Code signing

## macOS

Electron-builder signs and notarizes the `.dmg` automatically when these
repo secrets are set:

| Secret | Description |
|--------|-------------|
| `CSC_LINK` | Base64-encoded `.p12` Developer ID certificate |
| `CSC_KEY_PASSWORD` | Password for the `.p12` |
| `APPLE_ID` | Apple ID email used for notarization |
| `APPLE_APP_SPECIFIC_PASSWORD` | App-specific password for that Apple ID |
| `APPLE_TEAM_ID` | 10-character Apple Developer Team ID |

When any of these are absent (forks, local builds), the workflow disables
identity discovery (`CSC_IDENTITY_AUTO_DISCOVERY=false`) and patches
`mac.notarize` to `false` — the build succeeds and produces an ad-hoc
signed (unsigned) `.dmg`.

## Windows

Two strategies, evaluated in priority order:

### 1. SignPath (preferred, free for open-source projects)

[SignPath.io](https://signpath.io) provides free code signing for OSS projects.
No certificate purchase needed — SignPath manages the EV cert.

**Setup (one-time):**

1. Register at <https://signpath.io> → create an Organization.
2. Link your GitHub repo under **Projects** → create a project.
3. In the project, create:
   - An **Artifact configuration** named `nsis-installer` targeting the `.exe` file.
   - A **Signing policy** named `release-signing` (CI signing, automatic approval or
     with a human approver step for extra security).
4. Generate an **API token** with *Submit Signing Request* permission.
5. Add three repo secrets:

| Secret | Value |
|--------|-------|
| `SIGNPATH_API_TOKEN` | API token from step 4 |
| `SIGNPATH_ORGANIZATION_ID` | UUID shown in SignPath org settings |
| `SIGNPATH_PROJECT_SLUG` | Short slug of your SignPath project |

The workflow submits the unsigned NSIS `.exe` to SignPath and waits for the
signed artifact, replacing the file in `release/desktop/` before it is
uploaded to the GitHub release.

**Important:** SignPath signing only runs on tag builds (`github.ref_type == 'tag'`).
Branch/dispatch builds produce unsigned artifacts (workflow runs only).

### 2. Classic PFX certificate (CSC_LINK)

If you have a purchased code-signing certificate in `.pfx` format:

```bash
# Encode the .pfx
base64 -i my-cert.pfx | pbcopy   # macOS
```

| Secret | Value |
|--------|-------|
| `CSC_LINK` | Base64-encoded `.pfx` |
| `CSC_KEY_PASSWORD` | PFX password |

Electron-builder picks these up automatically. When `SIGNPATH_API_TOKEN` is
also set, **SignPath takes priority** and CSC_LINK is ignored for Windows.

### 3. No secrets (unsigned)

When neither SignPath nor CSC_LINK secrets are present the installer ships
unsigned. Windows SmartScreen shows "Windows protected your PC" on first
install; users click **More info → Run anyway**. SmartScreen reputation builds
over time as more users install the signed or unsigned build.

## Linux

AppImage and `.deb` packages are not Authenticode-signed (no OS mechanism).
GPG detached signatures (`.asc`) can be added as a separate release step if
needed — out of scope here.

## Local development

None of the signing steps run locally. `electron-builder` without
`CSC_LINK`/`CSC_KEY_PASSWORD` env vars produces an unsigned artifact on all
platforms, which is fine for development and testing.
