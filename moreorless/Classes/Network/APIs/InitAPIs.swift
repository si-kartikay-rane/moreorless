//
//  InitAPIs.swift
//  UEFA_App
//
//  Created by Nausheen Khan on 20/10/21.
//

import UIKit
import SwiftyJSON
import GamesLib

class InitAPIs {
    var passnillGameplaydetail : Gameplaydetail? =  nil
        func getConfigData(onSuccess: ((ConfigModel?) -> ())?,
                           onFailure: ((String) -> ())?=nil){
            
            let configURL = "quiz/feeds/config/\(MOLTheme.currentGameID ?? "")-apps.json?buster=" + Date().timeIntervalSince1970.rounded().toString()
 //+ "?v=" + "\(Date().timeIntervalSinceReferenceDate)"
            
            NetworkWrapper.shared.GET(type:.CONFIG_BASE_URL,url: configURL, onSuccess: { responseJSON in
                
                do {
                    
                    let decoder = JSONDecoder()
                    let configValue = try decoder.decode(ConfigModel.self, from: responseJSON.rawData())
                    Constants.configData = nil
                    onSuccess?(configValue)

                    
                } catch {
                   
                }
                
            }, onFailure: { retVal in
                onFailure?(NetworkHelper.getErrorMessageFromTranslation(retVal: retVal, from: .none))
            }, headerType: .NONE)
        }
    func guestuserdata() -> [Gameplaydetail]?{
        return UserDefaultsData.shared.getCodableDataFromUserDefaults(forKey: "GuestData" + (MOLTheme.currentGameID ?? "uclmoreorless"))
    }
    func userLogin(onSuccess: @escaping((QUserLoginResponseModel?) -> ()), onFailure: ((String) -> ())?=nil){
        let user = GamingHubCards.user
    
        guard let configData = Constants.configData else {
            onFailure?("Couldnt get config data login")
            return}
      
        var loginURL = (configData.endpoints?.loginURL ?? String.empty) //+ "?backdoor={backdoor}"
        loginURL = loginURL.replacingOccurrences(of: NetworkConstants().urlKeys.backdoor, with: "sanzensekai")
       // loginURL = loginURL.replacingOccurrences(of: NetworkConstants().urlKeys.competitionType, with: MOLTheme.currentGameID ?? "uclmoreorless")
        let request = QUserLoginRequestModel()
        request.optType = 0
        request.userId = user.userId ?? 0
        request.platformId = MOLTheme.isIpad ? 4 :  2 //configData.platformIDIos ??
        request.favTeamId = user.favouriteClub?.intValue()
        request.gigyaId = user.uefaId ?? ""
        request.countryCode = user.countryCode ?? ""
        request.fullName = user.username
        request.level = user.level
        request.levelName = user.levelName
        request.socialId = user.userId ?? 0
        request.profilePic = user.avatar.url
        request.favTeamCode = ""
        request.clientId = 1
        request.gameplaydetail =   self.guestuserdata() ?? [] //QuizzGameSDk.game.store.getGuestData()
        
        
        do {
            let jsonData = try JSONEncoder().encode(request)
            // Convert JSON data to string
            if let jsonString = String(data: jsonData, encoding: .utf8) {
               
               
            } else {
               
            }
        } catch {
           
        }
        
        
        NetworkWrapper.shared.POST(type: .DETAIL_BASE_URL, url: loginURL, params: request, onSuccess: { responseJSON in
            
            let data: GenericResponseModel<QUserLoginResponseModel> = NetworkHelper.getDecodedData(from: responseJSON)
            QuizzGameSDk.game.store.setGuestData(data: nil)
            UserDefaultsData.shared.setCodableDataToUserDefaults(codableData:self.passnillGameplaydetail , forKey: "GuestData" + (MOLTheme.currentGameID ?? "uclmoreorless"))
            LocalDataHelper().deleteDataFromLocal(type: .GuestData)
            Constants.isLogin =  GamingHubCards.isLoggedIn
            Constants.guid = data.Data.Value?.userGUID ?? ""
            
            onSuccess(data.Data.Value)
        }, onFailure: { retVal in
            
            onFailure?(NetworkHelper.getErrorMessageFromTranslation(retVal: retVal, from: .none))
        }, headerType: .DEFAULT)
    }
    
    func getTranslationData(onSuccess: @escaping((JSON?) -> ()), onFailure: ((String) -> ())?=nil){
        guard let configData = Constants.configData else {
            onFailure?("Couldnt fetch config data")
            return
        }
        
        var transURL =  configData.endpoints?.translationsURL ?? ""
        transURL = transURL.replacingOccurrences(of: NetworkConstants().urlKeys.languageCode, with: GamingHubCards.environment.language)
        transURL = transURL.replacingOccurrences(of: NetworkConstants().urlKeys.platformId, with: "\(Constants.appData.platformID)")
    
        NetworkWrapper.shared.GET(type:.DETAIL_BASE_URL,url: transURL, onSuccess: { responseJSON in
            let data: GenericResponseModel<JSON> = NetworkHelper.getDecodedData(from: responseJSON)
            onSuccess(data.Data.Value?["translation"])
        }, onFailure: { retVal in
            onFailure?(NetworkHelper.getErrorMessageFromTranslation(retVal: retVal, from: .none))
        }, headerType: .NONE)
    }
    
    
    
    
}

extension Data {
    var prettyJson: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding:.utf8) else { return nil }

        return prettyPrintedString
    }
}
