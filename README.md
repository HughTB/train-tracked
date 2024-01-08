# Train Tracked

A 'better' UK train tracking app. Created as part of a Level 5 Computer Science project at the University of Portsmouth

## Getting Started

### Requirements

- Flutter setup and in your PATH
- The Android SDK if building for Android
- The [Train Tracked API](https://github.com/HughTB/train-tracked-api) setup and running on a publically-accessible server

### Building

- Clone the repository
- Run `flutter pub get` to install dependencies
- Create and configure the `lib/api/api_settings.dart` file, to the settings of your API instance
- Run `flutter build apk` to build for Android
- A built APK will be placed in the `build/app/outputs/flutter-apk/` folder
- The APK is unsigned, but can still be installed if you ignore the Play Protect warning

