//
//  NotificationAlertView.swift
//  quiz
//
//  Created by Kartikay Rane on 21/05/25.
//

import SwiftUI

struct NotificationAlertView: View {
    
    let title: String
    let description: String
    let attributedDescription: NSAttributedString?
    let icon: Image
    let btnHighlightedText: String
    let btnNormalText: String
    @Binding var notificationAlertPopUp : Bool
    @Binding var notificationPopUp : Bool
    @Binding var showToast: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            if !MOLTheme.isIpad {
                VStack{
                    Spacer()
                    VStack(spacing: 0) {
                        HStack {
                            Spacer()
                            Button(action: {
                                notificationAlertPopUp = false
                                showToast = true
                            }) {
                                VStack{
                                    Image(uiImage: MOLTheme.getImage(named: MOLTheme.currentGameID != "euromoreorless" ? MolImageName.QSDK_NavigationClose.name : "") ?? UIImage())
                                        .renderingMode(.template)
                                        .resizable()
                                        .foregroundColor(MOLTheme.getColor(named: .QSDK_9E9AA5))
                                        .frame(width: 15, height: 15)
                                }
                                .frame(width: 24, height: 24)
                                .background(MOLTheme.getColor(named: .QSDK_boosterWhiteColor))
                                .clipShape(Circle())
                            }
                            .padding(12)
                        }
                        .padding(.trailing, 8)
                        .padding(.top, 8)
                        VStack(spacing: 28){
                            VStack(spacing: 16){
                                icon
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                VStack(spacing: 8){
                                    Text(title)
                                        .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 20))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(MOLTheme.getColor(named: .QSDK_1A313C))
                                    
                                    Text(description)
                                        .font(Font.swiftUICustomFont(customFont: .SF_UI_Regular, size: 16))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(MOLTheme.getColor(named: .QSDK_1A313C))
                                    
                                }
                            }
                            
                            VStack(spacing: 12) {
                                Button {
                                    Track.shared.event(screen: "/gh_notifications_enabled")
                                    notificationAlertPopUp = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                                        notificationPopUp = true
                                    }
                                } label: {
                                    HStack{
                                        Spacer()
                                        Text(btnHighlightedText)
                                            .padding(.vertical,15)
                                            .font(Font.swiftUICustomFont(customFont: .SF_UI_Bold, size: 16))
                                            .multilineTextAlignment(.leading)
                                            .foregroundColor(MOLTheme.getColor(named: .QPSDKWhite))
                                        
                                        Spacer()
                                    }
                                    .background(MOLTheme.getColor(named: .QSDK_D91D41))
                                    .cornerRadius(15)
                                }
                                
                                Button {
                                    Track.shared.event(screen: "/gh_notifications_disabled")
                                    notificationAlertPopUp = false
                                    showToast = true
                                } label: {
                                    HStack{
                                        Spacer()
                                        Text(btnNormalText)
                                            .font(Font.swiftUICustomFont(customFont: .SF_UI_Bold, size: 16))
                                            .multilineTextAlignment(.leading)
                                            .foregroundColor(MOLTheme.getColor(named: .QSDK_CB333B))
                                            .padding(.vertical,15)
                                        Spacer()
                                    }
                                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(MOLTheme.getColor(named: .QSDK_D91D41)))
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.bottom, 50)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(MOLTheme.getColor(named: .QSDK_EEF7F9))
                    .quizCornerRadius(24.0, corners: [.topLeft,.topRight])
                    .shadow(radius: 20)
                    
                }
                .padding(.horizontal, 8)
            } else {
                VStack {
                    VStack(spacing: 0) {
                        VStack(spacing: 28){
                            
                            VStack(alignment: .leading, spacing: 8){
                                HStack(alignment: .top) {
                                    
                                    VStack(alignment: .leading, spacing: 16.0) {
                                        Text(title)
                                            .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 26))
                                            .multilineTextAlignment(.leading)
                                            .foregroundColor(MOLTheme.getColor(named: .QSDK_1A313C))
                                        
                                        Text(description)
                                            .font(Font.swiftUICustomFont(customFont: .SF_UI_Regular, size: 16))
                                            .multilineTextAlignment(.leading)
                                            .foregroundColor(MOLTheme.getColor(named: .QSDK_1A313C))
                                    }
                                    
                                    Spacer()
                                    
                                    icon
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                }
                                
                            }
                            .padding(.top, 24)
                            .padding()
                            
                            HStack {
                                Spacer()
                                Button {
                                    Track.shared.event(screen: "/gh_notifications_disabled")
                                    NotificationCenter.default.post(name: MOLTheme.QuizNotificationChannelStatusChanged, object: nil)
                                    notificationAlertPopUp = false
                                } label: {
                                    HStack{
                                        Text(btnNormalText)
                                            .font(Font.swiftUICustomFont(customFont: .SF_UI_Bold, size: 16))
                                            .multilineTextAlignment(.leading)
                                            .foregroundColor(MOLTheme.getColor(named: .QSDK_CB333B))
                                            .padding(.vertical,15)
                                    }.padding(.horizontal)
                                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(MOLTheme.getColor(named: .QSDK_D91D41)))
                                }
                                
                                Button {
                                    Track.shared.event(screen: "/gh_notifications_enabled")
                                    notificationAlertPopUp = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                                        notificationPopUp = true
                                    }
                                } label: {
                                    HStack{
                                        Text(btnHighlightedText)
                                            .padding(.vertical,15)
                                            .font(Font.swiftUICustomFont(customFont: .SF_UI_Bold, size: 16))
                                            .multilineTextAlignment(.leading)
                                            .foregroundColor(MOLTheme.getColor(named: .QPSDKWhite))
                                        
                                    }.padding(.horizontal)
                                    .background(MOLTheme.getColor(named: .QSDK_D91D41))
                                    .cornerRadius(15)
                                }
                                .padding(.leading, 8)
                                
                                
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 50)
                            
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .frame(width: UIScreen.screenWidth * 0.65)
                .background(MOLTheme.getColor(named: .QSDK_EEF7F9))
                .quizCornerRadius(24.0, corners: [.allCorners])
                .shadow(radius: 20)
                .padding(.horizontal, 8)
            }
        }
        .quizconditionalSafeArea( MOLTheme.isGamingHubHost)
        .onDisappear {
            NotificationCenter.default.removeObserver(self)
        }
        
    }
    
}

