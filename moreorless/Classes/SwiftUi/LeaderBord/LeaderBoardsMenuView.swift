//
//  LeaderBoardsMenuView.swift
//  quiz
//
//  Created by Vishal Vijayvargiya on 27/10/23.
//

import SwiftUI
import Kingfisher
import GamesLib

struct LeaderBoardsMenuView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var quizViewModel = HomeLandingViewModel()
    @State private var showLeaderBoardView = false
    @State private var PasstoAnotherView = false
    @State private var current_screen_name = "/leaderboard"
    @State var analyticsDomainName: String = ""
    @State var analyticsData: TrackingParameters = TrackingParameters([:] as [String: Any?]?)
    var body: some View {
        ZStack(alignment:.top){
            if QUIZTheme.currentGameID == "weuroquiz"
            {
                QUIZTheme.getColor(named: .QSDKEuroBG).ignoresSafeArea()
            }
            else{
                QUIZTheme.getColor(named: .QSDKBackGround_000040).ignoresSafeArea()
            }
            ScrollView{
                VStack(spacing:16.0){
                    AdsPresentedbyView(VerticaleEnable: false, analyticsDomainName: self.analyticsDomainName, analyticsData: self.analyticsData)
                VStack{
                    VStack{
                        HStack{
                            
                            Button {
                                
                            } label: {
                                Text(AppStrings.Leaderboard.getTranslationValue(default: "Leaderboard"))
                                    .font(Font.swiftUICustomFont(customFont: .SF_UI_Regular, size: 14))
                                    .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                                    .opacity(0.7)
                            }
                            
                            Spacer()
                            
                            Button {
                                
                            } label: {
                                Text(AppStrings.Rank.getTranslationValue(default: "Rank"))
                                    .font(Font.swiftUICustomFont(customFont: .SF_UI_Regular, size: 14))
                                    .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                                    .opacity(0.7)
                            }
                            
                        }.frame(height: 36)
                        .padding([.leading,.trailing],18)
                        
                        Divider().background(QUIZTheme.getColor(named: .QPSDKWhite).opacity(0.75)).padding([.leading,.trailing],16)
                        
                        ListView
                        
                        
                    }.padding(.bottom,10)
                    .padding([.top,.bottom],10)
                    
                }.background(QUIZTheme.getColor(named: .QSDK_0A0A61))
                    .frame(width: QUIZTheme.isIpad ? 400 : UIScreen.screenWidth-32)
                    .cornerRadius(14)
                   
                    AdsSponsorsView().frame(width: QUIZTheme.isIpad ? 320 : UIScreen.screenWidth-32)
            }
                NavigationLink("", destination: LeaderboardView( selectedLeaderBoardType: self.quizViewModel.selectedLeaderBoardType).navigationBarTitleDisplayMode(.inline),isActive:$showLeaderBoardView)
            }.padding([.top,.bottom], QuizzGameSDk.game.sponsorModel?.imageUrl == nil ? 16 : 0)
            .navigationBarItems(leading:
                                Button(action: {
                if  NetworkWrapper.isInternerConnected(){
                    self.presentationMode.wrappedValue.dismiss()
                }
        }) {
            Image(uiImage:QUIZTheme.getImage(named:QuizImageName.QSDK_NavBack.name) ?? UIImage())
                .imageScale(.large)
               
        }
        ).navigationBarBackButtonHidden()
        .navigationBarTitle(AppStrings.Leaderboards.getTranslationValue(default: "Leaderboards"), displayMode: .large)
        }.ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear{
            let (analyticsDomainName, analyticsData) = Track.shared.get_screen_domain_params(screen: current_screen_name, params: [:], replace: nil)
            self.analyticsDomainName = analyticsDomainName
            self.analyticsData = analyticsData
            GamingHubCards.registerTrackingDefaults(analyticsData, domain: analyticsDomainName, gameId: QUIZTheme.currentGameID ?? "uclquiz")
            Track.shared.screen(screen: current_screen_name, params: [:], replace: nil)
            Track.shared.trackSponsor(slot: "header", analyticsDomainName: analyticsDomainName, analyticsData: analyticsData)
            self.quizViewModel.LeaderBoardMenufun()
            QUIZTheme.currentnavigation!.style(style: .withBgImage(image: QUIZTheme.getImage(named: QuizImageName.QSDKNavigationBG.name) ?? UIImage(), color: UIColor(QUIZTheme.getColor(named: .QSDK_NavImage051139))))
        }
    }
    
    
    
    var ListView:some View{
        ForEach(quizViewModel.LeaderBoardMenu.indices, id: \.self) { index  in
            if let item = quizViewModel.LeaderBoardMenu[safe:index] {
                Button {
                    if  NetworkWrapper.isInternerConnected(){
                        self.showLeaderBoardView  =  true
                        self.quizViewModel.selectedLeaderBoardType =  item
                    }
                } label: {
                    HStack(spacing:12){
                        
                        ZStack(alignment:.center) {
                            
                            KFImage(URL(string: (item.avatar ?? "")))
                                .placeholder {
                                    QUIZTheme.getImage(named: imageName(quiztype: item.quiztypeid ?? 0))?
                                        .resizable()
                                }
                                .retry(maxCount: 3, interval: .seconds(5))
                                .resizable()
                            
                        } .frame(width: 35.0, height: 35.0)
                            .padding(.bottom,(index !=  self.quizViewModel.LeaderBoardMenu.count - 1) ? 13 : 0)
                        VStack{
                            HStack{
                                VStack(alignment:.leading,spacing: 2){
                                    Text(item.leaderboardtitle ?? .empty ).font(Font.swiftUICustomFont(customFont: .SF_UI_Bold, size: 16))
                                    
                                    Text(AppStrings.players.getTranslationValue(default: "players").replacingOccurrences(of: NetworkConstants().urlKeys.totalplayer, with: item.totalplayer ?? "")).font(Font.swiftUICustomFont(customFont: .SF_UI_Regular, size: 12)).opacity(0.7)
                                }
                                Spacer().disabled(true)
                                if let ranksuser = item.userrank{
                                    if ranksuser != 0 {
                                        Text(Constants.isLogin ? "\(ranksuser)" : "")
                                            .font(Font.swiftUICustomFont(customFont: .SF_UI_Bold, size: 14))
                                    }else{
                                        Text("")
                                    }
                                }else{
                                    Text(Constants.isLogin ? "\("")" : "")
                                }
                                Image(uiImage: QUIZTheme.getImage(named: QuizImageName.QSDK_RightArrow.name) ?? UIImage()).frame(width:24,height: 24)
                            }
                            if(index !=  self.quizViewModel.LeaderBoardMenu.count - 1)
                            {
                                Divider().background(QUIZTheme.getColor(named: .QPSDKWhite)).opacity(0.75).padding(.top,5)
                            }
                        }
                    }
                }
                
                .padding([.top,.bottom],2).padding([.leading,.trailing],16)
                .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
            }
        }
    }
    
    func seTitle(id:Int)->String{
        "quiz_type_title_{quizId}".replacingOccurrences(of: NetworkConstants().urlKeys.quizId, with: "\(id)").getTranslationValue(default: id != 2 ? "Random Quiz" : "Daily Quiz")
    }
    
    func imageName(quiztype:Int) -> String
    {
        switch quiztype {
        case 1:
            return QuizImageName.RandomQuizicon.name
        case 2:
            return  QuizImageName.QSDK_Dayily.name
        case 3:
            return  QuizImageName.QSDK_MOl.name
        default:
            return QuizImageName.QSDKLOGO.name
        }
    }
}
