#!/usr/bin/env sh
set -eu

# Generated from personwise-cli-bootstrap-model.json and the signed v1.0.1
# release manifest. Embedded trust root: RWQxXCGcBkNBLF/3q1BbM7xZmDxbaY53bjJYcruIuTbK5DYVm+Nm1ztO
action="${1:-}"
case "$action" in
  --approve-install|--approve-upgrade|--approve-rollback) ;;
  *)
  echo '{"schema_version":"1","ok":false,"error":{"code":"INSTALL_APPROVAL_REQUIRED","message":"Explicit user approval is required before installing, upgrading, or rolling back the PersonWise executable.","retryable":false,"action":"obtain_user_approval"},"request_id":"bootstrap-local"}' >&2
  exit 2
  ;;
esac

sha256_file() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | awk '{print $1}'
  elif command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$1" | awk '{print $1}'
  else
    echo "A SHA-256 verification tool is required." >&2
    exit 6
  fi
}

platform="$(uname -s)/$(uname -m)"
case "$platform" in
  "Linux/x86_64")
    artifact="personwise_1.0.1_linux_amd64.tar.gz"
    expected_size="3059156"
    expected_sha256="7a439f59b1279e5d717b4caaf36fc0cbf94e93cce276251085c91b3023fccbca"
    native_signature_status="not-applicable"
    native_signature_required="false"
    native_identity=""
    expected_executable_sha256="72daf39da8c5eed46adcab5a20c56cd62b1a58ab0a0f3b44722dd3f05eec6f19"
    allowed_upgrade_hashes="df428672b97a9478d3e66fd3672bcf08ffeff2ebe49bcce27b67dc7d1928bad3"
    allowed_rollback_hashes=""
    ;;
  "Linux/arm64")
    artifact="personwise_1.0.1_linux_arm64.tar.gz"
    expected_size="2750712"
    expected_sha256="a359d0fa5566a40859a1f8ea530f2ecd490f3f551ae4bc94bc8db24e22921a27"
    native_signature_status="not-applicable"
    native_signature_required="false"
    native_identity=""
    expected_executable_sha256="96dc5b038e6c81f265bd96ca7933cfb22ffdf0feed05b2785a003ef83d0c467e"
    allowed_upgrade_hashes="74a26677ebcda9cd173c0f3bca587d8733e8c302054fae8f5f051ab5e057ff35"
    allowed_rollback_hashes=""
    ;;
  "Darwin/x86_64")
    artifact="personwise_1.0.1_darwin_amd64.tar.gz"
    expected_size="3081589"
    expected_sha256="3ce9d7e57e486e191b9d67c20cae54e470bc1c74ba1e4832422ef2c8a1dffab3"
    native_signature_status="deferred-founder-approved"
    native_signature_required="false"
    native_identity=""
    expected_executable_sha256="724918b9a9053d053c7904cf0216fa35926246a052e4faa9b3b4298eb1939cd7"
    allowed_upgrade_hashes="fadbebceff3fc29c598dd50056a6440a1387f8f91fe61b9dfa6a0989d1e5ccaa"
    allowed_rollback_hashes=""
    ;;
  "Darwin/arm64")
    artifact="personwise_1.0.1_darwin_arm64.tar.gz"
    expected_size="2832391"
    expected_sha256="73000280ab0cbf3fbb82a2018584bc0c8c4aacd14ad67d1893c76c5f4f3c162c"
    native_signature_status="deferred-founder-approved"
    native_signature_required="false"
    native_identity=""
    expected_executable_sha256="1b559f84c6bc141f9f2aa33594f96f5f4a686c83ae981a91137258c9d0acf343"
    allowed_upgrade_hashes="70966e67c279a30c43804ff98325415c4568420128ea6f3ac29fceac88fd30c9"
    allowed_rollback_hashes=""
    ;;
  *) echo '{"schema_version":"1","ok":false,"error":{"code":"UNSUPPORTED_TARGET","message":"This operating-system target is not supported.","retryable":false,"action":"use_supported_target"},"request_id":"bootstrap-local"}' >&2; exit 9 ;;
esac

if [ "$(uname -s)" = "Darwin" ] && [ "$native_signature_required" = "true" ] && [ "$native_signature_status" != "verified" ]; then
  echo '{"schema_version":"1","ok":false,"error":{"code":"NATIVE_SIGNATURE_REQUIRED","message":"This release candidate has not completed Apple signing and notarization.","retryable":false,"action":"use_verified_release"},"request_id":"bootstrap-local"}' >&2
  exit 9
fi

if [ "$(uname -s)" = "Linux" ]; then
  target_dir="${XDG_BIN_HOME:-${HOME}/.local/bin}"
else
  target_dir="${HOME}/.local/bin"
fi
target_path="$target_dir/personwise"
case "$target_dir" in
  /*) ;;
  *) echo "Install directory must be an absolute path." >&2; exit 6 ;;
esac
control_free_target_dir="$(printf '%s' "$target_dir" | LC_ALL=C tr -d '[:cntrl:]')"
case "$target_dir" in
  *'\'*|*'"'*)
    echo "Install directory contains characters that cannot be reported safely." >&2
    exit 6
    ;;
esac
if [ "$control_free_target_dir" != "$target_dir" ]; then
  echo "Install directory contains control characters." >&2
  exit 6
fi
if [ ! -d "$target_dir" ]; then
  mkdir -m 700 -p "$target_dir"
fi
if [ -L "$target_dir" ]; then
  echo "Install directory must not be a symbolic link." >&2
  exit 6
fi
target_dir_identity="$(ls -id "$target_dir")" || exit 6
current_sha256=""
if [ -e "$target_path" ] || [ -L "$target_path" ]; then
  if [ "$action" = "--approve-install" ] || [ ! -f "$target_path" ] || [ -L "$target_path" ]; then
    echo '{"schema_version":"1","ok":false,"error":{"code":"INSTALL_TARGET_OCCUPIED","message":"The target path is occupied by an unrecognized installation; it was not changed.","retryable":false,"action":"inspect_existing_installation"},"request_id":"bootstrap-local"}' >&2
    exit 5
  fi
  current_sha256="$(sha256_file "$target_path")"
  if [ "$action" = "--approve-upgrade" ]; then allowed_hashes="$allowed_upgrade_hashes"; else allowed_hashes="$allowed_rollback_hashes"; fi
  case " $allowed_hashes " in
    *" $current_sha256 "*) ;;
    *)
      echo '{"schema_version":"1","ok":false,"error":{"code":"INSTALL_TARGET_OCCUPIED","message":"The existing executable is not recognized by the signed release history; it was not changed.","retryable":false,"action":"inspect_existing_installation"},"request_id":"bootstrap-local"}' >&2
      exit 5
      ;;
  esac
elif [ "$action" != "--approve-install" ]; then
  echo '{"schema_version":"1","ok":false,"error":{"code":"INSTALL_TARGET_MISSING","message":"An approved upgrade or rollback requires a recognized existing installation.","retryable":false,"action":"install_verified_release"},"request_id":"bootstrap-local"}' >&2
  exit 5
fi
work_dir="$(mktemp -d "$target_dir/.personwise-install.XXXXXX")"
cleanup() { rm -rf "$work_dir"; }
trap cleanup EXIT HUP INT TERM
archive="$work_dir/$artifact"
url="https://releases.personwise.ai/cli/v1.0.1/$artifact"

curl --disable --fail --silent --show-error --proto '=https' --tlsv1.2   --connect-timeout 10 --max-time 300 --max-filesize "26214400"   --output "$archive" "$url"
actual_size="$(wc -c < "$archive" | tr -d ' ')"
if [ "$actual_size" != "$expected_size" ] || [ "$actual_size" -gt "26214400" ]; then
  echo "Downloaded artifact size mismatch." >&2
  exit 6
fi
actual_sha256="$(sha256_file "$archive")"
if [ "$actual_sha256" != "$expected_sha256" ]; then
  echo "Downloaded artifact checksum mismatch." >&2
  exit 6
fi

extract_dir="$work_dir/extracted"
mkdir "$extract_dir"
entries="$(tar -tzf "$archive")"
if [ "$entries" != "personwise
LICENSE
THIRD_PARTY_NOTICES.md" ]; then
  echo "Release archive contents are invalid." >&2
  exit 6
fi
tar -xzf "$archive" -C "$extract_dir"
candidate="$extract_dir/personwise"
if [ ! -f "$candidate" ] || [ -L "$candidate" ]; then
  echo "Release executable is invalid." >&2
  exit 6
fi
if [ "$(sha256_file "$candidate")" != "$expected_executable_sha256" ]; then
  echo "Release executable checksum mismatch." >&2
  exit 6
fi
chmod 700 "$candidate"
if [ "$(uname -s)" = "Darwin" ] && [ "$native_signature_status" = "verified" ]; then
  codesign --verify --deep --strict --verbose=2 "$candidate"
  spctl --assess --type execute --verbose=2 "$candidate"
  actual_identity="$(codesign -dv --verbose=4 "$candidate" 2>&1 | sed -n 's/^Authority=//p' | head -1)"
  if [ -z "$native_identity" ] || [ "$actual_identity" != "$native_identity" ]; then
    echo "Apple signing identity mismatch." >&2
    exit 6
  fi
fi
if [ -L "$target_dir" ] || [ ! -d "$target_dir" ] || [ "$(ls -id "$target_dir")" != "$target_dir_identity" ]; then
  echo "Install directory changed during verification; no executable was installed." >&2
  exit 5
fi
if [ "$action" = "--approve-install" ]; then
  if ! ln "$candidate" "$target_path"; then
    echo "Install target became occupied; it was not replaced." >&2
    exit 5
  fi
  rm "$candidate"
else
  if [ ! -f "$target_path" ] || [ -L "$target_path" ] || [ "$(sha256_file "$target_path")" != "$current_sha256" ]; then
    echo "Existing installation changed during verification; it was not replaced." >&2
    exit 5
  fi
  mv -f "$candidate" "$target_path"
fi
printf '{"schema_version":"1","ok":true,"data":{"path":"%s","software_version":"1.0.1","cli_contract_version":"1.0","action":"%s"},"request_id":"bootstrap-local"}
' "$target_path" "$action"
