import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseCore
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    // ------------------------------------------------------------------------------------------------------------------------------------ //
    // USER SETUP METHOD
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let sceneWindow = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: sceneWindow)
        window?.rootViewController = LogoVC()
        window?.makeKeyAndVisible()
        FirebaseApp.configure()
        getAppColors()
        if Auth.auth().currentUser != nil{
            let authNetworking = AuthNetworking(nil)
            let uid = Auth.auth().currentUser!.uid
            authNetworking.setupUserInfo(uid) { (isActive) in
                if isActive {
                    self.window?.rootViewController = ChatTabBar()
                    self.window?.makeKeyAndVisible()
                }else{
                    let controller = SignInVC()
                    self.window?.rootViewController = controller
                    self.window?.makeKeyAndVisible()
                }
            }
        }else{
        window?.rootViewController = SignInVC()//WelcomeVC()
            window?.makeKeyAndVisible()
        }
        activityObservers()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // SETS UP THEME COLORS
    
    func getAppColors() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AppColors")
        request.returnsObjectsAsFaults = false
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if data.value(forKey: "selectedIncomingColor") != nil {
                    ThemeColors.selectedIncomingColor = data.value(forKey: "selectedIncomingColor") as! UIColor
                }
                if data.value(forKey: "selectedOutcomingColor") != nil {
                    ThemeColors.selectedOutcomingColor = data.value(forKey: "selectedOutcomingColor") as! UIColor
                }
                if data.value(forKey: "selectedBackgroundColor") != nil {
                    ThemeColors.selectedBackgroundColor = data.value(forKey: "selectedBackgroundColor") as! UIColor
                }
                if data.value(forKey: "selectedIncomingTextColor") != nil {
                    ThemeColors.selectedIncomingTextColor = data.value(forKey: "selectedIncomingTextColor") as! UIColor
                }
                if data.value(forKey: "selectedOutcomingTextColor") != nil {
                    ThemeColors.selectedOutcomingTextColor = data.value(forKey: "selectedOutcomingTextColor") as! UIColor
                }
            
            }
        }catch{
            // Standard app colors will be loaded
        }
    }
     
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // SENDS DATA TO FIREBASE THAT THE USER SUCCESSFULLY LOGGED IN
    
    func activityObservers(){
        guard let user = Auth.auth().currentUser else { return }
        let ref = Database.database().reference()
        let userRef = ref.child("users").child(user.uid)
        userRef.child("isOnline").setValue(true)
        userRef.child("isOnline").onDisconnectSetValue(false)
        userRef.child("lastLogin").setValue(Date().timeIntervalSince1970)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func sceneDidBecomeActive(_ scene: UIScene) {
       UserActivity.observe(isOnline: true)
        
        
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        
        UserActivity.observe(isOnline: false)
        showPrivacyProtectionWindow()
        
    }


       func sceneWillEnterForeground(_ scene: UIScene) {
           
           hidePrivacyProtectionWindow()
       }


       // MARK: Privacy Protection
       
       private var privacyProtectionWindow: UIWindow?

       private func showPrivacyProtectionWindow() {
           guard let windowScene = self.window?.windowScene else {
               return
           }

           privacyProtectionWindow = UIWindow(windowScene: windowScene)
           privacyProtectionWindow?.rootViewController = PrivacyProtectionViewController()
           privacyProtectionWindow?.windowLevel = .alert + 1
           privacyProtectionWindow?.makeKeyAndVisible()
       }

       private func hidePrivacyProtectionWindow() {
           privacyProtectionWindow?.isHidden = true
           privacyProtectionWindow = nil
       }
   
    }
