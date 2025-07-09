//
//  QuizScoreBoard.swift
//  uclquiz
//
//  Created by Vishal Vijayvargiya on 04/09/23.
//

import SwiftUI
import GamesLib

struct QuizScoreBoard: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel =  QuizViewModel()
     @StateObject private var viewLoginModel = SplashVM()
    @State private var playAgain = false
    @State var cardData:QuizCardListData? =  nil
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
    @Binding var isActive : Bool
    @State private var ObserveNotifications = false
    @ObservedObject var notificationsvm : QuizNotificationsViewModel
    var passnillGameplaydetail : Gameplaydetail? =  nil
    let sharedata =  Constants.configData?.socialShare?.quizResult
    var timerdata: timerData? {viewModel.timerData}
    var isEitherValid: Bool {
        (timerdata?.nextQuizHrLeft != "" || timerdata?.nextQuizMinLeft != "") &&
        (timerdata?.nextQuizHrLeft != nil && timerdata?.nextQuizMinLeft != nil)
    }
    
    @State var analyticsDomainName: String = ""
    @State var analyticsData: TrackingParameters = TrackingParameters([:] as [String: Any?]?)
    
    var body: some View {
        ZStack{
            MOLTheme.getColor(named: .QSDK_0A0A61).ignoresSafeArea()
            if MOLTheme.currentGameID != "uclquiz"{
                BackgroundView
            }
            VStack(spacing:0.0){
                AdsPresentedbyView(VerticaleEnable: false, analyticsDomainName: self.analyticsDomainName, analyticsData: self.analyticsData)
                ZStack{
                    if MOLTheme.currentGameID == "uclquiz"{
                        BackgroundView
                    }
                    ScrollView{
                        if MOLTheme.isIpad{
                            quizIpadbg
                        }else{
                            quizIphoneBg
                        }
                    }
                }.padding(0)
                VStack(spacing:0){
                    Divider().background(MOLTheme.getColor(named: .QPSDKWhite)).opacity(0.2)
                    VStack(spacing:12){
                        
                        if viewModel.timerData?.isdisable == 0 && GamingHubCards.isLoggedIn{
                            if MOLTheme.isIpad{
                                quizLoggedInIpad
                            }else{
                                quizLoggedInIphone
                            }
                        }else{
                            if MOLTheme.isIpad{
                                quizLoggedOutIpad
                            }else{
                                quizLoggedOutIphone
                            }
                        }
                        
                    }
                    .frame(width: MOLTheme.isIpad ? 400 : UIScreen.screenWidth-32)
                    .padding([.top,.bottom],12)
                    .padding([.leading,.trailing],16)
                    .background(MOLTheme.getColor(named: .QSDK_0A0A61))
                    .navigationBarBackButtonHidden(true)
                    .navigationTitle(cardData?.title ?? "")
                }
                .frame(width:UIScreen.main.bounds.width)
                .background(MOLTheme.getColor(named: .QSDK_0A0A61))

            }

            NavigationLink("", destination: LeaderboardView(quizId:cardData?.qzQuizMasterid ?? "" , quizIdType: "\(cardData?.quiztypeid ?? 0)").navigationBarTitleDisplayMode(.inline),isActive:$showLeaderBoardView)
        }.ignoresSafeArea(.keyboard, edges: .bottom)
            .popup(isPresented: $notificationsvm.showNotificationChannelPopUp, type: !MOLTheme.isIpad ? .floater(verticalPadding: 0, useSafeAreaInset: true) : .default, position: .bottom, dragToDismiss: false,closeOnTap: false, closeOnTapOutside: true, backgroundColor: .black.opacity(0.4)) {
                NoticationPopView(notificationPopUp: $notificationsvm.showNotificationChannelPopUp)
            }
            .popup(isPresented: $notificationsvm.showToast, type: !MOLTheme.isIpad ? .floater(verticalPadding: 0, useSafeAreaInset: false) : .floater(verticalPadding: 0, useSafeAreaInset: false), position: .bottom, autohideIn: 2.5,dragToDismiss: true, closeOnTap: false, closeOnTapOutside: false, backgroundColor: .black.opacity(0.0)) {
                NotificationToastView(showToast: $notificationsvm.showToast)
            }
        .overlay(
            
            isPresentingiPhoneActivityView ? ActivityViewPresenter(isPresented: $isPresentingiPhoneActivityView, items: [sharedata?.loadText?.getTranslationValue(default: "") as Any,URL(string: shareURls.scorescreen + (MOLTheme.currentGameID ?? "uclquiz"))!, MOLTheme.QuizScreenShotKey
                                                                                       
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
                                if MOLTheme.isIpad {
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
                          
                            let G4A = QuizzerAnalyticsShareResults(quizType:MOLTheme.eventTypeData(title: cardData?.gatitle ?? "-", gameType: cardData?.gaPageTitle ?? "-"))
                            Track.shared.event(G4A: G4A, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID, quizTitle: cardData?.gatitle, gaPageTitle: cardData?.gaPageTitle,gaPageSubType: cardData?.gaPageSubType)
                            
                        }
                        
                    }) {
                    Image(uiImage: MOLTheme.getImage(named: QuizImageName.QSDKShare.name) ?? UIImage())
                    
                    }
                .popover(isPresented: $isPresentingiPadActivityView) {
                    MNTCustSimplyShareViewController(activityItems: [sharedata?.loadText?.getTranslationValue(default: "") as Any,URL(string: shareURls.scorescreen + (MOLTheme.currentGameID ?? "uclquiz"))!, MOLTheme.QuizScreenShotKey]){ completed, returnedItems, activityError in
                            isPresentingiPadActivityView = false
                        viewModel.isHiddenLottie = false
                    }
                            
                    }
              
        )
        .quizOnRotate { newOrientation in
            if !Observer {
                orientation = newOrientation
            }
            MOLTheme.updateViewLayout()
        }
        
        .onAppear{
            self.viewModel.ScoreCardApiCall()
            current_screen_name = "/quiz-score-" + (self.cardData?.gametype ?? "")
            
            BusterHelper.shared.updateBuster(type: .LEADERBOARD)
           
            if MOLTheme.currentGameID == "uclquiz" || MOLTheme.currentGameID == "weuroquiz"{
                MOLTheme.currentnavigation!.style(style: .withBgImage(image: MOLTheme.getImage(named: QuizImageName.QSDKNavigationBG.name) ?? UIImage(),color:UIColor(MOLTheme.getColor(named: .QSDK_NavImage051139))))
            }else if MOLTheme.currentGameID == "uwclquiz" {
                MOLTheme.currentnavigation!.style(style: .withBgImage(image: MOLTheme.getImage(named: QuizImageName.QSDKNavigationBG.name) ?? UIImage(),color:UIColor(MOLTheme.getColor(named: .QSDK_NavImage051139))))
            }else if MOLTheme.currentGameID == "euroquiz"{
                MOLTheme.currentnavigation!.style(style: .withBgImageEuro(image: MOLTheme.getImage(named: QuizImageName.QSDK_EurosTopNavigationBar.name) ?? UIImage()))
            } else {
                MOLTheme.currentnavigation!.style(style: .blue())
            }
            orientation = UIDevice.current.orientation
            Observer = false
            
            let (analyticsDomainName, analyticsData) = Track.shared.get_screen_domain_params(screen: current_screen_name, params: [:], replace2: (Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: cardData?.qzQuizMasterid ?? "", quizTitle: self.cardData?.gatitle, gaPageTitle: self.cardData?.gaPageTitle, gaPageSubType: self.cardData?.gaPageSubType)
            GamingHubCards.registerTrackingDefaults(analyticsData, domain: analyticsDomainName, gameId: MOLTheme.currentGameID ?? "uclquiz")
            
            self.analyticsDomainName = analyticsDomainName
            self.analyticsData = analyticsData
            
            Track.shared.screen(screen: current_screen_name, params: [:], replace2: (Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: cardData?.qzQuizMasterid ?? "", quizTitle: self.cardData?.gatitle, gaPageTitle: self.cardData?.gaPageTitle, gaPageSubType: self.cardData?.gaPageSubType)
            Track.shared.trackSponsor(slot: "header", analyticsDomainName: analyticsDomainName, analyticsData: analyticsData)
            if QuizzGameSDk.game.sponsorModel?.imageUrl == nil {
                //Ad Hide Height
                if MOLTheme.isIpad {
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
                if MOLTheme.isIpad {
                    if (744...1023).contains(UIScreen.screenWidth) {
                    self.Lottie_Height_iPad = 475
                } else {
                    self.Lottie_Height_iPad = 575
                }
                    
                } else {
                    self.Lottie_Height_iPhone = 300
                }
            }
            ObserveNotifications =  true
        }
        .onDisappear {
            ObserveNotifications =  false
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
             
                self.viewModel.ScoreCardApiCall()
               
            }
        }
    }
    
    var quizIpadbg: some View{
        Group{
            if orientation.isLandscape || MOLTheme.sizeChnage{
                VStack{
                    TitleView.frame(width: 400).padding([.top,.bottom],32)
                    HStack(spacing:32){
//                        ScrollView{
                            VStack(spacing:16){
                                ScoreCardview
                                if isEitherValid{
                                    RankCardview
                                }
                            }
//                        }
//                        ScrollView{
                            if isEitherValid {
                                if GamingHubCards.isLoggedIn{
                                    NextQuizTimerview
                                }
                            }else{
                                RankCardview
                            }
//                        }
                    }.frame(width: 775)
                }
            }else{
//                ScrollView{
                    VStack(spacing:12){
                        TitleView
                        ScoreCardview
                        RankCardview
                        if GamingHubCards.isLoggedIn{
                            if Constants.configData?.isShowNotificationCard == true{
                                if notificationsvm.showNotificationCard == true {
                                    if let savedDate = UserDefaults.standard.value(forKey: "notificationPopupDismissTimeStamp") as? Date {
                                        let numberOfDays = Calendar.current.dateComponents([.day], from: savedDate, to: Date())
                                        if (numberOfDays.day ?? 0) >= 30 {
                                            NotificationsView(notificationsvm: notificationsvm)
                                        }
                                    }else{
                                        NotificationsView(notificationsvm: notificationsvm)
                                    }
                                }
                            }
                        }
                        if isEitherValid{
                            if GamingHubCards.isLoggedIn{
                                NextQuizTimerview
                            }
                        }
                        
                    }.padding(.all,16)
                        .frame(width: MOLTheme.isIpad ? 400 : UIScreen.screenWidth)
//                }
            }
        }
    }
    
    var quizIphoneBg: some View{
//        ScrollView{
            VStack(spacing:12){
                TitleView.padding([.top,.bottom],5)
                ScoreCardview
                RankCardview
                if GamingHubCards.isLoggedIn{
                    if Constants.configData?.isShowNotificationCard == true{
                        if notificationsvm.showNotificationCard == true {
                            if let savedDate = UserDefaults.standard.value(forKey: "notificationPopupDismissTimeStamp") as? Date {
                                let numberOfDays = Calendar.current.dateComponents([.day], from: savedDate, to: Date())
                                if (numberOfDays.day ?? 0) >= 30 {
                                    NotificationsView(notificationsvm: notificationsvm)
                                }
                            }else{
                                NotificationsView(notificationsvm: notificationsvm)
                            }
                        }
                    }
                }
                if isEitherValid{
                    if GamingHubCards.isLoggedIn{
                        NextQuizTimerview
                    }
                }
                
            }.padding([.leading,.trailing,.bottom],16)
                .frame(width: MOLTheme.isIpad ? 400 : UIScreen.screenWidth)
//        }
    }
    
    var quizLoggedInIpad: some View{
            HStack(spacing: 16){
                Button(action: {
                    if  NetworkWrapper.isInternerConnected(){
                        self.presentationMode.wrappedValue.dismiss()
                        self.PlayAgainvalue =  false
                        
                        //                                    Track.shared.event(event: .playagian, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID)
                        //
                        let G4A = QuizzerAnalyticsPlayAgain(quizType: MOLTheme.eventTypeData(title: cardData?.gatitle ?? "-", gameType: cardData?.gaPageTitle ?? "-"))
                        Track.shared.event(G4A: G4A, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID, quizTitle: cardData?.gatitle, gaPageTitle: cardData?.gaPageTitle)
                        
                    }
                }) {
                    VStack(alignment: .center, spacing: 5) {
                        Text(AppStrings.result_play_again_button_3.getTranslationValue(default: "play Again"))
                            .font(Font.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 14))
                            .frame(maxWidth: .infinity)
                            .padding()
                        
                    }
                    .foregroundColor(MOLTheme.getColor(named: .QSDKButtonTitle00004B))
                    .background(MOLTheme.getColor(named: .QPSDKPrimary))
                    .cornerRadius(14)
                }.frame(maxWidth: .infinity)
                
                
                Button(action: {
                    if  NetworkWrapper.isInternerConnected(){
                        playAgain =  true
                        self.isActive = false
                        
                        //                                    Track.shared.event(event:  cardData.quiztypeid != 2 ? .gotoarenafunlogin : .gotoarenadailylogin, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID)
                        //
                        QuizzGameSDk.game.store.setGuestData(data: nil)
                        UserDefaultsData.shared.setCodableDataToUserDefaults(codableData:self.passnillGameplaydetail , forKey: "GuestData" + (MOLTheme.currentGameID ?? "uclquiz"))
                        let G4A = QuizzerAnalyticsGoToQuizArena(quizType: MOLTheme.eventTypeData(title: cardData?.gatitle ?? "-", gameType: cardData?.gaPageTitle ?? "-"), isLoggedIn: GamingHubCards.isLoggedIn)
                        Track.shared.event(G4A: G4A, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID, quizTitle: cardData?.gatitle, gaPageTitle: cardData?.gaPageTitle)
                        
                    }
                }) {
                    VStack(alignment: .center, spacing: 5) {
                        Text(AppStrings.result_go_back_button_text_3.getTranslationValue(default: "Go to Quiz Arena"))
                            .font(Font.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 14))
                            .frame(maxWidth: .infinity)
                            .foregroundColor(MOLTheme.getColor(named: .QPSDKPrimary))
                            .padding()
                    }.clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(MOLTheme.getColor(named: .QPSDKPrimary), lineWidth: 1))
                    
                }.frame(maxWidth: .infinity)
                    .background(MOLTheme.getColor(named: .QSDK_0A0A61))
            }
            .background(MOLTheme.getColor(named: .QSDK_0A0A61))
    }
    
    var quizLoggedOutIpad: some View{

            HStack{
            if !GamingHubCards.isLoggedIn{
                if !self.viewLoginModel.isLogin{
                    Button(action: {
                        if  NetworkWrapper.isInternerConnected(){
                            GamingHubCards.login(MOLTheme.currentGameID ?? "uclquiz")
                            
//                                            Track.shared.event(event:  cardData.quiztypeid != 2 ? .scorelogintoplayfun : .scorelogintoplaydaily, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID)
                            
                            
                            let G4A = QuizzerAnalyticsLoginOrRegister(quizType: MOLTheme.eventTypeData(title: cardData?.gatitle ?? "-", gameType: cardData?.gaPageTitle ?? "-"))
                            Track.shared.event(G4A: G4A, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID, quizTitle: cardData?.gatitle, gaPageTitle: cardData?.gaPageTitle)
                            
                        }
                    }) {
                        VStack(alignment: .center, spacing: 5) {
                            Text(AppStrings.login_or_register.getTranslationValue(default: "Log in or register"))
                                .font(Font.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 14))
                                .frame(maxWidth: .infinity)
                                .padding()
                            
                        }
                        .foregroundColor(MOLTheme.getColor(named: .QSDKButtonTitle00004B))
                        .background(MOLTheme.getColor(named: .QPSDKPrimary))
                        .cornerRadius(14)
                    }.frame(maxWidth: .infinity)
                    Button(action: {
                        if  NetworkWrapper.isInternerConnected(){
                            playAgain =  true
                            self.isActive = false
//                                            Track.shared.event(event:  cardData.quiztypeid != 2 ? .gotoarenafunlogout : .gotoarenadailylogout, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID)
                            QuizzGameSDk.game.store.setGuestData(data: nil)
                            UserDefaultsData.shared.setCodableDataToUserDefaults(codableData:self.passnillGameplaydetail , forKey: "GuestData" + (MOLTheme.currentGameID ?? "uclquiz"))
                            let G4A = QuizzerAnalyticsGoToQuizArena(quizType:MOLTheme.eventTypeData(title: cardData?.gatitle ?? "-", gameType: cardData?.gaPageTitle ?? "-"), isLoggedIn: GamingHubCards.isLoggedIn)
                            Track.shared.event(G4A: G4A, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID, quizTitle: cardData?.gatitle, gaPageTitle: cardData?.gaPageTitle)
                            
                        }
                    }) {
                        VStack(alignment: .center, spacing: 5) {
                            Text(AppStrings.result_go_back_button_text_3.getTranslationValue(default: "Go to Quiz Arena"))
                                .font(Font.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 14))
                                .frame(maxWidth: .infinity)
                                .foregroundColor(MOLTheme.getColor(named: .QPSDKPrimary))
                                .padding()
                        }.clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(MOLTheme.getColor(named: .QPSDKPrimary), lineWidth: 1))
                        
                    }.frame(maxWidth: .infinity)
                        .background(MOLTheme.getColor(named: .QSDK_0A0A61))
                }
            }else{
                Button(action: {
                    if  NetworkWrapper.isInternerConnected(){
                        playAgain =  true
                        self.isActive = false
//                                        Track.shared.event(event:  cardData.quiztypeid != 2 ? .gotoarenafunlogin : .gotoarenadailylogin, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID)
                        QuizzGameSDk.game.store.setGuestData(data: nil)
                        UserDefaultsData.shared.setCodableDataToUserDefaults(codableData:self.passnillGameplaydetail , forKey: "GuestData" + (MOLTheme.currentGameID ?? "uclquiz"))
                        let G4A = QuizzerAnalyticsGoToQuizArena(quizType:MOLTheme.eventTypeData(title: cardData?.gatitle ?? "-", gameType: cardData?.gaPageTitle ?? "-"), isLoggedIn: GamingHubCards.isLoggedIn)
                        Track.shared.event(G4A: G4A, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID,quizTitle: cardData?.gatitle, gaPageTitle: cardData?.gaPageTitle)
                        
                    }
                }) {
                    VStack(alignment: .center, spacing: 5) {
                        Text(AppStrings.result_go_back_button_text_3.getTranslationValue(default: "Go to Quiz Arena"))
                            .font(Font.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 14))
                            .frame(maxWidth: .infinity)
                            .padding()
                    }.foregroundColor(MOLTheme.getColor(named: .QSDKButtonTitle00004B))
                        .background(MOLTheme.getColor(named: .QPSDKPrimary))
                        .cornerRadius(14)
                }.frame(maxWidth: .infinity)
            }
        }
            .background(MOLTheme.getColor(named: .QSDK_0A0A61))
    }
    
    var quizLoggedInIphone: some View{
            VStack(spacing: 16){
                
                Button(action: {
                    if  NetworkWrapper.isInternerConnected(){
                        self.presentationMode.wrappedValue.dismiss()
                        self.PlayAgainvalue =  false
                        
                        //                                    Track.shared.event(event: .playagian, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID)
                        //
                        let G4A = QuizzerAnalyticsPlayAgain(quizType: MOLTheme.eventTypeData(title: cardData?.gatitle ?? "-", gameType: cardData?.gaPageTitle ?? "-"))
                        Track.shared.event(G4A: G4A, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID, quizTitle: cardData?.gatitle, gaPageTitle: cardData?.gaPageTitle, gaPageSubType: cardData?.gaPageSubType)
                        
                    }
                }) {
                    VStack(alignment: .center, spacing: 5) {
                        Text(AppStrings.result_play_again_button_3.getTranslationValue(default: "play Again"))
                            .font(Font.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 14))
                            .frame(maxWidth: .infinity)
                            .padding()
                        
                    }
                    .foregroundColor(MOLTheme.getColor(named: .QSDKButtonTitle00004B))
                    .background(MOLTheme.getColor(named: .QPSDKPrimary))
                    .cornerRadius(14)
                }.frame(maxWidth: .infinity)
                
                
                Button(action: {
                    if  NetworkWrapper.isInternerConnected(){
                        playAgain =  true
                        self.isActive = false
                        
                        //                                    Track.shared.event(event:  cardData.quiztypeid != 2 ? .gotoarenafunlogin : .gotoarenadailylogin, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID)
                        //
                        QuizzGameSDk.game.store.setGuestData(data: nil)
                        UserDefaultsData.shared.setCodableDataToUserDefaults(codableData:self.passnillGameplaydetail , forKey: "GuestData" + (MOLTheme.currentGameID ?? "uclquiz"))
                        let G4A = QuizzerAnalyticsGoToQuizArena(quizType: MOLTheme.eventTypeData(title: cardData?.gatitle ?? "-", gameType: cardData?.gametype ?? "-"), isLoggedIn: GamingHubCards.isLoggedIn)
                        Track.shared.event(G4A: G4A, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID, quizTitle: cardData?.gaPageTitle, gaPageTitle: cardData?.gaPageTitle, gaPageSubType: cardData?.gaPageSubType)
                        
                    }
                }) {
                    VStack(alignment: .center, spacing: 5) {
                        Text(AppStrings.result_go_back_button_text_3.getTranslationValue(default: "Go to Quiz Arena"))
                            .font(Font.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 14))
                            .frame(maxWidth: .infinity)
                            .foregroundColor(MOLTheme.getColor(named: .QPSDKPrimary))
                            .padding()
                    }.clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(MOLTheme.getColor(named: .QPSDKPrimary), lineWidth: 1))
                    
                }.frame(maxWidth: .infinity)
                    .background(MOLTheme.getColor(named: .QSDK_0A0A61))
            }
            .background(MOLTheme.getColor(named: .QSDK_0A0A61))
    }
    
    var quizLoggedOutIphone: some View{
        Group
        {
            if !GamingHubCards.isLoggedIn{
                if !self.viewLoginModel.isLogin{
                    Button(action: {
                        if  NetworkWrapper.isInternerConnected(){
                            GamingHubCards.login(MOLTheme.currentGameID ?? "uclquiz")
                            //                                            Track.shared.event(event:  cardData.quiztypeid != 2 ? .scorelogintoplayfun : .scorelogintoplaydaily, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID)
                            
                            
                            let G4A = QuizzerAnalyticsLoginOrRegister(quizType:MOLTheme.eventTypeData(title: cardData?.gatitle ?? "-", gameType: cardData?.gatitle ?? "-"))
                            Track.shared.event(G4A: G4A, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID,quizTitle: cardData?.gaPageTitle, gaPageTitle: cardData?.gaPageTitle, gaPageSubType: cardData?.gaPageSubType)
                            
                        }
                    }) {
                        VStack(alignment: .center, spacing: 5) {
                            Text(AppStrings.login_or_register.getTranslationValue(default: "Log in or register"))
                                .font(Font.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 14))
                                .frame(maxWidth: .infinity)
                                .padding()
                            
                        }
                        .foregroundColor(MOLTheme.getColor(named: .QSDKButtonTitle00004B))
                        .background(MOLTheme.getColor(named: .QPSDKPrimary))
                        .cornerRadius(14)
                    }.frame(maxWidth: .infinity)
                }
                Button(action: {
                    if  NetworkWrapper.isInternerConnected(){
                        playAgain =  true
                        self.isActive = false
                        //                                        Track.shared.event(event:  cardData.quiztypeid != 2 ? .gotoarenafunlogout : .gotoarenadailylogout, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID)
                        QuizzGameSDk.game.store.setGuestData(data: nil)
                        UserDefaultsData.shared.setCodableDataToUserDefaults(codableData:self.passnillGameplaydetail , forKey: "GuestData" + (MOLTheme.currentGameID ?? "uclquiz"))
                        let G4A = QuizzerAnalyticsGoToQuizArena(quizType: MOLTheme.eventTypeData(title: cardData?.gatitle ?? "-", gameType: cardData?.gatitle ?? "-"), isLoggedIn: GamingHubCards.isLoggedIn)
                        Track.shared.event(G4A: G4A, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID, quizTitle: cardData?.gaPageTitle, gaPageTitle: cardData?.gaPageTitle, gaPageSubType: cardData?.gaPageSubType)
                        
                    }
                }) {
                    VStack(alignment: .center, spacing: 5) {
                        Text(AppStrings.result_go_back_button_text_3.getTranslationValue(default: "Go to Quiz Arena"))
                            .font(Font.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 14))
                            .frame(maxWidth: .infinity)
                            .foregroundColor(MOLTheme.getColor(named: .QPSDKPrimary))
                            .padding()
                    }.clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(MOLTheme.getColor(named: .QPSDKPrimary), lineWidth: 1))
                    
                }
                .background(MOLTheme.getColor(named: .QSDK_0A0A61))
            }else{
                Button(action: {
                    if  NetworkWrapper.isInternerConnected(){
                        playAgain =  true
                        self.isActive = false
                        //                                    Track.shared.event(event:  cardData.quiztypeid != 2 ? .gotoarenafunlogin : .gotoarenadailylogin, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID)
                        QuizzGameSDk.game.store.setGuestData(data: nil)
                        UserDefaultsData.shared.setCodableDataToUserDefaults(codableData:self.passnillGameplaydetail , forKey: "GuestData" + (MOLTheme.currentGameID ?? "uclquiz"))
                        
                        let G4A = QuizzerAnalyticsGoToQuizArena(quizType:MOLTheme.eventTypeData(title: cardData?.gatitle ?? "-", gameType: cardData?.gatitle ?? "-"), isLoggedIn: GamingHubCards.isLoggedIn)
                        Track.shared.event(G4A: G4A, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID, quizTitle: cardData?.gaPageTitle, gaPageTitle: cardData?.gaPageTitle, gaPageSubType: cardData?.gaPageSubType)
                    }
                }) {
                    VStack(alignment: .center, spacing: 5) {
                        Text(AppStrings.result_go_back_button_text_3.getTranslationValue(default: "Go to Quiz Arena"))
                            .font(Font.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 14))
                            .frame(maxWidth: .infinity)
                            .padding()
                    }.foregroundColor(MOLTheme.getColor(named: .QSDKButtonTitle00004B))
                        .background(MOLTheme.getColor(named: .QPSDKPrimary))
                        .cornerRadius(14)
                }.frame(maxWidth: .infinity)
            }
        }
    }
    
    var BackgroundView: some View{
        ZStack{

//            Image(uiImage:MOLTheme.getImage(named:QuizImageName.scoreBg.name) ?? UIImage()).resizable()
            if MOLTheme.isIpad && !MOLTheme.isLandscape{
                backgroundImageView
                .scaledToFill()
            }else{
                if MOLTheme.currentGameID != "uclquiz"{
                    VStack{
                        backgroundImageView
                            .scaledToFill()
                    }
                    .frame(height: UIScreen.main.bounds.height * 0.8)
                        
                }else{
                    backgroundImageView
                }
            }
            if let isShow = viewModel.QuizResultCalucate, isShow.showConfetti, MOLTheme.currentGameID != "weuroquiz"{
                
                if MOLTheme.isIpad{
                    if viewModel.isHiddenLottie{
                        
                    }else{
                        HStack{
                            ZStack{
//                                LottieView()
                            }
                            Spacer(minLength: 100)
                            ZStack{
//                                LottieView()
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
        if !MOLTheme.isIpad {
            return Image(uiImage:MOLTheme.getImage(named:QuizImageName.scoreBg.name) ?? UIImage()).resizable()
        } else if orientation.isLandscape {
            return Image(uiImage:MOLTheme.getImage(named:QuizImageName.scoreBglandscape.name) ?? UIImage()).resizable()
        } else {
            return Image(uiImage:MOLTheme.getImage(named:QuizImageName.scoreBg.name) ?? UIImage()).resizable()
        }
    }
    
    var TitleView:some View{
        VStack(alignment:.center,spacing:10){
            if MOLTheme.currentGameID == "weuroquiz"{
                if viewModel.QuizResultCalucate?.minScore == 0 && viewModel.QuizResultCalucate?.maxScore == 19{
                    Image(uiImage: MOLTheme.getImage(named: QuizImageName.score_Char_1.name) ?? UIImage())
                        .resizable()
                        .frame(width: 160, height: 132)
                }else if viewModel.QuizResultCalucate?.minScore == 20 && viewModel.QuizResultCalucate?.maxScore == 39{
                    Image(uiImage: MOLTheme.getImage(named: QuizImageName.score_Char_1.name) ?? UIImage())
                        .resizable()
                        .frame(width: 160, height: 132)
                }else if viewModel.QuizResultCalucate?.minScore == 40 && viewModel.QuizResultCalucate?.maxScore == 59{
                    Image(uiImage: MOLTheme.getImage(named: QuizImageName.score_Char_2.name) ?? UIImage())
                        .resizable()
                        .frame(width: 160, height: 132)
                }else if viewModel.QuizResultCalucate?.minScore == 60 && viewModel.QuizResultCalucate?.maxScore == 79{
                    Image(uiImage: MOLTheme.getImage(named: QuizImageName.score_Char_3.name) ?? UIImage())
                        .resizable()
                        .frame(width: 160, height: 132)
                }else if viewModel.QuizResultCalucate?.minScore == 80 && viewModel.QuizResultCalucate?.maxScore == 99{
                    Image(uiImage: MOLTheme.getImage(named: QuizImageName.score_Char_4.name) ?? UIImage())
                        .resizable()
                        .frame(width: 160, height: 132)
                }
                else if viewModel.QuizResultCalucate?.minScore == 100{
                    Image(uiImage: MOLTheme.getImage(named: QuizImageName.score_Char_5.name) ?? UIImage())
                        .resizable()
                        .frame(width: 160, height: 132)
                }
                else{
                   
                }
            }
            Text((viewModel.QuizResultCalucate?.heading ?? "").getTranslationValue(default: "")).textCase(.uppercase)
                .font((MOLTheme.currentGameID == "weuroquiz" ? .customFont(customFont: .PFBeauSansPro_Bold, size: 40) : (MOLTheme.currentGameID  == "euroquiz") ? .customFont(customFont:  .UEFAEuro_HeavyExtended, size: 40) : .customFont(customFont: .Champions_Display, size: 48)) )
                .foregroundColor(MOLTheme.getColor(named: .QPSDKWhite))
            if MOLTheme.currentGameID != "weuroquiz"{
                Text((viewModel.QuizResultCalucate?.description ?? "").getTranslationValue(default: "")).multilineTextAlignment(.center)
                    .font(.swiftUICustomFont(customFont: .SF_UI_Medium, size: 16))
                    .foregroundColor(MOLTheme.getColor(named: .QPSDKWhite))
            }
        }
    }
    
    var ScoreCardview: some View{
        VStack(alignment:.leading){
            Text(AppStrings.resultyourscore.getTranslationValue(default:"Your score"))
                .font(.swiftUICustomFont(customFont: .SF_UI_Medium, size: 20))
                .foregroundColor(MOLTheme.getColor(named: .QPSDKWhite))
                .padding(.all,16)
                
            HStack(spacing:16){
                TimmerView(totalScore: GamingHubCards.isLoggedIn ? (viewModel.scoreCardData?.outofscore ?? 0) : ((viewModel.GameAttemptConfigData?.totQues ?? 0) * (viewModel.GameAttemptConfigData?.QuPoint ?? 0)),currentScore: GamingHubCards.isLoggedIn ? viewModel.scoreCardData?.totPoints ?? 0 : viewModel.totalPoint)
                VStack{
                    HStack {
                        VStack(alignment: .leading){
                            Text(AppStrings.correct_answer.getTranslationValue(default:"Correct answers"))
                                .font(.swiftUICustomFont(customFont: .SF_UI_Medium, size: 14))
                                .foregroundColor(MOLTheme.getColor(named: .QPSDKWhite))
                            HStack{
                                Text(AppStrings.correct_ans_desc_quiz.getTranslationValue(default:"x {point} points")
                                    .replacingOccurrences(of: "{point}", with: "\(viewModel.questions?.quPoint ?? 0)"))
                                    .font(.swiftUICustomFont(customFont: .SF_UI_Regular, size: 12))
                                    .foregroundColor(MOLTheme.getColor(named: .QPSDKWhite).opacity(0.7))
                                Spacer()
                                
                            }
                        }
                        Spacer()
                        Text("\( GamingHubCards.isLoggedIn ? viewModel.scoreCardData?.rightAns ?? 0 : showCorrectanscount())")
                            .font(.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 20))
                            .foregroundColor(MOLTheme.getColor(named: .QPSDKWhite))
                    }
                    Divider().background(MOLTheme.getColor(named: .QPSDKWhite).opacity(0.3))
                   if GamingHubCards.isLoggedIn{
                        HStack {
                            VStack(alignment: .leading){
                                Text(AppStrings.score_streaks.getTranslationValue(default:"Streaks"))
                                    .font(.swiftUICustomFont(customFont: .SF_UI_Medium, size: 14))
                                    .foregroundColor(MOLTheme.getColor(named: .QPSDKWhite))
                                HStack{
                                    Text(AppStrings.streak_desc.getTranslationValue(default:"x {point} points").replacingOccurrences(of: "{point}", with: "\(viewModel.questions?.streakBonusPoints ?? 0)"))
                                        .font(.swiftUICustomFont(customFont: .SF_UI_Regular, size: 12))
                                        .foregroundColor(MOLTheme.getColor(named: .QPSDKWhite).opacity(0.7))
                                    Spacer()
                                    
                                }
                            }
                            Spacer()
                            Text("\(viewModel.scoreCardData?.streakCnt ?? 0)")
                                .font(.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 20))
                                .foregroundColor(MOLTheme.getColor(named: .QPSDKWhite))
                        }
                        Divider().background(MOLTheme.getColor(named: .QPSDKWhite).opacity(0.3))
                    }
                }
                
            }.padding([.leading,.trailing],16)
            HStack(alignment: .center){
                StreaksView.padding(.bottom,5)
            }
         
        }.background(MOLTheme.getColor(named: .QSDK_0A0A61))
            .cornerRadius(14)
    }
    
    var RankCardview: some View{
        ZStack{
            MOLTheme.getColor(named: .QSDK_0A0A61).ignoresSafeArea()
            HStack(spacing:0){
            VStack{
                if GamingHubCards.isLoggedIn{
                    Button(action: {
                        if  NetworkWrapper.isInternerConnected(){
                            showLeaderBoardView =  true
                            let G4A = QuizzerAnalyticsViewRanking(quizType: MOLTheme.eventTypeData(title: cardData?.gatitle ?? "-", gameType: cardData?.gaPageTitle ?? "-"), isLoggedIn: GamingHubCards.isLoggedIn)
                            Track.shared.event(G4A: G4A, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID, quizTitle: cardData?.gatitle, gaPageTitle: cardData?.gaPageTitle, gaPageSubType: cardData?.gaPageSubType)
                        }
                    }, label: {
                        VStack(alignment:.leading,spacing: 4){
                            HStack {
                                Text(AppStrings.resultyourrankquiz.getTranslationValue(default: "Your ranking for this quiz"))
                                Spacer()
                                Text("\(viewModel.scoreCardData?.userrank ?? .zero)")
                            }.font(.swiftUICustomFont(customFont: .SF_UI_Medium, size: 16))
                                .foregroundColor(MOLTheme.getColor(named: .QPSDKWhite))
                            
                            Text(AppStrings.resultyourrankatquiz.getTranslationValue(default: "You’re in the top {userPercentage}% of all players!").replacingOccurrences(of: NetworkConstants().urlKeys.userPercentage, with: "\(viewModel.scoreCardData?.pctl ?? 0)")).multilineTextAlignment(.leading)
                                .font(.swiftUICustomFont(customFont: .SF_UI_Regular, size: 14))
                                .foregroundColor(MOLTheme.getColor(named: .QPSDKWhite).opacity(0.7))
                        }.padding(.all,20)
                        
                    })
                }else{
                    VStack(alignment:.leading,spacing: 4){
                        Text(AppStrings.nonLoginScoreRanktitle.getTranslationValue(default: "Want to see where you ranked?"))
                            .font(.swiftUICustomFont(customFont: .SF_UI_Medium, size: 16))
                            .foregroundColor(MOLTheme.getColor(named: .QPSDKWhite))
                        
                        Text(AppStrings.nonLoginScoreRankDescription.getTranslationValue(default: "Log in or create an account to save your score and challenge your friends!")).multilineTextAlignment(.leading)
                            .font(.swiftUICustomFont(customFont: .SF_UI_Regular, size: 14))
                            .foregroundColor(MOLTheme.getColor(named: .QPSDKWhite).opacity(0.7))
                    }.padding(.all,20)
                }
            }
              
        }
        }.cornerRadius(14)
    }
    
    var NextQuizTimerview: some View {
       
        ZStack {
            let timerdata = viewModel.timerData
                VStack(alignment: .center, spacing: 4) {
                    Text(AppStrings.result_next_quiz_start_in.getTranslationValue(default: "Next quiz starts in"))
                        .multilineTextAlignment(.center)
                        .font(.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 20))
                    
                    HStack {
                        VStack {
                            Text(timerdata?.nextQuizHrLeft?.description ?? "")
                                .font(.swiftUICustomFont(customFont: MOLTheme.currentGameID == "weuroquiz" ? .PFBeauSansPro_Bold : .Champions_Bold, size: 48))
                            Text(AppStrings.result_next_quiz_hours.getTranslationValue(default: "Hours"))
                                .font(.swiftUICustomFont(customFont:  MOLTheme.currentGameID == "weuroquiz" ? .SF_UI_Bold : .SF_UI_Medium, size: 12))
                        }
                        Text(":")
                            .padding(.bottom, 15)
                            .font(.swiftUICustomFont(customFont: .Champions_Bold, size: 48))
                        VStack {
                            Text(timerdata?.nextQuizMinLeft?.description ?? "")
                                .font(.swiftUICustomFont(customFont: MOLTheme.currentGameID == "weuroquiz" ? .PFBeauSansPro_Bold : .Champions_Bold, size: 48))
                            Text(AppStrings.result_next_quiz_minute.getTranslationValue(default: "Minutes"))
                                .font(.swiftUICustomFont(customFont: MOLTheme.currentGameID == "weuroquiz" ? .SF_UI_Bold : .SF_UI_Medium, size: 12))
                        }
                    }
                }
                .foregroundColor(MOLTheme.getColor(named: .QPSDKWhite))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.all, 16)
//            }
        }
        .background(MOLTheme.getColor(named: .QSDK_0A0A61))
        .cornerRadius(14)
        
    }
    

    
    var StreaksView: some View {
        
        ScrollView(.horizontal, showsIndicators: false){
            Spacer()
            HStack(alignment: .center,spacing: 5) {
                Spacer()
                ForEach(0..<(GamingHubCards.isLoggedIn ? (viewModel.scoreCardData?.arrQtnCorrect?.count ?? 0) : viewModel.questionansCorrect.count), id: \.self) { index in
                    
                    ZStack {
                        if !GamingHubCards.isLoggedIn{
                            if let questionsCorrect = viewModel.questionansCorrect[safe:index]{
                                if viewModel.questionansCorrect[index].isCorrectAns{
                                    Image(uiImage: MOLTheme.getImage(named: QuizImageName.QSDKAnsCorrect.name) ?? UIImage())
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }else{
                                    Image(uiImage: MOLTheme.getImage(named: QuizImageName.QSDKInCorrect.name) ?? UIImage())
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                            }
                        }else{
                            if let arrQtnCorrect =  viewModel.scoreCardData?.arrQtnCorrect?[safe:index]{
                                if arrQtnCorrect == 1 {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(MOLTheme.getColor(named: .QSDK_0A9504))
                                        .frame(width: 20, height: 20)
                                    
                                    if shouldConnectImage(index: index){
                                        Image(uiImage: MOLTheme.getImage(named: QuizImageName.QSDK_QuestionProgressCorrect.name) ?? UIImage())
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    } else {
                                        Image(uiImage: MOLTheme.getImage(named: QuizImageName.QSDKAnsCorrect.name) ?? UIImage())
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    }
                                }else {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(MOLTheme.getColor(named: .QSDK_CB333B))
                                        .frame(width: 20, height: 20)
                                    
                                    Image(uiImage: MOLTheme.getImage(named: QuizImageName.QSDKInCorrect.name) ?? UIImage())
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                            }
                        }
                    }
                    .overlay(
                        Rectangle()
                            .frame(width: 20, height: 1.5)
                            .foregroundColor(shouldConnect(index: index) ? MOLTheme.getColor(named: .QSDK_0A9504) : .clear)
                            .offset(x: 20, y: 0),
                        alignment: .leading
                    )
                }
                Spacer()
            }
            Spacer()
            .frame(width: (MOLTheme.isIpad ? 400 : UIScreen.screenWidth) - 38)
            .padding(.bottom,5)
        }
    }
    
    func shouldConnectImage(index: Int) -> Bool {
      if  self.viewModel.StreakResultImageScore.count != 0{
            if viewModel.StreakResultImageScore[index]{
                return true
            }else{
                return false
            }
        }
        return false
    }


    func shouldConnect(index: Int) -> Bool {
        if  self.viewModel.StreakResultScore.count != 0{
            if viewModel.StreakResultScore[index]{
                return true
            }else{
                return false
            }
        }
        return false
    }
    
    func showCorrectanscount() -> Int{
        let correctAnswers = self.viewModel.questionansCorrect.filter { $0.isCorrectAns }
        return correctAnswers.count
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
    
    func seTitle(id:Int)->String{
        "quiz_type_title_{quizId}".replacingOccurrences(of: NetworkConstants().urlKeys.quizId, with: "\(id)").getTranslationValue(default: id != 2 ? "Random Quiz" : "Daily Quiz")
    }
}


struct TimmerView: View {
    let totalScore: Int
    let currentScore: Int
    
    var body: some View {
        let percentage = Double(currentScore) / Double(totalScore) // Calculate the completion percentage
        
        return HStack(spacing: 10) {
            ZStack {
                Circle()
                    .stroke(MOLTheme.getColor(named: .QPSDKWhite), lineWidth: 2.5)
                    .opacity(0.3)
                Circle()
                    .trim(from: 0, to: CGFloat(percentage)) // Trim the circle based on the completion percentage
                    .stroke(MOLTheme.getColor(named: MOLTheme.currentGameID  == "euroquiz" ? .QSDK_CB333B : MOLTheme.currentGameID  == "weuroquiz" ? .QSDK_FFAF4E : .QPSDKPrimary), lineWidth: 2.5)
                    .rotationEffect(.degrees(-90))
                VStack{
                    Text("\(currentScore)")
                        .font(.swiftUICustomFont(customFont: MOLTheme.currentGameID  == "euroquiz" ? .UEFAEuro_MediumNarrow : .SF_UI_Medium, size: 32))
                        .foregroundColor(MOLTheme.getColor(named: .QPSDKWhite))
                    Text( AppStrings.result_score_out_of.getTranslationValue(default: " Out of") + " " + "\(totalScore)")
                        .font(.swiftUICustomFont(customFont: MOLTheme.currentGameID  == "euroquiz" ? .UEFAEuro_MediumNarrow : .SF_UI_Regular, size: 14))
                        .foregroundColor(MOLTheme.getColor(named: .QPSDKWhite).opacity(0.7))
                }
            }
            .frame(width: 124, height: 124)
        }
        .foregroundColor(.white)
        
        .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4))
        
    }
}

