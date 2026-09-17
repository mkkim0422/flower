# Store listing draft — English (Play Store · App Store)

> Draft. The global app name is not decided yet. "Jaljarara" is a placeholder.

## Common

- App name: **Jaljarara** (placeholder, to be confirmed)
- Subtitle (App Store, 30 chars): Plant watering reminders
- Short description (Play, 80 chars): Snap a photo to find your plant, and never miss a watering day. No login, no ads.
- Category: Lifestyle
- Content rating: Everyone / 4+
- Privacy policy URL: (GitHub Pages) https://<account>.github.io/jaljarara/privacy_policy_en
- Price: Free. No in-app purchases. No ads.
- Localizations: English (default for every language except Korean), Korean

## Full description

Can't remember when you last watered your plants? Jaljarara does exactly that, and nothing more.

**Find your plant with a photo**
Take a photo of the leaves or flowers and see which plant it is likely to be. Add up to 5 photos for a better match. You can also search by name, or just give it a nickname.

**Watering countdown**
Each plant shows how many days are left until it needs water, adjusted for species and season (southern hemisphere seasons included). Watered it? Tap "Watered" once and the next date is set.

**Reminders you can act on**
Get one reminder that names your plants. Tap "Watered" or "Tomorrow" right from the notification. Going on a trip? Pause reminders and see which plants to water before you leave.

**Something looks wrong?**
Yellow leaves, drooping, brown tips. Pick the symptom and get the likely causes and what to do.

**Good to know**
Light, temperature (°C or °F by region) and common problems for 540+ popular houseplants. Plants that are truly dangerous to pets or children are clearly marked, with the reason.

**No login. No ads.**
Your records stay on your device. Export them to a file when you switch phones.

## Screenshots (6.7-inch, 5–6 images, English UI)

1. Home — photo cards with watering countdown
2. Identification results — candidate list
3. Plant details — countdown, memo, good to know
4. Notification with "Watered" and "Tomorrow" buttons
5. Symptom finder
6. Catalog page — pet/child danger badge

## Store-specific items

### Google Play
- Data safety: no data collected. Photos sent to Pl@ntNet for identification are processed ephemerally and not stored by the developer (privacy policy 2-1).
- Advertising ID: No
- Account deletion URL: not applicable (no accounts)

### App Store
- App Privacy: "Data Not Collected"
- Export compliance: `ITSAppUsesNonExemptEncryption=false` (already in Info.plist)
- Review notes: include a test plant photo. The Pl@ntNet API key is included in the review build.
- Localized display name and permission texts: `ios/Runner/en.lproj`, `ko.lproj` `InfoPlist.strings`

## Before release (global)

- [ ] Decide the global app name, then update `android/app/src/main/res/values/strings.xml`, `ios/Runner/en.lproj/InfoPlist.strings`, Info.plist and the `appName` string in `lib/l10n`
- [ ] Publish the English privacy policy and fill in the URL
- [ ] Rotate the Pl@ntNet API key before release
- [ ] English screenshots
