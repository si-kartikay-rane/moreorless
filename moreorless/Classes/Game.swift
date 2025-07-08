////
////  Game.swift
////  Pods
////
////  Created by Aurimas Petrevicius on 2021-10-08.
////
//
//import UIKit
//import GamesLib
//
//public class Game: UIViewController {
//
//    @IBOutlet weak var imageView: UIImageView!
//    
//    private var gameId: String = ""
//    private var data: [String:Any]?
//    
//    public override func viewDidLoad() {
//        super.viewDidLoad()
//
//    
//        // load local image in code from game resource bundle
//        imageView.image = UIImage(named: "markings", in: PodBundle.bundle, compatibleWith: nil)
//        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(onMenu))
//    
//        prepareBanner()
//        
//        refreshViews()
//        
//        // MARK: Listen to Login/Logout events
//        
//        // Register for logged in/logged out  notifications
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(onLoginLogout(notification:)),
//                                               name: .ghLoggedIn,
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(onLoginLogout(notification:)),
//                                               name: .ghLoggedOut,
//                                               object: nil)
//        
//        // MARK: DEEPLINK events listener
//        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(onDeepLink(notification:)),
//                                               name: .ghOpenLink,
//                                               object: nil)
//    }
//
//    public override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        // check data for deeplink if needed
//        if let url = data?["url"] as? URL {
//            print("DEEPLINK on game start \(url.absoluteString)")
//        }
//    }
//    
//    // MARK: LOGIN
//    
//    @IBOutlet weak var loginButton: UIButton!
//    @IBOutlet weak var userStateLabel: UILabel!
//    
//    @IBAction func onLoginRequestAction(_ sender: Any) {
//        GamingHubCards.login(gameId)
//    }
//    
//    private func refreshViews(){
//        // get environment info
//        let environment = GamingHubCards.environment
//        navigationItem.title = "\(environment.environment.rawValue) environment"
//        if GamingHubCards.isLoggedIn {
//            loginButton.isHidden = true
//            // get fresh user info
//            let user = GamingHubCards.user
//            userStateLabel.text = "Logged in user: \(user.username)"
//        }else{
//            loginButton.isHidden = false
//            userStateLabel.text = nil
//        }
//        
//        
//    }
//    
//    // MARK: LOGIN/LOGOUT LISTENERS
//    
//    @objc func onLoginLogout(notification: Notification){
//        refreshViews()
//    }
//    
//    // MARK: DEEPLINK LISTENER
//    
//    @objc func onDeepLink(notification: Notification){
//        guard let url = notification.userInfo?["url"] as? URL else { return }
//        print("DEEPLINK NOTIFICATION RECEIVED, \(url.absoluteString)")
//    }
//    
//    // MARK: STATIC FACTORY
//    
//    static func game(gameId: String, data: [String:Any]? = nil)->UIViewController {
//        let vc = Game(nibName: "Game", bundle: PodBundle.bundle)
//        vc.gameId = gameId
//        vc.data = data
//        return vc
//    }
//    
//    // MARK: MENU
//    
//    @objc func onMenu(){
//        GamingHubCards.openMenu()
//    }
//    
//}
//
//extension Game: GameCard {
//    public class func viewController(data: [String : Any]?) -> UIViewController? {
//        
//        let game = Game.game(gameId:GAMEID, data: data)
//        let nc = UINavigationController(rootViewController: game)
//        
//        return nc
//    }
//}

//
//  Game.swift
//  QuizeApp
//
//  Created by Vishal Vijayvargiya on 21/08/23.
//

import UIKit
import GamesLib
import SwiftUI

public class Game: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    private var gameId: String = ""
    private var data: [String:Any]?
    var nc: UINavigationController?
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
            if Constants.isLogEnable() {
               // Constants.print("DEEPLINK on game start \(url.absoluteString)")
            }
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
            QuizzGameSDk.game.store.QuizUser =  nil
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
        if Constants.isLogEnable() {
           // Constants.print("DEEPLINK NOTIFICATION RECEIVED, \(url.absoluteString)")
        }
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

extension Game: CompetitionGameCard {
    public static func viewController(data: [String : Any]?, gameId: String, competition: Int?) -> UIViewController? {
        
        if  let GAME_DATA =  data{
            
            if let restoreOld = GAME_DATA["restoreOldNavigationBarStyleOnClose"] as? Bool {
                QUIZTheme.restore_old_navigation = restoreOld
            }
            
            if let navigationController = GAME_DATA["navigationController"] as? UINavigationController {
                QUIZTheme.currentnavigation = navigationController
                QUIZTheme.gaming_pushed_navigation = navigationController
                QUIZTheme.originalNavBarAppearance = navigationController.navigationBar.standardAppearance.copy()
                QUIZTheme.originalNavBarprefersLargeTitles = navigationController.navigationBar.prefersLargeTitles
                let font: UIFont? = navigationController.navigationBar.titleTextAttributes?[.font] as? UIFont
                let textColor: UIColor? = navigationController.navigationBar.titleTextAttributes?[.foregroundColor] as? UIColor
                let tintColor: UIColor? = navigationController.navigationBar.tintColor
                let backgroundImage: UIImage? = navigationController.navigationBar.backgroundImage(for: .default)
                let shadowImage: UIImage? = navigationController.navigationBar.shadowImage
                let isTranslucent: Bool? = navigationController.navigationBar.isTranslucent
                let backgroundColor: UIColor? = navigationController.navigationBar.barTintColor
                var style = UINavigationController.NavigationBarStyle()
                style.font = font
                style.textColor = textColor
                style.tintColor = tintColor
                style.backgroundImage = backgroundImage
                style.shadowImage = shadowImage
                style.isTranslucent = isTranslucent
                style.backgroundColor = backgroundColor
                QUIZTheme.originalNavBarStoredStyle = style
            }
            
            if let embededInNavigationController = GAME_DATA["embededInNavigationController"] as? Bool {
                QUIZTheme.embeded_In_NavigationController = embededInNavigationController
                
            }
            
            if let dataURL = GAME_DATA["url"] as? URL {
                QUIZTheme.checkDeeplinkURlAndData(url: dataURL.absoluteString)
            }
            if let dataString = GAME_DATA["url"] as? String {
                if let url = URL(string: dataString) {
                    QUIZTheme.checkDeeplinkURlAndData(url: dataString)
                }
            }
            // Handle other cases as needed
            if let dataLinkURL = GAME_DATA["link"] as? URL {
                QUIZTheme.checkDeeplinkURlAndData(url: dataLinkURL.absoluteString)
            }
            
            if let dataLinkString = GAME_DATA["link"] as? String {
                QUIZTheme.checkDeeplinkURlAndData(url: dataLinkString)
            }
        }
        
        
        let podBundle = Bundle(for: FeaturedCard.self)
        let data1 = podBundle.url(forResource: gameId, withExtension: "bundle")!
        let theme_bundle = Bundle(url: data1) ?? Bundle.main
        QUIZTheme.currentBundle = theme_bundle
        QUIZTheme.currentGameID =  gameId
        QUIZTheme.competitionId = competition
        QUIZTheme.updateViewLayout()
        let game = Game() // Create an instance of Game
        
        if QUIZTheme.embeded_In_NavigationController {
            let QuizInitialView = UIHostingController(rootView: QuizStarterView().environment(\.bundle, theme_bundle).navigationViewStyle(.stack))
                    game.nc = UINavigationController(rootViewController: QuizInitialView)
                    QUIZTheme.currentnavigation = game.nc
            return game.nc
        } else {
            let QuizInitialPresentedScreen = UIHostingController(rootView: QuizStarterView().environment(\.bundle, theme_bundle).navigationViewStyle(.stack))
            
            QUIZTheme.currentnavigation = QUIZTheme.gaming_pushed_navigation
            return QuizInitialPresentedScreen
        }
        
        
    }
    
    
    
    public static func viewController(data: [String : Any]?) -> UIViewController? {
        return UIViewController()
    }
   
}


//Make a swiftui view - an intermediate one  // stsrtview
//if state is main view -> render hom landin view
// remove navigation link from spalsh view add it in start view
//note: - don't navigate just render not navigate


