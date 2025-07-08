//
//  ColorManager.swift
//  QuizeApp
//
//  Created by Vishal Vijayvargiya on 21/08/23.
//

import SwiftUI
import GamesLib
enum QSDKColorName:String {
    
    case QPSDKPrimary = "QPSDKPrimary"
    case QPSDKWhite = "QPSDKWhite"
    case QSDKBackGround_000040 = "QSDKBackGround_000040"
    case QSDKButtonTitle00004B = "QSDKButtonTitle00004B"
    case QSDKSponsorBG00439C = "QSDKSponcorBG00439C"
    case QSDK_FFFFFF40 = "QSDK_FFFFFF40"
    case QSDK_CB333B = "QSDK_CB333B"
    case QSDK_FF16FF = "QSDK_FF16FF"
    case QSDK_0A0A61 = "QSDK_0A0A61"
    case QSDK_000FAA = "QSDK_000FAA"
    case QSDK_32A72C = "QSDK_32A72C"
    case QSDK_151573 = "QSDK_151573"
    case QSDK_0D3AFF = "QSDK_0D3AFF"
    case QSDK_0A9504 = "QSDK_0A9504"
    case QSDK_FFCD44 = "QSDK_FFCD44"
    case QSDK_NavImage051139 = "QSDK_NavImage051139"
    case ML_0929C9 = "ML_0929C9"
    case ML_00057D = "ML_00057D"
    case ML_borderColor1C2291 = "ML_borderColor1C2291"
    case QSDK_boosterWhiteColor = "QSDK_boosterWhiteColor"
    case QSDK_PlayerHeadshot = "QSDK_PlayerHeadshot"
    case QSDK_00BA5D = "QSDK_00BA5D"
    case QSDK_euro_nav = "QSDK_euro_nav"
    case QSDK_count = "QSDK_count"
    case QSDK_143CDB = "QSDK_143CDB"
    case LD_Select_BG = "LD_Select_BG"
    case QSDK_2C2C2C = "QSDK_2C2C2C"
    case QSDKEuroBG = "QSDKEuroBG"
    case QSDK_FFAF4E = "QSDK_FFAF4E"
    case QSDK_0A0A61_Leaderboard = "QSDK_0A0A61_Leaderboard"
    case QSDK_EEF7F9 = "QSDK_EEF7F9"
    case QSDK_9E9AA5 = "QSDK_9E9AA5"
    case QSDK_D91D41 = "QSDK_D91D41"
    case QSDK_465AEE = "QSDK_465AEE"
    case QSDK_1A313C = "QSDK_1A313C"
    var name: String { self.rawValue }
}

 class QUIZTheme {
     static var currentnavigation: UINavigationController?
     static var currentBundle: Bundle?
     static var isIpad:Bool = UIDevice.current.userInterfaceIdiom == .pad
     static var constranWidthLandingViewLeaderbord:CGFloat = 575//525
     static var sizeChnage = false
     static var currentGameID:String? = ""
     static var competitionId:Int? = 0
     static var navigateTo:ConfigModel.DeeplinkRoute? = nil
     static var quizID:String? = nil
     static var quizIDType:String? = nil
     static var isLandscape: Bool {
         return UIDevice.current.orientation.isValidInterfaceOrientation
         ? UIDevice.current.orientation.isLandscape
         : UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape ?? false
 //        return UIDevice.current.orientation.isLandscape
     }
    static func getColor(named colorName: QSDKColorName) -> Color {
        return Color(colorName.name, bundle: currentBundle)
    }
    
    static func getImage(named imageName: String) -> Image? {
        return Image(imageName, bundle: currentBundle) // UIImage(named: imageName, in: currentBundle, compatibleWith: nil)
    }
     static func getImage(named imageName: String) -> UIImage? {
         return UIImage(named: imageName, in: currentBundle, compatibleWith: nil)
     }
     
     //MARK: - Navigation bar state restoration constants please don't touch till you know for what purpose it's used and without knowing the complete flow
     static var restore_old_navigation : Bool = true
     static var gaming_pushed_navigation : UINavigationController = UINavigationController()
     static var embeded_In_NavigationController : Bool = true
     static var originalNavBarAppearance: UINavigationBarAppearance?
     static var originalNavBarStoredStyle: UINavigationController.NavigationBarStyle?
     static var originalNavBarprefersLargeTitles: Bool? = false
     
     //MARK: - notification flow triggers 
     static var oldNotifcationPermisstion:UNAuthorizationStatus.RawValue = 0
     static var channels = [GameNotificationChannel]()
     static var isChannelChangedFromBG = false
     static var QuizzersetChannelFromBGTo : Bool?
     static let RefreshNotificationsChannelSubViews = Notification.Name("quizRefreshNotificationsChannelSubViews")
     static let QuizNotificationChannelStatusChanged = Notification.Name("quizNotificationChannelStatusChanged")
     
     static  func updateViewLayout() {
         if QUIZTheme.isIpad == true && QUIZTheme.isLandscape ==  true{
             let screenWidth = UIScreen.screenWidth
             print(screenWidth)
             switch screenWidth {
             case 744...1023:
                 QUIZTheme.constranWidthLandingViewLeaderbord = 480
             case 1024...1111:
                 QUIZTheme.constranWidthLandingViewLeaderbord = 480
             case 1112...1226:
                 QUIZTheme.constranWidthLandingViewLeaderbord = 320
             case 1227...3000:
                 QUIZTheme.constranWidthLandingViewLeaderbord = 480
             default:
                 QUIZTheme.constranWidthLandingViewLeaderbord = 400
             }
         }else if QUIZTheme.isIpad == true && QUIZTheme.isLandscape ==  false{
             let screenWidth = UIScreen.screenWidth
             print(screenWidth)
             switch screenWidth {
             case 744...1023:
                 QUIZTheme.sizeChnage =  false
                 QUIZTheme.constranWidthLandingViewLeaderbord = 280
             case 1024:
                 QUIZTheme.sizeChnage =  false
                 QUIZTheme.constranWidthLandingViewLeaderbord = 350
             case 1032:
                 QUIZTheme.sizeChnage =  true
                 QUIZTheme.constranWidthLandingViewLeaderbord = 400
             case 1112...1226:
                 QUIZTheme.sizeChnage =  false
                 QUIZTheme.constranWidthLandingViewLeaderbord = 320
             case 1366:
                 QUIZTheme.sizeChnage =  true
                 QUIZTheme.constranWidthLandingViewLeaderbord = 350
             default:
                 QUIZTheme.sizeChnage =  false
                 QUIZTheme.constranWidthLandingViewLeaderbord = 400
             }
         }
     }
     
     
     static func handleOpenLinkNotification(_ notification: Notification) {
            if let data = notification.userInfo {
                if let dataURL = data["url"] as? URL {
                    self.checkDeeplinkURlAndData(url: dataURL.absoluteString)
                }
                if let dataString = data["url"] as? String {
                    if let url = URL(string: dataString) {
                        self.checkDeeplinkURlAndData(url: dataString)
                    }
                }
                // Handle other cases as needed
                if let dataLinkURL = data["link"] as? URL {
                    self.checkDeeplinkURlAndData(url: dataLinkURL.absoluteString)
                }
                
                if let dataLinkString = data["link"] as? String {
                    self.checkDeeplinkURlAndData(url: dataLinkString)
                }
            }

           
        }
     
     static  func checkDeeplinkURlAndData(url: String?) {
        // Implement your logic to check and process the deeplink URL
        guard let dataURL = url else {return}
        let linkArray = dataURL.components(separatedBy: "/")
        let routeToGo = linkArray[safe: 5]
        
        switch routeToGo{
        case ConfigModel.DeeplinkRoute.home.rawValue:
            QUIZTheme.navigateTo = .home
        case ConfigModel.DeeplinkRoute.leaderboard.rawValue:
            QUIZTheme.navigateTo = .leaderboard
                QUIZTheme.quizID = linkArray[safe: 7]
                QUIZTheme.quizIDType = linkArray[safe: 6]
        case ConfigModel.DeeplinkRoute.game.rawValue:
            QUIZTheme.navigateTo = .game
            QUIZTheme.quizID = linkArray[safe: 7]
            QUIZTheme.quizIDType = linkArray[safe: 6]
        default:
            QUIZTheme.navigateTo = .none
        }
    }
     
     static let QuizScreenShotKey = "QuizTakeScreenShotofResultScreen"
     static  func seTitle(id:Int)->String{
         "quiz_type_title_{quizId}".replacingOccurrences(of: NetworkConstants().urlKeys.quizId, with: "\(id)").getTranslationValue(default: id != 2 ? "Random Quiz" : "Daily Quiz")
     }
     
     static  func urlavtra(url:String) -> String{
         var urlAvtrar:String = ""
         urlAvtrar = url
         urlAvtrar =  urlAvtrar.replacingOccurrences(of: NetworkConstants().urlKeys.size, with: "90")
         urlAvtrar =  urlAvtrar.replacingOccurrences(of: NetworkConstants().urlKeys.ratio, with: "")
         return urlAvtrar
     }
     static func eventTypeData(title:String, gameType: String) -> QuizCardItemTypeEnum{
         // TODO: two var must be passed in the above function
         // gameType and Title
         // gaTitle
         return QuizCardItemTypeEnum(type: "\(title)",
                                     gameType: "\(gameType)",
                                     trackingQuizType: Constants.configData?.dynamicQuizTypeTrackingKey?[title.description]?.trackingKeyQuizTypeEventAction ?? "",
                                     trackingKeyQuizType: String(describing: Constants.configData?.dynamicQuizTypeTrackingKey?[title.description]?.trackingKeyQuizTypeEvent ?? ""))
//         switch id {
//         case 1:
//             return
//         case 2:
//             return  QuizCardItemTypeEnum(type: "2", trackingQuizType: "Daily Quiz", trackingKeyQuizType: String(describing: Constants.configData?.quizTypeTrackingKey?["2"] ?? ""))
//         case 3:
//             return QuizCardItemTypeEnum(type: "3", trackingQuizType: "More or Less", trackingKeyQuizType: String(describing: Constants.configData?.quizTypeTrackingKey?["3"] ?? ""))
//         default:
//             return QuizCardItemTypeEnum(type: "1", trackingQuizType: "Random Quiz", trackingKeyQuizType: String(describing: Constants.configData?.quizTypeTrackingKey?["1"] ?? ""))
//         }
     }
     
     static var isGamingHubHost: Bool {
         
         switch GamingHubCards.environment.clientId {
         case let str where str.contains("GH_"):
             return true
         default:
             return false
         }
         
     }
     @State var isActiveNavigationLink : Bool = false
     
     //MARK: - Notification Sync manager for syncing foreground and backend because sometimes notification channel toggles are not synced or there are few channels left to enable or disable.

     ///USE ONLY IN CASE OF BACKGROUND AND FOREGROUND CHANGE
     
     static func QuizzerNotificationsyncmanager(completion: @escaping () -> Void) {
         
         let operationArray = QUIZTheme.channels
         
         if QUIZTheme.isChannelChangedFromBG {
             
             guard let newChannelStatus = QUIZTheme.QuizzersetChannelFromBGTo else { return }
                 QUIZTheme.updateChannelStatuses(channels: operationArray, newStatus: newChannelStatus) { result in
                     if result {
                         QUIZTheme.channels.removeAll()
                         QUIZTheme.isChannelChangedFromBG = false
                         QUIZTheme.QuizzersetChannelFromBGTo = nil
                         completion()
                     }
                 }
         } else {
             return
         }
         
     }
     
     static func updateChannelStatuses(channels: [GameNotificationChannel], newStatus: Bool, completion: @escaping (Bool) -> Void) {
            var remainingChannels = channels
            var counter = 0

            func updateNextChannel() {
                
                guard counter < 5 else { // Check if counter has reached 5
                      completion(false) // All attempts completed, but potentially not all channels updated
                      return
                    }

                guard let channel = remainingChannels.first else {
                    completion(true) // All channels updated successfully
                    return
                }
                
                counter += 1
                
                GameNotificationsManager.set(newStatus: newStatus, forNotificationChannel: channel) { result in
                    switch result {
                    case .success:
                        remainingChannels.removeFirst()
                        updateNextChannel() // Continue updating remaining channels
                    case .failure:
                        // Retry logic:
                        Constants.print("Error updating channel: \(channel.id). Retrying...")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            updateNextChannel()
                        }
                    }
                }
            }

            updateNextChannel() // Start the chain of updates
        }
}


extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


//MARK: - Navigation bar appearance and styling extenstion
extension UINavigationController {
    func style(style: NavigationBarStyle) {

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        if let font = style.font, let textColor = style.textColor {
            appearance.titleTextAttributes = [.foregroundColor: textColor, .font: UIFont.systemFont(ofSize: 17, weight: .bold)]
            appearance.largeTitleTextAttributes = [.foregroundColor: textColor, .font:  UIFont.systemFont(ofSize: 32, weight: .bold) ]
        }
        
        if let tintColor = style.tintColor {
            let buttonAppearance = UIBarButtonItemAppearance(style: .plain)
            buttonAppearance.normal.titleTextAttributes = [.foregroundColor: tintColor]
            appearance.buttonAppearance = buttonAppearance
            navigationBar.tintColor = tintColor
        }
        
        if let backgroundColor = style.backgroundColor {
            appearance.backgroundColor = backgroundColor
        } else{
            appearance.backgroundColor = UIColor.init(patternImage: UIImage())
        }
         
        if let backgroundImage = style.backgroundImage {
            appearance.backgroundColor = style.backgroundColor
            appearance.backgroundImage = backgroundImage
            appearance.backgroundImageContentMode = .bottomRight
        }else{
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.isTranslucent = true
        }
        navigationBar.prefersLargeTitles =  true
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance =  appearance
    }
    
    func onExitQuizzerGame_restore_old_style(style: NavigationBarStyle, appearance: UINavigationBarAppearance? = nil) {
        var restoreappearance : UINavigationBarAppearance?
        
        if appearance == nil {
            restoreappearance = UINavigationBarAppearance()
        } else {
            restoreappearance = appearance
        }
        
        guard let app = restoreappearance else { return }
        
        app.configureWithTransparentBackground()
        
        if let font = style.font, let textColor = style.textColor {
            app.titleTextAttributes = [.foregroundColor: textColor, .font: UIFont.systemFont(ofSize: 17, weight: .bold)]
            app.largeTitleTextAttributes = [.foregroundColor: textColor, .font:  UIFont.systemFont(ofSize: 32, weight: .bold) ]
        }
        
        if let tintColor = style.tintColor {
            let buttonAppearance = UIBarButtonItemAppearance(style: .plain)
            buttonAppearance.normal.titleTextAttributes = [.foregroundColor: tintColor]
            app.buttonAppearance = buttonAppearance
            navigationBar.tintColor = tintColor
        }
        
        if let backgroundColor = style.backgroundColor {
            app.backgroundColor = backgroundColor
        } else{
            app.backgroundColor = UIColor.init(patternImage: UIImage())
        }
         
        if let backgroundImage = style.backgroundImage {
            app.backgroundColor = style.backgroundColor
            app.backgroundImage = backgroundImage
            app.backgroundImageContentMode = .bottomRight
        }else{
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.isTranslucent = true
        }
        
        navigationBar.prefersLargeTitles = QUIZTheme.originalNavBarprefersLargeTitles ?? false
        navigationBar.standardAppearance = app
        navigationBar.scrollEdgeAppearance = app
        navigationBar.compactAppearance =  app
    }
    
    struct NavigationBarStyle {
        
        var font: UIFont?//
        var textColor: UIColor?
        var tintColor: UIColor?
        var backgroundImage: UIImage?
        var shadowImage: UIImage?
        var isTranslucent: Bool?
        var backgroundColor: UIColor?

        static func clear() -> NavigationBarStyle {
            var style = NavigationBarStyle()
           // style.font = UIFont.customFont(customFont: .SF_UI_Bold, size: 18)
            style.textColor = UIColor(QUIZTheme.getColor(named: .QPSDKWhite))
            style.tintColor = UIColor(QUIZTheme.getColor(named: .QPSDKWhite))
//            style.backgroundImage = UIImage()
            style.shadowImage = UIImage()
            style.isTranslucent = false
            style.backgroundColor = UIColor.init(patternImage: UIImage())
            return style
        }

        static func blue() -> NavigationBarStyle {
            var style = NavigationBarStyle()
            style.font =  UIFont.systemFont(ofSize: 14.0, weight: .regular)
            style.textColor = UIColor(QUIZTheme.getColor(named: .QPSDKWhite))
            style.tintColor = UIColor(QUIZTheme.getColor(named: .QPSDKWhite))
            //style.backgroundImage = UIImage()
            //style.shadowImage = UIImage()
            style.isTranslucent = false
            style.backgroundColor = UIColor(QUIZTheme.getColor(named: .QSDK_000FAA))
            return style
        }
        
        static func customColor(color: UIColor) -> NavigationBarStyle {
            var style = NavigationBarStyle()
           // style.font = UIFont.customFont(customFont: .SF_UI_Bold, size: 18)
            style.textColor = UIColor(QUIZTheme.getColor(named: .QPSDKWhite))
            style.tintColor = UIColor(QUIZTheme.getColor(named: .QPSDKWhite))
            //style.shadowImage = UIImage()
            style.isTranslucent = false
            style.backgroundColor = UIColor(QUIZTheme.getColor(named: .QSDK_000FAA))
            return style
        }
        
        static func darkColor(color: UIColor) -> NavigationBarStyle {
            var style = NavigationBarStyle()
            //style.font = UIFont.customFont(customFont: .SF_UI_Bold, size: 18)
            style.textColor = UIColor(QUIZTheme.getColor(named: .QPSDKWhite))
            style.tintColor = UIColor(QUIZTheme.getColor(named: .QPSDKWhite))
            //style.backgroundImage = UIImage()
            //style.shadowImage = UIImage()
            style.isTranslucent = false
            style.backgroundColor = color
            return style
        }
        
        static func withBgImage(image: UIImage,color: UIColor) -> NavigationBarStyle {
            var style = NavigationBarStyle()
            style.font =  UIFont.systemFont(ofSize: 24.0, weight: .regular)
            style.textColor = UIColor(QUIZTheme.getColor(named: .QPSDKWhite))
            style.tintColor = UIColor(QUIZTheme.getColor(named: .QPSDKWhite))
            style.backgroundImage = image
           // style.shadowImage = UIImage()
            style.isTranslucent = false
            style.backgroundColor = color
            return style
        }
        
        static func withBgImageEuro(image: UIImage) -> NavigationBarStyle {
            var style = NavigationBarStyle()
            style.font = UIFont.systemFont(ofSize: 24.0, weight: .regular)
            style.textColor = UIColor.white
            style.tintColor = UIColor.white
            style.backgroundImage = image
            //style.shadowImage = UIImage()
            style.isTranslucent = false
            style.backgroundColor = UIColor(QUIZTheme.getColor(named: .QSDK_143CDB))
            return style
        }
        
        static func eraseallstyles() -> NavigationBarStyle {
            let style = NavigationBarStyle()
            return style
        }
        
    }
    
    
}
