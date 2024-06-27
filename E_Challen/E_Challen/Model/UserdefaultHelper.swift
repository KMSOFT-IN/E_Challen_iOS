//
//  UserdefaultHelper.swift
//  Surat E Memo
//
//  Created by KMSOFT on 24/06/24.
//

import Foundation


class UserdefaultHelper {
    static func setAppId(value: String?) {
        UserDefaults.standard.set(value, forKey: Constant.UserDefault.APP_ID)
        UserDefaults.standard.synchronize()
    }
    
    static func getAppId() -> String? {
        return UserDefaults.standard.string(forKey: Constant.UserDefault.APP_ID)
    }
    
    static func setBannerId(value: String?) {
        UserDefaults.standard.set(value, forKey: Constant.UserDefault.BANNER_ID)
        UserDefaults.standard.synchronize()
    }
    
    static func getBannerId() -> String? {
        return UserDefaults.standard.string(forKey: Constant.UserDefault.BANNER_ID)
    }
    
    static func setIntertitialId(value: String?) {
        UserDefaults.standard.set(value, forKey: Constant.UserDefault.INTERSTITIAL_ID)
        UserDefaults.standard.synchronize()
    }
    
    static func getInterstitialId() -> String? {
        return UserDefaults.standard.string(forKey: Constant.UserDefault.INTERSTITIAL_ID)
    }
    
    static func setadsEnable(value: Bool?) {
        UserDefaults.standard.set(value, forKey: Constant.UserDefault.AD_ENABLE)
        UserDefaults.standard.synchronize()
    }
    
    static func getadsEnable() -> Bool? {
        return UserDefaults.standard.bool(forKey: Constant.UserDefault.AD_ENABLE)
    }
    
    static func setSearchCount(value: Int?) {
        UserDefaults.standard.set(value, forKey: Constant.UserDefault.SEARCH_COUNT)
        UserDefaults.standard.synchronize()
    }
    
    static func getSearchCount() -> Int? {
        return UserDefaults.standard.integer(forKey: Constant.UserDefault.SEARCH_COUNT)
    }
    
    static func setInternet(value: Bool?) {
        UserDefaults.standard.set(value, forKey: Constant.UserDefault.INTERNET)
        UserDefaults.standard.synchronize()
    }
    
    static func getInternet() -> Bool? {
        return UserDefaults.standard.bool(forKey: Constant.UserDefault.INTERNET)
    }
    
    static func setPrivacyPolicy(value: Bool?) {
        UserDefaults.standard.set(value, forKey: Constant.UserDefault.PRIVACY_POLICY_DONE)
        UserDefaults.standard.synchronize()
    }
    
    static func getPrivacyPolicy() -> Bool? {
        return UserDefaults.standard.bool(forKey: Constant.UserDefault.PRIVACY_POLICY_DONE)
    }
    
    
}
