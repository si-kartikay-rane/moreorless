//
//  FeaturedCard.swift
//  moreorless
//
//  Created by Aurimas Petrevicius on 2021-10-07.
//

import UIKit
import GamesLib

public class FeaturedCard: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Register for logged in/logged out  notifications
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onLoginLogout(notification:)),
                                               name: .ghLoggedIn,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onLoginLogout(notification:)),
                                               name: .ghLoggedOut,
                                               object: nil)
        refreshViews()
    }
    
    @objc func onLoginLogout(notification: Notification){
        refreshViews()
    }
    
    private func refreshViews(){
        (view.viewWithTag(100) as? UIButton)? .setTitle(GamingHubCards.isLoggedIn ? "loggedin" : "anonoymous", for: .normal)
    }
    
    // MARK: Actions
    
    @IBAction func onCardClicked(_ sender: Any) {
        GamingHubCards.open(GAMEID, data: nil)
    }
    
    
    // MARK: STATIC FACTORY
    
    static func card(matchRefId: String? = nil )->UIViewController {
        let vc = FeaturedCard(nibName: "FeaturedCard", bundle: PodBundle.bundle)
        return vc
        
    }
    
}

extension FeaturedCard: GameCard {
    public class func viewController(data: [String : Any]?) -> UIViewController? {
        return FeaturedCard.card()
    }
}
