// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appName => '잘자라라';

  @override
  String get commonCancel => '취소';

  @override
  String get commonSave => '저장';

  @override
  String get commonDelete => '삭제';

  @override
  String get commonRemove => '지우기';

  @override
  String get commonClose => '닫기';

  @override
  String get commonNext => '다음';

  @override
  String get commonLater => '나중에';

  @override
  String get commonToday => '오늘';

  @override
  String get commonYesterday => '어제';

  @override
  String get commonPickDate => '직접 선택';

  @override
  String get commonComingSoon => '준비 중';

  @override
  String get commonLoadFailed => '불러오지 못했어요';

  @override
  String get commonPhotoLoadFailed => '사진을 가져오지 못했어요';

  @override
  String get commonTakePhoto => '사진 찍기';

  @override
  String get commonPickFromAlbum => '앨범에서 고르기';

  @override
  String get commonAlbum => '앨범';

  @override
  String get commonSearchByName => '이름으로 검색';

  @override
  String get commonManualEntry => '직접 입력';

  @override
  String commonDays(int count) {
    return '$count일';
  }

  @override
  String commonEveryDays(int count) {
    return '$count일마다';
  }

  @override
  String get listSeparator => ', ';

  @override
  String get nameSeparator => '·';

  @override
  String get speciesUnknown => '품종 미지정';

  @override
  String get tabHome => '홈';

  @override
  String get tabCamera => '카메라';

  @override
  String get tabMy => 'MY';

  @override
  String get semanticsSelect => '선택';

  @override
  String get statusToday => '오늘 물 주기';

  @override
  String statusDaysLeft(int count) {
    return 'D-$count';
  }

  @override
  String statusOverdue(int count) {
    return 'D+$count';
  }

  @override
  String get dangerPetAndChild => '반려동물·아이에게 위험해요';

  @override
  String get dangerChild => '아이에게 위험해요';

  @override
  String get dangerPet => '반려동물에게 위험해요';

  @override
  String get toxicMildNote => '참고: 반려동물이나 아이가 잎을 씹으면 배탈이 날 수 있어요';

  @override
  String get windowDirE => '동향';

  @override
  String get windowDirW => '서향';

  @override
  String get windowDirS => '남향';

  @override
  String get windowDirN => '북향';

  @override
  String get windowDirNone => '창 없음';

  @override
  String get windowDistNear => '창가';

  @override
  String get windowDistOneMeter => '1m 이내';

  @override
  String get windowDistFar => '멀리';

  @override
  String get potSizeS => '작음';

  @override
  String get potSizeM => '보통';

  @override
  String get potSizeL => '큼';

  @override
  String get diaryTagNewLeaf => '새잎';

  @override
  String get diaryTagFlower => '꽃';

  @override
  String get diaryTagDroop => '잎 처짐';

  @override
  String get diaryTagYellow => '잎 노랗게';

  @override
  String get diaryTagPest => '해충 의심';

  @override
  String get notifChannelName => '물 주기 알림';

  @override
  String get notifChannelDesc => '물 줄 날에 식물 이름과 함께 알려드려요';

  @override
  String get notifActionWatered => '물 줬어요';

  @override
  String get notifActionSnooze => '내일 할게요';

  @override
  String get notifActionWateredEarly => '오늘 미리 줬어요';

  @override
  String notifWhoMore(String names, int count) {
    return '$names 외 $count개';
  }

  @override
  String notifBodyToday(String who, int count) {
    return '$who 물 줄 날이에요';
  }

  @override
  String notifBodyTomorrow(String who, int count) {
    return '내일은 $who 물 줄 날이에요';
  }

  @override
  String get onbSlide1Title => '내 식물, 잘 자라게';

  @override
  String get onbSlide1Body => '이름을 검색하거나 사진을 찍어 등록하면\n환경에 맞는 물주기를 계산해 드려요';

  @override
  String get onbSlide2Title => '물 주는 날을 놓치지 않게';

  @override
  String get onbSlide2Body =>
      '품종에 맞는 주기로 물 줄 날을 알려드리고,\n\"물 줬어요\" 한 번이면 다음 날짜가 잡혀요';

  @override
  String get onbSlide3Title => '로그인 없이, 광고 없이';

  @override
  String get onbSlide3Body => '기록은 기기에만 저장돼요.\n사진은 서버에 백업되지 않아요';

  @override
  String get onbStart => '시작하기';

  @override
  String get onbPermTitle => '물 주는 날 알려드릴게요';

  @override
  String get onbPermBody => '물 줄 날 오전 9시에 알려드려요.\n시간은 MY에서 바꿀 수 있어요';

  @override
  String get onbPermAllow => '알림 허용';

  @override
  String get homeTitle => '오늘';

  @override
  String get homeLoadFailed => '불러오지 못했어요. 앱을 다시 열어 보세요';

  @override
  String get homeEmptyTitle => '첫 식물을 등록해 보세요';

  @override
  String get homeEmptyBody => '사진을 찍으면 품종과 물주기를 알려드려요';

  @override
  String get homeAddPlant => '식물 추가';

  @override
  String get homeAddPlantPlus => '+ 식물 추가';

  @override
  String homeDueHeader(int count) {
    return '물 줄 식물 $count';
  }

  @override
  String get homeSelectAll => '전체 선택';

  @override
  String get homeDeselect => '선택 해제';

  @override
  String get homeNothingDue => '오늘 물 줄 식물이 없어요';

  @override
  String homeMyPlants(int count) {
    return '내 식물 $count';
  }

  @override
  String homeWateredCount(int count) {
    return '$count개 물 줬어요';
  }

  @override
  String get homeViewGrid => '앨범';

  @override
  String get homeViewList => '목록';

  @override
  String homePausedBanner(String date) {
    return '알림이 $date까지 멈춰 있어요';
  }

  @override
  String get homeResume => '다시 켜기';

  @override
  String waterSheetPlants(int count) {
    return '식물 $count개';
  }

  @override
  String get waterSheetWatered => '물 줬어요';

  @override
  String waterSheetLater(int count) {
    return '나중에 줄게요 · $count일 뒤 다시 알려드려요';
  }

  @override
  String get addTitle => '식물 추가';

  @override
  String get addHowTo => '어떻게 등록할까요?';

  @override
  String get addByPhoto => '사진으로 식별';

  @override
  String get addByPhotoSub => '잎 전체가 나오게 찍으면 품종을 찾아드려요';

  @override
  String get addByNameSub => '국내 유통명이나 학명으로 찾아요';

  @override
  String get addManualSub => '품종을 몰라도 이름만으로 등록해요';

  @override
  String get manualPlantName => '식물 이름';

  @override
  String get manualHint => '예: 창가 초록이';

  @override
  String get manualInfo =>
      '품종을 지정하지 않으면 물주기는 7일 기본값으로 시작해요. 상세 화면에서 언제든 바꿀 수 있어요';

  @override
  String get registerTitle => '내 식물로 등록';

  @override
  String get registerNotInCatalog => '도감에 없는 품종이에요. 이름은 직접 정해 주세요';

  @override
  String get registerName => '이름';

  @override
  String get registerNameHint => '예: 거실 몬스테라';

  @override
  String get registerLastWatered => '마지막으로 물 준 날';

  @override
  String registerInterval(int count) {
    return '약 $count일마다 물 주는 날을 알려드려요';
  }

  @override
  String get registerIntervalManual => ' (직접 설정)';

  @override
  String get registerEditInterval => '주기 수정';

  @override
  String registerBackToAuto(int count) {
    return '자동($count일)으로';
  }

  @override
  String get registerMemo => '메모 (선택)';

  @override
  String get memoHint => '예: 베란다 왼쪽. 잎이 처지면 물 부족';

  @override
  String get registerSubmit => '등록하기';

  @override
  String get searchTitle => '이름으로 검색';

  @override
  String get searchHint => '예: 몬스테라, Monstera';

  @override
  String get searchCatalogFailed => '품종 목록을 불러오지 못했어요';

  @override
  String get searchNotListed => '목록에 없어요 → 직접 입력';

  @override
  String get searchPrompt => '국내명이나 학명을 입력해 보세요';

  @override
  String get searchError => '검색 중 문제가 생겼어요';

  @override
  String searchNoResult(String query) {
    return '\"$query\"에 맞는 품종이 없어요.\n아래에서 직접 입력으로 등록해 보세요';
  }

  @override
  String searchAlsoKnownAs(String alias) {
    return '$alias(으)로도 불려요';
  }

  @override
  String get searchViewCatalog => '도감 보기';

  @override
  String get cameraTitle => '식별';

  @override
  String get cameraGuide => '잎 전체가 나오게 찍어 주세요';

  @override
  String get cameraTip1 => '밝은 곳에서, 잎이 화면의 절반 이상 차게';

  @override
  String get cameraTip2 => '꽃이 있으면 꽃도 함께 찍으면 더 정확해요';

  @override
  String get cameraPickFailed => '사진을 가져오지 못했어요. 권한을 확인하거나 다른 사진으로 시도해 보세요';

  @override
  String get cameraPreparing => '준비 중…';

  @override
  String get identifyTitle => '식별 결과';

  @override
  String get identifyAddPhoto => '사진 추가';

  @override
  String get identifyAddPhotoTip => '잎을 가까이, 또는 꽃이 있으면 꽃을 찍으면 더 정확해져요';

  @override
  String get identifyAddPhotoHint => '잎을 가까이, 또는 꽃을 찍어 추가하면 더 정확해져요';

  @override
  String get identifyPhotoGoesCover => '찍은 사진은 대표 사진으로 들어가요';

  @override
  String get identifySearching => '어떤 식물인지 찾고 있어요';

  @override
  String identifySearchingMulti(int count) {
    return '사진 $count장으로 다시 찾고 있어요';
  }

  @override
  String get identifyThisIsIt => '이 식물이 맞아요';

  @override
  String get identifyOtherCandidates => '다른 후보';

  @override
  String get identifyNotListed => '목록에 없어요';

  @override
  String get identifyIsItHere => '이 중에 있나요?';

  @override
  String get identifyNotInCatalog => '도감에 없는 품종 · 등록하면 이름을 직접 정할 수 있어요';

  @override
  String get identifyLimitTitle => '오늘 식별 횟수를 다 썼어요';

  @override
  String get identifyLimitBody => '내일 다시 시도하거나, 이름 검색으로 등록해 보세요';

  @override
  String get identifyOfflineTitle => '인터넷에 연결되지 않았어요';

  @override
  String get identifyOfflineBody => '연결을 확인하고 다시 시도하거나, 이름 검색으로 등록해 보세요';

  @override
  String get identifyNoResultTitle => '식물을 찾지 못했어요';

  @override
  String get identifyNoResultBody => '잎이나 꽃을 가까이 찍어 추가하거나, 이름 검색으로 등록해 보세요';

  @override
  String get identifyUnavailableTitle => '지금은 식별을 할 수 없어요';

  @override
  String get identifyUnavailableBody =>
      '식별 서버 연결이 아직 설정되지 않았어요. 이름 검색으로 등록해 보세요';

  @override
  String get identifyRetryWithPhoto => '사진 추가해서 다시 찾기';

  @override
  String get identifyManualRegister => '직접 입력으로 등록';

  @override
  String get diaryWriteTitle => '일기 쓰기';

  @override
  String diaryWriteTitleFor(String name) {
    return '$name 일기';
  }

  @override
  String get diaryRemovePhoto => '사진 지우기';

  @override
  String get diarySetCover => '대표 사진으로 설정';

  @override
  String get diaryLabel => '일기';

  @override
  String get diaryHint => '오늘 식물은 어땠나요? 새잎이 났는지, 잎이 처졌는지…';

  @override
  String get detailDeleted => '삭제된 식물이에요';

  @override
  String get detailRename => '이름 바꾸기';

  @override
  String get detailMyMemo => '내 메모';

  @override
  String get detailPlace => '놓는 곳';

  @override
  String get detailPlaceNone => '지정 안 함';

  @override
  String get detailAddPlace => '+ 새 장소 추가';

  @override
  String get detailChangePlace => '놓는 곳 바꾸기';

  @override
  String get detailDeleteDiaryQ => '이 일기를 지울까요?';

  @override
  String detailDeletePlantQ(String name) {
    return '$name을(를) 삭제할까요?';
  }

  @override
  String get detailDeletePlantBody => '물 준 기록과 메모도 함께 지워져요';

  @override
  String get detailCatalogPhoto => '도감 사진';

  @override
  String detailOverdue(int count) {
    return '물 주는 날이 $count일 지났어요';
  }

  @override
  String get detailDueToday => '오늘 물 주는 날이에요';

  @override
  String get detailUntilNext => '다음 물 주는 날까지';

  @override
  String get detailDDay => 'D-day';

  @override
  String get detailIntervalManual => ' (직접 설정)';

  @override
  String get detailIntervalAuto => ' (자동)';

  @override
  String detailLastWatered(String date) {
    return ' · 마지막 $date';
  }

  @override
  String get detailAdjust => '주기 조정';

  @override
  String get detailAddMemo => '+ 메모 남기기';

  @override
  String get detailDiaryWrite => '+ 쓰기';

  @override
  String get detailDiaryEmpty => '사진과 한 줄 메모로 자라는 모습을 남겨 보세요';

  @override
  String detailDiaryMore(int count) {
    return '외 $count개';
  }

  @override
  String get detailGoodToKnow => '알아두면 좋은 정보';

  @override
  String get detailNoSpeciesInfo =>
      '품종을 지정하면 키우기 정보를 보여드려요. 카메라로 식별하거나 이름으로 검색해 보세요';

  @override
  String get detailSymptomEntry => '식물이 아파 보이나요? 증상으로 원인 찾기';

  @override
  String get detailAlreadyWatered => '오늘은 이미 물을 줬어요';

  @override
  String get detailWateredToday => '오늘 물 줬어요';

  @override
  String get detailWatered => '물 줬어요';

  @override
  String tipWaterSucculent(int days) {
    return '물은 $days일쯤에 한 번, 흙이 속까지 완전히 마른 뒤 흠뻑 주세요. 과습이 가장 흔한 실패 원인이에요';
  }

  @override
  String tipWaterHerb(int days) {
    return '물은 $days일쯤에 한 번, 겉흙이 마르면 바로 주세요. 허브는 마르면 잎이 금방 처져요';
  }

  @override
  String tipWaterFlower(int days) {
    return '물은 $days일쯤에 한 번, 겉흙이 마르면 주세요. 꽃이 피는 동안은 조금 더 자주 살펴 주세요';
  }

  @override
  String tipWaterFoliage(int days) {
    return '물은 $days일쯤에 한 번, 화분 밑으로 흘러나올 만큼 흠뻑 주세요. 받침에 고인 물은 버려 주세요';
  }

  @override
  String get tipLightLow =>
      '빛이 적은 곳에서도 잘 자라요. 직사광선은 잎을 태울 수 있으니 창가에서 조금 떨어뜨려 두세요';

  @override
  String get tipLightMed => '밝은 간접광을 좋아해요. 커튼을 친 창가나 창에서 1m 안쪽이 좋아요';

  @override
  String get tipLightHigh => '햇빛을 많이 받아야 해요. 남향이나 동향 창가에 두고, 빛이 부족하면 웃자라요';

  @override
  String tipTempOptimal(String min, String max) {
    return '적정 $min~$max';
  }

  @override
  String tipTempHardy(String opt) {
    return '$opt. 추위에 강해 바깥 월동도 되지만 실내에서는 찬바람이 직접 닿지 않게 해 주세요';
  }

  @override
  String tipTempCool(String opt, String low) {
    return '$opt. $low까지는 견디니 겨울 베란다도 괜찮아요';
  }

  @override
  String tipTempTender(String opt, String low) {
    return '$opt. $low 아래로 내려가면 잎이 상하니 겨울에는 창가에서 떨어뜨려 주세요';
  }

  @override
  String get intervalTitle => '물주기 조정';

  @override
  String get intervalBasis => '자동 계산 근거';

  @override
  String intervalFormula(
    String base,
    String season,
    String light,
    String pot,
    String feedback,
  ) {
    return '품종 기본 $base × 계절 $season × 빛 $light × 화분 $pot × 피드백 $feedback';
  }

  @override
  String get intervalManual => '직접 정하기';

  @override
  String get intervalManualOn => '내가 정한 주기를 그대로 써요';

  @override
  String get intervalManualOff => '계절과 환경에 맞춰 자동으로 계산해요';

  @override
  String get spaceDeleteQ => '공간을 삭제할까요?';

  @override
  String get spaceDeleteBody => '이 공간의 식물은 공간 미지정으로 바뀌어요';

  @override
  String get spaceEditTitle => '공간 편집';

  @override
  String get spaceAddTitle => '공간 추가';

  @override
  String get spaceName => '공간 이름';

  @override
  String get spaceNameHint => '예: 거실, 베란다, 사무실 책상';

  @override
  String get spaceWindowDir => '창 방향';

  @override
  String get spaceWindowDist => '창과의 거리';

  @override
  String get spaceLightInfo => '카메라 광량 측정 대신 창 방향과 거리로 빛을 추정해요';

  @override
  String get spaceAdd => '추가';

  @override
  String get infoTitle => '도감';

  @override
  String get infoNotInCatalog => '도감에 없는 품종이에요';

  @override
  String get infoCategorySucculent => '다육·선인장';

  @override
  String get infoCategoryHerb => '허브';

  @override
  String get infoCategoryFlower => '꽃';

  @override
  String get infoCategoryOther => '기타';

  @override
  String get infoCategoryFoliage => '관엽';

  @override
  String infoPhotoCredit(String author, String license) {
    return '사진: $author · $license · Wikimedia Commons';
  }

  @override
  String get infoUnknownAuthor => '작가 미상';

  @override
  String infoOtherNames(String names) {
    return '다른 이름: $names';
  }

  @override
  String get infoWater => '물';

  @override
  String infoWaterBase(int days) {
    return '기본 $days일마다';
  }

  @override
  String get infoWaterSucculent => '흙이 속까지 완전히 마른 뒤 흠뻑. 과습이 가장 흔한 실패 원인이에요';

  @override
  String get infoWaterHerb => '겉흙이 마르면 바로. 마르면 잎이 금방 처져요';

  @override
  String get infoWaterFlower => '겉흙이 마르면. 꽃이 피는 동안은 조금 더 자주 살펴 주세요';

  @override
  String get infoWaterFoliage =>
      '손가락 두 마디 깊이까지 말랐을 때 화분 밑으로 흘러나올 만큼. 받침에 고인 물은 버려 주세요';

  @override
  String get infoWaterAuto => '앱은 계절과 놓는 곳에 따라 이 주기를 자동으로 조정해요';

  @override
  String get infoLight => '빛';

  @override
  String get infoLightLow => '빛이 적은 곳에서도 잘 자라요 (반음지)';

  @override
  String get infoLightMed => '밝은 간접광 (커튼 친 창가, 창에서 1m 안쪽)';

  @override
  String get infoLightHigh => '햇빛 많이 (남향·동향 창가)';

  @override
  String get infoLightLowNote => '직사광선은 잎을 태울 수 있어요';

  @override
  String get infoLightMedNote => '한여름 직사광선은 피해 주세요';

  @override
  String get infoLightHighNote => '빛이 부족하면 웃자라고 색이 옅어져요';

  @override
  String get infoTempHumidity => '온도·습도';

  @override
  String get infoHumidityTip => '건조한 겨울 실내에서는 잎에 분무하거나 가습기를 곁에 두면 좋아요';

  @override
  String get infoCommonIssues => '흔한 문제';

  @override
  String get infoAddToMine => '내 식물로 등록';

  @override
  String get symTitle => '증상으로 원인 찾기';

  @override
  String get symDisclaimer =>
      '사진 진단이 아니라 흔한 원인을 안내해요. 여러 원인이 겹칠 수 있으니 확인 방법을 보고 골라 주세요';

  @override
  String symSpeciesIssues(String name) {
    return '$name에 흔한 문제';
  }

  @override
  String get symWhichSymptom => '어떤 증상인가요?';

  @override
  String symCheck(String text) {
    return '확인: $text';
  }

  @override
  String get symAdjustInterval => '물주기 간격 조정';

  @override
  String get symOverwaterTitle => '물을 너무 자주 줌 (과습)';

  @override
  String get symOverwaterCheck => '흙이 며칠째 축축하고, 아랫잎부터 노래지며 잎이 물렁해요';

  @override
  String get symOverwaterFix =>
      '흙이 속까지 마를 때까지 물을 멈추고, 물주기 간격을 늘려 주세요. 받침에 고인 물은 버려 주세요';

  @override
  String get symUnderwaterTitle => '물 부족';

  @override
  String get symUnderwaterCheck => '흙이 바싹 말라 화분이 가볍고, 잎이 얇고 힘없이 처져요';

  @override
  String get symUnderwaterFix =>
      '화분 밑으로 물이 흘러나올 만큼 흠뻑 주세요. 자주 이러면 물주기 간격을 줄여 주세요';

  @override
  String get symLowLightTitle => '빛 부족';

  @override
  String get symLowLightCheck => '잎 색이 전체적으로 연해지고, 줄기가 가늘고 길게 늘어져요';

  @override
  String get symLowLightFix => '창가처럼 더 밝은 곳으로 옮겨 주세요. 한여름 직사광선만 피하면 돼요';

  @override
  String get symColdTitle => '추위·찬바람';

  @override
  String get symColdCheck => '겨울 창가나 에어컨·현관 바람이 닿는 자리에 있어요';

  @override
  String get symColdFix => '찬바람이 닿지 않는 따뜻한 곳으로 옮겨 주세요. 상한 잎은 회복되지 않으니 떼어 주세요';

  @override
  String get symYellow => '잎이 노랗게 변해요';

  @override
  String get symOldLeafTitle => '오래된 잎이 자연스럽게 지는 중';

  @override
  String get symOldLeafCheck => '맨 아래 잎 1~2장만 노래지고, 새잎은 건강해요';

  @override
  String get symOldLeafFix => '정상이에요. 노란 잎만 떼어 주세요';

  @override
  String get symBrownTips => '잎 끝이 갈색으로 말라요';

  @override
  String get symDryAirTitle => '공기가 건조함';

  @override
  String get symDryAirCheck => '난방·에어컨을 켜는 계절이거나 바람이 직접 닿는 자리예요';

  @override
  String get symDryAirFix => '가습기를 곁에 두거나 잎 주변에 분무해 주세요. 마른 끝은 가위로 다듬어도 돼요';

  @override
  String get symSaltTitle => '수돗물 성분·비료가 쌓임';

  @override
  String get symSaltCheck => '물을 제때 주는데도 끝이 계속 타들어가요';

  @override
  String get symSaltFix => '하루 받아둔 물을 주고, 비료를 줬다면 한동안 쉬어 주세요';

  @override
  String get symDroop => '잎이 축 처져요';

  @override
  String get symRootDamageTitle => '과습으로 뿌리가 상함';

  @override
  String get symRootDamageCheck => '흙이 젖어 있는데도 처지고, 밑동이 무르거나 흙에서 냄새가 나요';

  @override
  String get symRootDamageFix =>
      '물을 멈추고 흙을 말려 주세요. 밑동이 물렀다면 아래 \"줄기·밑동이 물러요\"를 확인해 주세요';

  @override
  String get symLeafDrop => '잎이 갑자기 떨어져요';

  @override
  String get symAdjustingTitle => '자리가 바뀌어 적응 중';

  @override
  String get symAdjustingCheck => '최근에 들여왔거나 자리를 옮겼어요 (고무나무·벤자민에 흔해요)';

  @override
  String get symAdjustingFix => '2~3주는 자리를 옮기지 말고 지켜봐 주세요. 새잎이 나면 적응한 거예요';

  @override
  String get symRot => '줄기·밑동이 물러요';

  @override
  String get symRootRotTitle => '뿌리 썩음 (오랜 과습)';

  @override
  String get symRootRotCheck => '밑동이 검고 물렁하며, 흙에서 퀴퀴한 냄새가 나요';

  @override
  String get symRootRotFix =>
      '화분에서 꺼내 검고 무른 뿌리를 잘라내고 마른 새 흙에 심어 주세요. 한동안 물을 아껴 주세요. 심하면 건강한 줄기를 잘라 물꽂이로 살릴 수 있어요';

  @override
  String get symSpots => '잎에 갈색·검은 반점이 생겨요';

  @override
  String get symSunburnTitle => '햇빛에 잎이 탐';

  @override
  String get symSunburnCheck => '햇빛이 닿는 쪽 잎에 마르고 바삭한 갈색 자국이 있어요';

  @override
  String get symSunburnFix => '커튼 너머로 옮겨 주세요. 탄 자국은 사라지지 않지만 새잎은 괜찮아요';

  @override
  String get symLeafSpotTitle => '곰팡이·세균성 반점';

  @override
  String get symLeafSpotCheck => '노란 테두리가 있는 젖은 듯한 반점이 점점 번져요';

  @override
  String get symLeafSpotFix => '반점 난 잎을 떼어 내고, 잎에 물이 오래 묻어 있지 않게 통풍을 시켜 주세요';

  @override
  String get symMealybug => '흰 솜 같은 벌레, 끈적임';

  @override
  String get symMealybugTitle => '깍지벌레·솜깍지벌레';

  @override
  String get symMealybugCheck => '잎 겨드랑이나 뒷면에 하얀 솜뭉치나 갈색 껍질이 붙어 있고, 잎이 끈적여요';

  @override
  String get symMealybugFix =>
      '물티슈나 면봉으로 닦아내고 다른 식물과 떨어뜨려 주세요. 계속 생기면 원예용 살충제를 써 주세요';

  @override
  String get symSpiderMite => '잎 뒷면에 거미줄·작은 점';

  @override
  String get symSpiderMiteTitle => '응애';

  @override
  String get symSpiderMiteCheck =>
      '잎에 자잘한 흰 점이 생기고, 뒷면에 가는 거미줄이 보여요. 건조할 때 잘 생겨요';

  @override
  String get symSpiderMiteFix =>
      '샤워기로 잎 앞뒤를 씻어내고 습도를 올려 주세요. 반복되면 응애용 살충제를 써 주세요';

  @override
  String get symGnat => '작은 날파리가 날아다녀요';

  @override
  String get symGnatTitle => '뿌리파리 (흙이 오래 젖어 있음)';

  @override
  String get symGnatCheck => '화분 흙 위나 주변에 작은 검은 날파리가 맴돌아요';

  @override
  String get symGnatFix =>
      '겉흙이 마를 때까지 물을 참고 노란 끈끈이를 꽂아 주세요. 물주기 간격을 조금 늘리면 줄어들어요';

  @override
  String get symLeggy => '줄기만 길쭉하게 자라요';

  @override
  String get symLeggyTitle => '빛 부족 (웃자람)';

  @override
  String get symLeggyCheck => '잎 사이 간격이 넓어지고 줄기가 창 쪽으로 휘어요';

  @override
  String get symLeggyFix =>
      '더 밝은 곳으로 옮기고, 웃자란 줄기는 잘라 정리해 주세요. 가끔 화분을 돌려 주면 고르게 자라요';

  @override
  String get symMold => '흙 위에 하얀 곰팡이가 폈어요';

  @override
  String get symMoldTitle => '통풍 부족·과습';

  @override
  String get symMoldCheck => '흙 표면에 흰 실이나 솜 같은 곰팡이가 보여요';

  @override
  String get symMoldFix => '곰팡이 핀 겉흙을 걷어내고 통풍이 되는 곳에 두세요. 식물에는 대부분 해가 없어요';

  @override
  String get symNoGrowth => '새잎이 안 나요';

  @override
  String get symDormantTitle => '겨울 휴면';

  @override
  String get symDormantCheck => '11월~2월이에요';

  @override
  String get symDormantFix => '정상이에요. 봄이 되면 다시 자라요. 겨울에는 물을 조금 아껴 주세요';

  @override
  String get symPotboundTitle => '화분이 작아짐';

  @override
  String get symPotboundCheck => '뿌리가 배수구 밖으로 나오거나 물이 금방 빠져요';

  @override
  String get symPotboundFix => '봄에 한 치수 큰 화분으로 옮겨 심어 주세요';

  @override
  String get myTitle => 'MY';

  @override
  String get myStatWaterings => '이번 달\n물 준 횟수';

  @override
  String get myStatDiary => '일기';

  @override
  String get myStatStreak => '연속 관리일';

  @override
  String get mySectionNotifications => '알림';

  @override
  String get myNotifyTime => '알림 시간';

  @override
  String get myNotifyTiming => '알림 시점';

  @override
  String get myNotifyDayBefore => '하루 전';

  @override
  String get myNotifySameDay => '당일';

  @override
  String get myPause => '알림 잠시 멈추기';

  @override
  String get myPauseOff => '꺼짐';

  @override
  String myPauseUntil(String date) {
    return '$date까지';
  }

  @override
  String get myNotifyDays => '알림 요일';

  @override
  String get myEveryDay => '매일';

  @override
  String mySkipDays(String days) {
    return '제외: $days';
  }

  @override
  String get mySectionData => '데이터';

  @override
  String get myBackup => '기록 내보내기·가져오기';

  @override
  String get myBackupValue => '파일';

  @override
  String get myRequestSpecies => '품종 추가 요청';

  @override
  String get myDebugNotify => '(개발용) 10초 뒤 알림';

  @override
  String get myDebugTest => '테스트';

  @override
  String get mySectionInfo => '정보';

  @override
  String get myTermsPrivacy => '약관·개인정보 처리방침';

  @override
  String get myPhotoCredits => '도감 사진 출처';

  @override
  String get myContact => '문의';

  @override
  String get myVersion => '버전';

  @override
  String get myLocalOnly =>
      '기록은 이 기기에만 저장돼요. 폰 백업(구글·iCloud)에 기록이 포함되고, 사진까지 옮기려면 내보내기를 쓰세요';

  @override
  String get myNotifyTimeHelp => '물 주는 날 알림 시간';

  @override
  String get mySkipDaysTitle => '알림을 받지 않을 요일';

  @override
  String get mySkipAllWarning => '모든 요일을 제외하면 알림이 오지 않아요';

  @override
  String get pauseHelp => '이 날까지 알림을 멈춰요';

  @override
  String get pauseTitle => '알림 잠시 멈추기';

  @override
  String get pauseSubtitle => '여행이나 휴가로 집을 비울 때 알림을 멈춰요';

  @override
  String pauseDays(int count) {
    return '$count일';
  }

  @override
  String get pauseOneWeek => '1주';

  @override
  String get pauseTwoWeeks => '2주';

  @override
  String pauseUntilDate(String date) {
    return '$date까지';
  }

  @override
  String pauseNoneDue(String date) {
    return '$date까지 물 줄 날이 오는 식물은 없어요';
  }

  @override
  String pauseWaterBefore(String names) {
    return '떠나기 전에 물 주면 좋은 식물: $names';
  }

  @override
  String get pausePickPeriod => '기간을 골라 주세요';

  @override
  String pauseConfirm(String date) {
    return '$date까지 멈추기';
  }

  @override
  String get pauseResume => '알림 다시 켜기';

  @override
  String get creditsTitle => '도감 사진 출처';

  @override
  String get creditsIntro =>
      '도감 사진은 위키미디어 공용(Wikimedia Commons)의 자유 라이선스 사진이에요. 각 사진의 작가와 라이선스, 원본 주소는 아래와 같아요';

  @override
  String get backupShareSubject => '잘자라라 기록 백업';

  @override
  String get backupShareText =>
      '잘자라라 기록 백업 파일이에요. 새 폰에서 MY › 기록 가져오기로 복원할 수 있어요';

  @override
  String get backupExported => '파일을 만들었어요. 보관할 곳으로 보내 주세요';

  @override
  String backupExportFailed(String error) {
    return '내보내기에 실패했어요: $error';
  }

  @override
  String get backupNotOurs => '잘자라라 백업 파일이 아니에요';

  @override
  String get backupImportQ => '기록을 가져올까요?';

  @override
  String backupImportSummary(String date, int plants, int diaries, int photos) {
    return '$date에 내보낸 파일이에요.\n식물 $plants개 · 일기 $diaries개 · 사진 $photos장\n\n지금 이 폰에 있는 기록은 모두 이 파일의 내용으로 바뀌어요.';
  }

  @override
  String get backupImport => '가져오기';

  @override
  String get backupImported => '가져왔어요. 홈에서 확인해 보세요';

  @override
  String backupImportFailed(String error) {
    return '가져오기에 실패했어요: $error';
  }

  @override
  String get backupTitle => '기록 내보내기·가져오기';

  @override
  String get backupExport => '내보내기';

  @override
  String get backupExportBody =>
      '식물·물 준 기록·일기·사진을 파일 하나로 만들어요. 카카오톡 나에게 보내기, 구글 드라이브 등 원하는 곳에 보관하세요';

  @override
  String get backupExportButton => '파일 만들어 보내기';

  @override
  String get backupImportBody =>
      '새 폰에서 내보낸 파일을 고르면 그대로 복원돼요. 지금 폰에 있는 기록은 파일 내용으로 바뀌니 주의하세요';

  @override
  String get backupImportButton => '파일 골라서 가져오기';

  @override
  String get backupNote =>
      '참고: 폰 자체 백업(구글 계정 백업, iCloud 백업)을 켜 두면 새 폰으로 옮길 때 기록이 자동으로 따라와요. 안드로이드 자동 백업에는 사진이 빠지니, 사진까지 옮기려면 이 화면의 내보내기를 쓰세요';
}
