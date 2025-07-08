//
//  QuizzQuetionAnsApi.swift
//  Pods
//
//  Created by Vishal Vijayvargiya on 07/09/23.
//

import Foundation
import SwiftyJSON
import GamesLib
class QuizzQuetionAnsApi {
    static let shared = QuizzQuetionAnsApi()
    var arrintid:[Int] = []
    func getGameConfigData(quizID:String,onSuccess: @escaping((GameAttemptConfigData?) -> ()), onFailure: ((String) -> ())?=nil){
        guard let configData = Constants.configData else {
            onFailure?("Couldnt fetch config data getGameConfigData")
            return
        }
       
        var gameconfigURL = configData.endpoints?.gameDetailsURL ?? ""
        gameconfigURL = gameconfigURL.replacingOccurrences(of: NetworkConstants().urlKeys.quizId, with: quizID)
        
        NetworkWrapper.shared.GET(type:.DETAIL_BASE_URL,url: gameconfigURL, onSuccess: { responseJSON in
            let data: DataConfigClass<GameAttemptConfigData> = NetworkHelper.getDecodedData(from: responseJSON)
            onSuccess(data.data)
        }, onFailure: { retVal in
            onFailure?(NetworkHelper.getErrorMessageFromTranslation(retVal: retVal, from: .none))
        }, headerType: .NONE)
    }
    
   //MARK: quiz Detail Api call
    func getQuetionDetailApi(quizID:String,onSuccess: @escaping((QuizUserDetailModel?) -> ()), onFailure: ((String) -> ())?=nil){
        arrintid = []
        guard let configData = Constants.configData, var userDetailsURL = configData.endpoints?.userDetailsURL else {
            onFailure?("Couldnt fetch config data")
            return
        }
      
        userDetailsURL = userDetailsURL.replacingOccurrences(of: NetworkConstants().urlKeys.guid, with: "\(GamingHubCards.user.userId ?? 0)")
        userDetailsURL = userDetailsURL.replacingOccurrences(of: NetworkConstants().urlKeys.gameId, with: quizID)
       
        let request:QuizRequestModel?
        if !GamingHubCards.isLoggedIn{
             request = QuizRequestModel(isGuestUser: true, questionsPlayed: [] )
        }else
        {
            request = QuizRequestModel(isGuestUser: false, questionsPlayed: [])
        }
        
        NetworkWrapper.shared.POST(type: .BASE_URL, url: userDetailsURL, params: request, onSuccess: { responseJSON in
            
            let data: GenericResponseModel<QuizUserDetailModel> = NetworkHelper.getDecodedData(from: responseJSON)
            onSuccess(data.Data.Value)
        }, onFailure: { retVal in
            onFailure?(NetworkHelper.getErrorMessageFromTranslation(retVal: retVal, from: .none))
        }, headerType: .DEFAULT)
    }
    
    //MARK: quiz First Question Api call
    
    func getQuetionStartApi(GamedayId:Int?,quizID:String,attemptNo:String,gamdayid:Int,CategoryID:Int,SportID:Int,isMediaQuiz:Bool?,difficultyLevel: Int?,onSuccess: @escaping((QuizQuestionModel?) -> ()), onFailure: ((String) -> ())?=nil){
        guard let configData = Constants.configData, var quizStartGameURL = configData.endpoints?.quizStartGameURL else {
            onFailure?("Couldnt fetch config data")
            return
        }
     
        quizStartGameURL = quizStartGameURL.replacingOccurrences(of: NetworkConstants().urlKeys.guid, with: "\(GamingHubCards.user.userId ?? 0)")
        quizStartGameURL = quizStartGameURL.replacingOccurrences(of: NetworkConstants().urlKeys.gameId, with: quizID) // quiz id
        quizStartGameURL = quizStartGameURL.replacingOccurrences(of: NetworkConstants().urlKeys.gameDayId, with: "\(GamedayId ?? 0)")
        quizStartGameURL = quizStartGameURL.replacingOccurrences(of: NetworkConstants().urlKeys.quizId, with: quizID)
        quizStartGameURL = quizStartGameURL.replacingOccurrences(of: NetworkConstants().urlKeys.qzCatId, with: "\(CategoryID)")
        quizStartGameURL = quizStartGameURL.replacingOccurrences(of: NetworkConstants().urlKeys.attemptNo, with: attemptNo)
        quizStartGameURL = quizStartGameURL.replacingOccurrences(of: NetworkConstants().urlKeys.languageCode, with: QuizzGameSDk.game.getAppLanguage())
        quizStartGameURL = quizStartGameURL.replacingOccurrences(of: NetworkConstants().urlKeys.platformId, with: "\(Constants.appData.platformID)")
        quizStartGameURL = quizStartGameURL.replacingOccurrences(of: NetworkConstants().urlKeys.isMediaQuiz, with: "\(isMediaQuiz ?? false)")
        
        quizStartGameURL = quizStartGameURL.replacingOccurrences(of: NetworkConstants().urlKeys.difflevelid, with: "\(difficultyLevel ?? 0)")
        
//        quizStartGameURL = quizStartGameURL.replacingOccurrences(of: NetworkConstants().urlKeys.difficultyLevel, with: "\(difficultyLevel ?? 0)" == "0" ? "" : "\(difficultyLevel ?? 0)")

        quizStartGameURL = quizStartGameURL + "&buster=" + Date().timeIntervalSince1970.rounded().toString()
        let request:QuizRequestModel?
        if !GamingHubCards.isLoggedIn{
             request = QuizRequestModel(isGuestUser: true, questionsPlayed: [] )
        }else
        {
            request = QuizRequestModel(isGuestUser: false, questionsPlayed: [] )
        }
        
        
        NetworkWrapper.shared.POST(type: .BASE_URL, url: quizStartGameURL, params: request, onSuccess: { responseJSON in
            
            let data: GenericResponseModel<QuizQuestionModel> = NetworkHelper.getDecodedData(from: responseJSON)
            onSuccess(data.Data.Value)
        }, onFailure: { retVal in
            onFailure?(NetworkHelper.getErrorMessageFromTranslation(retVal: retVal, from: .none))
        }, headerType: .DEFAULT)
    }
    
    //MARK: quiz Next Question Api cal
    func getNextQuestionStartApi(GamedayId:Int?,quizID:String,QstMId:Int?,SltdAnsOpt:String,QuAttemptId:Int?,AtmptStatus:Int,isMediaQuiz:Bool?,onSuccess: @escaping((QuizQuestionModel?) -> ()), onFailure: ((String) -> ())?=nil){
        guard let configData = Constants.configData, var quizStartGameURL = configData.endpoints?.quizGameQuestionURL else {
            onFailure?("Couldnt fetch config data")
            return
        }
        arrintid.append(QstMId ?? 0)
       
        quizStartGameURL = quizStartGameURL.replacingOccurrences(of: NetworkConstants().urlKeys.guid, with: "\(GamingHubCards.user.userId ?? 0)")
        quizStartGameURL = quizStartGameURL.replacingOccurrences(of: NetworkConstants().urlKeys.gameId, with: quizID)
        quizStartGameURL = quizStartGameURL.replacingOccurrences(of: NetworkConstants().urlKeys.gameDayId, with: "\(GamedayId ?? 0)")
        quizStartGameURL = quizStartGameURL.replacingOccurrences(of: NetworkConstants().urlKeys.quizId, with: quizID)
        quizStartGameURL = quizStartGameURL.replacingOccurrences(of: NetworkConstants().urlKeys.sportId, with: "1")
        quizStartGameURL = quizStartGameURL.replacingOccurrences(of: NetworkConstants().urlKeys.QzAtmpId, with: "\(QuAttemptId ?? 0)")
        quizStartGameURL = quizStartGameURL.replacingOccurrences(of: NetworkConstants().urlKeys.sltdAnsOptn, with: SltdAnsOpt)
        quizStartGameURL = quizStartGameURL.replacingOccurrences(of: NetworkConstants().urlKeys.qstMId, with: "\(QstMId ?? 0)")
        quizStartGameURL = quizStartGameURL.replacingOccurrences(of: NetworkConstants().urlKeys.timeSpent, with: "1")
        quizStartGameURL = quizStartGameURL.replacingOccurrences(of: NetworkConstants().urlKeys.atmptStatus, with: "\(AtmptStatus)")
        quizStartGameURL = quizStartGameURL.replacingOccurrences(of: NetworkConstants().urlKeys.resumeAtmp, with: "0")
        quizStartGameURL = quizStartGameURL.replacingOccurrences(of: NetworkConstants().urlKeys.hintCnt, with: "0")
        quizStartGameURL = quizStartGameURL.replacingOccurrences(of: NetworkConstants().urlKeys.languageCode, with: QuizzGameSDk.game.getAppLanguage())
        quizStartGameURL = quizStartGameURL.replacingOccurrences(of: NetworkConstants().urlKeys.platformId, with: "\(Constants.appData.platformID)")
        quizStartGameURL = quizStartGameURL.replacingOccurrences(of: NetworkConstants().urlKeys.isMediaQuiz, with: "\(isMediaQuiz ?? false)")
        quizStartGameURL = quizStartGameURL + "&buster=" + Date().timeIntervalSince1970.rounded().toString()
       
        var request:QuizRequestModel?
        if !GamingHubCards.isLoggedIn{
            request = QuizRequestModel(isGuestUser: true, questionsPlayed: arrintid )
        }else
        {
            request = QuizRequestModel(isGuestUser: false, questionsPlayed: [] )
        }
        
        
        NetworkWrapper.shared.POST(type: .BASE_URL, url: quizStartGameURL, params: request, onSuccess: { responseJSON in
            
            let data: GenericResponseModel<QuizQuestionModel> = NetworkHelper.getDecodedData(from: responseJSON)
            onSuccess(data.Data.Value)
        }, onFailure: { retVal in
            onFailure?(NetworkHelper.getErrorMessageFromTranslation(retVal: retVal, from: .none))
        }, headerType: .DEFAULT)
    }
    
    func FiftyFiftyData(GamedayId:Int?,quizID:String,QstMId:Int?,QuAttemptId:Int?,isMediaQuiz:Bool?,onSuccess: @escaping((Bool,FiftyFiftyValue?) -> ()), onFailure: ((String) -> ())?=nil){
        guard let configData = Constants.configData, var quizApplyFiftyFiftyBoosterURL = configData.endpoints?.quizApplyFiftyFiftyBoosterURL else {
            onFailure?("Couldnt fetch config data")
            return
        }
      
        quizApplyFiftyFiftyBoosterURL = quizApplyFiftyFiftyBoosterURL.replacingOccurrences(of: NetworkConstants().urlKeys.guid, with: "\(GamingHubCards.user.userId ?? 0)")
        quizApplyFiftyFiftyBoosterURL = quizApplyFiftyFiftyBoosterURL.replacingOccurrences(of: NetworkConstants().urlKeys.gameId, with: quizID)
        quizApplyFiftyFiftyBoosterURL = quizApplyFiftyFiftyBoosterURL.replacingOccurrences(of: NetworkConstants().urlKeys.gameDayId, with: "\(GamedayId ?? 1)")
        quizApplyFiftyFiftyBoosterURL = quizApplyFiftyFiftyBoosterURL.replacingOccurrences(of: NetworkConstants().urlKeys.attemptId, with: "\(QuAttemptId ?? 0)")
        quizApplyFiftyFiftyBoosterURL = quizApplyFiftyFiftyBoosterURL.replacingOccurrences(of: NetworkConstants().urlKeys.qstMId, with: "\(QstMId ?? 0)")
        quizApplyFiftyFiftyBoosterURL = quizApplyFiftyFiftyBoosterURL.replacingOccurrences(of: NetworkConstants().urlKeys.qstmid, with: "\(QstMId ?? 0)")
        quizApplyFiftyFiftyBoosterURL = quizApplyFiftyFiftyBoosterURL.replacingOccurrences(of: NetworkConstants().urlKeys.platformId, with: "\(Constants.appData.platformID)")
        quizApplyFiftyFiftyBoosterURL = quizApplyFiftyFiftyBoosterURL.replacingOccurrences(of: NetworkConstants().urlKeys.languageCode, with: QuizzGameSDk.game.getAppLanguage())
        quizApplyFiftyFiftyBoosterURL = quizApplyFiftyFiftyBoosterURL.replacingOccurrences(of: NetworkConstants().urlKeys.isMediaQuiz, with: "\(isMediaQuiz)")
        var questionid:[Int] = []
        questionid.append(QstMId ?? 0)
        let request:QuizRequestModel?
        if !GamingHubCards.isLoggedIn{
             request = QuizRequestModel(isGuestUser: true, questionsPlayed: questionid )
        }else
        {
            request = QuizRequestModel(isGuestUser: false, questionsPlayed: [] )
        }
        NetworkWrapper.shared.POST(type: .BASE_URL, url: quizApplyFiftyFiftyBoosterURL, params: request, onSuccess: { responseJSON in
            
            let data: GenericResponseModel<FiftyFiftyValue> = NetworkHelper.getDecodedData(from: responseJSON)
            onSuccess(true, data.Data.Value)
        }, onFailure: { retVal in
            onFailure?(NetworkHelper.getErrorMessageFromTranslation(retVal: retVal, from: .none))
        }, headerType: .DEFAULT)
    }
    
    func VarSneakPeakData(GamedayId:Int?,selectedAns:String,quizID:String,QstMId:Int?,QuAttemptId:Int?,OptType:Int,isMediaQuiz:Bool?,onSuccess: @escaping((Bool,VarSneakPeakValue?) -> ()), onFailure: ((String) -> ())?=nil){
        guard let configData = Constants.configData, var quizApplyVarBoosterURL = configData.endpoints?.quizApplyVarBoosterURL else {
            onFailure?("Couldnt fetch config data")
            return
        }
        
        quizApplyVarBoosterURL = quizApplyVarBoosterURL.replacingOccurrences(of: NetworkConstants().urlKeys.guid, with: "\(GamingHubCards.user.userId ?? 0)")
        quizApplyVarBoosterURL = quizApplyVarBoosterURL.replacingOccurrences(of: NetworkConstants().urlKeys.gameId, with: quizID)
        quizApplyVarBoosterURL = quizApplyVarBoosterURL.replacingOccurrences(of: NetworkConstants().urlKeys.gameDayId, with: "\(GamedayId ?? 1)")
        quizApplyVarBoosterURL = quizApplyVarBoosterURL.replacingOccurrences(of: NetworkConstants().urlKeys.selectedAnswer, with: selectedAns)
        quizApplyVarBoosterURL = quizApplyVarBoosterURL.replacingOccurrences(of: NetworkConstants().urlKeys.attemptId, with: "\(QuAttemptId ?? 0)")
        quizApplyVarBoosterURL = quizApplyVarBoosterURL.replacingOccurrences(of: NetworkConstants().urlKeys.qstMId, with: "\(QstMId ?? 0)")
        quizApplyVarBoosterURL = quizApplyVarBoosterURL.replacingOccurrences(of: NetworkConstants().urlKeys.qstmid, with: "\(QstMId ?? 0)")
        quizApplyVarBoosterURL = quizApplyVarBoosterURL.replacingOccurrences(of: NetworkConstants().urlKeys.platformId, with: "\(Constants.appData.platformID)")
        quizApplyVarBoosterURL = quizApplyVarBoosterURL.replacingOccurrences(of: NetworkConstants().urlKeys.optType, with: "\(OptType)")
        quizApplyVarBoosterURL = quizApplyVarBoosterURL.replacingOccurrences(of: NetworkConstants().urlKeys.languageCode, with: QuizzGameSDk.game.getAppLanguage())
        quizApplyVarBoosterURL = quizApplyVarBoosterURL.replacingOccurrences(of: NetworkConstants().urlKeys.isMediaQuiz, with: "\(isMediaQuiz ?? false)")
        
        var questionid:[Int] = []
        questionid.append(QstMId ?? 0)
        let request:QuizRequestModel?
        if !GamingHubCards.isLoggedIn{
             request = QuizRequestModel(isGuestUser: true, questionsPlayed: questionid )
        }else
        {
            request = QuizRequestModel(isGuestUser: false, questionsPlayed: [] )
        }
        NetworkWrapper.shared.POST(type: .BASE_URL, url: quizApplyVarBoosterURL, params: request, onSuccess: { responseJSON in
            
            let data: GenericResponseModel<VarSneakPeakValue> = NetworkHelper.getDecodedData(from: responseJSON)
            onSuccess(true, data.Data.Value)
        }, onFailure: { retVal in
            onFailure?(NetworkHelper.getErrorMessageFromTranslation(retVal: retVal, from: .none))
        }, headerType: .DEFAULT)
    }
    
    
    
    func QuizScoreData(GamedayId:Int?,quizID:String,attemptNo:Int,onSuccess: @escaping((scoreCardData?) -> ()), onFailure: ((String) -> ())?=nil){
        
       
        guard let configData = Constants.configData, var quizScoredCardURL = configData.endpoints?.quizScoredCardURL else {
            onFailure?("Couldnt fetch config data")
            return
        }
        
        let request:QuizRequestModel?
        if !GamingHubCards.isLoggedIn{
             request = QuizRequestModel(isGuestUser: true, questionsPlayed: [] )
        }else
        {
            request = QuizRequestModel(isGuestUser: false, questionsPlayed: [] )
        }
        
        
        quizScoredCardURL = quizScoredCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.guid, with: "\(GamingHubCards.user.userId ?? 0)")
        quizScoredCardURL = quizScoredCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.gameId, with: quizID)
        quizScoredCardURL = quizScoredCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.gameDayId, with: "\(GamedayId ?? 1)")
        quizScoredCardURL = quizScoredCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.attemptId, with: "\(attemptNo)")
        quizScoredCardURL = quizScoredCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.quizId, with: quizID)
        quizScoredCardURL = quizScoredCardURL.replacingOccurrences(of: NetworkConstants().urlKeys.attemptId, with: "\(attemptNo)")
        NetworkWrapper.shared.POST(type: .BASE_URL, url: quizScoredCardURL, params: request, onSuccess: { responseJSON in
            
            let data: GenericResponseModel<scoreCardData> = NetworkHelper.getDecodedData(from: responseJSON)
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
        
        let request:QuizRequestModel?
        
        if !GamingHubCards.isLoggedIn{
             request = QuizRequestModel(isGuestUser: true, questionsPlayed: [] )
        }else
        {
            request = QuizRequestModel(isGuestUser: false, questionsPlayed: [] )
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
