//
//  NoticationPopView.swift
//  quiz
//
//  Created by Kartikay Rane on 20/05/25.
//

import SwiftUI
import GamesLib

struct NoticationPopView: View {
    
    @Binding var notificationPopUp : Bool
    @State private var isPresented: Bool = true
    @State private var isGranted: Bool = true
    @State private var isFromRefreshView: Bool = false
    @State private var channels: [GameNotificationChannel] = []

    var body: some View {
        ZStack(alignment: .bottom) {
            if !MOLTheme.isIpad {
                VStack{
                Spacer()
                VStack(spacing: 0) {
                    VStack(spacing: 0){
                        HStack {
                            Spacer()
                            Button(action: { notificationPopUp = false }) {
                                MOLTheme.getImage(named:QuizImageName.QSDK_NotificationPopUpClose.name)?
                                    .foregroundColor(.white)
                                    .frame(width: 24, height: 24)
                                    .background(Color.white.opacity(0.2))
                                    .clipShape(Circle())
                            }
                            .padding([.trailing, .top], 16)
                        }
                        
                        Text(NotificationStrings.notificationalertChannelPopupTitle.getTranslationValue(default: "Push notifications"))
                            .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 20))
                            .foregroundColor(MOLTheme.getColor(named: .QSDK_boosterWhiteColor))
                            .padding(.bottom, 24)
                    }
                    
                    VStack(spacing: 24) {
                        Divider().background(MOLTheme.getColor(named: .QPSDKWhite).opacity(0.75))
                        ForEach(channels, id: \.id) { channel in
                            ToggleRow(
                                isGranted: isGranted,
                                channel: channel,
                                isFromBG: isFromRefreshView,
                                completion: {
                                    refreshNotifications()
                                })
                            Divider().background(MOLTheme.getColor(named: .QPSDKWhite).opacity(0.75))
                        }
                        .padding(.bottom, 3)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                }
                .frame(maxWidth: .infinity)
                .background(MOLTheme.getColor(named: .QSDK_0A0A61))
                .quizCornerRadius(24.0, corners: [.topLeft,.topRight])
                .shadow(radius: 20)
                
            }
                .padding(.horizontal, 8)
            } else {
                    VStack(spacing: 0) {
                        VStack(spacing: 0){
                            HStack {
                                Spacer()
                                Button(action: { notificationPopUp = false }) {
                                    MOLTheme.getImage(named:QuizImageName.QSDK_NotificationPopUpClose.name)?
                                        .foregroundColor(.white)
                                        .frame(width: 24, height: 24)
                                        .background(Color.white.opacity(0.2))
                                        .clipShape(Circle())
                                }
                                .padding([.trailing, .top], 16)
                            }
                            
                            Text(NotificationStrings.notificationalertChannelPopupTitle.getTranslationValue(default: "Push notifications"))
                                .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 20))
                                .foregroundColor(MOLTheme.getColor(named: .QSDK_boosterWhiteColor))
                                .padding(.bottom, 24)
                        }
                        
                        VStack(spacing: 24) {
                            Divider().background(MOLTheme.getColor(named: .QPSDKWhite).opacity(0.75))
                            ForEach(channels, id: \.id) { channel in
                                ToggleRow(
                                    isGranted: isGranted,
                                    channel: channel,
                                    isFromBG: isFromRefreshView,
                                    completion: {
                                        refreshNotifications()
                                    })
                                Divider().background(MOLTheme.getColor(named: .QPSDKWhite).opacity(0.75))
                            }
                            .padding(.bottom, 3)
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 32)
                    }
                    .frame(width: UIScreen.screenWidth * 0.50)
                    .background(MOLTheme.getColor(named: .QSDK_0A0A61))
                    .quizCornerRadius(24.0, corners: .allCorners)
                    .shadow(radius: 20)

                
                .padding(.horizontal, 8)
            }
        }
        .quizconditionalSafeArea( MOLTheme.isGamingHubHost)
//        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            Track.shared.screen(screen: "/push-notification-dialog", params: nil)
            setupObservers()
            initialSetup()
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self)
        }
        
    }
    
    func initialSetup() {
       refreshNotifications()
   }
   
    func refreshNotifications() {
        
       GameNotificationsManager.isNotificationsGranted { status in
           DispatchQueue.main.async {
               isGranted = status == .authorized
               fetchChannels()
           }
       }
   }
   
   func fetchChannels() {
       if isFromRefreshView {
           if !MOLTheme.channels.isEmpty {
               channels = MOLTheme.channels.sorted { $0.id < $1.id }
           } else {
               getRemoteChannels()
           }
       } else {
           getRemoteChannels()
       }
   }
   
   func getRemoteChannels() {
       GameNotificationsManager.channels(for: MOLTheme.currentGameID ?? "uclmoreorless") { result in
           DispatchQueue.main.async {
               switch result {
               case .success(let remoteChannels):
                   channels = remoteChannels
               case .failure(let error):
                   Constants.print(error)
               }
           }
       }
   }
   
   func setupObservers() {
       NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { _ in
           initialSetup()
       }
       NotificationCenter.default.addObserver(forName: MOLTheme.RefreshNotificationsChannelSubViews, object: nil, queue: .main) { _ in
           isFromRefreshView = true
//           initialSetup()
       }
   }
//    }
}

struct ToggleRow: View {

    @State var isGranted: Bool
    var channel: GameNotificationChannel
    var isFromBG: Bool
    var completion: (() -> Void)?
    @State var isOn: Bool = false
    
    var body: some View {
        VStack{
            HStack {
                Text(channel.title)
                    .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 16))
                    .foregroundColor(MOLTheme.getColor(named: .QSDK_boosterWhiteColor))
                Spacer()
                Toggle("", isOn: $isOn)
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: MOLTheme.getColor(named: .QPSDKPrimary)))
                    
            }
            .onChange(of: isOn) { newValue in
                if !isOn && !isGranted{
                    //Nothing to be handled here
                }else{
                    handleToggleChange(newValue)
                }
                
            }
        }
        .onAppear {
            initializeToggleState()
        }
        .quizconditionalSafeArea( MOLTheme.isGamingHubHost)
    }
    
    
     func initializeToggleState() {
        if MOLTheme.isChannelChangedFromBG && isGranted {
            isOn = true
        } else if isGranted {
            isOn = channel.status
        } else {
            isOn = false
        }
    }

     func handleToggleChange(_ newValue: Bool) {
        if isGranted {
            GameNotificationsManager.set(newStatus: newValue, forNotificationChannel: channel) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let updatedChannel):
                        isOn = updatedChannel.status
                    case .failure(let error):
                        Constants.print(error)
                        isOn.toggle()
                    }
                }
            }
        } else {
            GameNotificationsManager.enableSystemNotifications(gameId: MOLTheme.currentGameID ?? "weuromoreorless") { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let status):
                        if status {
                            completion?()
                        } else {
                            isOn = false
                        }
                    case .failure(let error):
                        Constants.print(error)
                        isOn = false
                    }
                }
            }
        }
        
        NotificationCenter.default.post(name: MOLTheme.QuizNotificationChannelStatusChanged, object: nil)
    }

}


extension View {
    @ViewBuilder
    func quizconditionalSafeArea(_ condition: Bool) -> some View {
        if condition {
            self.edgesIgnoringSafeArea(.bottom)
        } else {
            self
        }
    }
}
