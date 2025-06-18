# LearneVerse

LearneVerse is a cross-platform educational app built with Flutter. It provides interactive learning experiences, media content, and user engagement features. The project leverages modern Flutter libraries and best practices for state management, routing, and UI design.

## Features
- Interactive lessons and media (video, audio, documents)
- User authentication and secure storage
- Calendar and scheduling
- Charts and data visualization
- Speech-to-text and audio playback
- Responsive design for mobile and desktop
- Theming and custom fonts

## Tech Stack
- **Framework:** Flutter (Dart)
- **State Management:** Provider, flutter_bloc, bloc
- **Routing:** go_router
- **UI & Animation:** fl_chart, table_calendar, google_fonts, font_awesome_flutter, lottie, simple_animations, syncfusion_flutter_charts, syncfusion_flutter_pdfviewer
- **Media:** video_player, audioplayers, image_picker
- **Storage:** shared_preferences, flutter_secure_storage, path_provider
- **Networking:** http, jwt_decoder
- **Utilities:** url_launcher, cached_network_image, mime, path

## Assets
- Images, videos, audio, and documents are stored in the `assets/` directory and referenced in `pubspec.yaml`.

## Getting Started
1. Install Flutter SDK (see [Flutter docs](https://docs.flutter.dev/get-started/install)).
2. Run `flutter pub get` to install dependencies.
3. Use `flutter run` to launch the app on your device or emulator.

## Development
- Code is organized in the `lib/` directory.
- Main entry point: `lib/main.dart`
- Feature modules: `lib/core/features/`
- Utilities: `lib/core/utils/`

## License
This project is for educational purposes.
