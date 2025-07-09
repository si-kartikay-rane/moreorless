//
//  MolNotificationsViewModel.swift
//  quiz
//
//  Created by Milind Trivedi on 21/05/25.
//

import Foundation
import GamesLib


class MolNotificationsViewModel : ObservableObject {
    
    @Published var showLoader = false
    @Published var showNotificationCard: Bool = false
    @Published var showNotificationChannelPopUp: Bool = false
    @Published var showToast: Bool = false
    @Published var notificationPopUp : Bool = false
    
    @objc func appDidBecomeActive() {
        DispatchQueue.main.async {
            self.showLoader = true
            if self.showNotificationCard {
                GameNotificationsManager.isNotificationsGranted { [weak self] granted in
                    guard let self = self else { return }
                    if  MOLTheme.oldNotifcationPermisstion != granted.rawValue {
                        MOLTheme.channels.removeAll()
                        MOLTheme.isChannelChangedFromBG = false
                        self.setStatusforallChannels(isFromBG: true)
                        MOLTheme.oldNotifcationPermisstion = granted.rawValue
                        self.showLoader = false
                    } else {
                        self.checkNotificationSavedTime()
                    }
                }
                self.showLoader = false
            }else{
                self.showNotificationCard = true
#warning("Call landing page api if needed and reload home landing view to show showNotificationCard ")
                self.showLoader = false
            }
            
        }
    }
    
    @objc func notificationsChannelStatusChanged() {
        DispatchQueue.main.async {
            GameNotificationsManager.channels(for: MOLTheme.currentGameID ?? "quiz") { result in
                switch result {
                case.success(let channels):
                    self.showNotificationCard = !channels.allSatisfy({ $0.status == true })
                    if self.showNotificationCard {
                        //self.viewmodel.getCellsForHome()
#warning("Call landing page api if needed and reload home landing view to show showNotificationCard ")
                    }
                case .failure(_):
                    self.showNotificationCard = true
                    //self.viewmodel.getCellsForHome()
#warning("Call landing page api if needed and reload home landing view to show showNotificationCard ")
                }
            }
        }
    }
    
    func checkNotificationsPermission() {
        GameNotificationsManager.isNotificationsGranted { granted in
            if  granted != .authorized {
                DispatchQueue.main.async {
                    if UserDefaultsData.shared.homeScreenVisitedCount == 1 {
                        GameNotificationsManager.isNotificationsGranted { granted in
                            if  granted == .authorized || granted == .provisional {
                                DispatchQueue.main.async {
                                    GameNotificationsManager.channels(for: MOLTheme.currentGameID ?? "quiz") { result in
                                        switch result {
                                        case.success(let channels):
                                            //ENABLE ALL CHANNELS
                                            let dispatchGroup = DispatchGroup()
                                            
                                            for channel in channels {
                                                dispatchGroup.enter() // Enter the group for each channel
                                                
                                                GameNotificationsManager.set(newStatus: true, forNotificationChannel: channel) { _ in
                                                    dispatchGroup.leave() // Leave the group once the task is complete
                                                }
                                            }
                                            
                                        case .failure(let error):
                                            Constants.print(error.localizedDescription)
                                        }
                                    }
                                }
                            }else{
                                self.showNotificationPopup()
                            }
                        }
                        
                    } else {
                        self.showNotificationCard = true
                    }
                }
            } else {
                self.checkNotificationSavedTime()
            }
        }
    }
    
    func checkNotificationSavedTime() {
        if MOLTheme.isChannelChangedFromBG {
            MOLTheme.QuizzerNotificationsyncmanager {
                let savedDate = UserDefaultsData.shared.notificationPopupDismissTimeStamp
                guard savedDate == nil else { return }
                
                GameNotificationsManager.channels(for: MOLTheme.currentGameID ?? "quiz") { result in
                    switch result {
                    case.success(let channels):
                        self.showNotificationCard = !channels.allSatisfy({ $0.status == true })
                    case .failure(_):
                        self.showNotificationCard = true
                    }
                }
            }
            return
        }
        
        let savedDate = UserDefaultsData.shared.notificationPopupDismissTimeStamp
        guard savedDate == nil else { return }
        
        GameNotificationsManager.channels(for: MOLTheme.currentGameID ?? "quiz") { result in
            switch result {
            case.success(let channels):
                self.showNotificationCard = !channels.allSatisfy({ $0.status == true })
            case .failure(_):
                self.showNotificationCard = true
            }
        }
    }
    
    func promptUserToEnableChannels() {
        DispatchQueue.main.async {
            GameNotificationsManager.channels(for: MOLTheme.currentGameID ?? "quiz") { result in
                switch result {
                case .success(let channels):
                    DispatchQueue.main.async { [weak self] in
                        if channels.count > 1 {
                            
                            GameNotificationsManager.isNotificationsGranted { granted in
                                if  granted == .authorized || granted == .provisional {
                                    DispatchQueue.main.async {
                                        GameNotificationsManager.channels(for: MOLTheme.currentGameID ?? "quiz") { result in
                                            guard let self = self else { return }
                                            switch result {
                                            case.success(let channels):
                                                self.showNotificationChannelPopUp = true
#warning("if needed to pass use channels variable and pass channels to your notification channel popup view")
                                            case .failure(let error):
                                                Constants.print(error.localizedDescription)
                                            }
                                        }
                                    }
                                }else{
                                    DispatchQueue.main.async {
                                        GameNotificationsManager.channels(for: MOLTheme.currentGameID ?? "quiz") { result in
                                            guard let self = self else { return }
                                            switch result {
                                            case.success(let channels):
                                                //ENABLE ALL CHANNELS
                                                let dispatchGroup = DispatchGroup()
                                                
                                                for channel in channels {
                                                    dispatchGroup.enter() // Enter the group for each channel
                                                    
                                                    GameNotificationsManager.set(newStatus: true, forNotificationChannel: channel) { result in
                                                        switch result {
                                                        case .success(_):
                                                            dispatchGroup.leave() // Leave the group once the task is complete
                                                        case .failure(let error):
                                                            Constants.print(error.localizedDescription)
                                                        }
                                                        
                                                    }
                                                }
                                                
                                                dispatchGroup.notify(queue: .main) {
                                                    self.checkNotificationSavedTime()
                                                }
                                            case .failure(let error):
                                                Constants.print(error.localizedDescription)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            //
                        }else{
                            if let channel = channels.first {
                                GameNotificationsManager.set(newStatus: true, forNotificationChannel: channel) { result in
                                    guard let self = self else { return }
                                    switch result {
                                    case .success(let channel):
                                        DispatchQueue.main.async {
                                            self.removeNotificationCard()
                                        }
                                    case .failure(let error):
                                        Constants.print(error)
                                        DispatchQueue.main.async {
                                            self.showNotificationCard = true
                                        }
                                    }
                                }
                            }
                        }
                    }
                case .failure(let error):
                    Constants.print(error)
                    self.showNotificationCard = true
                }
            }
        }
    }
    
    func setStatusforallChannels(isFromBG: Bool = false) {
        //Once user allows permission ask them to enable their respective channels
        let dispatchGroup = DispatchGroup()
        //ENABLE ALL CHANNELS AND LET USER CHOOSE
        GameNotificationsManager.isNotificationsGranted { granted in
            if granted == .authorized || granted == .provisional {
                dispatchGroup.enter()
                GameNotificationsManager.channels(for: MOLTheme.currentGameID ?? "quiz") { [weak self] result in
                    guard let self = self else { return }

                    switch result {
                    case .success(let channels):
                        for channel in channels {
                            dispatchGroup.enter()
                            GameNotificationsManager.set(newStatus: true, forNotificationChannel: channel) { result in
                                switch result {
                                case .success(let newChannel):
                                    // Channel enabled successfully
                                    if isFromBG {
                                        MOLTheme.channels.append(newChannel)
                                        MOLTheme.isChannelChangedFromBG = true
                                        MOLTheme.QuizzersetChannelFromBGTo = true
                                    }
                                    break
                                case .failure(let error):
                                    Constants.print(error.localizedDescription)
                                }
                                dispatchGroup.leave() // Moved here to ensure it waits for async completion
                            }
                        }

                        dispatchGroup.leave() // Leave after starting all async tasks

                        dispatchGroup.notify(queue: .main) {
                            self.checkNotificationSavedTime()
                            NotificationCenter.default.post(name: MOLTheme.RefreshNotificationsChannelSubViews, object: nil)
                        }

                    case .failure(let error):
                        Constants.print(error.localizedDescription)
                    }
                }
            } else {
                dispatchGroup.enter()
                GameNotificationsManager.channels(for: MOLTheme.currentGameID ?? "quiz") { [weak self] result in
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let channels):
                        
                        
                        for channel in channels {
                            dispatchGroup.enter()
                            GameNotificationsManager.set(newStatus: false, forNotificationChannel: channel) { result in
                                switch result {
                                case .success(let newChannel):
                                    // Channel disabled successfully
                                    if isFromBG {
                                        MOLTheme.channels.append(newChannel)
                                        MOLTheme.isChannelChangedFromBG = true
                                        MOLTheme.QuizzersetChannelFromBGTo = false
                                    }
                                    break
                                case .failure(let error):
                                    Constants.print(error.localizedDescription)
                                }
                                dispatchGroup.leave() // Moved here to ensure it waits for async completion
                            }
                        }
                        
                        dispatchGroup.leave() // Leave after starting all async tasks
                        
                        dispatchGroup.notify(queue: .main) {
                            self.checkNotificationSavedTime()
                            NotificationCenter.default.post(name: MOLTheme.RefreshNotificationsChannelSubViews, object: nil)
                        }
                        
                    case .failure(let error):
                        Constants.print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func CheckNotification() {
        
        //MARK: - ||STEP 1|| App Notification status - check if push notifications are enabled on App's level
        
        GameNotificationsManager.isNotificationsGranted { granted in
            if  granted == .authorized {
                DispatchQueue.main.async {
                    // ||STEP 3|| Get Game Notification Channels
                    GameNotificationsManager.channels(for: MOLTheme.currentGameID ?? "quiz") { result in
                        switch result {
                        case.success(let channels):
                            ///check channel more then 1 show all channel else first dirrectly enabled
                            if channels.count > 1 {
                                self.promptUserToEnableChannels()
                            }else{
                                if let channel = channels.first {
                                    GameNotificationsManager.set(newStatus: true, forNotificationChannel: channel) { result in
                                        self.removeNotificationCard()
                                        //self.showToast(type: .none, message: "notifPermissionGrantedToastMsg".getTranslationValue(default: "Notifications activated"), icon: "icon_notification")
                                    }
                                }
                            }
                            
                        case .failure(_):
                            //App Notification status enabled but couldn't get channels of push notifications so keep on showing notifications card on fantasy overview
                            self.showNotificationCard = true
                        }
                    }
                }
            } else {
                //MARK: - ||STEP 2|| PROMPT USER TO Enable Push Notifications on App
                
                GameNotificationsManager.enableSystemNotifications(gameId: MOLTheme.currentGameID ?? "quiz") { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let status):
                        if status {
                            //Once user allows permission ask them to enable their respective channels
                            self.setStatusforallChannels()
                        } else {
                            DispatchQueue.main.async {
                                //Once user declines to go to settings ask them to enable notification by showing popuop
                                self.setStatusforallChannels()
                                GameNotificationsManager.channels(for: MOLTheme.currentGameID ?? "quiz") { result in
                                    switch result {
                                    case.success(let channels):
                                        
                                        ///check channel more then 1 show all channel else first dirrectly enabled
                                        if channels.count > 1 {
                                            self.promptUserToEnableChannels()
                                        } else {
                                            self.showNotificationCard = true
                                        }
                                        
                                    case .failure(_):
                                        //App Notification status enabled but couldn't get channels of push notifications so keep on showing notifications card on fantasy overview
                                        self.showNotificationCard = true
                                    }
                                }
                            }
                        }
                    case .failure(let error):
                        Constants.print(error)
                        DispatchQueue.main.async {
                            //Once user declines persmissions ask them to enable notification by showing popuop
                            self.setStatusforallChannels()
                            // no need to show alert again- agian
                        }
                    }
                }
            }
        }
    }
    
    func removeNotificationCard() {
#warning("Implement removal of notification card logic here")
        self.showNotificationCard = false
//        if self.showNotificationCard == false{
//            
//        }
//        if let index = self.viewmodel.homeCards.firstIndex(of: .NOTIFICATION_CARD) {
//            DispatchQueue.main.async {
//                
//                if (self.viewmodel.homeCards[safe: index] != nil) {
//                    
//                    self.viewmodel.homeCards.remove(at: index)
//                    self.homeTableView.layoutIfNeeded()
//                    self.homeTableView.reloadData()
//                    
//                }
//                
//            }
//        }
    }
    
    func showNotificationPopup() {
        #warning("Implement popup logic here")
        if UserDefaultsData.shared.homeScreenVisitedCount == 1{
            Track.shared.screen(screen: "/quiz-notifications", params: nil, replace: nil)
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.notificationPopUp = true
                UserDefaultsData.shared.homeScreenVisitedCount += 1
            }
        }

        //self.showCustomPopup(title: "notifPopupTitle".getTranslationValue(default: "Stay ahead of the game"), description: "notifPopupDescription".getTranslationValue(default: "Turn on notifications to get alerts about transfer deadlines, player injuries and points updates."), attributedDescription: nil, icon: "icon_notification", btnHighlightedText: "notifOnBtn".getTranslationValue(default: "Turn on notification"), btnNormalText: "notNowBtn".getTranslationValue(default: "Not now"))
    }
    
    func didCloseNotificationCard() {
#warning("Implement tracking logic")
        //Track.shared.cardClick(cardName: "card-notification", variant: "Dismiss")
        UserDefaultsData.shared.notificationPopupDismissTimeStamp = Date()
        showNotificationCard = false
#warning("Implement toast here")
        showToast = true
        //self.showToast(type: .none, message: "notifPermissionDeclineToastMsg".getTranslationValue(default: "You can turn on notifications at any time from your Gaming Hub profile"), icon: "icon_notif_disable_toast")
    }
    
    func didClickNotificationPermission() {
#warning("Implement tracking logic")
        //Track.shared.cardClick(cardName: "card-notification", variant: "Open notifications")
                self.CheckNotification()
    }
    
}
