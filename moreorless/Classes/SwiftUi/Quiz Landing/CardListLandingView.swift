//
//  CardListLandingView.swift
//  quiz
//
//  Created by Vishal Vijayvargiya on 11/10/23.
//

import SwiftUI
import GamesLib
import Kingfisher

struct CardListLandingView: View {
    
    @State private var showQuetionAnsView = false
    var QuizCardListData : QuizCardListData? = nil
    var tag: Int // Tag value for this view
    var current_screen_name : String
    var buttonAction: (Bool) -> Void // Closure to handle button click
    var body: some View {
        //ForEach(0..<2, id: \.self) { index in
           
            if  QUIZTheme.isIpad{
                quizCardIpad
                    
            }else{
                quizCardIphone
                    
            }
        //}
    }
    
   
    
     var quizCardIphone: some View {
         
         VStack {
             
             ZStack(alignment:.top){
                 
                 //ImageView(imageUrl: QuizCardListData?.bgimage ?? "", placeholder: QUIZTheme.getImage(named:QuizImageName.QSDK_Rmedia.name))
                 
                 KFImage(URL(string: QuizCardListData?.bgimage ?? ""))
                     .placeholder {
                         QUIZTheme.getImage(named:QuizImageName.QSDK_Rmedia.name)?
                             .resizable()
                     }
                     .retry(maxCount: 3, interval: .seconds(5))
                     .resizable()
                     .scaledToFit()
                     .ignoresSafeArea()
                     .overlay(
                        LinearGradient(gradient: Gradient(colors: gradientColors()),
                                       startPoint: .top,
                                       endPoint: .bottom).opacity(0.0)
                     ).opacity((QuizCardListData?.isDisable ?? 0) != 0 ? 0.3 : (QuizCardListData?.cardState == 1 && QuizCardListData?.showWinner == 0) ? 0.3 : 1)
                 
                 if  QuizCardListData?.timer != nil{
                     HStack{
                         Spacer()
                         
                         Text(QuizCardListData?.timer ?? "")
                             .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                             .font(Font.swiftUICustomFont(customFont: .SF_UI_Bold, size: 12))
                             .frame(minHeight:20)
                             .padding([.top,.bottom],2)
                             .padding([.leading,.trailing],6)
                             .background(QUIZTheme.getColor(named: QUIZTheme.currentGameID  == "euroquiz" ? .QSDK_00BA5D : .QSDK_000FAA ))
                             .cornerRadius(4)
                     }.padding(.all,15)
                     
                     Spacer()
                 }
                 
                 if !GamingHubCards.isLoggedIn{
                     
                     if (QuizCardListData?.cardState != 2 && QuizCardListData?.showWinner != 1){
                         // normal game play no condition check only check quiz type daily then show text showiner 0/nil or cart status 0/nil
                         if (QuizCardListData?.showWinner == 0 || QuizCardListData?.showWinner == nil) && (QuizCardListData?.cardState == 0 || QuizCardListData?.cardState == nil) && (QuizCardListData?.quiztypeid ?? 0) == 2 && GamingHubCards.isLoggedIn{
                             HStack{
                                 Spacer()
                                 
                                 Text("".timeUntilNextQuizLanding(disable: QuizCardListData?.isDisable ?? 0, endDate: QuizCardListData?.quizEndDate ?? ""))
                                     .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                                     .font(Font.swiftUICustomFont(customFont: .SF_UI_Bold, size: 12))
                                     .frame(minHeight:20)
                                     .padding([.top,.bottom],2)
                                     .padding([.leading,.trailing],6)
                                     .background(QUIZTheme.getColor(named: QUIZTheme.currentGameID  == "euroquiz" ? .QSDK_00BA5D : .QSDK_000FAA ))
                                     .cornerRadius(4)
                             }.padding(.all,15)
                             
                             Spacer()
                             // coming soon card then show text
                         }else if (QuizCardListData?.cardState == 1 && QuizCardListData?.showWinner == 0 ) {
                             HStack{
                                 Spacer()
                                 Text("".formatDate(dateString: QuizCardListData?.quizStartDate ?? "") ?? "")
                                     .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                                     .font(Font.swiftUICustomFont(customFont: .SF_UI_Bold, size: 12))
                                     .frame(minHeight:20)
                                     .padding([.top,.bottom],2)
                                     .padding([.leading,.trailing],6)
                                     .background(QUIZTheme.getColor(named: QUIZTheme.currentGameID  == "euroquiz" ? .QSDK_00BA5D : .QSDK_000FAA ))
                                     .cornerRadius(4)
                             }.padding(.all,15)
                             
                             Spacer()
                             // quiz type 2 and logn user then check
                         }else if  GamingHubCards.isLoggedIn {
                             HStack{
                                 Spacer()
                                 Text("".timeUntilNextQuizLanding(disable: QuizCardListData?.isDisable ?? 0, endDate: QuizCardListData?.quizEndDate ?? ""))
                                     .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                                     .font(Font.swiftUICustomFont(customFont: .SF_UI_Bold, size: 12))
                                     .frame(minHeight:20)
                                     .padding([.top,.bottom],2)
                                     .padding([.leading,.trailing],6)
                                     .background(QUIZTheme.getColor(named: QUIZTheme.currentGameID  == "euroquiz" ? .QSDK_00BA5D : .QSDK_000FAA ))
                                     .cornerRadius(4)
                             }.padding(.all,15)
                             
                             Spacer()
                         }
                     }
                     
                 }
             }
             VStack(alignment:.leading,spacing: 16){
                 VStack(alignment:.leading,spacing: 6){
                     //if winer card is available
                     if QuizCardListData?.cardState == 2 && QuizCardListData?.showWinner == 1 {
                         Text(QuizCardListData?.title ?? "")
                             .multilineTextAlignment(.leading)
                             .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 24))
                         Divider().frame(width: 20,height: 4).background(QUIZTheme.getColor(named: .QPSDKPrimary)).padding([.top,.bottom],10)
                         VStack(alignment: .leading, spacing:2){
                             Text(AppStrings.winner_title.getTranslationValue(default: "Winner"))
                                 .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 14))
                             Text(QuizCardListData?.winnerName ?? "")
                                 .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 20))
                         }.foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                         
                     }else{
                         if QuizCardListData?.rank != nil && QuizCardListData?.rank != 0 {
                             Text(AppStrings.quiz_card_rank_and_points.getTranslationValue(default: "{{points}} pts • Rank {{rank}}").replacingOccurrences(of: NetworkConstants().urlKeys.points, with: "\(QuizCardListData?.points ?? 0)").replacingOccurrences(of: NetworkConstants().urlKeys.rank, with: "\(QuizCardListData?.rank ?? 0)"))
                                 .multilineTextAlignment(.leading)
                                 .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 14))
                         }else{
                             Text(QuizCardListData?.subtitle ?? "")
                                 .multilineTextAlignment(.leading)
                                 .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 14))
                         }
                         Text(QuizCardListData?.title ?? "")
                             .multilineTextAlignment(.leading)
                             .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 24))
                         Text(QuizCardListData?.description ?? "")
                             .multilineTextAlignment(.leading)
                             .font(Font.swiftUICustomFont(customFont: .SF_UI_Regular, size: 14))
                             .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite)).opacity(0.7)
                     }
                 }.foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                     .padding(.top,10)
                 // first check no show because winner card is available
                 if (QuizCardListData?.cardState != 2 && QuizCardListData?.showWinner != 1){
                 HStack{
                    
                    
                         // card status 1 mens coming soon card
                         if QuizCardListData?.cardState == 1 && QuizCardListData?.showWinner == 0{
                             Button(action: {
                                 if  NetworkWrapper.isInternerConnected(){
                                     self.buttonAction(true)
                                     
                                    
                                     let G4A = QuizzerAnalyticsGenerateQuiz(quizType: QUIZTheme.eventTypeData(title: QuizCardListData?.gatitle ?? "-", gameType: QuizCardListData?.gaPageTitle ?? "-" ))
                                         Track.shared.event(G4A: G4A, name: current_screen_name, params: nil)
                                     //
                                     //                                 Track.shared.event(event:  QuizCardListData?.quiztypeid != 2 ? .startfun : .startdaily, name: screenName.overview, params: nil)
                                 }
                             }, label: {
                                 Text( AppStrings.comebacktomorrow.getTranslationValue(default: "Come back soon") )
                                     .font(Font.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 14))
                                     .padding([.top,.bottom],10)
                                     .padding([.leading,.trailing],16)
                                     .background(QUIZTheme.getColor(named: .QPSDKPrimary))
                                     .foregroundColor(QUIZTheme.getColor(named: .QSDKButtonTitle00004B))
                                     .cornerRadius(10)
                                 
                             }).tag(tag)
                                 .opacity(0.5)
                                 .disabled(true)
                         }else if QuizCardListData?.isDisable == 1  &&  ("".hoursLeftOnSameDay(quizEndDateStr:QuizCardListData?.quizEndDate ?? "") != nil) {
                             Button(action: {
                                 if  NetworkWrapper.isInternerConnected(){
                                     self.buttonAction(true)
                                     
                                     
                                         let G4A = QuizzerAnalyticsGenerateQuiz(quizType: QUIZTheme.eventTypeData(title: QuizCardListData?.gatitle ?? "-", gameType: QuizCardListData?.gaPageTitle ?? "-" ))
                                         Track.shared.event(G4A: G4A, name: current_screen_name, params: nil)
                                     //
                                     //                                 Track.shared.event(event:  QuizCardListData?.quiztypeid != 2 ? .startfun : .startdaily, name: screenName.overview, params: nil)
                                 }
                             }, label: {
                                 Text( AppStrings.comebacksoon.getTranslationValue(default: AppStrings.comebacktomorrow.getTranslationValue(default: "Come back soon")) )
                                     .font(Font.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 14))
                                     .padding([.top,.bottom],10)
                                     .padding([.leading,.trailing],16)
                                     .background(QUIZTheme.getColor(named: .QPSDKPrimary))
                                     .foregroundColor(QUIZTheme.getColor(named: .QSDKButtonTitle00004B))
                                     .cornerRadius(10)
                                 
                             }).tag(tag)
                                 .opacity(0.5)
                                 .disabled(true)
                             
                         }else{
                             
                             if GamingHubCards.isLoggedIn{
                                 Button(action: {
                                     if  NetworkWrapper.isInternerConnected(){
                                         self.buttonAction(true)
                                         
                                         //                                 Track.shared.event(event:  QuizCardListData?.quiztypeid != 2 ? .startfun : .startdaily , name: screenName.overview, params: nil)
                                         
                                         let G4A = QuizzerAnalyticsGenerateQuiz(quizType: QUIZTheme.eventTypeData(title: QuizCardListData?.gatitle ?? "-", gameType: QuizCardListData?.gaPageTitle ?? "-" ))
                                             Track.shared.event(G4A: G4A, name: current_screen_name, params: nil)
                                         
                                     }
                                 }, label: {
                                     Text((QuizCardListData?.isDisable ?? 0) != 0 ? AppStrings.comebacktomorrow.getTranslationValue(default: "Come back tomorrow") : QuizCardListData?.cta ?? AppStrings.ButtonBrowsequizzes.getTranslationValue(default: "Browse quizzes") )
                                         .font(Font.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 14))
                                         .padding([.top,.bottom],8)
                                         .padding([.leading,.trailing],16)
                                         .background(QUIZTheme.getColor(named: .QPSDKPrimary))
                                         .foregroundColor(QUIZTheme.getColor(named: .QSDKButtonTitle00004B))
                                         .cornerRadius(10)
                                     
                                 }).tag(tag)
                                     .opacity((QuizCardListData?.isDisable ?? 0) != 0 ? 0.5 : 1)
                                     .disabled(((QuizCardListData?.isDisable ?? 0) != 0 ? true : false))
                             }else{
                                 Button(action: {
                                     if  NetworkWrapper.isInternerConnected(){
                                         self.buttonAction(false)
                                         
                                         //Track.shared.event(event: QuizCardListData?.quiztypeid != 2 ? .logintoplayfun : .logintoplaydaily, name: screenName.overview, params: nil)
                                         
                                         let G4A = QuizzerAnalyticsLoginToPlay(quizType: QUIZTheme.eventTypeData(title: QuizCardListData?.gatitle ?? "-", gameType: QuizCardListData?.gaPageTitle ?? "-" ))
                                         Track.shared.event(G4A: G4A, name: current_screen_name, params: nil)
                                     }
                                 }, label: {
                                     VStack(alignment: .center, spacing: 5) {
                                         Text(AppStrings.logintoplay.getTranslationValue(default: "Login to play"))
                                             .font(Font.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 14))
                                             .padding([.top,.bottom],8)
                                             .padding([.leading,.trailing],16)
                                             .background(QUIZTheme.getColor(named: .QPSDKPrimary))
                                             .foregroundColor(QUIZTheme.getColor(named: .QSDKButtonTitle00004B))
                                             .cornerRadius(10)
                                     }
                                 }).tag(tag)
                                     .opacity((QuizCardListData?.isDisable ?? 0) != 0 ? 0.5 : 1)
                                     .disabled(((QuizCardListData?.isDisable ?? 0) != 0 ? true : false))
                                 if (UserDefaults.standard.string(forKey:QuizCardListData?.qzQuizMasterid ?? "") ==  QuizCardListData?.qzQuizMasterid)  {
                                     
                                 }else{
                                     Button(action: {
                                         // self.buttonAction()
                                         if  NetworkWrapper.isInternerConnected(){
                                             self.buttonAction(true)
                                             
                                             //                                 Track.shared.event(event: QuizCardListData?.quiztypeid == 2 ? .tryasguestdaily : .tryasguestdaily, name: screenName.overview, params: nil)
                                             let G4A = QuizzerAnalyticsTryAsGuest(quizType: QUIZTheme.eventTypeData(title: QuizCardListData?.gaPageName ?? "-", gameType: QuizCardListData?.gaPageTitle ?? "-" ))
                                             Track.shared.event(G4A: G4A, name:current_screen_name, params: nil)
                                             
                                         }
                                     }) {
                                         VStack(alignment: .center, spacing: 5) {
                                             Text(AppStrings.Tryasguest.getTranslationValue(default: "Try as a guest"))
                                                 .font(Font.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 14))
                                                 .padding([.top,.bottom],8)
                                                 .padding([.leading,.trailing],16)
                                                 .foregroundColor(QUIZTheme.getColor(named: .QPSDKPrimary))
                                                 .cornerRadius(10)
                                         }.clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                             .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                .stroke(QUIZTheme.getColor(named: .QPSDKPrimary), lineWidth: 1))
                                         
                                     }.tag(tag)
                                 }
                             }
                             Spacer()
                         }
                     
                 }
             }
                 }.frame(maxWidth: .infinity, alignment:.leading)
                     .padding([.leading,.trailing,.bottom],16)
                 
                 //NavigationLink("", destination:  QuetionAnsView(Observer: $PasstoAnotherView, PasstoNavigationView: $PasstoNavigationView).navigationBarTitleDisplayMode(.inline), isActive: $showQuetionAnsView)
             }
             .background(QUIZTheme.getColor(named: .QSDK_0A0A61))
             .cornerRadius(14)
             
         }
    
     var quizCardIpad: some View {
         
         ZStack(alignment:.bottom){
             KFImage(URL(string: QuizCardListData?.bgimage ?? ""))
                 .placeholder {
                     QUIZTheme.getImage(named: QuizImageName.QSDK_Rmedia.name)?
                         .resizable()
                 }
                 .retry(maxCount: 3, interval: .seconds(5))
                 .resizable()
                 .aspectRatio(contentMode: .fit)
                 .ignoresSafeArea()
                 .opacity((QuizCardListData?.isDisable ?? 0) != 0 ? 0.3 : (QuizCardListData?.cardState == 1 && QuizCardListData?.showWinner == 0) ? 0.3 : 1)
                 .overlay(
                     LinearGradient(
                         gradient: Gradient(colors: gradientColors()),
                         startPoint: .top,
                         endPoint: .bottom
                     ).opacity(0.7)
                 )
             
             VStack(alignment:.leading,spacing: 16){
                 
                 if  QuizCardListData?.timer != nil{
                     HStack{
                         Spacer()
                         
                         Text(QuizCardListData?.timer ?? "")
                             .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                             .font(Font.swiftUICustomFont(customFont: .SF_UI_Bold, size: 12))
                             .frame(minHeight:20)
                             .padding([.top,.bottom],2)
                             .padding([.leading,.trailing],6)
                             .background(QUIZTheme.getColor(named: QUIZTheme.currentGameID  == "euroquiz" ? .QSDK_00BA5D : .QSDK_000FAA ))
                             .cornerRadius(4)
                     }.padding(.all,15)
                     
                     Spacer()
                 }
                 
                 if !GamingHubCards.isLoggedIn{
                        if (QuizCardListData?.cardState != 2 && QuizCardListData?.showWinner != 1){
                     // normal game play no condition check only check quiz type daily then show text showiner 0/nil or cart status 0/nil
                     if (QuizCardListData?.showWinner == 0 || QuizCardListData?.showWinner == nil) && (QuizCardListData?.cardState == 0 || QuizCardListData?.cardState == nil)  && GamingHubCards.isLoggedIn{
                         HStack{
                             Spacer()
                             
                             Text("".timeUntilNextQuizLanding(disable: QuizCardListData?.isDisable ?? 0, endDate: QuizCardListData?.quizEndDate ?? ""))
                                 .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                                 .font(Font.swiftUICustomFont(customFont: .SF_UI_Bold, size: 12))
                                 .frame(minHeight:20)
                                 .padding([.top,.bottom],2)
                                 .padding([.leading,.trailing],6)
                                 .background(QUIZTheme.getColor(named: QUIZTheme.currentGameID  == "euroquiz" ? .QSDK_00BA5D : .QSDK_000FAA ))
                                 .cornerRadius(4)
                         }
                         
                         Spacer()
                         // coming soon card then show text
                     }else if (QuizCardListData?.cardState == 1 && QuizCardListData?.showWinner == 0 ) {
                         HStack{
                             Spacer()
                             Text("".formatDate(dateString: QuizCardListData?.quizStartDate ?? "") ?? "")
                                 .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                                 .font(Font.swiftUICustomFont(customFont: .SF_UI_Bold, size: 12))
                                 .frame(minHeight:20)
                                 .padding([.top,.bottom],2)
                                 .padding([.leading,.trailing],6)
                                 .background(QUIZTheme.getColor(named: QUIZTheme.currentGameID  == "euroquiz" ? .QSDK_00BA5D : .QSDK_000FAA ))
                                 .cornerRadius(4)
                         }
                         
                         Spacer()
                         // quiz type 2 and logn user then check
                     }else if  GamingHubCards.isLoggedIn {
                         HStack{
                             Spacer()
                             Text("".timeUntilNextQuizLanding(disable: QuizCardListData?.isDisable ?? 0, endDate: QuizCardListData?.quizEndDate ?? ""))
                                 .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                                 .font(Font.swiftUICustomFont(customFont: .SF_UI_Bold, size: 12))
                                 .frame(minHeight:20)
                                 .padding([.top,.bottom],2)
                                 .padding([.leading,.trailing],6)
                                 .background(QUIZTheme.getColor(named: QUIZTheme.currentGameID  == "euroquiz" ? .QSDK_00BA5D : .QSDK_000FAA ))
                                 .cornerRadius(4)
                         }
                         
                         Spacer()
                     }
                 }
             }
                 VStack(alignment:.leading,spacing: 4){
                     // if winer card is available
                     if QuizCardListData?.cardState == 2 && QuizCardListData?.showWinner == 1 {
                         Text(QuizCardListData?.title ?? "")
                             .multilineTextAlignment(.leading)
                             .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 24))
                         Divider().frame(width: 20,height: 4).background(QUIZTheme.getColor(named: .QPSDKPrimary)).padding([.top,.bottom],10)
                         VStack(alignment: .leading, spacing:2){
                             Text(AppStrings.winner_title.getTranslationValue(default: "Winner"))
                                 .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 14))
                             Text(QuizCardListData?.winnerName ?? "")
                                 .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 20))
                         }.foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                         
                     }else{
                         
                         if QuizCardListData?.rank != nil && QuizCardListData?.rank != 0{
                             Text(AppStrings.quiz_card_rank_and_points.getTranslationValue(default: "{{points}} pts • Rank {{rank}}").replacingOccurrences(of: NetworkConstants().urlKeys.points, with: "\(QuizCardListData?.points ?? 0)").replacingOccurrences(of: NetworkConstants().urlKeys.rank, with: "\(QuizCardListData?.rank ?? 0)"))
                                 .multilineTextAlignment(.leading)
                                 .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 14))
                         }else{
                             Text(QuizCardListData?.subtitle ?? "")
                                 .multilineTextAlignment(.leading)
                                 .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 14))
                         }
                         Text(QuizCardListData?.title ?? "")
                             .multilineTextAlignment(.leading)
                             .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 24))
                         Text(QuizCardListData?.description ?? "")
                             .multilineTextAlignment(.leading)
                             .font(Font.swiftUICustomFont(customFont: .SF_UI_Regular, size: 14))
                     }
                 }.foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                 
                 if (QuizCardListData?.cardState != 2 && QuizCardListData?.showWinner != 1){
                     HStack{
                         
                         if QuizCardListData?.cardState == 1 && QuizCardListData?.showWinner == 0{
                             Button(action: {
                                 if  NetworkWrapper.isInternerConnected(){
                                     self.buttonAction(true)
                                     
                                   
                                         let G4A = QuizzerAnalyticsGenerateQuiz(quizType: QUIZTheme.eventTypeData(title: QuizCardListData?.gatitle ?? "-", gameType: QuizCardListData?.gaPageTitle ?? "-" ))
                                         Track.shared.event(G4A: G4A, name: current_screen_name, params: nil)
                                     //
                                     //                                 Track.shared.event(event:  QuizCardListData?.quiztypeid != 2 ? .startfun : .startdaily, name: screenName.overview, params: nil)
                                 }
                             }, label: {
                                 Text( AppStrings.comebacktomorrow.getTranslationValue(default: "Come back soon") )
                                     .font(Font.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 14))
                                     .padding([.top,.bottom],8)
                                     .padding([.leading,.trailing],16)
                                     .background(QUIZTheme.getColor(named: .QPSDKPrimary))
                                     .foregroundColor(QUIZTheme.getColor(named: .QSDKButtonTitle00004B))
                                     .cornerRadius(10)
                                 
                             }).tag(tag)
                                 .opacity(0.5)
                                 .disabled(true)
                         }else if QuizCardListData?.isDisable == 1  &&  ("".hoursLeftOnSameDay(quizEndDateStr:QuizCardListData?.quizEndDate ?? "") != nil) {
                             Button(action: {
                                 if  NetworkWrapper.isInternerConnected(){
                                     self.buttonAction(true)
                                     
                                    
                                         let G4A = QuizzerAnalyticsGenerateQuiz(quizType: QUIZTheme.eventTypeData(title: QuizCardListData?.gatitle ?? "-", gameType: QuizCardListData?.gaPageTitle ?? "-" ))
                                         Track.shared.event(G4A: G4A, name: current_screen_name, params: nil)
                                     //
                                     //                                 Track.shared.event(event:  QuizCardListData?.quiztypeid != 2 ? .startfun : .startdaily, name: screenName.overview, params: nil)
                                 }
                             }, label: {
                                 Text( AppStrings.comebacksoon.getTranslationValue(default: AppStrings.comebacktomorrow.getTranslationValue(default: "Come back soon")) )
                                     .font(Font.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 14))
                                     .padding([.top,.bottom],8)
                                     .padding([.leading,.trailing],16)
                                     .background(QUIZTheme.getColor(named: .QPSDKPrimary))
                                     .foregroundColor(QUIZTheme.getColor(named: .QSDKButtonTitle00004B))
                                     .cornerRadius(10)
                                 
                             }).tag(tag)
                                 .opacity(0.5)
                                 .disabled(true)
                             
                         }else{
                             if GamingHubCards.isLoggedIn{
                                 Button(action: {
                                     if  NetworkWrapper.isInternerConnected(){
                                         self.buttonAction(true)
                                             let G4A = QuizzerAnalyticsGenerateQuiz(quizType: QUIZTheme.eventTypeData(title: QuizCardListData?.gatitle ?? "-", gameType: QuizCardListData?.gaPageTitle ?? "-" ))
                                             Track.shared.event(G4A: G4A, name: current_screen_name, params: nil)
                                         //
                                         //                                 Track.shared.event(event:  QuizCardListData?.quiztypeid != 2 ? .startfun : .startdaily, name: screenName.overview, params: nil)
                                     }
                                 }, label: {
                                     Text((QuizCardListData?.isDisable ?? 0) != 0 ? AppStrings.comebacktomorrow.getTranslationValue(default: "Come back tomorrow") :  QuizCardListData?.cta ?? AppStrings.ButtonBrowsequizzes.getTranslationValue(default: "Browse quizzes") )
                                         .font(Font.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 14))
                                         .padding([.top,.bottom],8)
                                         .padding([.leading,.trailing],16)
                                         .background(QUIZTheme.getColor(named: .QPSDKPrimary))
                                         .foregroundColor(QUIZTheme.getColor(named: .QSDKButtonTitle00004B))
                                         .cornerRadius(10)
                                     
                                 }).tag(tag)
                                     .opacity((QuizCardListData?.isDisable ?? 0) != 0 ? 0.5 : 1)
                                     .disabled(((QuizCardListData?.isDisable ?? 0) != 0 ? true : false))
                             }else{
                                 Button(action: {
                                     if  NetworkWrapper.isInternerConnected(){
                                         self.buttonAction(false)
                                         // self.showQuetionAnsView.toggle()
                                         //GamingHubCards.trackEvent("card-play-quiz",parameters:[:])
                                         //                                 Track.shared.event(event: QuizCardListData?.quiztypeid != 2 ? .logintoplayfun : .logintoplaydaily, name: screenName.overview, params: nil)
                                         let G4A = QuizzerAnalyticsLoginToPlay(quizType:QUIZTheme.eventTypeData(title: QuizCardListData?.gatitle ?? "-", gameType: QuizCardListData?.gaPageTitle ?? "-" ))
                                         Track.shared.event(G4A: G4A, name: current_screen_name, params: nil)
                                         
                                     }
                                 }, label: {
                                     Text(AppStrings.logintoplay.getTranslationValue(default: "Login to play"))
                                         .font(Font.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 14))
                                         .padding([.top,.bottom],8)
                                         .padding([.leading,.trailing],16)
                                         .background(QUIZTheme.getColor(named: .QPSDKPrimary))
                                         .foregroundColor(QUIZTheme.getColor(named: .QSDKButtonTitle00004B))
                                         .cornerRadius(10)
                                     
                                 }).tag(tag)
                                     .opacity((QuizCardListData?.isDisable ?? 0) != 0 ? 0.5 : 1)
                                     .disabled(((QuizCardListData?.isDisable ?? 0) != 0 ? true : false))
                                 if (UserDefaults.standard.string(forKey:QuizCardListData?.qzQuizMasterid ?? "") == QuizCardListData?.qzQuizMasterid) {
                                     
                                 }else{
                                     Button(action: {
                                         if  NetworkWrapper.isInternerConnected(){
                                             //                                     Track.shared.event(event: QuizCardListData?.quiztypeid == 2 ? .tryasguestdaily : .tryasguestdaily, name: screenName.overview, params: nil)
                                             let G4A = QuizzerAnalyticsTryAsGuest(quizType: QUIZTheme.eventTypeData(title: QuizCardListData?.gaPageName ?? "-", gameType: QuizCardListData?.gaPageTitle ?? "-" ))
                                             Track.shared.event(G4A: G4A, name: current_screen_name, params: nil)
                                             self.buttonAction(true)
                                         }
                                     }) {
                                         VStack(alignment: .center, spacing: 5) {
                                             Text(AppStrings.Tryasguest.getTranslationValue(default: "Try as a guest"))
                                                 .font(Font.swiftUICustomFont(customFont: .SF_UI_SemiBold, size: 14))
                                                 .padding([.top,.bottom],8)
                                                 .padding([.leading,.trailing],16)
                                                 .foregroundColor(QUIZTheme.getColor(named: .QPSDKPrimary))
                                                 .cornerRadius(10)
                                         }.clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                             .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                .stroke(QUIZTheme.getColor(named: .QPSDKPrimary), lineWidth: 1))
                                         
                                     }.tag(tag)
                                 }
                             }
                         }
                         
                     }
                 }
             }.frame(maxWidth: .infinity, alignment:.leading)
                 .padding(.all,32)
            
         }
         
         .cornerRadius(14)
         
     }
    
    func gradientColors() -> [Color] {
        if ((QuizCardListData?.showWinner == 0 || QuizCardListData?.showWinner == nil) && (QuizCardListData?.cardState == 0 || QuizCardListData?.cardState == nil) && (QuizCardListData?.quiztypeid ?? 0) == 2 && GamingHubCards.isLoggedIn) {
            return (QUIZTheme.currentGameID == "euroquiz") ? [.black, .clear] : [.clear, .black]
        } else if  (QuizCardListData?.cardState == 1 && QuizCardListData?.showWinner == 0 )  {
            return (QUIZTheme.currentGameID == "euroquiz") ? [.black, .clear] : [.clear, .black]
        } else if (QuizCardListData?.quiztypeid ?? 0) == 2 && GamingHubCards.isLoggedIn  {
            return (QUIZTheme.currentGameID == "euroquiz") ? [.black, .clear] : [.clear, .black]
        }else{
            return (QUIZTheme.currentGameID == "euroquiz") ? [.clear, .black] : QUIZTheme.isIpad ? [.clear, .black] : [.clear, .clear]
        }
    }

}

public struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func quizCornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}


