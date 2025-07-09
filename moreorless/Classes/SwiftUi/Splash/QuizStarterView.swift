//
//  QuizStarterView.swift
//  quiz
//
//  Created by Milind Trivedi on 14/03/24.
//

import SwiftUI
import GamesLib

struct QuizStarterView: View {
    
    //    @State var stopObserver : Bool
    //    @State var isDeepLinkLeaderboard : Bool
    //    @State var isDeepGamePlay:Bool
    //    @State var quizID : String
    //    @State var quizIDType : String
    //    @State var navigateTo : ConfigModel.DeeplinkRoute
    //
    
    var viewModel = SplashVM()
    
    var initAPIs: InitAPIs = {
        return InitAPIs()
    }()
    //    @State var addShow:Bool =  false
    @State var navBarHidden =  true
    @State var orientation = UIDevice.current.orientation
    @State var take = false
    @State var stopObserver = false
    @State var isLandscape : Bool = false
    @State var navigateTo : ConfigModel.DeeplinkRoute = .none
    @State var timerIsRunning = false
    @State var showUserLogdIn = true
    @State var MoveToHomeView = false
    @State var MoveToLoginView =  false
    @State var showLeaderBoardView = false
    @State var quizID:String = ""
    @State var quizIDType:String = ""
    @State var isDeepLinkLeaderboard:Bool = false
    @State var isDeepLinkGame:Bool = false
    @State var showErrorPopup = false
    @State var error: String = ""
    
    @State var MOlDeepLink:Bool = false
    @StateObject var quizViewModel = HomeLandingViewModel()
    @StateObject var notificationvm = MolNotificationsViewModel()
    @State private var PasstoNavigationView = false
    var passnillGameplaydetail : Gameplaydetail? =  nil
    
    var body: some View {
        ZStack {
            if !MoveToHomeView {
                QuizSplashView()
            } else {
                
                HomeLandingView(stopObserver: $stopObserver)
            }
            
            NavigationLink("", destination: LeaderboardView(quizId:MOLTheme.quizID ?? self.quizID,quizIdType: self.quizIDType).navigationBarTitleDisplayMode(.inline),isActive:$isDeepLinkLeaderboard)
            
//            NavigationLink("", destination:  QuetionAnsView(notificationsvm: notificationvm, cardData: self.quizViewModel.cardSelection, Observer: $stopObserver, PasstoNavigationView: $PasstoNavigationView, isActive: $isDeepLinkGame).navigationBarHidden(false).navigationBarTitleDisplayMode(.inline), isActive: $isDeepLinkGame)
            NavigationLink("", destination: MLQuestionAnsView(cardData: self.quizViewModel.cardSelection,Observer: $stopObserver,PasstoNavigationView: $PasstoNavigationView, isActive: $MOlDeepLink).navigationBarHidden(false).navigationBarTitleDisplayMode(.inline),isActive:$MOlDeepLink)//4
        }
        
        .quizOnRotate { newOrientation in
            if !stopObserver {
                orientation = newOrientation
                MOLTheme.updateViewLayout()
            }
        }
        
        .onAppear {
            DispatchQueue.main.async {
                let env = GamingHubCards.environment.environment
                if env != GamingHubEnvironment.production {
                    if let prevEnv = UserDefaults.standard.string(forKey: "QuizArenaGamingHubEnvironment") {
                        if prevEnv != env.rawValue {
                            //print("WARNING: Environment changed from \(prevEnv) to \(env)")
                            viewModel.resetUserCache()
                            UserDefaults.standard.set(env.rawValue, forKey: "QuizArenaGamingHubEnvironment")
                        }
                    } else {
                        UserDefaults.standard.set(env.rawValue, forKey: "QuizArenaGamingHubEnvironment")
                    }
                }
                
                
                QuizzGameSDk.game.sponsorModel =  nil
                QuizzGameSDk.game.getSponsorsForGame(gameid: MOLTheme.currentGameID, competitionid: MOLTheme.competitionId)
            }
            BusterHelper.shared.updateBuster(type: .LEADERBOARD)
            //Track.shared.screen(screen: screenName.splashScreen, params: [:], replace: nil)
            orientation = UIDevice.current.orientation
            stopObserver = false
            
            // Start a timer when the view appears
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                refreshView()
            }
            
            //MARK: Config Api Call
            initAPIs.getConfigData { configData in
                Constants.configData = configData
                QuizzGameSDk.game.refreshTranslationData { success, error in
                    
                }
            } onFailure: { message in
                self.showErrorPopup = true
                self.error = message
            }
        }
        .onDisappear {
            stopObserver = false
            
            
        }
        .onReceive(NotificationCenter.default.publisher(for: .ghOpenLink)) { notification in
            
            handleOpenLinkNotification(notification)
        }
        
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("game"))) { notification in
            
            self.quizcehckDeepLink(quizid: quizID)
            
        }
        .alert(isPresented: $showErrorPopup) {
            Alert(title: Text(error),
                  message: nil,
                  dismissButton: .default(Text(AppStrings.ok)){
                showErrorPopup = true
            }
            )
        }
    }
    
    
    
    func refreshView(){
        if GamingHubCards.isLoggedIn{
            self.viewModel.loginUserSession { [self] success, errorMessage in
                if success{
                    MoveToHomeView =  true
                    self.viewModel.isLogin =  true
                }else{
                    MoveToHomeView =  true
                    self.viewModel.isLogin =  false
                }
            }
        }else{
            MoveToHomeView =  true
            self.viewModel.isLogin =  false
        }
        if MOLTheme.navigateTo == .leaderboard {
            self.isDeepLinkLeaderboard =  true
            
        }
        
        if MOLTheme.navigateTo == .game{
            self.quizcehckDeepLink(quizid: MOLTheme.quizID ?? quizID)
        }
        navBarHidden = false
    }
}

//MARK: - deeplink Game play check

extension QuizStarterView{
    
    
    func quizcehckDeepLink(quizid:String){
        
        quizViewModel.GameStatustData(quizId:quizid) { detailModel in
            if detailModel != nil{
                
                if (detailModel?.isdisable == 0) {
                    
                    if  GamingHubCards.isLoggedIn{
                        if  detailModel?.gametype == "mol"{
                            self.quizViewModel.cardSelection = MolCardListData(title: detailModel?.quiztitle ?? "", quiztype: nil, subtitle: nil, isdisable: nil, description: nil, qzQuizMasterid:  MOLTheme.quizID ?? quizID, quiztypeid: Int(self.quizIDType) ?? 3, bgimage: nil, cta: nil,rank: nil,points: nil,cardState: nil,showWinner: nil,quizStartDate: nil,quizEndDate: nil,winnerName:nil, gametype: "mol", gatitle: nil, isMediaQuiz: nil, difficultyLevels: nil, isDifficultyApplied: false, defaultDifficulty: nil, difficultyTimer: nil, gaPageTitle: nil, gaPageName: nil, gaPageSubType: nil)
                            
                            MOlDeepLink  =  true
                            
                        }else{
                            
                            self.quizViewModel.cardSelection = MolCardListData(title: detailModel?.quiztitle ?? "", quiztype: nil, subtitle: nil, isdisable: nil, description: nil, qzQuizMasterid: MOLTheme.quizID ?? quizID, quiztypeid: detailModel?.quiztypeid, bgimage: nil, cta: nil,rank: nil,points: nil,cardState: nil,showWinner: nil,quizStartDate: nil,quizEndDate: nil,winnerName:nil, gametype: "quiz", gatitle: nil, isMediaQuiz: detailModel?.isMediaQuiz, difficultyLevels: nil, isDifficultyApplied: false, defaultDifficulty: nil, difficultyTimer: nil, gaPageTitle: nil, gaPageName: nil, gaPageSubType: nil)
                            // self.quizID = .empty
                            isDeepLinkGame  =  true
                            
                            
                            
                        }
                    }else{
                        if  UserDefaults.standard.string(forKey:(MOLTheme.quizID ?? quizID)) !=  (MOLTheme.quizID ?? quizID)  && detailModel?.gametype == "quiz"{
                            self.quizViewModel.cardSelection = MolCardListData(title: detailModel?.quiztitle ?? "", quiztype: nil, subtitle: nil, isdisable: nil, description: nil, qzQuizMasterid:MOLTheme.quizID ?? quizID, quiztypeid: nil, bgimage: nil, cta: nil,rank: nil,points: nil,cardState: nil,showWinner: nil,quizStartDate: nil,quizEndDate: nil,winnerName:nil,gametype: "quiz", gatitle: nil, isMediaQuiz: detailModel?.isMediaQuiz, difficultyLevels: nil, isDifficultyApplied: false, defaultDifficulty: nil, difficultyTimer: nil, gaPageTitle: nil, gaPageName: nil, gaPageSubType: nil)
                            //self.quizID = .empty
                            isDeepLinkGame  =  true
                            
                        }else if UserDefaults.standard.string(forKey:(MOLTheme.quizID ?? quizID)) !=  (MOLTheme.quizID ?? quizID) && detailModel?.gametype == "mol"{
                            
                            
                            self.quizViewModel.cardSelection = MolCardListData(title: detailModel?.quiztitle ?? "", quiztype: nil, subtitle: nil, isdisable: nil, description: nil, qzQuizMasterid: MOLTheme.quizID ?? quizID, quiztypeid: Int(MOLTheme.quizIDType ?? self.quizIDType) ?? 3, bgimage: nil, cta: nil,rank: nil,points: nil,cardState: nil,showWinner: nil,quizStartDate: nil,quizEndDate: nil,winnerName:nil,gametype: "mol", gatitle: nil, isMediaQuiz: nil, difficultyLevels: nil, isDifficultyApplied: false, defaultDifficulty: nil, difficultyTimer: nil, gaPageTitle: nil, gaPageName: nil, gaPageSubType: nil)
                            //self.quizID = .empty
                            MOlDeepLink  =  true
                            
                        }
                        
                    }
                    
                }
                
            }
        }
        
        
        
    }
}
extension QuizStarterView{
    func handleOpenLinkNotification(_ notification: Notification) {
        if  let GAME_DATA =  notification.userInfo{
            
            if let restoreOld = GAME_DATA["restoreOldNavigationBarStyleOnClose"] as? Bool {
                MOLTheme.restore_old_navigation = restoreOld
            }
            
            if let navigationController = GAME_DATA["navigationController"] as? UINavigationController {
                MOLTheme.currentnavigation = navigationController
                MOLTheme.gaming_pushed_navigation = navigationController
                MOLTheme.originalNavBarAppearance = navigationController.navigationBar.standardAppearance.copy()
                MOLTheme.originalNavBarprefersLargeTitles = navigationController.navigationBar.prefersLargeTitles
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
                MOLTheme.originalNavBarStoredStyle = style
            }
            
            if let embededInNavigationController = GAME_DATA["embededInNavigationController"] as? Bool {
                MOLTheme.embeded_In_NavigationController = embededInNavigationController
                
            }
            
            if let dataURL = GAME_DATA["url"] as? URL {
                checkDeeplinkURlAndData(url: dataURL.absoluteString)
            }
            if let dataString = GAME_DATA["url"] as? String {
                if let url = URL(string: dataString) {
                    checkDeeplinkURlAndData(url: dataString)
                }
            }
            // Handle other cases as needed
            if let dataLinkURL = GAME_DATA["link"] as? URL {
                checkDeeplinkURlAndData(url: dataLinkURL.absoluteString)
            }
            
            if let dataLinkString = GAME_DATA["link"] as? String {
                checkDeeplinkURlAndData(url: dataLinkString)
            }
            
        }
        
        
    }
    
    func checkDeeplinkURlAndData(url: String?) {
        // Implement your logic to check and process the deeplink URL
        guard let dataURL = url else {return}
        let linkArray = dataURL.components(separatedBy: "/")
        let routeToGo = linkArray[safe: 5]
        
        switch routeToGo{
        case ConfigModel.DeeplinkRoute.home.rawValue:
            navigateTo = .home
            MoveToHomeView =  true
        case ConfigModel.DeeplinkRoute.leaderboard.rawValue:
            MOLTheme.navigateTo = .leaderboard
            
            quizID = linkArray[safe: 7] ?? ""
            quizIDType = linkArray[safe: 6] ?? ""
            MOLTheme.quizID = linkArray[safe: 7]
            MOLTheme.quizIDType = linkArray[safe: 6]
            
            
            isDeepLinkLeaderboard =  true
            
        case ConfigModel.DeeplinkRoute.game.rawValue:
            
            MOLTheme.navigateTo = .game
            quizID = linkArray[safe: 7] ?? ""
            quizIDType = linkArray[safe: 6] ?? ""
            MOLTheme.quizID = linkArray[safe: 7]
            MOLTheme.quizIDType = linkArray[safe: 6]
            
            quizcehckDeepLink(quizid:quizID)
        default:
            navigateTo = .none
            MoveToHomeView =  true
        }
    }
}

