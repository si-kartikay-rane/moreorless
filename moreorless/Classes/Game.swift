//
//  Game.swift
//  Pods
//
//  Created by Aurimas Petrevicius on 2021-10-08.
//

import UIKit
import GamesLib

public class Game: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    private var gameId: String = ""
    private var data: [String:Any]?
    
    public override func viewDidLoad() {
        super.viewDidLoad()

    
        // load local image in code from game resource bundle
        imageView.image = UIImage(named: "markings", in: PodBundle.bundle, compatibleWith: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(onMenu))
    
        prepareBanner()
        
        refreshViews()
        
        // MARK: Listen to Login/Logout events
        
        // Register for logged in/logged out  notifications
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onLoginLogout(notification:)),
                                               name: .ghLoggedIn,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onLoginLogout(notification:)),
                                               name: .ghLoggedOut,
                                               object: nil)
        
        // MARK: DEEPLINK events listener
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onDeepLink(notification:)),
                                               name: .ghOpenLink,
                                               object: nil)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // check data for deeplink if needed
        if let url = data?["url"] as? URL {
            print("DEEPLINK on game start \(url.absoluteString)")
        }
    }
    
    // MARK: LOGIN
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userStateLabel: UILabel!
    
    @IBAction func onLoginRequestAction(_ sender: Any) {
        GamingHubCards.login(gameId)
    }
    
    private func refreshViews(){
        // get environment info
        let environment = GamingHubCards.environment
        navigationItem.title = "\(environment.environment.rawValue) environment"
        if GamingHubCards.isLoggedIn {
            loginButton.isHidden = true
            // get fresh user info
            let user = GamingHubCards.user
            userStateLabel.text = "Logged in user: \(user.username)"
        }else{
            loginButton.isHidden = false
            userStateLabel.text = nil
        }
        
        
    }
    
    // MARK: LOGIN/LOGOUT LISTENERS
    
    @objc func onLoginLogout(notification: Notification){
        refreshViews()
    }
    
    // MARK: DEEPLINK LISTENER
    
    @objc func onDeepLink(notification: Notification){
        guard let url = notification.userInfo?["url"] as? URL else { return }
        print("DEEPLINK NOTIFICATION RECEIVED, \(url.absoluteString)")
    }
    
    // MARK: STATIC FACTORY
    
    static func game(gameId: String, data: [String:Any]? = nil)->UIViewController {
        let vc = Game(nibName: "Game", bundle: PodBundle.bundle)
        vc.gameId = gameId
        vc.data = data
        return vc
    }
    
    // MARK: MENU
    
    @objc func onMenu(){
        GamingHubCards.openMenu()
    }
    
}

extension Game: GameCard {
    public class func viewController(data: [String : Any]?) -> UIViewController? {
        
        let game = Game.game(gameId:GAMEID, data: data)
        let nc = UINavigationController(rootViewController: game)
        
        return nc
    }
}
