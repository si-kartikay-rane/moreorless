//
//  InviteView.swift
//  quiz
//
//  Created by Vishal Vijayvargiya on 07/12/23.
//

import SwiftUI

struct InviteView: View {
//    var buttonAction: (Bool,CGRect) -> Void
    @State private var buttonRect: CGRect = .zero
    @State var presentActivity = false
    @State var isIpadpresentActivity =  false
    var current_screen_name : String
    let sharedata =  Constants.configData?.socialShare?.overview
    var body: some View {
        ZStack {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 16) {
                    Text(AppStrings.sharecardmessage.getTranslationValue(default:  "Challenge your friends on Quiz Arena!"))
                        .font(Font.swiftUICustomFont(customFont: .SF_UI_Bold, size: 16))
                        .multilineTextAlignment(.leading)
                        .foregroundColor(QUIZTheme.getColor(named: .QPSDKWhite))
                    
                    if QUIZTheme.isIpad {
                        
                        Button(action: {
                            isIpadpresentActivity = true
                            
                            let g4a = QuizzerAnalyticsInviteFriends()
                            Track.shared.event(G4A: g4a, name: current_screen_name, params: nil)
                            
                        }, label: {
                            Text(AppStrings.sharecardinvitefriends.getTranslationValue(default: "Invite friends")).font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 14))
                                .foregroundColor(QUIZTheme.getColor(named: .QPSDKPrimary))
                        }).popover(isPresented: $isIpadpresentActivity) {
                        
                            
                            MNTCustSimplyShareViewController(activityItems: [sharedata?.loadText?.getTranslationValue(default: "") as Any ,URL(string: shareURls.invitefrnd + (QUIZTheme.currentGameID ?? "uclquiz"))!]) { completed, returnedItems, activityError in
                                isIpadpresentActivity = false
                        }
                                
                        }
                        
                    } else {
                        
                        Button(action: {
                            presentActivity = true
                            
                            let g4a = QuizzerAnalyticsInviteFriends()
                            Track.shared.event(G4A: g4a, name: current_screen_name, params: nil)
                            
                        }, label: {
                            Text(AppStrings.sharecardinvitefriends.getTranslationValue(default: "Invite friends")).font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 14))
                                .foregroundColor(QUIZTheme.getColor(named: .QPSDKPrimary))
                        })
                    }
                }.padding([.bottom,.top,.leading],QUIZTheme.isIpad ? 16 : 16)
                Spacer()
                VStack {
                    Image(uiImage: QUIZTheme.getImage(named: QUIZTheme.currentGameID != "euroquiz" ? QuizImageName.QSDK_InviteFrnd.name : "") ?? UIImage())
                        .resizable()
                        //.scaledToFill()
                }.frame(maxWidth:  72, maxHeight:  72)
                    .padding([.bottom,.top,.leading],  QUIZTheme.currentGameID == "euroquiz" ? 0 : QUIZTheme.isIpad ? 16 : 16)
                    
            }.background(HStack{Spacer()
                Image(uiImage: QUIZTheme.getImage(named:   QUIZTheme.currentGameID == "euroquiz" ? QuizImageName.QSDK_InviteFrnd.name : "") ?? UIImage()).resizable().frame(width: 216,alignment: .trailing)
            })
            .padding(.trailing, QUIZTheme.currentGameID == "euroquiz" ? 0 :  QUIZTheme.isIpad ? 20 : 16)
        }.background(ActivityViewPresenter(isPresented: $presentActivity, items: [sharedata?.loadText?.getTranslationValue(default: "") as Any,URL(string: shareURls.invitefrnd + (QUIZTheme.currentGameID ?? "uclquiz"))!]){ completed, returnedItems, activityError in
            presentActivity = false
                     }
        
        
        )
        
//        .background(ActivityViewPresenter(isPresented: $presentActivity, items: [sharedata?.modalTitle?.getTranslationValue(default: "") as Any,sharedata?.modalDesc?.getTranslationValue(default: "") as Any,sharedata?.loadText?.getTranslationValue(default: "") as Any,URL(string: shareURls.invitefrnd)!]){ completed, returnedItems, activityError in
//            presentActivity = false
//                     }
//        
//        
//        )
        .frame(maxWidth: .infinity)
        .background(QUIZTheme.getColor(named: .QSDK_0A0A61))
        .cornerRadius(14)
    }
}

