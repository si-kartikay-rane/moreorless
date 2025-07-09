//
//  App Strings.swift
//  UEFAQuizSDK
//
//  Created by Vishal Vijayvargiya on 24/08/23.
//

import SwiftUI

/// This file contains all strings that are being used in app for the convinience of changes as it's centralized
/// This will also help with localization i.e changing app Languages

final class AppStrings {
    //spalsh
    static let TitleApp = "quiz_hub"
    static let PresentedBy = "quizzes"
    //Home
    static let LandingTitle = "gaming_hub_title"
    static let Leaderboards = "leaderboards"
    static let ButtonBrowsequizzes = "browse_quizzes"
    static let sharecardmessage = "share_card_message"
    static let sharecardinvitefriends = "share_card_invite_friends"
    static let Viewallleaderboards = "view_all_leaderboards"
    static let quiz_card_rank_and_points = "quiz_card_rank_and_points"
    static let comebacktomorrow = "come_back_tomorrow"
    static let comebacksoon = "check_back_soon"
    static let winner_title =  "winner_title"
    // leaderboard menu
    static let Leaderboard = "leaderboard_table_columnheader1"
    static let leaderboard_ranking_title = "leaderboard_ranking_title"
    static let Rank = "rank"
    static let points_leaderboard = "points_leaderboard"
    static let correct_percentage = "correct_percentage"
    //quiz game
    static let TIME_S_UP = "time_s_up"
    static let Total = "total"
    static let Pts = "pts"
    static let quiz_starts_in =   "prequiz_countdowntimer"
    static let boosteractive = "booster_active"
    static let boosterplayed = "booster_played"
    static let booster1  = "booster_1" //50-50
    static let booster2 = "booster_2" //vra
    static let tap_to_skip = "prequiz_tap_to_skip" 
    static let resultscorestreaks = "result_score_streaks"
    static let yourboosters = "your_boosters"
    static let Incorrect = "incorrect"
    static let Correct = "correct"
    static let exityes = "exit_game_submit_button_text"
    static let exitNo = "exit_game_cancel_button_text"
    static let exit_title = "exit_game_title"
    static let exit_sub_title = "exit_game_sub_title"
    static let DailyQuiz = "leaderboard_daily_quiz"
    static let RandomQuiz = "leaderboard_fun_quiz"
    static let quiz_streak_text = "quiz_streak_text"
    // resulte
    static let correct_answer  = "result_correct_answer"
    static let streak_desc = "result_x_points_streak"
    static let correct_ans_desc_quiz = "result_x_points"
    static let score_streaks = "result_score_streaks"
    static let resultyourrankquiz = "result_your_rank_for_this_quiz"
    static let resultyourrankatquiz = "result_your_rank_at_quiz"
    static let result_next_quiz_start_in = "result_next_quiz_start_in"
    static let result_next_quiz_hours = "result_next_quiz_hours"
    static let result_next_quiz_minute = "result_next_quiz_minute"
    static let result_score_out_of = "result_score_out_of"
    static let resultyourscore  = "result_your_score"
    
    //timeleft
    static let card_next_game_start_time = "card_next_game_start_time"
    static let quizcard_currentgame_timeleft =  "quizcard_currentgame_timeleft"  //{timestamp} left
    static let quizcard_game_hrs = "quizcard_game_hrs" //{hours} hrs
    static let quizcard_game_hr =  "quizcard_game_hr" //{hours} hr
    static let quizcard_game_mins =  "quizcard_game_mins" //{minute} mins
    static let quizcard_game_min =  "quizcard_game_min" //{minute} min
    static let game_card_end_text = "game_card_end_text"
    static let Point = "Points"
    static let quizzes_played = "Quizzes played:"
    static let game_card_coming_soon_text = "game_card_coming_soon_text"
   
    
    static let play_again = "result_play_again_button"
    static let go_to_quiz_arena = "result_go_back_button_text"
    static let login_or_register = "result_login_button"
    static let load_50_more_rows = "leaderboard_load_more"
    static let logintoplay = "login_to_play"
    static let Tryasguest = "try_as_guest"
   
    static let players = "leaderboard_total_player_text"
    static let nonLoginScoreRanktitle = "result_guest_rank_message"
    static let nonLoginScoreRankDescription = "result_guest_position_message"
    static let quiz_type_title = "quiz_type_title_{quizId}"
    //popup
    static let ok = "OK"
    static let NO_INTERNET = "No Internet Connection"
    static let INTERNET_AVAILABLE = "Please relaunch the app"
    
    static let mlScore = "mol_game_total"
    static let mlStreak = "mol_game_streak"
    
    static let result_go_back_button_text_3 = "result_go_back_button_text_3"
    static let result_play_again_button_3 = "result_play_again_button_3"
    static let result_your_score_3 = "result_your_score_3"
    static let result_score_out_of_3 = "result_score_out_of_3"
    static let result_correct_answer_3 = "result_correct_answer_3"
    static let correct_ans_desc_mol = "result_x_points_game"
    static let result_your_rank_for_this_quiz_3 = "result_your_rank_for_this_quiz_3"
    static let result_your_rank_at_quiz_3 = "result_your_rank_at_quiz_3"
    static let result_guest_rank_message_3 = "result_guest_rank_message_3"
    static let result_guest_position_message_3 = "result_guest_position_message_3"
    
    //Difficulty Level Card With Timer
    static let difficulty_card_title = "difficulty_card_title"
    static let difficulty_card_subtitle = "difficulty_card_subtitle"
    static let difficulty_card_timer_text = "difficulty_card_timer_text"
    
    
    // Notifications
    static let notifcation_card_title = "notifcation_card_title"
    static let notifcation_card_btn = "notifcation_card_btn"
    
    static let notification_alert_title = "notification_alert_title"
    static let notification_alert_description = "notification_alert_description"
    static let notification_alert_Btn1 = "notification_alert_Btn1"
    static let notification_alert_Btn2 = "notification_alert_Btn2"
    
    static let notification_channel_popup_title = "notification_channel_popup_title"
    
    static let notification_toast_message = "notification_toast_message"
    
}

final class screenName {
    static let  splashScreen = "/splash-screen"
    static let  overview = "/overview"
    static let  quizGameplay = "/quiz-gameplay"
    static let  quizResult = "/quiz-result"
    static let  league = "/league"
    static let  leaderboard = "/leaderboard"
}

final class quiztypeTracking{
    static let dailyquiz = "daily_quiz"
    static let randomquiz = "random_quiz"
}

final class shareURls{
    static let invitefrnd = AppBaseURLs.shareDomin + "/\(QuizzGameSDk.game.getAppLanguage())/"
    static let leaderBoard = AppBaseURLs.shareDomin + "/\(QuizzGameSDk.game.getAppLanguage())/"
    static let gamePlay = AppBaseURLs.shareDomin + "/\(QuizzGameSDk.game.getAppLanguage())/\(MOLTheme.currentGameID ?? "uclquiz")"
    static let scorescreen  = AppBaseURLs.shareDomin + "/\(QuizzGameSDk.game.getAppLanguage())/"
    
}


final class NotificationStrings {
    static let notificationcardTitle = "notification_card_title"
    static let notificationCardbutton = "notification_card_btn"
    static let notificationCardAlertTitle = "notification_alert_title"
    static let notificationCardAlertdesc =  "notification_alert_description"
    static let notificationalertbuttonOne = "notification_alert_Btn1"
    static let notificationalertbuttonTne = "notification_alert_Btn2"
    static let notificationalertChannelPopupTitle = "notification_channel_popup_title"
    static let notificationToastMessage = "notification_toast_message"
    static let kebabmenunotificationTitle = "kebab_menu_notification_title"
}
