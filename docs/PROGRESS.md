# PROGRESS.md — 진행 기록

## 기획 변경 승인 (2026-09-16, 사용자 최종 승인 — HANDOFF 0장 절차)

사용자가 아래 3건을 HANDOFF.md / DESIGN.md에 덮어쓰기(Override)로 승인함. 충돌 시 이 항목이 원문보다 우선한다.

### 이해 요약
| # | 변경 | 원문 | 변경 후 |
|---|---|---|---|
| O1 | TFLite 온디바이스 식별을 M5 → **M2**로 앞당김 | 1단계 PlantNet, 2단계 TFLite(별도 트랙) | **TFLite 로컬 추론 먼저 → 실패·모델 없음·저신뢰 시에만 PlantNet Fallback** |
| O2 | 사진 백업 삭제 | Storage `photos/{user_id}/` 업로드 | **latest.json(DB 텍스트)만 백업. 사진은 기기 로컬 전용** |
| O3 | 'Modern Cozy' 테마 | background #F5F7F4, primary #2E7D5B, primaryContainer #E4F1EA, surfaceVariant #EEF1EC | **background #F4F1EB, primary #2C5E43, primaryContainer = surfaceVariant #DDE6DF** |

### 적용 계획
- O1 (M2에서 구현)
  - `lib/domain/identification_service.dart`: `IdentificationPipeline` = `[OnDeviceIdentifier(TFLite), PlantNetIdentifier]` 순서 고정.
  - `OnDeviceIdentifier`: `assets/models/plant_classifier.tflite` 로드 시도 → 파일 없음/로드 실패 → `ModelUnavailable` 반환(예외 아님) → 다음 단계로. 1순위 ≥ 0.80이면 종료.
  - 모델 파일이 없는 현재는 **더미 구현**(항상 `ModelUnavailable`)으로 파이프라인이 막히지 않게 함. 인터페이스·테스트는 완성.
  - `tflite_flutter` 패키지(Apache 2.0, 무료)는 M2 착수 시 추가. M0에서는 추가하지 않음.
- O2 (M4에서 구현)
  - `backup_service.dart`: `backups/{user_id}/latest.json` 덮어쓰기만. 사진 업로드 코드 없음.
  - AUTH-01 / MY-01 백업 카드 / ONB-01 마지막 슬라이드에 문구 "사진은 서버에 백업되지 않아요. 기기에만 저장돼요" 추가.
  - 개인정보 처리방침에 "사진은 서버로 전송·보관하지 않음" 명시.
- O3 (M0에서 즉시 적용 — 완료)
  - `lib/app/theme.dart` 라이트 팔레트 교체. `statusOk`는 원문대로 primary와 동일 → #2C5E43. 다크 팔레트는 지시 없어 유지.
  - HOME-01 카드: 그림자 없음, radius 16, 카드 간 12 / 내부 16 — 기존 DESIGN.md 3장과 동일하므로 토큰 변경 없음.
  - 중앙 카메라 FAB: 이미 탭바 위 12pt 돌출 원형 56으로 구현됨. 유지.
  - HOME-02 흙 확인 바텀시트(M1): 큰 2버튼(말랐어요·물 줬어요 Primary / 아직 촉촉해요 Secondary) + 식물 썸네일·별명 상단 표시로 설계.

## M0 — 세팅 (2026-09-16)

### 완료
- Flutter 3.41.6 프로젝트 생성 (`plant_app/`, Android + iOS)
- 패키지 설치: flutter_riverpod 2.6, go_router 17.5, drift 2.34 + drift_flutter, path_provider, flutter_local_notifications 22, intl
- `lib/app/theme.dart`: DESIGN.md 토큰(AppColors light/dark, AppText, AppSpace, AppRadius, AppSize, AppMotion) + ThemeData 매핑, ThemeMode.system
- Pretendard 4종 폰트 번들 (OFL, `docs/LICENSE_Pretendard.txt`)
- go_router StatefulShellRoute 3탭 스캐폴드 + 중앙 카메라 원형 버튼 (`lib/app/tab_scaffold.dart`)
- 공통 위젯: `AppButton`(primary/secondary/text/destructive), `StatusDot`, `EmptyState`
- Drift 스키마 7개 테이블 (species / spaces / plants / care_events / diary_entries / identification_logs / settings), 코드 생성 완료
- HOME-01 빈 상태 화면, CAM-01·MY-01 플레이스홀더
- 테스트 4건 통과 (DB 3건 + 3탭 스모크 1건), `flutter analyze` 이슈 0
- CI: `.github/workflows/ci.yml` (analyze + test + 유료 서비스 grep 검사)
- Android minSdk 26, iOS 15.0, 앱 표시명 "잘자라라"
- `.env.example` (PLANTNET_API_KEY, SUPABASE_URL, SUPABASE_ANON_KEY)

### 미완 / 미검증
- Android·iOS 시뮬레이터 실행 확인은 아직 안 함 (Gradle 빌드 시간 때문에 생략). 한글 경로 이슈 가능성 있음 → 아래 "결정 사항" 참고.
- `home_mockup.png`가 폴더에 없음. DESIGN.md 8장 레이아웃 요약대로 구현 예정.

### 결정 사항 (사용자 확인 필요 — HANDOFF 10장)
1. **앱 이름**: 폴더명을 따라 "잘자라라"로 가정. 패키지명은 임시 `com.jaljarara.plant_app`. 확정 시 변경 필요.
2. Kakao 로그인 포함 여부: 미결 (M4)
3. species 시드 300종: 미결 (M1 착수 전 확인 필요)
4. Crashlytics/Analytics 포함 여부: 미결

### 스키마 추가 (HANDOFF 4장 대비)
- `plants.feedback_coef` (REAL, 기본 1.0), `plants.dry_streak` (INT): 5-1 feedback_coef 상태 저장용
- `settings.onboarding_done` (BOOL): ONB-01 1회 노출 판단용

### 환경 이슈와 우회
- 프로젝트 경로에 한글(`C:\잘자라라`)이 있어 build_runner AOT 컴파일이 실패함 → **`--force-jit`** 로 실행:
  `C:\src\flutter\bin\dart run build_runner build --delete-conflicting-outputs --force-jit`
- PATH의 `dart`가 다른 Flutter SDK(OneDrive 경로)를 가리킴 → 반드시 `C:\src\flutter\bin\dart` 사용
- drift_dev ≥2.34.6은 Flutter SDK의 meta 1.17 과 충돌 → drift 2.34 / drift_dev <2.34.6 고정
- flutter_riverpod 3.x는 의존성 충돌로 2.6.1 사용
- 위젯 테스트에서 Drift 사용 시 `tester.runAsync` 필수 (fakeAsync에서 close 무한 대기)
- Android Gradle 빌드도 한글 경로에서 실패할 수 있음. 실패 시 ASCII 경로 정션 권장:
  `cmd /c mklink /J C:\plant_app C:\잘자라라\plant_app`

### 라이선스
| 패키지 | 라이선스 | 비용 |
|---|---|---|
| flutter_riverpod | MIT | 0 |
| go_router | BSD-3 | 0 |
| drift / drift_flutter / drift_dev | MIT | 0 |
| path_provider | BSD-3 | 0 |
| flutter_local_notifications | BSD-3 | 0 |
| intl | BSD-3 | 0 |
| build_runner | BSD-3 | 0 |
| Pretendard 폰트 | SIL OFL 1.1 | 0 |

### 제안 (구현 안 함)
- 아이콘: DESIGN.md의 Material Symbols Rounded 대신 M0에서는 Flutter 내장 Material Icons(rounded/outlined) 사용. 정확한 Symbols가 필요하면 `material_symbols_icons`(Apache 2.0) 추가 검토.

## 다음: M1 — 식물 등록 + 물주기 코어
- species 시드 로드, ADD-01~04, SPC-02, PLT-01, watering_rules + 테스트 20케이스, HOME-01 오늘 할 일, HOME-02, 로컬 알림
