//
//  LeaderboardView.swift
//  quiz
//
//  Created by Vishal Vijayvargiya on 13/10/23.
//

import SwiftUI
import GamesLib
import Kingfisher

struct LeaderboardView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var orientation = UIDevice.current.orientation
    @State private var buttonRect: CGRect = .zero
    @State private var PasstoAnotherView = false
    @StateObject var quizViewModel = HomeLandingViewModel()
    var selectedLeaderBoardType:leaderboardMenuValue? =  nil
    @State private var isPresentingiPadActivityView = false
    @State private var isPresentingiPhoneActivityView = false
    @State var selectedIndex: Int = 0
    @State var maxOffset:Int = 0
    @State var quizId:String = ""
    @State var quizIdType:String = ""
    @State var title : String = ""
    @State private var oldorientation = UIDevice.current.orientation
    @State private var current_screen_name = "/leaderboard-{quizType}"
    let sharedata =  Constants.configData?.socialShare?.leaderboard
    @State var analyticsDomainName: String = ""
    @State var analyticsData: TrackingParameters = TrackingParameters([:] as [String: Any?]?)
    
    var body: some View {
        ZStack{
            
            QUIZTheme.getColor(named: .QSDK_0A0A61).ignoresSafeArea()
            if self.quizViewModel.isLoading{
                
                ActivityIndicator(isAnimating:$quizViewModel.isLoading, style: .large)
            }else{
                
                VStack(spacing:0.0){
                    AdsPresentedbyView(VerticaleEnable: false, analyticsDomainName: self.analyticsDomainName, analyticsData: self.analyticsData)
                    VStack
                    {
                        if QUIZTheme.currentGameID != "weuroquiz" {
                            VStack{
                                HStack{
                                    Text(self.quizViewModel.typeTitle ?? .empty).font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 24))
                                    
                                    Spacer()
                                }
                                //                            leaderboardCardList(quizViewModel: quizViewModel)
                                //                            LeaguesOverallStatsDataCell()
                                
                                //                            Text("Ends 21 Sep 00:00").font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 14)).opacity(0.3)
                            }.foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                                .padding(.top,24)
                                .padding(.bottom,16)
                                .padding(.leading, 10)
                        }
                        HStack(spacing:10){
                            Button {
                                
                            } label: {
                                Text(AppStrings.Rank.getTranslationValue(default: "Rank"))
                                    .font(Font.swiftUICustomFont(customFont: .SF_UI_Regular, size: 12))
                                    .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                                    .opacity(0.7)
                                    .frame(maxWidth:40 ,alignment: .leading)
                            }
                            Spacer()
                            if QUIZTheme.currentGameID == "weuroquiz"{
                                Button {
                                    
                                } label: {
                                    Text(AppStrings.correct_percentage.getTranslationValue(default: "Correct %"))
                                        .font(Font.swiftUICustomFont(customFont: .SF_UI_Regular, size: 12))
                                        .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                                        .opacity(0.7)
                                        .frame(maxWidth: 60)
                                }
                            }
                            Button {
                                
                            } label: {
                                Text(AppStrings.points_leaderboard.getTranslationValue(default: "Total Pts"))
                                    .font(Font.swiftUICustomFont(customFont: .SF_UI_Regular, size: 12))
                                    .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                                    .opacity(0.7)
                                    .frame(maxWidth:75 ,alignment: QUIZTheme.currentGameID == "weuroquiz" ? .center : .trailing)
                            }
                            
                        }
                        .padding(.top, QUIZTheme.currentGameID == "weuroquiz" ? 20 : 10)
                        .padding([.leading,.trailing, .bottom],10)
                        
                        Divider().background(QUIZTheme.getColor(named: .QPSDKWhite).opacity(0.3))
                    }.padding([.leading,.trailing], QUIZTheme.isIpad ? (QUIZTheme.isLandscape && QUIZTheme.currentGameID == "weuroquiz" ? 232 : 52) : 0)
                    
                    ListRankview
                    
                }.navigationBarItems(leading:
                                        Button(action: {
                    if  NetworkWrapper.isInternerConnected(){
                        self.quizId = .empty
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Image(uiImage:QUIZTheme.getImage(named:QuizImageName.QSDK_NavBack.name) ?? UIImage())
                        .imageScale(.large)
                    
                },trailing:
                                        Button(action: {
                    if  NetworkWrapper.isInternerConnected(){
                        
                        //Track.shared.event(event: self.selectedLeaderBoardType?.quiztypeid == 2 ? .leaderboardsharedaily : .leaderboardsharefun, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.quizViewModel.quizType ?? 0)"]  as? String ?? ""),quizId:self.selectedLeaderBoardType?.quizid ?? quizId)
                        
                        
                        let G4A = QuizzerAnalyticsLeaderboardShare(quizType: QUIZTheme.eventTypeData(title: (self.quizViewModel.gaTitlePassed ?? self.title ), gameType: (self.quizViewModel.gaPageTitle ?? self.title ) ))
                        
                        Track.shared.event(G4A: G4A, name: current_screen_name, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.quizViewModel.quizType ?? self.selectedLeaderBoardType?.quiztypeid ?? Int(self.quizIdType) ?? Int(QUIZTheme.quizIDType ?? "") ?? 0 )"]  as? String ?? ""),quizId:self.selectedLeaderBoardType?.quizid ?? quizId, quizTitle: self.quizViewModel.gaTitlePassed, gaPageTitle: self.quizViewModel.gaPageTitle,gaPageSubType: self.quizViewModel.gaPageSubType)
                        
                        
                        if QUIZTheme.isIpad {
                            
                            isPresentingiPadActivityView = true
                        } else {
                            isPresentingiPhoneActivityView = true
                        }
                    }
                    
                }) {
                    Image(uiImage: QUIZTheme.getImage(named: QuizImageName.QSDKShare.name) ?? UIImage())
                    
                }.popover(isPresented: $isPresentingiPadActivityView) {
                    //                MNTCustSimplyShareViewController(activityItems: [sharedata?.modalTitle?.getTranslationValue(default: ""),sharedata?.modalDesc?.getTranslationValue(default: ""),sharedata?.loadText?.getTranslationValue(default: ""),URL(string: shareURls.leaderBoard + "/\(self.quizViewModel.quizType ?? 0)" + "/\(self.selectedLeaderBoardType?.quizid ?? quizId)")!])
                    MNTCustSimplyShareViewController(activityItems: [sharedata?.loadText?.getTranslationValue(default: "") as Any,URL(string: shareURls.leaderBoard + (QUIZTheme.currentGameID ?? "uclquiz") + screenName.leaderboard
                                                                                                                                      + "/\(self.quizViewModel.quizType ?? self.selectedLeaderBoardType?.quiztypeid ?? Int(self.quizIdType) ?? Int(QUIZTheme.quizIDType ?? "") ?? 0 )" + "/\(self.selectedLeaderBoardType?.quizid ?? quizId)")!])
                    
                }
                                     
                                     
                ).navigationBarBackButtonHidden()
                    .navigationBarTitle(QUIZTheme.currentGameID == "weuroquiz" ? "\(self.quizViewModel.typeTitle ?? "")" : AppStrings.Leaderboards.getTranslationValue(default: "Leaderboards"), displayMode: QUIZTheme.currentGameID == "weuroquiz" ? .large : .inline)
//                    .navigationTitle(AppStrings.leaderboard_ranking_title.getTranslationValue(default: "Leaderboard"))
                
            }
            if isPresentingiPhoneActivityView || isPresentingiPadActivityView {
                Color.black.opacity(0.001) // Invisible overlay
                    .edgesIgnoringSafeArea(.all)
                    .allowsHitTesting(true) // Blocks user interaction
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        //        .background(ActivityViewPresenter(isPresented: $isPresentingiPhoneActivityView, items: [sharedata?.modalTitle?.getTranslationValue(default: ""),sharedata?.modalDesc?.getTranslationValue(default: ""),sharedata?.loadText?.getTranslationValue(default: ""),URL(string: shareURls.leaderBoard + "/\(self.quizViewModel.quizType ?? 0)" + "/\(self.selectedLeaderBoardType?.quizid ?? quizId)")!]))
        .background(ActivityViewPresenter(isPresented: $isPresentingiPhoneActivityView, items: [sharedata?.loadText?.getTranslationValue(default: "") as Any,URL(string: shareURls.leaderBoard + (QUIZTheme.currentGameID ?? "uclquiz") + screenName.leaderboard + "/\(self.quizViewModel.quizType ?? self.selectedLeaderBoardType?.quiztypeid ?? Int(self.quizIdType) ?? Int(QUIZTheme.quizIDType ?? "") ?? 0 )" + "/\(self.selectedLeaderBoardType?.quizid ?? quizId)")!]))
        .navigationBarHidden(false)
        .onAppear{
            self.quizViewModel.LeaderBoardRankList(quizId: self.selectedLeaderBoardType?.quizid ?? quizId  , offset: maxOffset, count: GamingHubCards.isLoggedIn ? Constants.configData?.leaderBoardPagingPerPage ?? 10 : Constants.configData?.leaderBoardPagingPerPageForGuest ?? 50)
            DispatchQueue.main.async{
                quizViewModel.isLoading = true
                if GamingHubCards.isLoggedIn{
                    self.quizViewModel.LeaderBoardSelfRankList(quizId: self.selectedLeaderBoardType?.quizid ?? quizId)
                    
                    let intvals0 = self.selectedLeaderBoardType?.quiztypeid
                    let intvals1 = self.quizIdType
                    let intvals2 = QUIZTheme.quizIDType ?? intvals1
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                        current_screen_name = current_screen_name.replacingOccurrences(of: "{quizType}", with: self.quizViewModel.gameType ?? "")

                        
                        
                        let (analyticsDomainName, analyticsData) = Track.shared.get_screen_domain_params(screen: current_screen_name, params: [:],replace2: (Constants.configData?.quizTypeTrackingKey?["\(intvals0 ?? Int(intvals2) ?? 0)"]  as? String ?? ""),quizId:GamingHubCards.isLoggedIn ? self.selectedLeaderBoardType?.quizid ?? QUIZTheme.quizID ?? quizId : "\(self.selectedLeaderBoardType?.quiztypeid ?? Int(quizId) ?? 0)",quizTitle: self.quizViewModel.gaTitlePassed, gaPageTitle: self.quizViewModel.gaPageTitle, gaPageSubType: self.quizViewModel.gaPageSubType)
                        
                        
                        
                        GamingHubCards.registerTrackingDefaults(analyticsData, domain: analyticsDomainName, gameId: QUIZTheme.currentGameID ?? "uclquiz")
                        self.analyticsDomainName = analyticsDomainName
                        self.analyticsData = analyticsData
                        
                        Track.shared.screen(screen: current_screen_name, params: [:],replace2: (Constants.configData?.quizTypeTrackingKey?["\(intvals0 ?? Int(intvals2) ?? 0)"]  as? String ?? ""),quizId:GamingHubCards.isLoggedIn ? self.selectedLeaderBoardType?.quizid ?? QUIZTheme.quizID ?? quizId : "\(self.selectedLeaderBoardType?.quiztypeid ?? Int(quizId) ?? 0)",quizTitle: self.quizViewModel.gaTitlePassed, gaPageTitle: self.quizViewModel.gaPageTitle, gaPageSubType: self.quizViewModel.gaPageSubType)
                        
                        Track.shared.trackSponsor(slot: "header", analyticsDomainName: self.analyticsDomainName, analyticsData: self.analyticsData)
                    }
                }else{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                        current_screen_name = current_screen_name.replacingOccurrences(of: "{quizType}", with: self.quizViewModel.gameType ?? "")
                        
                        
                        let (analyticsDomainName, analyticsData) = Track.shared.get_screen_domain_params(screen: current_screen_name, params: [:], replace2: (Constants.configData?.quizTypeTrackingKey?["\(self.quizViewModel.quizType ?? self.selectedLeaderBoardType?.quiztypeid ?? Int(self.quizIdType) ?? 0)"]  as? String ?? ""),quizId:self.selectedLeaderBoardType?.quizid ?? quizId, quizTitle: self.quizViewModel.gaTitlePassed, gaPageTitle: self.quizViewModel.gaPageTitle, gaPageSubType: self.quizViewModel.gaPageSubType)
                        
                        GamingHubCards.registerTrackingDefaults(analyticsData, domain: analyticsDomainName, gameId: QUIZTheme.currentGameID ?? "uclquiz")
                        self.analyticsDomainName = analyticsDomainName
                        self.analyticsData = analyticsData
                        
                        Track.shared.screen(screen: current_screen_name, params: [:], replace2: (Constants.configData?.quizTypeTrackingKey?["\(self.quizViewModel.quizType ?? self.selectedLeaderBoardType?.quiztypeid ?? Int(self.quizIdType) ?? 0)"]  as? String ?? ""),quizId:self.selectedLeaderBoardType?.quizid ?? quizId, quizTitle: self.quizViewModel.gaTitlePassed, gaPageTitle: self.quizViewModel.gaPageTitle, gaPageSubType: self.quizViewModel.gaPageSubType)                        
                        
                        Track.shared.trackSponsor(slot: "header", analyticsDomainName: self.analyticsDomainName, analyticsData: self.analyticsData)
                    }
                }
                
                orientation = UIDevice.current.orientation
                oldorientation = UIDevice.current.orientation
                if QUIZTheme.currentGameID == "uclquiz" || QUIZTheme.currentGameID == "weuroquiz"{
                    QUIZTheme.currentnavigation!.style(style: .withBgImage(image: QUIZTheme.getImage(named: QuizImageName.QSDKNavigationBG.name) ?? UIImage(),color:UIColor(QUIZTheme.getColor(named: .QSDK_NavImage051139))))
                }else if QUIZTheme.currentGameID == "uwclquiz" {
                    QUIZTheme.currentnavigation!.style(style: .withBgImage(image: QUIZTheme.getImage(named: QuizImageName.QSDKNavigationBG.name) ?? UIImage(),color:UIColor(QUIZTheme.getColor(named: .QSDK_NavImage051139))))
                }else if QUIZTheme.currentGameID == "euroquiz"{
                    QUIZTheme.currentnavigation!.style(style: .withBgImageEuro(image: QUIZTheme.getImage(named: QuizImageName.QSDK_EurosTopNavigationBar.name) ?? UIImage()))
                } else {
                    QUIZTheme.currentnavigation!.style(style: .blue())
                }
                
                
                QUIZTheme.navigateTo = nil
                QUIZTheme.quizID = nil
            
            }
        }
        
        .quizOnRotate { newOrientation in
            if !PasstoAnotherView {
                orientation = newOrientation
                QUIZTheme.updateViewLayout()
            }
        }
        
    }
    
    
    var ListRankview: some View {
        VStack{
            ScrollView
            {
                VStack(spacing:0)
                {
                    ForEach(0..<(self.quizViewModel.arrayleaderboardRanking.count), id: \.self)
                    { index in
                        
                        if let item  = self.quizViewModel.arrayleaderboardRanking[safe:index]{
                            VStack(spacing:0){
                                HStack{
                                    if (item.guid == QuizzGameSDk.game.store.QuizUser?.userGUID){
                                        RoundedRectangle(cornerRadius: 0)
                                            .fill(QUIZTheme.getColor(named: .QPSDKPrimary))
                                            .frame(width: 5,height: 56)
                                    }
                                    HStack(spacing:10){
                                        
                                        Text(QUIZTheme.isIpad ? String(item.rank ?? 0) : String(item.rank ?? 0).prefix(Constants.configData?.leaderboardMaxRankLength ?? 6) + (String(item.rank ?? 0).count > (Constants.configData?.leaderboardMaxRankLength ?? 6) ? ".." : ""))
                                            .lineLimit(1)
                                            .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 10))
                                            .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                                            .padding(.trailing,5)
                                        HStack {
                                            Spacer()
                                            Text(String(item.level ?? 0))
                                                .font(Font.swiftUICustomFont(customFont: .Champions_Light, size: 8))
                                                .foregroundColor(QUIZTheme.getColor(named: .QSDKButtonTitle00004B))
                                                .background(Image(uiImage: QUIZTheme.getImage(named: QuizImageName.QSDK_PointBg.name) ?? UIImage()))
                                            
                                        }.padding(.trailing,5)
                                            .padding(.top,25)
                                        
                                            .background(
                                                ZStack {
                                                    KFImage(URL(string: QUIZTheme.urlavtra(url:(item.avatar ?? ""))))
                                                        .placeholder {
                                                            QUIZTheme.getImage(named:QuizImageName.QSDK_GamingAvatarRed.name)
                                                        }
                                                        .retry(maxCount: 3, interval: .seconds(5))
                                                        .resizable()
                                                        .frame(width: 45.0, height: 45.0)
                                                } .frame(width: 45.0, height: 45.0)
                                            ) .frame(width: 45.0, height: 45.0)
                                        
                                        HStack(){
                                            if (item.fullname ?? "").count > (QUIZTheme.isIpad ? 25 : 17){
                                                Text(item.fullname ?? "")
                                                    .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 14))
                                                    .multilineTextAlignment(.leading)
                                                    .lineLimit(1)
                                                    .truncationMode(.middle)
                                                    .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                                                    .frame(width:QUIZTheme.isIpad ? 155 : 140)
                                                    .padding(.vertical, 1)
                                            }else{
                                                Text(item.fullname ?? "")
                                                    .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 14))
                                                    .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                                                    .lineLimit(1)
                                                    .padding(.vertical, 1)
                                            }
                                            if (item.guid == QuizzGameSDk.game.store.QuizUser?.userGUID){
                                                
                                                Text("(You)")
                                                    .font(Font.swiftUICustomFont(customFont: .SF_UI_Regular, size: 12))
                                                    .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite).opacity(0.7))
                                            }
                                            
                                        }.frame(maxWidth:.infinity ,alignment: .leading)
                                        if QUIZTheme.currentGameID == "weuroquiz"{
                                            Button {
                                                
                                            } label: {
                                                Text("\(item.correctaccuracy ?? 0)")
                                                    .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 14))
                                                    .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                                                    .frame(alignment: .center)
                                            }
                                            .frame(maxWidth: 50)
                                        }
                                        Button {
                                            
                                        } label: {
                                            if let overpo = item.overallpoints{
                                                if QUIZTheme.currentGameID != "weuroquiz"{
                                                    Spacer()
                                                }
                                                Text(QUIZTheme.isIpad ? String(overpo) : String(overpo).prefix(Constants.configData?.leaderboardMaxPointLength ?? 6) + (String(overpo).count > (Constants.configData?.leaderboardMaxPointLength ?? 6) ? ".." : ""))
                                                    .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 14))
                                                    .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                                            }else{
                                                Text("")
                                                    .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 14))
                                                    .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                                            }
                                        }
                                        .frame(maxWidth: 75)
                                    }.padding([.top,.bottom],5).padding([.leading,.trailing],10)
                                }.padding(.trailing,(item.guid == QuizzGameSDk.game.store.QuizUser?.userGUID) ? 0 : 0)
                                
                                Divider().background(QUIZTheme.getColor(named: .QPSDKWhite).opacity(0.3))
                            }
                            .background((item.guid == QuizzGameSDk.game.store.QuizUser?.userGUID) ? (QUIZTheme.getColor(named: .LD_Select_BG)) : Color.clear).ignoresSafeArea()
                            .padding([.leading,.trailing],(item.guid == QuizzGameSDk.game.store.QuizUser?.userGUID) ? QUIZTheme.isIpad ? (QUIZTheme.isLandscape && QUIZTheme.currentGameID == "weuroquiz" ? 232 : 52) : 0 : QUIZTheme.isIpad ? (QUIZTheme.isLandscape && QUIZTheme.currentGameID == "weuroquiz" ? 232 : 52) : 0)
                            
                        }
                    }
                    //MARK: Load More
                    if  quizViewModel.HideLoadMore && GamingHubCards.isLoggedIn{
                        loadMoreButton
                    }
                    
                    //MARK: SelfUserRank
                    if !quizViewModel.HideSelfRank && GamingHubCards.isLoggedIn{
                        
                        SelfUserRank(selfRankData: self.quizViewModel.selfRankData)
                        
                    }
                }
                .frame(maxWidth: .infinity)
                
                
            }
            if QUIZTheme.currentGameID == "weuroquiz"{
                Spacer()
                AdsSponsorsView()
                    .frame(width: 320)
                    .padding(.bottom, 10)
            }
        }
    }
    
    
    var loadMoreButton:some View{
        VStack{
            Button(action: {
                if  NetworkWrapper.isInternerConnected(){
                    quizViewModel.CurrentCount += 1
                    self.quizViewModel.LeaderBoardRankList(quizId: self.selectedLeaderBoardType?.quizid ?? quizId, offset: quizViewModel.CurrentCount, count: Constants.configData?.leaderBoardPagingPerPage ?? 50)
                }
            }) {
                VStack(alignment: .center, spacing: 5) {
                    Text(AppStrings.load_50_more_rows.getTranslationValue(default: "Load {count} more rows").replacingOccurrences(of: NetworkConstants().urlKeys.count, with: "\(Constants.configData?.leaderBoardPagingPerPage ?? 0)"))
                        .font(Font.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 14))
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .truncationMode(.middle)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(QUIZTheme.getColor(named: .QPSDKPrimary))
                        .padding()
                }.clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(QUIZTheme.getColor(named: .QPSDKPrimary), lineWidth: 1))
                
            }.frame(width:QUIZTheme.isIpad ? 200 : UIScreen.screenWidth - 32)
                .padding([.leading,.trailing], QUIZTheme.isIpad ? 52 : 16).padding([.top,.bottom], 14)
        }
    }
    
    func seTitle(id:Int)->String{
        "quiz_type_title_{quizId}".replacingOccurrences(of: NetworkConstants().urlKeys.quizId, with: "\(id)").getTranslationValue(default: id != 2 ? "Random Quiz" : "Daily Quiz")
    }
    
    
}


struct SelfUserRank : View {
    var selfRankData:[leaderboardRanking]? = nil
    @State private var isLandscape: Bool = UIDevice.current.orientation.isLandscape
    
    var body: some View {
        VStack(spacing:0){
            
            ForEach(0..<(selfRankData?.count ?? 0), id: \.self)
            { index in
                
                if let item  = selfRankData?[safe:index]{
                    VStack(spacing:0){
                        HStack{
                            if (item.guid == QuizzGameSDk.game.store.QuizUser?.userGUID){
                                RoundedRectangle(cornerRadius: 0)
                                    .fill(QUIZTheme.getColor(named: .QPSDKPrimary))
                                    .frame(width: 5,height: 56)
                            }
                            HStack(spacing:10){
                                Text(QUIZTheme.isIpad ? String(item.rank ?? 0) : String(item.rank ?? 0).prefix(Constants.configData?.leaderboardMaxRankLength ?? 6) + (String(item.rank ?? 0).count > (Constants.configData?.leaderboardMaxPointLength ?? 6) ? ".." : ""))
                                    .lineLimit(1)
                                    .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 10))
                                    .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                                    .padding(.trailing,5)
                                
                                HStack {
                                    Spacer()
                                    Text(String(item.level ?? 0))
                                        .font(Font.swiftUICustomFont(customFont: .Champions_Light, size: 8))
                                        .foregroundColor(QUIZTheme.getColor(named: .QSDKButtonTitle00004B))
                                        .background(Image(uiImage: QUIZTheme.getImage(named: QuizImageName.QSDK_PointBg.name) ?? UIImage()))
                                    
                                }.padding(.trailing,5)
                                    .padding(.top,25)
                                    .background(
                                        ZStack {
                                            KFImage(URL(string: QUIZTheme.urlavtra(url:(item.avatar ?? ""))))
                                                .placeholder {
                                                    QUIZTheme.getImage(named:QuizImageName.QSDK_GamingAvatarRed.name)
                                                }.retry(maxCount: 3, interval: .seconds(5))
                                                .resizable()
                                                .frame(width: 45.0, height: 45.0)
                                        } .frame(width: 45.0, height: 45.0)
                                    ) .frame(width: 45.0, height: 45.0)
                                
                                fullNameView(item: item)
                                
                                if QUIZTheme.currentGameID == "weuroquiz"{
                                    Button {
                                        
                                    } label: {
                                        Text("\(item.correctaccuracy ?? 0)")
                                            .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 14))
                                            .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                                            .frame(alignment: .center)
                                    }
                                    .frame(maxWidth: 50)
                                }
                                
                                Button {
                                    
                                } label: {
                                    if let overpo = item.overallpoints{
                                        Text(QUIZTheme.isIpad ? String(overpo) : String(overpo).prefix(Constants.configData?.leaderboardMaxPointLength ?? 6) + (String(overpo).count > (Constants.configData?.leaderboardMaxPointLength ?? 6) ? ".." : ""))
                                            .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 14))
                                            .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                                            .frame(alignment: .trailing)
                                            .frame(maxWidth: 75)
                                    }else{
                                        Text("")
                                    }
                                }
                                
                            }.padding([.top,.bottom],5).padding([.leading,.trailing],10)
                        }.padding(.trailing,(item.selfrank == 1) ? 0 : 0)
                        
                        Divider().background(QUIZTheme.getColor(named: .QPSDKWhite).opacity(0.3))
                    }
                    .background((item.guid == QuizzGameSDk.game.store.QuizUser?.userGUID) ? (QUIZTheme.getColor(named: .QSDK_151573)) : Color.clear).ignoresSafeArea()
                    .padding([.leading,.trailing],(item.guid == QuizzGameSDk.game.store.QuizUser?.userGUID) ?QUIZTheme.isIpad ? (isLandscape && QUIZTheme.currentGameID == "weuroquiz" ? 232 : 52) : 0 : QUIZTheme.isIpad ? (isLandscape && QUIZTheme.currentGameID == "weuroquiz" ? 232 : 52) : 0)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            isLandscape = UIDevice.current.orientation.isLandscape
        }
    }
   
}


struct fullNameView : View {
    var item:leaderboardRanking? = nil
    var body: some View {
        
        HStack(){
            if (item?.fullname ?? "").count > (QUIZTheme.isIpad ? 25 : 17){
                Text(item?.fullname ?? "")
                    .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 14))
                    .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                    .lineLimit(1)
                    .frame(width:QUIZTheme.isIpad ? 155 : 140)
                    .padding(.vertical, 1)
                
            }else{
                Text(item?.fullname ?? "")
                    .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 14))
                    .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                    .lineLimit(1)
                    .padding(.vertical, 1)
            }
            if (item?.guid == QuizzGameSDk.game.store.QuizUser?.userGUID){
                
                Text("(You)")
                    .font(Font.swiftUICustomFont(customFont: .SF_UI_Regular, size: 12))
                    .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite).opacity(0.7))
            }
            
        }.frame(maxWidth:.infinity ,alignment: .leading)
        
    }
}


struct LeaguesOverallStatsDataCell: View {
    
//    var vm : LeaguesMatchDayStatsViewModel?
    var statsTitle = "Overall Stats"
//    var overAllStatsCards:[LeaguesVM.PrivateLeagueDetailPageItems] = []
//    var privateLeagueDetailResponse: PrivateLeagueDetailResponseModel?
    
    var body: some View {
//        if overAllStatsCards.count > 0 {
            ZStack {
                VStack {
                    HStack {
                        Text(statsTitle)
                            .font(.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 24))
                            .foregroundColor(.white)
                            .frame(height: 16.0)
                            .padding([.top, .bottom], 16.0)
                        
                        Spacer()
                        
                    }
                    LeaguesOverallStatsCarouselCell()
                }
            }
//        }
    }
}

struct LeaguesOverallStatsCarouselCell: View {
    
    var body: some View {
//        if overAllStatsCards.count > 0 {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0.0) {
                    ForEach(0..<2, id: \.self) { index in
                        let width = UIScreen.screenWidth * 0.8/*(FantasyGame.game.isIpad) ? (parentViewWidth * 0.489) : UIScreen.uclfantasyscreenWidth * 0.80*/
                            Button {

                            } label: {
                                LeaguesOverallStatsCarouselHighScorerView(/*overAllStats: obj1,*/ viewWidth: width)
                                    .frame(width: width)
                                    .padding([.leading], index == 0 ? 0 : 0)
                                    .padding(.trailing,/* index == overAllStatsCards.count - 1 ? 0.0 :*/ 16.0)
                            }
                        }
                    }
                }
//        }
    }
}

struct LeaguesOverallStatsCarouselHighScorerView: View {
    
//    var vm : LeaguesOverallStatsScores?
//    var overAllStats:OverallStat?
    var viewWidth:CGFloat
    
    var body: some View {
            ZStack {
                HStack {
                    VStack(alignment: .leading) {
                        HStack{
                            VStack(alignment: .leading) {
                                HStack(alignment: .top) {
                                    QUIZTheme.getImage(named:QuizImageName.QSDK_icon_crown.name)?
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 12.0, height: 12.0)
                                    Text("most_high_scorer".getTranslationValue(default: "Most high scores"))
                                        .font(.swiftUICustomFont(customFont: .SF_UI_Regular, size: 12))
                                        .foregroundColor(.white.opacity(0.7))
                                    
                                }
                                Text("Cristiano Ronaldo")
                                    .font(.swiftUICustomFont(customFont: .SF_UI_Medium, size: 24))
                                    .foregroundColor(.white)
                                    .frame(width: (viewWidth * 0.55), alignment: .leading)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                            }
                            Spacer()
                            QUIZTheme.getImage(named:QuizImageName.QSDK_icon_crown.name)?
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18.0, height: 18.0)
                        }
                        
                        Spacer()
                        
                        HStack {
                                Text("89278")
                                .font(.swiftUICustomFont(customFont: .SF_UI_Medium, size: 16))
                                .foregroundColor(.white)
                            
                        }
                    }
                    .padding()
                    Spacer()
                }
                .background(QUIZTheme.getColor(named: .QSDK_0D3AFF))
                .cornerRadius(14.0)
            }.frame(height: 154)
//            .background(QUIZTheme.getColor(named: .QSDK_151573)//hex: "#0D1E62"
//                        
////                .overlay(
////                    Image.appImageNamed("LeaguesStatsBG")
////                        .resizable()
////                        .scaledToFill()
////                )
////                    .cornerRadius(14.0)
//            )
    }
}

struct leaderboardCardList: View {
    @StateObject var quizViewModel = HomeLandingViewModel()
    @State var isMenuPresented = false
//    @State private var selectedOption: String = "Overall"
//    let options = ["Overall", "Today", "This Week", "This Month", "Custom"]\
    @State private var showMenu = false
    @State private var selectedOption = "Overall"
    @State private var buttonFrame: CGRect = .zero
    
    let options = ["Overall", "Today", "This Week", "This Month", "Custom"]

    var body: some View{
        Menu {
            ForEach(0..<5) { index in
                Button("Option \(index)") {
                    selectedOption = "Option \(index)"
                }
            }
        } label: {
            HStack {
                Text(selectedOption)
                    .font(Font.swiftUICustomFont(customFont: .SF_UI_Regular, size: 16))
                    .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                Spacer()
                Image(uiImage: QUIZTheme.getImage(named: QuizImageName.QSDK_RightArrow.name) ?? UIImage())
                    .rotationEffect(.degrees(90))
            }
            .padding(.horizontal, 15)
            .frame(height: 45)
            .background(QUIZTheme.getColor(named: .QSDK_151573))
            .cornerRadius(10)
        }
    }
}


struct ButtonFrameReader: UIViewRepresentable {
    var onAppear: (CGRect) -> Void
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Accessing the frame after the view is rendered
            self.onAppear(view.frame)
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}


//MARK: - Current Window and Current Screen getters - Designed by MILIND T.
public func getCurrentVC() -> UIViewController! {
    guard let vc = UIApplication.shared.connectedScenes.compactMap({$0 as? UIWindowScene}).first?.windows.first?.rootViewController else {
        return UIViewController()
    }
    return vc
}

public extension UIApplication {
    func currentUIWindow() -> UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes.filter{ $0.activationState == .foregroundActive }.compactMap { $0 as? UIWindowScene }
        
        let window = connectedScenes.first?.windows.first { $0.isKeyWindow }
        return window
    }
}
//MARK: - Simple Share View Controller - Designed by MILIND T.
struct MNTCustSimplyShareViewController: UIViewControllerRepresentable {
    
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    var completionHandler: ((Bool, [Any]?, Error?) -> Void)?
    var isFromResultScreen: Bool? = false
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        print(activityItems)
        let filteredActivityItems: [Any] = activityItems.compactMap { item in
            if let activity = item as? String, activity == QUIZTheme.QuizScreenShotKey {
                return TakeScreenShotforQuiz()
            } else if let text = item as? String {
                return text
            } else if let image = item as? UIImage {
                return image
            } else if let url = item as? URL {
                return url
            }
            return nil
        }

        let controller = UIActivityViewController(activityItems: filteredActivityItems, applicationActivities: applicationActivities)
        
        controller.completionWithItemsHandler = { activityType, completed, returnedItems, error in
            self.completionHandler?(completed, returnedItems, error)
        }
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}

    private func TakeScreenShotforQuiz() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: UIScreen.main.bounds)
        return renderer.image { context in
            UIApplication.shared.windows.first?.layer.render(in: context.cgContext)
        }
    }
}
