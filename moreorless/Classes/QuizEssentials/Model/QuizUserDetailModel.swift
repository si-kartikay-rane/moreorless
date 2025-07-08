//
//  QuizUserDetailModel.swift
//  quiz
//
//  Created by Vishal Vijayvargiya on 07/11/23.
//

import Foundation
// MARK: - Value
class  QuizUserDetailModel: Codable {
    let gamedayID, categoryID, sportID, totAttemptCnt: Int?
    let totLLCnt, totQtnGameCnt, maxTimePerQue, pointProFlg, quiztypeid,pendAtmptid,AtmptNo: Int?
    let userDetails: [UserDetail]?
    
    enum CodingKeys: String, CodingKey {
        case gamedayID = "GamedayId"
        case categoryID = "CategoryID"
        case sportID = "SportID"
        case totAttemptCnt = "TotAttemptCnt"
        case totLLCnt = "TotLLCnt"
        case totQtnGameCnt = "TotQtnGameCnt"
        case maxTimePerQue = "MaxTimePerQue"
        case pointProFlg = "PointProFlg"
        case userDetails = "UserDetails"
        case quiztypeid = "quiztypeid"
        case pendAtmptid = "PendAtmptid"
        case AtmptNo = "AtmptNo"
    }
    
    init(gamedayID: Int?, categoryID: Int?, sportID: Int?, totAttemptCnt: Int?, totLLCnt: Int?, totQtnGameCnt: Int?, maxTimePerQue: Int?, pointProFlg: Int?, userDetails: [UserDetail]?,quiztypeid:Int?,pendAtmptid:Int?
         ,AtmptNo:Int?) {
        self.gamedayID = gamedayID
        self.categoryID = categoryID
        self.sportID = sportID
        self.totAttemptCnt = totAttemptCnt
        self.totLLCnt = totLLCnt
        self.totQtnGameCnt = totQtnGameCnt
        self.maxTimePerQue = maxTimePerQue
        self.pointProFlg = pointProFlg
        self.userDetails = userDetails
        self.quiztypeid =  quiztypeid
        self.pendAtmptid =  pendAtmptid
        self.AtmptNo = AtmptNo
    }
}

// MARK: - UserDetail
class UserDetail: Codable {
    let atmptNo, resumeFlag, pendAtmptid, totPt: Int?
    let streakCnt, llUsedCnt, totQtnDelCnt, totQtnRAnsCnt: Int?
    let arrQtnNo, arrQtnCorrect, arrQtnStreak: [Int]?
    let pctl: Int?
    
    enum CodingKeys: String, CodingKey {
        case atmptNo = "AtmptNo"
        case resumeFlag = "ResumeFlag"
        case pendAtmptid = "PendAtmptid"
        case totPt = "TotPt"
        case streakCnt = "StreakCnt"
        case llUsedCnt = "LLUsedCnt"
        case totQtnDelCnt = "TotQtnDelCnt"
        case totQtnRAnsCnt = "TotQtnRAnsCnt"
        case arrQtnNo = "ArrQtnNo"
        case arrQtnCorrect = "ArrQtnCorrect"
        case arrQtnStreak = "ArrQtnStreak"
        case pctl = "Pctl"
    }
    
    init(atmptNo: Int?, resumeFlag: Int?, pendAtmptid: Int?, totPt: Int?, streakCnt: Int?, llUsedCnt: Int?, totQtnDelCnt: Int?, totQtnRAnsCnt: Int?, arrQtnNo: [Int]?, arrQtnCorrect: [Int]?, arrQtnStreak: [Int]?, pctl: Int?) {
        self.atmptNo = atmptNo
        self.resumeFlag = resumeFlag
        self.pendAtmptid = pendAtmptid
        self.totPt = totPt
        self.streakCnt = streakCnt
        self.llUsedCnt = llUsedCnt
        self.totQtnDelCnt = totQtnDelCnt
        self.totQtnRAnsCnt = totQtnRAnsCnt
        self.arrQtnNo = arrQtnNo
        self.arrQtnCorrect = arrQtnCorrect
        self.arrQtnStreak = arrQtnStreak
        self.pctl = pctl
    }
}

struct QuizResultCalucate: Codable {
    let minScore: Int
    let maxScore: Int
    let heading: String
    let description: String
    var showConfetti: Bool
}


// MARK: - Value
class scoreCardData: Codable {
    let streak2Cnt, outofscore: Int?
    let arrQtnCorrect: [Int]?
    let rightAns: Int?
    let playerAssign: String?
    let qtnactualpt: Int?
    let arrQtnStreak2: [Int?]?
    let totQtn, totalStreakpt: Int?
    let arrQtnStreak: [Int]?
    let userrank: Int?
    let arrAttempFlag: [Int]?
    let userAttemptNo, streakCnt: Int?
    let arrQtnNo: [Int]?
    let maxAttemptNo, timePoints: Int?
    let playerName: String?
    let pctl, totPoints: Int?
    let streak2bonuspoint:Int?
    let streak2row:Int?
    let streakbonuspoints:Int?
    let streakrow:Int?
    
    enum CodingKeys: String, CodingKey {
        case streak2Cnt = "Streak2Cnt"
        case outofscore
        case arrQtnCorrect = "ArrQtnCorrect"
        case rightAns = "RightAns"
        case playerAssign, qtnactualpt
        case arrQtnStreak2 = "ArrQtnStreak2"
        case totQtn = "TotQtn"
        case totalStreakpt
        case arrQtnStreak = "ArrQtnStreak"
        case userrank
        case arrAttempFlag = "ArrAttempFlag"
        case userAttemptNo = "UserAttemptNo"
        case streakCnt = "StreakCnt"
        case arrQtnNo = "ArrQtnNo"
        case maxAttemptNo = "MaxAttemptNo"
        case timePoints, playerName
        case pctl = "Pctl"
        case totPoints = "TotPoints"
        case streak2bonuspoint = "streak2_bonus_point"
        case streak2row = "streak2_row"
        case streakbonuspoints = "streak_bonus_points"
        case streakrow = "streak_row"
        
        
    }
    
    init(streak2Cnt: Int?, outofscore: Int?, arrQtnCorrect: [Int]?, rightAns: Int?, playerAssign: String?, qtnactualpt: Int?,arrQtnStreak2:[Int?]?, totQtn: Int?, totalStreakpt: Int?, arrQtnStreak: [Int]?, userrank: Int?, arrAttempFlag: [Int]?, userAttemptNo: Int?, streakCnt: Int?, arrQtnNo: [Int]?, maxAttemptNo: Int?, timePoints: Int?, playerName: String?, pctl: Int?, totPoints: Int?,streak2bonuspoint:Int?,streak2row:Int?,streakbonuspoints:Int?,streakrow:Int?) {
        self.streak2Cnt = streak2Cnt
        self.outofscore = outofscore
        self.arrQtnCorrect = arrQtnCorrect
        self.rightAns = rightAns
        self.playerAssign = playerAssign
        self.qtnactualpt = qtnactualpt
        self.arrQtnStreak2 = arrQtnStreak2
        self.totQtn = totQtn
        self.totalStreakpt = totalStreakpt
        self.arrQtnStreak = arrQtnStreak
        self.userrank = userrank
        self.arrAttempFlag = arrAttempFlag
        self.userAttemptNo = userAttemptNo
        self.streakCnt = streakCnt
        self.arrQtnNo = arrQtnNo
        self.maxAttemptNo = maxAttemptNo
        self.timePoints = timePoints
        self.playerName = playerName
        self.pctl = pctl
        self.totPoints = totPoints
        self.streak2bonuspoint = streak2bonuspoint
        self.streak2row = streak2row
        self.streakbonuspoints = streakbonuspoints
        self.streakrow = streakrow
    }
}


//MARK: - timerData

class timerData:Codable{
    let gametype: String?
    let isdisable, cardstate: Int?
    let quizstartdate, quizEndDate: String?
    let nextQuizStartText, nextQuizStartHrText, nextQuizStartMinText: String?
    let nextQuizHrLeft, nextQuizMinLeft: String?
    var difficultyLevels: [DifficultyLevel]?
    let isDifficultyApplied: Bool?
    let defaultDifficulty: String?
    let difficultyTimer: Int?
    
    
    enum CodingKeys: String, CodingKey {
        case gametype, isdisable, cardstate, quizstartdate
        case quizEndDate = "quiz_end_date"
        case nextQuizStartText = "next_quiz_start_text"
        case nextQuizStartHrText = "next_quiz_start_hr_text"
        case nextQuizStartMinText = "next_quiz_start_min_text"
        case nextQuizHrLeft = "str_next_quiz_hr_left"
        case nextQuizMinLeft = "str_next_quiz_min_left"
        case difficultyLevels = "difficulty_levels"
        case isDifficultyApplied = "is_difficulty_applied"
        case defaultDifficulty = "default_difficulty"
        case difficultyTimer = "difficulty_timer"
    }
}


// MARK: - DataClass
class GameAttemptConfigData: Codable {
    let retType, timeSpan, isBooster: Int?
    let quizVisability: String?
    let isTimer, totQues, totBooster, streakIsactive: Int?
    let streakPt, gameQuecount, maxQuetime, timeBonus: Int?
    let timeBonuspt, isAnsshow: Int?
    let booster: [Booster]?
    let livequizstartdt, startDate, endDate: String?
    let streakCount, themeID, dayAttempts, isQuesrepat: Int?
    let styleVar: String?
    let isPublish, streak2Isactive, streak2Pt, streak2Count, quiztypeid,QuPoint: Int?
    
    enum CodingKeys: String, CodingKey {
        case retType, timeSpan, isBooster, quizVisability, isTimer, totQues, totBooster, streakIsactive, streakPt, gameQuecount, maxQuetime, timeBonus, timeBonuspt, isAnsshow, booster, livequizstartdt, startDate, endDate, streakCount
        case themeID = "themeId"
        case dayAttempts, isQuesrepat, styleVar, isPublish, streak2Isactive, streak2Pt, streak2Count,quiztypeid, QuPoint
    }
    
    init(retType: Int?, timeSpan: Int?, isBooster: Int?, quizVisability: String?, isTimer: Int?, totQues: Int?, totBooster: Int?, streakIsactive: Int?, streakPt: Int?, gameQuecount: Int?, maxQuetime: Int?, timeBonus: Int?, timeBonuspt: Int?, isAnsshow: Int?, booster: [Booster]?, livequizstartdt: String?, startDate: String?, endDate: String?, streakCount: Int?, themeID: Int?, dayAttempts: Int?, isQuesrepat: Int?, styleVar: String?, isPublish: Int?, streak2Isactive: Int?, streak2Pt: Int?, streak2Count: Int?,quiztypeid:Int?,QuPoint:Int?) {
        self.retType = retType
        self.timeSpan = timeSpan
        self.isBooster = isBooster
        self.quizVisability = quizVisability
        self.isTimer = isTimer
        self.totQues = totQues
        self.totBooster = totBooster
        self.streakIsactive = streakIsactive
        self.streakPt = streakPt
        self.gameQuecount = gameQuecount
        self.maxQuetime = maxQuetime
        self.timeBonus = timeBonus
        self.timeBonuspt = timeBonuspt
        self.isAnsshow = isAnsshow
        self.booster = booster
        self.livequizstartdt = livequizstartdt
        self.startDate = startDate
        self.endDate = endDate
        self.streakCount = streakCount
        self.themeID = themeID
        self.dayAttempts = dayAttempts
        self.isQuesrepat = isQuesrepat
        self.styleVar = styleVar
        self.isPublish = isPublish
        self.streak2Isactive = streak2Isactive
        self.streak2Pt = streak2Pt
        self.streak2Count = streak2Count
        self.quiztypeid = quiztypeid
        self.QuPoint = QuPoint
    }
}

// MARK: - Booster
class Booster: Codable {
    let boosterID: Int?
    let boosterName: String?
    
    enum CodingKeys: String, CodingKey {
        case boosterID = "boosterId"
        case boosterName
    }
    
    init(boosterID: Int?, boosterName: String?) {
        self.boosterID = boosterID
        self.boosterName = boosterName
    }
}

