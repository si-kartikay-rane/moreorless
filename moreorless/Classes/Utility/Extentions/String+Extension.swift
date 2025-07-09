//
//  String+Extension.swift
//  QuizeApp
//
//  Created by Vishal Vijayvargiya on 21/08/23.
//

import UIKit

extension String {
    
    var toLocalize : String {
        return NSLocalizedString(self, comment: "")
    }
    
    static var empty: String {
        return ""
    }
       
    func intValue() -> Int{
        return Int(self) ?? 0
    }
    
    
    func doubleValue() -> Double{
        return Double(self) ?? 0.0
    }
    
    func isValidTeamName() -> Bool {
        let specialChars = "\'\"|\\/<>;"
        
        let charSet = CharacterSet.init(charactersIn: specialChars)
        
        if self.rangeOfCharacter(from: charSet) != nil{
            return false
        }else{
            return true
        }
    }
    
    func toMinuteString() -> String{
        return !self.isEmpty ? "\(self)'" : ""
    }
    
    

        // Helper function to calculate time until the next quiz
    func timeUntilNextQuiz() -> (String, String) {
        let now = Date()
           var calendar = Calendar.current
           calendar.timeZone = TimeZone(identifier: "UTC")!

           var nextQuizDate = calendar.startOfDay(for: now)
           nextQuizDate.addTimeInterval(24 * 60 * 60) // Adding 1 day
           nextQuizDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: nextQuizDate)!

           let distance = nextQuizDate.timeIntervalSince(now)

           let hours = Int(distance / 3600)
           let minutes = Int((distance.truncatingRemainder(dividingBy: 3600)) / 60)

           return (String(format: "%2d", abs(hours)), String(format: "%2d", abs(minutes)))
        }
    
//    func timeUntilNextQuizLanding() -> String {
//        import Foundation

    func timeUntilNextQuizLanding(disable:Int,endDate:String) -> String {
        
        let now = Date()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        var nextQuizDate = calendar.startOfDay(for: now)
        nextQuizDate.addTimeInterval(24 * 60 * 60) // Adding 1 day
        nextQuizDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: nextQuizDate)!
        
        let distance = nextQuizDate.timeIntervalSince(now)
        
        let hours = Int(distance / 3600)
        let minutes = Int((distance.truncatingRemainder(dividingBy: 3600)) / 60)
        
        
        
        if ((hours)) < 4 {
            if ((hours)) > 0 && minutes > 0 {
                // Display in the format: "X hrs Y mins left"
                return  AppStrings.quizcard_game_hrs.getTranslationValue(default: "{hrs} hrs").replacingOccurrences(of: NetworkConstants().urlKeys.hours, with: String(format: "%2d", abs(hours)))   + AppStrings.quizcard_game_mins.getTranslationValue(default: "{minute} mins").replacingOccurrences(of: NetworkConstants().urlKeys.minute, with: String(format: "%2d", abs(minutes))) + AppStrings.quizcard_currentgame_timeleft.getTranslationValue(default: "{timestamp} left").replacingOccurrences(of: NetworkConstants().urlKeys.timestamp, with: "").replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression, range: nil)
            } else if ((hours)) > 0 {
                // Display in the format: "X hrs left"
                return AppStrings.quizcard_game_hrs.getTranslationValue(default: "{hrs} hrs").replacingOccurrences(of: NetworkConstants().urlKeys.hours, with: String(format: "%2d", abs(hours)))  +  AppStrings.quizcard_currentgame_timeleft.getTranslationValue(default: "{timestamp} left").replacingOccurrences(of: NetworkConstants().urlKeys.timestamp, with: "")
            } else {
                // Display in the format: "Y mins left"
                return  AppStrings.quizcard_game_mins.getTranslationValue(default: "{minute} mins").replacingOccurrences(of: NetworkConstants().urlKeys.minute, with: String(format: "%2d", abs(minutes)))  +  AppStrings.quizcard_currentgame_timeleft.getTranslationValue(default: "{timestamp} left").replacingOccurrences(of: NetworkConstants().urlKeys.timestamp, with: "").replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression, range: nil)
            }
        } else {
            // Display in the format: "New quiz in X hrs"
            if disable != 0{
                if let passdata = hoursLeftOnSameDay(quizEndDateStr: endDate){
                    return  AppStrings.game_card_end_text.getTranslationValue(default: "Game ends in {timestamp} hrs").replacingOccurrences(of: NetworkConstants().urlKeys.timestamp, with: "") + AppStrings.quizcard_game_hrs.getTranslationValue(default: "{hours} hrs").replacingOccurrences(of: NetworkConstants().urlKeys.hours, with: String(format: "%2d", abs(hours))).replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression, range: nil)
                }else{
                    return  AppStrings.card_next_game_start_time.getTranslationValue(default: "Next quiz in").replacingOccurrences(of: NetworkConstants().urlKeys.timestamp, with: "")  + AppStrings.quizcard_game_hrs.getTranslationValue(default: "{hours} hrs").replacingOccurrences(of: NetworkConstants().urlKeys.hours, with: String(format: "%2d", abs(hours))).replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression, range: nil)
                }
            }else{
                if ((hours)) > 4 && minutes > 59 {
                    // Display in the format: "X hrs Y mins left"
                    return  AppStrings.quizcard_game_hrs.getTranslationValue(default: "{hrs} hrs").replacingOccurrences(of: NetworkConstants().urlKeys.hours, with: String(format: "%2d", abs(hours))) + AppStrings.quizcard_game_mins.getTranslationValue(default: "{minute} mins").replacingOccurrences(of: NetworkConstants().urlKeys.minute, with: String(format: "%2d", abs(minutes))) + AppStrings.quizcard_currentgame_timeleft.getTranslationValue(default: "{timestamp} left").replacingOccurrences(of: NetworkConstants().urlKeys.timestamp, with: "").replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression, range: nil)
                } else if ((hours)) > 0 {
                    // Display in the format: "X hrs left"
                    return AppStrings.quizcard_game_hrs.getTranslationValue(default: "{hrs} hrs").replacingOccurrences(of: NetworkConstants().urlKeys.hours, with: String(format: "%2d", abs(hours)))  +  AppStrings.quizcard_currentgame_timeleft.getTranslationValue(default: "{timestamp} left").replacingOccurrences(of: NetworkConstants().urlKeys.timestamp, with: "").replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression, range: nil)
                } else {
                    // Display in the format: "Y mins left"
                    return  AppStrings.quizcard_game_mins.getTranslationValue(default: "{minute} mins").replacingOccurrences(of: NetworkConstants().urlKeys.minute, with: String(format: "%2d", abs(minutes)))  +  AppStrings.quizcard_currentgame_timeleft.getTranslationValue(default: "{timestamp} left").replacingOccurrences(of: NetworkConstants().urlKeys.timestamp, with: "").replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression, range: nil)
                }
            }
        }
    }
    
    func formatDate(dateString: String) -> String? {
        let inputFormatter = DateFormatter()
           inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
           inputFormatter.locale = Locale(identifier: "en_US_POSIX")
           inputFormatter.timeZone = TimeZone(abbreviation: "UTC") // Adjust if your date format differs
        
        guard let date = inputFormatter.date(from: dateString) else {
            print("Date string is invalid")
            return nil
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMM"
        outputFormatter.locale = Locale(identifier: "en_US_POSIX") // Use appropriate locale
        
        let formattedDate = outputFormatter.string(from: date)
        return AppStrings.game_card_coming_soon_text.getTranslationValue(default: "Available from {date}").replacingOccurrences(of: NetworkConstants().urlKeys.date, with: formattedDate)
    }
    
    func hoursLeftOnSameDay(quizEndDateStr: String) -> String? {
        let inputFormatter = DateFormatter()
           inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
           inputFormatter.locale = Locale(identifier: "en_US_POSIX")
           inputFormatter.timeZone = TimeZone(abbreviation: "UTC")

        guard let quizEndDate = inputFormatter.date(from: quizEndDateStr) else {
            print("Error parsing quiz end date",quizEndDateStr)
            return nil
        }

        let currentDate = Date()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        // Check if the current date and quiz end date are equal in year, month, and day
        let comparisonComponents: Set<Calendar.Component> = [.year, .month, .day]
        let currentDateComponents = calendar.dateComponents(comparisonComponents, from: currentDate)
        let quizEndDateComponents = calendar.dateComponents(comparisonComponents, from: quizEndDate)

        if currentDateComponents == quizEndDateComponents {
            // Calculate how many hours are left
            let hourComponent = calendar.dateComponents([.hour], from: addOneDayToCurrentDate()!, to: quizEndDate)
            if let hourDiff = hourComponent.hour, hourDiff >= 0 {
                print("Hours left until quiz end: \(hourDiff)")
                return AppStrings.game_card_end_text.getTranslationValue(default: "Game ends in {timestamp} hrs").replacingOccurrences(of: NetworkConstants().urlKeys.timestamp, with: String(format: "%2d", abs(hourDiff)))
            } else {
                print("Quiz end time has passed today.")
                return "Game Close"
            }
        } else {
            print("Current date and quiz end date are not the same day.")
            return nil
        }
    }
    func addOneDayToCurrentDate() -> Date? {
        let currentDate = Date()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")! // Ensure the calendar uses UTC timezone
        
        // Attempt to add one day to the current date
        if let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDate) {
            // nextDay is a Date object, 1 day ahead of the current date, in UTC timezone
            return nextDay
        } else {
            // If unable to calculate the next day, return nil
            return nil
        }
    }
//    quizcard_currentgame_timeleft    {timestamp} left
//    quizcard_game_hrs    {hours} hrs
//    quizcard_game_hr    {hours} hr
//    
//    quizcard_game_min    {minute} min
    
    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        
        return formattedDate
    }
    
}

//MARK:- Translations
extension String{
    var translationValue : String {
//        guard let translationData = Constants.translationData else {
//            return self
//        }
        guard let translationData = MolGameSDk.game.store.getTranslations() else {
            return self
        }
        return translationData[self].stringValue != String.empty ? translationData[self].stringValue : self
    }
    
    func getTranslationValue(default value: String) -> String{
        guard let translationData = MolGameSDk.game.store.getTranslations() else {
            return value.replacingOccurrences(of: "\\n", with: "\n")
        }
        return translationData[self].stringValue != String.empty  ? translationData[self].stringValue.replacingOccurrences(of: "\\n", with: "\n") : value.replacingOccurrences(of: "\\n", with: "\n")
    }
    
}


extension String {

    mutating func appendQueryItem(name: String, value: String?) {

        guard var urlComponents = URLComponents(string: self) else { return }

        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []

        // Create query item
        let queryItem = URLQueryItem(name: name, value: value)

        // Append the new query item in the existing query items array
        queryItems.append(queryItem)

        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems

        // Returns the url from new url components
        self = urlComponents.url?.absoluteString ?? ""
    }
}

extension NSMutableAttributedString {

    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}
