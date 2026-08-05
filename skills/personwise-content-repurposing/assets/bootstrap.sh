#!/usr/bin/env sh
set -eu

# Generated from personwise-cli-bootstrap-model.json and the signed v1.1.3
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
    artifact="personwise_1.1.3_linux_amd64.tar.gz"
    expected_size="3143710"
    expected_sha256="129f9d5d8436a0296a41d0534514bbe51d3c3838f9c2381ba6b46060a8a0f723"
    native_signature_status="not-applicable"
    native_signature_required="false"
    native_identity=""
    expected_executable_sha256="62a63aa9801268238306e3752c53843e123509ee0a1da73145ca6ce234fcd214"
    allowed_upgrade_hashes="34745a93ed24f86c1dfb5b7ef9110799f8ced0b48bd8038e3af827bb217339b0 34bc3cde92441468138d1149b0704823755244fcb678ea0fc402e8ff8d089493 72daf39da8c5eed46adcab5a20c56cd62b1a58ab0a0f3b44722dd3f05eec6f19 d07c76359db33a068a10c73e8425495efd3aa294098d5f9451af454a84be5b82 df428672b97a9478d3e66fd3672bcf08ffeff2ebe49bcce27b67dc7d1928bad3"
    allowed_rollback_hashes=""
    ;;
  "Linux/arm64")
    artifact="personwise_1.1.3_linux_arm64.tar.gz"
    expected_size="2831281"
    expected_sha256="e26b8d625089f7a560958f86db1ab105ffba61af9e98244cdaf354e7fe90f99f"
    native_signature_status="not-applicable"
    native_signature_required="false"
    native_identity=""
    expected_executable_sha256="0e27b20ba3367441b3c0e6f8d26b1b1488cd22ac12847574081d8970fd75d029"
    allowed_upgrade_hashes="385730ab4d97b161d4314836e3c4685542d1c7d0a6d00208020b52e2d90a5650 457a7b132b1aeb673936ac48e1f9ed8419f6da75a64558c79d656ea368bc2d01 74a26677ebcda9cd173c0f3bca587d8733e8c302054fae8f5f051ab5e057ff35 96dc5b038e6c81f265bd96ca7933cfb22ffdf0feed05b2785a003ef83d0c467e f0c37971f16878a6e33e8bc8562526005b7295aac6047f463ca1c6187b4b01b3"
    allowed_rollback_hashes=""
    ;;
  "Darwin/x86_64")
    artifact="personwise_1.1.3_darwin_amd64.tar.gz"
    expected_size="3175349"
    expected_sha256="ec43a0b1f2e3c8a46dfcfd329b3b74ae96f0ab64d4187fb4387888881036bdba"
    native_signature_status="deferred-founder-approved"
    native_signature_required="false"
    native_identity=""
    expected_executable_sha256="848d817f8102b5b6b56b970022d0d0d1a5ad1037557697934dd6b0ffa57f9acf"
    allowed_upgrade_hashes="34dd1dc5bb38a83a33c441ad9ec490d0174eb354ec4e9bbdb63c166feddbb4f2 3c4950044f7d89b72876df205d31617ec5b321d1910853ede0c3243e2c56df57 400d84244021b0c0c2e57ec46b28df604b949780bbc02d1e523ba4ff9d6b7779 724918b9a9053d053c7904cf0216fa35926246a052e4faa9b3b4298eb1939cd7 fadbebceff3fc29c598dd50056a6440a1387f8f91fe61b9dfa6a0989d1e5ccaa"
    allowed_rollback_hashes=""
    ;;
  "Darwin/arm64")
    artifact="personwise_1.1.3_darwin_arm64.tar.gz"
    expected_size="2919093"
    expected_sha256="6507c10f6daf2df731f1d7f7854e3942671fddeff92b56bcb6b897e7979c0438"
    native_signature_status="deferred-founder-approved"
    native_signature_required="false"
    native_identity=""
    expected_executable_sha256="5af22f0e53dd5085e47cded1fc696c04bdf76c3c6db7c33f20c1472be383b50a"
    allowed_upgrade_hashes="1b559f84c6bc141f9f2aa33594f96f5f4a686c83ae981a91137258c9d0acf343 4c4e85be09fbf5c9c53eb6f891cf338c763aa010ed4d985c025eb32152c56056 4e26527da7abe1420b6ba7bbf29b1022a3ab742baa4e8497558ca70986361c14 70966e67c279a30c43804ff98325415c4568420128ea6f3ac29fceac88fd30c9 a7bad519658d85f7c437efdb8552e4294d3e39cd7412ff67f9b089d890b6b35c"
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
url="https://releases.personwise.ai/cli/v1.1.3/$artifact"

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
printf '{"schema_version":"1","ok":true,"data":{"path":"%s","software_version":"1.1.3","cli_contract_version":"1.0","action":"%s"},"request_id":"bootstrap-local"}
' "$target_path" "$action"
