//
//  CardListModel.swift
//  quiz
//
//  Created by Vishal Vijayvargiya on 09/11/23.
//

import Foundation

class cardListValue: Codable {
    let quizcard: [QuizCardListData]?

    init(quizcard: [QuizCardListData]?) {
        self.quizcard = quizcard
    }
}


class QuizCardListData: Codable {
    let title, quiztype, subtitle: String?
        var isDisable: Int?
        let description: String?
        let qzQuizMasterid: String?
        var isFun:Bool?
        let bgimage:String?
        let quiztypeid:Int?
        var rank:Int?
        var points:Int?
        let cta:String?
        var cardState:Int? = nil
        var showWinner:Int? = nil
        var quizStartDate:String? = nil
        var quizEndDate:String? = nil
        var winnerName:String? = nil
        let gametype:String?
        var timer:String? =  nil
        let gatitle:String?
        var isMediaQuiz: Bool?
        var difficultyLevels: [DifficultyLevel]?
        let isDifficultyApplied: Bool?
        let defaultDifficulty: Int?
        let difficultyTimer: Int?
        let gaPageTitle: String?
        let gaPageName: String?
        let gaPageSubType: String?
    
        enum CodingKeys: String, CodingKey {
            case title, quiztype, subtitle, description
            case qzQuizMasterid = "id"
            case isDisable = "isdisable"
            case bgimage = "bg_image"
            case quiztypeid = "quiztypeid"
            case cta = "cta"
            case rank = "rank"
            case points = "points"
            case cardState = "card_state"
            case showWinner = "show_winner"
            case quizStartDate = "quiz_start_date"
            case quizEndDate = "quiz_end_date"
            case winnerName = "winner_name"
            case gametype = "gametype"
            case gatitle = "ga_title"
            case isMediaQuiz = "isMediaQuiz"
            case difficultyLevels = "difficulty_levels"
            case isDifficultyApplied = "is_difficulty_applied"
            case defaultDifficulty = "default_difficulty_id"
            case difficultyTimer = "difficulty_timer"
            case gaPageTitle = "GA_PageTitle"
            case gaPageName = "GA_PageName"
            case gaPageSubType = "GA_PageSubType"
        }

    init(title: String?, quiztype: String?, subtitle: String?, isdisable: Int?, description: String?, qzQuizMasterid: String?,quiztypeid:Int?,bgimage:String?,cta:String?,rank:Int?,points:Int?,cardState:Int? ,showWinner:Int? ,quizStartDate:String?,quizEndDate:String?,winnerName:String?,gametype:String?,gatitle:String?,isMediaQuiz: Bool?, difficultyLevels: [DifficultyLevel]?, isDifficultyApplied: Bool, defaultDifficulty: Int?, difficultyTimer: Int?, gaPageTitle: String?, gaPageName: String?, gaPageSubType: String?) {
            self.title = title
            self.quiztype = quiztype
            self.subtitle = subtitle
            self.isDisable = isdisable
            self.description = description
            self.qzQuizMasterid = qzQuizMasterid
            self.bgimage =  bgimage
            self.quiztypeid = quiztypeid
            self.cta = cta
            self.rank = rank
            self.points = points
            self.cardState = cardState
            self.showWinner = showWinner
            self.quizStartDate = quizStartDate
            self.quizEndDate = quizEndDate
            self.winnerName = winnerName
            self.gametype = gametype
            self.gatitle = gatitle
            self.isMediaQuiz = isMediaQuiz
            self.difficultyLevels = difficultyLevels
            self.isDifficultyApplied = isDifficultyApplied
            self.defaultDifficulty = defaultDifficulty
            self.difficultyTimer = difficultyTimer
            self.gaPageName = gaPageName
            self.gaPageTitle = gaPageTitle
            self.gaPageSubType = gaPageSubType
        }
}


// MARK: - Value
class leaderboardValue: Codable {
    let leaderboard: [Leaderboard]?

    init(leaderboard: [Leaderboard]?) {
        self.leaderboard = leaderboard
    }
}

// MARK: - Leaderboard
class Leaderboard: Codable {
        let quizid: String?
        let topranking: [leaderboardRanking]?
        let leaderboardtype: String?
    let leaderboardtitle:String?
    let quiztypeid:Int?

    init(quizid:String?,leaderboardtype: String?, topranking: [leaderboardRanking]?,quiztypeid:Int?,leaderboardtitle:String?) {
        self.leaderboardtype = leaderboardtype
        self.topranking = topranking
        self.quizid =  quizid
        self.quiztypeid = quiztypeid
        self.leaderboardtitle = leaderboardtitle
    }
}

// MARK: - TopRanking
class leaderboardRanking: Codable {
    let quizid: String?
    let leaderboardtype, guid: String?
    let rank, selfrank, level, trend: Int?
    let avatar, fullname: String?
    let overallpoints, correctaccuracy: Int?
    
    init(quizid: String?, leaderboardtype: String?, guid: String?, rank: Int?, selfrank: Int?, level: Int?, trend: Int?, avatar: String?, fullname: String?, overallpoints: Int?, correctaccuracy: Int?) {
        self.quizid = quizid
        self.leaderboardtype = leaderboardtype
        self.guid = guid
        self.rank = rank
        self.selfrank = selfrank
        self.level = level
        self.trend = trend
        self.avatar = avatar
        self.fullname = fullname
        self.overallpoints = overallpoints
        self.correctaccuracy = correctaccuracy
    }
}

class leaderboardMenuValue: Codable {
    let title,avatar,quizid,totalplayer,leaderboardtitle: String?
        let  userrank , quiztypeid: Int?

    init(title: String?,avatar:String?, quizid: String?, userrank: Int?, totalplayer: String?,quiztypeid:Int?,leaderboardtitle:String?) {
            self.title = title
            self.quizid = quizid
            self.userrank = userrank
            self.totalplayer = totalplayer
            self.avatar = avatar
            self.quiztypeid = quiztypeid
        self.leaderboardtitle = leaderboardtitle
        
        }
}


// MARK: - Value
class leaderboardRankValue: Codable {
    var userInfo: [leaderboardRanking]?
    let maxoffset: Int?
    let totUserNew, quiztypeid: Int?
    var isButtonShowHide:Bool? = false
    
    let leaderboardtype: String?
    let leaderboardtitle:String?
    let ga_title : String?
    let GA_PageName: String?
    let GA_PageSubType: String?
    let GA_PageTitle: String?
    let gametype: String?

    init(userInfo: [leaderboardRanking]?, maxoffset: Int?, totUserNew: Int?,quiztypeid:Int?,leaderboardtype:String?,leaderboardtitle:String?,ga_title : String?, gametype: String?,  GA_PageName: String?, GA_PageSubType: String?, GA_PageTitle: String? ) {
        self.userInfo = userInfo
        self.maxoffset = maxoffset
        self.totUserNew = totUserNew
        self.leaderboardtype = leaderboardtype
        self.quiztypeid = quiztypeid
        self.leaderboardtitle = leaderboardtitle
        self.ga_title = ga_title
        self.GA_PageName = GA_PageName
        self.GA_PageTitle = GA_PageTitle
        self.GA_PageSubType = GA_PageSubType
        self.gametype = gametype
    }
}

class selfRankDataValue: Codable {
    let userdata: [leaderboardRanking]?

    init(userdata: [leaderboardRanking]?) {
        self.userdata = userdata
    }
}

class RankPointDisable: Codable {
    let quizid,timer: String?
    let isdisable, rank, points: Int?

    init(quizid: String?, isdisable: Int?, rank: Int?, points: Int?,timer:String?) {
        self.quizid = quizid
        self.isdisable = isdisable
        self.rank = rank
        self.points = points
        self.timer = timer
    }
}

struct DifficultyLevel: Codable {
    let id: Int
    let level: String
    let points: Int
}
