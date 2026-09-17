import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Jaljarara'**
  String get appName;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get commonRemove;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get commonLater;

  /// No description provided for @commonToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get commonToday;

  /// No description provided for @commonYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get commonYesterday;

  /// No description provided for @commonPickDate.
  ///
  /// In en, this message translates to:
  /// **'Pick a date'**
  String get commonPickDate;

  /// No description provided for @commonComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get commonComingSoon;

  /// No description provided for @commonLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load. Please try again.'**
  String get commonLoadFailed;

  /// No description provided for @commonPhotoLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t get the photo'**
  String get commonPhotoLoadFailed;

  /// No description provided for @commonTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get commonTakePhoto;

  /// No description provided for @commonPickFromAlbum.
  ///
  /// In en, this message translates to:
  /// **'Choose from album'**
  String get commonPickFromAlbum;

  /// No description provided for @commonAlbum.
  ///
  /// In en, this message translates to:
  /// **'Album'**
  String get commonAlbum;

  /// No description provided for @commonSearchByName.
  ///
  /// In en, this message translates to:
  /// **'Search by name'**
  String get commonSearchByName;

  /// No description provided for @commonManualEntry.
  ///
  /// In en, this message translates to:
  /// **'Enter manually'**
  String get commonManualEntry;

  /// No description provided for @commonDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String commonDays(int count);

  /// No description provided for @commonEveryDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Every day} other{Every {count} days}}'**
  String commonEveryDays(int count);

  /// No description provided for @listSeparator.
  ///
  /// In en, this message translates to:
  /// **', '**
  String get listSeparator;

  /// No description provided for @nameSeparator.
  ///
  /// In en, this message translates to:
  /// **', '**
  String get nameSeparator;

  /// No description provided for @speciesUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown species'**
  String get speciesUnknown;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get tabCamera;

  /// No description provided for @tabMy.
  ///
  /// In en, this message translates to:
  /// **'My'**
  String get tabMy;

  /// No description provided for @semanticsSelect.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get semanticsSelect;

  /// No description provided for @statusToday.
  ///
  /// In en, this message translates to:
  /// **'Water today'**
  String get statusToday;

  /// No description provided for @statusDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Tomorrow} other{In {count} days}}'**
  String statusDaysLeft(int count);

  /// No description provided for @statusOverdue.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day late} other{{count} days late}}'**
  String statusOverdue(int count);

  /// No description provided for @dangerPetAndChild.
  ///
  /// In en, this message translates to:
  /// **'Dangerous for pets and children'**
  String get dangerPetAndChild;

  /// No description provided for @dangerChild.
  ///
  /// In en, this message translates to:
  /// **'Dangerous for children'**
  String get dangerChild;

  /// No description provided for @dangerPet.
  ///
  /// In en, this message translates to:
  /// **'Dangerous for pets'**
  String get dangerPet;

  /// No description provided for @toxicMildNote.
  ///
  /// In en, this message translates to:
  /// **'Note: pets or children chewing the leaves may get an upset stomach'**
  String get toxicMildNote;

  /// No description provided for @windowDirE.
  ///
  /// In en, this message translates to:
  /// **'East'**
  String get windowDirE;

  /// No description provided for @windowDirW.
  ///
  /// In en, this message translates to:
  /// **'West'**
  String get windowDirW;

  /// No description provided for @windowDirS.
  ///
  /// In en, this message translates to:
  /// **'South'**
  String get windowDirS;

  /// No description provided for @windowDirN.
  ///
  /// In en, this message translates to:
  /// **'North'**
  String get windowDirN;

  /// No description provided for @windowDirNone.
  ///
  /// In en, this message translates to:
  /// **'No window'**
  String get windowDirNone;

  /// No description provided for @windowDistNear.
  ///
  /// In en, this message translates to:
  /// **'By the window'**
  String get windowDistNear;

  /// No description provided for @windowDistOneMeter.
  ///
  /// In en, this message translates to:
  /// **'Within 1 m'**
  String get windowDistOneMeter;

  /// No description provided for @windowDistFar.
  ///
  /// In en, this message translates to:
  /// **'Far'**
  String get windowDistFar;

  /// No description provided for @potSizeS.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get potSizeS;

  /// No description provided for @potSizeM.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get potSizeM;

  /// No description provided for @potSizeL.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get potSizeL;

  /// No description provided for @diaryTagNewLeaf.
  ///
  /// In en, this message translates to:
  /// **'New leaf'**
  String get diaryTagNewLeaf;

  /// No description provided for @diaryTagFlower.
  ///
  /// In en, this message translates to:
  /// **'Flower'**
  String get diaryTagFlower;

  /// No description provided for @diaryTagDroop.
  ///
  /// In en, this message translates to:
  /// **'Drooping'**
  String get diaryTagDroop;

  /// No description provided for @diaryTagYellow.
  ///
  /// In en, this message translates to:
  /// **'Yellow leaves'**
  String get diaryTagYellow;

  /// No description provided for @diaryTagPest.
  ///
  /// In en, this message translates to:
  /// **'Pests?'**
  String get diaryTagPest;

  /// No description provided for @notifChannelName.
  ///
  /// In en, this message translates to:
  /// **'Watering reminders'**
  String get notifChannelName;

  /// No description provided for @notifChannelDesc.
  ///
  /// In en, this message translates to:
  /// **'Tells you which plants need water, by name'**
  String get notifChannelDesc;

  /// No description provided for @notifActionWatered.
  ///
  /// In en, this message translates to:
  /// **'Watered'**
  String get notifActionWatered;

  /// No description provided for @notifActionSnooze.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get notifActionSnooze;

  /// No description provided for @notifActionWateredEarly.
  ///
  /// In en, this message translates to:
  /// **'Watered today'**
  String get notifActionWateredEarly;

  /// No description provided for @notifWhoMore.
  ///
  /// In en, this message translates to:
  /// **'{names} and {count} more'**
  String notifWhoMore(String names, int count);

  /// No description provided for @notifBodyToday.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{who} needs water today} other{{who} need water today}}'**
  String notifBodyToday(String who, int count);

  /// No description provided for @notifBodyTomorrow.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{who} needs water tomorrow} other{{who} need water tomorrow}}'**
  String notifBodyTomorrow(String who, int count);

  /// No description provided for @onbSlide1Title.
  ///
  /// In en, this message translates to:
  /// **'Help your plants thrive'**
  String get onbSlide1Title;

  /// No description provided for @onbSlide1Body.
  ///
  /// In en, this message translates to:
  /// **'Search by name or snap a photo to add a plant,\nand get a watering schedule that fits it'**
  String get onbSlide1Body;

  /// No description provided for @onbSlide2Title.
  ///
  /// In en, this message translates to:
  /// **'Never miss a watering day'**
  String get onbSlide2Title;

  /// No description provided for @onbSlide2Body.
  ///
  /// In en, this message translates to:
  /// **'We remind you when each plant needs water.\nTap \"Watered\" once and the next date is set'**
  String get onbSlide2Body;

  /// No description provided for @onbSlide3Title.
  ///
  /// In en, this message translates to:
  /// **'No sign-up, no ads'**
  String get onbSlide3Title;

  /// No description provided for @onbSlide3Body.
  ///
  /// In en, this message translates to:
  /// **'Your records stay on this device.\nPhotos are never uploaded to a server'**
  String get onbSlide3Body;

  /// No description provided for @onbStart.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onbStart;

  /// No description provided for @onbPermTitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll remind you on watering days'**
  String get onbPermTitle;

  /// No description provided for @onbPermBody.
  ///
  /// In en, this message translates to:
  /// **'We notify you at 9 AM on watering days.\nYou can change the time in My'**
  String get onbPermBody;

  /// No description provided for @onbPermAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications'**
  String get onbPermAllow;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get homeTitle;

  /// No description provided for @homeLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load. Please reopen the app.'**
  String get homeLoadFailed;

  /// No description provided for @homeEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first plant'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Snap a photo and we\'ll tell you the species and when to water'**
  String get homeEmptyBody;

  /// No description provided for @homeAddPlant.
  ///
  /// In en, this message translates to:
  /// **'Add plant'**
  String get homeAddPlant;

  /// No description provided for @homeAddPlantPlus.
  ///
  /// In en, this message translates to:
  /// **'+ Add plant'**
  String get homeAddPlantPlus;

  /// No description provided for @homeDueHeader.
  ///
  /// In en, this message translates to:
  /// **'To water {count}'**
  String homeDueHeader(int count);

  /// No description provided for @homeSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get homeSelectAll;

  /// No description provided for @homeDeselect.
  ///
  /// In en, this message translates to:
  /// **'Deselect'**
  String get homeDeselect;

  /// No description provided for @homeNothingDue.
  ///
  /// In en, this message translates to:
  /// **'No plants need water today'**
  String get homeNothingDue;

  /// No description provided for @homeMyPlants.
  ///
  /// In en, this message translates to:
  /// **'My plants {count}'**
  String homeMyPlants(int count);

  /// No description provided for @homeWateredCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Watered 1 plant} other{Watered {count} plants}}'**
  String homeWateredCount(int count);

  /// No description provided for @homeViewGrid.
  ///
  /// In en, this message translates to:
  /// **'Album'**
  String get homeViewGrid;

  /// No description provided for @homeViewList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get homeViewList;

  /// No description provided for @homePausedBanner.
  ///
  /// In en, this message translates to:
  /// **'Reminders paused until {date}'**
  String homePausedBanner(String date);

  /// No description provided for @homeResume.
  ///
  /// In en, this message translates to:
  /// **'Turn back on'**
  String get homeResume;

  /// No description provided for @waterSheetPlants.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 plant} other{{count} plants}}'**
  String waterSheetPlants(int count);

  /// No description provided for @waterSheetWatered.
  ///
  /// In en, this message translates to:
  /// **'Watered'**
  String get waterSheetWatered;

  /// No description provided for @waterSheetLater.
  ///
  /// In en, this message translates to:
  /// **'Later · we\'ll remind you in {count, plural, =1{1 day} other{{count} days}}'**
  String waterSheetLater(int count);

  /// No description provided for @addTitle.
  ///
  /// In en, this message translates to:
  /// **'Add plant'**
  String get addTitle;

  /// No description provided for @addHowTo.
  ///
  /// In en, this message translates to:
  /// **'How would you like to add it?'**
  String get addHowTo;

  /// No description provided for @addByPhoto.
  ///
  /// In en, this message translates to:
  /// **'Identify by photo'**
  String get addByPhoto;

  /// No description provided for @addByPhotoSub.
  ///
  /// In en, this message translates to:
  /// **'Take a photo showing the whole leaf and we\'ll find the species'**
  String get addByPhotoSub;

  /// No description provided for @addByNameSub.
  ///
  /// In en, this message translates to:
  /// **'Find it by common or scientific name'**
  String get addByNameSub;

  /// No description provided for @addManualSub.
  ///
  /// In en, this message translates to:
  /// **'Add it with just a name, even if you don\'t know the species'**
  String get addManualSub;

  /// No description provided for @manualPlantName.
  ///
  /// In en, this message translates to:
  /// **'Plant name'**
  String get manualPlantName;

  /// No description provided for @manualHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Window greenie'**
  String get manualHint;

  /// No description provided for @manualInfo.
  ///
  /// In en, this message translates to:
  /// **'Without a species, watering starts at every 7 days. You can change it anytime on the plant page.'**
  String get manualInfo;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Add to my plants'**
  String get registerTitle;

  /// No description provided for @registerNotInCatalog.
  ///
  /// In en, this message translates to:
  /// **'This species isn\'t in our catalog yet. Please name it yourself.'**
  String get registerNotInCatalog;

  /// No description provided for @registerName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get registerName;

  /// No description provided for @registerNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Living room monstera'**
  String get registerNameHint;

  /// No description provided for @registerLastWatered.
  ///
  /// In en, this message translates to:
  /// **'Last watered'**
  String get registerLastWatered;

  /// No description provided for @registerInterval.
  ///
  /// In en, this message translates to:
  /// **'We\'ll remind you about every {count, plural, =1{day} other{{count} days}}'**
  String registerInterval(int count);

  /// No description provided for @registerIntervalManual.
  ///
  /// In en, this message translates to:
  /// **' (set by you)'**
  String get registerIntervalManual;

  /// No description provided for @registerEditInterval.
  ///
  /// In en, this message translates to:
  /// **'Edit interval'**
  String get registerEditInterval;

  /// No description provided for @registerBackToAuto.
  ///
  /// In en, this message translates to:
  /// **'Back to auto ({count, plural, =1{1 day} other{{count} days}})'**
  String registerBackToAuto(int count);

  /// No description provided for @registerMemo.
  ///
  /// In en, this message translates to:
  /// **'Memo (optional)'**
  String get registerMemo;

  /// No description provided for @memoHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Left side of the balcony. Droopy leaves mean thirsty.'**
  String get memoHint;

  /// No description provided for @registerSubmit.
  ///
  /// In en, this message translates to:
  /// **'Add plant'**
  String get registerSubmit;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search by name'**
  String get searchTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Monstera, Pothos'**
  String get searchHint;

  /// No description provided for @searchCatalogFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the catalog'**
  String get searchCatalogFailed;

  /// No description provided for @searchNotListed.
  ///
  /// In en, this message translates to:
  /// **'Not listed → Enter manually'**
  String get searchNotListed;

  /// No description provided for @searchPrompt.
  ///
  /// In en, this message translates to:
  /// **'Type a common or scientific name'**
  String get searchPrompt;

  /// No description provided for @searchError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while searching'**
  String get searchError;

  /// No description provided for @searchNoResult.
  ///
  /// In en, this message translates to:
  /// **'No species match \"{query}\".\nYou can add it manually below.'**
  String searchNoResult(String query);

  /// No description provided for @searchAlsoKnownAs.
  ///
  /// In en, this message translates to:
  /// **'Also known as {alias}'**
  String searchAlsoKnownAs(String alias);

  /// No description provided for @searchViewCatalog.
  ///
  /// In en, this message translates to:
  /// **'View catalog'**
  String get searchViewCatalog;

  /// No description provided for @cameraTitle.
  ///
  /// In en, this message translates to:
  /// **'Identify'**
  String get cameraTitle;

  /// No description provided for @cameraGuide.
  ///
  /// In en, this message translates to:
  /// **'Capture the whole leaf'**
  String get cameraGuide;

  /// No description provided for @cameraTip1.
  ///
  /// In en, this message translates to:
  /// **'In good light, with the leaf filling at least half the frame'**
  String get cameraTip1;

  /// No description provided for @cameraTip2.
  ///
  /// In en, this message translates to:
  /// **'If it has flowers, include them for better accuracy'**
  String get cameraTip2;

  /// No description provided for @cameraPickFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t get the photo. Check permissions or try another photo.'**
  String get cameraPickFailed;

  /// No description provided for @cameraPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing…'**
  String get cameraPreparing;

  /// No description provided for @identifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Identification'**
  String get identifyTitle;

  /// No description provided for @identifyAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get identifyAddPhoto;

  /// No description provided for @identifyAddPhotoTip.
  ///
  /// In en, this message translates to:
  /// **'A close-up of a leaf, or a flower if it has one, improves accuracy'**
  String get identifyAddPhotoTip;

  /// No description provided for @identifyAddPhotoHint.
  ///
  /// In en, this message translates to:
  /// **'Add a close-up of a leaf or flower for better accuracy'**
  String get identifyAddPhotoHint;

  /// No description provided for @identifyPhotoGoesCover.
  ///
  /// In en, this message translates to:
  /// **'The photo you took will be used as the cover photo'**
  String get identifyPhotoGoesCover;

  /// No description provided for @identifySearching.
  ///
  /// In en, this message translates to:
  /// **'Finding out what this plant is'**
  String get identifySearching;

  /// No description provided for @identifySearchingMulti.
  ///
  /// In en, this message translates to:
  /// **'Searching again with {count} photos'**
  String identifySearchingMulti(int count);

  /// No description provided for @identifyThisIsIt.
  ///
  /// In en, this message translates to:
  /// **'That\'s my plant'**
  String get identifyThisIsIt;

  /// No description provided for @identifyOtherCandidates.
  ///
  /// In en, this message translates to:
  /// **'Other matches'**
  String get identifyOtherCandidates;

  /// No description provided for @identifyNotListed.
  ///
  /// In en, this message translates to:
  /// **'It\'s not here'**
  String get identifyNotListed;

  /// No description provided for @identifyIsItHere.
  ///
  /// In en, this message translates to:
  /// **'Is it one of these?'**
  String get identifyIsItHere;

  /// No description provided for @identifyNotInCatalog.
  ///
  /// In en, this message translates to:
  /// **'Not in our catalog · you can name it when adding'**
  String get identifyNotInCatalog;

  /// No description provided for @identifyLimitTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'ve used today\'s identifications'**
  String get identifyLimitTitle;

  /// No description provided for @identifyLimitBody.
  ///
  /// In en, this message translates to:
  /// **'Try again tomorrow, or add it by searching its name'**
  String get identifyLimitBody;

  /// No description provided for @identifyOfflineTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline'**
  String get identifyOfflineTitle;

  /// No description provided for @identifyOfflineBody.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again, or add it by searching its name'**
  String get identifyOfflineBody;

  /// No description provided for @identifyNoResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t find this plant'**
  String get identifyNoResultTitle;

  /// No description provided for @identifyNoResultBody.
  ///
  /// In en, this message translates to:
  /// **'Add a close-up of a leaf or flower, or add it by searching its name'**
  String get identifyNoResultBody;

  /// No description provided for @identifyUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Identification isn\'t available right now'**
  String get identifyUnavailableTitle;

  /// No description provided for @identifyUnavailableBody.
  ///
  /// In en, this message translates to:
  /// **'The identification service isn\'t set up yet. Try searching by name.'**
  String get identifyUnavailableBody;

  /// No description provided for @identifyRetryWithPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add a photo and try again'**
  String get identifyRetryWithPhoto;

  /// No description provided for @identifyManualRegister.
  ///
  /// In en, this message translates to:
  /// **'Add manually'**
  String get identifyManualRegister;

  /// No description provided for @diaryWriteTitle.
  ///
  /// In en, this message translates to:
  /// **'Write a diary'**
  String get diaryWriteTitle;

  /// No description provided for @diaryWriteTitleFor.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s diary'**
  String diaryWriteTitleFor(String name);

  /// No description provided for @diaryRemovePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get diaryRemovePhoto;

  /// No description provided for @diarySetCover.
  ///
  /// In en, this message translates to:
  /// **'Use as cover photo'**
  String get diarySetCover;

  /// No description provided for @diaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Diary'**
  String get diaryLabel;

  /// No description provided for @diaryHint.
  ///
  /// In en, this message translates to:
  /// **'How is your plant today? New leaves, drooping…'**
  String get diaryHint;

  /// No description provided for @detailDeleted.
  ///
  /// In en, this message translates to:
  /// **'This plant was deleted'**
  String get detailDeleted;

  /// No description provided for @detailRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get detailRename;

  /// No description provided for @detailMyMemo.
  ///
  /// In en, this message translates to:
  /// **'My memo'**
  String get detailMyMemo;

  /// No description provided for @detailPlace.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get detailPlace;

  /// No description provided for @detailPlaceNone.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get detailPlaceNone;

  /// No description provided for @detailAddPlace.
  ///
  /// In en, this message translates to:
  /// **'+ Add a location'**
  String get detailAddPlace;

  /// No description provided for @detailChangePlace.
  ///
  /// In en, this message translates to:
  /// **'Change location'**
  String get detailChangePlace;

  /// No description provided for @detailDeleteDiaryQ.
  ///
  /// In en, this message translates to:
  /// **'Delete this diary entry?'**
  String get detailDeleteDiaryQ;

  /// No description provided for @detailDeletePlantQ.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String detailDeletePlantQ(String name);

  /// No description provided for @detailDeletePlantBody.
  ///
  /// In en, this message translates to:
  /// **'Its watering history and memo will be deleted too'**
  String get detailDeletePlantBody;

  /// No description provided for @detailCatalogPhoto.
  ///
  /// In en, this message translates to:
  /// **'Catalog photo'**
  String get detailCatalogPhoto;

  /// No description provided for @detailOverdue.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Watering is 1 day late} other{Watering is {count} days late}}'**
  String detailOverdue(int count);

  /// No description provided for @detailDueToday.
  ///
  /// In en, this message translates to:
  /// **'It\'s watering day'**
  String get detailDueToday;

  /// No description provided for @detailUntilNext.
  ///
  /// In en, this message translates to:
  /// **'Next watering'**
  String get detailUntilNext;

  /// No description provided for @detailDDay.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get detailDDay;

  /// No description provided for @detailIntervalManual.
  ///
  /// In en, this message translates to:
  /// **' (set by you)'**
  String get detailIntervalManual;

  /// No description provided for @detailIntervalAuto.
  ///
  /// In en, this message translates to:
  /// **' (auto)'**
  String get detailIntervalAuto;

  /// No description provided for @detailLastWatered.
  ///
  /// In en, this message translates to:
  /// **' · last {date}'**
  String detailLastWatered(String date);

  /// No description provided for @detailAdjust.
  ///
  /// In en, this message translates to:
  /// **'Adjust'**
  String get detailAdjust;

  /// No description provided for @detailAddMemo.
  ///
  /// In en, this message translates to:
  /// **'+ Add a memo'**
  String get detailAddMemo;

  /// No description provided for @detailDiaryWrite.
  ///
  /// In en, this message translates to:
  /// **'+ Write'**
  String get detailDiaryWrite;

  /// No description provided for @detailDiaryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Record how it grows with a photo and a line'**
  String get detailDiaryEmpty;

  /// No description provided for @detailDiaryMore.
  ///
  /// In en, this message translates to:
  /// **'{count} more'**
  String detailDiaryMore(int count);

  /// No description provided for @detailGoodToKnow.
  ///
  /// In en, this message translates to:
  /// **'Good to know'**
  String get detailGoodToKnow;

  /// No description provided for @detailNoSpeciesInfo.
  ///
  /// In en, this message translates to:
  /// **'Set a species to see care info. Identify it with the camera or search by name.'**
  String get detailNoSpeciesInfo;

  /// No description provided for @detailSymptomEntry.
  ///
  /// In en, this message translates to:
  /// **'Plant looking unwell? Find the cause by symptom'**
  String get detailSymptomEntry;

  /// No description provided for @detailAlreadyWatered.
  ///
  /// In en, this message translates to:
  /// **'Already watered today'**
  String get detailAlreadyWatered;

  /// No description provided for @detailWateredToday.
  ///
  /// In en, this message translates to:
  /// **'Watered today'**
  String get detailWateredToday;

  /// No description provided for @detailWatered.
  ///
  /// In en, this message translates to:
  /// **'Watered'**
  String get detailWatered;

  /// No description provided for @tipWaterSucculent.
  ///
  /// In en, this message translates to:
  /// **'Water about every {days} days, soaking thoroughly only after the soil is completely dry. Overwatering is the most common mistake.'**
  String tipWaterSucculent(int days);

  /// No description provided for @tipWaterHerb.
  ///
  /// In en, this message translates to:
  /// **'Water about every {days} days, as soon as the topsoil dries. Herbs droop quickly when dry.'**
  String tipWaterHerb(int days);

  /// No description provided for @tipWaterFlower.
  ///
  /// In en, this message translates to:
  /// **'Water about every {days} days when the topsoil dries. Check a little more often while it blooms.'**
  String tipWaterFlower(int days);

  /// No description provided for @tipWaterFoliage.
  ///
  /// In en, this message translates to:
  /// **'Water about every {days} days until it drains from the bottom. Empty the saucer afterwards.'**
  String tipWaterFoliage(int days);

  /// No description provided for @tipLightLow.
  ///
  /// In en, this message translates to:
  /// **'Does fine in low light. Direct sun can scorch the leaves, so keep it a little away from the window.'**
  String get tipLightLow;

  /// No description provided for @tipLightMed.
  ///
  /// In en, this message translates to:
  /// **'Likes bright, indirect light, such as a curtained window or within 1 m of a window.'**
  String get tipLightMed;

  /// No description provided for @tipLightHigh.
  ///
  /// In en, this message translates to:
  /// **'Needs plenty of sun. Keep it by a sunny window; without enough light it gets leggy.'**
  String get tipLightHigh;

  /// No description provided for @tipTempOptimal.
  ///
  /// In en, this message translates to:
  /// **'Best at {min}–{max}'**
  String tipTempOptimal(String min, String max);

  /// No description provided for @tipTempHardy.
  ///
  /// In en, this message translates to:
  /// **'{opt}. Cold-hardy, but keep it out of cold drafts indoors'**
  String tipTempHardy(String opt);

  /// No description provided for @tipTempCool.
  ///
  /// In en, this message translates to:
  /// **'{opt}. Tolerates down to {low}, so a cool spot in winter is fine'**
  String tipTempCool(String opt, String low);

  /// No description provided for @tipTempTender.
  ///
  /// In en, this message translates to:
  /// **'{opt}. Below {low} the leaves get damaged, so move it away from cold windows in winter'**
  String tipTempTender(String opt, String low);

  /// No description provided for @intervalTitle.
  ///
  /// In en, this message translates to:
  /// **'Adjust watering'**
  String get intervalTitle;

  /// No description provided for @intervalBasis.
  ///
  /// In en, this message translates to:
  /// **'How it’s calculated'**
  String get intervalBasis;

  /// No description provided for @intervalFormula.
  ///
  /// In en, this message translates to:
  /// **'Species {base} × season {season} × light {light} × pot {pot} × feedback {feedback}'**
  String intervalFormula(
    String base,
    String season,
    String light,
    String pot,
    String feedback,
  );

  /// No description provided for @intervalManual.
  ///
  /// In en, this message translates to:
  /// **'Set it myself'**
  String get intervalManual;

  /// No description provided for @intervalManualOn.
  ///
  /// In en, this message translates to:
  /// **'Uses the interval you set'**
  String get intervalManualOn;

  /// No description provided for @intervalManualOff.
  ///
  /// In en, this message translates to:
  /// **'Calculated automatically for season and conditions'**
  String get intervalManualOff;

  /// No description provided for @spaceDeleteQ.
  ///
  /// In en, this message translates to:
  /// **'Delete this location?'**
  String get spaceDeleteQ;

  /// No description provided for @spaceDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'Plants here will become \"location not set\"'**
  String get spaceDeleteBody;

  /// No description provided for @spaceEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit location'**
  String get spaceEditTitle;

  /// No description provided for @spaceAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add location'**
  String get spaceAddTitle;

  /// No description provided for @spaceName.
  ///
  /// In en, this message translates to:
  /// **'Location name'**
  String get spaceName;

  /// No description provided for @spaceNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Living room, Balcony, Office desk'**
  String get spaceNameHint;

  /// No description provided for @spaceWindowDir.
  ///
  /// In en, this message translates to:
  /// **'Window direction'**
  String get spaceWindowDir;

  /// No description provided for @spaceWindowDist.
  ///
  /// In en, this message translates to:
  /// **'Distance from window'**
  String get spaceWindowDist;

  /// No description provided for @spaceLightInfo.
  ///
  /// In en, this message translates to:
  /// **'We estimate light from window direction and distance'**
  String get spaceLightInfo;

  /// No description provided for @spaceAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get spaceAdd;

  /// No description provided for @infoTitle.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get infoTitle;

  /// No description provided for @infoNotInCatalog.
  ///
  /// In en, this message translates to:
  /// **'This species isn\'t in the catalog'**
  String get infoNotInCatalog;

  /// No description provided for @infoCategorySucculent.
  ///
  /// In en, this message translates to:
  /// **'Succulents & cacti'**
  String get infoCategorySucculent;

  /// No description provided for @infoCategoryHerb.
  ///
  /// In en, this message translates to:
  /// **'Herbs'**
  String get infoCategoryHerb;

  /// No description provided for @infoCategoryFlower.
  ///
  /// In en, this message translates to:
  /// **'Flowering plants'**
  String get infoCategoryFlower;

  /// No description provided for @infoCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get infoCategoryOther;

  /// No description provided for @infoCategoryFoliage.
  ///
  /// In en, this message translates to:
  /// **'Foliage plants'**
  String get infoCategoryFoliage;

  /// No description provided for @infoPhotoCredit.
  ///
  /// In en, this message translates to:
  /// **'Photo: {author} · {license} · Wikimedia Commons'**
  String infoPhotoCredit(String author, String license);

  /// No description provided for @infoUnknownAuthor.
  ///
  /// In en, this message translates to:
  /// **'Unknown author'**
  String get infoUnknownAuthor;

  /// No description provided for @infoOtherNames.
  ///
  /// In en, this message translates to:
  /// **'Also called: {names}'**
  String infoOtherNames(String names);

  /// No description provided for @infoWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get infoWater;

  /// No description provided for @infoWaterBase.
  ///
  /// In en, this message translates to:
  /// **'Base: every {days} days'**
  String infoWaterBase(int days);

  /// No description provided for @infoWaterSucculent.
  ///
  /// In en, this message translates to:
  /// **'Soak only after the soil is completely dry. Overwatering is the most common mistake.'**
  String get infoWaterSucculent;

  /// No description provided for @infoWaterHerb.
  ///
  /// In en, this message translates to:
  /// **'As soon as the topsoil dries. Herbs droop quickly when dry.'**
  String get infoWaterHerb;

  /// No description provided for @infoWaterFlower.
  ///
  /// In en, this message translates to:
  /// **'When the topsoil dries. Check a little more often while it blooms.'**
  String get infoWaterFlower;

  /// No description provided for @infoWaterFoliage.
  ///
  /// In en, this message translates to:
  /// **'When the soil is dry two knuckles deep, water until it drains. Empty the saucer.'**
  String get infoWaterFoliage;

  /// No description provided for @infoWaterAuto.
  ///
  /// In en, this message translates to:
  /// **'The app adjusts this interval for the season automatically'**
  String get infoWaterAuto;

  /// No description provided for @infoLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get infoLight;

  /// No description provided for @infoLightLow.
  ///
  /// In en, this message translates to:
  /// **'Tolerates low light (partial shade)'**
  String get infoLightLow;

  /// No description provided for @infoLightMed.
  ///
  /// In en, this message translates to:
  /// **'Bright, indirect light (curtained window, within 1 m of a window)'**
  String get infoLightMed;

  /// No description provided for @infoLightHigh.
  ///
  /// In en, this message translates to:
  /// **'Plenty of sun (sunny window)'**
  String get infoLightHigh;

  /// No description provided for @infoLightLowNote.
  ///
  /// In en, this message translates to:
  /// **'Direct sun can scorch the leaves'**
  String get infoLightLowNote;

  /// No description provided for @infoLightMedNote.
  ///
  /// In en, this message translates to:
  /// **'Avoid harsh midsummer sun'**
  String get infoLightMedNote;

  /// No description provided for @infoLightHighNote.
  ///
  /// In en, this message translates to:
  /// **'Without enough light it gets leggy and pale'**
  String get infoLightHighNote;

  /// No description provided for @infoTempHumidity.
  ///
  /// In en, this message translates to:
  /// **'Temperature & humidity'**
  String get infoTempHumidity;

  /// No description provided for @infoHumidityTip.
  ///
  /// In en, this message translates to:
  /// **'In dry winter air, mist the leaves or keep a humidifier nearby'**
  String get infoHumidityTip;

  /// No description provided for @infoCommonIssues.
  ///
  /// In en, this message translates to:
  /// **'Common problems'**
  String get infoCommonIssues;

  /// No description provided for @infoAddToMine.
  ///
  /// In en, this message translates to:
  /// **'Add to my plants'**
  String get infoAddToMine;

  /// No description provided for @symTitle.
  ///
  /// In en, this message translates to:
  /// **'Find the cause by symptom'**
  String get symTitle;

  /// No description provided for @symDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This isn\'t a photo diagnosis — it lists common causes. Several can overlap, so use the checks to decide.'**
  String get symDisclaimer;

  /// No description provided for @symSpeciesIssues.
  ///
  /// In en, this message translates to:
  /// **'Common problems for {name}'**
  String symSpeciesIssues(String name);

  /// No description provided for @symWhichSymptom.
  ///
  /// In en, this message translates to:
  /// **'What do you see?'**
  String get symWhichSymptom;

  /// No description provided for @symCheck.
  ///
  /// In en, this message translates to:
  /// **'Check: {text}'**
  String symCheck(String text);

  /// No description provided for @symAdjustInterval.
  ///
  /// In en, this message translates to:
  /// **'Adjust watering interval'**
  String get symAdjustInterval;

  /// No description provided for @symOverwaterTitle.
  ///
  /// In en, this message translates to:
  /// **'Watering too often (overwatering)'**
  String get symOverwaterTitle;

  /// No description provided for @symOverwaterCheck.
  ///
  /// In en, this message translates to:
  /// **'The soil stays wet for days, lower leaves yellow first and feel soft'**
  String get symOverwaterCheck;

  /// No description provided for @symOverwaterFix.
  ///
  /// In en, this message translates to:
  /// **'Stop watering until the soil dries through, and lengthen the interval. Empty any water in the saucer.'**
  String get symOverwaterFix;

  /// No description provided for @symUnderwaterTitle.
  ///
  /// In en, this message translates to:
  /// **'Not enough water'**
  String get symUnderwaterTitle;

  /// No description provided for @symUnderwaterCheck.
  ///
  /// In en, this message translates to:
  /// **'The soil is bone dry, the pot feels light, and leaves droop thin and limp'**
  String get symUnderwaterCheck;

  /// No description provided for @symUnderwaterFix.
  ///
  /// In en, this message translates to:
  /// **'Water until it drains from the bottom. If this keeps happening, shorten the interval.'**
  String get symUnderwaterFix;

  /// No description provided for @symLowLightTitle.
  ///
  /// In en, this message translates to:
  /// **'Not enough light'**
  String get symLowLightTitle;

  /// No description provided for @symLowLightCheck.
  ///
  /// In en, this message translates to:
  /// **'Leaves turn pale overall and stems grow thin and long'**
  String get symLowLightCheck;

  /// No description provided for @symLowLightFix.
  ///
  /// In en, this message translates to:
  /// **'Move it somewhere brighter, like a window. Just avoid harsh midsummer sun.'**
  String get symLowLightFix;

  /// No description provided for @symColdTitle.
  ///
  /// In en, this message translates to:
  /// **'Cold or drafts'**
  String get symColdTitle;

  /// No description provided for @symColdCheck.
  ///
  /// In en, this message translates to:
  /// **'It sits by a cold winter window or in the path of AC or door drafts'**
  String get symColdCheck;

  /// No description provided for @symColdFix.
  ///
  /// In en, this message translates to:
  /// **'Move it somewhere warm away from drafts. Damaged leaves won\'t recover, so remove them.'**
  String get symColdFix;

  /// No description provided for @symYellow.
  ///
  /// In en, this message translates to:
  /// **'Leaves turning yellow'**
  String get symYellow;

  /// No description provided for @symOldLeafTitle.
  ///
  /// In en, this message translates to:
  /// **'Old leaves dropping naturally'**
  String get symOldLeafTitle;

  /// No description provided for @symOldLeafCheck.
  ///
  /// In en, this message translates to:
  /// **'Only the bottom one or two leaves yellow, and new growth looks healthy'**
  String get symOldLeafCheck;

  /// No description provided for @symOldLeafFix.
  ///
  /// In en, this message translates to:
  /// **'That\'s normal. Just remove the yellow leaves.'**
  String get symOldLeafFix;

  /// No description provided for @symBrownTips.
  ///
  /// In en, this message translates to:
  /// **'Leaf tips turning brown and crispy'**
  String get symBrownTips;

  /// No description provided for @symDryAirTitle.
  ///
  /// In en, this message translates to:
  /// **'Dry air'**
  String get symDryAirTitle;

  /// No description provided for @symDryAirCheck.
  ///
  /// In en, this message translates to:
  /// **'It\'s heating or AC season, or air blows directly on it'**
  String get symDryAirCheck;

  /// No description provided for @symDryAirFix.
  ///
  /// In en, this message translates to:
  /// **'Keep a humidifier nearby or mist around the leaves. You can trim the dry tips.'**
  String get symDryAirFix;

  /// No description provided for @symSaltTitle.
  ///
  /// In en, this message translates to:
  /// **'Tap water minerals or fertilizer buildup'**
  String get symSaltTitle;

  /// No description provided for @symSaltCheck.
  ///
  /// In en, this message translates to:
  /// **'Tips keep browning even though you water on time'**
  String get symSaltCheck;

  /// No description provided for @symSaltFix.
  ///
  /// In en, this message translates to:
  /// **'Use water that\'s been left out for a day, and pause any fertilizer for a while.'**
  String get symSaltFix;

  /// No description provided for @symDroop.
  ///
  /// In en, this message translates to:
  /// **'Leaves drooping'**
  String get symDroop;

  /// No description provided for @symRootDamageTitle.
  ///
  /// In en, this message translates to:
  /// **'Roots damaged by overwatering'**
  String get symRootDamageTitle;

  /// No description provided for @symRootDamageCheck.
  ///
  /// In en, this message translates to:
  /// **'It droops even though the soil is wet, the base is soft, or the soil smells'**
  String get symRootDamageCheck;

  /// No description provided for @symRootDamageFix.
  ///
  /// In en, this message translates to:
  /// **'Stop watering and let the soil dry. If the base is soft, see \"Stem or base is mushy\" below.'**
  String get symRootDamageFix;

  /// No description provided for @symLeafDrop.
  ///
  /// In en, this message translates to:
  /// **'Leaves suddenly falling off'**
  String get symLeafDrop;

  /// No description provided for @symAdjustingTitle.
  ///
  /// In en, this message translates to:
  /// **'Adjusting to a new spot'**
  String get symAdjustingTitle;

  /// No description provided for @symAdjustingCheck.
  ///
  /// In en, this message translates to:
  /// **'You recently brought it home or moved it (common in rubber plants and weeping figs)'**
  String get symAdjustingCheck;

  /// No description provided for @symAdjustingFix.
  ///
  /// In en, this message translates to:
  /// **'Don\'t move it for 2–3 weeks and watch. New leaves mean it has settled in.'**
  String get symAdjustingFix;

  /// No description provided for @symRot.
  ///
  /// In en, this message translates to:
  /// **'Stem or base is mushy'**
  String get symRot;

  /// No description provided for @symRootRotTitle.
  ///
  /// In en, this message translates to:
  /// **'Root rot (long-term overwatering)'**
  String get symRootRotTitle;

  /// No description provided for @symRootRotCheck.
  ///
  /// In en, this message translates to:
  /// **'The base is dark and soft, and the soil smells musty'**
  String get symRootRotCheck;

  /// No description provided for @symRootRotFix.
  ///
  /// In en, this message translates to:
  /// **'Unpot it, cut away black mushy roots and replant in fresh dry soil. Water sparingly for a while. If severe, root a healthy cutting in water.'**
  String get symRootRotFix;

  /// No description provided for @symSpots.
  ///
  /// In en, this message translates to:
  /// **'Brown or black spots on leaves'**
  String get symSpots;

  /// No description provided for @symSunburnTitle.
  ///
  /// In en, this message translates to:
  /// **'Sunburn'**
  String get symSunburnTitle;

  /// No description provided for @symSunburnCheck.
  ///
  /// In en, this message translates to:
  /// **'Leaves facing the sun have dry, crispy brown patches'**
  String get symSunburnCheck;

  /// No description provided for @symSunburnFix.
  ///
  /// In en, this message translates to:
  /// **'Move it behind a curtain. The burn marks won\'t fade, but new leaves will be fine.'**
  String get symSunburnFix;

  /// No description provided for @symLeafSpotTitle.
  ///
  /// In en, this message translates to:
  /// **'Fungal or bacterial leaf spot'**
  String get symLeafSpotTitle;

  /// No description provided for @symLeafSpotCheck.
  ///
  /// In en, this message translates to:
  /// **'Wet-looking spots with yellow halos that keep spreading'**
  String get symLeafSpotCheck;

  /// No description provided for @symLeafSpotFix.
  ///
  /// In en, this message translates to:
  /// **'Remove spotted leaves and improve airflow so leaves don\'t stay wet.'**
  String get symLeafSpotFix;

  /// No description provided for @symMealybug.
  ///
  /// In en, this message translates to:
  /// **'White cottony bugs or sticky leaves'**
  String get symMealybug;

  /// No description provided for @symMealybugTitle.
  ///
  /// In en, this message translates to:
  /// **'Mealybugs or scale'**
  String get symMealybugTitle;

  /// No description provided for @symMealybugCheck.
  ///
  /// In en, this message translates to:
  /// **'White cottony clumps or brown shells in leaf joints or undersides, and sticky leaves'**
  String get symMealybugCheck;

  /// No description provided for @symMealybugFix.
  ///
  /// In en, this message translates to:
  /// **'Wipe them off with a wet wipe or cotton swab and isolate the plant. If they return, use a houseplant insecticide.'**
  String get symMealybugFix;

  /// No description provided for @symSpiderMite.
  ///
  /// In en, this message translates to:
  /// **'Webbing or tiny dots under leaves'**
  String get symSpiderMite;

  /// No description provided for @symSpiderMiteTitle.
  ///
  /// In en, this message translates to:
  /// **'Spider mites'**
  String get symSpiderMiteTitle;

  /// No description provided for @symSpiderMiteCheck.
  ///
  /// In en, this message translates to:
  /// **'Fine pale speckles on leaves and thin webbing underneath. Common in dry air.'**
  String get symSpiderMiteCheck;

  /// No description provided for @symSpiderMiteFix.
  ///
  /// In en, this message translates to:
  /// **'Rinse both sides of the leaves in the shower and raise humidity. If it recurs, use a miticide.'**
  String get symSpiderMiteFix;

  /// No description provided for @symGnat.
  ///
  /// In en, this message translates to:
  /// **'Tiny flies around the pot'**
  String get symGnat;

  /// No description provided for @symGnatTitle.
  ///
  /// In en, this message translates to:
  /// **'Fungus gnats (soil stays wet too long)'**
  String get symGnatTitle;

  /// No description provided for @symGnatCheck.
  ///
  /// In en, this message translates to:
  /// **'Small dark flies hover over or around the soil'**
  String get symGnatCheck;

  /// No description provided for @symGnatFix.
  ///
  /// In en, this message translates to:
  /// **'Let the topsoil dry out and add yellow sticky traps. Watering a little less often helps.'**
  String get symGnatFix;

  /// No description provided for @symLeggy.
  ///
  /// In en, this message translates to:
  /// **'Only the stems grow long'**
  String get symLeggy;

  /// No description provided for @symLeggyTitle.
  ///
  /// In en, this message translates to:
  /// **'Not enough light (leggy growth)'**
  String get symLeggyTitle;

  /// No description provided for @symLeggyCheck.
  ///
  /// In en, this message translates to:
  /// **'Gaps between leaves widen and stems lean toward the window'**
  String get symLeggyCheck;

  /// No description provided for @symLeggyFix.
  ///
  /// In en, this message translates to:
  /// **'Move it somewhere brighter and trim leggy stems. Rotate the pot now and then for even growth.'**
  String get symLeggyFix;

  /// No description provided for @symMold.
  ///
  /// In en, this message translates to:
  /// **'White mold on the soil'**
  String get symMold;

  /// No description provided for @symMoldTitle.
  ///
  /// In en, this message translates to:
  /// **'Poor airflow or overwatering'**
  String get symMoldTitle;

  /// No description provided for @symMoldCheck.
  ///
  /// In en, this message translates to:
  /// **'White threads or fuzz on the soil surface'**
  String get symMoldCheck;

  /// No description provided for @symMoldFix.
  ///
  /// In en, this message translates to:
  /// **'Scrape off the moldy topsoil and keep it somewhere airy. It\'s usually harmless to the plant.'**
  String get symMoldFix;

  /// No description provided for @symNoGrowth.
  ///
  /// In en, this message translates to:
  /// **'No new leaves'**
  String get symNoGrowth;

  /// No description provided for @symDormantTitle.
  ///
  /// In en, this message translates to:
  /// **'Winter dormancy'**
  String get symDormantTitle;

  /// No description provided for @symDormantCheck.
  ///
  /// In en, this message translates to:
  /// **'It\'s the cold season'**
  String get symDormantCheck;

  /// No description provided for @symDormantFix.
  ///
  /// In en, this message translates to:
  /// **'That\'s normal — growth resumes in spring. Water a little less in winter.'**
  String get symDormantFix;

  /// No description provided for @symPotboundTitle.
  ///
  /// In en, this message translates to:
  /// **'Outgrown its pot'**
  String get symPotboundTitle;

  /// No description provided for @symPotboundCheck.
  ///
  /// In en, this message translates to:
  /// **'Roots poke out of the drainage hole, or water runs straight through'**
  String get symPotboundCheck;

  /// No description provided for @symPotboundFix.
  ///
  /// In en, this message translates to:
  /// **'Repot into a pot one size larger in spring'**
  String get symPotboundFix;

  /// No description provided for @myTitle.
  ///
  /// In en, this message translates to:
  /// **'My'**
  String get myTitle;

  /// No description provided for @myStatWaterings.
  ///
  /// In en, this message translates to:
  /// **'Waterings\nthis month'**
  String get myStatWaterings;

  /// No description provided for @myStatDiary.
  ///
  /// In en, this message translates to:
  /// **'Diary'**
  String get myStatDiary;

  /// No description provided for @myStatStreak.
  ///
  /// In en, this message translates to:
  /// **'Day streak'**
  String get myStatStreak;

  /// No description provided for @mySectionNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get mySectionNotifications;

  /// No description provided for @myNotifyTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder time'**
  String get myNotifyTime;

  /// No description provided for @myNotifyTiming.
  ///
  /// In en, this message translates to:
  /// **'When to remind'**
  String get myNotifyTiming;

  /// No description provided for @myNotifyDayBefore.
  ///
  /// In en, this message translates to:
  /// **'Day before'**
  String get myNotifyDayBefore;

  /// No description provided for @myNotifySameDay.
  ///
  /// In en, this message translates to:
  /// **'Same day'**
  String get myNotifySameDay;

  /// No description provided for @myPause.
  ///
  /// In en, this message translates to:
  /// **'Pause reminders'**
  String get myPause;

  /// No description provided for @myPauseOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get myPauseOff;

  /// No description provided for @myPauseUntil.
  ///
  /// In en, this message translates to:
  /// **'Until {date}'**
  String myPauseUntil(String date);

  /// No description provided for @myNotifyDays.
  ///
  /// In en, this message translates to:
  /// **'Reminder days'**
  String get myNotifyDays;

  /// No description provided for @myEveryDay.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get myEveryDay;

  /// No description provided for @mySkipDays.
  ///
  /// In en, this message translates to:
  /// **'Except {days}'**
  String mySkipDays(String days);

  /// No description provided for @mySectionData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get mySectionData;

  /// No description provided for @myBackup.
  ///
  /// In en, this message translates to:
  /// **'Export & import records'**
  String get myBackup;

  /// No description provided for @myBackupValue.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get myBackupValue;

  /// No description provided for @myRequestSpecies.
  ///
  /// In en, this message translates to:
  /// **'Request a species'**
  String get myRequestSpecies;

  /// No description provided for @myDebugNotify.
  ///
  /// In en, this message translates to:
  /// **'(Dev) Notify in 10 s'**
  String get myDebugNotify;

  /// No description provided for @myDebugTest.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get myDebugTest;

  /// No description provided for @mySectionInfo.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get mySectionInfo;

  /// No description provided for @myTermsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Terms & privacy policy'**
  String get myTermsPrivacy;

  /// No description provided for @myPhotoCredits.
  ///
  /// In en, this message translates to:
  /// **'Catalog photo credits'**
  String get myPhotoCredits;

  /// No description provided for @myContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get myContact;

  /// No description provided for @myVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get myVersion;

  /// No description provided for @myLocalOnly.
  ///
  /// In en, this message translates to:
  /// **'Records are stored only on this device. Phone backups (Google/iCloud) include them; to move photos too, use export.'**
  String get myLocalOnly;

  /// No description provided for @myNotifyTimeHelp.
  ///
  /// In en, this message translates to:
  /// **'Watering reminder time'**
  String get myNotifyTimeHelp;

  /// No description provided for @mySkipDaysTitle.
  ///
  /// In en, this message translates to:
  /// **'Days without reminders'**
  String get mySkipDaysTitle;

  /// No description provided for @mySkipAllWarning.
  ///
  /// In en, this message translates to:
  /// **'If you exclude every day, you won\'t get reminders'**
  String get mySkipAllWarning;

  /// No description provided for @pauseHelp.
  ///
  /// In en, this message translates to:
  /// **'Pause reminders until this date'**
  String get pauseHelp;

  /// No description provided for @pauseTitle.
  ///
  /// In en, this message translates to:
  /// **'Pause reminders'**
  String get pauseTitle;

  /// No description provided for @pauseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pause reminders while you\'re traveling or away'**
  String get pauseSubtitle;

  /// No description provided for @pauseDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String pauseDays(int count);

  /// No description provided for @pauseOneWeek.
  ///
  /// In en, this message translates to:
  /// **'1 week'**
  String get pauseOneWeek;

  /// No description provided for @pauseTwoWeeks.
  ///
  /// In en, this message translates to:
  /// **'2 weeks'**
  String get pauseTwoWeeks;

  /// No description provided for @pauseUntilDate.
  ///
  /// In en, this message translates to:
  /// **'Until {date}'**
  String pauseUntilDate(String date);

  /// No description provided for @pauseNoneDue.
  ///
  /// In en, this message translates to:
  /// **'No plants need water until {date}'**
  String pauseNoneDue(String date);

  /// No description provided for @pauseWaterBefore.
  ///
  /// In en, this message translates to:
  /// **'Water these before you leave: {names}'**
  String pauseWaterBefore(String names);

  /// No description provided for @pausePickPeriod.
  ///
  /// In en, this message translates to:
  /// **'Choose a period'**
  String get pausePickPeriod;

  /// No description provided for @pauseConfirm.
  ///
  /// In en, this message translates to:
  /// **'Pause until {date}'**
  String pauseConfirm(String date);

  /// No description provided for @pauseResume.
  ///
  /// In en, this message translates to:
  /// **'Turn reminders back on'**
  String get pauseResume;

  /// No description provided for @creditsTitle.
  ///
  /// In en, this message translates to:
  /// **'Catalog photo credits'**
  String get creditsTitle;

  /// No description provided for @creditsIntro.
  ///
  /// In en, this message translates to:
  /// **'Catalog photos are freely licensed images from Wikimedia Commons. The author, license and source of each photo are listed below.'**
  String get creditsIntro;

  /// No description provided for @backupShareSubject.
  ///
  /// In en, this message translates to:
  /// **'Jaljarara records backup'**
  String get backupShareSubject;

  /// No description provided for @backupShareText.
  ///
  /// In en, this message translates to:
  /// **'This is a Jaljarara backup file. Restore it on a new phone from My › Export & import records.'**
  String get backupShareText;

  /// No description provided for @backupExported.
  ///
  /// In en, this message translates to:
  /// **'File created. Send it somewhere safe.'**
  String get backupExported;

  /// No description provided for @backupExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String backupExportFailed(String error);

  /// No description provided for @backupNotOurs.
  ///
  /// In en, this message translates to:
  /// **'This isn\'t a Jaljarara backup file'**
  String get backupNotOurs;

  /// No description provided for @backupImportQ.
  ///
  /// In en, this message translates to:
  /// **'Import these records?'**
  String get backupImportQ;

  /// No description provided for @backupImportSummary.
  ///
  /// In en, this message translates to:
  /// **'Exported on {date}.\n{plants} plants · {diaries} diary entries · {photos} photos\n\nAll records on this phone will be replaced with this file.'**
  String backupImportSummary(String date, int plants, int diaries, int photos);

  /// No description provided for @backupImport.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get backupImport;

  /// No description provided for @backupImported.
  ///
  /// In en, this message translates to:
  /// **'Imported. Check your home screen.'**
  String get backupImported;

  /// No description provided for @backupImportFailed.
  ///
  /// In en, this message translates to:
  /// **'Import failed: {error}'**
  String backupImportFailed(String error);

  /// No description provided for @backupTitle.
  ///
  /// In en, this message translates to:
  /// **'Export & import records'**
  String get backupTitle;

  /// No description provided for @backupExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get backupExport;

  /// No description provided for @backupExportBody.
  ///
  /// In en, this message translates to:
  /// **'Bundles your plants, watering history, diary and photos into one file. Keep it anywhere — email, Google Drive, a chat with yourself.'**
  String get backupExportBody;

  /// No description provided for @backupExportButton.
  ///
  /// In en, this message translates to:
  /// **'Create and send file'**
  String get backupExportButton;

  /// No description provided for @backupImportBody.
  ///
  /// In en, this message translates to:
  /// **'On a new phone, choose the exported file to restore everything. Records currently on this phone will be replaced.'**
  String get backupImportBody;

  /// No description provided for @backupImportButton.
  ///
  /// In en, this message translates to:
  /// **'Choose file to import'**
  String get backupImportButton;

  /// No description provided for @backupNote.
  ///
  /// In en, this message translates to:
  /// **'Tip: with phone backup (Google or iCloud) turned on, your records move to a new phone automatically. Android auto backup doesn\'t include photos, so use export to move them.'**
  String get backupNote;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
