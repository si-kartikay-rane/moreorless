//
//  FeatureCardViewModel.swift
//  quiz
//
//  Created by Vishal Vijayvargiya on 28/11/23.
//

import Foundation


class QSDKFeatureCardViewModel:ObservableObject{
    
    private  var initAPIs: InitAPIs = {
        return InitAPIs()
    }()
    @Published var cardData:ConfigCard? =  nil
    @Published var isLoading:Bool =  true
    func getFeatureCardData(){
        let group = DispatchGroup()
        QuizzGameSDk.game.sponsorModel =  nil
        QuizzGameSDk.game.getSponsorsForGame(gameid: MOLTheme.currentGameID, competitionid: MOLTheme.competitionId)
        initAPIs.getConfigData { configData in
            Constants.configData = configData
            group.enter()
            QuizzGameSDk.game.refreshTranslationData { success, error in
                group.leave()
            }
            
            group.enter()
            QSDKFeatureCardAPIs.shared.getFeatureCardData { data in
                
                if data != nil{
                    self.cardData =  data
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    self.isLoading =  false
                }
                group.leave()
            }
            

        }
    }
    
}
class ConfigCard: Codable {
    let cardImageURL, cardtitle, cardBody, cardButton: String?
    let cardTransURL: String?

    enum CodingKeys: String, CodingKey {
        case cardImageURL = "cardImageUrl"
        case cardtitle, cardBody, cardButton
        case cardTransURL = "cardTransUrl"
    }

    init(cardImageURL: String?, cardtitle: String?, cardBody: String?, cardButton: String?, cardTransURL: String?) {
        self.cardImageURL = cardImageURL
        self.cardtitle = cardtitle
        self.cardBody = cardBody
        self.cardButton = cardButton
        self.cardTransURL = cardTransURL
    }
}

class guestUserPlayGame:Codable{
    var quizTypeID:Int?
    var isdisable:Bool?
}
