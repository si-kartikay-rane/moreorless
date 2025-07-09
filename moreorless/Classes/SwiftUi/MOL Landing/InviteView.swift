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
                        .foregroundColor(MOLTheme.getColor(named: .QPSDKWhite))
                    
                    if MOLTheme.isIpad {
                        
                        Button(action: {
                            isIpadpresentActivity = true
                            
                            let g4a = QuizzerAnalyticsInviteFriends()
                            Track.shared.event(G4A: g4a, name: current_screen_name, params: nil)
                            
                        }, label: {
                            Text(AppStrings.sharecardinvitefriends.getTranslationValue(default: "Invite friends")).font(Font.swiftUICustomFont(customFont: .SF_UI_Medium, size: 14))
                                .foregroundColor(MOLTheme.getColor(named: .QPSDKPrimary))
                        }).popover(isPresented: $isIpadpresentActivity) {
                        
                            
                            MNTCustSimplyShareViewController(activityItems: [sharedata?.loadText?.getTranslationValue(default: "") as Any ,URL(string: shareURls.invitefrnd + (MOLTheme.currentGameID ?? "uclmoreorless"))!]) { completed, returnedItems, activityError in
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
                                .foregroundColor(MOLTheme.getColor(named: .QPSDKPrimary))
                        })
                    }
                }.padding([.bottom,.top,.leading],MOLTheme.isIpad ? 16 : 16)
                Spacer()
                VStack {
                    Image(uiImage: MOLTheme.getImage(named: MOLTheme.currentGameID != "euromoreorless" ? MolImageName.QSDK_InviteFrnd.name : "") ?? UIImage())
                        .resizable()
                        //.scaledToFill()
                }.frame(maxWidth:  72, maxHeight:  72)
                    .padding([.bottom,.top,.leading],  MOLTheme.currentGameID == "euromoreorless" ? 0 : MOLTheme.isIpad ? 16 : 16)
                    
            }.background(HStack{Spacer()
                Image(uiImage: MOLTheme.getImage(named:   MOLTheme.currentGameID == "euromoreorless" ? MolImageName.QSDK_InviteFrnd.name : "") ?? UIImage()).resizable().frame(width: 216,alignment: .trailing)
            })
            .padding(.trailing, MOLTheme.currentGameID == "euromoreorless" ? 0 :  MOLTheme.isIpad ? 20 : 16)
        }.background(ActivityViewPresenter(isPresented: $presentActivity, items: [sharedata?.loadText?.getTranslationValue(default: "") as Any,URL(string: shareURls.invitefrnd + (MOLTheme.currentGameID ?? "uclmoreorless"))!]){ completed, returnedItems, activityError in
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
        .background(MOLTheme.getColor(named: .QSDK_0A0A61))
        .cornerRadius(14)
    }
}

