//
//  ExitBottomPopup.swift
//  QuizeApp
//
//  Created by Vishal Vijayvargiya on 21/08/23.
//
import SwiftUI
import GamesLib

struct ExitBottomPopup: View {
    @Binding var isPresented: Bool
    var quiztype : Int
    var replaceString : String
    var quizId : String
    var gameType: String
    @State private var current_screen_name = "/quiz-gameplay-"
//    @State var viewModel = QuizViewModel()
    @State var MLViewModel = MLGameViewModel()
    @State var userClickYes:Bool = false
    var onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            if userClickYes {
                ActivityIndicator(isAnimating:$userClickYes, style: .large)
            }
            if MOLTheme.isIpad{
                HStack{
                    
                    buttonView
                        
            
                }.frame(width:540)
                 .disabled(userClickYes)
            }else{
                VStack {
                    Spacer(minLength: 10)
                    buttonView
                    if !MOLTheme.isGamingHubHost{
                        
                        VStack{}.frame(height: 50)
                    }
                }.frame(width:UIScreen.screenWidth).disabled(userClickYes)
                    
            }
        }.onAppear {
            current_screen_name =  "/quiz-gameplay-"
        }
    }
    
    var buttonView:some View{
        ZStack(alignment: .bottom){
            VStack(alignment: .leading,spacing: 0) {

                HStack {
                    Spacer()

                    Button(action: {
                        isPresented = false
                    }, label: {
                        Image(uiImage: MOLTheme.getImage(named: MolImageName.QSDK_Cross.name) ?? UIImage())
                            //.resizable()
                            .frame(width: 32, height: 32)

                    })

                }.padding([.top,.trailing],10)
                    .padding(.bottom,0)

                VStack(alignment: .leading,spacing:20){
                    Text(AppStrings.exit_title.getTranslationValue(default: "Exit quiz?"))
                        .multilineTextAlignment(.leading)
                        .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 20))
                        .foregroundColor(MOLTheme.getColor(named: .QPSDKWhite))

                    Text(AppStrings.exit_sub_title.getTranslationValue(default: "If you resume the quiz later, this question will be skipped."))
                        .multilineTextAlignment(.leading)
                        .font(Font.swiftUICustomFont(customFont: .SF_UI_Regular, size: 16))
                        .foregroundColor(MOLTheme.getColor(named: .QPSDKWhite)).opacity(0.7)

                    if MOLTheme.isIpad{
                        HStack{

                            Button(action: {
                                isPresented = false
                                if gameType == "mol"{
                                    let ga4 = QuizzerAnalyticsExitModalQuitQuiz(quizType:MOLTheme.eventTypeData(title: MLViewModel.cardSelection?.gatitle ?? "", gameType: MLViewModel.cardSelection?.gaPageTitle ?? "mol"))
                                    Track.shared.event(G4A: ga4, name: current_screen_name + (MLViewModel.cardSelection?.gametype ?? "mol"), params: nil, replaceString: "\(MLViewModel.currentQuestionIndex+1)", quizId: self.MLViewModel.quizID,quizTitle: MLViewModel.cardSelection?.gatitle, gaPageTitle: MLViewModel.cardSelection?.gaPageTitle)
                                }else{
//                                    let ga4 = QuizzerAnalyticsExitModalQuitQuiz(quizType:MOLTheme.eventTypeData(title: viewModel.cardSelection?.gatitle ?? "", gameType: viewModel.cardSelection?.gaPageTitle ?? "quiz"))
//                                    Track.shared.event(G4A: ga4, name: current_screen_name +  (viewModel.cardSelection?.gametype ?? "quiz"), params: nil, replaceString: "\(viewModel.jsonIndex+1)", quizId: self.viewModel.quizID,quizTitle: viewModel.cardSelection?.gatitle, gaPageTitle: viewModel.cardSelection?.gaPageTitle)
                                }
                            }, label: {
                                Text(AppStrings.exitNo.getTranslationValue(default: "No, continue"))
                                    .frame(maxWidth: .infinity,maxHeight: 20)
                                    .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 14))
                                    .foregroundColor(MOLTheme.getColor(named: .QPSDKPrimary))
                            }).buttonStyle(.secondary(borderWidth: 1))

                            Button(action: {
                                if !userClickYes{
                                    userClickYes = true
                                    if GamingHubCards.isLoggedIn {
                                       if self.gameType != "mol"{
//                                            self.viewModel.settlemetnExit(){ isdismiss in
//                                                isPresented = !isdismiss
////                                                let ga4 = QuizzerAnalyticsExitModalQuitQuiz(quizType:MOLTheme.eventTypeData(title: viewModel.cardSelection?.gatitle ?? "", gameType: viewModel.cardSelection?.gaPageTitle ?? "quiz"))
////                                                Track.shared.event(G4A: ga4, name: current_screen_name +  (viewModel.cardSelection?.gametype ?? "quiz"), params: nil, replaceString: "\(viewModel.jsonIndex+1)", quizId: self.viewModel.quizID,quizTitle: viewModel.cardSelection?.gatitle, gaPageTitle: viewModel.cardSelection?.gaPageTitle)
//                                                onDismiss()
//                                                userClickYes =  false
//                                            }
                                       }else{
                                           let ga4 = QuizzerAnalyticsExitModalQuitQuiz(quizType:MOLTheme.eventTypeData(title: MLViewModel.cardSelection?.gatitle ?? "", gameType: MLViewModel.cardSelection?.gaPageTitle ?? "mol"))
                                           Track.shared.event(G4A: ga4, name: current_screen_name + (MLViewModel.cardSelection?.gametype ?? "quiz"), params: nil, replaceString: "\(MLViewModel.currentQuestionIndex+1)", quizId: self.MLViewModel.quizID,quizTitle: MLViewModel.cardSelection?.gatitle, gaPageTitle: MLViewModel.cardSelection?.gaPageTitle)
                                           MLViewModel.exitapicall(){ onSuccess in
                                               if onSuccess{
                                                   userClickYes =  false
                                                   isPresented = false
                                                   BusterHelper.shared.updateBuster(type: .LEADERBOARD)
                                                   onDismiss()
                                               }else{
                                                   onDismiss()
                                               }
                                           }
                                       }
                                    }else{
                                        userClickYes =  false
                                        isPresented = false
                                        if gameType == "mol"{
                                            let ga4 = QuizzerAnalyticsExitModalQuitQuiz(quizType:MOLTheme.eventTypeData(title: MLViewModel.cardSelection?.gatitle ?? "", gameType: MLViewModel.cardSelection?.gaPageTitle ?? "mol"))
                                            Track.shared.event(G4A: ga4, name: current_screen_name + (MLViewModel.cardSelection?.gametype ?? "quiz"), params: nil, replaceString: "\(MLViewModel.currentQuestionIndex+1)", quizId: self.MLViewModel.quizID,quizTitle: MLViewModel.cardSelection?.gatitle, gaPageTitle: MLViewModel.cardSelection?.gaPageTitle)
                                        }else{
//                                            let ga4 = QuizzerAnalyticsExitModalQuitQuiz(quizType:MOLTheme.eventTypeData(title: viewModel.cardSelection?.gatitle ?? "", gameType: viewModel.cardSelection?.gaPageTitle ?? "quiz"))
//                                            Track.shared.event(G4A: ga4, name: current_screen_name +  (viewModel.cardSelection?.gametype ?? "quiz"), params: nil, replaceString: "\(viewModel.jsonIndex+1)", quizId: self.viewModel.quizID,quizTitle: viewModel.cardSelection?.gatitle, gaPageTitle: viewModel.cardSelection?.gaPageTitle)
                                        }
                                        onDismiss()
                                    }
                                }
                            }, label: {
                                Text(AppStrings.exityes.getTranslationValue(default: "Yes, exit"))
                                    .frame(maxWidth: .infinity,maxHeight: 20)
                                    .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 14))
                            }).buttonStyle(.primary)
                        }
                    }else{
                        VStack{
                            Button(action: {
                                if !userClickYes{
                                    userClickYes = true
                                    if GamingHubCards.isLoggedIn {
                                        if self.gameType != "mol"{
//                                            self.viewModel.settlemetnExit(){ isdismiss in
//                                                isPresented = !isdismiss
////                                                let ga4 = QuizzerAnalyticsExitModalQuitQuiz(quizType:MOLTheme.eventTypeData(title: viewModel.cardSelection?.gatitle ?? "", gameType: viewModel.cardSelection?.gaPageTitle ?? "quiz"))
////                                                Track.shared.event(G4A: ga4, name: current_screen_name +  (viewModel.cardSelection?.gametype ?? "quiz"), params: nil, replaceString: "\(viewModel.jsonIndex+1)", quizId: self.viewModel.quizID,quizTitle: viewModel.cardSelection?.gatitle, gaPageTitle: viewModel.cardSelection?.gaPageTitle)
//                                                onDismiss()
//                                                userClickYes =  false
//                                               
//                                            }
                                        }else{
                                            let ga4 = QuizzerAnalyticsExitModalQuitQuiz(quizType:MOLTheme.eventTypeData(title: MLViewModel.cardSelection?.gatitle ?? "", gameType: MLViewModel.cardSelection?.gaPageTitle ?? "mol"))
                                            Track.shared.event(G4A: ga4, name: current_screen_name + (MLViewModel.cardSelection?.gametype ?? "quiz"), params: nil, replaceString: "\(MLViewModel.currentQuestionIndex+1)", quizId: self.MLViewModel.quizID,quizTitle: MLViewModel.cardSelection?.gatitle, gaPageTitle: MLViewModel.cardSelection?.gatitle)
                                            
                                            MLViewModel.exitapicall(){ onSuccess in
                                                if onSuccess{
                                                    userClickYes =  false
                                                    isPresented = false
                                                    BusterHelper.shared.updateBuster(type: .LEADERBOARD)
                                                    onDismiss()
                                                }else{
                                                    onDismiss()
                                                }
                                            }
                                        }
                                    }else{
                                        userClickYes =  false
                                        isPresented = false
                                        if gameType == "mol"{
                                            let ga4 = QuizzerAnalyticsExitModalQuitQuiz(quizType:MOLTheme.eventTypeData(title: MLViewModel.cardSelection?.gatitle ?? "", gameType: MLViewModel.cardSelection?.gaPageTitle ?? "mol"))
                                            Track.shared.event(G4A: ga4, name: current_screen_name + (MLViewModel.cardSelection?.gametype ?? "quiz"), params: nil, replaceString: "\(MLViewModel.currentQuestionIndex+1)", quizId: self.MLViewModel.quizID,quizTitle: MLViewModel.cardSelection?.gatitle, gaPageTitle: MLViewModel.cardSelection?.gaPageTitle)
                                        }else{
//                                            let ga4 = QuizzerAnalyticsExitModalQuitQuiz(quizType:MOLTheme.eventTypeData(title: viewModel.cardSelection?.gatitle ?? "", gameType: viewModel.cardSelection?.gaPageTitle ?? "quiz"))
//                                            Track.shared.event(G4A: ga4, name: current_screen_name +  (viewModel.cardSelection?.gametype ?? "quiz"), params: nil, replaceString: "\(viewModel.jsonIndex+1)", quizId: self.viewModel.quizID,quizTitle: viewModel.cardSelection?.gatitle, gaPageTitle: MLViewModel.cardSelection?.gaPageTitle)
                                        }
                                        onDismiss()
                                    }
                                }
                            }, label: {
                                Text(AppStrings.exityes.getTranslationValue(default: "Yes, exit"))
                                    .frame(maxWidth: .infinity,maxHeight: 20)
                                    .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 14))
                            }).buttonStyle(.primary)
                            
                            Button(action: {
                                isPresented = false
                                
                                if gameType == "mol"{
                                    let ga4 = QuizzerAnalyticsExitModalQuitQuiz(quizType:MOLTheme.eventTypeData(title: MLViewModel.cardSelection?.gatitle ?? "", gameType: MLViewModel.cardSelection?.gaPageTitle ?? "mol"))
                                    Track.shared.event(G4A: ga4, name: current_screen_name + (MLViewModel.cardSelection?.gametype ?? "quiz"), params: nil, replaceString: "\(MLViewModel.currentQuestionIndex+1)", quizId: self.MLViewModel.quizID,quizTitle: MLViewModel.cardSelection?.gatitle, gaPageTitle: MLViewModel.cardSelection?.gaPageTitle)
                                }else{
//                                    let ga4 = QuizzerAnalyticsExitModalQuitQuiz(quizType:MOLTheme.eventTypeData(title: viewModel.cardSelection?.gatitle ?? "", gameType: viewModel.cardSelection?.gaPageTitle ?? "quiz"))
//                                    Track.shared.event(G4A: ga4, name: current_screen_name +  (viewModel.cardSelection?.gametype ?? "quiz"), params: nil, replaceString: "\(viewModel.jsonIndex+1)", quizId: self.viewModel.quizID,quizTitle: viewModel.cardSelection?.gatitle, gaPageTitle: viewModel.cardSelection?.gaPageTitle)
                                }
                            }, label: {
                                Text(AppStrings.exitNo.getTranslationValue(default: "No, continue"))
                                    .frame(maxWidth: .infinity,maxHeight: 20)
                                    .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 14))
                                    .foregroundColor(MOLTheme.getColor(named: .QPSDKPrimary))
                            }).buttonStyle(.secondary(borderWidth: 1))
                        }
                        
                    }
                }.padding([.leading,.trailing],MOLTheme.isIpad ? 32 : 12)
                 .padding(.bottom,MOLTheme.isIpad ? 52 : 32)
            }

        }.ignoresSafeArea()
        .background(MOLTheme.getColor(named: .QSDK_151573))
        .quizCornerRadius(16.0, corners: MOLTheme.isIpad ? .allCorners : [.topLeft,.topRight])
        //.padding([.leading,.trailing],20)
        
    }
}

//extension View {
//    func quizCornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
//        clipShape( RoundedCorner(radius: radius, corners: corners) )
//    }
//}
//
//struct RoundedCorner: Shape {
//
//    var radius: CGFloat = .infinity
//    var corners: UIRectCorner = .allCorners
//
//    func path(in rect: CGRect) -> Path {
//        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        return Path(path.cgPath)
//    }
//}
