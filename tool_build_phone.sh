#!/usr/bin/env bash
# 폰 디버그 빌드+설치. .env 의 PLANTNET_API_KEY 를 --dart-define 으로 주입 (키는 커밋하지 않음)
set -e
cd /c/plant_app
KEY=$(grep '^PLANTNET_API_KEY=' .env | cut -d= -f2)
flutter build apk --debug --suppress-analytics --dart-define=PLANTNET_API_KEY="$KEY"
"$LOCALAPPDATA/Android/Sdk/platform-tools/adb.exe" install -r build/app/outputs/flutter-apk/app-debug.apk
