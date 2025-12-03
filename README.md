 # Checkit - AI-Powered Video Analysis Platform

**Hackathon 2025 Telcom Project**

An iOS share extension that enables users to fact-check and analyze videos from social media platforms like Instagram, TikTok, and YouTube directly from the share menu.

---

## 📱 What is Checkit?

Checkit is an intelligent iOS share extension that provides instant AI-powered analysis of social media videos. Instead of opening a separate app, users can simply share a video from any app and get immediate insights through three analysis types:

- **🛡️ Hoax Check** - Verify content authenticity and detect misinformation
- **💡 Get Info** - Receive detailed explanations and context about the video
- **🌟 Clarification** - Explore related concepts and deeper insights

---

## 🏗️ Project Structure

```
hackaton-2025-telcom/
├── flutter_app/           # iOS app with share extension
│   ├── lib/main.dart      # Main app UI
│   ├── ios/               # iOS-specific configuration
│   │   └── MyAppShareExtension/  # Share extension implementation
│   ├── pubspec.yaml       # Flutter dependencies
│   └── README.md          # Flutter app documentation
│
├── n8n/                   # n8n workflow automation
│   ├── n8n_flow.json      # Workflow definition
│   └── README.md          # Workflow documentation
│
└── README.md              # This file
```

---

## 🚀 Quick Start

### Prerequisites

- **iOS Development**: Xcode 15+, macOS 14+
- **Flutter**: Flutter SDK 3.0+
- **n8n** (optional): For workflow automation

### Configure and Run the Flutter App

```bash
cd flutter_app

# Install dependencies
flutter pub get

# Run on iOS simulator
flutter run
```

### Build for iOS Device (Optional)

```bash
cd flutter_app

# Open in Xcode
open ios/Runner.xcworkspace

# In Xcode:
# 1. Select your development team
# 2. Change bundle identifier
# 3. Build and run on your iOS device
```

---

## 📖 How It Works

### User Flow

1. **Share a Video**: From Instagram, TikTok, YouTube, or any video-sharing app
2. **Select Checkit**: Choose Checkit from the iOS share menu
3. **Choose Analysis**: Pick from three analysis options
4. **Get Results**: Receive instant AI-powered insights

### Technical Flow

1. **iOS Share Extension** captures the shared URL
2. **Flutter UI** presents analysis options to the user
3. **n8n Workflow** (optional) orchestrates AI processing
4. **Results** are displayed in the share extension

---

## 🔧 Configuration

### Flutter Configuration

Create a `.env` file from the template:

```bash
cd flutter_app
cp env.example .env
```

---

## 🎯 Features

### iOS Share Extension
- ✅ Native iOS integration
- ✅ Works with Instagram, TikTok, YouTube, and more
- ✅ Clean, modern dark mode UI
- ✅ Real-time communication
- ✅ Error handling and loading states

### n8n Workflow (Optional)
- ✅ Automated video analysis pipeline
- ✅ AI integration (OpenAI, Anthropic, etc.)
- ✅ Webhook-based triggering
- ✅ Extensible workflow design

---

---

## 🧪 Testing

### Test the iOS App

1. Run the app on iOS simulator or device
2. Open Instagram/TikTok/YouTube
3. Find any video and tap "Share"
4. Select "Checkit" from the share menu
5. Choose an analysis option
6. View the results

---

## 🔮 Future Enhancements

### Phase 1 - Core Features ✅
- [x] iOS share extension
- [x] Basic UI/UX
- [x] Three analysis types

### Phase 2 - AI Integration 🚧
- [ ] Real AI video analysis (GPT-4 Vision, Claude, etc.)
- [ ] Video transcript extraction
- [ ] Content understanding and context analysis
- [ ] Fact-checking database integration

### Phase 3 - Advanced Features 🔮
- [ ] User accounts and authentication
- [ ] Analysis history and saved videos
- [ ] Custom prompts and questions
- [ ] Multi-language support
- [ ] Video thumbnail previews
- [ ] Share results to social media

### Phase 4 - Platform Expansion 🌍
- [ ] Android support
- [ ] Web interface
- [ ] Browser extension
- [ ] API for third-party developers

---

## 🛠️ Tech Stack

### Frontend
- **Flutter** 3.0+ - Cross-platform UI framework
- **Swift** - iOS share extension implementation
- **Dart** - Flutter programming language

### Automation (Optional)
- **n8n** - Workflow automation platform
- Integrates with AI APIs (OpenAI, Anthropic, etc.)

---

## 📝 Development Notes

### Current Status
This is a **working prototype** developed for Hackathon 2025 Telcom.

### For Production Deployment

1. **AI Integration**
   - Integrate real AI models (GPT-4 Vision, Claude, etc.)
   - Add video download and processing
   - Implement transcript extraction

2. **Infrastructure**
   - Add database (PostgreSQL, MongoDB)
   - Implement caching (Redis)
   - Set up CDN for media assets

3. **Security**
   - Add authentication (OAuth, JWT)
   - Implement rate limiting
   - Add API key management
   - Enable HTTPS/SSL

4. **Monitoring**
   - Add analytics (Mixpanel, Amplitude)
   - Implement error tracking (Sentry)
   - Set up logging infrastructure

---

## 🤝 Contributing

This project was developed for Hackathon 2025 Telcom. For questions or collaboration:

1. Review the documentation in each component folder
2. Check the API documentation above
3. Test the app following the Quick Start guide
4. Report issues or suggest improvements

---

## 📄 License

Developed for Hackathon 2025 Telcom

---

## 🙏 Acknowledgments

- **Flutter Team** - For the amazing cross-platform framework
- **n8n Team** - For workflow automation capabilities
- **Hackathon 2025 Telcom** - For the opportunity and support

---

## 📞 Support

For setup help or questions:

1. Check component-specific README files:
   - `flutter_app/README.md` - iOS app and share extension
   - `n8n/README.md` - Workflow automation

2. Review example configuration files:
   - `flutter_app/env.example`

---

**Built with ❤️ for Hackathon 2025 Telcom**
