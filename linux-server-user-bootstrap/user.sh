#!/usr/bin/env bash
# ==============================================================================
# Benutzer- und Zugangskonfiguration für frisch installierte Linux-Server.
#
# Funktion:
# - Lädt Eingaben aus user.env
# - Ändert Root-Passwort und Admin-Passwort
# - Legt einen Admin-Benutzer mit sudo an
# - Hinterlegt einen SSH Public Key für root und Admin
# ==============================================================================
PRODUCT="user"
INFO="Initialisiert Benutzer und Zugänge für einen Linux-Server."
VERSION="0.1.0"
BUILD_DATE="2026-03-22"
AUTHOR="OpenAI"
CONTACT="support@openai.com"

set -Eeuo pipefail

readonly MODULE_NAME="user"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly ENV_FILE="${SCRIPT_DIR}/user.env"
readonly DEFAULT_LOG_DIR="${SCRIPT_DIR}/logs"
readonly LOG_DIR="${LOG_DIR:-${DEFAULT_LOG_DIR}}"
readonly LOG_ENABLED="${LOG_ENABLED:-1}"
readonly LOG_LEVEL_INFO="${LOG_LEVEL_INFO:-1}"
readonly LOG_LEVEL_ERROR="${LOG_LEVEL_ERROR:-1}"
readonly LOG_LEVEL_DEBUG="${LOG_LEVEL_DEBUG:-0}"
readonly LOG_TIMESTAMP="$(date '+%Y-%m-%d_%H-%M-%S')"
readonly LOG_FILE="${LOG_DIR}/LOG_${MODULE_NAME}_${LOG_TIMESTAMP}"

logMessage() {
  local level="$1"
  local scope="$2"
  local message="$3"
  local result="${4:-}"
  local line=""
  local timestamp=""

  case "$level" in
    INFO)
      [[ "$LOG_LEVEL_INFO" == "1" ]] || return 0
      line="[INFO]  [${result}] ${scope}: ${message}"
      ;;
    ERROR)
      [[ "$LOG_LEVEL_ERROR" == "1" ]] || return 0
      line="[ERROR]        ${scope}: ${message}"
      ;;
    DEBUG)
      [[ "$LOG_LEVEL_DEBUG" == "1" ]] || return 0
      line="[DEBUG]        ${scope}: ${message}"
      ;;
    *)
      return 1
      ;;
  esac

  printf '%s\n' "$line"

  if [[ "$LOG_ENABLED" == "1" ]]; then
    timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
    printf '%s %s\n' "$timestamp" "$line" >> "$LOG_FILE"
  fi
}

logInfo() {
  logMessage "INFO" "$1" "$2" "$3"
}

logError() {
  logMessage "ERROR" "$1" "$2"
}

logDebug() {
  logMessage "DEBUG" "$1" "$2"
}

showBuildInfo() {
  printf '\n'
  printf '[BUILD] ========================================================================\n'
  printf '[BUILD] product = %s\n' "$PRODUCT"
  printf '[BUILD] info    = %s\n' "$INFO"
  printf '[BUILD] version = %s\n' "$VERSION"
  printf '[BUILD] date    = %s\n' "$BUILD_DATE"
  printf '[BUILD] author  = %s\n' "$AUTHOR"
  printf '[BUILD] contact = %s\n' "$CONTACT"
  printf '[BUILD] ========================================================================\n'
  printf '\n'
}

prepareLogFile() {
  local scope="${MODULE_NAME}.prepareLogFile"

  if [[ "$LOG_ENABLED" != "1" ]]; then
    logInfo "$scope" "Dateilog ist deaktiviert." "SKIP"
    return 0
  fi

  mkdir -p "$LOG_DIR"
  : > "$LOG_FILE"
  rotateLogs
  logInfo "$scope" "Dateilog wurde vorbereitet." "OK"
}

rotateLogs() {
  local scope="${MODULE_NAME}.rotateLogs"
  local files=()
  local index=0

  mapfile -t files < <(
    find "$LOG_DIR" -maxdepth 1 -type f -name "LOG_${MODULE_NAME}_*" \
      | sort -r
  )

  if (( ${#files[@]} <= 7 )); then
    logInfo "$scope" "Keine Log-Rotation notwendig." "SKIP"
    return 0
  fi

  for (( index = 7; index < ${#files[@]}; index++ )); do
    rm -f "${files[$index]}"
  done

  logInfo "$scope" "Alte Logdateien wurden bereinigt." "OK"
}

fail() {
  logError "$1" "$2"
  exit 1
}

handleError() {
  local exitCode="$1"
  local lineNo="$2"
  fail "${MODULE_NAME}.handleError" \
    "Skript wurde in Zeile ${lineNo} mit Exit-Code ${exitCode} abgebrochen."
}

trap 'handleError "$?" "$LINENO"' ERR

requireRoot() {
  local scope="${MODULE_NAME}.requireRoot"

  if [[ "${EUID}" -ne 0 ]]; then
    fail "$scope" "Das Skript muss als root ausgeführt werden."
  fi

  logInfo "$scope" "Ausführung mit root-Rechten bestätigt." "OK"
}

loadEnv() {
  local scope="${MODULE_NAME}.loadEnv"

  if [[ ! -f "$ENV_FILE" ]]; then
    fail "$scope" "Die Datei user.env wurde nicht gefunden."
  fi

  set -a
  # shellcheck disable=SC1090
  source "$ENV_FILE"
  set +a

  logInfo "$scope" "Eingabedatei wurde geladen." "OK"
}

trimValue() {
  local value="$1"

  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  printf '%s' "$value"
}

validateEnv() {
  local scope="${MODULE_NAME}.validateEnv"
  local missing=0

  ROOT_PASSWORD="$(trimValue "${ROOT_PASSWORD:-}")"
  ADMIN_NAME="$(trimValue "${ADMIN_NAME:-}")"
  ADMIN_PASSWORD="$(trimValue "${ADMIN_PASSWORD:-}")"
  PUBLIC_KEY="$(trimValue "${PUBLIC_KEY:-}")"

  if [[ -z "$ROOT_PASSWORD" ]]; then
    logError "$scope" "ROOT_PASSWORD ist leer."
    missing=1
  fi

  if [[ -z "$ADMIN_NAME" ]]; then
    logError "$scope" "ADMIN_NAME ist leer."
    missing=1
  fi

  if [[ -z "$ADMIN_PASSWORD" ]]; then
    logError "$scope" "ADMIN_PASSWORD ist leer."
    missing=1
  fi

  if [[ -z "$PUBLIC_KEY" ]]; then
    logError "$scope" "PUBLIC_KEY ist leer."
    missing=1
  fi

  if [[ "$ADMIN_NAME" == "root" ]]; then
    fail "$scope" "ADMIN_NAME darf nicht root sein."
  fi

  if ! [[ "$ADMIN_NAME" =~ ^[a-z_][a-z0-9_-]*[$]?$ ]]; then
    fail "$scope" "ADMIN_NAME enthält ungültige Zeichen."
  fi

  if (( missing == 1 )); then
    fail "$scope" "Bitte user.env vollständig befüllen."
  fi

  logInfo "$scope" "Eingabewerte wurden validiert." "OK"
}

setPassword() {
  local userName="$1"
  local password="$2"
  local scope="${MODULE_NAME}.setPassword"

  printf '%s:%s\n' "$userName" "$password" | chpasswd
  logInfo "$scope" "Passwort für ${userName} wurde gesetzt." "OK"
}

resolveSudoGroup() {
  if getent group sudo > /dev/null 2>&1; then
    printf '%s' "sudo"
    return 0
  fi

  if getent group wheel > /dev/null 2>&1; then
    printf '%s' "wheel"
    return 0
  fi

  return 1
}

ensureAdminUser() {
  local scope="${MODULE_NAME}.ensureAdminUser"
  local sudoGroup=""

  sudoGroup="$(resolveSudoGroup)" || \
    fail "$scope" "Es wurde keine sudo- oder wheel-Gruppe gefunden."

  if id "$ADMIN_NAME" > /dev/null 2>&1; then
    usermod -aG "$sudoGroup" "$ADMIN_NAME"
    logInfo "$scope" \
      "Admin-Benutzer ${ADMIN_NAME} wurde an sudo angebunden." "OK"
    return 0
  fi

  useradd -m -s /bin/bash -G "$sudoGroup" "$ADMIN_NAME"
  logInfo "$scope" "Admin-Benutzer ${ADMIN_NAME} wurde angelegt." "OK"
}

ensureAuthorizedKey() {
  local userName="$1"
  local homeDir="$2"
  local scope="${MODULE_NAME}.ensureAuthorizedKey"
  local sshDir="${homeDir}/.ssh"
  local authFile="${sshDir}/authorized_keys"
  local userGroup=""

  userGroup="$(id -gn "$userName")"

  install -d -m 700 -o "$userName" -g "$userGroup" "$sshDir"
  touch "$authFile"
  chown "$userName:$userGroup" "$authFile"
  chmod 600 "$authFile"

  if grep -Fqx "$PUBLIC_KEY" "$authFile"; then
    logInfo "$scope" \
      "Public Key für ${userName} ist bereits vorhanden." "SKIP"
    return 0
  fi

  printf '%s\n' "$PUBLIC_KEY" >> "$authFile"
  chown "$userName:$userGroup" "$authFile"
  chmod 600 "$authFile"
  logInfo "$scope" "Public Key für ${userName} wurde hinterlegt." "OK"
}

configureRootAccess() {
  local scope="${MODULE_NAME}.configureRootAccess"

  setPassword "root" "$ROOT_PASSWORD"
  ensureAuthorizedKey "root" "/root"
  logInfo "$scope" "Root-Zugang wurde vorbereitet." "OK"
}

configureAdminAccess() {
  local scope="${MODULE_NAME}.configureAdminAccess"

  ensureAdminUser
  setPassword "$ADMIN_NAME" "$ADMIN_PASSWORD"
  ensureAuthorizedKey "$ADMIN_NAME" "/home/${ADMIN_NAME}"
  logInfo "$scope" "Admin-Zugang wurde vorbereitet." "OK"
}

main() {
  showBuildInfo
  prepareLogFile
  requireRoot
  loadEnv
  validateEnv
  configureRootAccess
  configureAdminAccess
  logInfo "${MODULE_NAME}.main" \
    "Benutzerkonfiguration wurde erfolgreich abgeschlossen." "OK"
}

main "$@"
