//
//  FeatureCardView.swift
//  QuizeApp
//
//  Created by Vishal Vijayvargiya on 21/08/23.
//

import SwiftUI
import GamesLib
import Kingfisher

public struct FeaturedCardSwiftUI: View {
    
    let data: [String : Any]?
    let gameId: String?
    let competition: Int?
    let theme_bundle : Bundle?
    @State private var index:Int = 0
    @State private var list:String = ""
    @State private var brand:String = ""
    @State private var isLoading = true
    @StateObject private var viewModel = QSDKFeatureCardViewModel()
    
    @State private var isVisible: Bool = false
    @State private var triggerWork: Bool = false
    @State var stops = [Gradient.Stop(color: Color(hex: "0232FF"), location: 0.0),
                        Gradient.Stop(color: Color(hex: "FF51A2"), location: 0.33),
                        Gradient.Stop(color: Color(hex: "00EEFF"), location: 0.66),
                        Gradient.Stop(color: Color(hex: "0232FF"), location: 1.0)]
    
    public init(data: [String : Any]?, gameId: String?, competition: Int?) {
        self.data = data
        self.gameId = gameId
        self.competition = competition
        let podBundle =  Bundle(for: FeaturedCard.self)
        let data = podBundle.url(forResource: gameId, withExtension: "bundle")!
        theme_bundle = Bundle(url: data) ?? Bundle.main
        MOLTheme.currentBundle =  theme_bundle
        MOLTheme.currentGameID =  gameId
        MOLTheme.competitionId = competition
        MOLTheme.updateViewLayout()
        GamingHubCards.registerFonts(forCompetition: 1) //euro = 3 // ucl = 1
        if let info = self.data?["trackingInfo"] as? [String:Any] {
            index = info["index"] as? Int ?? 0
            list = info["list"] as? String ?? ""
            brand = info["brand"] as? String ?? ""
            
        }else{
            index = 0
            brand = ""
            list = ""
        }
        //Font.QSDKregisterFonts()
        
        
       
    }
    
    public var body: some View {
      
                VStack {
                    if viewModel.isLoading {
                        ZStack {
                            MOLTheme.getColor(named: .QSDKBackGround_000040).ignoresSafeArea()
                            ActivityIndicator(isAnimating: $isLoading, style: .large)
                        }
                    } else {
                        if MOLTheme.isIpad {
                            Button(action: {
                                if NetworkWrapper.isInternerConnected() {
                                    GamingHubCards.open(gameId ?? "quiz", data: nil)
                                }
                            }, label: {
                                featureCardIpad
                                
                            })
                        } else {
                            Button(action: {
                                if NetworkWrapper.isInternerConnected() {
                                    print(gameId)
                                    GamingHubCards.open(gameId ?? "quiz", data: nil)
                                }
                            }, label: {
                                featureCardIphone
                                    
                            })
                        }
                    }
                }
                .overlay(
                   
                            VisibilityTracker(isVisible: $isVisible, onVisible: {
                                // Perform actions when visible
                                trackingImpression()
                            }).allowsHitTesting(false)
                        )
        .environment(\.bundle, theme_bundle)
        .onAppear {
            viewModel.getFeatureCardData()
        }
    }

    
    private func trackingImpressionAfterDelay() {
        if !triggerWork && isVisible {
            triggerWork = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if isVisible { // Re-check visibility after delay
                    trackingImpression()
                }
                triggerWork = false
            }
        }
    }
    
    private func trackingImpression() {
        GamingHubCards.trackProductImpression("", name: "Quiz Arena - Browse quizzes", category: MOLTheme.currentGameID ?? "uclmoreorless", variant: nil, list: list, brand: brand, index: index)
    }
    
    
    
    private var featureCardIphone : some View {
        VStack(spacing:0){
            VStack{
                KFImage(URL(string: urlavtra(url: viewModel.cardData?.cardImageURL ?? "")))
                    .placeholder {
                        MOLTheme.getImage(named:QuizImageName.QSDK_Rmedia.name)?
                            .resizable()
                    }
                    .retry(maxCount: 3, interval: .seconds(5))
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .offset(y: MOLTheme.currentGameID == "uclmoreorless" ? 2 : 0)
                    .clipShape(RoundedCorner(radius:MOLTheme.currentGameID == "uclmoreorless" ? 13 : 0, corners: [.topLeft,.topRight]))
//                    .overlay(
//                        LinearGradient(gradient: Gradient(colors: MOLTheme.currentGameID == "euromoreorless" ? [.clear,.clear] : [.clear, .black]),
//                                       startPoint: .top,
//                                       endPoint: .bottom).opacity(0.8)
//                    )

            }

            VStack(alignment:.leading,spacing: 16){
                VStack(alignment:.leading,spacing: 4){
                   
                    Text(viewModel.cardData?.cardtitle?.getTranslationValue(default: "Quiz Arena") ?? "Quiz Arena")
                        .multilineTextAlignment(.leading)
                        .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 14))
                    //Text("Put your knowledge to the test – and climb the leaderboards!")
                    Text(viewModel.cardData?.cardBody?.getTranslationValue(default: "Put your knowledge to the test – and climb the leaderboards!") ?? "Put your knowledge to the test – and climb the leaderboards!")
                        .multilineTextAlignment(.leading)
                        .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 20))
                    
                }.foregroundColor(MOLTheme.getColor(named: .QPSDKWhite))
                HStack{
                    
                    Button(action: {
                        if  NetworkWrapper.isInternerConnected(){
                            GamingHubCards.open(gameId ?? "quiz", data: nil)
                            GamingHubCards.trackProductImpression("", name: "Quiz Arena - Browse quizzes", category: MOLTheme.currentGameID ?? "uclmoreorless", variant: nil, list: list, brand: brand, index: index)
                        }
            
                    }, label: {
                        //Text("Browse quizzes")
                        Text(viewModel.cardData?.cardButton?.getTranslationValue(default: "Browse quizzes") ?? "Browse quizzes")
                            .font(Font.swiftUICustomFont(customFont: MOLTheme.currentGameID == "weuromoreorless" ? .SF_UI_SemiBold : .SF_UI_Bold, size: 14))
                           // .frame(height: 32)
                            .padding([.top,.bottom],9)
                            .padding([.leading,.trailing],16)
                            .background(MOLTheme.getColor(named: .QPSDKPrimary))
                            .foregroundColor(MOLTheme.getColor(named: .QSDKButtonTitle00004B))
                            .cornerRadius(10)
                        
                    })
                    
                }
            }
            .frame(maxWidth: .infinity, alignment:.leading)
            .padding(.all,16)
            .background(MOLTheme.getColor(named: .QSDK_0A0A61))
        }
        .background( MOLTheme.currentGameID == "uclmoreorless" ? LinearGradient(
            stops: stops,
            startPoint: .topLeading,
            endPoint: .topTrailing
        ) : LinearGradient(gradient: Gradient(colors: [MOLTheme.getColor(named: .QSDK_0A0A61)]), startPoint: .top, endPoint: .bottom))
        .clipShape(RoundedCorner(radius: MOLTheme.currentGameID == "uclmoreorless" ? 10 : 0, corners: [.topLeft,.topRight]))
    }
    
    private var featureCardIpad: some View {
        
        ZStack(alignment:.bottom){

                KFImage(URL(string: urlavtra(url: viewModel.cardData?.cardImageURL ?? "")))
                    .placeholder {
                        MOLTheme.getImage(named:QuizImageName.QSDK_Rmedia.name)?
                            .resizable()
                    }
                    .retry(maxCount: 3, interval: .seconds(5))
                   .resizable()
                   .aspectRatio(16/9, contentMode: .fit)
                    .ignoresSafeArea()
                    .overlay(
                        LinearGradient(gradient: Gradient(colors:[.clear, .black]),
                                       startPoint: .top,
                                       endPoint: .bottom).opacity(0.8)
                    )
                    .offset(y:  MOLTheme.currentGameID == "uclmoreorless" ? 2 : 0)
                    .clipShape(RoundedCorner(radius: 16, corners: [.topLeft,.topRight]))
      
            
            VStack(alignment:.leading,spacing: 16){
                VStack(alignment:.leading,spacing: 4){
                    Text(viewModel.cardData?.cardtitle?.getTranslationValue(default: "Quiz Arena") ?? "Quiz Arena")
//                    Text(viewModel.cardData?.cardtitle ?? "")
                        .multilineTextAlignment(.leading)
                        .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 14))
                    Text(viewModel.cardData?.cardBody?.getTranslationValue(default: "Put your knowledge to the test – and climb the leaderboards!") ?? "Put your knowledge to the test – and climb the leaderboards!")
//                    Text(viewModel.cardData?.description ?? "")
                        .multilineTextAlignment(.leading)
                        .font(Font.swiftUICustomFont(customFont: .SF_UI_Bold, size: 20))
                    
                }.foregroundColor(MOLTheme.getColor(named: .QPSDKWhite))
                HStack{
                    
                    Button(action: {
                        
                        if  NetworkWrapper.isInternerConnected(){
                            GamingHubCards.open(gameId ?? "quiz", data: nil)
                            GamingHubCards.trackProductImpression("", name: "Quiz Arena - Browse quizzes", category: MOLTheme.currentGameID ?? "uclmoreorless", variant: nil, list: list, brand: brand, index: index)
                        }
                        
                    }, label: {
                        Text(viewModel.cardData?.cardButton?.getTranslationValue(default: "Browse quizzes") ?? "Browse quizzes")
//                        Text(viewModel.cardData?.cardButton ?? "")
                            .font(Font.swiftUICustomFont(customFont: .SF_UI_Bold, size: 14))
                           // .frame(height: 32)
                            .padding([.top,.bottom],9)
                            .padding([.leading,.trailing],16)
                            .background(MOLTheme.getColor(named: .QPSDKPrimary))
                            .foregroundColor(MOLTheme.getColor(named: .QSDKButtonTitle00004B))
                            .cornerRadius(10)
                        
                    })
                    
                }
            }.frame(maxWidth: .infinity, alignment:.leading)
                .padding(.all,32)
            
        }
        .background( MOLTheme.currentGameID == "uclmoreorless" ? LinearGradient(
            stops: stops,
            startPoint: .topLeading,
            endPoint: .topTrailing
        ) : LinearGradient(gradient: Gradient(colors: [MOLTheme.getColor(named: .QSDK_0A0A61)]), startPoint: .top, endPoint: .bottom))
        .clipShape(RoundedCorner(radius: MOLTheme.currentGameID == "uclmoreorless" ? 10 : 0, corners: [.topLeft,.topRight]))
    }
    
    func urlavtra(url:String) -> String{
        var urlAvtrar:String = ""
        urlAvtrar = url
        urlAvtrar =  urlAvtrar.replacingOccurrences(of: NetworkConstants().urlKeys.backgroundType, with: "default")
        return urlAvtrar
    }
}


struct BundleKey: EnvironmentKey {
    static var defaultValue: Bundle? = nil
}

extension EnvironmentValues {
    var bundle: Bundle? {
        get { self[BundleKey.self] }
        set { self[BundleKey.self] = newValue }
    }
}


struct VisibilityTracker: UIViewControllerRepresentable {
    @Binding var isVisible: Bool
    let onVisible: () -> Void

    func makeUIViewController(context: Context) -> VisibilityTrackerViewController {
        let controller = VisibilityTrackerViewController()
        controller.onVisibilityChange = { visible in
            isVisible = visible
            if visible {
                onVisible()
            }
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: VisibilityTrackerViewController, context: Context) {}
}

class VisibilityTrackerViewController: UIViewController {
    var onVisibilityChange: ((Bool) -> Void)?
    private var displayLink: CADisplayLink?
    private var visibilityTimer: Timer?
    private var isVisibilityTimerRunning = false

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startVisibilityCheck()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopVisibilityCheck()
    }

    private func startVisibilityCheck() {
        displayLink = CADisplayLink(target: self, selector: #selector(checkVisibility))
        displayLink?.add(to: .main, forMode: .tracking)
    }

    private func stopVisibilityCheck() {
        displayLink?.invalidate()
        displayLink = nil
        stopVisibilityTimer()
    }

    @objc private func checkVisibility() {
        guard let window = view.window else { return }
        let visibleRect = window.bounds.intersection(view.convert(view.bounds, to: window))
        let visiblePercentage = visibleRect.size.height / view.bounds.size.height

        if visiblePercentage > 0.4 {
            if !isVisibilityTimerRunning {
                startVisibilityTimer()
            }
        } else {
            stopVisibilityTimer()
            onVisibilityChange?(false)
        }
    }

    private func startVisibilityTimer() {
        isVisibilityTimerRunning = true
        visibilityTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.isVisibilityTimerRunning = false
            self.onVisibilityChange?(true)
        }
    }

    private func stopVisibilityTimer() {
        visibilityTimer?.invalidate()
        visibilityTimer = nil
        isVisibilityTimerRunning = false
    }
}
