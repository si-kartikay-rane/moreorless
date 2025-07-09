//
//  AdsView.swift
//  QuizeApp
//
//  Created by Vishal Vijayvargiya on 22/08/23.
//

import SwiftUI
import GoogleMobileAds
import Kingfisher
import GamesLib


struct AdsPresentedbyView: View {
    private var viewModel =  PresentedByViewModel()
    var VerticaleEnable:Bool = true
    var analyticsDomainName: String
    var analyticsData: TrackingParameters
    var backgroundColor: Color = MOLTheme.getColor(named: .QSDKSponsorBG00439C)
    var SponsorClickDisabled:Bool =  false
    var textprestcolor:Color = .white
    @State var openWebView:Bool =  false
    @State var height : CGFloat = 0
    var buttonAction: ((Bool) -> Void)?
    init(VerticaleEnable: Bool,analyticsDomainName:String ,analyticsData : TrackingParameters, backgroundColor: Color = MOLTheme.getColor(named: .QSDKSponsorBG00439C),SponsorClickDisabled:Bool = false,buttonAction: ((Bool) -> Void)? = nil) {
        self.viewModel = PresentedByViewModel()
        self.VerticaleEnable = VerticaleEnable
        self.backgroundColor = Color(hex: viewModel.colorcode ?? "")
        self.textprestcolor = Color(hex: viewModel.textcolor ?? "")
        self.SponsorClickDisabled = SponsorClickDisabled
        self.buttonAction = buttonAction
        self.analyticsDomainName = analyticsDomainName
        self.analyticsData = analyticsData
    }
    
    var body: some View {
        
        if viewModel.ImageUrl != nil {
            Button {
                if  NetworkWrapper.isInternerConnected(){
                    if !SponsorClickDisabled{
                        self.openWebView =  true
                        Track.shared.trackSponsorClick(analyticsDomainName: analyticsDomainName, analyticsData: analyticsData)
                        if let action = buttonAction {
                            action(true)
                        }
                    }
                }
            } label: {
                VStack(alignment: .center,spacing: 0.0){
                    if !VerticaleEnable{
                        ZStack {
                            backgroundColor
                            HStack{
                                Text(viewModel.SponserIntro)
                                    .foregroundColor(textprestcolor)
                                    .font(Font.swiftUICustomFont(customFont: .SF_UI_Regular, size: 10))
                                    .frame(alignment: .leading)
                            }.padding(.leading,-110)
                            HStack(spacing: 10){
                                KFImage(URL(string: viewModel.ImageUrl ?? ""))
                                    .placeholder {
                                        MOLTheme.getImage(named:MolImageName.QPSDKAdsImage.name)?
                                            .resizable()
                                    }
                                    .retry(maxCount: 3, interval: .seconds(5))
                                    .resizable()
                                
                                    .frame(width: 67, height: 40, alignment: .center)
                                    .scaledToFit()
                                    .padding(.all,5)
                            }
                        } .frame(maxHeight: 50.0)
                     
                    }else{
                        VStack(alignment: .center, spacing: 10){
                            Text(viewModel.SponserIntro)
                                .foregroundColor(textprestcolor)
                                .font(Font.swiftUICustomFont(customFont: .SF_UI_Regular, size: 14))
                            
                            KFImage(URL(string: viewModel.ImageUrl ?? ""))
                                .placeholder {
                                    MOLTheme.getImage(named:MolImageName.QPSDKAdsImage.name)?
                                        .resizable()
                                }
                                .retry(maxCount: 3, interval: .seconds(5))
                                .resizable()
                            
                                .frame(width: 67, height: 40, alignment: .center)
                                .scaledToFit()
                                
                        }.padding(.trailing,(MOLTheme.currentGameID  == "euromoreorless") ? -8 : 0)
                        .padding(20)
                    }
                }
                
                NavigationLink("", destination: CommonWebView(url: self.viewModel.linkurl ?? "",titleString: self.viewModel.Titile ?? "").navigationBarTitleDisplayMode(.inline),isActive:$openWebView)
            }.background(!VerticaleEnable ? backgroundColor : .clear)
        }
    }
    var PlaceHolder:some View{
        Image(uiImage:MOLTheme.getImage(named:MolImageName.QPSDKAdsImage.name) ?? UIImage())
            .resizable()
        .frame(width: 70, height: 50)
        .scaledToFit()
    }
}

struct AdsSponsorsView: View {
    
    var body: some View {
        VStack(alignment: .center){
            AdMobBannerView().frame(width: 320,height: 50)
        }
    }
}

// A SwiftUI view representing an AdMob banner
struct AdMobBannerView: UIViewRepresentable {
    func makeUIView(context: Context) -> GADBannerView {
        let bannerView = GADBannerView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        if let adUnitId = Constants.configData?.adBanner?[MolGameSDk.game.getAppLanguage()]{
            bannerView.adUnitID = adUnitId
        }
        
        bannerView.rootViewController = MolGameSDk.game.getQuizzerRootViewController()
        let request = GAMRequest()
        request.customTargeting = ["pos": "top"]
        
        /// Set correlator:
        let extras = GADExtras()
        extras.additionalParameters = ["correlator": MolGameSDk.game.QuizzerGenerateRandom16DigitUInt()];
        request.register(extras)
        
        bannerView.load(request)
        return bannerView
    }

    func updateUIView(_ uiView: GADBannerView, context: Context) {}
}



