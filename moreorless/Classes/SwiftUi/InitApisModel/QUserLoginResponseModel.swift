//
//  QUserLoginResponseModel.swift
//  quiz
//
//  Created by Vishal Vijayvargiya on 19/10/23.
//

import Foundation


class UserLoginResponseClass: Codable {
    let value: QUserLoginResponseModel?
    let feedTime: FeedTime?

    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case feedTime = "FeedTime"
    }

    init(value: QUserLoginResponseModel?, feedTime: FeedTime?) {
        self.value = value
        self.feedTime = feedTime
    }
}

struct QUserLoginResponseModel: Codable {
    let userID: Int?
        let avtarID: String?
        let clientID: Int?
        let fullName: String?
        let socialID: Int?
        let userGUID, countryID, countryName: String?
        let partitionID, isGdprActive, scoremigrated, userFavTeamID: Int?

        enum CodingKeys: String, CodingKey {
            case userID = "userId"
            case avtarID = "avtarId"
            case clientID = "clientId"
            case fullName
            case socialID = "socialId"
            case userGUID = "userGuid"
            case countryID = "countryId"
            case countryName
            case partitionID = "partitionId"
            case isGdprActive, scoremigrated
            case userFavTeamID = "userFavTeamId"
        }

        init(userID: Int?, avtarID: String?, clientID: Int?, fullName: String?, socialID: Int?, userGUID: String?, countryID: String?, countryName: String?, partitionID: Int?, isGdprActive: Int?, scoremigrated: Int?, userFavTeamID: Int?) {
            self.userID = userID
            self.avtarID = avtarID
            self.clientID = clientID
            self.fullName = fullName
            self.socialID = socialID
            self.userGUID = userGUID
            self.countryID = countryID
            self.countryName = countryName
            self.partitionID = partitionID
            self.isGdprActive = isGdprActive
            self.scoremigrated = scoremigrated
            self.userFavTeamID = userFavTeamID
        }
}

class datavalueGameStatus: Codable {
    let value: GameStatus?
    let feedTime: FeedTime?

    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case feedTime = "FeedTime"
    }

    init(value: GameStatus?, feedTime: FeedTime?) {
        self.value = value
        self.feedTime = feedTime
    }
}
// MARK: - Value
class GameStatus: Codable {
    let quiztypeid, isdisable: Int?
    let gametype: String?
    let quiztitle: String?
    let isMediaQuiz: Bool?
    
    init(quiztypeid: Int?, isdisable: Int?,gametype:String?,quiztitle:String?, isMediaQuiz:Bool?) {
        self.quiztypeid = quiztypeid
        self.isdisable = isdisable
        self.gametype = gametype
        self.quiztitle = quiztitle
        self.isMediaQuiz = isMediaQuiz
    }
}
