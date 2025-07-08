//
//  QuizImageEnum.swift
//  QuizeApp
//
//  Created by Vishal Vijayvargiya on 21/08/23.
//

import Foundation

enum QuizImageName:String{
    case QPSDKBackGroundImage = "BG"
    case QPSDKAdsImage = "QPSDKAdsPSL"
    case QSDKtrofiBanner = "trofiBanner"
    case QSDKSplashIPhoneBG = "QSDKSplashIPhoneBG"
    case QSDKSplashIPadLandscapeBG = "QSDKSplashIPadLandscapeBG"
    case QSDKSplashIPadPortraitBG = "QSDKSplashIPadPortraitBG"
    case QSDKLOGO = "QSDKLOGO"
    case quizspashLogo = "quizspashLogo"
    case quizspashIpadLogo = "quizspashIpadLogo"
    case QSDKNavigationBG = "QSDKNavigationBG"
    case QSDKAdsSponsors = "QSDKAdsSponsors"
    case QSDKAnsCorrect = "QSDKAnsCorrect"
    case QSDKInCorrect = "QSDKInCorrect"
    case QSDK_Cross = "QSDK_Cross"
    case QSDK_NavBack = "QSDK_NavBack"
    case QSDK_Menu = "QSDK_Menu"
    case QSDK_NavOption = "QSDK_NavOption"
    case QSDK_Rmedia = "QSDK_Rmedia"
    case QSDK_GamingAvatarRed = "QSDK_GamingAvatarRed"
    case QSDK_PointBg  = "QSDK_PointBg"
    case QSDK_RightArrow = "QSDK_RightArrow"
    case QSDK_TrendDown = "QSDK_TrendDown"
    case QSDK_TrendUp = "QSDK_TrendUp"
    case QSDK_SmallBack = "QSDK_SmallBack"
    case QSDKCountdownBG = "QSDKCountdownBG"
    case scoreBg = "scoreBg"
    case DailyQuizicon = "DailyQuizicon"
    case RandomQuizicon = "RandomQuizicon"
    case QSDKShare = "QSDKShare"
    case QSDK_QuestionProgressCorrect = "QSDK_QuestionProgressCorrect"
    case QSDK_NavigationClose = "QSDK_NavigationClose"
    case QSDK_NotificationClose = "QSDK_NotificationClose"
    case QSDK_50_50Wildcard = "QSDK_50-50Wildcard"
    case QSDK_Var = "QSDK_Var"
    case QSDK_Dayily = "QSDK_Dayily"
    case QSDK_InviteFrnd = "QSDK_InviteFrnd"
    case QSDK_streak = "QSDK_streak"
    case scoreBglandscape = "scoreBglandscape"
    case QSDK_used_Vra = "QSDK_used_Vra"
    case QSDK_star = "QSDK_star"
    case score_Char_1 = "scoreChar1"
    case score_Char_2 = "scoreChar2"
    case score_Char_3 = "scoreChar3"
    case score_Char_4 = "scoreChar4"
    case score_Char_5 = "scoreChar5"
    case QSDK_icon_crown = "QSDK_icon_crown"
    case QSDK_Alert = "QSDK_Alert"
    case QSDK_Notification = "QSDK_Notification"
    case QSDK_NotificationPopUpClose 
    
    //MORE Less
    
    case ML_Sub_in = "ML_Sub_in"
    case ML_Sub_off = "ML_Sub_off"
    case ML_Switch = "ML_Switch"
    case ML_addedTime = "ML_addedTime"
    case ML_Correct = "ML_Correct"
    case ML_Incorrect = "ML_Incorrect"
    case Ml_Streak = "Ml_Streak"
    case QSDK_MOl = "QSDK_MOl"
    case ML_PlayerPlaceholder = "ML_PlayerPlaceholder"
    
    
    //EURO
    case QSDK_EurosTopNavigationBar = "QSDK_EurosTopNavigationBar"
    case QSDK_Streak_Left = "QSDK_Streak_Left"
    case QSDK_Streak_Right = "QSDK_Streak_Right"
    case euroQuizView = "euroQuizView"
    case euroStadTop = "euroStadTop"
    var name: String { self.rawValue }
}
