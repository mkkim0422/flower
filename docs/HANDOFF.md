# 식물 관리 앱 — Claude Code 인수인계서

작성일: 2026-09-16
목적: 이 문서 하나로 Claude Code가 프로젝트 초기 세팅부터 MVP 구현까지 진행할 수 있어야 한다.
읽는 순서: 0 → 1 → 2 → 8 → 9 순으로 먼저 읽고, 구현 시 3~7을 참조.

---

## 0. 절대 전제 (모든 판단의 기준)

1. **기능은 6개 벤치마크 앱의 장점에서만 가져온다.** 세계 Top3(Planta, PictureThis, Greg) + 국내 Top3(플랜트노트, 그루우, 초록일기). 이 목록에 근거 없는 기능은 추가하지 않는다.
2. **단점은 보완 가능한 것만 채택한다.** 보완책이 없는 기능은 뺀다.
3. **개인 비용 0.** 유료 API·유료 서버·유료 라이브러리 금지. 유일한 예외는 스토어 등록비(Apple $99/년, Google $25/1회).
4. 1차 목표는 **유저 수 확보**. 결제·구독·광고 화면은 MVP에 넣지 않는다. 유료화는 2차 이후.
5. Android / iOS 동시 출시.

이 5개와 충돌하는 요청·구현 아이디어가 생기면 진행하지 말고 사용자에게 먼저 확인한다.

---

## 1. 벤치마크 → 채택 기능 매핑

| # | 채택 기능 | 출처 앱 | 보완한 원본 단점 |
|---|---|---|---|
| F1 | 화분 크기·배수구·창 방향·창과의 거리 입력 → 물주기 주기 자동 계산 | Planta | 서양 품종 위주 DB → 국내 유통 명칭 DB 병행 |
| F2 | 물주기 외 관리 알림 (비료 / 분갈이 / 잎 닦기) | Planta | 유료 → 전부 무료 |
| F3 | 사진 식별, 확률 순 후보 리스트 | PictureThis | 유료·구독 유도 → 무료, 결제 화면 없음 |
| F4 | 식물 도감 정보 (독성 최우선 → 물 → 빛 → 온도 → 흔한 문제) | PictureThis | 사진·위치 과수집 → 사진 서버 미보관 |
| F5 | 계절(월별) 보정 계수 | Greg(날씨 반영) 축소판 | 미국 날씨 기준 → 월별 계수로 대체, 2차에 기상청 API |
| F6 | 국내 유통 명칭 + 학명 병기 DB, 이름 검색 등록 | 플랜트노트 | 주기 수동 입력 → 자동 기본값 + 수동 조정 |
| F7 | 사진 생장 일기 (타임라인) | 플랜트노트 | — |
| F8 | 공간(거실/베란다…)별 화분 배치 뷰 | 초록일기 | 식별 없음 → F3로 해결 |
| F9 | 광고·구독 유도 없는 단순 홈 | 초록일기·플랜트노트 | — |
| F10 | 최신 UI, 중앙 카메라 버튼 | 그루우 | 커머스 산만 → 홈은 "오늘 할 일"만 |
| F11 | 내 기록 통계 (물주기 횟수 / 새잎 / 연속 관리일) | — (3인 토론 결과) | MY 탭 공백 보완 |

**토론에서 추가·변경된 규칙**
- 알림은 "오늘 물 주세요"가 아니라 **"흙 확인"** 알림. 확인 결과(말랐음/젖음)를 입력받아 주기를 자동 보정한다.
- 카메라 광량 측정은 **채택하지 않는다**(센서 편차 큼). 창 방향 + 창과의 거리 선택으로 대체.
- 여러 식물 **다중 선택 일괄 완료** 지원.
- 로그인은 온보딩이 아니라 **백업 시점**에 요청. 데이터는 로컬 우선.

**MVP 제외 (2차)**: 병해 진단, 기상청 날씨 보정, 커뮤니티, 탐색 탭, 유료화.

---

## 2. 기술 스택 (비용 0 검증 완료)

| 영역 | 선택 | 근거 |
|---|---|---|
| 프레임워크 | **Flutter** (stable 최신) | 단일 코드베이스, TFLite 플러그인 성숙, 로컬 DB 생태계 좋음 |
| 상태관리 | Riverpod | 테스트 용이 |
| 로컬 DB | **Drift** (SQLite) | 오프라인 우선, 마이그레이션 지원 |
| 알림 | flutter_local_notifications | 서버 불필요 |
| 백업/인증 | **Supabase 무료 티어** (Auth + Postgres 500MB + Storage 1GB) | 무료, Google/Apple/Kakao OAuth 지원 |
| 식별 (1단계) | **PlantNet API 무료** (`my-api.plantnet.org`, 500회/일) | 즉시 사용 가능. 일 한도 초과 시 "내일 다시" 안내 |
| 식별 (2단계) | **온디바이스 TFLite** 모델 | 별도 트랙. 오픈 데이터셋(PlantNet-300K, iNaturalist)으로 학습. 준비되면 1단계보다 우선 호출 |
| 이미지 처리 | image, flutter_image_compress | 식별 전 1024px 리사이즈 |
| 날씨 (2차) | 기상청 공공데이터포털 API | 무료 |
| CI | GitHub Actions 무료 | 빌드·테스트만. 배포는 수동 |
| 크래시/분석 | Firebase Crashlytics + Analytics 무료 | 선택. 넣으면 개인정보 처리방침에 명시 |

**금지**: Plant.id(유료), Google Cloud Vision(과금), 유료 폰트/아이콘, 유료 지도 SDK.

---

## 3. IA / 화면 정의

### 3-1. 탭 구조
```
[하단 탭]  홈  ·  (카메라: 중앙 강조 버튼)  ·  MY
```
2차에 "탐색" 탭 추가(도감+커뮤니티) → 4탭.

### 3-2. 화면 목록

| 화면ID | 화면명 | 진입 | 핵심 요소 |
|---|---|---|---|
| ONB-01 | 인트로 | 최초 실행 | 슬라이드 3장, "시작하기". 로그인 없음 |
| ONB-02 | 권한 안내 | 인트로 후 | 알림 권한 요청. 카메라 권한은 카메라 첫 사용 시 |
| HOME-01 | 홈 | 탭 | ① 오늘 확인할 식물 리스트 (다중 선택 → 일괄 완료) ② 내 식물 목록 (목록↔공간별 토글) ③ "+ 식물 추가" ④ 우상단 설정 아이콘 없음(MY 탭 사용). 식물 0개면 빈 상태 CTA |
| HOME-02 | 흙 확인 결과 입력 | 오늘 할 일 탭 시 | "말랐어요 → 물 줬어요" / "아직 촉촉해요" 2버튼. 결과에 따라 주기 보정 |
| ADD-01 | 식물 추가 방법 선택 | HOME-01 | 카메라 식별 / 이름 검색 / 직접 입력 |
| ADD-02 | 이름 검색 | ADD-01 | 국내명·학명 동시 검색, 결과 탭 → ADD-04 |
| ADD-03 | 직접 입력 | ADD-01 | 이름만 입력, 품종 미지정(기본 주기 7일) |
| ADD-04 | 환경 입력 | 식별/검색/직접 후 | 화분 크기(S/M/L) · 배수구(유/무) · 공간 선택(→SPC-02) · 마지막 물 준 날 · 별명 |
| CAM-01 | 카메라 | 탭 | 촬영 / 앨범. 가이드 문구 "잎 전체가 나오게" |
| CAM-02 | 식별 중 | CAM-01 | 로딩. PlantNet 호출 (일 한도 시 CAM-04) |
| CAM-03 | 식별 결과 | CAM-02 | 1순위 확률 ≥ 0.80 → 확정 카드 + "이 식물이 맞아요". 미만 → 후보 3~5개 리스트(학명 + 국내명 + %). 하단 "목록에 없어요 → 직접 입력" |
| CAM-04 | 식별 불가 안내 | 한도/네트워크 오류 | "오늘 식별 횟수를 다 썼어요. 이름 검색으로 등록해 보세요" |
| PLT-01 | 식물 상세 | 목록 탭 | 헤더(사진·별명·품종) · 다음 확인일 · 관리 일정 카드(물/비료/분갈이, 자동값 표시 + 수동 조정) · 생장 일기 타임라인 · 관리 이력 · 도감 정보 링크 · 편집/삭제/공간 이동 |
| PLT-02 | 관리 주기 조정 | PLT-01 | 자동 계산 근거 표시(품종 기본 × 계절 × 빛 × 화분) + 수동 슬라이더 |
| DIA-01 | 일기 작성 | PLT-01 | 사진(촬영/앨범) · 메모 · 상태 태그(새잎/꽃/잎 처짐/잎 노랗게/해충 의심) |
| INFO-01 | 도감 정보 | PLT-01, ADD-02 | 순서 고정: 독성(아이/반려동물) → 물 → 빛 → 온도·습도 → 흔한 문제 → "내 식물로 등록" |
| SPC-01 | 공간별 뷰 | HOME-01 토글 | 공간 카드 안에 화분 썸네일 + 상태 점(빨강=확인 필요) |
| SPC-02 | 공간 추가/편집 | SPC-01, ADD-04 | 이름 · 창 방향(동/서/남/북/창 없음) · 창과의 거리(창가/1m 이내/멀리) |
| MY-01 | MY | 탭 | ① 통계 카드(이번 달 물주기 횟수 / 새잎 태그 수 / 연속 관리일) ② 백업·복원(→AUTH-01) ③ 알림 시간 ④ 품종 추가 요청 ⑤ 계정·탈퇴 ⑥ 약관·개인정보 ⑦ 문의 ⑧ 버전 |
| AUTH-01 | 로그인 | MY-01 백업 시 | Google / Apple / Kakao. 설명 문구 "백업하려면 로그인이 필요해요" |
| MY-02 | 알림 설정 | MY-01 | 확인 알림 시간(기본 09:00), 요일 제외 |
| MY-03 | 품종 추가 요청 | MY-01, CAM-03 | 식물명 · 사진(선택) · 메모 → Supabase 테이블 저장 |
| MY-04 | 계정 / 탈퇴 | MY-01 | 탈퇴 시 서버 데이터 삭제 + 로컬 삭제 여부 선택 |

### 3-3. 스토어 필수 준수
- 소셜 로그인 제공 시 iOS는 **Apple 로그인 필수**.
- **회원 탈퇴** 메뉴 앱 내 필수 (양 스토어).
- 카메라·알림 권한은 **사용 시점**에 요청, 이유 문구 표시.
- 개인정보 처리방침 URL 필요 (GitHub Pages 무료로 호스팅).
- 식별용 사진은 **서버에 저장하지 않는다** (API 호출 후 폐기). 처리방침에 명시.

---

## 4. 데이터 모델 (Drift)

```
species          # 품종 마스터 (앱 번들 JSON → 첫 실행 시 DB 시드)
  id, scientific_name, ko_names[] (국내 유통명 복수), family,
  base_water_days (기본 물주기 일수), light_pref (low/med/high),
  toxic_pet (bool), toxic_child (bool), temp_min, temp_max,
  fert_days, repot_months, common_issues[] (텍스트)

spaces
  id, name, window_dir (E/W/S/N/none), window_dist (near/1m/far), sort_order

plants
  id, species_id (nullable), nickname, photo_path, space_id,
  pot_size (S/M/L), has_drainage (bool),
  water_interval_days (현재 적용 주기, 계산값 또는 수동값),
  manual_override (bool), last_watered_at, next_check_at,
  fert_interval_days, last_fert_at, repot_at, created_at

care_events
  id, plant_id, type (water/fert/repot/wipe/check_dry/check_wet), at, note

diary_entries
  id, plant_id, photo_path, memo, tags[] (new_leaf/flower/droop/yellow/pest), at

identification_logs      # 자체 모델 학습용. 사진은 로컬에만
  id, local_photo_path, candidates_json, user_selected_species_id, at

settings
  notify_hour, notify_minute, skip_weekdays[], backup_user_id (nullable)
```

**품종 시드 데이터**: `assets/species_ko.json`. 1차 목표 300종(국내 유통 관엽·다육·허브·꽃). 출처는 공공 데이터(농촌진흥청 국립원예특작과학원 실내식물 정보, 공공데이터포털)와 위키 학명. 국내명 복수 허용(예: "스킨답서스" ↔ "에피프레넘").

---

## 5. 핵심 알고리즘

### 5-1. 물주기 주기 계산
```
interval = base_water_days(species)
         × season_coef(month)
         × light_coef(window_dir, window_dist)
         × pot_coef(pot_size, has_drainage)
         × feedback_coef(plant)

season_coef:  3~5월 1.0 / 6~8월 0.8 / 9~10월 1.0 / 11~2월 1.4
light_coef:   남향·창가 0.8 / 동·서 창가 0.9 / 북향 또는 멀리 1.2 / 창 없음 1.3
pot_coef:     S 0.85 / M 1.0 / L 1.2, 배수구 없음 ×1.2
feedback_coef: 초기 1.0. "아직 촉촉" 입력 시 ×1.15, "말랐음" 이 2회 연속이면 ×0.9. 범위 0.5~2.0로 클램프.

next_check_at = last_watered_at + round(interval)
manual_override = true 이면 계산 무시, 사용자 값 사용.
품종 미지정(직접 입력)이면 base = 7.
```
계산식과 계수는 `lib/domain/watering_rules.dart`에 상수로 두고 단위 테스트 필수.

### 5-2. 식별 파이프라인
```
1. 사진 → 1024px 리사이즈, EXIF 제거
2. (2단계 준비 시) 온디바이스 TFLite 추론 → 1순위 ≥ 0.80이면 종료
3. PlantNet API 호출 (organs=leaf 기본, project=all)
   - 일 카운터 로컬 저장, 480회 도달 시 호출 안 함 → CAM-04
4. 응답 candidates → species DB와 학명 매칭 → 국내명 병기
   - 매칭 실패 종은 학명만 표시, 등록 시 species_id null + 학명을 nickname 힌트로
5. 결과 표시 규칙: 1순위 ≥ 0.80 확정 / 미만 상위 5개 리스트
6. 사용자 선택 → identification_logs 저장 (사진 로컬 경로만)
7. 원본 사진은 서버 전송 후 즉시 메모리 해제, 앱 내 저장은 식물 대표사진으로만
```
API 키는 `--dart-define`으로 주입. 저장소에 커밋 금지.

### 5-3. 알림
- 매일 `notify_hour`에 로컬 알림 1건: "오늘 확인할 식물 N개".
- 앱 실행 시 `next_check_at ≤ today` 식물을 홈 상단에 집계.
- 알림 스케줄은 앱이 포그라운드로 올 때마다 재계산(백그라운드 서비스 사용 안 함 — 배터리·심사 이슈 회피).

### 5-4. 백업/복원
- 로그인 후 "지금 백업": 로컬 DB 전체를 JSON으로 직렬화 → Supabase Storage `backups/{user_id}/latest.json` 덮어쓰기. 사진은 Storage `photos/{user_id}/` (1GB 한도 안내, 초과 시 사진 제외 백업).
- 복원: 새 기기에서 로그인 → latest.json 다운로드 → 로컬 DB 교체(확인 다이얼로그).
- 자동 동기화는 MVP에서 하지 않는다(무료 티어 트래픽 절약).

---

## 6. 프로젝트 구조

```
plant_app/
  lib/
    main.dart
    app/            # 라우팅(go_router), 테마, 탭 스캐폴드
    core/           # 상수, 유틸, 에러
    data/
      db/           # Drift 테이블·DAO
      seed/         # species_ko.json 로더
      remote/       # plantnet_client.dart, supabase_client.dart
    domain/
      watering_rules.dart
      identification_service.dart
      backup_service.dart
      stats_service.dart
    features/
      onboarding/  home/  add_plant/  camera/  plant_detail/
      diary/  species_info/  spaces/  my/  auth/
  assets/
    species_ko.json
    images/
  test/
    domain/watering_rules_test.dart   # 필수
    domain/identification_service_test.dart
  .github/workflows/ci.yml           # flutter analyze + test
  docs/
    privacy_policy.md                 # GitHub Pages로 호스팅
    HANDOFF.md                        # 이 문서
    DESIGN.md                         # 디자인 스펙 (theme.dart의 원본)
    home_mockup.png                   # HOME-01 시안
```

---

## 7. UI 규칙

**색·타이포·간격·컴포넌트는 `docs/DESIGN.md`가 단일 기준이다. 아래는 요약이며 충돌 시 DESIGN.md 우선. 홈 화면 시안: `docs/home_mockup.png` (라이트/다크).**

- 홈 화면에는 **광고·배너·프로모션 영역 없음**.
- 하단 탭 3개, 중앙 카메라는 원형 강조 버튼(탭바 위로 살짝 돌출).
- 식물 카드 상태 점: 빨강(확인 필요) / 초록(정상) / 회색(품종 미지정).
- 도감 정보 페이지 첫 섹션은 항상 **독성 여부** (아이콘 + 한 줄).
- 후보 리스트 각 행: 대표 이미지(PlantNet 응답 이미지 URL) · 국내명(굵게) · 학명(회색, 이탤릭) · 확률 %.
- 빈 상태(식물 0개, 일기 0개)마다 일러스트 + CTA 1개.
- 폰트: 시스템 기본(Pretendard 등 유료 아님이면 허용). 아이콘: Material Symbols.
- 다크 모드 지원(시스템 따름).

---

## 8. 구현 순서 (마일스톤)

**M0 — 세팅 (1일)**
- Flutter 프로젝트 생성, 패키지 설치, go_router 3탭 스캐폴드, Drift 스키마, CI.
- 완료 기준: 빈 3탭 앱이 Android·iOS 시뮬레이터에서 실행, `flutter test` 통과.

**M1 — 식물 등록 + 물주기 코어 (핵심)**
- species 시드 로드, ADD-01~04, SPC-02, PLT-01, watering_rules + 테스트, HOME-01 오늘 할 일, HOME-02 흙 확인, 로컬 알림.
- 완료 기준: 이름 검색으로 식물 등록 → 다음 확인일 계산 → 알림 수신 → 흙 확인 입력 → 주기 보정까지 E2E 동작.

**M2 — 카메라 식별**
- CAM-01~04, PlantNet 연동, 일 한도 카운터, 후보 리스트, identification_logs.
- 완료 기준: 실제 식물 사진 10장 테스트, 한도 초과 시나리오 확인.

**M3 — 일기 · 공간 뷰 · 도감 · 통계**
- DIA-01, SPC-01, INFO-01, MY-01 통계.

**M4 — 백업 · 인증 · 스토어 준비**
- AUTH-01(Google/Apple/Kakao), 백업·복원, MY-04 탈퇴, 개인정보 처리방침 페이지, 스토어 스크린샷·설명.
- 완료 기준: TestFlight / 내부 테스트 트랙 업로드.

**M5 (2차, 별도 지시 전까지 착수 금지)**: 온디바이스 모델, 병해 진단, 기상청 날씨 보정, 커뮤니티, 탐색 탭, 유료화.

---

## 9. 완료 정의 (MVP DoD)

- [ ] 로그인 없이 식물 등록·알림·일기·식별 전부 사용 가능
- [ ] 결제·구독·광고 UI 없음
- [ ] 외부 유료 서비스 호출 0건 (`grep`으로 plant.id, vision.googleapis 등 부재 확인)
- [ ] 식별 사진 서버 저장 안 함 (코드 리뷰로 확인)
- [ ] `watering_rules_test.dart` 계수별 케이스 20개 이상 통과
- [ ] Apple 로그인·탈퇴 메뉴·권한 사유 문구·처리방침 URL 존재
- [ ] Android 8.0+ / iOS 15+ 실기기 각 1대 이상 수동 테스트
- [ ] species_ko.json 300종 이상, 독성 정보 누락 0건

---

## 10. 사용자에게 확인이 필요한 미결 사항

1. 앱 이름 / 패키지명 (`com.xxx.plantapp`)
2. Kakao 로그인 포함 여부 (Kakao Developers 앱 등록 필요, 무료)
3. species 시드 300종 작성을 Claude Code가 공공 데이터로 생성할지, 사용자가 제공할지
4. Crashlytics/Analytics 포함 여부 (포함 시 처리방침 문구 추가)
5. ~~디자인 시안 유무~~ → `DESIGN.md` + `home_mockup.png` 제공됨. 나머지 화면은 DESIGN.md 8장 레이아웃 요약대로 구현

---

## 11. Claude Code 작업 지침

- 작업 시작 전 이 문서 0장을 다시 읽고, 충돌 시 멈추고 질문한다.
- 각 마일스톤 종료마다 `docs/PROGRESS.md`에 완료 항목·미완 항목·결정 사항을 기록한다.
- 새 패키지 추가 시 라이선스(MIT/BSD/Apache만 허용)와 비용을 PROGRESS.md에 적는다.
- API 키·비밀값은 커밋하지 않는다. `.env.example`만 커밋.
- 커밋 단위는 화면ID 또는 기능 단위. 메시지 예: `feat(CAM-03): 식별 후보 리스트 UI`.
- 벤치마크 6개 앱에 없는 기능 아이디어가 떠오르면 구현하지 말고 PROGRESS.md "제안" 섹션에만 적는다.
