//
//  FeatureCardAPIs.swift
//  quiz
//
//  Created by Vishal Vijayvargiya on 28/11/23.
//

import Foundation
import Combine
import SwiftUI
class QSDKFeatureCardAPIs {
    static let shared = QSDKFeatureCardAPIs()
 

   func getFeatureCardData(onSuccess: @escaping((ConfigCard?) -> ()), onFailure: ((String) -> ())?=nil){
       

       guard let configData = Constants.configData else {
           onFailure?("Couldnt fetch config data")
           return
       }
       var gamerCardURL = (configData.baseDomain ?? .empty) + "/quiz/feeds/config/\(MOLTheme.currentGameID ?? "uclmoreorless")-apps.json?buster=1701411978363"
      
        NetworkWrapper.shared.GET(type: .None, url: gamerCardURL, onSuccess: { responseJSON in
            do {
                
                let decoder = JSONDecoder()
                let configValue = try decoder.decode(ConfigCard.self, from: responseJSON.rawData())
               
                onSuccess(configValue)
            } catch {
            }
            
        }, onFailure: { retVal in
            onSuccess(nil)
        }, headerType: .ENTITY)
   }
    
        
}
