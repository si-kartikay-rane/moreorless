//
//  NotificationView.swift
//  quiz
//
//  Created by Kartikay Rane on 20/05/25.
//

import SwiftUI

struct NotificationsView: View {
    @ObservedObject var notificationsvm : QuizNotificationsViewModel
    
    var body: some View {
            ZStack {
                HStack {
                    VStack(alignment: .leading, spacing: 18.0) {
                        
                        Text(NotificationStrings.notificationcardTitle.getTranslationValue(default: "Never miss a Daily Quiz"))
                            .font(Font.swiftUICustomFont(customFont: .SF_UI_Bold, size: 16))
                            .multilineTextAlignment(.leading)
                            .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                        
                        Button {
                            notificationsvm.didClickNotificationPermission()
                        } label: {
                            Text(NotificationStrings.notificationCardbutton.getTranslationValue(default: "Turn on notifications"))
                                .font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 14))
                                .foregroundColor(QUIZTheme.getColor(named: .QPSDKPrimary))
                        }
                        
                    }
                    .padding()
                    Spacer()
                    ZStack(alignment: .top){
                        VStack {
                            Image(uiImage: QUIZTheme.getImage(named: QUIZTheme.currentGameID != "euroquiz" ? QuizImageName.QSDK_Notification.name : "") ?? UIImage())
                                .resizable()
                            //.scaledToFill()
                        }.frame(width:  96, height:  96)
                            .padding(.trailing, QUIZTheme.currentGameID == "euroquiz" ? 0 :  QUIZTheme.isIpad ? 20 : 16)
                    }
                    .overlay(
                        VStack{
                            HStack{
                                Spacer()
                                Button(action: { notificationsvm.didCloseNotificationCard() }) {
                                    VStack{
                                        Image(uiImage: QUIZTheme.getImage(named: QUIZTheme.currentGameID != "euroquiz" ? QuizImageName.QSDK_NavigationClose.name : "") ?? UIImage())
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                    }
                                    .frame(width: 24, height: 24)
                                    .background(QUIZTheme.getColor(named: .QSDKButtonTitle00004B))
                                    .clipShape(Circle())
                                }
                                .padding([.top, .trailing], 8)
                            }
                            Spacer()
                        }
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 112)
            .background(QUIZTheme.getColor(named: .QSDK_0A0A61))
            .cornerRadius(14)
    }
}
