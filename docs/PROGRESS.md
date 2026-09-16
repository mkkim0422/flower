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

## M1 — 식물 등록 + 물주기 코어 (2026-09-16)

### 완료
- `lib/domain/watering_rules.dart`: 5-1 계산식·계수 상수, feedback 보정, next_check_at, D-day 유틸. 테스트 `test/domain/watering_rules_test.dart` 34케이스(계수별·클램프·수동·날짜).
- 시드 로더 `lib/data/seed/species_seed.dart`: `assets/species_ko.json` → species 테이블 (비어 있을 때 1회), 검색용 `search_text` 생성.
- 저장소: `species_repository`(국내명·학명 검색), `space_repository`, `plant_repository`(등록·재계산·흙 확인·수동 주기·관리 이벤트), `settings_repository`. 테스트 `test/data/plant_repository_test.dart` 7케이스 — 등록 → 다음 확인일 → 흙 확인 → 주기 보정 E2E 포함.
- 화면: ONB-01/02, HOME-01(오늘 확인 + 다중 선택 일괄 완료 + 내 식물 목록/공간 토글), HOME-02(흙 확인 바텀시트, 큰 2버튼), ADD-01~04, SPC-02, PLT-01, PLT-02(자동 근거 + 수동 슬라이더).
- 공통 위젯 추가: `PlantCard`, `PlantThumb`, `TodayCheckTile`(체크 scale 애니메이션), `ToxicBadge`.
- 로컬 알림 `lib/domain/notification_service.dart`: 매일 notify 시각 1건 "오늘 확인할 식물이 N개 있어요". 앱 포그라운드마다 재계산·재예약(`app.dart` AppLifecycleListener). 제외 요일 지원. Android: POST_NOTIFICATIONS·BOOT 리시버·desugaring 설정.
- 라우터: 온보딩 리다이렉트, 등록 플로우는 탭바 위 전체화면(root navigator).
- 테스트 총 46건 통과, `flutter analyze` 오류 0.

### 미완 / 미검증
- 실기기·에뮬레이터 실행 및 알림 실제 수신은 미검증 (Gradle 빌드 미실행).
- 사진 등록은 CAM(M2)에서. PLT-01 "일기 쓰기"는 M3까지 비활성.
- INFO-01 전체 페이지·SPC-01 공간 뷰·MY 통계는 M3. HOME-01 공간 토글은 임시로 공간별 그룹 목록.

### 결정 사항 (명세 공백을 메운 가정)
- lightCoef에서 **남·동·서 + 1m 이내**는 명세에 없어 1.0으로 둠.
- "아직 촉촉해요" 후 재확인일: interval의 25%, 1~3일로 클램프(`recheckDaysAfterWet`). 물 준 날은 바꾸지 않음.
- "말랐어요, 물 줬어요"는 care_events에 `check_dry` + `water` 2건 기록.
- 다중 선택 일괄 완료는 선택한 식물 전부에 같은 결과를 적용.
- 계절 계수 반영을 위해 앱 포그라운드마다 수동이 아닌 식물의 주기를 재계산(다음 확인일 = 마지막 물 준 날 + 새 주기).
- 온보딩 완료 여부는 settings.onboarding_done 으로 저장, 알림 권한은 ONB-02에서 요청("나중에" 가능).
- species 시드: 사용자 결정(2026-09-16)에 따라 Claude가 공공 자료(농진청 실내식물 정보·ASPCA 독성 목록·위키 학명) 기반으로 생성. data.go.kr/농사로 API는 키가 없어 직접 호출하지 않음 → 검수 필요 표시.

### 라이선스 추가
| 패키지 | 라이선스 | 비용 |
|---|---|---|
| timezone | BSD-2 | 0 |

## 다음: M2 — 카메라 식별
- CAM-01~04, TFLite 더미 로더 → PlantNet Fallback, 일 한도 카운터, 후보 리스트, identification_logs
