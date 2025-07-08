//
//  MLQuestionModel.swift
//  quiz
//
//  Created by Vishal Vijayvargiya on 10/02/24.
//

import Foundation



class MLQuestionModel: Codable {
    var attemptID: Int?
       var gametype: String?
       var islastanscorrect: Int?
       var isAttemptEnds: Int?
       var lastplayervalue: Int?
       var questioncard: QuestionCard?
       var streaktotal: Int?
       var totalpoint: Int?
       var skipBoosterUsed: Int?
       var addedTimeUsed: Int?
       var gamedescription: String?
       var gametimer: Int?
       var basecard: BaseCard?
    var totalquestions:Int?
    var perquestionpoint:Int?
       
       enum CodingKeys: String, CodingKey {
           case attemptID = "attemptid"
           case gametype
           case islastanscorrect = "islastanscorrect"
           case isAttemptEnds = "isattemptends"
           case lastplayervalue = "lastplayervalue"
           case questioncard = "questioncard"
           case streaktotal = "streaktotal"
           case totalpoint = "totalpoint"
           case skipBoosterUsed = "skipboosterused"
           case addedTimeUsed = "addedtimeused"
           case gamedescription, gametimer, basecard
           case totalquestions = "totalquestions"
           case perquestionpoint = "perquestionpoint"
       }
   }

   struct QuestionCard: Codable {
       var qid: Int?
       var question: String?
       var playername: String?
       var playerimg: String?
       var playerid: Int?
       var values: Int?
       
       enum CodingKeys: String, CodingKey {
           case qid = "qno"
           case question
           case playername = "player_name"
           case playerimg = "playerimg"
           case playerid = "playerid"
           case values
       }
   }

   struct BaseCard: Codable {
       var playername: String?
       var playerimg: String?
       var value: Int?
       var playerid: Int?
       var position: MLQuestionAnsView.CardPosition = .bottom
       var isQuestionViewHide:Bool = true
       
       enum CardPosition: Equatable {
           case hidden, center, top
       }
       
       enum CodingKeys: String, CodingKey {
           case playername, playerimg, value, playerid
       }
   }

//class MlNextQuestionAnsrequestModel: Codable {
//    let qid: String?
//    let attemptid, player1ID, player2ID, answer: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case qid, attemptid
//        case player1ID = "player1id"
//        case player2ID = "player2id"
//        case answer
//    }
//
//    init(qid: String?, attemptid: Int?, player1ID: Int?, player2ID: Int?, answer: Int?) {
//        self.qid = qid
//        self.attemptid = attemptid
//        self.player1ID = player1ID
//        self.player2ID = player2ID
//        self.answer = answer
//    }
//}

struct MlQuestionAnsrequestModel: Codable {
    let quizID: String?
    let attemptid, player1ID, player2ID, answer: Int?
    let timetaken, isskipped, addedtime: Int?

    enum CodingKeys: String, CodingKey {
        case quizID = "quizId"
        case attemptid
        case player1ID = "player1id"
        case player2ID = "player2id"
        case answer, timetaken, isskipped, addedtime
    }
}

// MARK: - Value
struct MLResultScore: Codable {
    let pctl, rank, rightans, totpoints: Int?
    let outofscore: Int?
}
