//
//  LeaderBoardLandingView.swift
//  quiz
//
//  Created by Vishal Vijayvargiya on 10/10/23.
//

import SwiftUI
import GamesLib
import Kingfisher

struct LeaderBoardLandingView: View {
    
    var items = ["Item 1", "Item 2", "Item 3",]
    @State private var showLeaderBoardView = false
    @ObservedObject var viewModelCard :HomeLandingViewModel = HomeLandingViewModel()
    var current_screen_name : String
    var buttonAction: (Bool) -> Void
    var viewleaderrankAction: (String,String) -> Void// Closure to handle button click
    var body: some View {
        ZStack(alignment:.center){
            
            VStack(alignment:.leading){
                
                Text(AppStrings.Leaderboards.getTranslationValue(default: "leaderboards"))
                    .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 20))
                    .foregroundColor(.white)
                    .padding(.all,16)
                
                scrollView
                
                Button {
                    //showLeaderBoardView =  true
                    if  NetworkWrapper.isInternerConnected(){
                        self.buttonAction(true)
                        //                        Track.shared.event(event:  .viewallleaderboard, name: screenName.overview, params: nil)
                        
                        //                        let G4A = GoToQuizArena(quizType: cardData.quiztypeid == 2 ? .FUN_QUIZ : .DAILY_QUIZ, isLoggedIn: GamingHubCards.isLoggedIn)
                        //                        Track.shared.event(G4A: G4A, name: screenName.quizResult, params: nil,replaceString:(Constants.configData?.quizTypeTrackingKey?["\(self.cardData.quiztypeid ?? 0)"]  as? String ?? ""),quizId: viewModel.quizID)
                        
                        //                        let G4A = QuizzerAnalyticsViewAllLeaderboard()
                        //                        Track.shared.event(G4A: G4A, name: current_screen_name, params: nil)
                        //
                    }
                } label: {
                    Text(AppStrings.Viewallleaderboards.getTranslationValue(default: "view all leaderboards"))
                        .foregroundColor(MOLTheme.getColor(named: .QPSDKPrimary))
                        .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 14))
                        .padding(.all,16)
                }
                
                NavigationLink("", destination: LeaderBoardsMenuView().navigationBarTitleDisplayMode(.inline),isActive:$showLeaderBoardView )
                
            }
            .background(MOLTheme.getColor(named: .QSDK_0A0A61))
            .cornerRadius(14)
            
            
        }.ignoresSafeArea(.keyboard, edges: .bottom)
        
        
    }
    
    
    //MARK: Sub View
    var scrollView : some View{
        ScrollView(.horizontal,showsIndicators:false) {
            leaderboardSectionView
        }.padding([.leading],16)
    }
    
    
    var leaderboardSectionView : some View{
        HStack(alignment:.top) {
            // 1
            ForEach(0..<(self.viewModelCard.LeaderboardList?.count ?? 0 ),id: \.self) { section in
                if (self.viewModelCard.LeaderboardList?[safe: section]?.topranking) != nil  {
                    
                    Button(action: {
                        if  NetworkWrapper.isInternerConnected(){
                            viewleaderrankAction( self.viewModelCard.LeaderboardList?[safe: section]?.quizid ?? "", "\(self.viewModelCard.LeaderboardList?[safe: section]?.quiztypeid ?? 0)")
                        }
                    }, label: {
                        leaderboardCellview(section: section,topranking: self.viewModelCard.LeaderboardList?[safe:section]?.topranking,LeaderboardList:  self.viewModelCard.LeaderboardList) { quizid, quiztypeid in
                            viewleaderrankAction( quizid, quiztypeid)
                        }
                    }).padding(.trailing,section == ((self.viewModelCard.LeaderboardList?.count ?? 0 ) - 1) ? 16 : 0)
                    
                }
            }
        }
    }
    
    
}


struct leaderboardCellview:View{
    @State var section:Int
    @State var topranking: [leaderboardRanking]? =  nil
    @State var LeaderboardList:[Leaderboard]? =  nil
    var viewleaderrankAction: (String,String) -> Void
    var body: some View {
        VStack(alignment:.leading,spacing:0){
            
            Text(LeaderboardList?[safe:section]?.leaderboardtitle ?? "")
                .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 16))
                .foregroundColor(MOLTheme.getColor(named: .QPSDKWhite))
                .multilineTextAlignment(.leading)
                .padding([.all],16)
            Divider().background(MOLTheme.getColor(named: .QPSDKWhite)).opacity(0.3)
            // ScrollView(.vertical){
            VStack(alignment:.leading,spacing:0){
                ForEach(0..<(topranking?.count ?? 0),id: \.self) { Index in
                    
                    if let topRanking = topranking?[safe:Index] {
                        let leaderboardCount = topranking?.count
                        let isLastElement = (Index == (leaderboardCount ?? 0) - 1)
                        HStack{
                            if (topRanking.guid == Constants.guid){
                                RoundedRectangle(cornerRadius: 0)
                                    .fill(MOLTheme.getColor(named: .QPSDKPrimary))
                                    .frame(width: 3,height: 56)
                            }
                            Text(String(topRanking.rank ?? 0))
                                .font(Font.swiftUICustomFont(customFont: .SF_UI_Regular, size: 14))
                                .multilineTextAlignment(.leading)
                                .foregroundColor(MOLTheme.getColor(named: .QPSDKWhite)).opacity(0.7)
                                .frame(minWidth: (topRanking.guid == Constants.guid) ? 11 : 25)
                                .padding(.leading, (topRanking.guid == Constants.guid) ? 0 : 5)
                            HStack {
                                Spacer()
                                Text(String(topRanking.level ?? 0))
                                    .font(Font.swiftUICustomFont(customFont: .Champions_Light, size: 8))
                                    .foregroundColor(MOLTheme.getColor(named: .QSDKButtonTitle00004B))
                                    .background(Image(uiImage: MOLTheme.getImage(named: QuizImageName.QSDK_PointBg.name) ?? UIImage()))
                                    .lineLimit(1)
                            }.padding(.trailing,5)
                                .padding(.top,25)
                            
                            
                                .background(
                                    ZStack {
                                        KFImage(URL(string: MOLTheme.urlavtra(url: topranking?[Index].avatar ?? "")))
                                            .placeholder {
                                                MOLTheme.getImage(named:QuizImageName.QSDK_GamingAvatarRed.name)
                                            }
                                            .retry(maxCount: 3, interval: .seconds(5))
                                            .resizable()
                                            .frame(width: 45.0, height: 45.0)
                                    } .frame(width: 45.0, height: 45.0)
                                ) .frame(width: 45.0, height: 45.0)
                            
                            Text(((topRanking.fullname ?? "").prefix(MOLTheme.isIpad ? 12 : 8)) + ((topRanking.fullname ?? "").count > (MOLTheme.isIpad ? 12 : 8) ? ".." : ""))
                                .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 16))
                                .foregroundColor(MOLTheme.getColor(named: .QPSDKWhite))
                                .lineLimit(1)
                                .onTapGesture{
                                    if  NetworkWrapper.isInternerConnected(){
                                        viewleaderrankAction( LeaderboardList?[safe: section]?.quizid ?? "", "\(LeaderboardList?[safe: section]?.quiztypeid ?? 0)")
                                    }
                                }
                            //}
                            Spacer(minLength: 8)
                            
                            Text(MOLTheme.isIpad ? String(topRanking.overallpoints ?? 0)  : String(topRanking.overallpoints ?? 0).prefix( Constants.configData?.leaderboardMaxPointLength ?? 6) + (String(topRanking.overallpoints ?? 0).count > (Constants.configData?.leaderboardMaxPointLength ?? 6) ? ".." : "") )
                                .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 20))
                                .foregroundColor(MOLTheme.getColor(named: .QPSDKWhite))
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .padding(.trailing,16)
                            
                        }
                        .frame(height:61)
                        .background((topRanking.guid == Constants.guid) ? (MOLTheme.getColor(named: .LD_Select_BG)) : Color.clear).ignoresSafeArea()
                        .padding(.bottom, (topRanking.guid == Constants.guid && isLastElement) ? 10 : 0)
                        if(Index !=  (LeaderboardList?[safe:section]?.topranking?.count ?? 0) - 1)
                        {
                            Divider().background(MOLTheme.getColor(named: .QPSDKWhite)).padding([.leading,.trailing],8).opacity(0.3)
                        }
                    }
                }
            } .frame(minWidth:283)
                .padding(.top,0)
            
        }
        .background(MOLTheme.getColor(named: .QSDK_151573))
        .cornerRadius(14)
        
    }
    
   
}


