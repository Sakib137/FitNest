# 🏋️‍♂️ FitNest - Smart Fitness & Nutrition Companion

[![iOS Version](https://img.shields.io/badge/iOS-18.2%2B-blue.svg?style=flat&logo=apple)](https://developer.apple.com/ios/)
[![Swift Version](https://img.shields.io/badge/Swift-5.9%2B-orange.svg?style=flat&logo=swift)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-cyan.svg?style=flat&logo=swift)](https://developer.apple.com/xcode/swiftui/)
[![Language](https://img.shields.io/badge/Languages-English%20%7C%20বাংলা-green.svg)](#-bilingual-support-english--বাংলা)
[![License](https://img.shields.io/badge/License-MIT-lightgrey.svg)](LICENSE)

**FitNest** is a modern, personalized fitness and nutrition iOS application crafted with SwiftUI. It empowers users to achieve their wellness goals through curated workout routines, an interactive voice-guided workout player, smart habit & streak reminders, and a tailored nutrition tracker featuring an extensive **Bangladeshi & South Asian food database** with full **English and Bengali (বাংলা)** bilingual support.

---

## 📱 Key Features

### 🏋️ 1. Comprehensive Workouts & Guided Session Player
- **Extensive Library**: Diverse workouts ranging from HIIT, Strength Training, Cardio, Core, to Flexibility and Yoga.
- **Smart Filters**: Filter routines quickly by **Duration** (*<10m, 10-20m, >20m*), **Equipment** (*None, Basic, Gym*), and **Intensity** (*Low, Medium, High*).
- **Interactive Workout Player**:
  - Step-by-step exercise guides with real-time countdown timers and circular progress meters.
  - **Audio Guidance**: Spoken voice cues powered by `AVSpeechSynthesizer` to coach you through exercises and rest intervals.
  - Exercise navigation (Pause, Resume, Next, Previous, and Rest Timers).
- **Celebration Screen**: Summary view celebrating completed workouts, calories burned, and duration.

### 🥗 2. Nutrition & Localized Calorie Counter
- **Goal-Driven Nutrition Plans**: Tailored meal plans for *Weight Loss*, *Muscle Building*, *Staying Active*, and *Flexibility*.
- **Bangladeshi & South Asian Food Database**: Searchable calorie and macronutrient directory for local foods (e.g., Bhuna Khichuri, Shorshe Ilish, Roti, Dal, Pitha, Singara, Doi, fresh fruits).
- **Meal Schedule & Tracking**: Structured breakfast, lunch, snack, and dinner meal scheduling.
- **Custom Food Entries**: Easily add custom food items with custom portion sizes and calories.
- **Healthy Food Swaps & Tips**: Evidence-based healthy eating tips and ingredient alternatives in English and Bengali.

### 🌐 3. Bilingual Support (English & বাংলা)
- **Instant Language Switching**: Toggle between English and Bengali (বাংলা) across the entire application with a single tap.
- **Culturally Tailored Content**: Translated workout instructions, nutrition advice, notifications, and onboarding flows.

### 🔔 4. Smart Notifications & Habit Streaks
- **Intelligent Habit Reminders**: Configurable morning, evening, and gentle nightly workout reminders.
- **Streak Tracking**: Automatically counts active daily streaks and celebrates milestone achievements (3-day, 7-day, 30-day streaks).
- **Resilient Authorization**: Multi-stage permission handling with fallback support and in-app diagnostics.

### 👤 5. Personalized Profile & Goal Tracking
- **Personalized Onboarding**: Profile setup collecting age, height, weight, gender, city, and fitness objectives.
- **BMI Calculation & Insights**: Live BMI updates with categorization and target guidance.
- **Custom Profile Photos**: Photo picker integration using `PhotosUI`.
- **Achievements & Badges**: Unlock milestones and view lifetime statistics.

---

## 🛠️ Architecture & Tech Stack

- **Framework**: [SwiftUI](https://developer.apple.com/xcode/swiftui/) (Declarative UI)
- **Target Platform**: iOS 18.2+ / iPadOS 18.2+
- **Architecture Pattern**: MVVM (Model-View-ViewModel) + State Management using `@EnvironmentObject` and `@StateObject`
- **Audio & Speech**: `AVFoundation` (`AVSpeechSynthesizer`) for workout audio coaching
- **Notifications**: `UserNotifications` (`UNUserNotificationCenter`) for scheduled local alerts
- **Photo Selection**: `PhotosUI` (`PhotosPicker`)
- **Persistence**: `UserDefaults` for local user preferences, streaks, and profile state

---

## 📂 Project Structure

```text
FitNest/
├── FitNestApp.swift                 # App entry point & notification initialization
├── ContentView.swift                # Root navigation & authentication state router
├── Models/
│   ├── AuthenticationManager.swift  # User session, profile data & streak logic
│   ├── MealData.swift               # Fitness goals, meal schedules & Bangladeshi food database
│   └── Language.swift               # Bilingual localization enum (EN / BN)
├── Views/
│   ├── SplashView.swift             # App splash screen & welcome flow
│   ├── OnboardingView.swift         # Feature onboarding carousel
│   ├── SimpleUserInfoView.swift     # Initial user registration / sign-in
│   ├── UserProfileSetupView.swift   # Step-by-step profile & physical metrics setup
│   ├── MainTabView.swift            # 5-tab navigation container
│   ├── HomeView.swift               # Daily dashboard, streak tracker & quick workouts
│   ├── WorkoutsLibraryView.swift    # Searchable & filterable workout catalog
│   ├── WorkoutDetailView.swift      # Workout overview, equipment & exercise list
│   ├── WorkoutSessionView.swift     # Active workout player with audio cues & timer
│   ├── WorkoutCompleteView.swift    # Post-workout accomplishment screen
│   ├── NutritionView.swift          # Nutrition plans & daily meal schedules
│   ├── CalorieCounterView.swift     # Bangladeshi food calorie search & tracker
│   ├── HealthyTipsView.swift        # Curated diet tips & healthy food swaps
│   ├── ProfileView.swift            # Profile management, stats, achievements & settings
│   ├── NotificationSettingsView.swift # Notification preferences & test triggers
│   └── NotificationManager.swift    # Notification scheduling & permission engine
├── Assets.xcassets                  # App icons, colors, and graphics
└── Preview Content/                 # Xcode SwiftUI previews & sample data
```

---

## 🚀 Getting Started

### Prerequisites
- macOS Sonoma 14.5 or later (macOS Sequoia recommended)
- [Xcode 16.0+](https://developer.apple.com/xcode/)
- iOS 18.2+ Simulator or physical device

### Installation & Running

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Sakib137/FitNest.git
   cd FitNest
   ```

2. **Open the project in Xcode**:
   ```bash
   open FitNest.xcodeproj
   ```

3. **Select a Target & Destination**:
   - In Xcode's top toolbar, select the `FitNest` scheme.
   - Choose an iOS Simulator (e.g., *iPhone 16 Pro*) or your connected physical iOS device.

4. **Build and Run**:
   - Press `Cmd + R` or click the **Play** button in Xcode.

---

## 🔒 Permissions & Configuration

FitNest utilizes the following iOS capabilities:
- **Notifications (`UNUserNotificationCenter`)**: To send reminders for planned workout times and streak milestones.
- **Photos Library (`PhotosUI`)**: Allows selecting a custom avatar for user profiles.
- **Speech Synthesis (`AVSpeechSynthesizer`)**: Audio coaching during workout sessions.

---

## 🔮 Roadmap

- [ ] **HealthKit Integration**: Sync active energy burned, step count, and workouts with Apple Health.
- [ ] **Community & Social Feed**: Share workout milestones, challenge friends, and view community leaderboards.
- [ ] **WatchOS Companion App**: Apple Watch standalone workout tracking and heart rate monitoring.
- [ ] **Cloud Sync & Backup**: CloudKit / Firebase multi-device data synchronization.

---

## 👨‍💻 Author

**Md Sakib Al Hasan**  
- GitHub: [@Sakib137](https://github.com/Sakib137)

---

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
