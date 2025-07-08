//
//  GenericRequestModel.swift
//  UEFAQuizSDK
//
//  Created by Vishal Vijayvargiya on 24/08/23.
//
import Foundation

class GenericRequestModel: Codable{
    var langCode: String
    var buster: String = .empty
    
    init(){
        langCode = "en" //FantasyGame.game.getAppLanguage()
    }
    
    enum CodingKeys: String, CodingKey {
        case langCode = "langCode"
        case buster = "buster"
    }
}
