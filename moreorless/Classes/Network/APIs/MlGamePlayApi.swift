//
//  MlGamePlayApi.swift
//  quiz
//
//  Created by Vishal Vijayvargiya on 12/02/24.
//

import Foundation
import GamesLib

class MlGamePlayApi {
    static let shared = MlGamePlayApi()
   
    
    func MlFirstGameApiCall(quizid:String? = nil,onSuccess: @escaping((MLQuestionModel?) -> ()), onFailure: ((String) -> ())?=nil){
        guard let configData = Constants.configData else {
            onFailure?("Couldnt fetch config data")
            return
        }
        var quizCardURL = Constants.configData?.endpoints?.molStartGameCardUrl ?? "/quiz/services/mol/gameplay/v1/{competitionType}/attempt?quizId={quizId}&langCode={languageCode}&isGuestUser={isGuestUser}"
        quizCardURL = quizCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.isGuestUser, with: "\(!GamingHubCards.isLoggedIn)")
        quizCardURL = quizCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.quizId, with: quizid ?? "")
        quizCardURL = quizCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.languageCode, with: "\(QuizzGameSDk.game.getAppLanguage())")
       // quizCardURL = quizCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.competitionType, with: MOLTheme.currentGameID ?? "uclquiz")
       
        quizCardURL =  quizCardURL + "&buster=" + Date().timeIntervalSince1970.rounded().toString()
        NetworkWrapper.shared.GET(type:.DETAIL_BASE_URL, url: quizCardURL, onSuccess: { responseJSON in
            let data:GenericResponseModel<MLQuestionModel> = NetworkHelper.getDecodedData(from: responseJSON)
            if let value = data.Data.Value{
                onSuccess(value)
            }else{
                onSuccess(nil)
            }
        }, onFailure: { retVal in
            onFailure?(NetworkHelper.getErrorMessageFromTranslation(retVal: retVal, from: .none))
        }, headerType: .DEFAULT)
        
    }
    
    func MlNextGameApiCall(player1ID:Int?=nil, player2ID:Int?=nil, attemptid:Int?=nil, ans:Int?=nil, qid:String?=nil,onSuccess: @escaping(MLQuestionModel?) -> (), onFailure: ((String) -> ())?=nil){
       
        guard let configData = Constants.configData else {
            onFailure?("Couldnt fetch config data")
            return
        }
        
        var quizCardURL = configData.endpoints?.molQuestionGameCardUrl ?? "/quiz/services/mol/gameplay/v1/{competitionType}/questions?langCode={languageCode}&isGuestUser={isGuestUser}" 
        quizCardURL = quizCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.isGuestUser, with: "\(!GamingHubCards.isLoggedIn)")
        quizCardURL = quizCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.languageCode, with: "\(QuizzGameSDk.game.getAppLanguage())")
      //  quizCardURL = quizCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.competitionType, with: MOLTheme.currentGameID ?? "uclquiz")
        let request:MlQuestionAnsrequestModel?

            request = MlQuestionAnsrequestModel(quizID: qid ?? "", attemptid: attemptid ?? 0, player1ID: player1ID ?? 0, player2ID: player2ID ?? 0, answer: ans ?? -1, timetaken: 5, isskipped: 0, addedtime: 0)
   
        
        NetworkWrapper.shared.POST(type: .BASE_URL, url: quizCardURL, params: request, onSuccess: { responseJSON in
            
            let data: GenericResponseModel<MLQuestionModel> = NetworkHelper.getDecodedData(from: responseJSON)
            onSuccess(data.Data.Value)
        }, onFailure: { retVal in
            onFailure?(NetworkHelper.getErrorMessageFromTranslation(retVal: retVal, from: .none))
        }, headerType: .DEFAULT)
    }
    
    
    func MlResultApiCall(quizid:String? = nil,attemptid:Int?=nil,onSuccess: @escaping((MLResultScore?) -> ()), onFailure: ((String) -> ())?=nil){
        guard let configData = Constants.configData else {
            onFailure?("Couldnt fetch config data")
            return
        }
   
        var quizCardURL =  configData.endpoints?.molScoreCardUrl ??  "/quiz/services/mol/gameplay/v1/{competitionType}/scorecard?quizId={quizId}&langCode={languageCode}&isGuestUser={isGuestUser}&attemptId={attemptId}"
        quizCardURL = quizCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.isGuestUser, with: "\(!GamingHubCards.isLoggedIn)")
        quizCardURL = quizCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.attemptId, with: "\(attemptid ?? 0)")
        quizCardURL = quizCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.quizId, with: quizid ?? "")
        quizCardURL = quizCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.languageCode, with: "\(QuizzGameSDk.game.getAppLanguage())")
       // quizCardURL = quizCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.competitionType, with: MOLTheme.currentGameID ?? "uclquiz")
       
        quizCardURL =  quizCardURL + "&buster=" + Date().timeIntervalSince1970.rounded().toString()
        NetworkWrapper.shared.GET(type:.DETAIL_BASE_URL, url: quizCardURL, onSuccess: { responseJSON in
            let data:GenericResponseModel<MLResultScore> = NetworkHelper.getDecodedData(from: responseJSON)
            if let value = data.Data.Value{
                onSuccess(value)
            }else{
                onSuccess(nil)
            }
        }, onFailure: { retVal in
            onFailure?(NetworkHelper.getErrorMessageFromTranslation(retVal: retVal, from: .none))
        }, headerType: .DEFAULT)
        
    }
    
    func timerScoreCardApi(GamedayId:Int?,quizID:String,onSuccess: @escaping((timerData?) -> ()),onFailure: ((String) -> ())?=nil){
        guard let configData = Constants.configData, var timerScoreBoardURL = configData.endpoints?.userQuizDetails else {
            onFailure?("Couldnt fetch config data")
            return
        }
        
        timerScoreBoardURL = timerScoreBoardURL.replacingOccurrences(of: NetworkConstants().urlKeys.guid, with: "\(GamingHubCards.user.userId ?? 0)" )
        timerScoreBoardURL = timerScoreBoardURL.replacingOccurrences(of: NetworkConstants().urlKeys.quizId, with: quizID)
        timerScoreBoardURL = timerScoreBoardURL.replacingOccurrences(of: NetworkConstants().urlKeys.platformId, with: "\(Constants.appData.platformID)")
        timerScoreBoardURL = timerScoreBoardURL.replacingOccurrences(of: NetworkConstants().urlKeys.languageCode, with: QuizzGameSDk.game.getAppLanguage())
        timerScoreBoardURL = timerScoreBoardURL.replacingOccurrences(of: NetworkConstants().urlKeys.isGuestUser, with: "\(!GamingHubCards.isLoggedIn)")
        timerScoreBoardURL = timerScoreBoardURL + "&buster=" + BusterHelper.shared.getBusterFor(type: .LEADERBOARD)
        
        NetworkWrapper.shared.GET(type: .BASE_URL, url: timerScoreBoardURL,onSuccess: { responseJSON in
            let data: GenericResponseModel<timerData> = NetworkHelper.getDecodedData(from: responseJSON)
            if let value = data.Data.Value{
                onSuccess(value)
            }else{
                onSuccess(nil)
            }
        }, onFailure: { retVal in
            onFailure?(NetworkHelper.getErrorMessageFromTranslation(retVal: retVal, from: .none))
        }, headerType: .DEFAULT)
    }
}

