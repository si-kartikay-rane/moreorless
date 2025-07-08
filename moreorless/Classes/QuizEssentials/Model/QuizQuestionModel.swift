//
//  QuizQuestionModel.swift
//  Pods
//
//  Created by Vishal Vijayvargiya on 01/09/23.
//

import Foundation

// MARK: - Value
struct QuizQuestionModel: Codable {
    let quID: Int?
    let quDES: String?
    let optionNode: [OptionNode]?
    let quNo, quDayID, quCatID, quSportID: Int?
    let quAttemptID, quTime: Int?
    let quType: String?
    let quPoint: Int?
    let quMediaType: String?
    let quMediaUrl: String?
    let questionMediaUrls: [String?]?
    let cropLocation: String?
    let croppingPercentage: Int?
    let isCroppingApplied: Bool?
    let quPlaceholderImage: String?
    let mediaViewType: String?
    var lastQuAnsOpt: String?
    var lastUserAnsFlag, lastStreakAct, streakRow, streakBonusPoints: Int?
    var lastStreak2Act, streak2Row, streak2BonusPoint, userAtpPt: Int?
    var lastQuPoint, quTotCnt, userFiftyLifeCnt, userSneakLifeCnt: Int?
    let userSwitchLifeCnt: Int?
    let url: String?
    let urlTypeid, urlDduaration: Int?
    let arrIscorrect, arrIsattemptflag: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case quID = "QuId"
        case quDES = "QuDes"
        case optionNode = "OptionNode"
        case quNo = "QuNo"
        case quDayID = "QuDayId"
        case quCatID = "QuCatId"
        case quSportID = "QuSportId"
        case quAttemptID = "QuAttemptId"
        case quTime = "QuTime"
        case quType = "QuType"
        case quPoint = "QuPoint"
        case quMediaType = "QuMediaType"
        case quMediaUrl = "QuMediaUrl"
        case questionMediaUrls = "QuestionMediaUrls"
        case quPlaceholderImage = "QuPlaceholderImage"
        case cropLocation = "CropLocation"
        case croppingPercentage = "CroppingPercentage"
        case isCroppingApplied = "IsCroppingApplied"
        case mediaViewType = "MediaViewType"
        case lastQuAnsOpt = "LastQuAnsOpt"
        case lastUserAnsFlag = "LastUserAnsFlag"
        case lastStreakAct = "LastStreakAct"
        case streakRow = "streak_row"
        case streakBonusPoints = "streak_bonus_points"
        case lastStreak2Act = "LastStreak2Act"
        case streak2Row = "streak2_row"
        case streak2BonusPoint = "streak2_bonus_point"
        case userAtpPt = "UserAtpPt"
        case lastQuPoint
        case quTotCnt = "QuTotCnt"
        case userFiftyLifeCnt = "UserFiftyLifeCnt"
        case userSneakLifeCnt = "UserSneakLifeCnt"
        case userSwitchLifeCnt = "UserSwitchLifeCnt"
        case url, urlTypeid, urlDduaration, arrIscorrect, arrIsattemptflag
    }
    
    init(quID: Int?, quDES: String?, optionNode: [OptionNode]?, quNo: Int?, quDayID: Int?, quCatID: Int?, quSportID: Int?, quAttemptID: Int?, quTime: Int?, quType: String?, quPoint: Int?, lastQuAnsOpt: String?, lastUserAnsFlag: Int?, lastStreakAct: Int?, streakRow: Int?, streakBonusPoints: Int?, lastStreak2Act: Int?, streak2Row: Int?, streak2BonusPoint: Int?, userAtpPt: Int?, lastQuPoint: Int?, quTotCnt: Int?, userFiftyLifeCnt: Int?, userSneakLifeCnt: Int?, userSwitchLifeCnt: Int?, url: String?, urlTypeid: Int?, urlDduaration: Int?, arrIscorrect: [Int]?, arrIsattemptflag: [Int]?, quMediaType: String?, quMediaUrl:String?, quPlaceholderImage: String?,cropLocation:String?,croppingPercentage:Int?,isCroppingApplied:Bool?,mediaViewType:String?, questionMediaUrls:[String?]?) {
        self.quID = quID
        self.quDES = quDES
        self.optionNode = optionNode
        self.quNo = quNo
        self.quDayID = quDayID
        self.quCatID = quCatID
        self.quSportID = quSportID
        self.quAttemptID = quAttemptID
        self.quTime = quTime
        self.quType = quType
        self.quPoint = quPoint
        self.lastQuAnsOpt = lastQuAnsOpt
        self.lastUserAnsFlag = lastUserAnsFlag
        self.lastStreakAct = lastStreakAct
        self.streakRow = streakRow
        self.streakBonusPoints = streakBonusPoints
        self.lastStreak2Act = lastStreak2Act
        self.streak2Row = streak2Row
        self.streak2BonusPoint = streak2BonusPoint
        self.userAtpPt = userAtpPt
        self.lastQuPoint = lastQuPoint
        self.quTotCnt = quTotCnt
        self.userFiftyLifeCnt = userFiftyLifeCnt
        self.userSneakLifeCnt = userSneakLifeCnt
        self.userSwitchLifeCnt = userSwitchLifeCnt
        self.url = url
        self.urlTypeid = urlTypeid
        self.urlDduaration = urlDduaration
        self.arrIscorrect = arrIscorrect
        self.arrIsattemptflag = arrIsattemptflag
        self.quMediaType = quMediaType
        self.quMediaUrl = quMediaUrl
        self.quPlaceholderImage = quPlaceholderImage
        self.cropLocation = cropLocation
        self.isCroppingApplied = isCroppingApplied
        self.croppingPercentage = croppingPercentage
        self.mediaViewType = mediaViewType
        self.questionMediaUrls = questionMediaUrls
    }
}

// MARK: - OptionNode
class OptionNode: Codable {
    let option, value: String?

    init(option: String?, value: String?) {
        self.option = option
        self.value = value
    }
}


struct FiftyFiftyValue: Codable {
    let inCorrectOpt1, inCorrectOpt2: String?
    let userFiftyLifeCnt: Int?

    enum CodingKeys: String, CodingKey {
        case inCorrectOpt1 = "InCorrectOpt1"
        case inCorrectOpt2 = "InCorrectOpt2"
        case userFiftyLifeCnt = "UserFiftyLifeCnt"
    }
}

// MARK: - Value
struct VarSneakPeakValue: Codable {
    let isSuccessful: Int?
    let userSneakLifeCnt: Int?

    enum CodingKeys: String, CodingKey {
        case isSuccessful = "IsSuccessful"
        case userSneakLifeCnt = "UserSneakLifeCnt"
    }
}


struct QuestionAnsCheckModel{
    var totalQuestion:Int?
    var currentIndex:Int?
    var isCorrectAns:Bool = false
    var TotalPoint:Int?
    
}

enum MediaType: String {
    case text = "TEXT"
    case image = "IMAGE"
    case video = "VIDEO"
    case audio = "AUDIO"
    case unknown = "UNKNOWN"
    
    init(rawValue: String) {
        switch rawValue.uppercased() {
        case "TEXT":
            self = .text
        case "IMAGE":
            self = .image
        default:
            self = .unknown
        }
    }
}

enum MediaViewType: String {
    case playerFront = "PlayerFront"
    case clubLogo = "ClubLogo"
    case playerHeadshot = "PlayerHeadshot"
    case manualMedia = "ManualMedia"
    case stadium = "Stadium"
    case unknown = "UNKNOWN"
    
    init(rawValue: String) {
        switch rawValue{
        case "PlayerFront":
            self = .playerFront
        case "ClubLogo":
            self = .clubLogo
        case "PlayerHeadshot":
            self = .playerHeadshot
        case "Stadium":
            self = .stadium
        case "ManualMedia":
            self = .manualMedia
        default:
            self = .unknown
        }
    }
}
