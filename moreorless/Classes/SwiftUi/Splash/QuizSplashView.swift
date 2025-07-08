//
//  UclQuizSplashView.swift
//  uclquiz
//
//  Created by Vishal Vijayvargiya on 21/09/23.
//

import SwiftUI
import GamesLib
import Combine

struct QuizSplashView: View {

    @State var addShow:Bool =  false
    @State private var orientation: UIInterfaceOrientation = .unknown
    @State var isNavigationHiden = false
    @State var stopObserver = false
    @State private var current_screen_name = "/splash-screen" //splash-screen"
    @State var analyticsDomainName: String = ""
    @State var analyticsData: TrackingParameters = TrackingParameters([:] as [String: Any?]?)
    
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

     var body: some View {
       
            ZStack {
                if QUIZTheme.currentGameID == "weuroquiz" && orientation.isLandscape{
                    backgroundImageView
                        .resizable()
                        .frame(width:UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        .edgesIgnoringSafeArea(.vertical)
                }else{
                    backgroundImageView
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                }
                    
                VStack(alignment: .center) {
                    
                    if QUIZTheme.currentGameID == "uwclquiz"{
                        Image(uiImage: QUIZTheme.getImage(named: QuizImageName.quizspashLogo.name) ?? UIImage())
                            .resizable()
                            .frame(width: QUIZTheme.currentGameID == "euroquiz" ? 100.83: 211, height: 149)
                            .scaledToFit()
                            .padding(.top, (QUIZTheme.isIpad && !orientation.isLandscape) ? 205 : 133)
                            .padding(.bottom,55)
                        if QUIZTheme.currentGameID == "euroquiz"{
                            Image(uiImage: QUIZTheme.getImage(named: QuizImageName.euroQuizView.name) ?? UIImage())
                                .resizable()
                                .frame(width: 210,height: 210)
                            
                        }
                        
                    }
                    
//                    if QUIZTheme.currentGameID != "uclquiz"{
//                        Image(uiImage: QUIZTheme.getImage(named: QuizImageName.quizspashLogo.name) ?? UIImage())
//                            .resizable()
//                            .frame(width: QUIZTheme.currentGameID == "euroquiz" ? 100.83: 211, height: 149)
//                            .scaledToFit()
//                        let value =  AppStrings.TitleApp.getTranslationValue(default: "Quiz Arena").components(separatedBy: " ")
//                        if  (QUIZTheme.currentGameID  == "euroquiz"){
//                            VStack{
//                                Text(value.first ?? "")
//                                Text(value.last ?? "")
//                            }.font(.customFont(customFont:  .UEFAEuro_Bold, size: 36))
//                                .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
//                        }else{
//                            Text(AppStrings.TitleApp.getTranslationValue(default: "Quiz Arena"))
//                                .font(.customFont(customFont: .Champions_Bold, size: 56) )
//                                .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
//                        }
//                        
//                        if QUIZTheme.currentGameID == "euroquiz"{
//                            Image(uiImage: QUIZTheme.getImage(named: QuizImageName.euroQuizView.name) ?? UIImage())
//                                .resizable()
//                                .frame(width: 210,height: 210)
//                            
//                        }
//                        
//                    }
                    if !QUIZTheme.isIpad && QUIZTheme.currentGameID != "uclquiz" && QUIZTheme.currentGameID != "weuroquiz"{
                        if GamingHubCards.environment.environment != GamingHubEnvironment.production {
                            Text("v" + String(describing:(PodBundle.version)) + "-" + String(describing: GamingHubCards.environment.environment))
                                .foregroundColor(.white)
                                .font(.caption)
                        }
                    }
                    if QUIZTheme.currentGameID == "uclquiz"{
                        if QUIZTheme.isIpad{
                            Image(uiImage: QUIZTheme.getImage(named: QuizImageName.quizspashLogo.name) ?? UIImage())
                                .resizable()
                                .scaledToFit()
                                .frame(width: 260,height: 260)
                                .padding(.top, (QUIZTheme.isIpad && !orientation.isLandscape) ? 205 : 69)
                            Spacer()
                            if GamingHubCards.environment.environment != GamingHubEnvironment.production {
                                Text("v" + String(describing:(PodBundle.version)) + "-" + String(describing: GamingHubCards.environment.environment))
                                    .foregroundColor(.white)
                                    .font(.caption)
                            }
                            Spacer()
                            Image(uiImage: QUIZTheme.getImage(named: QuizImageName.euroQuizView.name) ?? UIImage())
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200,height: 200)
                            Image(uiImage: QUIZTheme.getImage(named: QuizImageName.euroStadTop.name) ?? UIImage())
                                .resizable()
                                .scaledToFit()
                                .frame(height: 156)
                                .padding(.bottom, /*(QUIZTheme.isIpad && !orientation.isLandscape && UIScreen.screenHeight > 1180) ? 35 : */0)
                        }
                    }
                    if QUIZTheme.currentGameID == "weuroquiz"{
                            
                        if QUIZTheme.isIpad{
                            Image(uiImage: QUIZTheme.getImage(named: QuizImageName.quizspashIpadLogo.name) ?? UIImage())
                                .resizable()
                                .scaledToFit()
                                .frame(width: 260,height: 260)
                                .padding(.top, (QUIZTheme.isIpad && !orientation.isLandscape) ? 205 : 100)
                        }else{
                            Image(uiImage: QUIZTheme.getImage(named: QuizImageName.quizspashLogo.name) ?? UIImage())
                                .resizable()
                                .scaledToFit()
                                .frame(width: 210,height: 210)
                                .padding(.top, 100)
                        }
                        
                        if GamingHubCards.environment.environment != GamingHubEnvironment.production {
                            Text("v" + String(describing:(PodBundle.version)) + "-" + String(describing: GamingHubCards.environment.environment))
                                .foregroundColor(.white)
                                .font(.caption)
                        }
                        VStack{
                            if addShow{
                                AdsPresentedbyView(VerticaleEnable: true,analyticsDomainName: self.analyticsDomainName, analyticsData: self.analyticsData, backgroundColor: QUIZTheme.getColor(named: .QSDKSponsorBG00439C), SponsorClickDisabled:true)
                            }
                        }
                        .padding(.leading,10)
                            Image(uiImage: QUIZTheme.getImage(named: QuizImageName.euroQuizView.name) ?? UIImage())
                                .resizable()
                                .scaledToFit()
                                .frame(width: QUIZTheme.isIpad ? 380 : 300,height: QUIZTheme.isIpad ? 380 : 300)
                                .padding(.bottom, (QUIZTheme.isIpad && !orientation.isLandscape && UIScreen.screenHeight > 1180) ? 215 : 85)

                    }
                    
                    
                    
                    if QUIZTheme.currentGameID != "weuroquiz"{
                        if addShow{
                            AdsPresentedbyView(VerticaleEnable: true, analyticsDomainName: self.analyticsDomainName, analyticsData: self.analyticsData, backgroundColor: QUIZTheme.getColor(named: .QSDKSponsorBG00439C), SponsorClickDisabled:true)
                            
                          
                        }
                    }
                    if QUIZTheme.currentGameID == "uwclquiz"{
                        Spacer()
                    }
                    
                }
                        //.padding(.all,10)
 
            }.navigationBarHidden(isNavigationHiden)
            .quizOnRotate { newOrientation in
                if !stopObserver {
//                    orientation = newOrientation
                    updateOrientation()
                    QUIZTheme.updateViewLayout()
                }
            }
       
            .onAppear {
                isNavigationHiden =  true
                
                let (analyticsDomainName, analyticsData) = Track.shared.get_screen_domain_params(screen: current_screen_name, params: [:], replace: nil)
                GamingHubCards.registerTrackingDefaults(analyticsData, domain: analyticsDomainName, gameId: QUIZTheme.currentGameID ?? "uclquiz")
                
                self.analyticsDomainName = analyticsDomainName
                self.analyticsData = analyticsData
                
                Track.shared.screen(screen: current_screen_name, params: [:], replace: nil)
                Track.shared.trackSponsor(slot: "body", analyticsDomainName: analyticsDomainName, analyticsData: analyticsData)
                updateOrientation()
//                orientation = UIDevice.current.orientation
                stopObserver = false
//                if GamingHubCards.isLoggedIn{
//                    
//                }

            }
            .onDisappear {
                stopObserver = false
                isNavigationHiden = false
            }

            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("Sponsor"))) { notification in
                if !stopObserver{
                    addShow =  true
                }
            }
//            .overlay {
//                if GamingHubCards.environment.environment != GamingHubEnvironment.production {
//                    ZStack {
//                        Text("v\(PodBundle.version) (\(GamingHubCards.environment.environment))")
//                    }
//                }
//            }
    }
    
    private var backgroundImageView: Image {
        if idiom != .pad {
            return Image(uiImage: QUIZTheme.getImage(named: QuizImageName.QSDKSplashIPhoneBG.name) ?? UIImage())
        } else if orientation.isLandscape && (UIScreen.main.bounds.width > UIScreen.main.bounds.height){
            return Image(uiImage: QUIZTheme.getImage(named: QuizImageName.QSDKSplashIPadLandscapeBG.name) ?? UIImage())
        } else {
            return Image(uiImage: QUIZTheme.getImage(named: QuizImageName.QSDKSplashIPadPortraitBG.name) ?? UIImage())
        }
    }

    private func updateOrientation() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            orientation = scene.interfaceOrientation
        }
    }
}

