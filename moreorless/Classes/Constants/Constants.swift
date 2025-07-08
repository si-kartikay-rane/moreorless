//
//  Stroyboard+Constants.swift
//  Quiz
//
//  Created by Vishal Vijayvargiya on 21/09/23.
//

import Foundation
import SwiftyJSON
import GamesLib
struct Constants {
    //config data
    static var configData : ConfigModel?{
        didSet{
            guard let config = configData else {
                return
            }
           Constants.appData.platformID = QUIZTheme.isIpad ? 4 : 2
//            Constants.appData.tourId = config.tourID ?? 0
            
        }
    }
    static var isLogin = GamingHubCards.isLoggedIn
    static var guid = ""
    static var appData = AppData()
    struct AppData {
        var platformID : Int = QUIZTheme.isIpad ? 4 : 2
        var tourId: Int = 1
    }
}

extension Constants {
    
    static func isLogEnable() -> Bool {
        if CommandLine.arguments.contains(where: {$0 == "quiz"}) {
            return true
        } else {
            return false
        }
    }
    
    static func print(_ items: Any..., separator: String = " ", terminator: String = ",\n") {
        GameLogger.print(items,domain: "quiz")
    }
}
