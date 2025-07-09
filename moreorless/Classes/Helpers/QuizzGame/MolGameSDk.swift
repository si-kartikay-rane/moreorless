//
//  MolGameSDk.swift
//  UEFAQuizSDK
//
//  Created by Vishal Vijayvargiya on 24/08/23.
//

import Foundation
import SwiftyJSON
import GamesLib

class MolGameSDk {
    
    static var game: MolGameSDk = MolGameSDk()
    let store: MolGameSDk.Store
    
    private var translationData: JSON?
    //Sponsor
    @Published var sponsorModel: SponsorModel?
    
    init() {
        //tourId = "60" //config.tour_id
        store = MolGameSDk.Store()
    }
    
    private(set) var initAPIs: InitAPIs = {
        return InitAPIs()
    }()
    
    func getQuizUserToken() -> String? {
            return GamingHubCards.user.token?.token
    }
    func getAppLanguage() -> String{
        return GamingHubCards.environment.language
    }
    
    func isLogin() -> Bool{
        return GamingHubCards.isLoggedIn
    }
   
    
    func refreshTranslationData(onCompletion: @escaping((Bool, String?) -> ())) {
        //since trans is stored in local storage, refresh it only when there is version change
//        guard  UserDefaultsData.shared.currentLang != MolGameSDk.game.getAppLanguage() else {
//            onCompletion(true,nil)
//            return
//        }
        self.initAPIs.getTranslationData { [weak self] response in
            UserDefaultsData.shared.currentLang = MolGameSDk.game.getAppLanguage()
            self?.store.setTranslations(data: response)
            LocalDataHelper().saveDataToLocal(type: .Translation)
            //UserDefaultsData.shared.translationVersion = Constants.configData?.apiVersions?.transVersion ?? 1
            onCompletion(true, nil)
        } onFailure: { errorMessage in
            onCompletion(false, errorMessage)
        }
    }
   
    func refreshUserLogin(onCompletion: @escaping((Bool, String?) -> ())) {
        self.initAPIs.userLogin { [weak self] userdata in
            self?.store.QuizUser = userdata
            
                onCompletion(true, nil)
            
        } onFailure: { errorMessage in
            onCompletion(false, errorMessage)
        }
    }
    
    //MARK : -  Strore Class
    class Store {
        
        private var translationData: JSON?
        var QuizUser: QUserLoginResponseModel?
        var cardData:ConfigCard?
        var guestData:[Gameplaydetail] = []
        func setTranslations(data: JSON?){
            self.translationData = data
        }
        
        func setGuestData(data:Gameplaydetail?){
            if let values = data{
                guestData.append(values)
            }else{
                guestData = []
            }
            LocalDataHelper().saveDataToLocal(type: .GuestData)
        }
        
        func getGuestData() -> [Gameplaydetail]{
            self.guestData
        }
        
        //MARK: Translation
        func getTranslations() -> JSON?{
            if self.translationData == nil {
                self.translationData = LocalDataHelper().readDataFromLocal(type: .Translation)
            }
            return self.translationData
        }
    }
}


extension MolGameSDk{
    
    func getSponsorsForGame(gameid:String?,competitionid:Int?){
        guard self.sponsorModel == nil else {return}
        GamingHubCards.getSponsors(tags: gameid, competitionId: competitionid) { data, sponsorLogos in
            DispatchQueue.main.async {
                
                if let data = data, data.count > 0{
                    let sponsorData = data[0]
                    let sponsorModel = SponsorModel()
                    sponsorModel.imageUrl = sponsorData["image"] as? String
                    sponsorModel.color = sponsorData["colour"] as? String
                    sponsorModel.secondaryColor = sponsorData["secondaryColour"] as? String
                    let intro = sponsorData["introText"] as? [String: Any]
                    let trans = intro?["translations"] as? [String:String]
                    sponsorModel.introText = trans
                    sponsorModel.links = sponsorData["links"] as? [String:String]
                    sponsorModel.name = sponsorData["name"] as? String
                    sponsorModel.mainSponsor = sponsorData["mainSponsor"] as? String
                    sponsorModel.code = sponsorData["code"] as? String
                    self.sponsorModel = sponsorModel
                    NotificationCenter.default.post(name: Notification.Name("Sponsor"), object: nil, userInfo: nil)
                }
            }
        }
    }
    
    func QuizzerGenerateRandom16DigitUInt() -> String {
        let digits = (0..<16).map { _ in String(Int.random(in: 0...9)) }
            return digits.joined()
    }
    
    func getQuizzerRootViewController() -> UIViewController? {
        if #available(iOS 15.0, *) {
            // Modern approach using UIWindowScene
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                return window.rootViewController
            }
        } else {
            // Legacy approach for older iOS versions
            return UIApplication.shared.windows.first?.rootViewController
        }
        return nil
    }
}
