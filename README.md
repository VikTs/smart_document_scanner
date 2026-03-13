# Smart documents scanner

![Flutter](https://img.shields.io/badge/Flutter-3.38-blue)
![Dart](https://img.shields.io/badge/Dart-3.10-blue)

Mobile application for scanning and storing the documents. 

# Features
- Scan an image or uploap it from the gallery 
- View a list of the scanned documents
- Open the full screen document

# Technologies
- Flutter for UI
- State Management: Bloc
- Database: Drift (local storage)
- Localization: easy_localization (translations in assets/translations)
- Text recognision: google_mlkit_text_recognition (text extractors in core/extractors)

# Getting started
## Prerequisites

- [Flutter >= 3.38](https://docs.flutter.dev/install)
- [Dart >= 3.10](https://dart.dev/get-dart)

## Installation and launching

1. Clone the repo
```bash
git clone https://github.com/VikTs/smart_document_scanner
cd smart_document_scanner
```
2. Install dependencies
```bash
flutter pub get
dart run build_runner build
```
3. Connect device and run the application
```bash
flutter run
```

## Testing data
The application was tested with the images from **assets/images/test** folder.
They can be uploaded to the device's gallery and used for testing.

## Running tests
Tests are stored inside /test folder. To run them, launch the command:

```bash
flutter test
```

## Building Android app

```bash
flutter build apk --release
```

The apk file will be saved to build/app/outputs/flutter-apk folder
