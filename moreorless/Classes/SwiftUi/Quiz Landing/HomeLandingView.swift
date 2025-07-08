//
//  HomeLandingView.swift
//  Quiz
//
//  Created by Vishal Vijayvargiya on 06/10/23.
//

import SwiftUI
import GamesLib
struct HomeLandingView: View {
    
    @State private var showQuetionAnsView = false
    @State private var orientation = UIDeviceOrientation.unknown
    @State private var PasstoAnotherView = false
    @State private var showLeaderBoardMenu = false
    @State  var showLeaderBoardView = false
    @State  var showMoreLessView = false
    @Binding var stopObserver : Bool
    @State private var PasstoNavigationView = false
    @StateObject var quizViewModel: HomeLandingViewModel = HomeLandingViewModel()
    @StateObject private var viewLoginModel = SplashVM()
    @State private var isLoading = true
    @State private var isPresentingActivityView = false
    @State private var sourceRect: CGRect = .zero
    @State var quizID:String = ""
    @State var quizIDType:String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var current_screen_name = "/landing-page-logged-out"
    @State private var isRefreshing: Bool = false
    @State private var showFloatingMenu: Bool = false
    @State var notificationPopUp = false
    @State var notificationAlertPopUp = false
    @StateObject var notificationvm = QuizNotificationsViewModel()
    @State var analyticsDomainName: String = ""
    @State var analyticsData: TrackingParameters = TrackingParameters([:] as [String: Any?]?)
    
    var body: some View {
        
        ZStack{
            QUIZTheme.getColor(named: .QSDKBackGround_000040).ignoresSafeArea()
            if showFloatingMenu {
                Color.black.opacity(0.001) // Invisible overlay to catch taps
                    .onTapGesture {
                        showFloatingMenu = false
                    }
            }
           if self.quizViewModel.isLoading{
               
                ActivityIndicator(isAnimating:$isLoading, style: .large)
            }else{
            if QUIZTheme.isIpad{
                VStack(spacing: 0.0){
                    AdsPresentedbyView(VerticaleEnable: false, analyticsDomainName: self.analyticsDomainName, analyticsData: self.analyticsData)
                    Spacer(minLength: QUIZTheme.isIpad ? 0 : 16)
                    
                    if orientation.isLandscape || QUIZTheme.sizeChnage{
                        HStack(spacing:32){
                            ScrollView(showsIndicators: false) {
                                VStack(spacing: 20){
                                    ForEach(0..<(quizViewModel.cardList?.count ?? 0), id: \.self) { index in
                                        if let cardIndex = quizViewModel.cardList?[safe:index]{
                                            CardListLandingView(QuizCardListData: cardIndex, tag: index, current_screen_name: self.current_screen_name){ login in
                                                self.quizViewModel.cardSelection = cardIndex
                                                if cardIndex.gametype == "mol"{
                                                    if login{
                                                        showMoreLessView = true
                                                    }else{
                                                        GamingHubCards.login(QUIZTheme.currentGameID ?? "uclquiz")
                                                    }
                                                }else{
                                                    
                                                    if login{
                                                        showQuetionAnsView = true
                                                    }else{
                                                        GamingHubCards.login(QUIZTheme.currentGameID ?? "uclquiz")
                                                    }
                                                }
                                            }
                                            if GamingHubCards.isLoggedIn{
                                                if Constants.configData?.isShowNotificationCard == true{
                                                    if notificationvm.showNotificationCard == true {
                                                        if let savedDate = UserDefaults.standard.value(forKey: "notificationPopupDismissTimeStamp") as? Date {
                                                            let numberOfDays = Calendar.current.dateComponents([.day], from: savedDate, to: Date())
                                                            if (numberOfDays.day ?? 0) >= 30 {
                                                                NotificationsView(notificationsvm: notificationvm)
                                                            }
                                                        } else{
                                                            NotificationsView(notificationsvm: notificationvm)
                                                        }
                                                    }
                                                }
                                            }
                                            if index == 0{
                                                InviteView(current_screen_name: self.current_screen_name)
                                            }
                                        }
                                    }
                                    
                                }.padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0 ))
                            }.pullToRefresh(isRefreshing: $isRefreshing) {
                                refreshData()
                            }
                            ScrollView(showsIndicators: false) {
                                VStack(spacing: 16){
                                    if self.quizViewModel.showHideleaderBoard {
                                        LeaderBoardLandingView(viewModelCard: self.quizViewModel, current_screen_name: self.current_screen_name) { selecterd in
                                            if selecterd{
                                                showLeaderBoardMenu =  true
                                            }
                                        } viewleaderrankAction: { sectionselcted,typeQuiz  in
                                            self.quizID =  "\(sectionselcted)"
                                            self.quizIDType = typeQuiz
                                            self.showLeaderBoardView = true
                                            
                                        }

                                        
                                    }
                                    AdsSponsorsView()
                                        .frame(width: 320)
                                }.padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0 ))
                            }.frame(width:400)
                            
                        }.padding([.leading,.trailing],52)
                        
                    }else {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing:20){
                                
                                ForEach(0..<(quizViewModel.cardList?.count ?? 0), id: \.self) { index in
                                    if let cardIndex = quizViewModel.cardList?[safe:index]{
                                        CardListLandingView(QuizCardListData: cardIndex, tag: index, current_screen_name: current_screen_name){ login in
                                            self.quizViewModel.cardSelection = cardIndex
                                            if cardIndex.gametype == "mol"{
                                                if login{
                                                    showMoreLessView = true
                                                }else{
                                                    GamingHubCards.login(QUIZTheme.currentGameID ?? "uclquiz")
                                                }
                                            }else{
                                                
                                                if login{
                                                    showQuetionAnsView = true
                                                }else{
                                                    GamingHubCards.login(QUIZTheme.currentGameID ?? "uclquiz")
                                                }
                                            }
                                        }
                                        if index == 0{
                                            if GamingHubCards.isLoggedIn{
                                                if Constants.configData?.isShowNotificationCard == true{
                    
                                                    if notificationvm.showNotificationCard == true {
                                                        if let savedDate = UserDefaults.standard.value(forKey: "notificationPopupDismissTimeStamp") as? Date {
                                                            let numberOfDays = Calendar.current.dateComponents([.day], from: savedDate, to: Date())
                                                            if (numberOfDays.day ?? 0) >= 30 {
                                                                NotificationsView(notificationsvm: notificationvm)
                                                            }
                                                        }else{
                                                            NotificationsView(notificationsvm: notificationvm)
                                                        }
                                                    }
                                                }
                                            }
                                            InviteView(current_screen_name: self.current_screen_name)
                                        }
                                    }

                                }
                                AdsSponsorsView()
                                    .frame(width: 320)
                                if self.quizViewModel.showHideleaderBoard {
                                    LeaderBoardLandingView(viewModelCard: self.quizViewModel, current_screen_name: self.current_screen_name) { selecterd in
                                        if selecterd{
                                            showLeaderBoardMenu =  true
                                        }
                                    } viewleaderrankAction: { sectionselcted,typeQuiz  in
                                        self.quizID =  "\(sectionselcted)"
                                        self.quizIDType = typeQuiz
                                        self.showLeaderBoardView = true
                                        
                                    }
                                }
                            }.padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0 ))
                            
                        }.padding([.leading,.trailing],52)
                            .pullToRefresh(isRefreshing: $isRefreshing) {
                                            refreshData()
                                        }
                    }
                }
            }else{
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0.0) {
                        AdsPresentedbyView(VerticaleEnable: false, analyticsDomainName: self.analyticsDomainName, analyticsData: self.analyticsData)
                        VStack(spacing:16){
                            ForEach(0..<(quizViewModel.cardList?.count ?? 0), id: \.self) { index in
                                if let cardIndex = quizViewModel.cardList?[safe:index] {
                                    CardListLandingView(QuizCardListData: cardIndex, tag: index, current_screen_name: self.current_screen_name){ login in
                                        self.quizViewModel.cardSelection = cardIndex
                                        if cardIndex.gametype == "mol"{
                                            if login{
                                                showMoreLessView = true
                                            }else{
                                                GamingHubCards.login(QUIZTheme.currentGameID ?? "uclquiz")
                                            }
                                        }else{
                                            
                                            if login{
                                                showQuetionAnsView = true
                                            }else{
                                                GamingHubCards.login(QUIZTheme.currentGameID ?? "uclquiz")
                                            }
                                        }
                                        
                                        
                                    }
                                    if self.quizViewModel.AdbannerViewOrder != nil{
                                        if index == (self.quizViewModel.AdbannerViewOrder ?? 0) - 2{
                                            AdsSponsorsView().padding([.leading,.trailing],16)
                                        }
                                    }
                                    if self.quizViewModel.InviteViewOrder != nil{
                                        if index == (self.quizViewModel.InviteViewOrder ?? 0 )-2{
                                            if GamingHubCards.isLoggedIn{
                                                if Constants.configData?.isShowNotificationCard == true{
                                                    if notificationvm.showNotificationCard == true {
                                                        if let savedDate = UserDefaults.standard.value(forKey: "notificationPopupDismissTimeStamp") as? Date {
                                                            let numberOfDays = Calendar.current.dateComponents([.day], from: savedDate, to: Date())
                                                            if (numberOfDays.day ?? 0) >= 30 {
                                                                NotificationsView(notificationsvm: notificationvm)
                                                            }
                                                        }else{
                                                            NotificationsView(notificationsvm: notificationvm)
                                                        }
                                                    }
                                                }
                                            }
                                            
                                            InviteView(current_screen_name: self.current_screen_name)
                                        }
                                    }
//
                                    if (self.quizViewModel.cardList?.count ?? 0) == 0 {
                                        if self.quizViewModel.AdbannerViewOrder != nil{
                                            
                                            AdsSponsorsView().padding([.leading,.trailing],16)
                                            
                                        }
                                        if self.quizViewModel.InviteViewOrder != nil{
                                            
                                            InviteView(current_screen_name: self.current_screen_name)
                                            
                                        }
                                    }
                                }
                            }
                            if self.quizViewModel.showHideleaderBoard {
                                LeaderBoardLandingView(viewModelCard: self.quizViewModel, current_screen_name: self.current_screen_name) { selecterd in
                                    if selecterd{
                                        showLeaderBoardMenu =  true
                                    }
                                } viewleaderrankAction: { sectionselcted,typeQuiz  in
                                    self.quizID =  "\(sectionselcted)"
                                    self.quizIDType = typeQuiz
                                    self.showLeaderBoardView = true
                                    
                                }
                            }
                            
                        }.padding(.all,16)
                    }.pullToRefresh(isRefreshing: $isRefreshing) {
                        refreshData()
                    }
                }.padding(.all,0)
                    
                
            }
            NavigationLink("", destination: LeaderBoardsMenuView(),isActive:$showLeaderBoardMenu )
                
//                NavigationLink("", destination:  QuetionAnsView(notificationsvm: notificationvm, cardData: self.quizViewModel.cardSelection, Observer: $PasstoAnotherView, PasstoNavigationView: $PasstoNavigationView, isActive: $showQuetionAnsView).navigationBarTitleDisplayMode(.inline), isActive: $showQuetionAnsView) //1
                
                NavigationLink("", destination: LeaderboardView(quizId: self.quizID,quizIdType: self.quizIDType).navigationBarTitleDisplayMode(.inline),isActive:$showLeaderBoardView)
                NavigationLink("", destination: MLQuestionAnsView(cardData: self.quizViewModel.cardSelection,Observer: $PasstoAnotherView,PasstoNavigationView: $PasstoNavigationView, isActive: $showMoreLessView).navigationBarTitleDisplayMode(.inline),isActive:$showMoreLessView) //3
                
                
        }
        }
        .environmentObject(quizViewModel)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .quizOnRotate { newOrientation in
            if !PasstoAnotherView {
                
                orientation = newOrientation
                QUIZTheme.updateViewLayout()
            }
        }
        
        
        .navigationBarTitle(AppStrings.LandingTitle.getTranslationValue(default: "Quiz Arena"), displayMode: .large)
        .navigationBarItems(
            leading:
                Button(action: {
                    if  NetworkWrapper.isInternerConnected(){
                        if QUIZTheme.restore_old_navigation {
                            //MARK: - Restore nav bar
                            if let originalNavStyle = QUIZTheme.originalNavBarStoredStyle {
                               
                                QUIZTheme.currentnavigation?.onExitQuizzerGame_restore_old_style(style: originalNavStyle, appearance:  QUIZTheme.originalNavBarAppearance)
                            }
                        } else {
                            //MARK: - Handle empty state
                            QUIZTheme.currentnavigation?.style(style: .clear())
                            QUIZTheme.currentnavigation?.onExitQuizzerGame_restore_old_style(style: .eraseallstyles())
                        }
                            GamingHubCards.openMenu()
                    }
                }) {
                    if QUIZTheme.isGamingHubHost {
                        Image(uiImage: QUIZTheme.getImage(named: QuizImageName.QSDK_Menu.name) ?? UIImage())
                    } else {
                        Image(uiImage: QUIZTheme.getImage(named: QuizImageName.QSDK_NavBack.name) ?? UIImage())
                    }
                    
                },
            trailing:
                VStack{
                    if GamingHubCards.isLoggedIn {
                        kebabMenu
                    }
                }
        )
            .navigationBarHidden(false)
            .navigationBarBackButtonHidden(true)
            .onAppear{
                if GamingHubCards.isLoggedIn{
                    UserDefaultsData.shared.homeScreenVisitedCount += 1
                    notificationvm.checkNotificationsPermission()
                }
                DispatchQueue.main.async {
                    QUIZTheme.currentnavigation!.style(style: .withBgImage(image: QUIZTheme.getImage(named: QuizImageName.QSDKNavigationBG.name) ?? UIImage(),color:UIColor(QUIZTheme.getColor(named: .QSDK_NavImage051139))))
                }
           
                if (GamingHubCards.isLoggedIn) {
                    self.current_screen_name = "/landing-page-logged-in"
                } else {
                    self.current_screen_name = "/landing-page-logged-out"
                }
                
                let (analyticsDomainName, analyticsData) = Track.shared.get_screen_domain_params(screen: current_screen_name, params: [:], replace: nil)
                GamingHubCards.registerTrackingDefaults(analyticsData, domain: analyticsDomainName, gameId: QUIZTheme.currentGameID ?? "uclquiz")
                self.analyticsDomainName = analyticsDomainName
                self.analyticsData = analyticsData
                Track.shared.screen(screen: current_screen_name, params: [:], replace: nil)
                Track.shared.trackSponsor(slot: "header", analyticsDomainName: analyticsDomainName, analyticsData: analyticsData)
                orientation = UIDevice.current.orientation
                stopObserver = true
                
                NotificationCenter.default.addObserver(forName: .ghLoggedIn, object: nil, queue: .main) { _ in
                    DispatchQueue.main.async {
                    self.viewLoginModel.isLogin =  true
                    self.quizViewModel.isLoading =  true
                    Constants.guid =  ""
                    QuizzGameSDk.game.store.QuizUser =  nil
                    NotificationCenter.default.post(name: Notification.Name("Login"), object: nil, userInfo: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                        self.viewLoginModel.loginUserSession { [self] success, errorMessage in
                            if success{
                                BusterHelper.shared.updateBuster(type: .LEADERBOARD)
                                self.quizViewModel.cardListdata()
                                self.quizViewModel.LeaderboardListdata()
                                if GamingHubCards.isLoggedIn{
                                    UserDefaultsData.shared.homeScreenVisitedCount += 1
                                    notificationvm.checkNotificationsPermission()
                                }
                            }else{
                                BusterHelper.shared.updateBuster(type: .LEADERBOARD)
                                self.viewLoginModel.isLogin =  false
                                
                                self.quizViewModel.cardListdata()
                                self.quizViewModel.LeaderboardListdata()
                                Constants.guid =  ""
                            }
                        }
                    }
                }
                    
                }
                if !self.quizViewModel.isLoading{
                    DispatchQueue.main.async {
                    self.quizViewModel.isLoading =  true
                    self.quizViewModel.cardListdata()
                    self.quizViewModel.LeaderboardListdata()
                    
                }
                }
                
                //MARK: - Notification flow
                
                GameNotificationsManager.isNotificationsGranted { status in
                    QUIZTheme.oldNotifcationPermisstion = status.rawValue
                }
                
                NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { _ in
                    notificationvm.appDidBecomeActive()
                }
                
                NotificationCenter.default.addObserver(forName: QUIZTheme.QuizNotificationChannelStatusChanged, object: nil, queue: .main) { _ in
                    notificationvm.notificationsChannelStatusChanged()
                    if GamingHubCards.isLoggedIn{
                        notificationvm.checkNotificationsPermission()
                    }
                }
            }
           
            .onDisappear {
                if showQuetionAnsView == true {
                    stopObserver = true
                } else {
                    stopObserver = true
                }
            }
            .popup(isPresented: $notificationvm.showNotificationChannelPopUp, type: !QUIZTheme.isIpad ? .floater(verticalPadding: 0, useSafeAreaInset: true) : .default, position: .bottom, dragToDismiss: false,closeOnTap: false, closeOnTapOutside: true, backgroundColor: .black.opacity(0.4)) {
                NoticationPopView(notificationPopUp: $notificationvm.showNotificationChannelPopUp)
            }
            .popup(isPresented: $notificationvm.notificationPopUp, type: !QUIZTheme.isIpad ? .floater(verticalPadding: 0, useSafeAreaInset: true) : .default, position: .bottom,dragToDismiss: false ,closeOnTap: false, closeOnTapOutside: false, backgroundColor: .black.opacity(0.4)) {
                
                NotificationAlertView(
                    title: NotificationStrings.notificationCardAlertTitle.getTranslationValue(default: "Never miss a quiz!"), description: NotificationStrings.notificationCardAlertdesc.getTranslationValue(default: "Turn on notifications to get quiz reminders and leaderboard updates."), attributedDescription: nil, icon:  Image(uiImage:QUIZTheme.getImage(named:QuizImageName.QSDK_Alert.name) ?? UIImage()), btnHighlightedText: NotificationStrings.notificationalertbuttonOne.getTranslationValue(default: "Turn on notification"), btnNormalText: NotificationStrings.notificationalertbuttonTne.getTranslationValue(default: "Not now"),
                    notificationAlertPopUp: $notificationvm.notificationPopUp, notificationPopUp: $notificationvm.showNotificationChannelPopUp, showToast: $notificationvm.showToast)
            }
        
            .popup(isPresented: $notificationvm.showToast, type: !QUIZTheme.isIpad ? .floater(verticalPadding: 0, useSafeAreaInset: QUIZTheme.isGamingHubHost ? false : true) : .floater(verticalPadding: 0, useSafeAreaInset: false), position: .bottom, autohideIn: 2.5,dragToDismiss: true, closeOnTap: false, closeOnTapOutside: false, backgroundColor: .black.opacity(0.0)) {
                NotificationToastView(showToast: $notificationvm.showToast)
            }
    }
    
    var kebabMenu: some View {
        Group {
            if Constants.configData?.isShowKebabMenu == true {
                Menu {
                    Button(action: {
                        notificationvm.showNotificationChannelPopUp = true
                    }) {
                        Text(NotificationStrings.kebabmenunotificationTitle.getTranslationValue(default: "Notifications"))
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(90))
                }
            }
        }
    }

    
    
    private func refreshData() {
        self.quizViewModel.cardListdata()
        self.quizViewModel.LeaderboardListdata()
        
    }
}


