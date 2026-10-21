# Package builds

This branch only holds the build of the FluentFTP package from a pinned commit of this fork, and the workflow that
publishes it as a release:

- `build.sh`: clones this fork, checks out the pinned commit (verified) and runs `dotnet pack` on
  `FluentFTP/FluentFTP.csproj`.
- `.github/workflows/release.yml`: runs `build.sh` when it changes on this branch and publishes release `v<version>`
  with the `.nupkg`, `SHA256SUMS.txt` and a build provenance attestation
  (`gh attestation verify FluentFTP.<version>.nupkg --repo muller-camille/fluentftp`).

To publish a new build, change the pinned commit and version in `build.sh`.
