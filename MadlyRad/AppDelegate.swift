
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseMessaging
import FirebaseCore
import UserNotifications
import CoreData
import GiphyCoreSDK
import GiphyUISDK
import ScreenShieldKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    //asdvcfgdfhjayusadfbbfdsff
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    var window: UIWindow?
    
    let gcmMessageIDKey = "gcm.message_id"
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "mChat")
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do{
                try context.save()
            }catch{
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        Giphy.configure(apiKey: "LrJf34hRudUjbHHum4ShNwUGxm2UXjfa")
        ScreenShieldKit.setLicenseKey("MEYCIQDb+JhAa/gyMEcMUq2/zE+Vk3AWPF5MFszcWAf+4t6FEQIhAMw2u5LTiIehRHC3hBxYIEZNHeIBmxcjZWMeognRZjpk")
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        IQKeyboardManager.shared.enable = true
        
        requestAuthorizationForNotificationUI()
        registerForRemoteNotifications(application)
        
        if let token = Messaging.messaging().fcmToken {
            Database.database().reference().child("users").child("resigraotaon").child("registration_token").setValue(token)
        }
        
        return true
    }
    
    private func requestAuthorizationForNotificationUI() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
    }
    
    private func registerForRemoteNotifications(_ application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
    }
    
    func updateFirebasePushToken() {
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        guard let userId = CurrentUser.uid else { return }
        let userRef = Database.database().reference().child("userActions").child(userId)
        userRef.removeValue()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
        let userInfo = notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
        
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
        
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let notificationToken = fcmToken else { return }
        storeNotificationTokenOnDevice(notificationToken)
        
//        let dataDict:[String: String] = ["token": fcmToken]
//        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    
    private func storeNotificationTokenOnDevice(_ notificationToken: String) {
        UserDefaults.standard.setValue(notificationToken, forKey: UserDefaults.Key.notificationToken.rawValue)
    }
    
}
