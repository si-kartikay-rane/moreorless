//
//  MolOtherApi.swift
//  quiz
//
//  Created by Vishal Vijayvargiya on 22/11/23.
//

import Foundation
import GamesLib
class MolOtherApi {
    static let shared = MolOtherApi()
    
    func molCardList(onSuccess: @escaping((Bool,cardListValue?) -> ()), onFailure: ((String) -> ())?=nil){
        guard let configData = Constants.configData else {
            onFailure?("Couldnt fetch config data")
            return
        }
        var molCardURL =  ""
        if GamingHubCards.environment.environment == .integration{
            molCardURL = configData.endpoints?.landingPageQuizCardUrl2 ?? "/quiz/services/card/v1/\(MOLTheme.currentGameID ?? "uclmoreorless")/gamelist?langCode=\(QuizzGameSDk.game.getAppLanguage())&isGuestUser=\(!GamingHubCards.isLoggedIn)"
        }else{
            molCardURL = configData.endpoints?.landingPageQuizCardUrl2 ?? ""
        }
        molCardURL = molCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.isGuestUser, with: "\(!GamingHubCards.isLoggedIn)")
        molCardURL = molCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.languageCode, with: "\(QuizzGameSDk.game.getAppLanguage())")
      //  molCardURL = molCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.competitionType, with: MOLTheme.currentGameID ?? "uclmoreorless")
        
        molCardURL = molCardURL + "&buster=" + BusterHelper.shared.getBusterFor(type: .LEADERBOARD)

        NetworkWrapper.shared.GET(type:.DETAIL_BASE_URL, url: molCardURL, onSuccess: { responseJSON in
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
        var molCardURL = configData.endpoints?.landingPageQuizCardPointUrl ?? "/quiz/services/card/v2/\(MOLTheme.currentGameID ?? "uclmoreorless")/pending-attempt?langCode=\(QuizzGameSDk.game.getAppLanguage())&platformId={platformId}"
        molCardURL = molCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.isGuestUser, with: "\(!GamingHubCards.isLoggedIn)")
        molCardURL = molCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.languageCode, with: "\(QuizzGameSDk.game.getAppLanguage())")
        molCardURL = molCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.platformId, with: Constants.appData.platformID.description)
       // molCardURL = molCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.competitionType, with: MOLTheme.currentGameID ?? "uclmoreorless")
        
        molCardURL = molCardURL + "&buster=" + BusterHelper.shared.getBusterFor(type: .LEADERBOARD)
        
        NetworkWrapper.shared.GET(type:.DETAIL_BASE_URL, url: molCardURL, onSuccess: { responseJSON in
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
        
        var molCardURL =  ""
       if GamingHubCards.isLoggedIn{
           molCardURL =  leaderboardTopRankingURL + "&buster=" + BusterHelper.shared.getBusterFor(type: .LEADERBOARD)
       }else{
           molCardURL =  (configData.endpoints?.guestUserLeaderBoardTopRankingUrlV2 ?? "") + "?buster=" + BusterHelper.shared.getBusterFor(type: .LEADERBOARD)
       }
        //molCardURL = molCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.competitionType, with: MOLTheme.currentGameID ?? "uclmoreorless")
        molCardURL = molCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.languageCode, with: "\(QuizzGameSDk.game.getAppLanguage())")
//        eotScoreURL = eotScoreURL.replacingOccurrences(of: NetworkConstants().urlKeys.tourId, with: Constants.appData.tourId.toString())
        
        NetworkWrapper.shared.GET(type:.DETAIL_BASE_URL, url: molCardURL, onSuccess: { responseJSON in
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
        
        var molCardURL = ""
        if GamingHubCards.isLoggedIn{
            
            molCardURL =  leaderboardUserRankingURL  + "&buster=" + BusterHelper.shared.getBusterFor(type: .LEADERBOARD)
        }else{
            molCardURL = (configData.endpoints?.guestUserOverViewLeaderBoardUrlV2 ?? "") + ("?buster=" + BusterHelper.shared.getBusterFor(type: .LEADERBOARD))
        }
        molCardURL = molCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.languageCode, with: "\(QuizzGameSDk.game.getAppLanguage())")
        //molCardURL = molCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.competitionType, with: MOLTheme.currentGameID ?? "uclmoreorless")
//        eotScoreURL = eotScoreURL.replacingOccurrences(of: NetworkConstants().urlKeys.tourId, with: Constants.appData.tourId.toString())
        
        NetworkWrapper.shared.GET(type:.DETAIL_BASE_URL, url: molCardURL, onSuccess: { responseJSON in
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
        var molCardURL = ""
        if GamingHubCards.isLoggedIn{
            molCardURL = leaderboardUserRankingURL + "&buster=" + BusterHelper.shared.getBusterFor(type: .LEADERBOARD)
        }else{
            molCardURL = (configData.endpoints?.guestUserLeaderBoardRankingUrlV2 ?? "") + ("?buster=" + BusterHelper.shared.getBusterFor(type: .LEADERBOARD))
        }
        //molCardURL = molCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.competitionType, with: MOLTheme.currentGameID ?? "uclmoreorless")
        molCardURL = molCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.quizId, with: quizId ?? "")
        molCardURL = molCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.offSet, with: "\(offset ?? 0)")
        molCardURL = molCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.totalCount, with: "\(count ?? 0)")
        molCardURL = molCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.quizType, with: "\(quizId ?? "")")
        molCardURL = molCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.languageCode, with: "\(QuizzGameSDk.game.getAppLanguage())")
        NetworkWrapper.shared.GET(type:.DETAIL_BASE_URL, url: molCardURL, onSuccess: { responseJSON in
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
       // leaderboardSelfUserRankingURL = leaderboardSelfUserRankingURL.replacingOccurrences(of: NetworkConstants().urlKeys.competitionType, with: MOLTheme.currentGameID ?? "uclmoreorless")
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
