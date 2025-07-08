//
//  UserDefaultsData.swift
//  UEFA_App
//
//  Created by Nausheen Khan on 09/10/21.
//

import UIKit

class UserDefaultsData: NSObject {
    
    static let shared = UserDefaultsData()
    private let defaults = UserDefaults.standard
    
    override private init() {
        super.init()
    }
    
    func setCodableDataToUserDefaults <T:Codable> (codableData: T, forKey key: String) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(codableData) {
            defaults.setValue(encodedData, forKey: key)
        }
    }
    
    func getCodableDataFromUserDefaults<T: Codable> (forKey key: String) -> T?  {
        if let savedData = defaults.object(forKey: key) as? Data {
            
            let decoder = JSONDecoder()
            if let saveDataObject = try? decoder.decode(T.self, from: savedData) {
                return saveDataObject
            }
        }
        return nil
    }
}

//MARK: general defaults
extension UserDefaultsData{
    var isTutorialVisited: Bool{
        get{
            return UserDefaults.standard.bool(forKey: "isTutorialVisited")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isTutorialVisited")
        }
    }
    
    var isMyTeamFilterTooltipVisited: Bool{
        get{
            return UserDefaults.standard.bool(forKey: "isMyTeamFilterTooltipVisited")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isMyTeamFilterTooltipVisited")
        }
    }
    
    var isPickPlayerTooltipVisited: Bool{
        get{
            return UserDefaults.standard.bool(forKey: "isPickPlayerTooltipVisited")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isPickPlayerTooltipVisited")
        }
    }
    
    var isRecommededQstnPopupVisited: Bool{
        get{
            return UserDefaults.standard.bool(forKey: "isRecommededQstnPopupVisited")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isRecommededQstnPopupVisited")
        }
    }
    
    var guestUserTeamName: String?{
        get{
            return UserDefaults.standard.string(forKey: "guestUserTeamName")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "guestUserTeamName")
        }
    }
    
    var homeScreenVisitedCount: Int{
        get{
            return UserDefaults.standard.integer(forKey: "homeScreenVisitedCount")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "homeScreenVisitedCount")
        }
    }
    
    var didShowPlayerKitsMsg: Bool{
        get{
            return UserDefaults.standard.bool(forKey: "didShowPlayerKitsMsg")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "didShowPlayerKitsMsg")
        }
    }
    
    //MARK: Translation related
    var currentLang: String{
        get{
            return UserDefaults.standard.string(forKey: "currentLang") ?? "en"
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "currentLang")
        }
    }
    
    //MARK: Translation related
    var apiVersioning: Int{
        get{
            return UserDefaults.standard.integer(forKey: "apiVersioning")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "apiVersioning")
        }
    }
    
    var isUserTeamUpdatedForGameday: Int{
        get{
            return UserDefaults.standard.integer(forKey: "isUserTeamUpdatedForGameday")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isUserTeamUpdatedForGameday")
        }
    }
}

//MARK: Guest card data
extension UserDefaultsData{
//    var isFunQuizPlay: String?{
//       
//        set{
//            UserDefaults.standard.set(newValue, forKey: isFunQuizPlay ?? "")
//        }
//    }
    
    var isDayliQuizPlay: Bool{
        get{
            return UserDefaults.standard.bool(forKey: "isDayliQuizPlay\(QUIZTheme.currentGameID ?? "uclquiz")")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isDayliQuizPlay\(QUIZTheme.currentGameID ?? "uclquiz")")
        }
    }
    
    var isMoreLessPlay: Bool{
        get{
            return UserDefaults.standard.bool(forKey: "isMoreLessPlay\(QUIZTheme.currentGameID ?? "uclquiz")")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isMoreLessPlay\(QUIZTheme.currentGameID ?? "uclquiz")")
        }
    }
}


//MARK: User Login related data
//extension UserDefaultsData {
//    
//    func isUserLoggedIn() -> Bool{
//        return UserDefaults.standard.bool(forKey: "isLoggedIn")
//    }
//    
//    func setUserLoggedIn(_ status: Bool){
//        UserDefaults.standard.set(status, forKey: "isLoggedIn")
//    }
//    
//    func getUserData() -> UserLoginResponseModel?{
//        return getCodableDataFromUserDefaults(forKey: "userData")
//    }
//    
//    func setUserData(_ data: UserLoginResponseModel?){
//        setCodableDataToUserDefaults(codableData: data, forKey: "userData")
//    }
//}

//MARK: App Init related
extension UserDefaultsData{
    
    var translationVersion: Double{
        get{
            return UserDefaults.standard.double(forKey: "translationVersion")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "translationVersion")
        }
    }
    
    var teamVersion: Double{
        get{
            return UserDefaults.standard.double(forKey: "teamVersion")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "teamVersion")
        }
    }
    
    var formationVersion: Double{
        get{
            return UserDefaults.standard.double(forKey: "formationVersion")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "formationVersion")
        }
    }
    
    var dismissibleCardVersion: String{
        get{
            return UserDefaults.standard.string(forKey: "dismissibleCardVersion") ?? ""
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "dismissibleCardVersion")
        }
    }
    
    var dismissibleCardPersistKey: String{
        get{
            return UserDefaults.standard.string(forKey: "dismissibleCardPersistKey") ?? ""
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "dismissibleCardPersistKey")
        }
    }
}


//MARK: Overview screen
extension UserDefaultsData {
    var notificationCardToBeHidden: Bool {
        get{
            return UserDefaults.standard.bool(forKey: "notificationCardShown")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "notificationCardShown")
        }
    }
    
    var notificationPopupDismissTimeStamp: Date? {
        get {
            if let savedDate = UserDefaults.standard.value(forKey: "notificationPopupDismissTimeStamp") as? Date {
                let numberOfDays = Calendar.current.dateComponents([.day], from: savedDate, to: Date())
                if (numberOfDays.day ?? 0) < 30 {
                    return savedDate
                }
            }
            return nil
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "notificationPopupDismissTimeStamp")
        }
    }
}

