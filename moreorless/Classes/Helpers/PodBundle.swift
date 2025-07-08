//
//  PodBundle.swift
//  UEFAQuizSDK
//
//  Created by Vishal Vijayvargiya on 24/08/23.
//

import Foundation
import GamesLib

let GAME__ID = "uclquiz"

class PodBundle {
    static var bundle: Bundle = {
        GamingHubCards.gameBundle(for: GAME__ID) ?? Bundle.main
//        let podBundle =  Bundle(for: FeaturedCard.self)
//        let data = podBundle.url(forResource: "uclmoreorless", withExtension: "bundle")!
//        return Bundle(url: data) ?? Bundle.main
    }()
    
    
    func getThemeFor(GameID: String) -> Bundle! {
        guard let bundleURL = Bundle.main.url(forResource: GAME__ID, withExtension: "bundle") else {
            return Bundle.main
        }
        guard let bundle = Bundle(url: bundleURL) else {
            return Bundle.main
        }
        return bundle
    }
    
    static var version: String = {
        (GamingHubCards.gameBundle(for: GAME__ID)?.infoDictionary?["CFBundleShortVersionString"] as? String)
        ?? ""
    }()
    
}
