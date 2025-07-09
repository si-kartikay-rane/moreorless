//
//  HomeLandingViewMOdel.swift
//  quiz
//
//  Created by Vishal Vijayvargiya on 12/10/23.
//

import Foundation
import SwiftyJSON
import GamesLib
class HomeLandingViewModel:ObservableObject{
    
    @Published var cardSelection:MolCardListData? =  nil
    @Published var cardList:[MolCardListData]? = []
    @Published var LeaderboardList:[Leaderboard]? = []
    @Published var LeaderBoardMenu:[leaderboardMenuValue] = []
    @Published var selectedLeaderBoardType:leaderboardMenuValue? =  nil
    @Published var showHideleaderBoard:Bool = false
    @Published var arrayleaderboardRanking:[leaderboardRanking] = []
    @Published var isLoading:Bool = false
    @Published var CurrentCount:Int  =  0
    @Published var selfRankData:[leaderboardRanking]? = nil
    @Published var HideLoadMore:Bool =  false
    @Published var HideSelfRank:Bool =  false
    @Published var viewCGRect: CGRect = .zero
    @Published var typeTitle:String? = ""
    @Published var gaTitlePassed:String? = ""
    @Published var gaPageTitle: String? = ""
    @Published var gaPageSubType: String? = ""
    @Published var gaPageName: String? = ""
    @Published var quizType:Int? = nil
    @Published var gameType:String? = nil
    @Published var showErrorPopup = false
    @Published var error: String = ""
    @Published var AdbannerViewOrder:Int? = nil
    @Published var InviteViewOrder:Int? = nil
    @Published var isSetteled:Bool =  false
    
    func getQuizStatuslApi(quizID:String){
        guard let configData = Constants.configData, var quizStartGameURL = configData.endpoints?.quizStartGameURL else {
           
            return
        }
        let urluser = "/quiz/services/Gameplay/quiz-status?quizId=\(quizID)"
   
        let request: QuizRequestModel? = nil
        
        
        NetworkWrapper.shared.POST(type: .DETAIL_BASE_URL, url: urluser, params: request, onSuccess: { responseJSON in
            
            do {
                if let jsonDictionary = try JSONSerialization.jsonObject(with: responseJSON.rawData(), options: []) as? [String: Any] {
                    if let data = jsonDictionary["Data"] as? [String: Any], let value = data["Value"] as? Int {
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            if let cardIndex = self.cardList?.firstIndex(where: { $0.qzQuizMasterid == quizID }) {
                               // (self.cardList?[cardIndex].isDisable ?? false) = (value != 0) ? true : false
                            }
                        }
                    } else {
                        
                    }
                } else {
                
                }
            } catch {
                
            }
            
           
        }, onFailure: { retVal in
           
           
        }, headerType: .DEFAULT)
    }
    
    
    func cardListdata(){
        self.cardList = nil
        MolOtherApi.shared.molCardList { staus, MolCardListData2 in
            if staus{
                DispatchQueue.main.async {
                    self.cardList =  MolCardListData2?.quizcard
                    if GamingHubCards.isLoggedIn {
                        self.rankpointupdate()
                    }
//                    if GamingHubCards.environment.environment == GamingHubEnvironment.integration{
//                        
//                        self.cardList?.append(MolCardListData(title: "More or Less", quiztype: "3", subtitle: "Play for fun", isdisable: 0, description: "Guess 10 UCL-themed questions which players have more or less goals, appearances or saves", qzQuizMasterid: "123", quiztypeid: 3, bgimage: "", cta: "open", rank: 0, points: 0))
//                    }
                    self.isLoading =  false
                    for obj in Constants.configData?.landingPageItems ?? []{
                        if obj.itemID == 4 {
                            self.InviteViewOrder = (obj.visible ?? false ) ? obj.order ?? 0 : nil
                        }else if obj.itemID == 5 {
                            self.AdbannerViewOrder = (obj.visible ?? false ) ? obj.order ?? 0 : nil
                        }
                    }
                }
            }else {
                DispatchQueue.main.async {
                    self.isLoading =  false
                }
            }
            
        }
    }
    
    func rankpointupdate(){
        MolOtherApi.shared.quizCardListRankPointDisable { status, rankandpoint in
            if status{
                self.mergeData(quizCards: self.cardList ?? [], quizStatuses: rankandpoint ?? [])
            }
        }
    }
    
    func mergeData(quizCards: [MolCardListData], quizStatuses: [RankPointDisable]) {
            // Map quizStatuses for quicker access
            let statusMap = Dictionary(uniqueKeysWithValues: quizStatuses.map { ($0.quizid, $0) })
            
            // Merge data
        self.cardList = quizCards.map { card in
                var combinedCard = card
                if let status = statusMap[card.qzQuizMasterid] {
                    combinedCard.isDisable = status.isdisable
                    combinedCard.rank = status.rank
                    combinedCard.points = status.points
                    combinedCard.timer =  status.timer
                }
                return combinedCard
            }
        }
    
    func LeaderboardListdata(){
        self.LeaderboardList = []
        MolOtherApi.shared.landingScreenLeaderboardList { Status, leaderboardValue in
            if Status {
                
                self.LeaderboardList =  leaderboardValue?.leaderboard?.filter { !($0.topranking?.isEmpty ?? true) }
                
                for section in 0..<(self.LeaderboardList?.count ?? 0) {
                    if let configData = self.LeaderboardList?[section].topranking, !configData.isEmpty {
                        self.showHideleaderBoard = true
                        break // Exit the loop once a non-nil and non-empty topranking is found
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    DispatchQueue.main.async {
                        self.isLoading =  false
                    }
                }
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    DispatchQueue.main.async {
                        self.isLoading =  false
                        self.showHideleaderBoard = false
                    }
                }
            }
        }
    }
    
    func LeaderBoardMenufun(){
        MolOtherApi.shared.LeaderboardMenuList { Status, leaderboardMenu in
            if Status {
                self.LeaderBoardMenu = leaderboardMenu ?? []
            }
        }
    }
    
    func LeaderBoardRankList(quizId: String?, offset: Int?, count: Int){
        MolOtherApi.shared.LeaderboardRankList(quizId: quizId, offset: offset, count: count) { Status, leaderboardRankValue in
            if Status {
                
                if let data  = leaderboardRankValue{
                    
                    if (data.maxoffset ?? 0) > self.CurrentCount {
                        self.HideLoadMore =  true
                    }else{
                        self.HideLoadMore =  false
                    }
                    let  userinfo = data.userInfo ?? []
                    let selfrank  =  userinfo.first(where: {$0.guid == MolGameSDk.game.store.QuizUser?.userGUID})
                    if selfrank?.guid == MolGameSDk.game.store.QuizUser?.userGUID{
                        self.HideSelfRank = true
                    }
                    self.arrayleaderboardRanking = data.userInfo ?? []
                    self.typeTitle = data.leaderboardtitle
                    self.gaTitlePassed = data.ga_title
                    self.gaPageTitle = data.GA_PageTitle
                    self.gaPageSubType = data.GA_PageSubType
                    self.gaPageName = data.GA_PageName
                    self.quizType = data.quiztypeid
                    self.gameType = data.gametype
                    self.isLoading = false
                }
            } else {
                self.isLoading = false
            }
        }
    }
    
    func LeaderBoardSelfRankList(quizId: String?){
        MolOtherApi.shared.LeaderboardSelfRankList(quizId: quizId) { Status, leaderboardRankValue in
            if Status {
                
                if let data  = leaderboardRankValue{
                    self.selfRankData =  data.userdata
                }
            }
        }
    }
    
    func SettlementData(quizId: String?, attempt: Int?,GamedayId:Int?,isExit:Int,onSuccess: @escaping((Bool) -> ())){
        MolOtherApi.shared.SettlementData(quizID: quizId, QuAttemptId: attempt,GamedayId:GamedayId, isExit: isExit) { Status in
            if Status {
                BusterHelper.shared.updateBuster(type: .LEADERBOARD)
                onSuccess(Status)
            }else{
                onSuccess(false)
            }
        }
    }
    
    func GameStatustData(quizId: String?,onSuccess: @escaping((GameStatus?) -> ())){
        MolOtherApi.shared.GameStatus(quizID: quizId ?? "") { gamedata in
            if (gamedata != nil) {
                
                onSuccess(gamedata)
            }else{
                onSuccess(nil)
            }
        }
    }
    
    
    
}
