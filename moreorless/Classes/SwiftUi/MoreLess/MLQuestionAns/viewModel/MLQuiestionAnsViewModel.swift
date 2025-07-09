//
//  MLQuiestionAnsViewModel.swift
//  Alamofire
//
//  Created by Vishal Vijayvargiya on 08/02/24.
//

import Foundation
import Combine
import SwiftUI
import GamesLib
class MLGameViewModel: ObservableObject {
    
    @Published var baseCard: [BaseCard?] = []
    @Published var questionCard: QuestionCard?
    @Published var isHiddenLottie = false
    @Published var streakTotal: Int = 0
    @Published var totalPoints: Int = 0
    @Published var gamedescription: String = ""
    @Published var timeRemaining: Int = 0
    @Published var timerProgress: Double = 0
    @Published var timeUP:Bool =  false
    @Published var isThreeSecondsLeft:Bool =  false
    @Published var currentQuestionIndex: Int = 0
    @Published var gameType:String = ""
    @Published var progress: CGFloat = 0.0
    @Published var bodarrprogress: CGFloat = 0.0
    @Published var lastplayervalue:Int = 0
    @Published var topCornerRadis:Bool = false
    @Published var isCorrectWronfAns:Int? = nil
    @Published  var quizType = 3
    @Published  var appInBackground:Bool = false
    @Published var isQuizCompleted:Bool =  false
    @Published var QuizResultCalucate:QuizResultCalucate? = nil
    @Published var isAnsAttemptClick:Bool =  false
    @Published var MLResultScore: MLResultScore?  = nil
    @Published var showErrorPopup = false
    @Published var error: String = ""
    @Published var totalquestions:Int = 0
    @Published var perquestionpoint:Int = 0
    @Published var isDisable:Bool = false
    @Published var cardSelection:MolCardListData? =  nil
    @Published var timerData: timerData? = nil
    @Published var analyticsDomainName: String = ""
    @Published var analyticsData: TrackingParameters = TrackingParameters([:] as [String: Any?]?)
    
    var GamedayId:Int  = 1
    
    private var current_screen_name = "/quiz-gameplay-"
    var isAnimatinglastplayervalue = false
    var timer: Timer?
    var attempid:Int?
    var quizID = ""
    var timerCount:Int = 0
    var homeModel=HomeLandingViewModel()
    // Simulate receiving the first API response
    func loadQuestionsFromJSON(moreless:Int? = nil) {
        timer?.invalidate()
        if currentQuestionIndex == 0{
            MlGamePlayApi.shared.MlFirstGameApiCall(quizid:quizID) { MlGameData in
                if let  MlGameDatavalue = MlGameData{
                    if !self.timeUP{
                        self.receiveFirstApiResponse(apiResponse: MlGameDatavalue)
                        
                        
                        let (analyticsDomainName, analyticsData) = Track.shared.get_screen_domain_params(screen: self.current_screen_name + (self.cardSelection?.gametype ?? "mol"), params: [:], replace: "\(self.baseCard.count+1)",replace2:(Constants.configData?.quizTypeTrackingKey?["\(self.quizType)"]  as? String ?? ""),quizId:self.quizID, quizTitle: self.cardSelection?.gatitle, gaPageTitle: self.cardSelection?.gaPageTitle)
                        
                        GamingHubCards.registerTrackingDefaults(analyticsData, domain: analyticsDomainName, gameId: MOLTheme.currentGameID ?? "uclmoreorless")
                        
                        self.analyticsDomainName = analyticsDomainName
                        self.analyticsData = analyticsData
                        Track.shared.screen(screen: self.current_screen_name + (self.cardSelection?.gametype ?? "mol"), params: [:], replace: "\(self.baseCard.count+1)",replace2:(Constants.configData?.quizTypeTrackingKey?["\(self.quizType)"]  as? String ?? ""),quizId:self.quizID, quizTitle: self.cardSelection?.gatitle, gaPageTitle: self.cardSelection?.gaPageTitle)
                        Track.shared.trackSponsor(slot: "header", analyticsDomainName: analyticsDomainName, analyticsData: analyticsData)
                        
                        
                        
                        
                    }
                }
            }
            
        }else{
            if !self.isAnsAttemptClick || timeUP{
                MlGamePlayApi.shared.MlNextGameApiCall(player1ID:self.baseCard[safe: currentQuestionIndex-1]??.playerid,player2ID:self.questionCard?.playerid,attemptid: attempid,ans:moreless,qid: "\(String(describing: self.quizID))") { MlGameData in
                    if let  MlGameDatavalue = MlGameData{
                        self.isCorrectWronfAns =  nil
                        self.receiveSecondApiResponse(apiResponse: MlGameDatavalue)
                        
                        
                        let (analyticsDomainName, analyticsData) = Track.shared.get_screen_domain_params(screen: self.current_screen_name + (self.cardSelection?.gametype ?? "mol"), params: [:], replace: "\(self.baseCard.count+1)",replace2:(Constants.configData?.quizTypeTrackingKey?["\(self.quizType)"]  as? String ?? ""),quizId:self.quizID, quizTitle: self.cardSelection?.gatitle, gaPageTitle: self.cardSelection?.gaPageTitle)
                        
                        GamingHubCards.registerTrackingDefaults(analyticsData, domain: analyticsDomainName, gameId: MOLTheme.currentGameID ?? "uclmoreorless")
                        
                        self.analyticsDomainName = analyticsDomainName
                        self.analyticsData = analyticsData
                        
                        Track.shared.trackSponsor(slot: "header", analyticsDomainName: analyticsDomainName, analyticsData: analyticsData)
                    }
                }
            }
            
        }
    
}
    
    func exitapicall(onSuccess: @escaping((Bool) -> ())){
        if currentQuestionIndex == 0{
            MlGamePlayApi.shared.MlNextGameApiCall(player1ID:self.baseCard[safe: currentQuestionIndex]??.playerid,player2ID:self.questionCard?.playerid,attemptid: attempid,ans:-2,qid: "\(String(describing: self.quizID))") { MlGameData in
                if let  MlGameDatavalue = MlGameData{
                    onSuccess(true)
                    
                }else{
                    onSuccess(false)
                }
            }
        }else{
            MlGamePlayApi.shared.MlNextGameApiCall(player1ID:self.baseCard[safe:currentQuestionIndex-1]??.playerid,player2ID:self.questionCard?.playerid,attemptid: attempid,ans:-2,qid: "\(String(describing: self.quizID))") { MlGameData in
                if let  MlGameDatavalue = MlGameData{
                    onSuccess(true)
                }else{
                    onSuccess(false)
                }
            }
        }
    }
    func resultApiCall(){
        if GamingHubCards.isLoggedIn{
            MlGamePlayApi.shared.MlResultApiCall(quizid:self.quizID,attemptid:attempid ?? 0) { scoreResult in
                if let scoredata =  scoreResult{
                    self.MLResultScore =  scoredata
                    self.calculatePercentageDecrease(originalValue: Double(self.MLResultScore?.outofscore ?? 0), newValue: Double(self.MLResultScore?.totpoints ?? 0))
                }
            }
            quizcehckDeepLink(quizid:self.quizID)
        }else{
            QuizzGameSDk.game.store.setGuestData(data: Gameplaydetail(quizid: self.quizID, score: self.totalPoints, gamedate: "".getCurrentDate(), quiztypeid: self.quizType))
            self.MLResultScore = moreorless.MLResultScore(pctl: nil, rank: nil, rightans: self.streakTotal, totpoints: totalPoints, outofscore: (self.totalquestions * self.perquestionpoint))
            self.calculatePercentageDecrease(originalValue: Double(self.totalquestions * self.perquestionpoint), newValue: Double(self.MLResultScore?.totpoints ?? 0))
        }
        self.timerApiCall()
    }
    
    func timerApiCall(){
        MlGamePlayApi.shared.timerScoreCardApi(GamedayId: self.GamedayId,quizID:self.quizID){ timerData in
            if timerData != nil{
                self.timerData = timerData
            }
        }
    }
    
    func quizcehckDeepLink(quizid:String){
        
        homeModel.GameStatustData(quizId:quizid) { detailModel in
            if detailModel != nil{
                
                if (detailModel?.isdisable == 0) {
                    self.isDisable =  true
                }
            }
        }
    }
    func receiveFirstApiResponse(apiResponse: MLQuestionModel) {
        self.baseCard.append(apiResponse.basecard)
        self.questionCard = apiResponse.questioncard
        self.streakTotal = apiResponse.streaktotal ?? 0
        self.totalPoints = apiResponse.totalpoint ?? 0
        self.gamedescription = apiResponse.gamedescription ?? ""
        self.gameType = apiResponse.gametype ?? "-"
        self.attempid = apiResponse.attemptID ?? 0
        self.timerCount = apiResponse.gametimer ?? 15
        self.totalquestions = apiResponse.totalquestions ?? 0
        self.perquestionpoint = apiResponse.perquestionpoint ?? 0
        self.currentQuestionIndex += 1
        self.updateCardPositions()
        
    }
    
    // Simulate receiving the second API response
    func receiveSecondApiResponse(apiResponse: MLQuestionModel) {
        // Assuming you want to replace the base card with the previous question card
        // and update the question card with the new question
        self.currentQuestionIndex += 1
        timer = nil
        self.gameType = apiResponse.gametype ?? "-"
        withAnimation(.linear(duration: 1)) {
            progress =  1
        }
        self.attempid = apiResponse.attemptID ?? 0
        self.streakTotal = apiResponse.streaktotal ?? self.streakTotal
        self.totalPoints = apiResponse.totalpoint ?? self.totalPoints
//        self.isCorrectWronfAns = apiResponse.islastanscorrect ?? 0
        startNumberLoop(apiResponse: apiResponse, finalValue: apiResponse.lastplayervalue ?? 0)
         
        // if correct ans then call
        if ((apiResponse.islastanscorrect ?? 0) != 0 && apiResponse.questioncard != nil) && apiResponse.isAttemptEnds != 1{
            Track.shared.screen(screen: self.current_screen_name + (cardSelection?.gametype ?? "mol"), params: [:], replace: "\(self.baseCard.count+1)",replace2:(Constants.configData?.quizTypeTrackingKey?["\(self.quizType)"]  as? String ?? ""),quizId:self.quizID, quizTitle: cardSelection?.gatitle, gaPageTitle: self.cardSelection?.gaPageTitle)
            DispatchQueue.main.asyncAfter(deadline: .now() + 03) {
                self.progress = 0
                self.bodarrprogress = 0
                withAnimation(.linear(duration: 1)) {
                    self.topCornerRadis = false
                }
                self.baseCard[self.baseCard.count-1]?.isQuestionViewHide = true
                if let lastQuestionCard = self.questionCard {
                    if !self.appInBackground{
                        self.baseCard.append(BaseCard(playername: lastQuestionCard.playername, playerimg: lastQuestionCard.playerimg, value: apiResponse.lastplayervalue,playerid: lastQuestionCard.playerid, position:.center))
                        self.isAnsAttemptClick =  false
                }
                    self.questionCard = apiResponse.questioncard
                    //if self.baseCard.count != 1{
                        
                   // }
                }
                if !self.timeUP{
                    
                    self.updateCardPositions()
                }else{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 03) {
                        self.isQuizCompleted =  true
                        
                    }
                }
            }
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 03) {
                self.isQuizCompleted =  true
            }
            
        }
    }
    //
    func startNumberLoop(apiResponse:MLQuestionModel,finalValue: Int, interval: TimeInterval = 0.03) {
            // Reset the number to 0 before starting the loop
            lastplayervalue = 0
            
            // Use a Timer to change the number at each interval
            Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
                // Update the number
                if self.lastplayervalue < finalValue {
                    self.lastplayervalue += 1
                } else {
                    // Invalidate the timer if the final value is reached
                    timer.invalidate()
                    self.isCorrectWronfAns = apiResponse.islastanscorrect
                        withAnimation(.linear(duration: 1)) {
                            
                            self.bodarrprogress =  1
                           
                        }
                        
                    
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self.lastplayervalue = finalValue
                self.isCorrectWronfAns = apiResponse.islastanscorrect
                    withAnimation(.linear(duration: 1)) {
                        
                        self.bodarrprogress =  1
                        
                    }
                    
                
            }
        
        }
    func updateCardPositions() {
        
        if  (self.baseCard.count > 1) && !appInBackground{
            if self.baseCard[self.baseCard.count-2]?.position == .top{
                self.updateCard()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.easeInOut(duration: 1)) {
                        
                        self.baseCard[self.baseCard.count-2]?.position = .secondTop
                       
                        
                    }
                }
            }else{
                self.updateCard()
            }
        }else{
            self.updateCard()
        }
        
    }
    
  func  updateCard(){
      withAnimation(.easeInOut(duration: 0.5)) {
           //if baseCard.count == self.currentQuestionIndex{
          self.baseCard[self.baseCard.count-1]?.isQuestionViewHide = true
          if self.baseCard.count == 1{
              baseCard[self.baseCard.count-1]?.position = .center
          }
          DispatchQueue.main.asyncAfter(deadline: .now() + 01) {
              //self.secondCardHide =  true
              self.baseCard[self.baseCard.count-1]?.isQuestionViewHide = false
              withAnimation(.easeInOut(duration: 1)) {
                  self.baseCard[self.baseCard.count-1]?.position = .top
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                      withAnimation(.easeInOut(duration: 0.5)) {
                          self.topCornerRadis = true
                      }
                  }
                  self.timeUP =  false
                  self.startTimer()
              }
          }
      }
  }
}
//StartTime staff
extension MLGameViewModel{
    // timer start
    func startTimer() {
        
        self.timeRemaining =  self.timerCount
        timer?.invalidate()
        
        self.timerProgress = 0
        self.isThreeSecondsLeft =  false
        self.timerProgress = Double(self.timeRemaining) / Double(self.timerCount)
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.timeRemaining >= 1 {
                
                self.timeRemaining -= 1
                self.isThreeSecondsLeft = self.timeRemaining <= 3
                self.timerProgress = Double(self.timeRemaining) / Double(self.timerCount)
            } else {
//                self.currentQuestionIndex += 1
                self.loadQuestionsFromJSON(moreless:-1)
                self.timeUP =  true
                self.isAnsAttemptClick =  true
                timer.invalidate()
                
             
            }
        }
    }
}


//MARK: Quiz - score card

extension MLGameViewModel{
    func calculatePercentageDecrease(originalValue: Double, newValue: Double) {
//        let decrease = originalValue - newValue
//        if newValue != 0 && originalValue != 0{
//            let percentageDecrease = (newValue / originalValue) * 100
        QuizResultCalucate = getQuizResult(forScore: Int(self.MLResultScore?.rightans ?? 0) )
//        }else{
//            QuizResultCalucate = getQuizResult(forScore:  0)
//        }
       
    }
    
    
    func getQuizResult(forScore score: Int) -> QuizResultCalucate? {
        let results: [QuizResultCalucate] = Constants.configData?.resultMessagesattemptMOl ?? []
        
        for result in results {
            if score >= result.minScore && score <= result.maxScore {
                return result
            }
        }
        
        return nil
    }
}


extension MLGameViewModel{
    func handleNotification(_ notification: Notification) {
        
        DispatchQueue.main.async {
            
           // self.isFromBackGround = true
            self.showInternetStatus()
        }
        
    }
    
    func showInternetStatus() {
        DispatchQueue.main.async {
            if case .reachable( _) =  NetworkWrapper.shared.networkReachabilityStatus {
                    self.showErrorPopup = false
                    self.error = "internet_connection_back_message".getTranslationValue(default: AppStrings.INTERNET_AVAILABLE)
                DispatchQueue.main.async { [weak self] in
                        
                        guard let dt = self else {
                            return
                        }
                        
                        if dt.timeUP{
                            dt.showErrorPopup = false
                            dt.error = ""
                           // dt.currentQuestionIndex += 1
                            dt.loadQuestionsFromJSON()
                        }
  
                    }
                
            } else if .notReachable == NetworkWrapper.shared.networkReachabilityStatus {
                self.showErrorPopup = true
                self.error = "no_internet_connection_message".getTranslationValue(default: AppStrings.NO_INTERNET)
            } else if .unknown == NetworkWrapper.shared.networkReachabilityStatus {
                self.showErrorPopup = false
               // self.error = "internet_connection_back_message".getTranslationValue(default: AppStrings.INTERNET_AVAILABLE)
                DispatchQueue.main.async { [weak self] in
                    guard let dt = self else {
                        return
                    }
                    
                    dt.showErrorPopup = false
                    dt.error = ""
                    
                }
            }
        }
    }
}
