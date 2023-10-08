
import Foundation
import UserNotifications

protocol LocalNotificationsServiceProtocol {
    func registeForLatestUpdatesIfPossible()
    func allowNotifications()
}

class LocalNotificationsService {
    
}

extension LocalNotificationsService: LocalNotificationsServiceProtocol {
    
    func allowNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Пользователь разрешил уведомления")
            } else {
                print("Пользователь запретил уведомления")
            }
        }
    }
    
    func registeForLatestUpdatesIfPossible() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Уведомления"
        content.body = "Посмотрите последние обновления"
        content.sound = .default
        
        var components = DateComponents()
        components.hour = 19
        components.minute = 00
        components.second = 00
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        center.add(request)
    }
}
