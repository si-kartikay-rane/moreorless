//
//  PodBundle.swift
//  uclmoreorless
//
//  Created by Aurimas Petrevicius on 2021-08-27.
//

import Foundation
import GamesLib

let GAMEID = "moreorless"

class PodBundle {
    static var bundle: Bundle = {
        GamingHubCards.gameBundle(for: GAMEID) ?? Bundle.main
//        let podBundle =  Bundle(for: FeaturedCard.self)
//        let data = podBundle.url(forResource: "uclmoreorless", withExtension: "bundle")!
//        return Bundle(url: data) ?? Bundle.main
    }()
}
