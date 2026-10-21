#!/usr/bin/env bash
# FluentFTP package built from the pinned commit of this fork, verified after the clone. The package version is the
# one of FluentFTP/FluentFTP.csproj at that commit.
#
# Output in out/: FluentFTP.<version>.nupkg. The release workflow publishes it as release "v<version>".
set -euo pipefail

repository=https://github.com/muller-camille/fluentftp
commit=4b28b5695878cd9ecc2cd3b0669a5a56a416bf5e
version=55.1.1-zillaterm.1

root=$(cd "$(dirname "$0")" && pwd)
out="$root/out"

if [ "${1:-}" = "--tag" ]; then
  echo "v$version"
  exit 0
fi
if [ "${1:-}" = "--commit" ]; then
  echo "$commit"
  exit 0
fi

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
git clone --quiet "$repository" "$work/fluentftp"
git -C "$work/fluentftp" checkout --quiet --detach "$commit"
test "$(git -C "$work/fluentftp" rev-parse HEAD)" = "$commit"

rm -rf "$out"
# The project packs on build in Release; dotnet pack does it once, after building every target framework.
dotnet pack "$work/fluentftp/FluentFTP/FluentFTP.csproj" -c Release -p:GeneratePackageOnBuild=false -o "$out"
test -f "$out/FluentFTP.$version.nupkg"
echo "FluentFTP $version: built from $repository at commit $commit."
