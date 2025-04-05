#!/bin/bash

flutter pub get # get dependencies
# flutter gen-l10n --untranslated-messages-file=untranslated.json
flutter gen-l10n # generate localization
dart run build_runner build --delete-conflicting-outputs # generate mocks
#flutter pub run build_runner build --delete-conflicting-outputs
# ios pod install on macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    cd ./ios || exit
    pod install
fi