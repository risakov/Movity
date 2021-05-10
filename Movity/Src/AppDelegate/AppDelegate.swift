import UIKit
import DBDebugToolkit
import YandexMapsMobile

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var settings: Settings?
    let MAPKIT_API_KEY = "020a2bbe-24be-45d6-bbb7-9113729afc3a"

    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        #if DEBUG
        DBDebugToolkit.setup(with: [DBShakeTrigger()])
        #endif
        
        YMKMapKit.setApiKey(MAPKIT_API_KEY)
        YMKMapKit.setLocale("ru_RU")

        DI.initBackgroundDependencies()
        DI.initDependencies(self)
        self.settings = DI.resolve()
        
        return true
    }
    
    func openRootScreen() {
        if let window = self.window, window.rootViewController == nil || !(window.rootViewController?.restorationIdentifier == "firstNavigationController") {
            UIView.transition(with: window, duration: 0, options: .transitionCrossDissolve, animations: {
                window.rootViewController = R.storyboard.loginStoryboard.instantiateInitialViewController()!
            })
        }
    }

    func checkAuthorizationAndOpenLoginScreen(window: UIWindow?) {
        self.window = window
        self.openRootScreen()
    }
    
    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication,
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

