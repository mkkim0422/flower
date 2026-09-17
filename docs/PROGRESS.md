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
- 테스트 총 49건 통과(시드 검증 3건 포함), `flutter analyze` 오류 0.

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
  - 결과: **544종** (관엽 198 / 다육·선인장 162 / 꽃 90 / 허브 45 / 기타 49). 학명 중복 0, 독성 필드 누락 0. `test/data/species_seed_test.dart`로 DoD 자동 검증.
  - 학명은 현행 인정명 사용(Calathea→Goeppertia, Schefflera→Heptapleurum 등). 국내명에 옛 이름을 병기해 검색은 그대로 됨.
  - 2026-09-16 내용 검토(사용자 요청): 대표 100여 종 독성을 ASPCA 진실표와 대조 → 불일치 0. 속 단위 일관성 검사(Araceae·Ficus·Dracaena·Kalanchoe·Euphorbia 등 독성 / Hoya·Peperomia·야자·고사리·난·다육 무독) → 불일치 0 (스웨디시아이비는 무독이 맞음). 수정 3건: 국내명 충돌 '돈나무'(금전수→제거, 돈나무=Pittosporum), '나비란'(호접란→제거, 나비란=접란), 스테파니아 에렉타 7→12일·델로스페르마 7→10일. 검토 스크립트 결과 기준으로 온도 -10℃ 이하 11종은 내한성 노지 식물이라 그대로 둠.
  - **독성 검수 필요 항목(근거 약함)**: Fatsia japonica, Plerandra elegantissima, Caryota mitis(false), Pittosporum tobira, Ardisia crenata/japonica, Artemisia dracunculus, Borago officinalis, Passiflora caerulea, Ledebouria socialis/Albuca bracteata, Pistia stratiotes/Anubias barteri. 식용 허브(민트·라벤더·파슬리 등)는 ASPCA 기준 반려동물 독성 true, 아이 독성 false.

### 라이선스 추가
| 패키지 | 라이선스 | 비용 |
|---|---|---|
| timezone | BSD-2 | 0 |

## 전체 검토 (2026-09-16, 사용자 요청)

### 방법
- 리뷰 에이전트가 HANDOFF 0·4·5장, DESIGN.md 기준으로 lib/·test/ 전체를 정독. 별도로 grep 검사(유료 서비스·HEX 직접 입력·사진 업로드·TODO).
- 결과 14건 → 전부 반영. 테스트 73건 통과, analyze 0.

### 반영한 수정
| 구분 | 내용 |
|---|---|
| BUG | 촉촉 재확인일이 별명 변경·재계산(`recalc`/`recalcAll`/`setManualInterval`)에서 `last_watered + 주기`로 리셋되던 문제 → 주기 차이만큼 **이동**(`shiftedNextCheck`)으로 변경. 회귀 테스트 추가 |
| BUG | PLT-02 슬라이더 최대 45일인데 겨울·창 없음·대형 화분이면 주기 60일+ → `value > max` 크래시. 최대 90일 토큰 + 클램프 |
| SPEC | 알림이 다음 1건만 예약되어 며칠 앱을 안 열면 끊김 → **7일치(id 1~7) 선예약**, 식물·설정 변경 시 0.5초 디바운스로 재예약. 제외 요일 전부면 예약 없음 |
| SPEC | 수동 주기인데 흙 확인이 feedback 계수를 계속 바꾸던 불일치 → 수동이면 계수 미보정(문구와 일치) |
| BUG | 포그라운드 재계산이 cold start에 2중 실행 가능 → `_refreshing` 가드 |
| BUG | 홈 목록 정렬 동률 시 순서 흔들림 → `next_check_at, id` 2차 정렬 |
| STYLE | 화면 코드의 px 직접 입력 15곳 → `AppSize.iconSm/iconXs/pageDot/sliderMaxDays/stickyBar…` 토큰화, 그림자 `AppShadow.cameraButton` |
| STYLE | 칩·카드 위젯 중복 → `AppChip`, `AppCard` 공통화 (4곳 교체) |
| NIT | 미사용 `duePlantsProvider` 삭제, `Duration(days)` → 날짜 성분 산술(DST 안전), `nextFireTime` 테스트 7건 추가, `_saving` finally 복구, 검색어의 `%`·`_` 제거, 품종 변경 시 비료 주기 갱신 |
| CI | 유료 서비스 grep이 `plant.id` 필드 접근까지 잡던 오탐 → `api.plant.id` 등으로 패턴 좁힘 |

### 검토에서 이상 없음으로 확인된 항목
- Drift 스키마 ↔ HANDOFF 4장 일치(추가 컬럼은 PROGRESS에 기록됨), FK cascade/setNull, 물주기 계수 5-1 일치, go_router 리다이렉트·스택 정리, Riverpod 사용, 유료 서비스·로그인·결제·광고 UI 0건, 사진 업로드 코드 0건, 문구 해요체.

### 스토어 등록 설계 점검 (플레이스토어·앱스토어)
| 항목 | 상태 |
|---|---|
| Android minSdk 26 / iOS 15.0 | 완료 |
| 권한: 알림(POST_NOTIFICATIONS, Android 13+ 런타임 요청), 카메라·앨범(iOS 사용 사유 문구 등록, image_picker가 사용 시점 요청) | 완료 |
| 정확한 알람 권한(SCHEDULE_EXACT_ALARM) 미사용 → 심사 이슈 회피 | 완료 (inexact 스케줄) |
| iOS 수출 규정 `ITSAppUsesNonExemptEncryption=false` | 완료 |
| 광고·결제 SDK 없음, 트래킹(ATT) 불필요 | 완료 |
| 앱 아이콘·스플래시 | **미완** — 기본 Flutter 아이콘. M4에서 교체 필요 |
| Android 릴리스 서명 keystore | **미완** — 현재 debug 서명. M4에서 `key.properties`(커밋 금지) 설정 |
| 패키지명 확정 | **미결** — 임시 `com.jaljarara.plant_app` (스토어 등록 후 변경 불가) |
| 개인정보 처리방침 URL, Data Safety(Play)·App Privacy(App Store) 양식 | M4. PlantNet 전송 사진은 "수집하지 않음(일시 처리)"으로 기재 예정 |
| Apple 로그인(소셜 로그인 제공 시 필수), 회원 탈퇴 메뉴 | M4 (AUTH-01, MY-04) |
| 실기기 테스트 Android 8+/iOS 15+ | **미완** |

## M2 — 카메라 식별 (2026-09-16)

### 완료
- `lib/domain/identification_service.dart`: `Identifier` 인터페이스, `OnDeviceIdentifier`(**더미**: 모델 에셋 없으면 `modelMissing` 반환, 있어도 엔진 미연동이라 우회), `IdentificationPipeline`(TFLite → PlantNet 순서 고정, 로컬 ≥0.80이면 원격 호출 없음, 원격 실패 시 로컬 저신뢰 후보라도 반환), 학명 정규화.
- `lib/data/remote/plantnet_client.dart`: multipart 호출, 응답 파싱, 404/429/네트워크 사유 매핑, 키 없으면 호출 없이 안내. 키는 `--dart-define=PLANTNET_API_KEY`.
- 일 한도 카운터(settings.plantnet_day/count, 480회, 스키마 v2 마이그레이션), identification_logs 저장, species 매칭(국내명 병기).
- `lib/domain/image_prep.dart`: 1024px 리사이즈 + EXIF 제거 + 회전 보정(isolate), 앱 내부 `photos/` 저장.
- 화면: CAM-01(촬영/앨범, image_picker), CAM-02/03/04 통합(`identify_result_screen.dart`) — ≥80% 확정 카드 + "이 식물이 맞아요", 미만 후보 3~5행, 한도/네트워크/결과없음 안내 → 이름 검색·직접 입력 연결. 선택 시 ADD-04로 사진 경로 전달 → 대표 사진.
- 테스트 15건(파이프라인 분기, 파싱, 상태코드 매핑, 정규화, 한도 롤오버, 로그, 매칭).

### 미완 / 미검증
- **실제 PlantNet 호출 미검증** (키 없음). 키 받으면 `flutter run --dart-define=PLANTNET_API_KEY=...`로 실제 사진 10장 테스트 필요(M2 완료 기준).
- 온디바이스 모델 파일·`tflite_flutter` 미연동. `_infer` 1개 메서드만 구현하면 됨.
- 실기기 카메라 권한 흐름 미검증.

### 라이선스 추가
| 패키지 | 라이선스 | 비용 |
|---|---|---|
| image_picker | BSD-3 | 0 |
| image | MIT | 0 |
| http | BSD-3 | 0 |

## 실기기 테스트 피드백 반영 (2026-09-16, Galaxy S24+)

### 사용자 피드백 → 조치
| 피드백 | 원인 | 조치 |
|---|---|---|
| 사진 찍어도 품종을 못 맞춤 | PlantNet API 키 미설정(호출 자체 안 됨) + 온디바이스 모델 없음 | 키 발급 필요(my.plantnet.org 무료 가입). CAM-04 문구에 "서버 연결 미설정" 명시. PlantNet 요청 organ을 `leaf` 고정 → `auto`(잎·꽃 자동)로 변경 |
| 검색 결과에 "자미오쿨카스" 같은 음차 별칭이 제목에 붙음 | ko_names 전부를 ' · '로 이어 표시 | 대표 국내명만 제목. 별칭으로 검색된 경우에만 "…로도 불려요" 캡션 |
| 환경 입력(화분·배수구·공간)이 너무 복잡 | ADD-04가 F1 입력을 전부 필수로 노출 | **등록 = 이름 + 마지막 물 준 날(오늘/어제/3일 전/7일 전/날짜)**. 화분·배수구·놓는 곳은 "더 정확한 계산(선택)" 접힘 영역으로 이동. 계산 엔진·기본값(M·배수구 있음·공간 없음 = 계수 1.0)은 유지 → F1 기능은 선택 사항으로 존치 |
| 키우는 팁을 알려줘야 | PLT-01 도감 카드가 수치 나열 | "○○ 키우기 팁" 카드: 독성 → 물(분류별 문장) → 빛 → 온도 → 비료 → 분갈이 → 흔한 문제. 품종 정보에서 문장 생성(`careTips`) |
| 홈 목록이 한 줄에 하나씩 | 리스트만 제공 | **앨범형 2열 그리드 기본** + 목록/앨범 토글(settings.home_grid 저장, 스키마 v3). 공간별 보기는 M3 SPC-01로 이동 |

### 빌드 환경
- 한글 경로 때문에 Gradle이 빌드 거부 → `android/gradle.properties`에 `android.overridePathCheck=true`, 정션 `C:\plant_app`에서 빌드. 첫 빌드 9분(의존성 다운로드), 이후 2~3분.
- 설치: `adb install -r build/app/outputs/flutter-apk/app-debug.apk` (디버그 APK 165MB, 릴리스는 훨씬 작음).

## 사용자 지시: 물주기 중심 단순화 (2026-09-16) — HANDOFF 1장 "흙 확인 알림" 규칙 Override

### 지시
"물주는 주기만 있으면 된다. 흙 마르고 안 마르고 체크하는 사람 없다. 분갈이·비료 필요 없다. D-day 보여주고 그 아래 내 메모, 꽃 상세 정보·알아두면 좋은 정보."

### 조치
| 항목 | 변경 |
|---|---|
| 알림·홈 문구 | "확인할 식물" → **"물 줄 식물 N"**, 알림 "오늘 물 줄 식물이 N개 있어요", 상태 라벨 "오늘 물 주기" |
| HOME-02 시트 | 2택("말랐어요/촉촉해요") → **"물 줬어요"** Primary 1개 + "나중에 줄게요 · N일 뒤 다시" Text. 내부적으로는 기존 dry/wet 경로를 그대로 사용(미루기 = wet: 주기 ×1.15, N일 뒤 재알림) → 계산 엔진·테스트 변경 없음 |
| PLT-01 | 카드 순서 **D-day(주기·마지막 물 준 날·조정) → 내 메모(탭해서 편집, plants.memo 스키마 v4) → 알아두면 좋은 정보(독성·물·빛·온도·흔한 문제) → 물 준 기록(날짜 나열)**. 비료·분갈이 줄·버튼 제거, 하단 Primary "물 줬어요" |
| 팁 문장 | 비료·분갈이 문장 제외 |
| 온보딩·권한·등록·PLT-02 문구 | 흙 확인 표현 제거 |

### 유지(숨김)
- species.fert_days / repot_months, plants.fert_interval_days / last_fert_at / repot_at, care_events fert/repot 타입은 DB에 남김(2차에 필요 시 노출). UI에서는 사용하지 않음.
- feedback 계수 보정은 "물 줬어요"(dry) / "나중에"(wet) 경로로 그대로 동작.

## M3 — 일기 · 도감 · 통계 (2026-09-16)

### 완료
- DIA-01 일기 작성(`features/diary/diary_write_screen.dart`): 사진(촬영/앨범, 1024px 리사이즈) · 상태 태그 5종 · 메모 · "대표 사진으로 설정"(대표 사진 없으면 기본 켜짐). PLT-01에 일기 카드(최근 3개 + 외 N개, 사진 탭 → 전체화면, 개별 삭제).
- INFO-01 도감(`features/species_info/species_info_screen.dart`): 독성 → 물 → 빛 → 온도·습도 → 흔한 문제 → "내 식물로 등록". 검색 결과의 ⓘ 아이콘과 PLT-01 "알아두면 좋은 정보 › 자세히"에서 진입. 비료·분갈이는 표시 안 함(사용자 지시).
- MY-01 통계 3칸(이번 달 물 준 횟수 / 새잎 / 연속 관리일, `domain/stats_service.dart`) + MY-02 알림 시간·요일 제외 설정. 백업·품종 요청·약관·문의는 "준비 중"(M4).
- 테스트 +11건(통계 8, 일기 저장소 2, …) → 총 84건 통과.

### 결정
- 연속 관리일: 물 주기 또는 일기가 있는 날이 하루도 빠짐없이 이어진 일수. 오늘 아직 안 했으면 어제까지의 연속을 유지.
- SPC-01 공간별 뷰는 사용자가 공간 개념을 부담스러워해 보류(홈 토글은 목록/앨범). 필요 시 2차.

## M4 준비 (2026-09-16, API·계정 불필요 항목 선행)

### 완료
- `docs/privacy_policy.md` 초안: 로컬 저장 원칙, PlantNet 전송(축소·EXIF 제거·미보관), 백업은 텍스트만(사진 제외), 권한 표, 탈퇴. 시행일·운영자·문의 이메일은 공란.
- `docs/store_listing.md`: 앱 설명·스크린샷 구성·Play/App Store 필수 항목·출시 전 체크리스트.
- 앱 아이콘 자동 생성(`assets/icon/app_icon.png`, PIL 스크립트): 포레스트 그린 배경 + 세이지 잎 + 물방울. Android legacy mipmap 5종 + adaptive(anydpi-v26, 배경색) + iOS AppIcon 15종 교체. **디자이너 아이콘으로 교체 권장(임시).**
- Android 릴리스 서명: `key.properties` 있으면 release 키, 없으면 debug (CI 유지). `key.properties.example`, `.gitignore`(*.jks, key.properties), minify+shrink, proguard(flutter_local_notifications keep).
- 스플래시 배경을 베이지(#F4F1EB)로.

### 남은 M4 (사용자 입력 필요)
- 패키지명 확정, 운영자·문의 이메일, 처리방침 GitHub Pages URL, 릴리스 keystore 생성(비밀번호), Supabase 프로젝트(백업·탈퇴), Google/Apple(/Kakao) 로그인 설정, PlantNet 키.

## 백업 (2026-09-17, 로그인 없이) — M4 5-4 Override

사용자 결정: 로그인 백업 대신 ① OS 기본 백업 ② 파일 내보내기·가져오기 먼저. 로그인 백업(Supabase)은 사용자 요청이 생기면 이후 업데이트로.

- Android 자동 백업: `allowBackup` + `xml/backup_rules.xml`(≤11) + `xml/data_extraction_rules.xml`(12+). files/ 의 Drift DB만 포함(25MB 한도), 사진(app_flutter/photos)은 제외. Smart Switch 등 기기 전송도 포함.
- iOS: Application Support(DB)·Documents(사진) 모두 iCloud 백업 기본 포함 → 추가 설정 없음.
- 내보내기·가져오기(`domain/backup_service.dart`, `features/my/backup_screen.dart`): `jaljarara-backup-YYYYMMDD.zip` = backup.json(공간·식물·물 준 기록·일기·설정, 품종은 학명으로 저장해 설치 간 id 차이 무관) + photos/. share_plus 로 공유, file_picker 로 가져오기(요약 확인 후 전체 교체). 테스트 3건(JSON 왕복·전체 교체·zip 왕복).
- 패키지: archive(MIT), share_plus(BSD-3), file_picker(MIT) — 비용 0.

## 디자인 확정·도감 v3 (2026-09-17)

- **라이트 팔레트 화이트 확정**(사용자 선택): background·surface #FFFFFF, primaryContainer #E6F0EA, 신규 `accentSoft` #F1F2EF(장식 전용). 베이지(Modern Cozy)와 시안 스위치 제거, DESIGN.md 1-1 갱신. settings.theme_variant 컬럼은 남기되 미사용.
- **도감 v3**(species 스키마 v7): 적정 온도(temp_opt_min/max), 아이 독성 3단계(toxic_child_level: none/irritant/toxic), 독성 설명(toxicity_note: 원인·증상·대처). 에이전트 초안을 직접 검토해 19건 수정 — 백합은 아이 독성 없음(고양이에게만 치명), 칼랑코에·코틸레돈·아이비·튤립·히아신스는 사람 기준 '자극'으로 하향. 물주기 4건(드라세나 3종·인도고무나무 8→10일), 최저 온도 43건 보정. 결과 none 343 / irritant 172 / toxic 30.
- 화면: 독성 배지가 반려동물·아이 단계를 구분하고 아래에 설명 문장 표시. 온도 문장은 "적정 18~26°C. 10°C 아래로…" 형식.
- CI: 저장소 루트가 plant_app 이라 working-directory 제거.

## 기능 5종 (2026-09-17, 악마의 변호인 검토 후 사용자 "진행해")

1. **알림에 식물 이름 + 버튼**: "몬스테라, 스킨답서스 물 줄 날이에요" + [물 줬어요]/[내일 할게요]. 백그라운드 isolate 처리(Drift shareAcrossIsolates), iOS 카테고리.
2. **사진 여러 장 식별**: 최대 5장을 한 요청으로(일일 한도 1회 차감). 확신이 낮으면 "사진 추가" 안내.
3. **도감 사진**: 위키미디어 공용 369장(CC 라이선스·저작자·원본 페이지). 431장 후보를 모아보기 22장으로 전부 눈으로 검수해 62장 제외(야외 대형 수목·풍경·세밀화·표본·잎 없는 꽃 확대). MY › 사진 출처 화면.
4. **증상으로 찾기**: 12개 증상 → 원인·대처, 물주기 조정 바로가기.
5. **알림 잠시 멈추기**: 3일·1주·2주·날짜 선택, 멈추기 전에 물 줄 식물 안내.

## 글로벌 대응 (2026-09-17)

- **언어**: gen-l10n(ko/en ARB 372키). 한국어 기기만 한국어, 나머지 전부 영어. ARB는 스크래치 표(l10n_table_*.py)에서 생성.
- **날짜·시간·요일**: intl `DateFormat.*(localeName)`, `TimeOfDay.format`. 날짜 선택기 고정 로케일 제거.
- **알림**: 문구·버튼 모두 기기 언어(`deviceL10n()`).
- **도감 영어**: names_en·toxicity_note_en·common_issues_en(545종 전부). 영어 이름으로도 검색.
- **온도 단위**: 미국 등 화씨 국가는 °F (`formatTemperature`).
- **남반구 계절**: 호주·뉴질랜드·남미 등은 6개월 밀린 달로 물주기 계절 계수 적용(`hemisphereMonth`).
- **앱 이름·권한 문구**: Android `values/strings.xml`(Jaljarara)·`values-ko`(잘자라라), iOS `en.lproj`/`ko.lproj` InfoPlist.strings + CFBundleLocalizations.
- **문서**: privacy_policy_en.md, store_listing_en.md. 한국어 처리방침의 로그인 백업(Supabase) 내용을 실제 방식(파일·OS 백업)으로 정정.
- 테스트 120건 통과(ARB 키 일치·영어에 한글 없음·°F·남반구·영어 검색·사진 출처 포함).
- **미정**: 글로벌 앱 이름("Jaljarara"는 임시).

## 다음: M4 — 백업 · 인증 · 스토어 준비
- AUTH-01(Google/Apple/Kakao), latest.json 백업·복원, MY-04 탈퇴, 개인정보 처리방침, 앱 아이콘, 릴리스 서명, 패키지명 확정
