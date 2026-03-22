# TESTS

## Ausführbare Prüfungen

### 1. Shell-Syntax prüfen
```bash
bash -n user.sh
```

### 2. Vorlage prüfen
```bash
python3 - <<'PY'
from pathlib import Path
content = Path('user.env').read_text(encoding='utf-8').strip().splitlines()
expected = [
    'ROOT_PASSWORD=""',
    'ADMIN_NAME=""',
    'ADMIN_PASSWORD=""',
    'PUBLIC_KEY=""',
]
assert content == expected, content
print('user.env template OK')
PY
```

### 3. Logik mit Testwerten trocken validieren
- `user.env` mit Testwerten füllen.
- Skript nur auf einem Testsystem als `root` ausführen.
- Prüfen, dass:
  - `root` ein neues Passwort hat,
  - der Admin-Benutzer existiert,
  - der Admin-Benutzer in `sudo` oder `wheel` ist,
  - beide `authorized_keys` den Public Key genau einmal enthalten.
