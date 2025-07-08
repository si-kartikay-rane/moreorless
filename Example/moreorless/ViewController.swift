//
//  ViewController.swift
//  moreorless
//
//  Created by si-kartikay-rane on 07/07/2025.
//  Copyright (c) 2025 si-kartikay-rane. All rights reserved.
// mix test 

import UIKit
import GamesLib
import moreorless
import SwiftUI

//class ViewController: GHPOCViewController {
//
//    override var gameId: String {
//        "moreorless"
//    }
//
//}

class ViewController: GHPOCViewController {
    
    //let platforms = ["moreorless", "uclmoreorless", "euromoreorless", "uwclmoreorless", "weuromoreorless"]
    let platforms = ["quiz", "uclquiz", "euroquiz", "uwclquiz", "weuroquiz"]
    //MARK: - Game initialisation - Select GAMEID
    override var gameId: String {
        platforms[1]
    }
    
    //MARK: - Game initialisation - Initializer type enum
    private enum gameInitializer {
        case modale_Presentation
        case push_onHost
    }
    
    //MARK: - Game initialisation - review/change Initializer type here
    //The GH app utilizes - modale_Presentation
    //The Club app utilizes - push_onHost
    private let Game_initialisation = gameInitializer.modale_Presentation
    
    //MARK: - Game initialisation - full screen modal presentation
    override func setup(gameId: String, data: [String : Any]? = nil) {
        if Game_initialisation == .modale_Presentation {
            let card = moreorless.FeaturedCardSwiftUI(data: data, gameId: gameId, competition: nil)
            let vc = UIHostingController(rootView: card)
            add(gameCard: vc, to: self.view)
        }
    }
    
    //MARK: - Game initialisation - pushing onto Host Navigation Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Game_initialisation == .push_onHost {
            setupNavBarForTesting()
            self.pushgame()
        }
    }
    
    //MARK: - Game initialisation - Add some style for navigation bar to test restoration of pushing onto this Host's Navigation Controller and then when come back see if it's intact.
    
    private func setupNavBarForTesting() {
        self.navigationController?.navigationBar.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        self.navigationController?.navigationBar.prefersLargeTitles = false
        let addButton = UIButton(type: .custom)
        addButton.addTarget(self, action: #selector(pushgame), for: .touchUpInside)
        addButton.setTitle("Push Game Button", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let addBarButton = UIBarButtonItem(customView: addButton)
        addButton.tintColor = .white
        navigationItem.rightBarButtonItem = addBarButton
    }
    
    @objc func pushgame() {
        let data: [String: Any] = [ "embededInNavigationController": false, // if set to false - do not embed game in internal navigation controller
                                    "navigationController": self.navigationController!, // host navigation controller to be used
                                    "restoreOldNavigationBarStyleOnClose": true] // set to false if host app wants to restore its navigationBar instance style manually in onGHMenu listener
        if let game = GamingHubCards.game(gameId: gameId, data: data) {
            self.navigationController!.pushViewController(game, animated: true)
        }
    }
    
    override func openMenu(notification: Notification) {
        if Game_initialisation == .push_onHost {
            self.navigationController!.popViewController(animated: true)
        } else {
            dismiss(animated: true)
            CurrentGame = ""
        }
    }
}


