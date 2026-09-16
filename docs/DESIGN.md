# DESIGN.md — 디자인 스펙 (Claude Code용)

> **Override 2026-09-16 (사용자 승인)**: 라이트 팔레트를 'Modern Cozy'로 교체 — background `#F4F1EB`, primary `#2C5E43`, primaryContainer/surfaceVariant `#DDE6DF`. 홈 카드는 그림자 없이 radius 16, 여백 12~16. 중앙 카메라는 탭바 위로 돌출된 FAB. 흙 확인 바텀시트는 큰 2버튼으로 직관적으로. 다크 팔레트는 변경 없음. 상세는 `PROGRESS.md` 기획 변경 항목.

작업명: 온실 (앱 이름 확정 시 치환)
톤: **Modern Cozy** — 소프트 베이지 배경 + 포레스트 그린 + 세이지 그린, 여백 많음, 광고·배너 없음. 참고 앱: 초록일기(여백·단순함), Planta(카드 정보 밀도).
원칙: 모든 색·크기·간격은 이 문서 → `lib/app/theme.dart` 상수에서만 가져온다. 화면 코드에 HEX·px 직접 입력 금지.

---

## 1. 컬러

### 1-1. 라이트 (기본)

| 토큰 | HEX | 용도 |
|---|---|---|
| `primary` | `#2C5E43` | 포레스트 그린. 주 버튼, 중앙 FAB 카메라 버튼, 활성 탭, 강조 텍스트 |
| `primaryContainer` | `#DDE6DF` | 세이지 그린. 선택 상태 배경, 태그 배경, 진행 바 트랙 |
| `onPrimary` | `#FFFFFF` | primary 위 텍스트·아이콘 |
| `background` | `#F4F1EB` | 소프트 베이지. 화면 배경 |
| `surface` | `#FFFFFF` | 카드, 바텀시트, 탭바 |
| `surfaceVariant` | `#DDE6DF` | 세이지 그린. 입력창 배경, 카드 보조 영역 |
| `outline` | `#E1E6E1` | 카드 테두리, 구분선 |
| `textPrimary` | `#1B1F1D` | 제목, 본문 |
| `textSecondary` | `#5C635F` | 부제, 설명 |
| `textTertiary` | `#9AA19C` | 캡션, 비활성, 플레이스홀더 |
| `statusNeedCheck` | `#E05A4E` | 확인 필요(흙 확인일 도래) 점·배지 |
| `statusOk` | `#2C5E43` | 정상 (= primary) |
| `statusUnknown` | `#B5BBB7` | 품종 미지정 |
| `warning` | `#D9912B` | 독성 경고 아이콘·배지 |
| `error` | `#C63C30` | 삭제, 오류 |

### 1-2. 다크

| 토큰 | HEX |
|---|---|
| `primary` | `#6DBE97` |
| `primaryContainer` | `#1F3B2F` |
| `onPrimary` | `#0E1A14` |
| `background` | `#121614` |
| `surface` | `#1B211D` |
| `surfaceVariant` | `#242B27` |
| `outline` | `#2F3733` |
| `textPrimary` | `#ECEFEC` |
| `textSecondary` | `#A9B0AB` |
| `textTertiary` | `#6E7571` |
| `statusNeedCheck` | `#F07A6E` |
| `statusOk` | `#6DBE97` |
| `statusUnknown` | `#5B625E` |
| `warning` | `#E8A64A` |
| `error` | `#E0665A` |

색 사용 규칙: 한 화면에 `primary` 계열 채도 높은 면적은 카메라 버튼 + 주 버튼 1개까지. 카드 배경에 초록 채우기 금지(선택 상태 제외).

---

## 2. 타이포그래피

폰트: **Pretendard** (OFL, 무료). `assets/fonts/Pretendard-{Regular,Medium,SemiBold,Bold}.otf`. 미로드 시 시스템 기본.

| 토큰 | 크기 / 줄높이 | 굵기 | 용도 |
|---|---|---|---|
| `headline` | 24 / 32 | Bold | 화면 제목 ("오늘", "내 식물") |
| `title` | 18 / 26 | SemiBold | 카드 제목, 섹션 제목, 식물 이름 |
| `body` | 15 / 22 | Regular | 본문, 리스트 주 텍스트 |
| `bodyStrong` | 15 / 22 | Medium | 강조 본문, 버튼 |
| `caption` | 13 / 18 | Regular | 부가 정보, 날짜, 학명 |
| `label` | 11 / 14 | Medium | 태그, 배지, 탭 라벨 |

학명은 `caption` + 이탤릭 + `textSecondary`.
숫자(D-day, 확률 %)는 `title` 이상, tabular figures 적용.

---

## 3. 간격·형태

| 항목 | 값 |
|---|---|
| 기본 그리드 | 4pt. 간격은 4·8·12·16·24·32만 사용 |
| 화면 좌우 여백 | 20 |
| 섹션 간 간격 | 24 |
| 카드 내부 패딩 | 16 |
| 카드 간 간격 | 12 |
| 카드 radius | 16 |
| 버튼 radius | 12 |
| 입력창 radius | 12 |
| 칩·배지 radius | 999 (완전 원형) |
| 썸네일 radius | 12 (정사각), 프로필 999 |
| 카드 그림자 | 없음. `outline` 1px 테두리로 구분 |
| 바텀시트 | 상단 radius 24, 드래그 핸들 36×4 |
| 탭바 높이 | 64 + safe area |
| 중앙 카메라 버튼 | 지름 56, 탭바 위로 12 돌출, `primary` 채움, 그림자 y2 blur8 alpha12% |
| 터치 영역 최소 | 44×44 |

---

## 4. 컴포넌트

### 버튼
| 종류 | 스타일 | 높이 |
|---|---|---|
| Primary | `primary` 채움, `onPrimary` 텍스트 `bodyStrong` | 52 |
| Secondary | `primaryContainer` 채움, `primary` 텍스트 | 52 |
| Text | 배경 없음, `primary` 텍스트 | 44 |
| Destructive | `error` 텍스트, 배경 없음 | 44 |
Primary 버튼은 화면당 1개. 전체 폭(좌우 여백 20).

### 식물 카드 (홈 목록)
- 좌: 썸네일 56×56 radius 12 (사진 없으면 `surfaceVariant` + 잎 아이콘)
- 중: 별명 `title`, 아래 품종 국내명 `caption` `textSecondary`
- 우: 상태 점 8px + 텍스트 `caption` ("오늘 확인" / "D-3" / "미지정")
- 높이 88, 좌우 패딩 16, 카드 radius 16, `outline` 테두리

### 오늘 확인 카드 (홈 상단)
- 체크박스(원형 24) + 썸네일 40 + 별명 `bodyStrong` + 공간명 `caption`
- 다중 선택 시 하단 고정 바: "N개 확인 완료" Primary 버튼
- 탭 → 바텀시트: "말랐어요, 물 줬어요"(Primary) / "아직 촉촉해요"(Secondary)

### 식별 후보 행
- 좌: 이미지 64×64 radius 12
- 중: 국내명 `title` / 학명 `caption` 이탤릭
- 우: 확률 `title` `primary` (예: 87%)
- 1순위 행은 `primaryContainer` 배경

### 상태 점
8px 원. 색은 1장 status 토큰. 텍스트 없이 단독 사용 금지(항상 라벨 동반).

### 독성 배지 (도감 정보 첫 줄)
- 독성 있음: `warning` 아이콘 + "반려동물·아이에게 독성" `bodyStrong`
- 없음: `statusOk` 아이콘 + "독성 없음"
- 항상 도감 페이지 최상단 카드

### 빈 상태
- 일러스트 120×120 (단색 라인, `textTertiary`) + 제목 `title` + 설명 `body` `textSecondary` + Primary 버튼
- 예: 식물 0개 → "첫 식물을 등록해 보세요" / "사진 찍기"

### 입력창
- 높이 52, `surfaceVariant` 배경, radius 12, 테두리 없음, 포커스 시 `primary` 1.5px
- 라벨은 입력창 위 `label` `textSecondary`

### 태그·칩
- 높이 28, 좌우 12, `primaryContainer` 배경, `primary` 텍스트 `label`
- 일기 상태 태그(새잎/꽃/잎 처짐/잎 노랗게/해충 의심) 선택형: 선택 시 `primary` 채움

---

## 5. 아이콘·이미지

- 아이콘: **Material Symbols Rounded**, weight 400, 기본 24, 탭바 26. 채움(fill) 스타일은 활성 탭에만.
- 탭 아이콘: 홈 `home`, 카메라 `photo_camera`, MY `person`
- 상태 아이콘: 물 `water_drop`, 비료 `eco`, 분갈이 `potted_plant`, 잎닦기 `cleaning_services`, 독성 `warning`
- 식물 대표 사진 비율 1:1 center-crop. 상세 헤더는 4:3.
- 일러스트는 단색 라인 스타일. 무료 소스(unDraw, OFL) 또는 직접 SVG. 유료 스톡 금지.

---

## 6. 모션

- 화면 전환: 기본 플랫폼 전환(iOS 슬라이드 / Android fade-through)
- 바텀시트: 250ms easeOutCubic
- 체크 완료: 체크박스 scale 1→1.15→1, 150ms
- 그 외 장식 애니메이션 없음

---

## 7. 문구 톤

- 존댓말, 해요체. 느낌표 최소.
- 알림: "오늘 확인할 식물이 3개 있어요"
- 흙 확인 선택지: "말랐어요, 물 줬어요" / "아직 촉촉해요"
- 오류: 원인 + 대안. "오늘 식별 횟수를 다 썼어요. 이름 검색으로 등록해 보세요"
- 금지: "지금 구독하세요", "프리미엄", 광고성 문구 전부

---

## 8. 화면별 레이아웃 요약

### HOME-01 (시안 `home_mockup.png` 참조)
```
상단  "오늘" headline + 날짜 caption                      (여백 20, 상단 16)
섹션1 "확인할 식물 3" title + [전체 선택]                  (24 아래)
      오늘 확인 카드 × N (12 간격)
섹션2 "내 식물 12" title + [목록|공간] 세그먼트 토글
      식물 카드 × N (12 간격)
      "+ 식물 추가" Secondary 버튼
탭바  홈 · (카메라) · MY
```

### CAM-03
```
상단  촬영 사진 4:3
      확률 ≥ 80%: 확정 카드(primaryContainer) + "이 식물이 맞아요" Primary
      미만: "이 중에 있나요?" title + 후보 행 × 3~5
하단  "목록에 없어요" Text 버튼
```

### PLT-01
```
헤더  사진 4:3 + 별명 headline + 품종·학명 caption
카드1 다음 확인 D-day(title, primary) + 관리 일정 3줄(물/비료/분갈이)
카드2 생장 일기 타임라인 (최근 3개 + 더보기)
카드3 도감 정보 (독성 배지 첫 줄)
하단  [일기 쓰기] Primary
```

### MY-01
```
카드  통계 3칸 (물주기 횟수 / 새잎 / 연속일)  숫자 headline
리스트 백업·복원 / 알림 시간 / 품종 요청 / 계정 / 약관 / 문의 / 버전
```

---

## 9. Flutter 적용

- `lib/app/theme.dart`: `AppColors`(light/dark), `AppText`, `AppSpace`, `AppRadius` 클래스로 위 토큰 정의. `ThemeData`에 `colorScheme`, `textTheme` 매핑.
- `ThemeMode.system`.
- 위젯: `PlantCard`, `TodayCheckTile`, `CandidateRow`, `StatusDot`, `ToxicBadge`, `EmptyState`, `AppButton(primary/secondary/text)` 을 `lib/app/widgets/`에 공통화. 화면에서 직접 `Container` 스타일링 금지.
- 폰트 로드: `pubspec.yaml` fonts 항목 Pretendard 4종.
