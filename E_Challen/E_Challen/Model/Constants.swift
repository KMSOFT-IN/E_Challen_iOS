//
//  Constants.swift
//  E_Challen
//
//  Created by KMSOFT on 21/06/24.
//

import Foundation
import UIKit


class Constant{
    
    class Storyboard {
        
        static let MAIN = UIStoryboard(name: "Main", bundle: nil)
        
    }
    
    class UserDefault {
        static let APP_ID = "GADApplicationIdentifier"
        static let BANNER_ID = "GADBannerIdentifier"
        static let INTERSTITIAL_ID = "GADInterstitialIdentifier"
        static let AD_ENABLE = "isAdsEnable"
        static let SEARCH_COUNT = "search_count"
        static let INTERNET = "internet"
    }
    
    class NotificationCenterHelper {
        static let INTERNET_REACH:  Notification.Name = Notification.Name("INTERNET_REACH")
        static let INTERNET_LOST:  Notification.Name = Notification.Name("INTERNET_LOST")
      
    }

    
    var GOOGLEAD_INTERSTITIAL = "ca-app-pub-3940256099942544/4411468910"
}
