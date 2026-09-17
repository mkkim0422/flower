// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Jaljarara';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonRemove => 'Remove';

  @override
  String get commonClose => 'Close';

  @override
  String get commonNext => 'Next';

  @override
  String get commonLater => 'Later';

  @override
  String get commonToday => 'Today';

  @override
  String get commonYesterday => 'Yesterday';

  @override
  String get commonPickDate => 'Pick a date';

  @override
  String get commonComingSoon => 'Coming soon';

  @override
  String get commonLoadFailed => 'Couldn\'t load. Please try again.';

  @override
  String get commonPhotoLoadFailed => 'Couldn\'t get the photo';

  @override
  String get commonTakePhoto => 'Take a photo';

  @override
  String get commonPickFromAlbum => 'Choose from album';

  @override
  String get commonAlbum => 'Album';

  @override
  String get commonSearchByName => 'Search by name';

  @override
  String get commonManualEntry => 'Enter manually';

  @override
  String commonDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String commonEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count days',
      one: 'Every day',
    );
    return '$_temp0';
  }

  @override
  String get listSeparator => ', ';

  @override
  String get nameSeparator => ', ';

  @override
  String get speciesUnknown => 'Unknown species';

  @override
  String get tabHome => 'Home';

  @override
  String get tabCamera => 'Camera';

  @override
  String get tabMy => 'My';

  @override
  String get semanticsSelect => 'Select';

  @override
  String get statusToday => 'Water today';

  @override
  String statusDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'In $count days',
      one: 'Tomorrow',
    );
    return '$_temp0';
  }

  @override
  String statusOverdue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days late',
      one: '1 day late',
    );
    return '$_temp0';
  }

  @override
  String get dangerPetAndChild => 'Dangerous for pets and children';

  @override
  String get dangerChild => 'Dangerous for children';

  @override
  String get dangerPet => 'Dangerous for pets';

  @override
  String get toxicMildNote =>
      'Note: pets or children chewing the leaves may get an upset stomach';

  @override
  String get windowDirE => 'East';

  @override
  String get windowDirW => 'West';

  @override
  String get windowDirS => 'South';

  @override
  String get windowDirN => 'North';

  @override
  String get windowDirNone => 'No window';

  @override
  String get windowDistNear => 'By the window';

  @override
  String get windowDistOneMeter => 'Within 1 m';

  @override
  String get windowDistFar => 'Far';

  @override
  String get potSizeS => 'Small';

  @override
  String get potSizeM => 'Medium';

  @override
  String get potSizeL => 'Large';

  @override
  String get diaryTagNewLeaf => 'New leaf';

  @override
  String get diaryTagFlower => 'Flower';

  @override
  String get diaryTagDroop => 'Drooping';

  @override
  String get diaryTagYellow => 'Yellow leaves';

  @override
  String get diaryTagPest => 'Pests?';

  @override
  String get notifChannelName => 'Watering reminders';

  @override
  String get notifChannelDesc => 'Tells you which plants need water, by name';

  @override
  String get notifActionWatered => 'Watered';

  @override
  String get notifActionSnooze => 'Tomorrow';

  @override
  String get notifActionWateredEarly => 'Watered today';

  @override
  String notifWhoMore(String names, int count) {
    return '$names and $count more';
  }

  @override
  String notifBodyToday(String who, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$who need water today',
      one: '$who needs water today',
    );
    return '$_temp0';
  }

  @override
  String notifBodyTomorrow(String who, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$who need water tomorrow',
      one: '$who needs water tomorrow',
    );
    return '$_temp0';
  }

  @override
  String get onbSlide1Title => 'Help your plants thrive';

  @override
  String get onbSlide1Body =>
      'Search by name or snap a photo to add a plant,\nand get a watering schedule that fits it';

  @override
  String get onbSlide2Title => 'Never miss a watering day';

  @override
  String get onbSlide2Body =>
      'We remind you when each plant needs water.\nTap \"Watered\" once and the next date is set';

  @override
  String get onbSlide3Title => 'No sign-up, no ads';

  @override
  String get onbSlide3Body =>
      'Your records stay on this device.\nPhotos are never uploaded to a server';

  @override
  String get onbStart => 'Get started';

  @override
  String get onbPermTitle => 'We\'ll remind you on watering days';

  @override
  String get onbPermBody =>
      'We notify you at 9 AM on watering days.\nYou can change the time in My';

  @override
  String get onbPermAllow => 'Allow notifications';

  @override
  String get homeTitle => 'Today';

  @override
  String get homeLoadFailed => 'Couldn\'t load. Please reopen the app.';

  @override
  String get homeEmptyTitle => 'Add your first plant';

  @override
  String get homeEmptyBody =>
      'Snap a photo and we\'ll tell you the species and when to water';

  @override
  String get homeAddPlant => 'Add plant';

  @override
  String get homeAddPlantPlus => '+ Add plant';

  @override
  String homeDueHeader(int count) {
    return 'To water $count';
  }

  @override
  String get homeSelectAll => 'Select all';

  @override
  String get homeDeselect => 'Deselect';

  @override
  String get homeNothingDue => 'No plants need water today';

  @override
  String homeMyPlants(int count) {
    return 'My plants $count';
  }

  @override
  String homeWateredCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Watered $count plants',
      one: 'Watered 1 plant',
    );
    return '$_temp0';
  }

  @override
  String get homeViewGrid => 'Album';

  @override
  String get homeViewList => 'List';

  @override
  String homePausedBanner(String date) {
    return 'Reminders paused until $date';
  }

  @override
  String get homeResume => 'Turn back on';

  @override
  String waterSheetPlants(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count plants',
      one: '1 plant',
    );
    return '$_temp0';
  }

  @override
  String get waterSheetWatered => 'Watered';

  @override
  String waterSheetLater(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return 'Later · we\'ll remind you in $_temp0';
  }

  @override
  String get addTitle => 'Add plant';

  @override
  String get addHowTo => 'How would you like to add it?';

  @override
  String get addByPhoto => 'Identify by photo';

  @override
  String get addByPhotoSub =>
      'Take a photo showing the whole leaf and we\'ll find the species';

  @override
  String get addByNameSub => 'Find it by common or scientific name';

  @override
  String get addManualSub =>
      'Add it with just a name, even if you don\'t know the species';

  @override
  String get manualPlantName => 'Plant name';

  @override
  String get manualHint => 'e.g. Window greenie';

  @override
  String get manualInfo =>
      'Without a species, watering starts at every 7 days. You can change it anytime on the plant page.';

  @override
  String get registerTitle => 'Add to my plants';

  @override
  String get registerNotInCatalog =>
      'This species isn\'t in our catalog yet. Please name it yourself.';

  @override
  String get registerName => 'Name';

  @override
  String get registerNameHint => 'e.g. Living room monstera';

  @override
  String get registerLastWatered => 'Last watered';

  @override
  String registerInterval(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: 'day',
    );
    return 'We\'ll remind you about every $_temp0';
  }

  @override
  String get registerIntervalManual => ' (set by you)';

  @override
  String get registerEditInterval => 'Edit interval';

  @override
  String registerBackToAuto(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return 'Back to auto ($_temp0)';
  }

  @override
  String get registerMemo => 'Memo (optional)';

  @override
  String get memoHint =>
      'e.g. Left side of the balcony. Droopy leaves mean thirsty.';

  @override
  String get registerSubmit => 'Add plant';

  @override
  String get searchTitle => 'Search by name';

  @override
  String get searchHint => 'e.g. Monstera, Pothos';

  @override
  String get searchCatalogFailed => 'Couldn\'t load the catalog';

  @override
  String get searchNotListed => 'Not listed → Enter manually';

  @override
  String get searchPrompt => 'Type a common or scientific name';

  @override
  String get searchError => 'Something went wrong while searching';

  @override
  String searchNoResult(String query) {
    return 'No species match \"$query\".\nYou can add it manually below.';
  }

  @override
  String searchAlsoKnownAs(String alias) {
    return 'Also known as $alias';
  }

  @override
  String get searchViewCatalog => 'View catalog';

  @override
  String get cameraTitle => 'Identify';

  @override
  String get cameraGuide => 'Capture the whole leaf';

  @override
  String get cameraTip1 =>
      'In good light, with the leaf filling at least half the frame';

  @override
  String get cameraTip2 =>
      'If it has flowers, include them for better accuracy';

  @override
  String get cameraPickFailed =>
      'Couldn\'t get the photo. Check permissions or try another photo.';

  @override
  String get cameraPreparing => 'Preparing…';

  @override
  String get identifyTitle => 'Identification';

  @override
  String get identifyAddPhoto => 'Add photo';

  @override
  String get identifyAddPhotoTip =>
      'A close-up of a leaf, or a flower if it has one, improves accuracy';

  @override
  String get identifyAddPhotoHint =>
      'Add a close-up of a leaf or flower for better accuracy';

  @override
  String get identifyPhotoGoesCover =>
      'The photo you took will be used as the cover photo';

  @override
  String get identifySearching => 'Finding out what this plant is';

  @override
  String identifySearchingMulti(int count) {
    return 'Searching again with $count photos';
  }

  @override
  String get identifyThisIsIt => 'That\'s my plant';

  @override
  String get identifyOtherCandidates => 'Other matches';

  @override
  String get identifyNotListed => 'It\'s not here';

  @override
  String get identifyIsItHere => 'Is it one of these?';

  @override
  String get identifyNotInCatalog =>
      'Not in our catalog · you can name it when adding';

  @override
  String get identifyLimitTitle => 'You\'ve used today\'s identifications';

  @override
  String get identifyLimitBody =>
      'Try again tomorrow, or add it by searching its name';

  @override
  String get identifyOfflineTitle => 'You\'re offline';

  @override
  String get identifyOfflineBody =>
      'Check your connection and try again, or add it by searching its name';

  @override
  String get identifyNoResultTitle => 'Couldn\'t find this plant';

  @override
  String get identifyNoResultBody =>
      'Add a close-up of a leaf or flower, or add it by searching its name';

  @override
  String get identifyUnavailableTitle =>
      'Identification isn\'t available right now';

  @override
  String get identifyUnavailableBody =>
      'The identification service isn\'t set up yet. Try searching by name.';

  @override
  String get identifyRetryWithPhoto => 'Add a photo and try again';

  @override
  String get identifyManualRegister => 'Add manually';

  @override
  String get diaryWriteTitle => 'Write a diary';

  @override
  String diaryWriteTitleFor(String name) {
    return '$name\'s diary';
  }

  @override
  String get diaryRemovePhoto => 'Remove photo';

  @override
  String get diarySetCover => 'Use as cover photo';

  @override
  String get diaryLabel => 'Diary';

  @override
  String get diaryHint => 'How is your plant today? New leaves, drooping…';

  @override
  String get detailDeleted => 'This plant was deleted';

  @override
  String get detailRename => 'Rename';

  @override
  String get detailMyMemo => 'My memo';

  @override
  String get detailPlace => 'Location';

  @override
  String get detailPlaceNone => 'Not set';

  @override
  String get detailAddPlace => '+ Add a location';

  @override
  String get detailChangePlace => 'Change location';

  @override
  String get detailDeleteDiaryQ => 'Delete this diary entry?';

  @override
  String detailDeletePlantQ(String name) {
    return 'Delete $name?';
  }

  @override
  String get detailDeletePlantBody =>
      'Its watering history and memo will be deleted too';

  @override
  String get detailCatalogPhoto => 'Catalog photo';

  @override
  String detailOverdue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Watering is $count days late',
      one: 'Watering is 1 day late',
    );
    return '$_temp0';
  }

  @override
  String get detailDueToday => 'It\'s watering day';

  @override
  String get detailUntilNext => 'Next watering';

  @override
  String get detailDDay => 'Today';

  @override
  String get detailIntervalManual => ' (set by you)';

  @override
  String get detailIntervalAuto => ' (auto)';

  @override
  String detailLastWatered(String date) {
    return ' · last $date';
  }

  @override
  String get detailAdjust => 'Adjust';

  @override
  String get detailAddMemo => '+ Add a memo';

  @override
  String get detailDiaryWrite => '+ Write';

  @override
  String get detailDiaryEmpty => 'Record how it grows with a photo and a line';

  @override
  String detailDiaryMore(int count) {
    return '$count more';
  }

  @override
  String get detailGoodToKnow => 'Good to know';

  @override
  String get detailNoSpeciesInfo =>
      'Set a species to see care info. Identify it with the camera or search by name.';

  @override
  String get detailSymptomEntry =>
      'Plant looking unwell? Find the cause by symptom';

  @override
  String get detailAlreadyWatered => 'Already watered today';

  @override
  String get detailWateredToday => 'Watered today';

  @override
  String get detailWatered => 'Watered';

  @override
  String tipWaterSucculent(int days) {
    return 'Water about every $days days, soaking thoroughly only after the soil is completely dry. Overwatering is the most common mistake.';
  }

  @override
  String tipWaterHerb(int days) {
    return 'Water about every $days days, as soon as the topsoil dries. Herbs droop quickly when dry.';
  }

  @override
  String tipWaterFlower(int days) {
    return 'Water about every $days days when the topsoil dries. Check a little more often while it blooms.';
  }

  @override
  String tipWaterFoliage(int days) {
    return 'Water about every $days days until it drains from the bottom. Empty the saucer afterwards.';
  }

  @override
  String get tipLightLow =>
      'Does fine in low light. Direct sun can scorch the leaves, so keep it a little away from the window.';

  @override
  String get tipLightMed =>
      'Likes bright, indirect light, such as a curtained window or within 1 m of a window.';

  @override
  String get tipLightHigh =>
      'Needs plenty of sun. Keep it by a sunny window; without enough light it gets leggy.';

  @override
  String tipTempOptimal(String min, String max) {
    return 'Best at $min–$max';
  }

  @override
  String tipTempHardy(String opt) {
    return '$opt. Cold-hardy, but keep it out of cold drafts indoors';
  }

  @override
  String tipTempCool(String opt, String low) {
    return '$opt. Tolerates down to $low, so a cool spot in winter is fine';
  }

  @override
  String tipTempTender(String opt, String low) {
    return '$opt. Below $low the leaves get damaged, so move it away from cold windows in winter';
  }

  @override
  String get intervalTitle => 'Adjust watering';

  @override
  String get intervalBasis => 'How it’s calculated';

  @override
  String intervalFormula(
    String base,
    String season,
    String light,
    String pot,
    String feedback,
  ) {
    return 'Species $base × season $season × light $light × pot $pot × feedback $feedback';
  }

  @override
  String get intervalManual => 'Set it myself';

  @override
  String get intervalManualOn => 'Uses the interval you set';

  @override
  String get intervalManualOff =>
      'Calculated automatically for season and conditions';

  @override
  String get spaceDeleteQ => 'Delete this location?';

  @override
  String get spaceDeleteBody => 'Plants here will become \"location not set\"';

  @override
  String get spaceEditTitle => 'Edit location';

  @override
  String get spaceAddTitle => 'Add location';

  @override
  String get spaceName => 'Location name';

  @override
  String get spaceNameHint => 'e.g. Living room, Balcony, Office desk';

  @override
  String get spaceWindowDir => 'Window direction';

  @override
  String get spaceWindowDist => 'Distance from window';

  @override
  String get spaceLightInfo =>
      'We estimate light from window direction and distance';

  @override
  String get spaceAdd => 'Add';

  @override
  String get infoTitle => 'Catalog';

  @override
  String get infoNotInCatalog => 'This species isn\'t in the catalog';

  @override
  String get infoCategorySucculent => 'Succulents & cacti';

  @override
  String get infoCategoryHerb => 'Herbs';

  @override
  String get infoCategoryFlower => 'Flowering plants';

  @override
  String get infoCategoryOther => 'Other';

  @override
  String get infoCategoryFoliage => 'Foliage plants';

  @override
  String infoPhotoCredit(String author, String license) {
    return 'Photo: $author · $license · Wikimedia Commons';
  }

  @override
  String get infoUnknownAuthor => 'Unknown author';

  @override
  String infoOtherNames(String names) {
    return 'Also called: $names';
  }

  @override
  String get infoWater => 'Water';

  @override
  String infoWaterBase(int days) {
    return 'Base: every $days days';
  }

  @override
  String get infoWaterSucculent =>
      'Soak only after the soil is completely dry. Overwatering is the most common mistake.';

  @override
  String get infoWaterHerb =>
      'As soon as the topsoil dries. Herbs droop quickly when dry.';

  @override
  String get infoWaterFlower =>
      'When the topsoil dries. Check a little more often while it blooms.';

  @override
  String get infoWaterFoliage =>
      'When the soil is dry two knuckles deep, water until it drains. Empty the saucer.';

  @override
  String get infoWaterAuto =>
      'The app adjusts this interval for the season automatically';

  @override
  String get infoLight => 'Light';

  @override
  String get infoLightLow => 'Tolerates low light (partial shade)';

  @override
  String get infoLightMed =>
      'Bright, indirect light (curtained window, within 1 m of a window)';

  @override
  String get infoLightHigh => 'Plenty of sun (sunny window)';

  @override
  String get infoLightLowNote => 'Direct sun can scorch the leaves';

  @override
  String get infoLightMedNote => 'Avoid harsh midsummer sun';

  @override
  String get infoLightHighNote => 'Without enough light it gets leggy and pale';

  @override
  String get infoTempHumidity => 'Temperature & humidity';

  @override
  String get infoHumidityTip =>
      'In dry winter air, mist the leaves or keep a humidifier nearby';

  @override
  String get infoCommonIssues => 'Common problems';

  @override
  String get infoAddToMine => 'Add to my plants';

  @override
  String get symTitle => 'Find the cause by symptom';

  @override
  String get symDisclaimer =>
      'This isn\'t a photo diagnosis — it lists common causes. Several can overlap, so use the checks to decide.';

  @override
  String symSpeciesIssues(String name) {
    return 'Common problems for $name';
  }

  @override
  String get symWhichSymptom => 'What do you see?';

  @override
  String symCheck(String text) {
    return 'Check: $text';
  }

  @override
  String get symAdjustInterval => 'Adjust watering interval';

  @override
  String get symOverwaterTitle => 'Watering too often (overwatering)';

  @override
  String get symOverwaterCheck =>
      'The soil stays wet for days, lower leaves yellow first and feel soft';

  @override
  String get symOverwaterFix =>
      'Stop watering until the soil dries through, and lengthen the interval. Empty any water in the saucer.';

  @override
  String get symUnderwaterTitle => 'Not enough water';

  @override
  String get symUnderwaterCheck =>
      'The soil is bone dry, the pot feels light, and leaves droop thin and limp';

  @override
  String get symUnderwaterFix =>
      'Water until it drains from the bottom. If this keeps happening, shorten the interval.';

  @override
  String get symLowLightTitle => 'Not enough light';

  @override
  String get symLowLightCheck =>
      'Leaves turn pale overall and stems grow thin and long';

  @override
  String get symLowLightFix =>
      'Move it somewhere brighter, like a window. Just avoid harsh midsummer sun.';

  @override
  String get symColdTitle => 'Cold or drafts';

  @override
  String get symColdCheck =>
      'It sits by a cold winter window or in the path of AC or door drafts';

  @override
  String get symColdFix =>
      'Move it somewhere warm away from drafts. Damaged leaves won\'t recover, so remove them.';

  @override
  String get symYellow => 'Leaves turning yellow';

  @override
  String get symOldLeafTitle => 'Old leaves dropping naturally';

  @override
  String get symOldLeafCheck =>
      'Only the bottom one or two leaves yellow, and new growth looks healthy';

  @override
  String get symOldLeafFix => 'That\'s normal. Just remove the yellow leaves.';

  @override
  String get symBrownTips => 'Leaf tips turning brown and crispy';

  @override
  String get symDryAirTitle => 'Dry air';

  @override
  String get symDryAirCheck =>
      'It\'s heating or AC season, or air blows directly on it';

  @override
  String get symDryAirFix =>
      'Keep a humidifier nearby or mist around the leaves. You can trim the dry tips.';

  @override
  String get symSaltTitle => 'Tap water minerals or fertilizer buildup';

  @override
  String get symSaltCheck => 'Tips keep browning even though you water on time';

  @override
  String get symSaltFix =>
      'Use water that\'s been left out for a day, and pause any fertilizer for a while.';

  @override
  String get symDroop => 'Leaves drooping';

  @override
  String get symRootDamageTitle => 'Roots damaged by overwatering';

  @override
  String get symRootDamageCheck =>
      'It droops even though the soil is wet, the base is soft, or the soil smells';

  @override
  String get symRootDamageFix =>
      'Stop watering and let the soil dry. If the base is soft, see \"Stem or base is mushy\" below.';

  @override
  String get symLeafDrop => 'Leaves suddenly falling off';

  @override
  String get symAdjustingTitle => 'Adjusting to a new spot';

  @override
  String get symAdjustingCheck =>
      'You recently brought it home or moved it (common in rubber plants and weeping figs)';

  @override
  String get symAdjustingFix =>
      'Don\'t move it for 2–3 weeks and watch. New leaves mean it has settled in.';

  @override
  String get symRot => 'Stem or base is mushy';

  @override
  String get symRootRotTitle => 'Root rot (long-term overwatering)';

  @override
  String get symRootRotCheck =>
      'The base is dark and soft, and the soil smells musty';

  @override
  String get symRootRotFix =>
      'Unpot it, cut away black mushy roots and replant in fresh dry soil. Water sparingly for a while. If severe, root a healthy cutting in water.';

  @override
  String get symSpots => 'Brown or black spots on leaves';

  @override
  String get symSunburnTitle => 'Sunburn';

  @override
  String get symSunburnCheck =>
      'Leaves facing the sun have dry, crispy brown patches';

  @override
  String get symSunburnFix =>
      'Move it behind a curtain. The burn marks won\'t fade, but new leaves will be fine.';

  @override
  String get symLeafSpotTitle => 'Fungal or bacterial leaf spot';

  @override
  String get symLeafSpotCheck =>
      'Wet-looking spots with yellow halos that keep spreading';

  @override
  String get symLeafSpotFix =>
      'Remove spotted leaves and improve airflow so leaves don\'t stay wet.';

  @override
  String get symMealybug => 'White cottony bugs or sticky leaves';

  @override
  String get symMealybugTitle => 'Mealybugs or scale';

  @override
  String get symMealybugCheck =>
      'White cottony clumps or brown shells in leaf joints or undersides, and sticky leaves';

  @override
  String get symMealybugFix =>
      'Wipe them off with a wet wipe or cotton swab and isolate the plant. If they return, use a houseplant insecticide.';

  @override
  String get symSpiderMite => 'Webbing or tiny dots under leaves';

  @override
  String get symSpiderMiteTitle => 'Spider mites';

  @override
  String get symSpiderMiteCheck =>
      'Fine pale speckles on leaves and thin webbing underneath. Common in dry air.';

  @override
  String get symSpiderMiteFix =>
      'Rinse both sides of the leaves in the shower and raise humidity. If it recurs, use a miticide.';

  @override
  String get symGnat => 'Tiny flies around the pot';

  @override
  String get symGnatTitle => 'Fungus gnats (soil stays wet too long)';

  @override
  String get symGnatCheck => 'Small dark flies hover over or around the soil';

  @override
  String get symGnatFix =>
      'Let the topsoil dry out and add yellow sticky traps. Watering a little less often helps.';

  @override
  String get symLeggy => 'Only the stems grow long';

  @override
  String get symLeggyTitle => 'Not enough light (leggy growth)';

  @override
  String get symLeggyCheck =>
      'Gaps between leaves widen and stems lean toward the window';

  @override
  String get symLeggyFix =>
      'Move it somewhere brighter and trim leggy stems. Rotate the pot now and then for even growth.';

  @override
  String get symMold => 'White mold on the soil';

  @override
  String get symMoldTitle => 'Poor airflow or overwatering';

  @override
  String get symMoldCheck => 'White threads or fuzz on the soil surface';

  @override
  String get symMoldFix =>
      'Scrape off the moldy topsoil and keep it somewhere airy. It\'s usually harmless to the plant.';

  @override
  String get symNoGrowth => 'No new leaves';

  @override
  String get symDormantTitle => 'Winter dormancy';

  @override
  String get symDormantCheck => 'It\'s the cold season';

  @override
  String get symDormantFix =>
      'That\'s normal — growth resumes in spring. Water a little less in winter.';

  @override
  String get symPotboundTitle => 'Outgrown its pot';

  @override
  String get symPotboundCheck =>
      'Roots poke out of the drainage hole, or water runs straight through';

  @override
  String get symPotboundFix => 'Repot into a pot one size larger in spring';

  @override
  String get myTitle => 'My';

  @override
  String get myStatWaterings => 'Waterings\nthis month';

  @override
  String get myStatDiary => 'Diary';

  @override
  String get myStatStreak => 'Day streak';

  @override
  String get mySectionNotifications => 'Notifications';

  @override
  String get myNotifyTime => 'Reminder time';

  @override
  String get myNotifyTiming => 'When to remind';

  @override
  String get myNotifyDayBefore => 'Day before';

  @override
  String get myNotifySameDay => 'Same day';

  @override
  String get myPause => 'Pause reminders';

  @override
  String get myPauseOff => 'Off';

  @override
  String myPauseUntil(String date) {
    return 'Until $date';
  }

  @override
  String get myNotifyDays => 'Reminder days';

  @override
  String get myEveryDay => 'Every day';

  @override
  String mySkipDays(String days) {
    return 'Except $days';
  }

  @override
  String get mySectionData => 'Data';

  @override
  String get myBackup => 'Export & import records';

  @override
  String get myBackupValue => 'File';

  @override
  String get myRequestSpecies => 'Request a species';

  @override
  String get myDebugNotify => '(Dev) Notify in 10 s';

  @override
  String get myDebugTest => 'Test';

  @override
  String get mySectionInfo => 'About';

  @override
  String get myTermsPrivacy => 'Terms & privacy policy';

  @override
  String get myPhotoCredits => 'Catalog photo credits';

  @override
  String get myContact => 'Contact';

  @override
  String get myVersion => 'Version';

  @override
  String get myLocalOnly =>
      'Records are stored only on this device. Phone backups (Google/iCloud) include them; to move photos too, use export.';

  @override
  String get myNotifyTimeHelp => 'Watering reminder time';

  @override
  String get mySkipDaysTitle => 'Days without reminders';

  @override
  String get mySkipAllWarning =>
      'If you exclude every day, you won\'t get reminders';

  @override
  String get pauseHelp => 'Pause reminders until this date';

  @override
  String get pauseTitle => 'Pause reminders';

  @override
  String get pauseSubtitle => 'Pause reminders while you\'re traveling or away';

  @override
  String pauseDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get pauseOneWeek => '1 week';

  @override
  String get pauseTwoWeeks => '2 weeks';

  @override
  String pauseUntilDate(String date) {
    return 'Until $date';
  }

  @override
  String pauseNoneDue(String date) {
    return 'No plants need water until $date';
  }

  @override
  String pauseWaterBefore(String names) {
    return 'Water these before you leave: $names';
  }

  @override
  String get pausePickPeriod => 'Choose a period';

  @override
  String pauseConfirm(String date) {
    return 'Pause until $date';
  }

  @override
  String get pauseResume => 'Turn reminders back on';

  @override
  String get creditsTitle => 'Catalog photo credits';

  @override
  String get creditsIntro =>
      'Catalog photos are freely licensed images from Wikimedia Commons. The author, license and source of each photo are listed below.';

  @override
  String get backupShareSubject => 'Jaljarara records backup';

  @override
  String get backupShareText =>
      'This is a Jaljarara backup file. Restore it on a new phone from My › Export & import records.';

  @override
  String get backupExported => 'File created. Send it somewhere safe.';

  @override
  String backupExportFailed(String error) {
    return 'Export failed: $error';
  }

  @override
  String get backupNotOurs => 'This isn\'t a Jaljarara backup file';

  @override
  String get backupImportQ => 'Import these records?';

  @override
  String backupImportSummary(String date, int plants, int diaries, int photos) {
    return 'Exported on $date.\n$plants plants · $diaries diary entries · $photos photos\n\nAll records on this phone will be replaced with this file.';
  }

  @override
  String get backupImport => 'Import';

  @override
  String get backupImported => 'Imported. Check your home screen.';

  @override
  String backupImportFailed(String error) {
    return 'Import failed: $error';
  }

  @override
  String get backupTitle => 'Export & import records';

  @override
  String get backupExport => 'Export';

  @override
  String get backupExportBody =>
      'Bundles your plants, watering history, diary and photos into one file. Keep it anywhere — email, Google Drive, a chat with yourself.';

  @override
  String get backupExportButton => 'Create and send file';

  @override
  String get backupImportBody =>
      'On a new phone, choose the exported file to restore everything. Records currently on this phone will be replaced.';

  @override
  String get backupImportButton => 'Choose file to import';

  @override
  String get backupNote =>
      'Tip: with phone backup (Google or iCloud) turned on, your records move to a new phone automatically. Android auto backup doesn\'t include photos, so use export to move them.';
}
