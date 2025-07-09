//
//  SplashViewModel.swift
//  quiz
//
//  Created by Vishal Vijayvargiya on 19/10/23.
//

import Foundation
import GamesLib

class SplashVM:ObservableObject{
    @Published var isLogin:Bool =  false
    
    func loginUserSession(onCompletion: @escaping ((Bool, String?) -> ())){
        MolGameSDk.game.refreshUserLogin { success, error in
            onCompletion(success, error)
        }
    }
    
    func resetUserCache(){
        UserDefaultsData.shared.homeScreenVisitedCount = 0
        GamingHubCards.logout()
        let defaults = UserDefaults.standard
        guard let gameId = MOLTheme.currentGameID else { return }
        MolGameSDk.game.store.QuizUser =  nil
        MolGameSDk.game.store.cardData = nil
        MolGameSDk.game.store.guestData = []
        defaults.removeObject(forKey: "GuestData" + (gameId))
        defaults.removeObject(forKey: "isTutorialVisited")
        defaults.removeObject(forKey: "isMyTeamFilterTooltipVisited")
        defaults.removeObject(forKey: "isPickPlayerTooltipVisited")
        defaults.removeObject(forKey: "isRecommededQstnPopupVisited")
        defaults.removeObject(forKey: "guestUserTeamName")
        defaults.removeObject(forKey: "homeScreenVisitedCount")
        defaults.removeObject(forKey: "homeScreenVisitedCount")
        defaults.removeObject(forKey: "didShowPlayerKitsMsg")
        defaults.removeObject(forKey: "currentLang")
        defaults.removeObject(forKey: "apiVersioning")
        defaults.removeObject(forKey: "isUserTeamUpdatedForGameday")
        defaults.removeObject(forKey: "isDayliQuizPlay\(gameId)")
        defaults.removeObject(forKey: "isMoreLessPlay\(gameId)")
        defaults.removeObject(forKey: "isMoreLessPlay\(gameId)")
        defaults.removeObject(forKey: "translationVersion")
        defaults.removeObject(forKey: "teamVersion")
        defaults.removeObject(forKey: "formationVersion")
        defaults.removeObject(forKey: "dismissibleCardVersion")
        defaults.removeObject(forKey: "dismissibleCardPersistKey")
        defaults.removeObject(forKey: "notificationCardShown")
        defaults.removeObject(forKey: "notificationPopupDismissTimeStamp")
    }
}


