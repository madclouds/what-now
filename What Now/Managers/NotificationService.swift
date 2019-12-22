import UserNotifications

class NotificationService {
    class func setUpLocalNotification() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, _) in
            if granted {
                //10 seconds
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (60*60*12), repeats: true)
                let content = UNMutableNotificationContent()
                content.body = "What tasks did you complete?"
                content.title = "What should you be working on?"
                let notification = UNNotificationRequest(identifier: "com.erikbye.whatnow", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(notification, withCompletionHandler: nil)
            }
        }
    }

}
