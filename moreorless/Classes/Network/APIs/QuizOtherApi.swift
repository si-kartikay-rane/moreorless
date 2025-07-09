//
//  QuizOtherApi.swift
//  quiz
//
//  Created by Vishal Vijayvargiya on 22/11/23.
//

import Foundation
import GamesLib
class QuizOtherApi {
    static let shared = QuizOtherApi()
    
    func quizCardList(onSuccess: @escaping((Bool,cardListValue?) -> ()), onFailure: ((String) -> ())?=nil){
        guard let configData = Constants.configData else {
            onFailure?("Couldnt fetch config data")
            return
        }
        var quizCardURL1 =  ""
        if GamingHubCards.environment.environment == .integration{
            quizCardURL1 = configData.endpoints?.landingPageQuizCardUrl2 ?? "/quiz/services/card/v1/\(MOLTheme.currentGameID ?? "uclquiz")/gamelist?langCode=\(QuizzGameSDk.game.getAppLanguage())&isGuestUser=\(!GamingHubCards.isLoggedIn)"
        }else{
            quizCardURL1 = configData.endpoints?.landingPageQuizCardUrl2 ?? ""
        }
        quizCardURL1 = quizCardURL1.replacingOccurrences(of: NetworkConstants().urlKeys.isGuestUser, with: "\(!GamingHubCards.isLoggedIn)")
        quizCardURL1 = quizCardURL1.replacingOccurrences(of: NetworkConstants().urlKeys.languageCode, with: "\(QuizzGameSDk.game.getAppLanguage())")
      //  quizCardURL1 = quizCardURL1.replacingOccurrences(of: NetworkConstants().urlKeys.competitionType, with: MOLTheme.currentGameID ?? "uclquiz")
        
        quizCardURL1 = quizCardURL1 + "&buster=" + BusterHelper.shared.getBusterFor(type: .LEADERBOARD)

        NetworkWrapper.shared.GET(type:.DETAIL_BASE_URL, url: quizCardURL1, onSuccess: { responseJSON in
            let data:GenericResponseModel<cardListValue> = NetworkHelper.getDecodedData(from: responseJSON)
            if let value = data.Data.Value{
                onSuccess(true, value)
            }else{
                onSuccess(false, nil)
            }
        }, onFailure: { retVal in
            onFailure?(NetworkHelper.getErrorMessageFromTranslation(retVal: retVal, from: .none))
        }, headerType: .DEFAULT)
    }
    
    func quizCardListRankPointDisable(onSuccess: @escaping((Bool,[RankPointDisable]?) -> ()), onFailure: ((String) -> ())?=nil){
        guard let configData = Constants.configData else {
            onFailure?("Couldnt fetch config data")
            return
        }
        var quizCardURL = configData.endpoints?.landingPageQuizCardPointUrl ?? "/quiz/services/card/v2/\(MOLTheme.currentGameID ?? "uclquiz")/pending-attempt?langCode=\(QuizzGameSDk.game.getAppLanguage())&platformId={platformId}"
        quizCardURL = quizCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.isGuestUser, with: "\(!GamingHubCards.isLoggedIn)")
        quizCardURL = quizCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.languageCode, with: "\(QuizzGameSDk.game.getAppLanguage())")
        quizCardURL = quizCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.platformId, with: Constants.appData.platformID.description)
       // quizCardURL = quizCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.competitionType, with: MOLTheme.currentGameID ?? "uclquiz")
        
        quizCardURL = quizCardURL + "&buster=" + BusterHelper.shared.getBusterFor(type: .LEADERBOARD)
        
        NetworkWrapper.shared.GET(type:.DETAIL_BASE_URL, url: quizCardURL, onSuccess: { responseJSON in
            let data:GenericResponseModel<[RankPointDisable]> = NetworkHelper.getDecodedData(from: responseJSON)
            if let value = data.Data.Value{
                onSuccess(true, value)
            }else{
                onSuccess(false, nil)
            }
        }, onFailure: { retVal in
            onFailure?(NetworkHelper.getErrorMessageFromTranslation(retVal: retVal, from: .none))
        }, headerType: .DEFAULT)
        
    }
    
    func landingScreenLeaderboardList(onSuccess: @escaping((Bool,leaderboardValue?) -> ()), onFailure: ((String) -> ())?=nil){
        guard let configData = Constants.configData,  var leaderboardTopRankingURL = configData.endpoints?.leaderboardTopRankingUrlLive else {
            onFailure?("Couldnt fetch config data")
            return
        }
        
        var quizCardURL =  ""
       if GamingHubCards.isLoggedIn{
           quizCardURL =  leaderboardTopRankingURL + "&buster=" + BusterHelper.shared.getBusterFor(type: .LEADERBOARD)
       }else{
           quizCardURL =  (configData.endpoints?.guestUserLeaderBoardTopRankingUrlV2 ?? "") + "?buster=" + BusterHelper.shared.getBusterFor(type: .LEADERBOARD)
       }
        //quizCardURL = quizCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.competitionType, with: MOLTheme.currentGameID ?? "uclquiz")
        quizCardURL = quizCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.languageCode, with: "\(QuizzGameSDk.game.getAppLanguage())")
//        eotScoreURL = eotScoreURL.replacingOccurrences(of: NetworkConstants().urlKeys.tourId, with: Constants.appData.tourId.toString())
        
        NetworkWrapper.shared.GET(type:.DETAIL_BASE_URL, url: quizCardURL, onSuccess: { responseJSON in
            let data:GenericResponseModel<leaderboardValue> = NetworkHelper.getDecodedData(from: responseJSON)
            if let value = data.Data.Value{
                onSuccess(true, value)
            }else{
                onSuccess(false, nil)
            }
        }, onFailure: { retVal in
            onFailure?(NetworkHelper.getErrorMessageFromTranslation(retVal: retVal, from: .none))
        }, headerType: .ENTITY)
    }
    
    func LeaderboardMenuList(onSuccess: @escaping((Bool,[leaderboardMenuValue]?) -> ()), onFailure: ((String) -> ())?=nil){
        guard let configData = Constants.configData, let leaderboardUserRankingURL = configData.endpoints?.leaderboardUserRankingUrlLive else {
            onFailure?("Couldnt fetch config data")
            return
        }
        
        var quizCardURL = ""
        if GamingHubCards.isLoggedIn{
            
            quizCardURL =  leaderboardUserRankingURL  + "&buster=" + BusterHelper.shared.getBusterFor(type: .LEADERBOARD)
        }else{
            quizCardURL = (configData.endpoints?.guestUserOverViewLeaderBoardUrlV2 ?? "") + ("?buster=" + BusterHelper.shared.getBusterFor(type: .LEADERBOARD))
        }
        quizCardURL = quizCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.languageCode, with: "\(QuizzGameSDk.game.getAppLanguage())")
        //quizCardURL = quizCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.competitionType, with: MOLTheme.currentGameID ?? "uclquiz")
//        eotScoreURL = eotScoreURL.replacingOccurrences(of: NetworkConstants().urlKeys.tourId, with: Constants.appData.tourId.toString())
        
        NetworkWrapper.shared.GET(type:.DETAIL_BASE_URL, url: quizCardURL, onSuccess: { responseJSON in
            let data:GenericResponseModel<[leaderboardMenuValue]> = NetworkHelper.getDecodedData(from: responseJSON)
            if let value = data.Data.Value{
                onSuccess(true, value)
            }else{
                onSuccess(false, nil)
            }
        }, onFailure: { retVal in
            onFailure?(NetworkHelper.getErrorMessageFromTranslation(retVal: retVal, from: .none))
        }, headerType: .DEFAULT)
    }
    
    func LeaderboardRankList(quizId:String?,offset:Int?,count:Int?,onSuccess: @escaping((Bool,leaderboardRankValue?) -> ()), onFailure: ((String) -> ())?=nil){
        guard let configData = Constants.configData, var leaderboardUserRankingURL = configData.endpoints?.leaderboardRankingUrlLive else {
            onFailure?("Couldnt fetch config data")
            return
        }
        var quizCardURL = ""
        if GamingHubCards.isLoggedIn{
            quizCardURL = leaderboardUserRankingURL + "&buster=" + BusterHelper.shared.getBusterFor(type: .LEADERBOARD)
        }else{
            quizCardURL = (configData.endpoints?.guestUserLeaderBoardRankingUrlV2 ?? "") + ("?buster=" + BusterHelper.shared.getBusterFor(type: .LEADERBOARD))
        }
        //quizCardURL = quizCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.competitionType, with: MOLTheme.currentGameID ?? "uclquiz")
        quizCardURL = quizCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.quizId, with: quizId ?? "")
        quizCardURL = quizCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.offSet, with: "\(offset ?? 0)")
        quizCardURL = quizCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.totalCount, with: "\(count ?? 0)")
        quizCardURL = quizCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.quizType, with: "\(quizId ?? "")")
        quizCardURL = quizCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.languageCode, with: "\(QuizzGameSDk.game.getAppLanguage())")
        NetworkWrapper.shared.GET(type:.DETAIL_BASE_URL, url: quizCardURL, onSuccess: { responseJSON in
            let data:GenericResponseModel<leaderboardRankValue> = NetworkHelper.getDecodedData(from: responseJSON)
            if let value = data.Data.Value{
                onSuccess(true, value)
            }else{
                onSuccess(false, nil)
            }
        }, onFailure: { retVal in
            onFailure?(NetworkHelper.getErrorMessageFromTranslation(retVal: retVal, from: .none))
        }, headerType: .ENTITY)
    }
    
    func LeaderboardSelfRankList(quizId:String?,onSuccess: @escaping((Bool,selfRankDataValue?) -> ()), onFailure: ((String) -> ())?=nil){
        guard let configData = Constants.configData, var leaderboardSelfUserRankingURL = configData.endpoints?.leaderboardSelfUserRankingUrlLive else {
            onFailure?("Couldnt fetch config data")
            return
        }
        leaderboardSelfUserRankingURL =   leaderboardSelfUserRankingURL + "&buster=" + BusterHelper.shared.getBusterFor(type: .LEADERBOARD)
        leaderboardSelfUserRankingURL = leaderboardSelfUserRankingURL.replacingOccurrences(of: NetworkConstants().urlKeys.quizId, with: quizId ?? "")
       // leaderboardSelfUserRankingURL = leaderboardSelfUserRankingURL.replacingOccurrences(of: NetworkConstants().urlKeys.competitionType, with: MOLTheme.currentGameID ?? "uclquiz")
        NetworkWrapper.shared.GET(type:.DETAIL_BASE_URL, url: leaderboardSelfUserRankingURL, onSuccess: { responseJSON in
            let data:GenericResponseModel<selfRankDataValue> = NetworkHelper.getDecodedData(from: responseJSON)
            if let value = data.Data.Value{
                onSuccess(true, value)
            }else{
                onSuccess(false, nil)
            }
        }, onFailure: { retVal in
            onFailure?(NetworkHelper.getErrorMessageFromTranslation(retVal: retVal, from: .none))
        }, headerType: .DEFAULT)
    }
    
    func SettlementData(quizID:String?,QuAttemptId:Int?,GamedayId:Int?,isExit:Int,onSuccess: @escaping((Bool) -> ()), onFailure: ((String) -> ())?=nil){
        guard let configData = Constants.configData else {
            onFailure?("Couldnt fetch config data")
            return
        }
        var settlement = configData.endpoints?.quizGameSettleURL ?? ""
        //let lastURl = "/quiz/services/Gameplay/\(GamingHubCards.user.userId ?? 0)/\(quizID ?? "")/settlement?GamedayId=\(GamedayId ?? 0)&AttemptId=\(QuAttemptId ?? 0)&PlatformId=1&backdoor=sanzensekai&isExit=\(isExit)"
 
        settlement = settlement.replacingOccurrences(of: NetworkConstants().urlKeys.gameId, with: "\(quizID ?? "")")
        settlement = settlement.replacingOccurrences(of: NetworkConstants().urlKeys.gameDayId, with: "\(GamedayId ?? 0)")
        settlement = settlement.replacingOccurrences(of: NetworkConstants().urlKeys.attemptId, with: "\(QuAttemptId ?? 0)")
        settlement = settlement.replacingOccurrences(of: NetworkConstants().urlKeys.guid, with: "\(GamingHubCards.user.userId ?? 0)")
        settlement = settlement.replacingOccurrences(of: NetworkConstants().urlKeys.platformId, with: "\(Constants.appData.platformID)")
        settlement = settlement.replacingOccurrences(of: NetworkConstants().urlKeys.isExit, with: "\(isExit)")
        
        let request: QuizRequestModel? = nil
        NetworkWrapper.shared.POST(type: .BASE_URL, url: settlement, params: request, onSuccess: { responseJSON in
            
            onSuccess(true)
        }, onFailure: { retVal in
            onFailure?(NetworkHelper.getErrorMessageFromTranslation(retVal: retVal, from: .none))
        }, headerType: .DEFAULT)
    }
    
    
    func GameStatus(quizID:String,onSuccess: @escaping((GameStatus?) -> ()), onFailure: ((String) -> ())?=nil){
        let user = GamingHubCards.user
    
        guard let configData = Constants.configData else {
            onFailure?("Couldnt get config data login")
            return}
      
        var GameStatus = (configData.endpoints?.quizGameStatusUrl ?? String.empty) //+ "?backdoor={backdoor}"
        GameStatus = GameStatus.replacingOccurrences(of: NetworkConstants().urlKeys.guid, with: "\(GamingHubCards.user.userId ?? 0)")
        GameStatus = GameStatus.replacingOccurrences(of: NetworkConstants().urlKeys.gameId, with: quizID)
       
    
        
        
        NetworkWrapper.shared.GET(type:.DETAIL_BASE_URL, url: GameStatus, onSuccess: { responseJSON in
            
            let data: GenericResponseModel<GameStatus> = NetworkHelper.getDecodedData(from: responseJSON)

            onSuccess(data.Data.Value)
        }, onFailure: { retVal in
            
            onFailure?(NetworkHelper.getErrorMessageFromTranslation(retVal: retVal, from: .none))
        }, headerType: .DEFAULT)
    }
}
