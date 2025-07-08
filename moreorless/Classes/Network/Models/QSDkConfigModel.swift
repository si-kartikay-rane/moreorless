//
//  QSDkConfigModel.swift
//  UEFAQuizSDK
//
//  Created by Vishal Vijayvargiya on 24/08/23.
//

import Foundation

class ConfigModel: Codable {
    let baseDomain: String?
    let confettiUrl:  String?
    let imageVersion: Int?
    let leaderBoardPagingPerPage, leaderBoardPagingPerPageForGuest ,quizId_1: Int?
    let quizId_2, leaderboardMaxPointLength, leaderboardMaxRankLength: Int?
    let endpoints: Endpoints?
    let resultMessages: [QuizResultCalucate]?
    let resultMessagesattemptMOl : [QuizResultCalucate]?
    let socialShare: SocialShare?
    let socialShareGameSpecific: SocialShare?
    let adBanner: [String:String]?
    let pageTrackConstants: [String:[String:String]]?
    let quizTypeTrackingKey: [String: String]?
    let landingPageItems: [LandingPageItem]?
    let dynamicQuizTypeTrackingKey: [String: DynamicQuizTypeTrackingKey]?
    let isImagePreLoading: Bool?
    let isShowNotificationCard: Bool?
    let isShowKebabMenu: Bool?
    
    enum CodingKeys: String, CodingKey {
        case baseDomain, imageVersion, endpoints, quizId_1, quizId_2 ,confettiUrl, isImagePreLoading ,socialShare ,adBanner ,leaderBoardPagingPerPage, isShowNotificationCard, isShowKebabMenu
        ,leaderBoardPagingPerPageForGuest
        case resultMessages = "result-messages"
        case resultMessagesattemptMOl = "result-messages_by_attempt"
        case socialShareGameSpecific = "socialShareGameSpecific"
        case pageTrackConstants
        case leaderboardMaxPointLength, leaderboardMaxRankLength,quizTypeTrackingKey,landingPageItems,dynamicQuizTypeTrackingKey
    }

    init(baseDomain: String?, imageVersion: Int?,quizId_1:Int?, quizId_2:Int?, endpoints: Endpoints?, resultMessages: [QuizResultCalucate]?,confettiUrl:String?,socialShare:SocialShare?,adBanner:[String:String]?,leaderBoardPagingPerPage:Int?,
         leaderBoardPagingPerPageForGuest:Int?,leaderboardMaxPointLength:Int?,
         leaderboardMaxRankLength:Int?,pageTrackConstants: [String:[String:String]]?,quizTypeTrackingKey: [String: String]?,landingPageItems: [LandingPageItem]?,resultMessagesattemptMOl:[QuizResultCalucate]?,socialShareGameSpecific:SocialShare?,dynamicQuizTypeTrackingKey:[String:DynamicQuizTypeTrackingKey]?, isImagePreLoading:Bool?,isShowNotificationCard:Bool?, isShowKebabMenu: Bool?) {
        self.baseDomain = baseDomain
        self.imageVersion = imageVersion
        self.endpoints = endpoints
        self.resultMessages = resultMessages
        self.quizId_1 =  quizId_1
        self.quizId_2 = quizId_2
        self.confettiUrl = confettiUrl
        self.isImagePreLoading = isImagePreLoading
        self.socialShare =  socialShare
        self.adBanner =  adBanner
        self.leaderBoardPagingPerPage = leaderBoardPagingPerPage
        self.leaderBoardPagingPerPageForGuest = leaderBoardPagingPerPageForGuest
        self.pageTrackConstants = pageTrackConstants
        self.leaderboardMaxPointLength = leaderboardMaxPointLength
        self.leaderboardMaxRankLength = leaderboardMaxRankLength
        self.quizTypeTrackingKey =  quizTypeTrackingKey
        self.landingPageItems = landingPageItems
        self.resultMessagesattemptMOl = resultMessagesattemptMOl
        self.socialShareGameSpecific = socialShareGameSpecific
        self.dynamicQuizTypeTrackingKey = dynamicQuizTypeTrackingKey
        self.isShowKebabMenu = isShowKebabMenu
        self.isShowNotificationCard = isShowNotificationCard
        
    }
    
    enum DeeplinkRoute: String{
        case home = "uclquiz"
        case leaderboard = "leaderboard"
        case game = "game"
        case none = "none"
    }
}

// MARK: - Endpoints
class Endpoints: Codable {
    let loginURL, translationsURL, userDetailsURL, quizStartGameURL, quizGameStatusUrl,quizUserGameDetailsUrl: String?
    let quizGameQuestionURL, quizApplyFiftyFiftyBoosterURL, quizApplyVarBoosterURL, quizScoredCardURL: String?
    let gameDetailsURL, quizStatusURL, quizCardBannerURL, quizGameSettleURL: String?
    let leaderboardUserRankingURL, leaderboardTopRankingURL, landingPageQuizCardURL, leaderboardSelfUserRankingURL: String?
    let leaderboardRankingURL, guestUserLeaderBoardTopRankingURL, guestUserOverViewLeaderBoardURL, guestUserLeaderBoardRankingURL: String?
    let molStartGameCardUrl: String?
    let molQuestionGameCardUrl: String?
    let landingPageQuizCardUrl2: String?
    let landingPageQuizCardPointUrl: String?
    let leaderboardRankingUrlLive: String?
    let leaderboardSelfUserRankingUrlLive: String?
    let leaderboardTopRankingUrlLive: String?
    let leaderboardUserRankingUrlLive: String?
    let molScoreCardUrl : String?
    let guestUserLeaderBoardRankingUrlV2:String?
    let guestUserLeaderBoardTopRankingUrlV2:String?
    let guestUserOverViewLeaderBoardUrlV2:String?
    let userQuizDetails: String?
    
    enum CodingKeys: String, CodingKey {
        case loginURL = "loginUrl"
        case translationsURL = "translationsUrl"
        case userDetailsURL = "userDetailsUrl"
        case quizStartGameURL = "quizStartGameUrlV5"
        case quizGameQuestionURL = "quizGameQuestionUrlV4"
        case quizApplyFiftyFiftyBoosterURL = "quizApplyFiftyFiftyBoosterUrl2"
        case quizApplyVarBoosterURL = "quizApplyVarBoosterUrl2"
        case quizScoredCardURL = "quizScoredCardUrl"
        case gameDetailsURL = "gameDetailsUrl"
        case quizStatusURL = "quizStatusUrl"
        case quizCardBannerURL = "quizCardBannerUrl"
        case quizGameSettleURL = "quizGameSettleUrl"
        case leaderboardUserRankingURL = "leaderboardUserRankingUrl"
        case leaderboardTopRankingURL = "leaderboardTopRankingUrl"
        case landingPageQuizCardURL = "landingPageQuizCardUrl"
        case leaderboardSelfUserRankingURL = "leaderboardSelfUserRankingUrl"
        case leaderboardRankingURL = "leaderboardRankingUrl"
        case guestUserLeaderBoardTopRankingURL = "guestUserLeaderBoardTopRankingUrl"
        case guestUserOverViewLeaderBoardURL = "guestUserOverViewLeaderBoardUrl"
        case guestUserLeaderBoardRankingURL = "guestUserLeaderBoardRankingUrl"
        case quizGameStatusUrl = "quizGameStatusUrl"
        case molStartGameCardUrl = "molStartGameCardUrl"
        case molQuestionGameCardUrl = "molQuestionGameCardUrl"
        case landingPageQuizCardUrl2 = "landingPageQuizCardUrl3"
        case landingPageQuizCardPointUrl = "landingPageQuizCardPointUrlv2"
        case leaderboardUserRankingUrlLive =     "leaderboardUserRankingUrlV3"
        case leaderboardRankingUrlLive =     "leaderboardRankingUrlV5"
        case leaderboardSelfUserRankingUrlLive =     "leaderboardSelfUserRankingUrlV4"
        case leaderboardTopRankingUrlLive =     "leaderboardTopRankingUrlV3"
        case guestUserLeaderBoardRankingUrlV2 = "guestUserLeaderBoardRankingUrlV3"
        case guestUserLeaderBoardTopRankingUrlV2 = "guestUserLeaderBoardTopRankingUrlV3"
        case guestUserOverViewLeaderBoardUrlV2 = "guestUserOverViewLeaderBoardUrlV3"
        case molScoreCardUrl = "molScoreCardUrl"
        case userQuizDetails = "userQuizDetails"
        case quizUserGameDetailsUrl = "quizUserGameDetailsUrl"
    }

    init(loginURL: String?, translationsURL: String?, userDetailsURL: String?, quizStartGameURL: String?, quizGameQuestionURL: String?, quizApplyFiftyFiftyBoosterURL: String?, quizApplyVarBoosterURL: String?, quizScoredCardURL: String?, gameDetailsURL: String?, quizStatusURL: String?, quizCardBannerURL: String?, quizGameSettleURL: String?, leaderboardUserRankingURL: String?, leaderboardTopRankingURL: String?, landingPageQuizCardURL: String?, leaderboardSelfUserRankingURL: String?, leaderboardRankingURL: String?, guestUserLeaderBoardTopRankingURL: String?, guestUserOverViewLeaderBoardURL: String?, guestUserLeaderBoardRankingURL: String?, quizGameStatusUrl:String?,molStartGameCardUrl:String?,molQuestionGameCardUrl:String?,landingPageQuizCardUrl2:String?,landingPageQuizCardPointUrl:String?,leaderboardRankingUrlLive: String?,leaderboardSelfUserRankingUrlLive: String?,leaderboardTopRankingUrlLive: String?,leaderboardUserRankingUrlLive: String?,molScoreCardUrl:String?,guestUserLeaderBoardRankingUrlV2:String?,guestUserLeaderBoardTopRankingUrlV2:String?,guestUserOverViewLeaderBoardUrlV2:String?, userQuizDetails:String?,quizUserGameDetailsUrl:String? ) {
        self.loginURL = loginURL
        self.translationsURL = translationsURL
        self.userDetailsURL = userDetailsURL
        self.quizStartGameURL = quizStartGameURL
        self.quizGameQuestionURL = quizGameQuestionURL
        self.quizApplyFiftyFiftyBoosterURL = quizApplyFiftyFiftyBoosterURL
        self.quizApplyVarBoosterURL = quizApplyVarBoosterURL
        self.quizScoredCardURL = quizScoredCardURL
        self.gameDetailsURL = gameDetailsURL
        self.quizStatusURL = quizStatusURL
        self.quizCardBannerURL = quizCardBannerURL
        self.quizGameSettleURL = quizGameSettleURL
        self.leaderboardUserRankingURL = leaderboardUserRankingURL
        self.leaderboardTopRankingURL = leaderboardTopRankingURL
        self.landingPageQuizCardURL = landingPageQuizCardURL
        self.leaderboardSelfUserRankingURL = leaderboardSelfUserRankingURL
        self.leaderboardRankingURL = leaderboardRankingURL
        self.guestUserLeaderBoardTopRankingURL = guestUserLeaderBoardTopRankingURL
        self.guestUserOverViewLeaderBoardURL = guestUserOverViewLeaderBoardURL
        self.guestUserLeaderBoardRankingURL = guestUserLeaderBoardRankingURL
        self.quizGameStatusUrl = quizGameStatusUrl
        self.molStartGameCardUrl = molStartGameCardUrl
        self.molQuestionGameCardUrl = molQuestionGameCardUrl
        self.landingPageQuizCardUrl2 = landingPageQuizCardUrl2
        self.landingPageQuizCardPointUrl = landingPageQuizCardPointUrl
        self.leaderboardRankingUrlLive =     leaderboardRankingUrlLive
        self.leaderboardSelfUserRankingUrlLive =     leaderboardSelfUserRankingUrlLive
        self.leaderboardTopRankingUrlLive =     leaderboardTopRankingUrlLive
        self.leaderboardUserRankingUrlLive =     leaderboardUserRankingUrlLive
        self.molScoreCardUrl = molScoreCardUrl
        self.guestUserLeaderBoardRankingUrlV2 = guestUserLeaderBoardRankingUrlV2
        self.guestUserLeaderBoardTopRankingUrlV2 = guestUserLeaderBoardTopRankingUrlV2
        self.guestUserOverViewLeaderBoardUrlV2 = guestUserOverViewLeaderBoardUrlV2
        self.userQuizDetails = userQuizDetails
        self.quizUserGameDetailsUrl = quizUserGameDetailsUrl
    }
}


// MARK: - SocialShare
class SocialShare: Codable {
    let overview, quizResult, leaderboard: SocialShareLeaderboard?

    enum CodingKeys: String, CodingKey {
        case overview = "/overview"
        case quizResult = "/quiz-result"
        case leaderboard = "/leaderboard"
    }

    init(overview: SocialShareLeaderboard?, quizResult: SocialShareLeaderboard?, leaderboard: SocialShareLeaderboard?) {
        self.overview = overview
        self.quizResult = quizResult
        self.leaderboard = leaderboard
    }
}

// MARK: - SocialShareLeaderboard
class SocialShareLeaderboard: Codable {
    let modalTitle, modalDesc: String?
    let loadLink: String?
    let loadText: String?

    init(modalTitle: String?, modalDesc: String?, loadLink: String?, loadText: String?) {
        self.modalTitle = modalTitle
        self.modalDesc = modalDesc
        self.loadLink = loadLink
        self.loadText = loadText
    }

}


// MARK: - LeagueClass
class LeagueClass: Codable {
    let pageName, event, competition, competitionDate: String?
    let lang: String?

    enum CodingKeys: String, CodingKey {
        case pageName = "page_name"
        case event, competition
        case competitionDate = "competition_date"
        case lang
    }

    init(pageName: String?, event: String?, competition: String?, competitionDate: String?, lang: String?) {
        self.pageName = pageName
        self.event = event
        self.competition = competition
        self.competitionDate = competitionDate
        self.lang = lang
    }
}
// MARK: - LandingPageItem
class LandingPageItem: Codable {
    let visible, enabled: Bool?
    let itemID: Int?
    let displayTitle: String?
    let order: Int?

    enum CodingKeys: String, CodingKey {
        case visible, enabled
        case itemID = "item_id"
        case displayTitle = "display_title"
        case order
    }

    init(visible: Bool?, enabled: Bool?, itemID: Int?, displayTitle: String?, order: Int?) {
        self.visible = visible
        self.enabled = enabled
        self.itemID = itemID
        self.displayTitle = displayTitle
        self.order = order
    }
}
// MARK: - DynamicQuizTypeTrackingKey
class DynamicQuizTypeTrackingKey: Codable {
    let trackingKeyQuizTypeEventAction, trackingKeyQuizTypeEvent: String?
}
