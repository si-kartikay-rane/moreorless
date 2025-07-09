//
//  NotificationToastView.swift
//  quiz
//
//  Created by Kartikay Rane on 22/05/25.
//

import SwiftUI

struct NotificationToastView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var showToast: Bool
    
    var body: some View {
        if !MOLTheme.isIpad {
        HStack(alignment: .center, spacing: 12) {
            VStack{
                Spacer()
                Divider()
                Spacer()
            }
            .background(MOLTheme.getColor(named: .QSDK_465AEE))
            .frame(width: 3)
            Circle()
                .fill(MOLTheme.getColor(named: .QSDK_465AEE))
                .frame(width: 48, height: 48)
                .padding(.top, 4)
                .overlay(
                    Image(uiImage: MOLTheme.getImage(named: MOLTheme.currentGameID != "euromoreorless" ? MolImageName.QSDK_NotificationClose.name : "") ?? UIImage())
                        .resizable()
                        .frame(width: 24, height: 24)
                )
            
            // Message text
            Text(NotificationStrings.notificationToastMessage.getTranslationValue(default: "You can turn on notifications anytime from your profile"))
                .font(Font.swiftUICustomFont(customFont: .SF_UI_Regular, size: 16))
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            VStack{
                Button(action: {
                    showToast = false
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
                Spacer()
            }
            .padding([.top,.trailing],12)
        }
        .frame(height: 100)
        .background(Color(.systemGray6))
        .cornerRadius(2)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
        .padding(.horizontal, 12)
        .padding(.bottom, 32.0)
        } else {
            HStack(alignment: .center, spacing: 12) {
                VStack{
                    Spacer()
                    Divider()
                    Spacer()
                }
                .background(MOLTheme.getColor(named: .QSDK_465AEE))
                .frame(width: 3)
                Circle()
                    .fill(MOLTheme.getColor(named: .QSDK_465AEE))
                    .frame(width: 48, height: 48)
                    .padding(.top, 4)
                    .overlay(
                        Image(uiImage: MOLTheme.getImage(named: MOLTheme.currentGameID != "euromoreorless" ? MolImageName.QSDK_NotificationClose.name : "") ?? UIImage())
                            .resizable()
                            .frame(width: 24, height: 24)
                    )
                
                // Message text
                Text(NotificationStrings.notificationToastMessage.getTranslationValue(default: "You can turn on notifications anytime from your profile"))
                    .font(Font.swiftUICustomFont(customFont: .SF_UI_Regular, size: 16))
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                VStack{
                    Button(action: {
                        showToast = false
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
                    Spacer()
                }
                .padding([.top,.trailing],12)
            }
            .frame(width: UIScreen.screenWidth * 0.75,  height: 100)
            .background(Color(.systemGray6))
            .cornerRadius(2)
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
            .padding(.bottom, 100.0)
            
        }
    }
}

//#Preview {
//    NotificationToastView()
//}
