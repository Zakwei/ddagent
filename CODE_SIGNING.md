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

### Applying to the SignPath Foundation program

The certificate is issued to **SignPath Foundation** (not to a person), so the
publisher identity is the Foundation and it vouches that binaries were built
from this repository. Apply at <https://signpath.org/apply.html>.

**Repository requirements** (checked during review — see
[Foundation terms](https://signpath.org/terms.html)):

- OSI-approved license, no commercial dual-licensing — this repo qualifies
  (`LICENSE` = AGPL-3.0).
- Public source repository; the signing team must own the repo. (If the repository
  was initially private during early development, make it public before submitting
  the application).
- Project already released in the form to be signed (existing GitHub Releases
  with the `.exe`).
- Download page / README describes what the app is and where to get it.
- No malware, no hacking/exploit tooling, no proprietary components.

**Application form asks for:**

1. Repository URL (primary source of truth).
2. License name (AGPL-3.0, plus a pointer to the `LICENSE` file).
3. Download/release URL (GitHub Releases page).
4. Short project description: what it is, who it's for, which artifacts are
   distributed (`exe` NSIS installer).

After approval you get a SignPath.io organization linked to the project, then
continue with the one-time setup below.

### Setup (one-time):

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

The workflow submits the unsigned NSIS `.exe` to SignPath via an Actions
artifact and waits for the signed binary, updating the draft release asset
and `latest.yml` metadata.

**How verification and signing work per release:**

1. Push a `v*` tag (via `npm run release:desktop -- <x.y.z>`; the workflow
   fails if tag ≠ `package.json` version).
2. `desktop-release.yml` builds the **unsigned** NSIS installer (PFX creds
   are unset when SignPath handles signing).
3. `actions/upload-artifact@v4` uploads the unsigned `.exe`, and
   `signpath/github-action-submit-signing-request@v1` submits the signing request
   with `signing-policy-slug: release-signing` and
   `artifact-configuration-slug: nsis-installer`, then blocks
   (`wait-for-completion: true`, up to 600s / 10 minutes timeout matching
   `timeout-minutes: 10` on the step).
4. SignPath verifies the request against the policy: request origin (CI only,
   from the linked repo), artifact configuration match, and — if the policy
   has a human approver — manual approval in the SignPath console.
5. The workflow automatically validates the Authenticode signature of the
   downloaded binary using PowerShell's `Get-AuthenticodeSignature` (confirming
   `Status === 'Valid'`). If verification passes, `latest.yml` hash and file
   size are recomputed, and both the signed `.exe` and updated `latest.yml` are
   uploaded with `--clobber` to the GitHub draft release.

Non-tag builds (workflow_dispatch) skip the SignPath step entirely — unsigned
artifacts stay on the workflow run only.

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

## Open Source Compliance & Third-Party Notices

In accordance with open-source licensing requirements (AGPL-3.0, MIT, Apache 2.0, BSD),
releases include both the root project `LICENSE` and bundled package license texts in
`THIRD_PARTY_NOTICES.md`. This file is generated via `npm run licenses:generate` and
packaged directly into desktop release installers and server bundles.
