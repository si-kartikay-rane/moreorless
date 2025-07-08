//
//  QUserLoginRequestModel.swift
//  quiz
//
//  Created by Vishal Vijayvargiya on 18/10/23.
//

import Foundation
class QUserLoginRequestModel: Encodable{
    var optType: Int
    var platformId: Int
    var userId: Int
    var socialId: Int
    var gigyaId: String
    var fullName: String
    var countryCode: String?
    var favTeamCode: String
    var profilePic: String
    var level: String
    var levelName: String
    var favTeamId: Int?
    var accessToken: String
    var clientId:Int
    var gameplaydetail:[Gameplaydetail]
    
    init() {
        optType = -1
        platformId = -1
        userId = -1
        socialId = -1
        gigyaId = ""
        fullName = ""
        countryCode = ""
        favTeamCode = ""
        profilePic = ""
        level = ""
        levelName = ""
        favTeamId = -1
        accessToken = ""
        clientId = -1
        gameplaydetail = []
    }
    
}

class QuizRequestModel: Encodable{
    
    var isGuestUser: Bool?
    var questionsPlayed: [Int]?

    
    init(isGuestUser: Bool?, questionsPlayed: [Int]?) {
        self.isGuestUser = isGuestUser
        self.questionsPlayed = questionsPlayed
    }
}

class Gameplaydetail: Codable {
    let  score: Int?
    let  quizid ,gamedate: String?
    let quiztypeid : Int?

    init(quizid: String?, score: Int?, gamedate: String?,quiztypeid:Int?) {
        self.quizid = quizid
        self.score = score
        self.gamedate = gamedate
        self.quiztypeid = quiztypeid
    }
}
