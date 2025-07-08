//
//  QuizViewModel.swift
//  Pods
//
//  Created by Vishal Vijayvargiya on 01/09/23.
//

import Combine
import SwiftUI
import GamesLib
import Kingfisher
class QuizViewModel: ObservableObject {
    
    @Published var SkipCountTimmer:Bool = false
    @Published var isHiddenLottie = false
    @Published var countdown: Int = 3
    @Published var countDownDifficalty: Int = 3
    @Published var questions: QuizQuestionModel? =  nil
    @Published var currentQuestionIndex: Int = 0
    @Published var isUserAnswerCorrect: Bool? =  nil
    @Published var selectedAnswer: String? = nil
    @Published var timeRemaining: Int = 0
    @Published var timerProgress: Double = 0
    @Published var isQuizCompleted: Bool = false
    @Published var fiftyFiftyEnabled: Bool = false
    @Published var sneakPeakEnabled: Bool = false
    @Published var nextQuestionData: QuizQuestionModel? = nil
    @Published var disabledOptionsFiftyFifty: Set<String> = []
    @Published var timeUP:Bool =  false
    @Published var userIsSelected:Bool = false
    @Published var questionansCorrect:[QuestionAnsCheckModel] = []
    @Published var isThreeSecondsLeft:Bool =  false
    @Published var FirstTimeEnter:Bool = true
    @Published var QuizResultCalucate:QuizResultCalucate? = nil
    @Published var scoreCardData:scoreCardData? =  nil
    @Published var GameAttemptConfigData :GameAttemptConfigData? = nil
    @Published var isUsedfityfifty:Bool = false
    @Published var BosterButtonActive:Bool = false
    @Published var isUsedVRA:Bool =  false
    @Published var StreakResult:[Bool] = []
    @Published var StreakResultImage:[Bool] = []
    @Published var StreakResultScore:[Bool] = []
    @Published var StreakResultImageScore:[Bool] = []
    @Published var StreakActive:Bool =  false
    @Published var StreakPoint:Int = 0
    @Published  var quizType = 0
    @Published var showErrorPopup = false
    @Published var error: String = ""
    @Published var tempSelectedAnswer: String? = nil
    @Published var isFromBackGround: Bool = false
    @Published var isDissabpper:Bool  =  false
    @Published var showShareView:Bool = false
    @Published var cardSelection:QuizCardListData? =  nil
    @Published var timerData: timerData? = nil
    @Published var isButtonActive: Bool = false
    @Published var trackEvent: Bool? = false
    @Published var showLoader: Bool = true
    @Published var quizExit: Bool = false
    var homeModel=HomeLandingViewModel()
    var timervalue:Int = 0
    var quizID = ""
    var lastQuestionAns:String? = nil
    var incorrectOptions:[String] =  []
    var totalPoint:Int = 0
    var timer: Timer?
    var CounterTimer: Timer?
    var showCorrectAns:Bool =  false
    var jsonIndex:Int = 0
    var TotalPointQestion:Int = 0
    var VRAAttemptCount:Int = 0
    var VRACorrect:Int = 0
    var GamedayId:Int  = 1
    var pendAtmptid:Int = 0
    var difficultyLevel: Int?
    @Published var gameLoadVar : QuizUserDetailModel? = nil
    private var current_screen_name = "/quiz-gameplay-"
    @Published var analyticsDomainName: String = ""
    @Published var analyticsData: TrackingParameters = TrackingParameters([:] as [String: Any?]?)
    
    init() {
    
    }
    
    var currentQuestionData : QuizQuestionModel?{
        return questions//.[currentQuestionIndex]
    }
    
    var currentQuestion: String {
        return questions?.quDES ?? ""
    }
    
    var currentOptions: [OptionNode] {
        return questions?.optionNode ?? []
    }
    
    var canMoveToNextQuestion: Bool {
        return currentQuestionIndex < GameAttemptConfigData?.gameQuecount ?? 0
    }
    

    
//    var viewForOption: (OptionNode) -> some View {
//        return { [self] optionNode in
//            if self.selectedAnswer == optionNode.option {
//                if let isuserSelectedAns =  self.isUserAnswerCorrect{
//                    if isuserSelectedAns {
//                        return AnsView(mediaType: MediaViewType(rawValue: currentQuestionData?.mediaViewType ?? ""), mediaFormat: MediaType(rawValue: currentQuestionData?.quMediaType ?? ""), Ans: ( (optionNode.value ?? "")),isCorrectNot: true)
////                            .multilineTextAlignment(.center)
//                            .background(RoundedRectangle(cornerRadius: 14).foregroundColor(QUIZTheme.getColor(named: .QSDK_32A72C)))
//                    } else {
//                        return AnsView(mediaType: MediaViewType(rawValue: currentQuestionData?.mediaViewType ?? ""), mediaFormat: MediaType(rawValue: currentQuestionData?.quMediaType ?? ""),Ans: ( (optionNode.value ?? "")),isCorrectNot: false)
////                            .multilineTextAlignment(.center)
//                            .background(RoundedRectangle(cornerRadius: 14).foregroundColor(QUIZTheme.getColor(named: .QSDK_CB333B)))
//                    }
//                }else{
//                    return AnsView(mediaType: MediaViewType(rawValue: currentQuestionData?.mediaViewType ?? ""), mediaFormat: MediaType(rawValue: currentQuestionData?.quMediaType ?? ""),Ans: ( (optionNode.value ?? "")))
////                        .multilineTextAlignment(.center)
//                        
//                        .background(RoundedRectangle(cornerRadius: 14).foregroundColor(QUIZTheme.getColor(named: .QSDK_0A0A61)))
//                }
//            } else if isAnswerCorrect(userAnswer: optionNode.option ?? "") {
//                return (showCorrectAns ? AnsView(mediaType: MediaViewType(rawValue: currentQuestionData?.mediaViewType ?? ""), mediaFormat: MediaType(rawValue: currentQuestionData?.quMediaType ?? ""),Ans: ( (optionNode.value ?? "")))
////                        .multilineTextAlignment(.center)
//        
//                        .background(RoundedRectangle(cornerRadius: 14).foregroundColor(QUIZTheme.getColor(named: .QSDK_32A72C)))
//                        : AnsView(mediaType: MediaViewType(rawValue: currentQuestionData?.mediaViewType ?? ""), mediaFormat: MediaType(rawValue: currentQuestionData?.quMediaType ?? ""),Ans: ( (optionNode.value ?? "") ))
////                        .multilineTextAlignment(.center)
//                        
//                        .background(RoundedRectangle(cornerRadius: 14).foregroundColor(QUIZTheme.getColor(named: .QSDK_0A0A61)))
//                )
//            } else if disabledOptionsFiftyFifty.contains(optionNode.option ?? "") {
//                return AnsView(mediaType: MediaViewType(rawValue: currentQuestionData?.mediaViewType ?? ""), mediaFormat: MediaType(rawValue: currentQuestionData?.quMediaType ?? ""),Ans: ( (optionNode.value ?? "")),opacity: 0.5)
////                    .multilineTextAlignment(.center)
//                   
//                    
//                    .background(RoundedRectangle(cornerRadius: 14).foregroundColor(QUIZTheme.getColor(named: .QSDK_0A0A61).opacity(0.5)))
//            } else {
//                return AnsView(mediaType: MediaViewType(rawValue: currentQuestionData?.mediaViewType ?? ""), mediaFormat: MediaType(rawValue: currentQuestionData?.quMediaType ?? ""),Ans: ( (optionNode.value ?? "")))
////                    .multilineTextAlignment(.center)
//                    
//                    .background(RoundedRectangle(cornerRadius: 14).foregroundColor(QUIZTheme.getColor(named: .QSDK_0A0A61)))
//            }
//        }
//    }
    

    func reset(){
        self.showLoader = true
         SkipCountTimmer = false
         countdown = 3
         questions =  nil
         currentQuestionIndex = 0
         isUserAnswerCorrect =  nil
         selectedAnswer = nil
         timeRemaining = 0
         timerProgress = 0
         isQuizCompleted = false
         fiftyFiftyEnabled = false
         sneakPeakEnabled = false
         nextQuestionData = nil
         disabledOptionsFiftyFifty = []
         timeUP  =  false
         userIsSelected  = false
         questionansCorrect = []
         isThreeSecondsLeft =  false
         FirstTimeEnter = true
         QuizResultCalucate = nil
         scoreCardData =  nil
         GameAttemptConfigData  = nil
         isUsedfityfifty = false
         isUsedVRA =  false
         StreakResult = []
         StreakResultImage = []
         VRAAttemptCount =  0 
         StreakActive =  false
         StreakPoint = 0
        self.BosterButtonActive = false
    }
    

    // timer start
    func startTimer() {
        let currentQuestion = currentQuestionData
        self.timeRemaining =  self.timervalue
        timer?.invalidate()
        self.currentQuestionIndex =  self.jsonIndex
        self.quizExit = true
        self.timerProgress = 0
        self.isThreeSecondsLeft =  false
        self.timerProgress = Double(self.timeRemaining) / Double(self.timervalue)
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.timeRemaining >= 1 {
                
                self.timeRemaining -= 1
                self.isThreeSecondsLeft = self.timeRemaining <= 3
                self.timerProgress = Double(self.timeRemaining) / Double(self.timervalue)
            } else {
                self.timeUP =  true
                timer.invalidate()
                
           
                if  !NetworkWrapper.isInternerConnected(){
                    self.showErrorPopup = true
                    
//                    if self.timeUP {
//                        self.error = "internet_connection_back_message".getTranslationValue(default: AppStrings.INTERNET_AVAILABLE)
//                    } else {
                        self.error = "no_internet_connection_message".getTranslationValue(default: AppStrings.NO_INTERNET)
//                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if self.nextQuestionData?.quID != nil {
                        if  NetworkWrapper.isInternerConnected(){
                            self.nextQuizApiCall(selectedAns: nil)
                            // here to add correct not correct is user not select the ans
                            self.questionansCorrect.append(QuestionAnsCheckModel(totalQuestion: currentQuestion?.quTotCnt,currentIndex: self.jsonIndex, isCorrectAns: self.isUserAnswerCorrect ?? false, TotalPoint: self.totalPoint))
                            self.jsonIndex += 1
                            if self.tempSelectedAnswer == "E" {
                                self.currentQuestionIndex = self.jsonIndex
                            }
                            
                            
                        }
                    }else{
                        self.isQuizCompleted =  true
                        self.ScoreCardApiCall()
                    }
                    
                }
                
                
            }
        }
    }
    
    func handleNotification(_ notification: Notification) {
        
        DispatchQueue.main.async {
            self.showErrorPopup = false
            self.error = ""
           // self.isFromBackGround = true
            self.showInternetStatus()
        }
        
    }
    
    func showInternetStatus() {
        DispatchQueue.main.async {
            if case .reachable( _) =  NetworkWrapper.shared.networkReachabilityStatus {
                    self.showErrorPopup = true
                    self.error = "internet_connection_back_message".getTranslationValue(default: AppStrings.INTERNET_AVAILABLE)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                        
                        guard let dt = self else {
                            return
                        }
                        
                        if dt.timeRemaining != 0 && !dt.timeUP{
                            dt.showErrorPopup = false
                            dt.error = ""
                        }

                    }
                
            } else if .notReachable == NetworkWrapper.shared.networkReachabilityStatus {
                self.showErrorPopup = true
                self.error = "no_internet_connection_message".getTranslationValue(default: AppStrings.NO_INTERNET)
            } else if .unknown == NetworkWrapper.shared.networkReachabilityStatus {
                self.showErrorPopup = true
                self.error = "internet_connection_back_message".getTranslationValue(default: AppStrings.INTERNET_AVAILABLE)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                    guard let dt = self else {
                        return
                    }
                    
                    dt.showErrorPopup = false
                    dt.error = ""
                    if dt.isFromBackGround {
                        if !dt.isQuizCompleted{
                            //dt.selectAnswer("E")
                        }
                    }
                }
            }else {
                self.showErrorPopup = true
                    self.error = "no_internet_connection_message".getTranslationValue(default: AppStrings.NO_INTERNET)
            }
        }
    }
    
    // stop timer
    func stopTimer(index:Int?){
        self.currentQuestionIndex = index ?? 0
        timer?.invalidate()
        timer = nil
    }
    
    // Function to check if the user's answer is correct
    func isAnswerCorrect(userAnswer: String) -> Bool {
        return userAnswer == lastQuestionAns
    }
    
    // Function to submit the user's answer for the current question
    func selectAnswer(_ answer: String) {
        if self.tempSelectedAnswer == nil{
            self.userIsSelected =  true
            self.FirstTimeEnter =  false
            self.tempSelectedAnswer = answer
            if !sneakPeakEnabled{
            if self.nextQuestionData?.quID != nil {
                if  NetworkWrapper.isInternerConnected(){
                    self.jsonIndex += 1
                    if self.tempSelectedAnswer == "E" {
                        self.currentQuestionIndex = self.jsonIndex
                        self.stopCountdown()
                    }
                }
            }else {
                self.isQuizCompleted = true
                self.ScoreCardApiCall()
            }
            self.nextQuizApiCall(selectedAns: answer)
        }else{
            
            self.VRAAttemptCount += 1
            self.vraTestAPI(selectedAns: answer)
        }
    }
    }
    
    
    func prefetchNextQuestionImages(urls: [String?]) {
            urls.forEach { urlString in
                guard let url = URL(string: urlString ?? "") else { return }
                ImageCache.default.retrieveImage(forKey: urlString ?? "") { result in
                    switch result {
                    case .success(let cacheResult):
                        if cacheResult.image == nil {
                            // Download and cache image
                            KingfisherManager.shared.downloader.downloadImage(with: url) { result in
                                switch result {
                                case .success(let imageResult):
                                    ImageCache.default.store(imageResult.image, forKey: urlString ?? "")
                                case .failure(let error):
                                    print("Error caching image: \(error.localizedDescription)")
                                }
                            }
                        }
                    case .failure(let error):
                        print("Error retrieving image from cache: \(error.localizedDescription)")
                    }
                }
            }
        }
    
    // Function to update the current question and answer
    func updateCurrentQuestion(selectedAns:String?,question: QuizQuestionModel?) {
        disabledOptionsFiftyFifty.removeAll()
        self.nextQuestionData =  question
        self.questions?.lastQuAnsOpt = question?.lastQuAnsOpt ?? ""
        self.lastQuestionAns = question?.lastQuAnsOpt ?? ""
        let correctAnswer = nextQuestionData?.lastQuAnsOpt ?? ""
        // here to add correct not correct is user select ans
        if selectedAns != nil{
            isUserAnswerCorrect = 1 == nextQuestionData?.lastUserAnsFlag ?? 0
            self.selectedAnswer =  selectedAns
            questionansCorrect.append(QuestionAnsCheckModel(totalQuestion: question?.quTotCnt,currentIndex: self.currentQuestionIndex, isCorrectAns: isUserAnswerCorrect ?? false, TotalPoint: self.totalPoint))
            self.timer?.invalidate()
            self.userIsSelected =  true
        }
        
        if (isUserAnswerCorrect ?? false){
            
            self.totalPoint += (GameAttemptConfigData?.QuPoint ?? 0)
        }
        self.TotalPointQestion += GameAttemptConfigData?.QuPoint ?? 0
        
        // check first time enter in game
        if FirstTimeEnter{
            self.questions =  self.nextQuestionData
            self.selectedAnswer = nil
            self.isUserAnswerCorrect = false
            self.lastQuestionAns =  nil
            self.timer?.invalidate()
            if self.SkipCountTimmer{
                self.startTimer()
            }
            
            if self.canMoveToNextQuestion {
                
            } else {
                self.isQuizCompleted = true
                self.ScoreCardApiCall()
            }
            self.FirstTimeEnter =  false
            self.timeUP =  false
            self.userIsSelected =  false
            self.tempSelectedAnswer  =  nil
        }else{
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                self.questions =  self.nextQuestionData
                self.selectedAnswer = nil
                self.isUserAnswerCorrect = false
                self.lastQuestionAns =  nil
                self.timer?.invalidate()
                if self.SkipCountTimmer{
                    self.startTimer()
                }
                
                if self.canMoveToNextQuestion {
                    
                } else {
                    self.isQuizCompleted = true
                    self.ScoreCardApiCall()
                }
                self.timeUP =  false
                self.StreakActive =  false
                self.userIsSelected =  false
                self.tempSelectedAnswer  =  nil
            }
        }
        
        
        if self.fiftyFiftyEnabled{
            BosterButtonActive =  false
            self.isUsedfityfifty =  true
            self.fiftyFiftyEnabled =  false
        }
        
        if self.sneakPeakEnabled{
            BosterButtonActive =  false
            self.isUsedVRA =  true
            self.sneakPeakEnabled =  false
        }
        
       
    }
    
    // fifty fifty on
    func useFiftyFifty(option1:String,option2:String) {
        fiftyFiftyEnabled = true
        // Disable two random incorrect options
        incorrectOptions = [option1,option2]//currentOptions.filter { !isAnswerCorrect(userAnswer: $0.option) }
        let randomOptionsToDisable = incorrectOptions.shuffled().prefix(2)
        for optionNode in randomOptionsToDisable {
            disabledOptionsFiftyFifty.insert(optionNode)
        }
    }
    func VarSneakPeek(){
        sneakPeakEnabled = true
    }
    
    func vraTestAPI(selectedAns:String?){
        if self.VRAAttemptCount != 2{
            
            self.VarSneakApiCall(OptType: 2,selectedAns: selectedAns)
        }else{
            self.VarSneakApiCall(OptType: 2,selectedAns: selectedAns)
            
        }
    }
    
}
//MARK: Quiz - Countdown 3

extension QuizViewModel {
    
//    func startCountdown() {
//        countdown = (cardSelection?.isDifficultyApplied ?? false ? cardSelection?.difficultyTimer : 3) ?? 3
//        CounterTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
//            if self.countdown > 1 {
//                self.countdown -= 1
//            }else{
//                self.stopCountdown()
//            }
//        }
//    }
    
    
    
    
    func stopCountdown() {
        CounterTimer?.invalidate()
        CounterTimer =  nil
        SkipCountTimmer = true
        countdown = 0
        countDownDifficalty = 0
        if GamingHubCards.isLoggedIn{
            self.gameLoad(detailModel: self.gameLoadVar)
        }
        startTimer()
    }
    
    func skipCountdown() {
        stopCountdown()
        SkipCountTimmer = true
        countdown = 0
        startTimer()
    }
}

//MARK: Quiz - score card

extension QuizViewModel{
    func calculatePercentageDecrease(originalValue: Double, newValue: Double) {
        let decrease = originalValue - newValue
        if newValue != 0 && originalValue != 0{
            let percentageDecrease = (newValue / originalValue) * 100
            QuizResultCalucate = getQuizResult(forScore: Int(ceil(percentageDecrease)) )
        }else{
            QuizResultCalucate = getQuizResult(forScore:  0)
        }
       
    }
    
    
    func getQuizResult(forScore score: Int) -> QuizResultCalucate? {
        let results: [QuizResultCalucate] = Constants.configData?.resultMessages ?? []
        
        for result in results {
            if score >= result.minScore && score <= result.maxScore {
                return result
            }
        }
        
        return nil
    }
}

// MARK: API CALL FUNCTION
extension QuizViewModel{
    
    //MARK: Api call first question
    
    func firstQuestionApiCall(quizID:String){
        self.quizID = quizID
        QuizzQuetionAnsApi.shared.getGameConfigData(quizID:quizID) { gameConfigdata in
           if gameConfigdata != nil{
               print(gameConfigdata)
               self.GameAttemptConfigData =  gameConfigdata
               self.timervalue = gameConfigdata?.maxQuetime ?? 0
               if !GamingHubCards.isLoggedIn{
                   UserDefaults.standard.set(self.quizID, forKey: self.quizID)
               }
               self.quizType = gameConfigdata?.quiztypeid ?? 0
               QuizzQuetionAnsApi.shared.getQuetionDetailApi(quizID: self.quizID) { detailModel in
                   if detailModel != nil{
                       self.gameLoadVar = detailModel
                       self.GamedayId = detailModel?.gamedayID ?? 1
                       self.pendAtmptid = detailModel?.pendAtmptid ?? 0
                       self.homeModel.SettlementData(quizId: self.quizID, attempt: detailModel?.pendAtmptid, GamedayId: self.GamedayId, isExit: 0){ staus in
                           
                       }
                       if self.cardSelection?.isDifficultyApplied ?? false{
                           self.difficultyLevel = 2
                       }else{
                           self.difficultyLevel = nil
                           self.gameLoad(detailModel: detailModel)
                       }
                       
                   }
               }
           }
        }
    }
    
    func gameLoad(detailModel: QuizUserDetailModel?){
        if (detailModel?.userDetails?.last?.resumeFlag ?? 0)  == 1{
       
       
//       DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
           QuizzQuetionAnsApi.shared.getQuetionStartApi(GamedayId: self.GamedayId, quizID: self.quizID, attemptNo: "\((detailModel?.AtmptNo ?? 0)+1)",gamdayid: detailModel?.gamedayID ?? 0,CategoryID: detailModel?.categoryID ?? 0,SportID: detailModel?.sportID ?? 0, isMediaQuiz: self.cardSelection?.isMediaQuiz, difficultyLevel: self.difficultyLevel) {questionData in
               self.showLoader = false
               if questionData != nil{
                   if questionData?.quMediaType == nil && questionData?.mediaViewType == nil{
                       self.isButtonActive = true
                   }
                   self.updateCurrentQuestion(selectedAns: nil, question: questionData)
                   if Constants.configData?.isImagePreLoading ?? false{
                       let nextUrls = self.currentQuestionData?.questionMediaUrls ?? []
                       self.prefetchNextQuestionImages(urls: nextUrls)
                   }
                   let (analyticsDomainName, analyticsData) = Track.shared.get_screen_domain_params(screen: self.current_screen_name + (self.cardSelection?.gametype ?? "quiz"), params: [:], replace: "1",replace2:(Constants.configData?.quizTypeTrackingKey?["\(self.GameAttemptConfigData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId:self.quizID, quizTitle: self.cardSelection?.gatitle, gaPageTitle: self.cardSelection?.gaPageTitle)
                   
                   GamingHubCards.registerTrackingDefaults(analyticsData, domain: analyticsDomainName, gameId: QUIZTheme.currentGameID ?? "uclquiz")
                   
                   self.analyticsDomainName = analyticsDomainName
                   self.analyticsData = analyticsData 
                   
                   Track.shared.screen(screen: self.current_screen_name + (self.cardSelection?.gametype ?? "quiz"), params: [:], replace: "1",replace2:(Constants.configData?.quizTypeTrackingKey?["\(self.GameAttemptConfigData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId:self.quizID, quizTitle: self.cardSelection?.gatitle, gaPageTitle: self.cardSelection?.gaPageTitle)
                   Track.shared.trackSponsor(slot: "header", analyticsDomainName: analyticsDomainName, analyticsData: analyticsData)
               }
           }
//       }
   }else{
       self.homeModel.SettlementData(quizId: self.quizID, attempt: self.pendAtmptid, GamedayId: self.GamedayId, isExit: 0){ staus in
           
       }
       QuizzQuetionAnsApi.shared.getQuetionStartApi(GamedayId: self.GamedayId, quizID: self.quizID, attemptNo: "\((detailModel?.AtmptNo ?? 0)+1)",gamdayid: detailModel?.gamedayID ?? 0,CategoryID: detailModel?.categoryID ?? 0,SportID: detailModel?.sportID ?? 0, isMediaQuiz: self.cardSelection?.isMediaQuiz, difficultyLevel: self.difficultyLevel) {questionData in
           self.showLoader = false
           if questionData != nil{
               if questionData?.quMediaType == nil && questionData?.mediaViewType == nil{
                   self.isButtonActive = true
               }
               self.updateCurrentQuestion(selectedAns: nil, question: questionData)
               if Constants.configData?.isImagePreLoading ?? false{
                   let nextUrls = self.currentQuestionData?.questionMediaUrls ?? []
                   self.prefetchNextQuestionImages(urls: nextUrls)
               }
               
               let (analyticsDomainName, analyticsData) = Track.shared.get_screen_domain_params(screen: self.current_screen_name + "\(self.cardSelection?.gametype ?? "quiz")", params: [:], replace: "1",replace2:(Constants.configData?.quizTypeTrackingKey?["\(self.GameAttemptConfigData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId:self.quizID, quizTitle: self.cardSelection?.gatitle, gaPageTitle: self.cardSelection?.gaPageTitle)
               
               GamingHubCards.registerTrackingDefaults(analyticsData, domain: analyticsDomainName, gameId: QUIZTheme.currentGameID ?? "uclquiz")
               
               self.analyticsDomainName = analyticsDomainName
               self.analyticsData = analyticsData
               
               Track.shared.screen(screen: self.current_screen_name + "\(self.cardSelection?.gametype ?? "quiz")", params: [:], replace: "1",replace2:(Constants.configData?.quizTypeTrackingKey?["\(self.GameAttemptConfigData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId:self.quizID, quizTitle: self.cardSelection?.gatitle, gaPageTitle: self.cardSelection?.gaPageTitle)
               Track.shared.trackSponsor(slot: "header", analyticsDomainName: analyticsDomainName, analyticsData: analyticsData)
           }
       }
       
   }
}
    
    //MARK: Api call next question
    func nextQuizApiCall(selectedAns:String?){
        self.isFromBackGround = false
        if NetworkWrapper.isInternerConnected() {
            if self.showErrorPopup {
                self.showErrorPopup = false
                self.error = ""
            }
        }
        QuizzQuetionAnsApi.shared.getNextQuestionStartApi(GamedayId: self.GamedayId, quizID: self.quizID, QstMId:nextQuestionData?.quID , SltdAnsOpt: selectedAns ?? "E", QuAttemptId: nextQuestionData?.quAttemptID, AtmptStatus: self.jsonIndex >= (GameAttemptConfigData?.gameQuecount ?? 0) ? 1 : 0, isMediaQuiz: self.cardSelection?.isMediaQuiz) { questionAnsData in
            
            if questionAnsData != nil{
                if  self.jsonIndex < (self.GameAttemptConfigData?.gameQuecount ?? 0){
                    
                    let (analyticsDomainName, analyticsData) = Track.shared.get_screen_domain_params(screen: self.current_screen_name + "\(self.cardSelection?.gametype ?? "quiz")", params: [:], replace: String(questionAnsData?.quNo ?? .zero),replace2:(Constants.configData?.quizTypeTrackingKey?["\(self.GameAttemptConfigData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId:self.quizID, quizTitle: self.cardSelection?.gatitle, gaPageTitle: self.cardSelection?.gaPageTitle)
                    
                    GamingHubCards.registerTrackingDefaults(analyticsData, domain: analyticsDomainName, gameId: QUIZTheme.currentGameID ?? "uclquiz")
                    
                    self.analyticsDomainName = analyticsDomainName
                    self.analyticsData = analyticsData
                    
                    Track.shared.screen(screen: self.current_screen_name + "\(self.cardSelection?.gametype ?? "quiz")", params: [:], replace: String(questionAnsData?.quNo ?? .zero),replace2:(Constants.configData?.quizTypeTrackingKey?["\(self.GameAttemptConfigData?.quiztypeid ?? 0)"]  as? String ?? ""),quizId:self.quizID, quizTitle: self.cardSelection?.gatitle, gaPageTitle: self.cardSelection?.gaPageTitle)
                    Track.shared.trackSponsor(slot: "header", analyticsDomainName: analyticsDomainName, analyticsData: analyticsData)
            }
                let valuecheck  = self.checkConsecutiveOnes(array: (questionAnsData?.arrIscorrect ?? []))
                self.StreakResultImage = self.replaceTwoBeforeTrue(with: valuecheck)
                self.StreakResult = self.StreakBreak(array: self.StreakResultImage)
                
                let streak1 = (questionAnsData?.lastStreakAct ?? 0)
                let streak2 = (questionAnsData?.lastStreak2Act ?? 0)
                self.StreakActive = (streak1 != 0) //|| (streak2 != 0)
                self.StreakPoint = (streak1 != 0) ? (questionAnsData?.streakBonusPoints ?? 0) : ((streak2 != 0) ? (questionAnsData?.streak2BonusPoint ?? 0) : 0)
               
                self.updateCurrentQuestion(selectedAns: selectedAns, question: questionAnsData)
            }else{
                if self.nextQuestionData?.quID == nil {
                    self.isQuizCompleted = true
                    self.ScoreCardApiCall()
                    //  check condition for last question then end game
                }
            }
        }
    }
    
    //MARK: Api call Score Card
    
    func ScoreCardApiCall(){
        QuizzGameSDk.game.store.setGuestData(data: Gameplaydetail(quizid: self.quizID, score: self.totalPoint, gamedate: "".getCurrentDate(), quiztypeid: self.GameAttemptConfigData?.quiztypeid))
        QuizzQuetionAnsApi.shared.QuizScoreData(GamedayId: self.GamedayId, quizID: self.quizID, attemptNo: nextQuestionData?.quAttemptID ?? 0) { ScoreData in
            if ScoreData != nil{
                self.scoreCardData = ScoreData
                self.calculatePercentageDecrease(originalValue: Double(self.scoreCardData?.outofscore ?? 0), newValue: GamingHubCards.isLoggedIn ? Double(self.scoreCardData?.totPoints ?? 0) : Double(self.totalPoint))
                self.homeModel.getQuizStatuslApi(quizID: self.quizID)
                let valuecheck  = self.checkConsecutiveOnes(array: (self.scoreCardData?.arrQtnCorrect ?? []))
                self.StreakResultImageScore = self.replaceTwoBeforeTrue(with: valuecheck)
                self.timerApiCall()
                self.StreakResultScore = self.StreakBreak(array: self.StreakResultImage)
            }else{
               
            }
           // self.quizcehckDeepLink(quizid:self.quizID)
        }
    }
    
    func timerApiCall(){
        QuizzQuetionAnsApi.shared.timerScoreCardApi(GamedayId:self.GamedayId,quizID:self.quizID){ timerData in
            if timerData != nil{ 
                self.timerData = timerData
            }
        }
    }

    
    func FifityfitiyApiCall(){
        QuizzQuetionAnsApi.shared.FiftyFiftyData(GamedayId: self.GamedayId, quizID: self.quizID, QstMId: questions?.quID, QuAttemptId: questions?.quAttemptID, isMediaQuiz: self.cardSelection?.isMediaQuiz) { Status, FiftyFiftyValue in
            if Status{
                self.useFiftyFifty(option1: FiftyFiftyValue?.inCorrectOpt1 ?? "", option2: FiftyFiftyValue?.inCorrectOpt2 ?? "")
            }
        }
    }
    
    func VarSneakApiCall(OptType:Int,selectedAns:String?){
        QuizzQuetionAnsApi.shared.VarSneakPeakData(GamedayId: self.GamedayId, selectedAns: selectedAns ?? "", quizID: self.quizID, QstMId: questions?.quID, QuAttemptId: questions?.quAttemptID,OptType: OptType, isMediaQuiz: self.cardSelection?.isMediaQuiz) { Status, vradata in
            if Status{
                self.BosterButtonActive =  false
                if self.VRAAttemptCount == 1{
                    if vradata?.isSuccessful == 1{
                        self.sneakPeakEnabled = false
                       // self.userIsSelected =  false
                        if self.nextQuestionData?.quID != nil {
                            if  NetworkWrapper.isInternerConnected(){
                                self.jsonIndex += 1
                            }
                        }else {
                            self.isQuizCompleted = true
                            self.ScoreCardApiCall()
                        }
                        self.isUsedVRA =  true
                        self.nextQuizApiCall(selectedAns: selectedAns)
                    }else{
                        self.userIsSelected =  false
                        self.isUserAnswerCorrect = false//(selectedAns) == "A"
                        self.selectedAnswer =  selectedAns
                        self.tempSelectedAnswer = nil
                    }
                }else{
                    if self.selectedAnswer == selectedAns{
                        self.userIsSelected =  false
                        self.tempSelectedAnswer = nil
                    }else{
                        
                    self.userIsSelected =  true
                    self.sneakPeakEnabled = false
                    self.isUsedVRA =  true
                    if self.nextQuestionData?.quID != nil {
                        if  NetworkWrapper.isInternerConnected(){
                            self.jsonIndex += 1
                        }
                    }else {
                        self.isQuizCompleted = true
                        self.ScoreCardApiCall()
                    }
                    self.nextQuizApiCall(selectedAns: selectedAns)
                        self.tempSelectedAnswer = nil
                        
                    }
                }
            }
        }
    }
    
    func settlemetnExit(onSuccess: @escaping((Bool) -> ())){
        self.homeModel.SettlementData(quizId: self.quizID, attempt: nextQuestionData?.quAttemptID, GamedayId: self.GamedayId, isExit: 1){ Status in
            if Status{
                onSuccess(Status)
            }else{
                onSuccess(true)
            }
        }
    }
    
    func identifyConsecutiveCorrectSubsequencesImage(arrayCorrect:[Int]) -> [Bool] {
        var resultArray: [Bool] = Array(repeating: false, count: (arrayCorrect.count))

        var consecutiveCorrectCount = 0
        let consecutiveCount = self.GameAttemptConfigData?.streakCount ?? 0
        for (index, isCorrect) in arrayCorrect.enumerated() {
            if (isCorrect != 0) {
                consecutiveCorrectCount += 1
                if consecutiveCorrectCount >= consecutiveCount {
                    for i in 0..<3 {
                        resultArray[index - i] = true
                    }
                }
            } else {
                consecutiveCorrectCount = 0
            }
        }

        return resultArray
    }
    
    func identifyConsecutiveCorrectSubsequences(arrayCorrect:[Int]) -> [Bool] {
        var resultArray: [Bool] = Array(repeating: false, count: (arrayCorrect.count))
        var consecutiveCorrectCount = 0
        let consecutiveCount = self.GameAttemptConfigData?.streakCount ?? 0
        guard consecutiveCount > 0 else {
            // Invalid consecutive count, return an array of false
            return resultArray
        }

        for (index, isCorrect) in arrayCorrect.enumerated() {
            if (isCorrect != 0)  {
                consecutiveCorrectCount += 1
                if consecutiveCorrectCount >= consecutiveCount {
                    for i in 0..<consecutiveCount {
                        resultArray[index - i] = true
                    }
                    // Set the last element to false
                    resultArray[index] = false
                }
            } else {
                consecutiveCorrectCount = 0
            }
        }

        return resultArray
    }
    
    func checkConsecutiveOnes(array: [Int]) -> [Bool] {
            var consecutiveCount = 0
            var resultArray: [Bool] = []

            for element in array {
                if element == 1 {
                    consecutiveCount += 1
                } else {
                    consecutiveCount = 0
                }
                    if consecutiveCount == 3{
                       consecutiveCount = 0
                        resultArray.append(true)
                    }else{
                    
                       resultArray.append(false)
                    }
                
                
            }

            return resultArray
        }
    
    
    func replaceTwoBeforeTrue(with array: [Bool]) -> [Bool] {
        var modifiedArray = array

        for (index, element) in array.enumerated() {
            if element == true {
                let startIndex = max(0, index - 2)
                let endIndex = min(array.count, index)
                modifiedArray.replaceSubrange(startIndex..<endIndex, with: [true, true])
            }
        }

        return modifiedArray
    }
    
    func StreakBreak(array: [Bool]) -> [Bool]{
        var consecutiveCount = 0
        var resultArray: [Bool] = []

        for element in array {
            if element == true {
                consecutiveCount += 1
            }
                if consecutiveCount == 3{
                   consecutiveCount = 0
                    resultArray.append(false)
                }else{
                    if element != true{
                        resultArray.append(false)
                    }else{
                        resultArray.append(true)
                    }
                    
                }
            
            
        }

        return resultArray
    }
}
