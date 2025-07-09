//
//  NetworkConstants.swift
//  UEFAQuizSDK
//
//  Created by Vishal Vijayvargiya on 24/08/23.
//

import Foundation

import UIKit
import GamesLib

///  Base URLs Constants
///  Save all the PRODUCTION, SANDBOX , etc URLs here.
#warning("Remove this after adding xconfig for debug and release in build configs")
struct AppBaseURLs {
    
    
    static var environment: GamingHubEnvironment = GamingHubCards.environment.environment
    
    static var baseURL: String {
        
            switch environment {
            case .production:
                return Constants.configData?.baseDomain ?? "https://gaming.uefa.com"
            case .preproduction:
                return "https://gaming-pre.uefa.com"
            case .integration:
                return "https://gaming-int.uefa.com"
            case .qa:
                return "https://gaming-pre.uefa.com"
            }
        }

    
    static let productionURL = baseURL
    static let IntUrl = baseURL
    static  let dominURL = baseURL + "/"
    static let demo_url = baseURL
    static let imageURL =  baseURL + "/quiz/static-assets/cover-images/"
    static let shareDomin = baseURL

    /*
     struct AppBaseURLs {
         static let productionURL = Constants.configData?.baseDomain ?? "https://gaming-pre.uefa.com"//"https://gaming-int.uefa.com"//"https://origin-uefa-quiz-int.sportz.io/quiz"
         static let IntUrl = Constants.configData?.baseDomain ?? "https://gaming-pre.uefa.com"
         static let sandboxURL = "https://gaming-pre.uefa.com/en/uclfantasy/"
         static  let dominURL = "https://gaming-pre.uefa.com/"
         static let demo_url = "https://gamingdemo-quiz-admin.sportz.io"
         static let imageURL = "https://gaming-pre.uefa.com/quiz/static-assets/cover-images/"
         static let shareDomin = "https://gaming-pre.uefa.com"
     }
     */

}

///  Web service endpoints Constants
struct WSEndPoints {
    
    static var BaseURL:String{
        get{
            return AppBaseURLs.productionURL
            //set this when set with xcode config
            //Bundle.main.infoDictionary!["API_BASE_URL_ENDPOINT"] as! String
        }
    }
    
    struct APIs {
        static let config                   = "quiz/feeds/config/\(MOLTheme.currentGameID ?? "")-apps.json?buster=" + Date().timeIntervalSince1970.rounded().toString()
        static let service                  = "services/"
        static let feeds                    = "services/feeds/"
        static let login                    = "api/Session/login"
        static let rules                    = "rules"
    }
    
    struct WSKeys{
        static let data = "Data"
        static let meta = "Meta"
        static let success = "Success"
        static let retVal = "RetVal"
        static let value = "Value"
    }
}

struct NetworkConstants{
    var urlKeys = URLParamKeys()
    struct URLParamKeys{
        var language = "{{lang}}"
        var tourId = "{{tourId}}"
        var platformId = "{platformId}"
        var matchId = "{{matchdayId}}"
        var playerId = "{{playerId}}"
        var guid = "{guid}"
        var teamId = "{{TID}}"
        var team_Id = "{{TeamId}}"
        var position = "{POSITION}"
        var teamName_char_count = "{{NoChar}}"
        var skill_limit = "{{skill}}"
        var backdoor = "{backdoor}"
        var gameId = "{gameId}"
        var gameDayId = "{gameDayId}"
        var sportId = "{sportId}"
        var qzCatId = "{qzCatId}"
        var attemptNo = "{attemptNo}"
        var languageCode = "{languageCode}"
        var QzAtmpId = "{qzAtmpId}"
        var sltdAnsOptn = "{sltdAnsOptn}"
        var qstMId = "{qstMId}"
        var timeSpent = "{timeSpent}"
        var atmptStatus = "{atmptStatus}"
        var resumeAtmp = "{resumeAtmp}"
        var attemptId = "{attemptId}"
        var quizId = "{quizId}"
        var size = "{size}"
        var ratio = "{ratio}"
        var backgroundType = "{{backgroundType}}"
        var hintCnt = "{hintCnt}"
        var optType = "{optType}"
        var selectedAnswer = "{selectedAnswer}"
        var type = "{type}"
        var pageNo = "{page_no}"
        var offSet = "{offSet}"
        var totalCount = "{totalCount}"
        var quizType = "{quizType}"
        var guidn = "{guid}"
        var qstmid = "{qzQstMId}"
        var userPercentage = "{userPercentage}"
        var timestamp = "{timestamp}"
        var hours = "{hours}"
        var minute =  "{minute}"
        var points = "{{points}}"
        var rank = "{{rank}}"
        var totalplayer = "{totalplayer}"
        var count = "{count}"
        var isGuestUser = "{isGuestUser}"
        var competitionType = "{competitionType}"
        var isExit = "{isExit}"
        var date = "{date}"
        var gameTitle = "{GA_PageTitle}"
        var gameTypeTitle = "{GA_PageName}"
        var gamePageSubType = "{GA_PageSubType}"
        var isMediaQuiz = "{isMediaQuiz}"
        var difflevelid = "{difflevelid}"
       
    }
    
    enum PostErrorKeysType: String {
        case transfers, substitutions, saveCaptain
        case nameYourTeam, saveTeam
        case createLeague, joinLeague, reActivate, reJoin, deletePreviousLeague, deletePreviousMembersLeague, leaveLeague, suspension, unSuspension, deleteLeague, updateLeagueName, favClub
        case none
    }
}

