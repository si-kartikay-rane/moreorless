//
//  MlScoreBoard.swift
//  quiz
//
//  Created by Vishal Vijayvargiya on 15/02/24.
//

import SwiftUI
import GamesLib

struct MlScoreBoard: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel =  MLGameViewModel()
    @StateObject private var viewLoginModel = SplashVM()
    @State private var playAgain = false
    @State var cardData:QuizCardListData? = nil
    @State private var orientation = UIDevice.current.orientation
    @Binding  var Observer:Bool
    @State private var PasstoAnotherView = false
    @State var isLandscape : Bool = false
    @Binding var PlayAgainvalue:Bool
    @State private var isPresentingActivityView = false
    @State private var sourceRect: CGRect = .zero
    @State private var isPresentingiPadActivityView = false
    @State private var isPresentingiPhoneActivityView = false
    @State var isDeepLinkLeaderboard:Bool = false
    @State var isDeepgameplay:Bool = false
    @State var quizID:String = ""
    @State var quizIDType:String = ""
    @State var Lottie_Height_iPad : CGFloat = 0
    @State var Lottie_Height_iPhone : CGFloat = 0
    @State var showLeaderBoardView = false
    @State var isloginTrue = false
    @State private var current_screen_name = "/quiz-score-"
    @State var loadText:String = "-"
    @State private var ObserveNotifications = false
    @Binding var isActive : Bool
    var passnillGameplaydetail : Gameplaydetail? =  nil
    let sharedata =  Constants.configData?.socialShareGameSpecific?.quizResult
    var timerdata: timerData? {viewModel.timerData}
    var isEitherValid: Bool {
        (timerdata?.nextQuizHrLeft != "" || timerdata?.nextQuizMinLeft != "") &&
        (timerdata?.nextQuizHrLeft != nil && timerdata?.nextQuizMinLeft != nil)
    }
    
    //@State var analyticsDomainName: String
      //@State var analyticsData: TrackingParameters
    
    @State var analyticsDomainName: String = ""
    @State var analyticsData: TrackingParameters = TrackingParameters([:] as [String: Any?]?)
    
    var body: some View {
        ZStack{
            //            let timerdata = viewModel.timerData
            //            let isHrLeftValid : Bool = timerdata?.nextQuizHrLeft != nil && timerdata?.nextQuizHrLeft != 0
            //            let isMinLeftValid : Bool = timerdata?.nextQuizMinLeft != nil && timerdata?.nextQuizMinLeft != 0
            QUIZTheme.getColor(named: .QSDK_0A0A61).ignoresSafeArea()
            VStack(spacing:0){
                AdsPresentedbyView(VerticaleEnable: false, analyticsDomainName: self.analyticsDomainName, analyticsData: self.analyticsData)
                ZStack{
                    BackgroundView
                    if QUIZTheme.isIpad{
                        quizIpadBg
                    }else{
                        quizIphoneBg
                    }
                }
                VStack(spacing:12){
                    
                    if viewModel.isDisable && GamingHubCards.isLoggedIn{
                        if QUIZTheme.isIpad{
                            loggedInQuizIpad
                        }else{
                            loggedInQuizIphone
                        }
                    }else{
                        if QUIZTheme.isIpad{
                            loggedOutQuizIpad
                        }else{
                            loggedOutQuizIphone
                        }
                    }
                    
                }.frame(width: QUIZTheme.isIpad ? 400 : UIScreen.screenWidth-32)
                    .padding([.vertical],12)
                
                    .padding([.horizontal],16)
                    .navigationBarBackButtonHidden(true)
                    .navigationTitle(cardData?.title ?? "")
                
            }
            //            NavigationLink("", destination: HomeLandingView(stopObserver: $PasstoAnotherView, isDeepLinkLeaderboard: $isDeepLinkLeaderboard,isDeepGame: $isDeepgameplay, quizID: $quizID, quizIDType: $quizIDType),isActive: $playAgain)
            //            NavigationLink("", destination: HomeLandingView(stopObserver: $PasstoAnotherView, isDeepLinkLeaderboard: $isDeepLinkLeaderboard,isDeepGame: $isDeepgameplay, quizID: $quizID, quizIDType: $quizIDType),isActive: $isloginTrue)
            NavigationLink("", destination: LeaderboardView(quizId:cardData?.qzQuizMasterid ?? "" , quizIdType: "\(cardData?.quiztypeid ?? 0)").navigationBarTitleDisplayMode(.inline),isActive:$showLeaderBoardView)
        }.ignoresSafeArea(.keyboard, edges: .bottom)
            .overlay(
                
                isPresentingiPhoneActivityView ? ActivityViewPresenter(isPresented: $isPresentingiPhoneActivityView, items: [loadText.getTranslationValue(default: "") as Any,URL(string: shareURls.scorescreen + (QUIZTheme.currentGameID ?? "uclquiz"))!, QUIZTheme.QuizScreenShotKey
                                                                                                                             
                                                                                                                            ])
                { completed, returnedItems, activityError in
                    isPresentingiPhoneActivityView = false
                    viewModel.isHiddenLottie =  false
                }
                
                
                
                : nil)
            .navigationBarItems(
                
                trailing:
                    
                    Button(action: {
                        if  NetworkWrapper.isInternerConnected(){
                            
                            viewModel.isHiddenLottie =  true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                                if QUIZTheme.isIpad {
                                    isPresentingiPadActivityView = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                        viewModel.isHiddenLottie =  false
                                    }
                                } else {
                                    isPresentingiPhoneActivityView = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                        viewModel.isHiddenLottie =  false
                                    }
                                }
                            }
                            
                            //Track.shared.event(event:  cardData?.quiztypeid != 2 ? .shareresultfun : .shareresultdaily, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID)
                            
                            let G4A = QuizzerAnalyticsShareResults(quizType: QUIZTheme.eventTypeData(title: cardData?.gatitle ?? "-", gameType: cardData?.gaPageTitle ?? "-"))
                            Track.shared.event(G4A: G4A, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID, quizTitle: cardData?.gatitle, gaPageTitle: cardData?.gaPageTitle ?? "-")
                            
                        }
                        
                    }) {
                        Image(uiImage: QUIZTheme.getImage(named: QuizImageName.QSDKShare.name) ?? UIImage())
                        
                    }
                    .popover(isPresented: $isPresentingiPadActivityView) {
                        
                        MNTCustSimplyShareViewController(activityItems: [loadText.getTranslationValue(default: "") as Any,URL(string: shareURls.scorescreen + (QUIZTheme.currentGameID ?? "uclquiz"))!, QUIZTheme.QuizScreenShotKey]){ completed, returnedItems, activityError in
                            isPresentingiPadActivityView = false
                            viewModel.isHiddenLottie = false
                        }
                        
                    }
                
            )
            .quizOnRotate { newOrientation in
                if !Observer {
                    orientation = newOrientation
                }
                QUIZTheme.updateViewLayout()
            }
        
            .onAppear{
                self.viewModel.resultApiCall()
                ObserveNotifications =  true
//                self.viewModel.resultApiCall()
                current_screen_name = "/quiz-score-" + (self.cardData?.gametype ?? "mol")
                self.loadText = self.sharedata?.loadText?.replacingOccurrences(of: NetworkConstants().urlKeys.quizType, with: "\(self.cardData?.quiztypeid ?? 0)") ?? ""
                BusterHelper.shared.updateBuster(type: .LEADERBOARD)
                
                 if QUIZTheme.currentGameID == "uwclquiz" || QUIZTheme.currentGameID == "uclquiz" {
                    QUIZTheme.currentnavigation!.style(style: .withBgImage(image: QUIZTheme.getImage(named: QuizImageName.QSDKNavigationBG.name) ?? UIImage(),color:UIColor(QUIZTheme.getColor(named: .QSDK_NavImage051139))))
                }else if QUIZTheme.currentGameID == "euroquiz"{
                    QUIZTheme.currentnavigation!.style(style: .withBgImageEuro(image: QUIZTheme.getImage(named: QuizImageName.QSDK_EurosTopNavigationBar.name) ?? UIImage()))
                } else {
                    QUIZTheme.currentnavigation!.style(style: .blue())
                }
                
                orientation = UIDevice.current.orientation
                Observer = false
                
                let (analyticsDomainName, analyticsData) = Track.shared.get_screen_domain_params(screen: current_screen_name, params: [:], replace2: (Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: cardData?.qzQuizMasterid ?? "",quizTitle: cardData?.gatitle, gaPageTitle: self.cardData?.gaPageTitle)
                
                self.analyticsDomainName = analyticsDomainName
                self.analyticsData = analyticsData
                
                GamingHubCards.registerTrackingDefaults(analyticsData, domain: analyticsDomainName, gameId: QUIZTheme.currentGameID ?? "uclquiz")
                
                self.analyticsDomainName = analyticsDomainName
                self.analyticsData = analyticsData
                
                Track.shared.screen(screen: current_screen_name, params: [:], replace2: (Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: cardData?.qzQuizMasterid ?? "",quizTitle: cardData?.gatitle, gaPageTitle: self.cardData?.gaPageTitle)
                
                Track.shared.trackSponsor(slot: "header", analyticsDomainName: analyticsDomainName, analyticsData: analyticsData)
                if QuizzGameSDk.game.sponsorModel?.imageUrl == nil {
                    //Ad Hide Height
                    if QUIZTheme.isIpad {
                        if (744...1023).contains(UIScreen.screenWidth) {
                            self.Lottie_Height_iPad = 575
                        } else {
                            self.Lottie_Height_iPad = 525
                        }
                        
                    } else {
                        self.Lottie_Height_iPhone = 250
                    }
                    
                } else {
                    //AD show Height
                    if QUIZTheme.isIpad {
                        if (744...1023).contains(UIScreen.screenWidth) {
                            self.Lottie_Height_iPad = 475
                        } else {
                            self.Lottie_Height_iPad = 575
                        }
                        
                    } else {
                        self.Lottie_Height_iPhone = 300
                    }
                }
            }
            .onDisappear {
                
                Observer = true
                viewModel.QuizResultCalucate = nil
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("Login"))) { notification in
                isloginTrue =  true
                isActive  =  false
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
                if ObserveNotifications {
                    viewModel.QuizResultCalucate = nil
                    
                }
            }
        
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                if ObserveNotifications {
                    
                    self.viewModel.resultApiCall()
                    
                }
            }
        
        
    }
    
    var quizIpadBg: some View{
        Group
        {
            //            let timerdata = viewModel.timerData
            //            let isHrLeftValid : Bool = timerdata?.nextQuizHrLeft != nil && timerdata?.nextQuizHrLeft != 0
            //            let isMinLeftValid : Bool = timerdata?.nextQuizMinLeft != nil && timerdata?.nextQuizMinLeft != 0
            
            if orientation.isLandscape || QUIZTheme.sizeChnage{
                VStack{
                    TitleView.frame(width: 400).padding([.vertical],32)
                    HStack(spacing:32){
                        ScrollView{
                            VStack(spacing:16){
                                ScoreCardview
                                
                            }
                        }
                        ScrollView{
                            
                            RankCardview
                            if isEitherValid{
                                if GamingHubCards.isLoggedIn{
                                    NextQuizTimerview
                                }
                            }
                        }
                    }.frame(width: 775)
                }
            }else{
                ScrollView{
                    VStack(spacing:32){
                        TitleView
                        VStack(spacing:12){
                            ScoreCardview
                            RankCardview
                            if isEitherValid{
                                if GamingHubCards.isLoggedIn{
                                    NextQuizTimerview
                                }
                            }
                        }
                    }.padding(.all,16)
                        .frame(width: QUIZTheme.isIpad ? 400 : UIScreen.screenWidth)
                }
            }
        }
    }
    
    var quizIphoneBg: some View{
        ScrollView{
            //            let timerdata = viewModel.timerData
            //            let isHrLeftValid : Bool = timerdata?.nextQuizHrLeft != nil && timerdata?.nextQuizHrLeft != 0
            //            let isMinLeftValid : Bool = timerdata?.nextQuizMinLeft != nil && timerdata?.nextQuizMinLeft != 0
            VStack(spacing:12){
                VStack(spacing:0){
                    TitleView
                }.padding(.bottom,12)
                ScoreCardview
                RankCardview
                if isEitherValid{
                    if GamingHubCards.isLoggedIn{
                        NextQuizTimerview
                    }
                }
            }.padding(.all,16)
                .frame(width: QUIZTheme.isIpad ? 400 : UIScreen.screenWidth)
        }
        
    }
    
    var loggedInQuizIpad : some View{
        
        HStack(spacing: 16){
            
            Button(action: {
                if  NetworkWrapper.isInternerConnected(){
                    self.presentationMode.wrappedValue.dismiss()
                    self.PlayAgainvalue =  false
                    
                    //                                    Track.shared.event(event: .playagian, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID)
                    //
                    let G4A = QuizzerAnalyticsPlayAgain(quizType: QUIZTheme.eventTypeData(title: cardData?.gatitle ?? "-", gameType: cardData?.gaPageTitle ?? "-"))
                    
                    Track.shared.event(G4A: G4A, name: current_screen_name + (self.cardData?.gametype ?? "mol"), params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID,quizTitle: cardData?.gatitle, gaPageTitle: cardData?.gaPageTitle)
                    
                }
            }) {
                VStack(alignment: .center, spacing: 5) {
                    Text(AppStrings.result_play_again_button_3.getTranslationValue(default: "play Again"))
                        .font(Font.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 14))
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                }
                .foregroundColor(QUIZTheme.getColor(named: .QSDKButtonTitle00004B))
                .background(QUIZTheme.getColor(named: .QPSDKPrimary))
                .cornerRadius(14)
            }.frame(maxWidth: .infinity)
            
            
            Button(action: {
                if  NetworkWrapper.isInternerConnected(){
                    playAgain =  true
                    self.isActive = false
                    
                    //                                    Track.shared.event(event:  cardData?.quiztypeid != 2 ? .gotoarenafunlogin : .gotoarenadailylogin, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID)
                    //
                    QuizzGameSDk.game.store.setGuestData(data: nil)
                    UserDefaultsData.shared.setCodableDataToUserDefaults(codableData:self.passnillGameplaydetail , forKey: "GuestData" + (QUIZTheme.currentGameID ?? "uclquiz"))
                    let G4A = QuizzerAnalyticsGoToQuizArena(quizType: QUIZTheme.eventTypeData(title:cardData?.gatitle ?? "-", gameType: cardData?.gaPageTitle ?? "-"), isLoggedIn: GamingHubCards.isLoggedIn)
                    Track.shared.event(G4A: G4A, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID, quizTitle: cardData?.gatitle, gaPageTitle: cardData?.gaPageTitle)
                    
                }
            }) {
                VStack(alignment: .center, spacing: 5) {
                    Text(AppStrings.result_go_back_button_text_3.getTranslationValue(default: "Go to Quiz Arena"))
                        .font(Font.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 14))
                        .frame(maxWidth: .infinity)
                        .foregroundColor(QUIZTheme.getColor(named: .QPSDKPrimary))
                        .padding()
                }.clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(QUIZTheme.getColor(named: .QPSDKPrimary), lineWidth: 1))
                
            }.frame(maxWidth: .infinity)
                .background(QUIZTheme.getColor(named: .QSDK_0A0A61))
        }
    }
    
    var loggedInQuizIphone: some View{
        VStack(spacing: 16){
            
            Button(action: {
                if  NetworkWrapper.isInternerConnected(){
                    self.presentationMode.wrappedValue.dismiss()
                    self.PlayAgainvalue =  false
                    
                    //                                    Track.shared.event(event: .playagian, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID)
                    //
                    let G4A = QuizzerAnalyticsPlayAgain(quizType: QUIZTheme.eventTypeData(title:cardData?.gatitle ?? "-", gameType: cardData?.gaPageTitle ?? "-"))
                    Track.shared.event(G4A: G4A, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID, quizTitle: cardData?.gatitle, gaPageTitle: cardData?.gaPageTitle)
                    
                }
            }) {
                VStack(alignment: .center, spacing: 5) {
                    Text(AppStrings.result_play_again_button_3.getTranslationValue(default: "play Again"))
                        .font(Font.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 14))
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                }
                .foregroundColor(QUIZTheme.getColor(named: .QSDKButtonTitle00004B))
                .background(QUIZTheme.getColor(named: .QPSDKPrimary))
                .cornerRadius(14)
            }.frame(maxWidth: .infinity)
            
            
            Button(action: {
                if  NetworkWrapper.isInternerConnected(){
                    playAgain =  true
                    self.isActive = false
                    
                    //                                    Track.shared.event(event:  cardData?.quiztypeid != 2 ? .gotoarenafunlogin : .gotoarenadailylogin, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID)
                    //
                    QuizzGameSDk.game.store.setGuestData(data: nil)
                    UserDefaultsData.shared.setCodableDataToUserDefaults(codableData:self.passnillGameplaydetail , forKey: "GuestData" + (QUIZTheme.currentGameID ?? "uclquiz"))
                    let G4A = QuizzerAnalyticsGoToQuizArena(quizType: QUIZTheme.eventTypeData(title:cardData?.gatitle ?? "-", gameType: cardData?.gaPageTitle ?? "-"), isLoggedIn: GamingHubCards.isLoggedIn)
                    Track.shared.event(G4A: G4A, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID, quizTitle: cardData?.gatitle, gaPageTitle: cardData?.gaPageTitle)
                    
                }
            }) {
                VStack(alignment: .center, spacing: 5) {
                    Text(AppStrings.result_go_back_button_text_3.getTranslationValue(default: "Go to Quiz Arena"))
                        .font(Font.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 14))
                        .frame(maxWidth: .infinity)
                        .foregroundColor(QUIZTheme.getColor(named: .QPSDKPrimary))
                        .padding()
                }.clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(QUIZTheme.getColor(named: .QPSDKPrimary), lineWidth: 1))
                
            }.frame(maxWidth: .infinity)
                .background(QUIZTheme.getColor(named: .QSDK_0A0A61))
        }
        
    }
    
    var loggedOutQuizIpad: some View{
        HStack{
            if !GamingHubCards.isLoggedIn{
                if !self.viewLoginModel.isLogin{
                    Button(action: {
                        if  NetworkWrapper.isInternerConnected(){
                            GamingHubCards.login(QUIZTheme.currentGameID ?? "uclquiz")
                            
                            //                                            Track.shared.event(event:  cardData?.quiztypeid != 2 ? .scorelogintoplayfun : .scorelogintoplaydaily, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID)
                            
                            
                            let G4A = QuizzerAnalyticsLoginOrRegister(quizType: QUIZTheme.eventTypeData(title:cardData?.gatitle ?? "-", gameType: cardData?.gaPageTitle ?? "-"))
                            Track.shared.event(G4A: G4A, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID, quizTitle: cardData?.gatitle, gaPageTitle: cardData?.gaPageTitle)
                            
                        }
                    }) {
                        VStack(alignment: .center, spacing: 5) {
                            Text(AppStrings.login_or_register.getTranslationValue(default: "Log in or register"))
                                .font(Font.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 14))
                                .frame(maxWidth: .infinity)
                                .padding()
                            
                        }
                        .foregroundColor(QUIZTheme.getColor(named: .QSDKButtonTitle00004B))
                        .background(QUIZTheme.getColor(named: .QPSDKPrimary))
                        .cornerRadius(14)
                    }.frame(maxWidth: .infinity)
                    Button(action: {
                        if  NetworkWrapper.isInternerConnected(){
                            playAgain =  true
                            self.isActive = false
                            //                                            Track.shared.event(event:  cardData?.quiztypeid != 2 ? .gotoarenafunlogout : .gotoarenadailylogout, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID)
                            QuizzGameSDk.game.store.setGuestData(data: nil)
                            UserDefaultsData.shared.setCodableDataToUserDefaults(codableData:self.passnillGameplaydetail , forKey: "GuestData" + (QUIZTheme.currentGameID ?? "uclquiz"))
                            let G4A = QuizzerAnalyticsGoToQuizArena(quizType: QUIZTheme.eventTypeData(title:cardData?.gatitle ?? "-", gameType: cardData?.gaPageTitle ?? "-"), isLoggedIn: GamingHubCards.isLoggedIn)
                            Track.shared.event(G4A: G4A, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID, quizTitle: cardData?.gatitle, gaPageTitle: cardData?.gaPageTitle)
                            
                        }
                    }) {
                        VStack(alignment: .center, spacing: 5) {
                            Text(AppStrings.result_go_back_button_text_3.getTranslationValue(default: "Go to Quiz Arena"))
                                .font(Font.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 14))
                                .frame(maxWidth: .infinity)
                                .foregroundColor(QUIZTheme.getColor(named: .QPSDKPrimary))
                                .padding()
                        }.clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(QUIZTheme.getColor(named: .QPSDKPrimary), lineWidth: 1))
                        
                    }.frame(maxWidth: .infinity)
                        .background(QUIZTheme.getColor(named: .QSDK_0A0A61))
                }
            }else{
                Button(action: {
                    if  NetworkWrapper.isInternerConnected(){
                        playAgain =  true
                        self.isActive = false
                        //                                        Track.shared.event(event:  cardData?.quiztypeid != 2 ? .gotoarenafunlogin : .gotoarenadailylogin, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID)
                        QuizzGameSDk.game.store.setGuestData(data: nil)
                        UserDefaultsData.shared.setCodableDataToUserDefaults(codableData:self.passnillGameplaydetail , forKey: "GuestData" + (QUIZTheme.currentGameID ?? "uclquiz"))
                        let G4A = QuizzerAnalyticsGoToQuizArena(quizType:QUIZTheme.eventTypeData(title:cardData?.gatitle ?? "-", gameType: cardData?.gaPageTitle ?? "-"), isLoggedIn: GamingHubCards.isLoggedIn)
                        Track.shared.event(G4A: G4A, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID, quizTitle: cardData?.gatitle, gaPageTitle: cardData?.gaPageTitle)
                        
                    }
                }) {
                    VStack(alignment: .center, spacing: 5) {
                        Text(AppStrings.result_go_back_button_text_3.getTranslationValue(default: "Go to Quiz Arena"))
                            .font(Font.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 14))
                            .frame(maxWidth: .infinity)
                            .padding()
                    }.foregroundColor(QUIZTheme.getColor(named: .QSDKButtonTitle00004B))
                        .background(QUIZTheme.getColor(named: .QPSDKPrimary))
                        .cornerRadius(14)
                }.frame(maxWidth: .infinity)
            }
        }
        
    }
    
    var loggedOutQuizIphone: some View{
        VStack{
            if !GamingHubCards.isLoggedIn{
                if !self.viewLoginModel.isLogin{
                    Button(action: {
                        if  NetworkWrapper.isInternerConnected(){
                            GamingHubCards.login(QUIZTheme.currentGameID ?? "uclquiz")
                            //                                            Track.shared.event(event:  cardData?.quiztypeid != 2 ? .scorelogintoplayfun : .scorelogintoplaydaily, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID)
                            
                            
                            let G4A = QuizzerAnalyticsLoginOrRegister(quizType:QUIZTheme.eventTypeData(title:cardData?.gatitle ?? "-", gameType: cardData?.gaPageTitle ?? "-"))
                            Track.shared.event(G4A: G4A, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID, quizTitle: cardData?.gatitle, gaPageTitle: cardData?.gaPageTitle)
                            
                        }
                    }) {
                        VStack(alignment: .center, spacing: 5) {
                            Text(AppStrings.login_or_register.getTranslationValue(default: "Log in or register"))
                                .font(Font.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 14))
                                .frame(maxWidth: .infinity)
                                .padding()
                            
                        }
                        .foregroundColor(QUIZTheme.getColor(named: .QSDKButtonTitle00004B))
                        .background(QUIZTheme.getColor(named: .QPSDKPrimary))
                        .cornerRadius(14)
                    }.frame(maxWidth: .infinity)
                }
                Button(action: {
                    if  NetworkWrapper.isInternerConnected(){
                        playAgain =  true
                        self.isActive = false
                        //                                        Track.shared.event(event:  cardData?.quiztypeid != 2 ? .gotoarenafunlogout : .gotoarenadailylogout, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID)
                        QuizzGameSDk.game.store.setGuestData(data: nil)
                        UserDefaultsData.shared.setCodableDataToUserDefaults(codableData:self.passnillGameplaydetail , forKey: "GuestData" + (QUIZTheme.currentGameID ?? "uclquiz"))
                        let G4A = QuizzerAnalyticsGoToQuizArena(quizType:QUIZTheme.eventTypeData(title:cardData?.gatitle ?? "-", gameType: cardData?.gaPageTitle ?? "-"), isLoggedIn: GamingHubCards.isLoggedIn)
                        
                        Track.shared.event(G4A: G4A, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID, quizTitle: cardData?.gatitle, gaPageTitle: cardData?.gaPageTitle)
                        
                    }
                }) {
                    VStack(alignment: .center, spacing: 5) {
                        Text(AppStrings.result_go_back_button_text_3.getTranslationValue(default: "Go to Quiz Arena"))
                            .font(Font.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 14))
                            .frame(maxWidth: .infinity)
                            .foregroundColor(QUIZTheme.getColor(named: .QPSDKPrimary))
                            .padding()
                    }.clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(QUIZTheme.getColor(named: .QPSDKPrimary), lineWidth: 1))
                    
                }
                .background(QUIZTheme.getColor(named: .QSDK_0A0A61))
            }else{
                Button(action: {
                    if  NetworkWrapper.isInternerConnected(){
                        playAgain =  true
                        self.isActive = false
                        //                                    Track.shared.event(event:  cardData?.quiztypeid != 2 ? .gotoarenafunlogin : .gotoarenadailylogin, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID)
                        QuizzGameSDk.game.store.setGuestData(data: nil)
                        UserDefaultsData.shared.setCodableDataToUserDefaults(codableData:self.passnillGameplaydetail , forKey: "GuestData" + (QUIZTheme.currentGameID ?? "uclquiz"))
                        let G4A = QuizzerAnalyticsGoToQuizArena(quizType:QUIZTheme.eventTypeData(title:cardData?.gatitle ?? "-", gameType: cardData?.gaPageTitle ?? "-"), isLoggedIn: GamingHubCards.isLoggedIn)
                        Track.shared.event(G4A: G4A, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID, quizTitle: cardData?.gatitle, gaPageTitle: cardData?.gaPageTitle)
                    }
                }) {
                    VStack(alignment: .center, spacing: 5) {
                        Text(AppStrings.result_go_back_button_text_3.getTranslationValue(default: "Go to Quiz Arena"))
                            .font(Font.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 14))
                            .frame(maxWidth: .infinity)
                            .padding()
                    }.foregroundColor(QUIZTheme.getColor(named: .QSDKButtonTitle00004B))
                        .background(QUIZTheme.getColor(named: .QPSDKPrimary))
                        .cornerRadius(14)
                }.frame(maxWidth: .infinity)
            }
        }
    }
    
    var BackgroundView: some View{
        ZStack{
            
            //            Image(uiImage:QUIZTheme.getImage(named:QuizImageName.scoreBg.name) ?? UIImage()).resizable()
            backgroundImageView
            if let isShow = viewModel.QuizResultCalucate, isShow.showConfetti {
                if QUIZTheme.isIpad{
                    if viewModel.isHiddenLottie{
                        
                    }else{
                        HStack{
                            ZStack{
//                                LottieView().background(Color.clear)
                            }
                            Spacer(minLength: 100)
                            ZStack{
//                                LottieView().background(Color.clear)
                            }
                        }
                    }
                }else{
                    if viewModel.isHiddenLottie{
                        
                    }else{
//                        LottieView()
                    }
                }
            }
        }
    }
    
    private var backgroundImageView: Image {
        if !QUIZTheme.isIpad {
            return Image(uiImage:QUIZTheme.getImage(named:QuizImageName.scoreBg.name) ?? UIImage()).resizable()
        } else if orientation.isLandscape {
            return Image(uiImage:QUIZTheme.getImage(named:QuizImageName.scoreBglandscape.name) ?? UIImage()).resizable()
        } else {
            return Image(uiImage:QUIZTheme.getImage(named:QuizImageName.scoreBg.name) ?? UIImage()).resizable()
        }
    }
    
    var TitleView:some View{
        VStack(spacing:10){
            
            let hedline = viewModel.QuizResultCalucate?.heading.replacingOccurrences(of: NetworkConstants().urlKeys.quizType, with: "\(self.cardData?.quiztypeid ?? 0)")
            
            let Descriptiontext = viewModel.QuizResultCalucate?.description.replacingOccurrences(of: NetworkConstants().urlKeys.quizType, with: "\(self.cardData?.quiztypeid ?? 0)")
            
            Text((hedline ?? "" ).getTranslationValue(default: "")).textCase(.uppercase)
                .font((QUIZTheme.currentGameID  == "euroquiz") ? .customFont(customFont:  .UEFAEuro_HeavyNarrow, size: 40) : .customFont(customFont: .Champions_Display, size: 48) )
                .foregroundColor(QUIZTheme.getColor(named: .QSDK_FF16FF))
            Text((Descriptiontext ?? "").getTranslationValue(default: "")).multilineTextAlignment(.center)
                .font(.swiftUICustomFont(customFont: .SF_UI_Medium, size: 16))
                .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
        }
        
    }
    
    var ScoreCardview: some View{
        VStack(alignment:.leading){
            Text(AppStrings.result_your_score_3.getTranslationValue(default:"Your score"))
                .font(.swiftUICustomFont(customFont: .SF_UI_Medium, size: 20))
                .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                .padding(.all,16)
            
            HStack(spacing:16){
                TimmerView(totalScore: self.viewModel.MLResultScore?.outofscore ?? .zero,currentScore: self.viewModel.MLResultScore?.totpoints ?? .zero).padding(.bottom,20)
                VStack{
                    HStack {
                        VStack(alignment: .leading){
                            Text(AppStrings.result_correct_answer_3.getTranslationValue(default:"Correct answers"))
                                .font(.swiftUICustomFont(customFont: .SF_UI_Medium, size: 14))
                                .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                            HStack{
                                Text(AppStrings.correct_ans_desc_quiz.getTranslationValue(default:"x {point} points").replacingOccurrences(of: "{point}", with: "\(viewModel.perquestionpoint)"))
                                    .font(.swiftUICustomFont(customFont: .SF_UI_Regular, size: 12))
                                    .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite).opacity(0.7))
                                Spacer()
                                
                            }
                        }
                        Spacer()
                        Text("\(viewModel.MLResultScore?.rightans ?? 0)")
                            .font(.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 20))
                            .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                    }
                    Divider().background(QUIZTheme.getColor(named: .QPSDKWhite).opacity(0.3))
                    
                }
                
            }.padding([.horizontal],16)
            
            
        }.background(QUIZTheme.getColor(named: .QSDK_0A0A61))
            .cornerRadius(14)
    }
    
    var RankCardview: some View{
        ZStack{
            QUIZTheme.getColor(named: .QSDK_0A0A61).ignoresSafeArea()
            HStack(spacing:0){
                
                VStack{
                    if GamingHubCards.isLoggedIn{
                        Button(action: {
                            if  NetworkWrapper.isInternerConnected(){
                                showLeaderBoardView =  true
                                let G4A = QuizzerAnalyticsViewRanking(quizType:  QUIZTheme.eventTypeData(title: cardData?.gatitle ?? "-", gameType: cardData?.gaPageTitle ?? "-"), isLoggedIn: GamingHubCards.isLoggedIn)
                                Track.shared.event(G4A: G4A, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID, quizTitle: cardData?.gatitle, gaPageTitle: cardData?.gaPageTitle)
                            }
                        }, label: {
                            VStack(alignment:.leading,spacing: 4){
                                HStack {
                                    Text(AppStrings.result_your_rank_for_this_quiz_3.getTranslationValue(default: "Your ranking for this quiz"))
                                    Spacer()
                                    Text("\(viewModel.MLResultScore?.rank ?? .zero)")
                                }.font(.swiftUICustomFont(customFont: .SF_UI_Medium, size: 16))
                                    .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                                
                                Text(AppStrings.result_your_rank_at_quiz_3.getTranslationValue(default: "You’re in the top {userPercentage}% of all players!").replacingOccurrences(of: NetworkConstants().urlKeys.userPercentage, with: "\(viewModel.MLResultScore?.pctl ?? .zero)")).multilineTextAlignment(.leading)
                                    .font(.swiftUICustomFont(customFont: .SF_UI_Regular, size: 14))
                                    .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite).opacity(0.7))
                            }.padding(.all,20)
                            
                        })
                    }else{
                        VStack(alignment:.leading,spacing: 4){
                            Text(AppStrings.result_guest_rank_message_3.getTranslationValue(default: "Want to see where you ranked?"))
                                .font(.swiftUICustomFont(customFont: .SF_UI_Medium, size: 16))
                                .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                            
                            Text(AppStrings.result_guest_position_message_3.getTranslationValue(default: "Log in or create an account to save your score and challenge your friends!")).multilineTextAlignment(.leading)
                                .font(.swiftUICustomFont(customFont: .SF_UI_Regular, size: 14))
                                .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite).opacity(0.7))
                        }.padding(.all,20)
                    }
                }
                
            }
        }
        .cornerRadius(14)
    }
    var NextQuizTimerview: some View {
        ZStack {
            var timerdata = viewModel.timerData
            VStack(alignment: .center, spacing: 4) {
                Text(AppStrings.result_next_quiz_start_in.getTranslationValue(default: "Next quiz starts in"))
                    .multilineTextAlignment(.center)
                    .font(.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 20))
                
                HStack {
                    VStack {
                        Text(timerdata?.nextQuizHrLeft?.description ?? "")
                            .font(.swiftUICustomFont(customFont: .Champions_Bold, size: 48))
                        Text(AppStrings.result_next_quiz_hours.getTranslationValue(default: "Hours"))
                            .font(.swiftUICustomFont(customFont: .SF_UI_Medium, size: 12))
                    }
                    Text(":")
                        .padding(.bottom, 15)
                        .font(.swiftUICustomFont(customFont: .Champions_Bold, size: 48))
                    VStack {
                        Text(timerdata?.nextQuizMinLeft?.description ?? "")
                            .font(.swiftUICustomFont(customFont: .Champions_Bold, size: 48))
                        Text(AppStrings.result_next_quiz_minute.getTranslationValue(default: "Minutes"))
                            .font(.swiftUICustomFont(customFont: .SF_UI_Medium, size: 12))
                    }
                }
            }
            .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.all, 16)
            //            }
        }
        .background(QUIZTheme.getColor(named: .QSDK_0A0A61))
        .cornerRadius(14)
        
    }
    
    
    
    func captureScreenshot() -> UIImage {
        guard let window = UIApplication.shared.windows.first else {
            return UIImage()
        }
        
        let renderer = UIGraphicsImageRenderer(size: window.bounds.size)
        let screenshot = renderer.image { _ in
            window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
        }
        
        return screenshot
    }
}


