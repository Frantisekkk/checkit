# Checkit - Flutter iOS App

The iOS application for Checkit, featuring a native share extension for analyzing videos shared from other apps.

---

## 📱 Overview

Checkit is an iOS app that integrates with the native iOS share menu, allowing users to analyze videos from social media platforms (Instagram, TikTok, YouTube) without leaving their current app.

### Key Components

1. **Main App** (`lib/main.dart`) - Welcome screen with instructions
2. **Share Extension** (`ios/MyAppShareExtension/`) - Native iOS share extension for video analysis

---

## 🎨 Features

### Main App
- ✅ Clean, minimal welcome screen
- ✅ iOS-style dark mode design
- ✅ Step-by-step usage instructions
- ✅ SF Pro Text font (native iOS look)

### Share Extension
- ✅ Captures shared video URLs
- ✅ Three analysis options:
  - 🛡️ **Hoax Check** - Verify authenticity
  - 💡 **Get Info** - Detailed explanations
  - 🌟 **Clarification** - Explore deeper insights
- ✅ Real-time backend communication
- ✅ Beautiful loading states
- ✅ Error handling
- ✅ iOS-native UI components

---

## 🚀 Setup

### Prerequisites

- macOS 14.0+ (Sonoma or later)
- Xcode 15.0+
- Flutter SDK 3.0+
- CocoaPods (for iOS dependencies)

### Installation

1. **Install Flutter dependencies:**
   ```bash
   flutter pub get
   ```

2. **Install iOS dependencies:**
   ```bash
   cd ios
   pod install
   cd ..
   ```

3. **Configure backend URL:**
   - Open `ios/MyAppShareExtension/ShareViewController.swift`
   - Update the `backendUrl` constant:
     ```swift
     private let backendUrl = "http://YOUR_BACKEND_URL:8000"
     ```
   - For iOS Simulator: `http://localhost:8000`
   - For iOS Device (testing with local backend): Use your Mac's IP address, e.g., `http://192.168.1.100:8000`
   - For production: Use your deployed backend URL

4. **Run the app:**
   ```bash
   flutter run
   ```

---

## 📦 Project Structure

```
flutter_app/
├── lib/
│   └── main.dart                          # Main app UI
│
├── ios/
│   ├── Runner/                            # Main iOS app
│   │   ├── AppDelegate.swift
│   │   └── Info.plist
│   │
│   └── MyAppShareExtension/               # Share Extension
│       ├── ShareViewController.swift      # Extension logic & UI
│       ├── Info.plist                     # Extension configuration
│       └── Base.lproj/
│           └── MainInterface.storyboard   # Extension UI layout
│
├── pubspec.yaml                           # Flutter dependencies
└── README.md                              # This file
```

---

## 🔧 Configuration

### Backend Connection

The share extension connects to the backend API. Configure the URL in `ShareViewController.swift`:

```swift
private let backendUrl = "http://localhost:8000"  // Change this
```

**Important:** 
- iOS Simulator can use `localhost`
- Physical iOS devices need your Mac's IP address or deployed backend URL
- Make sure the backend is running before testing

### App Bundle Identifier

To build for a real device, you'll need to:

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select the Runner project
3. Update the Bundle Identifier (e.g., `com.yourcompany.checkit`)
4. Select your development team
5. Do the same for the MyAppShareExtension target

---

## 🧪 Testing

### Testing on iOS Simulator

1. Start the backend server (see `backend/README.md`)
2. Run the Flutter app:
   ```bash
   flutter run
   ```
3. Open Safari on the simulator
4. Navigate to any YouTube video
5. Tap the Share button
6. Select "Checkit" from the share menu
7. Choose an analysis option

### Testing on iOS Device

1. Ensure your device and Mac are on the same network
2. Update `backendUrl` in `ShareViewController.swift` to your Mac's IP
3. Build and run from Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```
4. Open Instagram, TikTok, or YouTube
5. Share any video and select Checkit

### Testing Without External Apps

Currently, the main app displays usage instructions. To test the share extension:
- Use Safari, Instagram, TikTok, or YouTube
- Share any video content
- Select Checkit from the share menu

---

## 📱 iOS Share Extension Details

### How It Works

1. **User shares a video** from any app
2. **iOS presents the share sheet** with available extensions
3. **User selects Checkit**
4. **Share extension launches** and extracts the URL
5. **Extension displays analysis options**
6. **User selects an option**
7. **Extension sends request to backend**
8. **Results are displayed** in the extension
9. **User can dismiss** to return to the original app

### Supported URL Schemes

The extension is configured to accept:
- `public.url` - Web URLs
- `public.text` - Text containing URLs
- `public.plain-text` - Plain text

It works with:
- ✅ Instagram posts and reels
- ✅ TikTok videos
- ✅ YouTube videos
- ✅ Any web video URLs

---

## 🎨 Design

### Color Scheme

- **Background**: Black (`#000000`)
- **Surface**: Dark Gray (`#1C1C1E`)
- **Text**: White (`#FFFFFF`)
- **Secondary Text**: Gray (`#8E8E93`)
- **Divider**: Subtle Gray (`#38383A`)

### Typography

- **Display**: SF Pro Display (34pt, bold)
- **Body**: SF Pro Text (17pt)
- **Caption**: SF Pro Text (15pt)

### Icons

Using iOS-style SF Symbols:
- 🛡️ Hoax Check: `checkmark.shield`
- 💡 Get Info: `lightbulb`
- 🌟 Clarification: `sparkles`

---

## 🔨 Building for Production

### 1. Update Configuration

- Change bundle identifier
- Update backend URL to production endpoint
- Set up proper code signing

### 2. Build Release Version

```bash
flutter build ios --release
```

### 3. Archive in Xcode

1. Open `ios/Runner.xcworkspace`
2. Select "Any iOS Device" as target
3. Product → Archive
4. Upload to App Store Connect

### 4. App Store Requirements

- Privacy Policy (data handling disclosure)
- App icon (all required sizes)
- Screenshots (various device sizes)
- App description and keywords
- Age rating

---

## 🐛 Troubleshooting

### Share Extension Not Appearing

1. **Check Info.plist** - Ensure `NSExtensionActivationRule` is configured
2. **Rebuild the app** - Clean build folder in Xcode
3. **Restart device** - Sometimes needed after installing

### Backend Connection Issues

1. **Check backend is running:**
   ```bash
   curl http://localhost:8000/health
   ```

2. **Verify URL in ShareViewController.swift**

3. **Check network permissions** - Ensure app has network access

4. **Test from iOS device** - Use Mac's IP address, not localhost

### Build Errors

1. **Clean build folder:**
   ```bash
   flutter clean
   cd ios
   pod deintegrate
   pod install
   cd ..
   flutter pub get
   ```

2. **Update CocoaPods:**
   ```bash
   sudo gem install cocoapods
   ```

3. **Check Xcode version** - Must be 15.0+

---

## 📚 Dependencies

### Flutter Dependencies (`pubspec.yaml`)

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  http: ^1.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

### iOS Dependencies (CocoaPods)

The share extension uses native iOS APIs:
- `UIKit` - UI components
- `Foundation` - Core functionality
- No external CocoaPods required

---

## 🚧 Known Limitations

1. **Currently supports only URLs** - Cannot process uploaded videos
2. **iOS only** - No Android support yet
3. **Backend must be running** - No offline functionality
4. **Simulated responses** - AI integration pending

---

## 🔮 Planned Features

### Short Term
- [ ] Video thumbnail preview
- [ ] Analysis history
- [ ] Custom question input
- [ ] Share results back to social media

### Long Term
- [ ] User accounts and authentication
- [ ] Saved analyses
- [ ] Multiple language support
- [ ] Video download and local processing
- [ ] Android version

---

## 💡 Development Tips

### Hot Reload

The main Flutter app supports hot reload:
```bash
# Press 'r' in terminal for hot reload
# Press 'R' for hot restart
```

**Note:** Share extension requires full rebuild to see changes.

### Debugging Share Extension

1. Run app from Xcode
2. Set breakpoints in `ShareViewController.swift`
3. Share content from another app
4. Xcode will attach debugger

### Testing Backend Changes

Use `curl` to test backend without rebuilding app:
```bash
curl -X POST http://localhost:8000/api/video \
  -H "Content-Type: application/json" \
  -d '{"url":"https://www.youtube.com/watch?v=test"}'
```

---

## 📖 Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [iOS Share Extension Guide](https://developer.apple.com/documentation/uikit/share_extensions)
- [Flutter iOS Deployment](https://docs.flutter.dev/deployment/ios)

---

## 🤝 Contributing

When adding features:

1. **Main App** - Edit `lib/main.dart`
2. **Share Extension** - Edit `ios/MyAppShareExtension/ShareViewController.swift`
3. **iOS Config** - Update `Info.plist` files as needed
4. **Dependencies** - Update `pubspec.yaml` and run `flutter pub get`

---

**Part of the Checkit project for Hackathon 2025 Telcom**
