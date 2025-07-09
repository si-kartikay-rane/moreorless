//
//  TrackHelper.swift
//  UEFAQuizSDK
//
//  Created by Vishal Vijayvargiya on 24/08/23.
//

import Foundation
import GamesLib

class Track {
    static let shared = Track()
    static let AnalyticsBooster50 = "50-50"
    static let AnalyticsBooster2shots = "2 shots"
    //ADDED
    func event(G4A : QuizzerAnalyticsEvent, name: String?, params: [String:Any]?, replaceString: String? = nil,quizId:String? = nil, quizTitle: String? = nil, gaPageTitle:String? = nil, gaPageSubType: String? = nil){

        var eventParams: [String:Any] = ["section_reference" : G4A.eventLabel.rawValue,
                                         String(describing: MOLTheme.currentGameID ?? "uclquiz") + "_interaction" : G4A.eventAction ,
                                         "ua_event_category" : "Click",
                                         "ua_event_label" : G4A.eventLabel.rawValue ,   
                                         "ua_event_action": G4A.eventAction ,
                                         "ua_event_name" : "gaEvent"]
                                         //"screen_name": screenname] //"\(GAMEID)_interaction" : name ?? "-", //"uclquiz",
               
        if let name = QuizzGameSDk.game.sponsorModel?.code {
            eventParams["partners"] = name
        }
        
        if let params = params, !params.isEmpty {
            eventParams = eventParams.merging(params, uniquingKeysWith: { current, _ in
                current})
        }
        
        //ADDED
        if let screenParams = getScreenParamsForEvent(screen: name ?? "", params: eventParams, replace: replaceString,quizId: quizId, quizTitle: quizTitle, gaPageTitle: gaPageTitle, gaPageSubType: gaPageSubType){
            eventParams = eventParams.merging(screenParams, uniquingKeysWith: { current, _ in
                current})
        }
        Constants.print("================Event Params==================")
        Constants.print(eventParams, "<<<<<<<ANALYTICS")
        Constants.print(String(describing: G4A.event ), "<<<<<<<ANALYTICS")
        Constants.print("==============================================")
        GamingHubCards.trackEvent(G4A.event , parameters: eventParams)
        
    }
    
    func event(screen: String){
        if let config = Constants.configData, let partners = config.pageTrackConstants{
            var eventParams = partners[screen] ?? [:]
            let screenName = eventParams["page_name"] ?? "-"
            GamingHubCards.trackEvent(screenName, parameters: eventParams)
            Constants.print(eventParams)
        }
    }

    func screen(screen: String, params: [String: String]?, replace: String? = nil,replace2:String? = nil,quizId:String? = nil, quizTitle:String? = nil, gaPageTitle:String? = nil,gaPageSubType: String? = nil){
        if let config = Constants.configData, let partners = config.pageTrackConstants{
            let lang = QuizzGameSDk.game.getAppLanguage().uppercased()

            //get config track constants
            if replace != nil || replace2 != nil || quizId != nil{
                var eventParams = partners[screen] ?? [:]
                var screenName = eventParams["page_name"] ?? "-"
                var pageTitle = eventParams["page_title"] ?? "-"
                var pageSubType = eventParams["page_sub_type"] ?? "-"
                screenName = screenName.replacingOccurrences(of: NetworkConstants().urlKeys.type, with:  replace2 ?? "-")
                screenName = screenName.replacingOccurrences(of: NetworkConstants().urlKeys.quizId, with: quizId ?? "-")
                screenName = screenName.replacingOccurrences(of: NetworkConstants().urlKeys.pageNo, with: replace ?? "-")
                screenName = screenName.replacingOccurrences(of: NetworkConstants().urlKeys.gameTypeTitle, with: quizTitle ?? "-")
                
                
                pageTitle = pageTitle.replacingOccurrences(of: NetworkConstants().urlKeys.gameTitle, with: gaPageTitle ?? "")
                pageSubType = pageSubType.replacingOccurrences(of: NetworkConstants().urlKeys.gamePageSubType, with: gaPageSubType ?? "-")
                eventParams["page_language"] = lang
                eventParams["page_name"] = screenName
                eventParams["page_title"] = pageTitle
                eventParams["page_sub_type"] = pageSubType
                eventParams["screen_name"] = screenName
                
                if let name = QuizzGameSDk.game.sponsorModel?.code {
                    eventParams["partners"] = name
                }
                GamingHubCards.trackScreen(screenName, parameters: eventParams, domain: screen, gameId: MOLTheme.currentGameID ?? "uclquiz")
            }else{
                var eventParams = partners[screen] ?? [:]
                eventParams["page_language"] = lang
                let screenName = eventParams["page_name"] ?? "-"
                if let name = QuizzGameSDk.game.sponsorModel?.code {
                    eventParams["sponsor"] = name
                }
                eventParams["screen_name"] = screenName
                GamingHubCards.trackScreen(screenName, parameters: eventParams, domain: screen, gameId: MOLTheme.currentGameID ?? "uclquiz")
            }
        }
        
        
    }
}

//MARK: Sponsor tracking
extension Track{
    func trackSponsor(slot: String,analyticsDomainName: String, analyticsData: TrackingParameters){
        if let sponsor = QuizzGameSDk.game.sponsorModel{
            GamingHubCards.trackSponsor(name: sponsor.code ?? .empty, creativeName: "exclusive-section" , slot: slot, domain: analyticsDomainName, gameId: MOLTheme.currentGameID ?? "uclquiz")

        }
    }
    func trackSponsorClick(analyticsDomainName: String, analyticsData: TrackingParameters){
        if let sponsor = QuizzGameSDk.game.sponsorModel{
            GamingHubCards.trackSponsor(name: sponsor.code ?? .empty, creativeName: "exclusive-section" , domain: analyticsDomainName, gameId: MOLTheme.currentGameID ?? "uclquiz")
        }
    }
    
}



extension Track{
    //ADDED
    private func getScreenParamsForEvent(screen: String, params: [String: Any]?, replace: String?,quizId:String? = nil, quizTitle: String? = nil, gaPageTitle:String? = nil, gaPageSubType: String? = nil) -> [String: Any]?{

        
        if let config = Constants.configData, let partners = config.pageTrackConstants{
            let lang = QuizzGameSDk.game.getAppLanguage().uppercased()

            //get config track constants
            if replace != nil{
                var eventParams = partners[screen] ?? [:]
                var screenName = eventParams["page_name"] ?? "-"
                var pageTitle = eventParams["page_title"] ?? "-"
                var pageSubType = eventParams["page_sub_type"] ?? "-"
                screenName = screenName.replacingOccurrences(of: NetworkConstants().urlKeys.type, with: replace ?? "-")
                screenName = screenName.replacingOccurrences(of: NetworkConstants().urlKeys.pageNo, with: replace ?? "-")
                screenName = screenName.replacingOccurrences(of: NetworkConstants().urlKeys.quizId, with: quizId ?? "-")
                //ADDED
                screenName = screenName.replacingOccurrences(of: NetworkConstants().urlKeys.gameTypeTitle, with: quizTitle ?? "-")
                
                pageTitle = pageTitle.replacingOccurrences(of: NetworkConstants().urlKeys.gameTitle, with: gaPageTitle ?? "-")
                pageSubType = pageSubType.replacingOccurrences(of: NetworkConstants().urlKeys.gamePageSubType, with: gaPageSubType ?? "-")
                eventParams["page_language"] = lang
                eventParams["page_name"] = screenName
                eventParams["page_title"] = pageTitle
                eventParams["page_sub_type"] = pageSubType
                eventParams["screen_name"] = screenName

                return eventParams

            }else{
                var eventParams = partners[screen] ?? [:]
                eventParams["page_language"] = lang
                let screenName = eventParams["page_name"] ?? "-"
                eventParams["screen_name"] = screenName
                return eventParams
                
            }
        }
        return nil
    }
    
    
    
    func get_screen_domain_params(screen: String, params: [String: String]?, replace: String? = nil,replace2:String? = nil,quizId:String? = nil, quizTitle:String? = nil, gaPageTitle:String? = nil,gaPageSubType: String? = nil) -> (analyticsDomainName: String, analyticsData: TrackingParameters) {
        if let config = Constants.configData, let partners = config.pageTrackConstants{
            let lang = QuizzGameSDk.game.getAppLanguage().uppercased()
            
            //get config track constants
            if replace != nil || replace2 != nil || quizId != nil{
                var eventParams = partners[screen] ?? [:]
                var screenName = eventParams["page_name"] ?? "-"
                var pageTitle = eventParams["page_title"] ?? "-"
                var pageSubType = eventParams["page_sub_type"] ?? "-"
                screenName = screenName.replacingOccurrences(of: NetworkConstants().urlKeys.type, with:  replace2 ?? "-")
                screenName = screenName.replacingOccurrences(of: NetworkConstants().urlKeys.quizId, with: quizId ?? "-")
                screenName = screenName.replacingOccurrences(of: NetworkConstants().urlKeys.pageNo, with: replace ?? "-")
                screenName = screenName.replacingOccurrences(of: NetworkConstants().urlKeys.gameTypeTitle, with: quizTitle ?? "-")
                
                
                pageTitle = pageTitle.replacingOccurrences(of: NetworkConstants().urlKeys.gameTitle, with: gaPageTitle ?? "")
                pageSubType = pageSubType.replacingOccurrences(of: NetworkConstants().urlKeys.gamePageSubType, with: gaPageSubType ?? "-")
                eventParams["page_language"] = lang
                eventParams["page_name"] = screenName
                eventParams["page_title"] = pageTitle
                eventParams["page_sub_type"] = pageSubType
                eventParams["screen_name"] = screenName
                
                if let name = QuizzGameSDk.game.sponsorModel?.code {
                    eventParams["partners"] = name
                }
                let analyticsDomainName = screen
                let analyticsData = TrackingParameters(eventParams as [String: Any?]?)
                
                return (analyticsDomainName, analyticsData)
                
            }else{
                var eventParams = partners[screen] ?? [:]
                eventParams["page_language"] = lang
                let screenName = eventParams["page_name"] ?? "-"
                //                eventParams["lang"] = lang
                if let name = QuizzGameSDk.game.sponsorModel?.code {
                    //eventParams["partners"] = name
                    eventParams["sponsor"] = name
                }
                eventParams["screen_name"] = screenName
                let analyticsDomainName = screen
                let analyticsData = TrackingParameters(eventParams as [String: Any?]?)
                
                return (analyticsDomainName, analyticsData)
                
            }
        }
        return ("", TrackingParameters(nil))
    }
}


struct QuizCardItemTypeEnum {
    let type: String
    let gameType : String
    let trackingQuizType: String
    var trackingKeyQuizType: String
    
    init(type: String, gameType: String, trackingQuizType: String, trackingKeyQuizType: String) {
        self.type = type
        self.gameType = gameType
        self.trackingQuizType = trackingQuizType
        self.trackingKeyQuizType = trackingKeyQuizType
    }
}


enum QuizzerAnalyticsEventLabel: String {
    case quizArena = "quizarena"
    case quiz = "quiz"
}

protocol QuizzerAnalyticsEvent {
    var event: String { get }
    var eventAction: String { get }
    var eventLabel: QuizzerAnalyticsEventLabel { get }
}

extension QuizzerAnalyticsEvent {
    func QuizzerAnalyticsformattedEventAction(with quizType: QuizCardItemTypeEnum, QuizzerAnalyticsisLoggedIn: Bool? = nil) -> String {
        switch self {
        case is QuizzerAnalyticsViewAllLeaderboard:
            return "View all leaderboard"
        case is QuizzerAnalyticsTapToSkip:
            return "Skip countdown"
        case is QuizzerAnalyticsCloseQuiz:
            return "Close quiz"
        case let booster as QuizzerAnalyticsBooster:
            return "Booster - \(booster.boosterType)"
        case let event:
            var action = event.eventAction.replacingOccurrences(of: "{quizType}", with: quizType.type)
            if let isLoggedIn = QuizzerAnalyticsisLoggedIn {
                let loginState = isLoggedIn ? "Logged in" : "Logged out"
                action = action.replacingOccurrences(of: "{loginState}", with: loginState)
            }
            return action
        }
    }
}

struct QuizzerAnalyticsLoginToPlay: QuizzerAnalyticsEvent {
    let quizType: QuizCardItemTypeEnum
    let event = "quiz_arena_log_in_play"
    var eventAction = "Log in or register - {quizType}"
    let eventLabel = QuizzerAnalyticsEventLabel.quizArena
    
    init(quizType: QuizCardItemTypeEnum) {
        self.quizType = quizType
        self.eventAction = eventAction.replacingOccurrences(of: "{quizType}", with: quizType.type)
    }
}

struct QuizzerAnalyticsTryAsGuest: QuizzerAnalyticsEvent {
    let quizType: QuizCardItemTypeEnum
    let event = "quiz_arena_try_guest"
    var eventAction = "Try as a guest - {quizType}"
    let eventLabel = QuizzerAnalyticsEventLabel.quizArena
    
    init(quizType: QuizCardItemTypeEnum) {
        self.quizType = quizType
        self.eventAction = eventAction.replacingOccurrences(of: "{quizType}", with: quizType.type)
    }
}

struct QuizzerAnalyticsGenerateQuiz: QuizzerAnalyticsEvent {
    let quizType: QuizCardItemTypeEnum
    let event: String
    let eventAction: String
    let eventLabel = QuizzerAnalyticsEventLabel.quizArena

    init(quizType: QuizCardItemTypeEnum) {
        self.quizType = quizType
        self.event = "quiz_arena_start_\(quizType.type)"
        self.eventAction = "Start quiz - \(quizType.gameType)"
    }
}
struct QuizzerAnalyticsGenerateDifficultyQuiz: QuizzerAnalyticsEvent {
    let quizType: QuizCardItemTypeEnum
    let event: String
    let difficulty: String
    let action : String
    let eventAction: String
    let eventLabel = QuizzerAnalyticsEventLabel.quiz

    init(quizType: QuizCardItemTypeEnum, difficulty: String, action: String) {
        self.quizType = quizType
        self.event = "quiz_arena_choose_difficulty"
        self.difficulty = difficulty
        self.action = action
        self.eventAction = "\(action) - \(difficulty)"
    }
}

struct QuizzerAnalyticsViewAllLeaderboard: QuizzerAnalyticsEvent {
    let event = ""
    let eventAction = "View all leaderboard"
    let eventLabel = QuizzerAnalyticsEventLabel.quizArena
}

struct QuizzerAnalyticsTapToSkip: QuizzerAnalyticsEvent {
    let event = "quiz_arena_skip_countdown"
    let eventAction = "Skip countdown"
    let eventLabel = QuizzerAnalyticsEventLabel.quiz
}

struct QuizzerAnalyticsCloseQuiz: QuizzerAnalyticsEvent {
    let event = ""
    let eventAction = "Close quiz"
    let eventLabel = QuizzerAnalyticsEventLabel.quiz
}

struct QuizzerAnalyticsBooster: QuizzerAnalyticsEvent {
    let boosterType: String
    let event = "quiz_arena_booster"
    var eventAction: String { "Booster - \(boosterType)" }
    let eventLabel = QuizzerAnalyticsEventLabel.quiz
}

struct QuizzerAnalyticsShareResults: QuizzerAnalyticsEvent {
    let quizType: QuizCardItemTypeEnum
    let event = "share"
    let eventAction: String
    let eventLabel = QuizzerAnalyticsEventLabel.quiz

    init(quizType: QuizCardItemTypeEnum) {
        self.quizType = quizType
        print(quizType)
        self.eventAction = "Share score - \(quizType.gameType)"
    }
}

struct QuizzerAnalyticsViewRanking: QuizzerAnalyticsEvent {
    let quizType: QuizCardItemTypeEnum
    let isLoggedIn: Bool
    let event = "quiz_arena_score_view_ranking"
    let eventAction: String
    let eventLabel = QuizzerAnalyticsEventLabel.quiz

    init(quizType: QuizCardItemTypeEnum, isLoggedIn: Bool) {
        self.quizType = quizType
        self.isLoggedIn = isLoggedIn
        let loginState = isLoggedIn ? "Logged in" : "Logged out"
        self.eventAction = "Score - View ranking - \(quizType.gameType) - \(loginState)"
        
    }
}

struct QuizzerAnalyticsGoToQuizArena: QuizzerAnalyticsEvent {
    let quizType: QuizCardItemTypeEnum
    let isLoggedIn: Bool
    let event = "quiz_arena_score_go_to_quiz"
    let eventAction: String
    let eventLabel = QuizzerAnalyticsEventLabel.quiz

    init(quizType: QuizCardItemTypeEnum, isLoggedIn: Bool) {
        self.quizType = quizType
        self.isLoggedIn = isLoggedIn
        let loginState = isLoggedIn ? "Logged in" : "Logged out"
        self.eventAction = "Score - Go to Quiz Arena - \(quizType.gameType) - \(loginState)"
    }
}

struct QuizzerAnalyticsLoginOrRegister: QuizzerAnalyticsEvent {
    let quizType: QuizCardItemTypeEnum
    let event = "quiz_arena_log_in_register"
    let eventAction: String
    let eventLabel = QuizzerAnalyticsEventLabel.quiz

    init(quizType: QuizCardItemTypeEnum) {
        self.quizType = quizType
        self.eventAction = "Score - Log in or register - \(quizType.gameType)"
    }
}

struct QuizzerAnalyticsPlayAgain: QuizzerAnalyticsEvent {
    let quizType: QuizCardItemTypeEnum
    let event: String
    let eventAction: String
    let eventLabel = QuizzerAnalyticsEventLabel.quiz

    init(quizType: QuizCardItemTypeEnum) {
        self.quizType = quizType
        self.event = "quiz_arena_score_\(quizType.trackingKeyQuizType)"
        self.eventAction = "Score - \(quizType.gameType) - Play again"
    }
}

struct QuizzerAnalyticsLeaderboardShare: QuizzerAnalyticsEvent {
    let quizType: QuizCardItemTypeEnum
    let event = "share"
    let eventAction: String
    let eventLabel = QuizzerAnalyticsEventLabel.quiz

    init(quizType: QuizCardItemTypeEnum) {
        self.quizType = quizType
        self.eventAction = "Leaderboard - Share - \(quizType.gameType)"
    }
}

struct QuizzerAnalyticsInviteFriends: QuizzerAnalyticsEvent {
    let event = "quiz_arena_invite_friends"
    let eventAction = "Invite friends - Quiz Arena"
    let eventLabel = QuizzerAnalyticsEventLabel.quizArena
}


struct QuizzerAnalyticsExitModalContinueQuiz: QuizzerAnalyticsEvent {
    let quizType: QuizCardItemTypeEnum
    let event = "quiz_arena_modal_continue"
    let eventAction: String
    let eventLabel = QuizzerAnalyticsEventLabel.quiz

    init(quizType: QuizCardItemTypeEnum) {
        self.quizType = quizType
        self.eventAction = "Modal - Continue - \(quizType.gameType)"
    }
}

struct QuizzerAnalyticsExitModalQuitQuiz: QuizzerAnalyticsEvent {
    let quizType: QuizCardItemTypeEnum
    let event = "quiz_arena_modal_quit"
    let eventAction: String
    let eventLabel = QuizzerAnalyticsEventLabel.quiz

    init(quizType: QuizCardItemTypeEnum) {
        self.quizType = quizType
        self.eventAction = "Modal - Quit - \(quizType.gameType)"
    }
}
