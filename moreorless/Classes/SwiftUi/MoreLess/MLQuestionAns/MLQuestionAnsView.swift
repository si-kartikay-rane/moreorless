//
//  MLQuestionAnsView.swift
//  quiz
//
//  Created by Vishal Vijayvargiya on 07/02/24.
//

import SwiftUI
import Kingfisher
import GamesLib
let greadiantCardBG = [QUIZTheme.getColor(named: .ML_0929C9),QUIZTheme.getColor(named: .ML_00057D)]


struct MLQuestionAnsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var cardPositions: [CardPosition] = [.bottom]
    @State var secondcardHiden:Bool =  true
    @StateObject var MLViewModel:MLGameViewModel = MLGameViewModel()
    @State private var isQuizCompleted = false
    @State var cardData:QuizCardListData? =  nil
    @State private var orientation = UIDeviceOrientation.unknown
    @State private var PasstoAnotherView = false
    @Binding var Observer : Bool
    @State var popups = PopupsState()
    @StateObject var QuizviewModel = QuizViewModel()
    @State private var ObserveNotifications = false
    @Binding var PasstoNavigationView:Bool
    @Binding var isActive : Bool
    @State var isUserPlayingchangetab: Bool = false
    @State var isSponcerOpen:Bool =  false
    var body: some View {
        ZStack{
            QUIZTheme.getColor(named: .QSDKButtonTitle00004B).opacity(5.0)
                .ignoresSafeArea()
            GeometryReader { fullView in
            VStack(spacing:0){
                AdsPresentedbyView(VerticaleEnable: false,analyticsDomainName: MLViewModel.analyticsDomainName,analyticsData : MLViewModel.analyticsData,  backgroundColor: QUIZTheme.getColor(named: .QSDKSponsorBG00439C)){ isOpen in
                    self.isSponcerOpen = isOpen
                }
                ZStack{
                    ScoreTimerView.blur(radius: MLViewModel.timeUP ? 7.0 : 0.0 )
                    if MLViewModel.timeUP{
                        Text(AppStrings.TIME_S_UP.getTranslationValue(default: "TIME’S UP!"))
                            .font((QUIZTheme.currentGameID  == "euroquiz") ? .customFont(customFont:  .UEFAEuro_HeavyExtended, size: 20) : .customFont(customFont: .Champions_Display, size: 24) )
                            .foregroundColor(QUIZTheme.getColor(named: .QSDK_FF16FF))
                    }
                }
                Divider().background(QUIZTheme.getColor(named: .QPSDKWhite)).opacity(0.3)
                if QUIZTheme.isIpad {
                    Spacer(minLength: (fullView.size.height-654)/2) // This Spacer will push the content to the center on iPad
                }
                VStack(spacing:0){
                    Text(MLViewModel.gamedescription)
                        .multilineTextAlignment(.center)
                        .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 16))
                        .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                        .padding([.leading,.trailing],40)
                        .padding([.top,.bottom],20)
                    QuestionAnsAniamtionview
                }.frame(width: QUIZTheme.isIpad ? 500 : UIScreen.screenWidth)
                if QUIZTheme.isIpad {
                    Spacer(minLength: (fullView.size.height-654)/2) // This Spacer will push the content to the center on iPad
                }
                VStack(spacing:0){
                    Spacer()
                    AdsSponsorsView()
                    
                        .padding([.leading,.trailing,.bottom],16)
                    //Divider().background(QUIZTheme.getColor(named: .QPSDKWhite)).opacity(0.3)
                    // BoosterButton.padding(.bottom,5)
                }
                
            }
        }
            NavigationLink("", destination:  MlScoreBoard(viewModel: MLViewModel, cardData: self.cardData, Observer: $PasstoAnotherView, PlayAgainvalue: $isQuizCompleted, isActive: $isActive).navigationBarTitleDisplayMode(.inline), isActive: $isQuizCompleted)
        }.ignoresSafeArea(.keyboard, edges: .bottom)
        .navigationBarBackButtonHidden()
        .navigationTitle(cardData?.title ?? "")
        .navigationBarItems(trailing:
                                Button(action: {
            if  NetworkWrapper.isInternerConnected(){
                self.popups.showingBottomFirst =  true
               
            }
        }) {
            Image(uiImage:QUIZTheme.getImage(named:QuizImageName.QSDK_NavigationClose.name) ?? UIImage())
            
        }
        )
        .onAppear {
            self.isUserPlayingchangetab =  true
            self.MLViewModel.quizID =  cardData?.qzQuizMasterid ?? ""
            ObserveNotifications = true
            self.MLViewModel.cardSelection = self.cardData
            
             if QUIZTheme.currentGameID == "uwclquiz" || QUIZTheme.currentGameID == "uclquiz" || QUIZTheme.currentGameID == "weuroquiz"{
                QUIZTheme.currentnavigation!.style(style: .withBgImage(image: QUIZTheme.getImage(named: QuizImageName.QSDKNavigationBG.name) ?? UIImage(),color:UIColor(QUIZTheme.getColor(named: .QSDK_NavImage051139))))
            }else if QUIZTheme.currentGameID == "euroquiz"{
                QUIZTheme.currentnavigation!.style(style: .withBgImageEuro(image: QUIZTheme.getImage(named: QuizImageName.QSDK_EurosTopNavigationBar.name) ?? UIImage()))
            } else {
                QUIZTheme.currentnavigation!.style(style: .blue())
            }
            if  !isSponcerOpen{
                self.initiialSetup()
            }else{
                self.MLViewModel.loadQuestionsFromJSON()
                self.MLViewModel.isAnsAttemptClick =  true
                self.MLViewModel.timeUP =  true
                self.isSponcerOpen = false
            }
            if !GamingHubCards.isLoggedIn{
                UserDefaults.standard.set(self.MLViewModel.quizID, forKey: self.MLViewModel.quizID)
//                if (self.cardData?.quiztypeid ?? 0) == 1{
//                   
//                    //UserDefaultsData.shared.isFunQuizPlay =  self.MLViewModel.quizID
//                }else if self.cardData?.quiztypeid ?? 0 == 2{
//                    UserDefaultsData.shared.isDayliQuizPlay =  true
//                }else if self.cardData?.quiztypeid ?? 0 == 3{
//                    UserDefaultsData.shared.isMoreLessPlay =  true
//                }
            }
            QUIZTheme.navigateTo =  nil
        }
        .onDisappear {
        
            ObserveNotifications = false
            if !QUIZTheme.isGamingHubHost && isUserPlayingchangetab && !self.isQuizCompleted && !isSponcerOpen{
                self.isActive = false
                BusterHelper.shared.updateBuster(type: .LEADERBOARD)
            }
//            if self.PasstoNavigationView{
//                if QUIZTheme.currentGameID == "uclquiz"{
//                    QUIZTheme.currentnavigation!.style(style: .withBgImage(image: QUIZTheme.getImage(named: QuizImageName.QSDKNavigationBG.name) ?? UIImage(), color: UIColor(QUIZTheme.getColor(named: .QSDK_NavImage051139))))
//                }else{
//                    
//                }
//            }
            
        }.popup(isPresented: $popups.showingBottomFirst, type: !QUIZTheme.isIpad ? .floater(verticalPadding: 0, useSafeAreaInset: true) : .default, position: .bottom, closeOnTap: false, closeOnTapOutside: true, backgroundColor: .black.opacity(0.4)) {
            ExitBottomPopup(isPresented: $popups.showingBottomFirst, quiztype: self.cardData?.quiztypeid ?? 0,replaceString: "\(self.MLViewModel.currentQuestionIndex)", quizId: self.MLViewModel.quizID, gameType: "mol",viewModel: self.QuizviewModel,MLViewModel: MLViewModel,onDismiss:{
                self.PasstoNavigationView =  true
                self.Observer =  false
//                self.presentationMode.wrappedValue.dismiss()
                self.isActive = false
            }).ignoresSafeArea()
        }
        .onReceive(MLViewModel.$isQuizCompleted, perform: { completed in
            self.isQuizCompleted = completed
            
        })
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
            if ObserveNotifications {
                self.MLViewModel.appInBackground =  true
 
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            if ObserveNotifications {
             
                self.MLViewModel.loadQuestionsFromJSON()
                self.MLViewModel.isAnsAttemptClick =  true
                self.MLViewModel.timeUP =  true
            }
        }
        
        .onReceive(NotificationCenter.default.publisher(for: .didUpdateNetworkReachabilityStatus)) { notification in
            if ObserveNotifications {
                MLViewModel.handleNotification(notification)
            }
            
        }
    
        .popup(isPresented: $MLViewModel.showErrorPopup, type: .`default`, dragToDismiss: false,closeOnTap: false, backgroundColor: Color.black.opacity(0.4)) {
            InGamePlayAlert(isPresented: $MLViewModel.showErrorPopup, txt: $MLViewModel.error)
        }
        .onReceive(MLViewModel.$isQuizCompleted, perform: { completed in
            if completed{
                self.popups.showingBottomFirst = false
            }
            
        })
        
        
    }
    
    private func initiialSetup(){
        self.MLViewModel.streakTotal =  0
        self.MLViewModel.totalPoints = 0
        self.MLViewModel.topCornerRadis =  false
        self.MLViewModel.isQuizCompleted =  false
        self.MLViewModel.baseCard.removeAll()
        self.MLViewModel.currentQuestionIndex = 0
        self.MLViewModel.timeUP = false
        self.MLViewModel.timerProgress = 0.0
        self.MLViewModel.timeRemaining = 0
        self.MLViewModel.timerCount = 0
        self.MLViewModel.questionCard = nil
        self.MLViewModel.progress =  0
        self.MLViewModel.isCorrectWronfAns = nil
        self.MLViewModel.isAnsAttemptClick =  false
        self.MLViewModel.loadQuestionsFromJSON()
        self.MLViewModel.bodarrprogress = 0
    }
    
    var ScoreTimerView:some View{
        HStack{
            VStack(spacing:5){
                Text(AppStrings.mlStreak.getTranslationValue(default: "Streak"))
                    .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite)).opacity(0.7)
                    .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 12))
                HStack(spacing:2){
                    Text(String(describing: MLViewModel.streakTotal))
                        .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                        .font(Font.swiftUICustomFont(customFont: .SF_UI_Bold, size: 16))
                    Image(uiImage: QUIZTheme.getImage(named: QuizImageName.Ml_Streak.name) ?? UIImage())
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }.frame(minWidth: 80)
                .padding(.all,16)
            Divider().background(QUIZTheme.getColor(named: .QPSDKWhite)).opacity(0.3).padding([.top,.bottom],10)
            Spacer()
            TimmerView
            Spacer()
            Divider().background(QUIZTheme.getColor(named: .QPSDKWhite)).opacity(0.3).padding([.top,.bottom],10)
            VStack(spacing:5){
                Text(AppStrings.mlScore.getTranslationValue(default: "Score"))
                    .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite)).opacity(0.7)
                    .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 12))
                Text(String(describing: MLViewModel.totalPoints) + " " + AppStrings.Pts.getTranslationValue(default: "Pts"))
                    .foregroundColor(QUIZTheme.getColor(named: QUIZTheme.currentGameID  == "euroquiz" ? .QSDK_CB333B : .QPSDKPrimary))
                    .font(Font.swiftUICustomFont(customFont: .SF_UI_Bold, size: 16))
            }.frame(minWidth: 80)
                .padding(.all,16)
            
        }.frame(height: 64)
        
    }
    
    var TimmerView: some View{
        HStack(spacing: 10){
            
            ZStack {
                Circle()
                    .stroke(QUIZTheme.getColor(named: .QSDK_FFFFFF40), lineWidth: 2.5)
                    .opacity(0.3)
                Circle()
                    .trim(from: 0, to: CGFloat(MLViewModel.timerProgress))
                    .stroke(MLViewModel.isThreeSecondsLeft ? QUIZTheme.getColor(named: .QSDK_CB333B) : QUIZTheme.getColor(named: .QSDK_FF16FF), style: StrokeStyle(lineWidth: 2.5,lineCap: .round))
                
                    .rotationEffect(.degrees(-90))
                
                Text("\(MLViewModel.timeRemaining)")
                    .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 16))
                    .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                
            }
            .frame(width: 40, height: 40)
        }
        .foregroundColor(.white)
        .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4))
        
    }
    
    var QuestionAnsAniamtionview: some View {
        ZStack(alignment: .top) {
            GeometryReader { fullView in
                ForEach(0..<(MLViewModel.baseCard.count ), id: \.self) { index in
                    
                    if let card = MLViewModel.baseCard[index]{
                        VStack(spacing: (card.position == .top  ||  card.position == .secondTop) ? -10 : 10){
                            QuestionComparePlayerCard(playerCardvalue: card, gametype: MLViewModel.gameType,topCornerRadis:MLViewModel.topCornerRadis)
                                .clipShape(RoundedCorner(radius: 14, corners: MLViewModel.topCornerRadis ? [.topLeft, .topRight] : .allCorners))
                                .offset(y: self.positionOffset(for: card.position, view: fullView))
                                .padding([.leading,.trailing],paddingForPosition(for: card.position))
                                .scaleEffect(card.position == .secondTop ? 0.8 : 1)
                                .opacity(card.position == .secondTop ? 0 : 1)
                            
                            if !card.isQuestionViewHide{
                                MoreLessAttempetAnsCard
                                    .offset(y: self.positionOffset(for: card.position, view: fullView))
                                    .scaleEffect(card.position == .secondTop ? 0.8 : 1)
                                    .opacity(card.position == .secondTop ? 0 : 1)
                                    .overlay(
                                        ZStack{
                                            BorderPathShape(cornerRadius: 14)
                                                .trim(from: 0, to: MLViewModel.bodarrprogress)
                                                .stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
                                                .foregroundColor((MLViewModel.isCorrectWronfAns == 1) ? Color.green : (MLViewModel.isCorrectWronfAns == 0) ? Color.red : .clear)
                                            BorderPathShapeleft(cornerRadius: 14)
                                                .trim(from: 0, to: MLViewModel.bodarrprogress)
                                                .stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
                                                .foregroundColor((MLViewModel.isCorrectWronfAns == 1) ? Color.green : (MLViewModel.isCorrectWronfAns == 0) ? Color.red : .clear)
                                        }
                                    )
                                    
                                
                            }
                        }
                    }
                    
                }
            }
        }.padding([.leading, .trailing], 16)
        
    }
    
    var MoreLessAttempetAnsCard: some View {
        ZStack(alignment:.top){
            LinearGradient(gradient: Gradient(colors: greadiantCardBG), startPoint: .bottom, endPoint: .top)
            VStack(spacing:12){
                ZStack{
                    if MLViewModel.progress == 0{
                        KFImage(URL(string: MLViewModel.questionCard?.playerimg ?? "https://panenka.uefa.com/panenka/fallback/generic-head.svg")).placeholder {
                            QUIZTheme.getImage(named:QuizImageName.ML_PlayerPlaceholder.name)?
                                .resizable()
                        }
                        .retry(maxCount: 3, interval: .seconds(10)).resizable().background(Color.white).clipShape(.circle).scaleEffect(MLViewModel.bodarrprogress == 1 ? 0 : 1)
                    }else{
                        
                        Image(uiImage: QUIZTheme.getImage(named: (self.MLViewModel.isCorrectWronfAns == 1) ? QuizImageName.ML_Correct.name : (self.MLViewModel.isCorrectWronfAns == 0) ? QuizImageName.ML_Incorrect.name : "" ) ?? UIImage()).resizable().clipShape(.circle).scaleEffect(MLViewModel.bodarrprogress == 1 ? 1 : 0)
                    }
                }.frame(width:QUIZTheme.isIpad ? 80 : 60,height: QUIZTheme.isIpad ? 80 : 60).padding(.top,20)
                
                if MLViewModel.progress == 1{
                    VStack(alignment:.center,spacing: 12){
                        VStack(alignment:.center,spacing: 2){
                            let name  =  MLViewModel.questionCard?.playername?.split(separator: " ")
                            let lasstname = MLViewModel.questionCard?.playername?.replacingOccurrences(of:name?.first ?? "", with: "")
                            Text(name?.first ?? "-")
                                .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 16))
                            Text(lasstname ?? "-")
                                .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 22))
                        }
                        VStack(alignment:.center,spacing: 0){
                            Text(String(describing:MLViewModel.lastplayervalue))
                                .foregroundColor(QUIZTheme.getColor(named: .QPSDKPrimary))
                                .font(Font.swiftUICustomFont(customFont: .SF_UI_Bold, size: 34))
                                .multilineTextAlignment(.center)
                            Text(MLViewModel.gameType)
                                .font(Font.swiftUICustomFont(customFont: .SF_UI_Regular, size: 12))
                                .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite)).opacity(0.7)
                                .multilineTextAlignment(.center)
                        }
                    }.foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                        .padding([.bottom,.leading,.trailing],20)
                }else{
                    VStack(alignment:.center,spacing: 12){
                        Text(appendSpacesIfNeeded(to: MLViewModel.questionCard?.question ?? ""))
                            .multilineTextAlignment(.center)
                            .frame(height: heightForTwoLines())
                            .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 20))
                            .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                            .padding([.leading,.trailing],20)
                        HStack(spacing:40){
                            Button(action: {
                                
                                // self.MLViewModel.currentQuestionIndex += 1
                                self.MLViewModel.loadQuestionsFromJSON(moreless:0)
                                self.MLViewModel.isAnsAttemptClick =  true
                            }) {
                                Image(uiImage: QUIZTheme.getImage(named: QuizImageName.ML_Sub_off.name) ?? UIImage()).resizable().frame(width: 48,height: 48)
                            }.disabled(self.MLViewModel.isAnsAttemptClick)
                            
                            Button(action: {
                                
                                // self.MLViewModel.currentQuestionIndex += 1
                                self.MLViewModel.loadQuestionsFromJSON(moreless:1)
                                self.MLViewModel.isAnsAttemptClick =  true
                            }) {
                                Image(uiImage: QUIZTheme.getImage(named: QuizImageName.ML_Sub_in.name) ?? UIImage()).resizable().frame(width: 48,height: 48)
                            }.disabled(self.MLViewModel.isAnsAttemptClick)
                            
                        }
                    }.padding(.bottom,20)
                    
                }
            }.frame(maxWidth: .infinity)
        }.frame(height: QUIZTheme.isIpad ? 266 : 228)
        .cornerRadius(14)
            .overlay(
                ZStack{
                    BorderPathShape(cornerRadius: 14)
                        .stroke(QUIZTheme.getColor(named: .ML_borderColor1C2291), lineWidth: 2)
                    BorderPathShapeleft(cornerRadius: 14)
                        .stroke(QUIZTheme.getColor(named: .ML_borderColor1C2291), lineWidth: 2)
                }
            )
    }
 
    
    private func positionOffset(for position: MLQuestionAnsView.CardPosition,view:GeometryProxy) -> CGFloat {
        switch position {
        case .bottom:
            return view.size.height
        case .center:
            return view.size.height / 2
        case .top:
            return 0
        case .secondTop:
            return -view.size.height / 2 + 100
        
        }
    }

   
    // Determine padding based on card position
    private func SpacingForPosition(index: Int) -> CGFloat {
        switch cardPositions[index] {
        case .top:
            // Increase padding for cards at the top
            return -10
        default:
            // Standard padding for other positions
            return 15
        }
    }
    
    
    // Determine padding based on card position
    private func paddingForPosition(for position: MLQuestionAnsView.CardPosition) -> CGFloat {
        switch position {
        case .top:
            // Increase padding for cards at the top
            
            return QUIZTheme.isIpad ? 60 : 24
        case .secondTop:
            return 55
        default:
            // Standard padding for other positions
            return 10
        }
    }
    // A function to append newlines or spaces if the text is likely to be shorter than 2 lines
        private func appendSpacesIfNeeded(to text: String) -> String {
            // Assuming a rough average character count that fits in one line. This is highly dependent on the font and view width.
            let averageCharactersPerLine = 50
            let minimumLengthForTwoLines = averageCharactersPerLine * 2
            
            if text.count < minimumLengthForTwoLines {
                return text + String(repeating: "", count: 2 - (text.count / averageCharactersPerLine))
            } else {
                return text
            }
        }
        
        // Estimate the height needed for two lines of text
        private func heightForTwoLines() -> CGFloat {
            let singleLineHeight = UIFont.systemFont(ofSize: 20).lineHeight // Example for default system font size 17
            return singleLineHeight * 2
        }
    
    var BoosterButton:some View{
        
        VStack(spacing:12){
            //if let boosterdata  = viewModel.GameAttemptConfigData?.booster{
                Text(AppStrings.yourboosters.getTranslationValue(default: "Your boosters"))
                    .multilineTextAlignment(.leading)
                    .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 14))
                    .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite)).opacity(0.7)
                    .padding(.top,16)
                HStack(spacing: 10){
                    //if let isavailble =  boosterdata.first(where: {($0.boosterID ?? 0) == 1}) {
                        Button(action: {
//                            if !self.viewModel.BosterButtonActive{
//                                self.viewModel.BosterButtonActive = true
//                                if  NetworkWrapper.isInternerConnected(){
//                                viewModel.FifityfitiyApiCall()
//
//
//                                    let G4A = QuizzerAnalyticsBooster(boosterType: Track.AnalyticsBooster50)
//                                    //Track.shared.event(G4A: G4A, name: current_screen_name, params: nil,replaceString: "\(viewModel.jsonIndex+1)",quizId: self.viewModel.quizID)
//                            }
//                        }
                        }) {
                            
                            HStack(alignment: .center, spacing: 6) {
                                
                                Image(uiImage:QUIZTheme.getImage(named:QuizImageName.ML_addedTime.name) ?? UIImage())//.resizable()
                                    .frame(width: 16,height: 16)
                                //let testcase = (viewModel.fiftyFiftyEnabled ? (AppStrings.booster1.getTranslationValue(default: "50-50") + " " + AppStrings.boosteractive.getTranslationValue(default: "active")) :  viewModel.isUsedfityfifty ? (AppStrings.booster1.getTranslationValue(default: "50-50") + " " + AppStrings.boosterplayed.getTranslationValue(default: "played")) : AppStrings.booster1.getTranslationValue(default: "50-50"))
                                Text("Added time")
                                    .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 14))
                                
                                    .lineLimit(2)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .conditionalBackground(false,
                                                   trueContent: { view in
                                view.background(QUIZTheme.getColor(named: .QSDK_FFCD44))
                                    .cornerRadius(14)
                                    .padding(5)
                                    .background(QUIZTheme.getColor(named: .QSDK_FFCD44).opacity(0.4))
                                    .cornerRadius(16.5)
                                    .padding(5)
                                    .background(QUIZTheme.getColor(named: .QSDK_FFCD44).opacity(0.2))
                                    .cornerRadius(16.5)
                                    .foregroundColor(.black)
                                
                            },
                                                   falseContent: { view in
                                view.background((QUIZTheme.getColor(named: .QSDK_0D3AFF)))
                                //view.background(viewModel.isUsedfityfifty ? (QUIZTheme.getColor(named: .QSDK_0D3AFF)) : Color.black.opacity(0.2))
                                    .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                                    //.foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite).opacity((viewModel.sneakPeakEnabled && !viewModel.isUsedfityfifty) ? 0.5 : 1.0))
                                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                    .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .stroke(QUIZTheme.getColor(named: .QPSDKWhite)))
                                        //.stroke(QUIZTheme.getColor(named: .QPSDKWhite).opacity((viewModel.sneakPeakEnabled && !viewModel.isUsedfityfifty) ? 0.5 : 1.0), lineWidth: viewModel.isUsedfityfifty ? 0 : 1))
                            }
                            )
                            
                            
                        }//.disabled(self.viewModel.isUsedfityfifty || self.viewModel.sneakPeakEnabled )
                            //.opacity((self.viewModel.sneakPeakEnabled && !self.viewModel.isUsedfityfifty) ? 0.5 : 1)
                            //.padding([.bottom,.top],5)
                    //}
                    
                    
                   // if let isavailble =  boosterdata.first(where: {($0.boosterID ?? 0) == 2}) {
                        Button(action: {
//                            if !self.viewModel.BosterButtonActive{
//                                self.viewModel.BosterButtonActive = true
//                                if  NetworkWrapper.isInternerConnected(){
//                                    viewModel.VarSneakPeek()
//
//                                    let G4A = QuizzerAnalyticsBooster(boosterType: Track.AnalyticsBooster2shots)
//                                    //Track.shared.event(G4A: G4A, name: current_screen_name, params: nil,replaceString: "\(viewModel.jsonIndex+1)",quizId: self.viewModel.quizID)
//                                }
//                            }
                        }) {
                            HStack(alignment: .center, spacing: 6) {
                                
                                Image(uiImage:QUIZTheme.getImage(named:QuizImageName.ML_Switch.name) ?? UIImage())
                                    .frame(width: 16,height: 16)
                               // let testcase = (viewModel.sneakPeakEnabled ? (AppStrings.booster2.getTranslationValue(default: "VRA") + " " + AppStrings.boosteractive.getTranslationValue(default: " active")) : viewModel.isUsedVRA ? (AppStrings.booster2.getTranslationValue(default: "VRA") + " " + AppStrings.boosterplayed.getTranslationValue(default: "Retake played")) : AppStrings.booster2.getTranslationValue(default: "VAR") )
                                
                                Text("Switch")
                                    .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 14))
                                    
                                    .lineLimit(2)
                            }.frame(maxWidth: .infinity)
                                .padding()
                            
                                .conditionalBackground(false,
                                                       trueContent: { view in
                                    view.background(QUIZTheme.getColor(named: .QSDK_FFCD44))
                                        .cornerRadius(14)
                                        .padding(5)
                                        .background(QUIZTheme.getColor(named: .QSDK_FFCD44).opacity(0.4))
                                        .cornerRadius(16.5)
                                        .padding(5)
                                        .background(QUIZTheme.getColor(named: .QSDK_FFCD44).opacity(0.2))
                                        .cornerRadius(16.5)
                                        .foregroundColor(.black)
                                    
                                },
                                                       falseContent: { view in
                                    view.background((QUIZTheme.getColor(named: .QSDK_0D3AFF)))
                                    //view.background(viewModel.isUsedVRA ? (QUIZTheme.getColor(named: .QSDK_0D3AFF)) : Color.black.opacity(0.2))
                                        .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                                        //.foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite).opacity((viewModel.sneakPeakEnabled && !viewModel.isUsedVRA) ? 0.5 : 1.0))
                                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous)
                                            .stroke(QUIZTheme.getColor(named: .QPSDKWhite)))
                                            //.stroke(QUIZTheme.getColor(named: .QPSDKWhite).opacity((viewModel.fiftyFiftyEnabled && !viewModel.isUsedVRA) ? 0.5 : 1.0), lineWidth: self.viewModel.isUsedVRA ? 0 : 1))
                                }
                                )
                        }//.disabled(self.viewModel.isUsedVRA || self.viewModel.fiftyFiftyEnabled )
                           // .opacity((self.viewModel.fiftyFiftyEnabled && !self.viewModel.isUsedVRA) ? 0.5 : 1)
                            //.padding([.bottom,.top],5)
                    //}
                }.frame(minHeight:70)
                    .padding([.leading,.trailing],16)
                
            //}
        }
        .frame(width: QUIZTheme.isIpad ? 400 : UIScreen.screenWidth)
            //.padding(16)
        
    }
    
}


extension MLQuestionAnsView {
    enum CardPosition {
        case bottom, center, top, secondTop
    }
}

struct QuestionComparePlayerCard: View {
    
    @State var playerCardvalue:BaseCard
    @State var gametype:String
    @State var topCornerRadis :Bool
    var body: some View {
        VStack(alignment:.leading,spacing: 0){
            HStack(spacing:8){
                KFImage(URL(string: playerCardvalue.playerimg ?? "https://panenka.uefa.com/panenka/fallback/generic-head.svg")).placeholder {
                    QUIZTheme.getImage(named:QuizImageName.ML_PlayerPlaceholder.name)?
                        .resizable()
                }
                .retry(maxCount: 3, interval: .seconds(10)).resizable().frame(width: 48,height: 48).background(Color.white).clipShape(.circle)
                VStack(alignment:.leading){
                    let name  =  playerCardvalue.playername?.split(separator: " ")
                    let lasstname = playerCardvalue.playername?.replacingOccurrences(of:name?.first ?? "", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                    if name?.count == 1{
                        Text(name?.first ?? "-")
                            .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 16))
                            .lineLimit(1)
                            .multilineTextAlignment(.leading)
                    }else{
                        Group{
                            Text(name?.first ?? "-")
                                .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 12))
                            Text(lasstname ?? "-")
                                .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 16))
                        }
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                    }
                    
                }.foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                Spacer()
                VStack(alignment:.center){
                    Text(String(describing:playerCardvalue.value ?? 0))
                        .font(Font.swiftUICustomFont(customFont: .SF_UI_Bold, size: 24))
                        .foregroundColor(QUIZTheme.getColor(named: .QPSDKPrimary))
                        .multilineTextAlignment(.center)
                    Text(gametype)
                        .font(Font.swiftUICustomFont(customFont: .SF_UI_Regular, size: 12))
                        .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite)).opacity(0.7)
                        .multilineTextAlignment(.center)
                }
            }.padding([.bottom],6).padding([.leading,.trailing],12)
        }.frame(maxWidth: .infinity, minHeight: 96).padding(.all,0)
        .background(LinearGradient(gradient: Gradient(colors: greadiantCardBG), startPoint: .bottom, endPoint: .top))
        .overlay(
            RoundedCorner(radius: 14, corners: topCornerRadis ? [.topLeft, .topRight] : .allCorners)
                .stroke(QUIZTheme.getColor(named: .ML_borderColor1C2291), lineWidth: 2)
        )
    }
}

//MARK: BorderAnimation
struct ProgressBorderView: View {
    let progress: CGFloat
    let lineWidth: CGFloat
    let cornerRadius: CGFloat
    let isCorrectWronfAns:Int?
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let rect = CGRect(x: 0, y: 0, width: geometry.size.width, height: geometry.size.height)
                let cornerPath = Path(roundedRect: rect, cornerRadius: cornerRadius)
                path.addPath(cornerPath)
            }
            .trim(from: 0, to: progress)
            .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
            .foregroundColor((isCorrectWronfAns == 1) ? Color.green : Color.red)
        }
    }
    
    
}
struct BorderPathShape: Shape {
    var cornerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.size.width
        let h = rect.size.height
        
        // Define the corners.
        let topLeft = CGPoint(x: 0, y: cornerRadius)
        let topRight = CGPoint(x: w - cornerRadius, y: 0)
        let bottomRight = CGPoint(x: w, y: h - cornerRadius)
        let bottomCenter = CGPoint(x: w / 2, y: h)
        let bottomLeft = CGPoint(x: cornerRadius, y: h)

        // Start from the top center, considering the corner radius
        path.move(to: CGPoint(x: w / 2 + cornerRadius, y: 0))
        
        // Draw to the top right corner, then add arc for corner
        path.addLine(to: CGPoint(x: w - cornerRadius, y: 0))
        path.addArc(center: CGPoint(x: w - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: .degrees(-90), endAngle: .degrees(0), clockwise: false)
        
        // Draw down to the bottom right corner, then to the bottom center with an arc for the corner
        path.addLine(to: CGPoint(x: w, y: h - cornerRadius))
        path.addArc(center: CGPoint(x: w - cornerRadius, y: h - cornerRadius), radius: cornerRadius, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
        path.addLine(to: CGPoint(x: w / 2, y: h))
        
        
        
        return path
    }
    
   
}
struct BorderPathShapeleft: Shape {
    var cornerRadius: CGFloat
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.size.width
        let h = rect.size.height
        
        // Define the corners.
        let topLeft = CGPoint(x: 0, y: cornerRadius)
        let topRight = CGPoint(x: w - cornerRadius, y: 0)
        let bottomRight = CGPoint(x: w, y: h - cornerRadius)
        let bottomCenter = CGPoint(x: w / 2, y: h)
        let bottomLeft = CGPoint(x: cornerRadius, y: h)
        
        // Move to the top center again to start the left side, considering the corner radius
        path.move(to: CGPoint(x: w / 2 + cornerRadius, y: 0))
        
        // Draw to the top left corner, then add arc for corner
        path.addLine(to: CGPoint(x: cornerRadius, y: 0))
        path.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: .degrees(-90), endAngle: .degrees(180), clockwise: true)
        
        // Draw down to the bottom left corner, then to the bottom center with an arc for the corner
        path.addLine(to: CGPoint(x: 0, y: h - cornerRadius))
        path.addArc(center: CGPoint(x: cornerRadius, y: h - cornerRadius), radius: cornerRadius, startAngle: .degrees(180), endAngle: .degrees(90), clockwise: true)
        path.addLine(to: CGPoint(x: w / 2, y: h))
        
        return path
    }
}
