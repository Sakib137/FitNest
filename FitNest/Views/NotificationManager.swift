//
//  NotificationManager.swift
//  FitNest
//
//  Created by Md Sakib Al Hasan on 29/8/25.
//

import Foundation
import UserNotifications
import SwiftUI

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    @Published var notificationsEnabled = true
    @Published var workoutReminders = true
    @Published var streakReminders = true
    @Published var motivationalMessages = true
    @Published var language: NotificationLanguage = .english
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadSettings()
        requestNotificationPermission()
    }
    
    // MARK: - Permission Handling
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                self.notificationsEnabled = granted
                if granted {
                    self.scheduleDefaultNotifications()
                }
            }
        }
    }
    
    // MARK: - Settings Management
    func loadSettings() {
        notificationsEnabled = userDefaults.bool(forKey: "notificationsEnabled")
        workoutReminders = userDefaults.bool(forKey: "workoutReminders")
        streakReminders = userDefaults.bool(forKey: "streakReminders")
        motivationalMessages = userDefaults.bool(forKey: "motivationalMessages")
        
        if let languageRaw = userDefaults.string(forKey: "notificationLanguage") {
            language = NotificationLanguage(rawValue: languageRaw) ?? .english
        }
    }
    
    func saveSettings() {
        userDefaults.set(notificationsEnabled, forKey: "notificationsEnabled")
        userDefaults.set(workoutReminders, forKey: "workoutReminders")
        userDefaults.set(streakReminders, forKey: "streakReminders")
        userDefaults.set(motivationalMessages, forKey: "motivationalMessages")
        userDefaults.set(language.rawValue, forKey: "notificationLanguage")
        
        if notificationsEnabled {
            scheduleDefaultNotifications()
        } else {
            cancelAllNotifications()
        }
    }
    
    // MARK: - Notification Scheduling
    func scheduleDefaultNotifications() {
        cancelAllNotifications()
        
        if workoutReminders {
            scheduleDailyWorkoutReminders()
        }
        
        if streakReminders {
            scheduleStreakReminders()
        }
        
        if motivationalMessages {
            scheduleMotivationalMessages()
        }
    }
    
    private func scheduleDailyWorkoutReminders() {
        // Morning reminder
        scheduleNotification(
            identifier: "morning_workout",
            title: language == .english ? "Good Morning! 🌅" : "সুপ্রভাত! 🌅",
            body: language == .english ? 
                "Start your day with energy! Time for your morning workout 💪" :
                "শক্তি দিয়ে দিন শুরু করুন! সকালের ওয়ার্কআউটের সময় 💪",
            hour: 7,
            minute: 0
        )
        
        // Evening reminder
        scheduleNotification(
            identifier: "evening_workout",
            title: language == .english ? "Evening Workout Time! 🌆" : "সন্ধ্যার ওয়ার্কআউট! 🌆",
            body: language == .english ? 
                "It's 7 PM – Time for your Evening Workout 💪" :
                "রাত ৭টা – আপনার সন্ধ্যার ওয়ার্কআউটের সময় 💪",
            hour: 19,
            minute: 0
        )
        
        // Gentle reminder if missed
        scheduleNotification(
            identifier: "gentle_reminder",
            title: language == .english ? "Don't Forget! 🔔" : "ভুলে যাবেন না! 🔔",
            body: language == .english ? 
                "Even 5 minutes of exercise makes a difference! 🏃‍♂️" :
                "মাত্র ৫ মিনিট ব্যায়ামও পার্থক্য তৈরি করে! 🏃‍♂️",
            hour: 21,
            minute: 0
        )
    }
    
    private func scheduleStreakReminders() {
        // Streak motivation (scheduled for different times)
        let streakMessages = getStreakMessages()
        
        for (index, message) in streakMessages.enumerated() {
            scheduleNotification(
                identifier: "streak_\(index)",
                title: message.title,
                body: message.body,
                hour: 18 + index, // Different hours for variety
                minute: 30
            )
        }
    }
    
    private func scheduleMotivationalMessages() {
        let motivationalMessages = getMotivationalMessages()
        
        for (index, message) in motivationalMessages.enumerated() {
            scheduleNotification(
                identifier: "motivation_\(index)",
                title: message.title,
                body: message.body,
                hour: 10 + (index * 2), // Spread throughout the day
                minute: 0
            )
        }
    }
    
    private func scheduleNotification(identifier: String, title: String, body: String, hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 1
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Dynamic Notifications
    func sendStreakNotification(streakCount: Int) {
        guard notificationsEnabled && streakReminders else { return }
        
        let content = UNMutableNotificationContent()
        
        if streakCount >= 7 {
            content.title = language == .english ? "🔥 AMAZING STREAK! 🔥" : "🔥 অসাধারণ স্ট্রিক! 🔥"
            content.body = language == .english ? 
                "Day \(streakCount) in a row! You're unstoppable! 💪" :
                "পরপর \(streakCount) দিন! আপনি অপ্রতিরোধ্য! 💪"
        } else {
            content.title = language == .english ? "🔥 Keep Going! 🔥" : "🔥 চালিয়ে যান! 🔥"
            content.body = language == .english ? 
                "Day \(streakCount) in a row! Don't break your streak 🔥" :
                "পরপর \(streakCount) দিন! আপনার স্ট্রিক ভাঙবেন না 🔥"
        }
        
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "streak_achievement_\(Date().timeIntervalSince1970)",
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func sendCalorieNotification(caloriesBurned: Int, period: String) {
        guard notificationsEnabled && motivationalMessages else { return }
        
        let content = UNMutableNotificationContent()
        let biryaniEquivalent = caloriesBurned / 250 // Approximate calories in a plate of biryani
        
        content.title = language == .english ? "🍛 Calorie Achievement! 🍛" : "🍛 ক্যালোরি অর্জন! 🍛"
        
        if biryaniEquivalent >= 1 {
            content.body = language == .english ? 
                "You burned \(caloriesBurned) calories this \(period) – that's \(biryaniEquivalent) plates of biryani! 🍛" :
                "আপনি এই \(period) \(caloriesBurned) ক্যালোরি পুড়িয়েছেন – এটা \(biryaniEquivalent) প্লেট বিরিয়ানির সমান! 🍛"
        } else {
            content.body = language == .english ? 
                "You burned \(caloriesBurned) calories this \(period)! Keep going! 💪" :
                "আপনি এই \(period) \(caloriesBurned) ক্যালোরি পুড়িয়েছেন! চালিয়ে যান! 💪"
        }
        
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "calorie_achievement_\(Date().timeIntervalSince1970)",
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func sendWorkoutCompleteNotification(workoutName: String, caloriesBurned: Int) {
        guard notificationsEnabled else { return }
        
        let content = UNMutableNotificationContent()
        content.title = language == .english ? "🎉 Workout Complete! 🎉" : "🎉 ওয়ার্কআউট সম্পন্ন! 🎉"
        content.body = language == .english ? 
            "Great job on '\(workoutName)'! You burned \(caloriesBurned) calories 🔥" :
            "'\(workoutName)' এ দুর্দান্ত কাজ! আপনি \(caloriesBurned) ক্যালোরি পুড়িয়েছেন 🔥"
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "workout_complete_\(Date().timeIntervalSince1970)",
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func sendMissedWorkoutReminder() {
        guard notificationsEnabled && workoutReminders else { return }
        
        let content = UNMutableNotificationContent()
        content.title = language == .english ? "We Miss You! 😊" : "আমরা আপনাকে মিস করছি! 😊"
        content.body = language == .english ? 
            "It's been a while since your last workout. Ready to get back on track? 💪" :
            "আপনার শেষ ওয়ার্কআউটের পর অনেক সময় হয়ে গেছে। আবার শুরু করতে প্রস্তুত? 💪"
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "missed_workout_\(Date().timeIntervalSince1970)",
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - Message Generators
    private func getStreakMessages() -> [NotificationMessage] {
        return language == .english ? [
            NotificationMessage(
                title: "🔥 Streak Alert! 🔥",
                body: "Day 3 in a row! Don't break your streak 🔥"
            ),
            NotificationMessage(
                title: "💪 You're on Fire! 💪",
                body: "Your consistency is paying off! Keep the momentum going!"
            ),
            NotificationMessage(
                title: "🏆 Streak Master! 🏆",
                body: "Week-long streaks build lifelong habits! You're amazing!"
            )
        ] : [
            NotificationMessage(
                title: "🔥 স্ট্রিক সতর্কতা! 🔥",
                body: "পরপর ৩ দিন! আপনার স্ট্রিক ভাঙবেন না 🔥"
            ),
            NotificationMessage(
                title: "💪 আপনি দুর্দান্ত! 💪",
                body: "আপনার নিয়মিততা ফল দিচ্ছে! গতি বজায় রাখুন!"
            ),
            NotificationMessage(
                title: "🏆 স্ট্রিক মাস্টার! 🏆",
                body: "সপ্তাহব্যাপী স্ট্রিক জীবনব্যাপী অভ্যাস তৈরি করে! আপনি অসাধারণ!"
            )
        ]
    }
    
    private func getMotivationalMessages() -> [NotificationMessage] {
        return language == .english ? [
            NotificationMessage(
                title: "🌟 Daily Motivation 🌟",
                body: "Small steps daily lead to big changes yearly! 🚀"
            ),
            NotificationMessage(
                title: "💡 Fitness Tip 💡",
                body: "Consistency beats perfection! Even 5 minutes counts! ⏰"
            ),
            NotificationMessage(
                title: "🎯 Goal Reminder 🎯",
                body: "Remember why you started. You've got this! 💪"
            ),
            NotificationMessage(
                title: "🌅 Fresh Start 🌅",
                body: "Every day is a new opportunity to be healthier! ✨"
            ),
            NotificationMessage(
                title: "🍛 Fun Fact 🍛",
                body: "A 30-minute workout burns the same calories as 1 plate of bhapa ilish! 🐟"
            )
        ] : [
            NotificationMessage(
                title: "🌟 দৈনিক অনুপ্রেরণা 🌟",
                body: "প্রতিদিনের ছোট পদক্ষেপ বছরে বড় পরিবর্তন আনে! 🚀"
            ),
            NotificationMessage(
                title: "💡 ফিটনেস টিপস 💡",
                body: "নিয়মিততা পূর্ণতার চেয়ে ভালো! মাত্র ৫ মিনিটও গুরুত্বপূর্ণ! ⏰"
            ),
            NotificationMessage(
                title: "🎯 লক্ষ্য স্মরণ 🎯",
                body: "কেন শুরু করেছিলেন মনে রাখুন। আপনি পারবেন! 💪"
            ),
            NotificationMessage(
                title: "🌅 নতুন শুরু 🌅",
                body: "প্রতিটি দিন স্বাস্থ্যকর হওয়ার নতুন সুযোগ! ✨"
            ),
            NotificationMessage(
                title: "🍛 মজার তথ্য 🍛",
                body: "৩০ মিনিটের ওয়ার্কআউট ১ প্লেট ভাপা ইলিশের সমান ক্যালোরি পোড়ায়! 🐟"
            )
        ]
    }
    
    // MARK: - Utility Functions
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func cancelNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.notificationsEnabled = settings.authorizationStatus == .authorized
            }
        }
    }
}

// MARK: - Supporting Models
enum NotificationLanguage: String, CaseIterable {
    case english = "en"
    case bangla = "bn"
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .bangla: return "বাংলা"
        }
    }
}

struct NotificationMessage {
    let title: String
    let body: String
}

// MARK: - Smart Notification Extensions
extension NotificationManager {
    // Send contextual notifications based on user behavior
    func sendSmartReminder(context: NotificationContext) {
        guard notificationsEnabled else { return }
        
        let content = UNMutableNotificationContent()
        
        switch context {
        case .lunchTimeWorkout:
            content.title = language == .english ? "🍽️ Lunch Break Fitness! 🍽️" : "🍽️ দুপুরের বিরতিতে ফিটনেস! 🍽️"
            content.body = language == .english ? 
                "Quick 10-minute workout before lunch? Your body will thank you! 🥗" :
                "দুপুরের খাবারের আগে ১০ মিনিটের দ্রুত ওয়ার্কআউট? আপনার শরীর কৃতজ্ঞ থাকবে! 🥗"
            
        case .preRamadanFitness:
            content.title = language == .english ? "🌙 Ramadan Prep! 🌙" : "🌙 রমজানের প্রস্তুতি! 🌙"
            content.body = language == .english ? 
                "Get fit before Ramadan! Light exercise helps with fasting 💪" :
                "রমজানের আগে ফিট হয়ে নিন! হালকা ব্যায়াম রোজায় সাহায্য করে 💪"
            
        case .rainydayIndoor:
            content.title = language == .english ? "🌧️ Rainy Day Fitness! 🌧️" : "🌧️ বর্ষার দিনে ফিটনেস! 🌧️"
            content.body = language == .english ? 
                "Perfect weather for indoor workouts! Stay active, stay dry 🏠" :
                "ঘরে ওয়ার্কআউটের জন্য নিখুঁত মোসম! সক্রিয় থাকুন, শুকনো থাকুন 🏠"
            
        case .festivalPrep:
            content.title = language == .english ? "🎉 Festival Ready! 🎉" : "🎉 উৎসবের প্রস্তুতি! 🎉"
            content.body = language == .english ? 
                "Get festival-ready! Quick workout before the celebrations 🥳" :
                "উৎসবের জন্য প্রস্তুত হন! উৎসবের আগে দ্রুত ওয়ার্কআউট 🥳"
        }
        
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "smart_reminder_\(Date().timeIntervalSince1970)",
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        )
        
        UNUserNotificationCenter.current().add(request)
    }
}

enum NotificationContext {
    case lunchTimeWorkout
    case preRamadanFitness
    case rainydayIndoor
    case festivalPrep
}