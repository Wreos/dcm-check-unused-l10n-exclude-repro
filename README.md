# DCM `check-unused-l10n` exclude glob repro

This repo reproduces inconsistent exclude matching for `dcm check-unused-l10n`.

## Environment

- DCM: `1.35.0`
- Flutter/Dart: generated via `flutter create`

## Repro setup

Two files intentionally trigger `check-unused-l10n` findings:

- `lib/l10n/gen/app_localizations.dart`
- `test/test_env.dart`

`test/test_env.dart` is a copy of generated localization code to force l10n findings in `test/`.

## Run

```bash
dcm check-unused-l10n . --class-pattern "^AppLocalizations$" --exclude="**/l10n/gen/**"
dcm check-unused-l10n . --class-pattern "^AppLocalizations$" --exclude="test/**"
dcm check-unused-l10n . --class-pattern "^AppLocalizations$" --exclude="**/test/**"
dcm check-unused-l10n . --class-pattern "^AppLocalizations$" --exclude="{**/l10n/gen/**,**/test/**}"
dcm check-unused-l10n . --class-pattern "^AppLocalizations$" --exclude="{**/l10n/gen/**,test/**}"
```

## Actual results

- `--exclude="**/l10n/gen/**"` excludes `lib/l10n/gen`, leaves `test/test_env.dart` (4 issues)
- `--exclude="test/**"` excludes `test`, leaves `lib/l10n/gen/app_localizations.dart` (4 issues)
- `--exclude="**/test/**"` does **not** exclude root `test/` (8 issues, both paths)
- `--exclude="{**/l10n/gen/**,**/test/**}"` leaves `test/test_env.dart` (4 issues)
- `--exclude="{**/l10n/gen/**,test/**}"` excludes both (0 scanned files)

## Expected

`**/test/**` should match root `test/...` consistently, especially when used in brace list with other patterns.
