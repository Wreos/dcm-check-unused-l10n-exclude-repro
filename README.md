# DCM `check-unused-l10n` exclude glob repro (monorepo-like layout)

This repo mirrors the relevant `CustomerApp` structure:

- `packages/l10n/lib/src/l10n/gen/app_localizations.dart`
- `test/test_env.dart`

## Environment

- DCM: `1.35.0`
- Flutter/Dart: generated via `flutter create`

## Repro setup

The package defines `AppLocalizations` with 50 keys in:

- `packages/l10n/lib/src/l10n/gen/app_localizations.dart`

Usage file references keys `key01..key48`:

- `packages/l10n/lib/src/localization_usage.dart`

So exactly 2 keys (`key49`, `key50`) remain unused.

## Run

```bash
dcm check-unused-l10n . --class-pattern "^AppLocalizations$" --exclude="**/l10n/gen/**"
dcm check-unused-l10n . --class-pattern "^AppLocalizations$" --exclude="test/**"
dcm check-unused-l10n . --class-pattern "^AppLocalizations$" --exclude="**/test/**"
dcm check-unused-l10n . --class-pattern "^AppLocalizations$" --exclude="{**/l10n/gen/**,**/test/**}"
dcm check-unused-l10n . --class-pattern "^AppLocalizations$" --exclude="{**/l10n/gen/**,test/**}"
```

## Actual results (DCM 1.35.0)

For all patterns below, DCM still reports the same 2 issues from:
`packages/l10n/lib/src/l10n/gen/app_localizations.dart` (`key49`, `key50`).

- `--exclude="**/l10n/gen/**"` -> 2 issues
- `--exclude="test/**"` -> 2 issues
- `--exclude="**/test/**"` -> 2 issues
- `--exclude="{**/l10n/gen/**,**/test/**}"` -> 2 issues
- `--exclude="{**/l10n/gen/**,test/**}"` -> 2 issues

## Expected

`**/test/**` should match root `test/...` consistently, especially when used in brace list with other patterns.
