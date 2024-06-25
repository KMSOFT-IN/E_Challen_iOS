//
//  AppDelegate.swift
//  E_Challen
//
//  Created by KMSOFT on 21/06/24.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let urlString = "https://raw.githubusercontent.com/bestappinfo/best-app/main/ids.json"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //print(URL.documentsDirectory)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    
//        if let gadAppID = UserDefaults.standard.string(forKey: Constant.UserDefault.APP_ID) {
//            GADMobileAds.sharedInstance().start(completionHandler: nil)
//            print("Google AdMob initialized with App ID: \(gadAppID)")
//        } else {
//            print("Google AdMob App ID not found")
//        }
        
        self.fetchAdIDs()
        return true
    }
    
    func fetchAdIDs() {
           guard let url = URL(string: urlString) else { return }
           
           let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
               guard let self = self else { return }
               
               if let error = error {
                   print("Failed to fetch data: \(error)")
                   return
               }
               
               guard let data = data else {
                   print("No data received")
                   return
               }
               
               do {
                   let adIDs = try JSONDecoder().decode(AdIDs.self, from: data)
                   DispatchQueue.main.async {
                       if adIDs.adsEnable {
                           UserdefaultHelper.setAppId(value: adIDs.iosAppID)
                           UserdefaultHelper.setBannerId(value: adIDs.iosBannerID)
                           UserdefaultHelper.setIntertitialId(value: adIDs.iosInterstitialID)
                           UserdefaultHelper.setadsEnable(value: true)
                           UserdefaultHelper.setSearchCount(value: 1)

                           print("iOS App ID: \(adIDs.iosAppID)")
                           print("iOS Banner ID: \(adIDs.iosBannerID)")
                           print("iOS Interstitial ID: \(adIDs.iosInterstitialID)")
                       } else {
                           print("Ads are disabled")
                           UserdefaultHelper.setadsEnable(value: false)
                       }
                   }
               } catch {
                   print("Failed to decode JSON: \(error)")
               }
           }
           
           task.resume()
       }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "E_Challen")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

