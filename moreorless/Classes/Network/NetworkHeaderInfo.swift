//
//  NetworkHeaderInfo.swift
//  UEFAQuizSDK
//
//  Created by Vishal Vijayvargiya on 24/08/23.
//

import UIKit
import Alamofire
import GamesLib
/// Header types
enum HeaderType {
    case NONE
    case ENTITY
    case DEFAULT
}

class HeaderInfo: NSObject {
    
    //MARK:- Helper Methods
    
    /// Get header info
    ///
    /// - parameter type:        Header type.
    
    static func getHeaderData(type:HeaderType) -> HTTPHeaders {
        switch type {
        case .NONE:
            return [:]
        case .ENTITY:
            return getEntityHeader()
        case .DEFAULT:
            return getDefaultHeader()
        }
    }
    
    static private func getEntityHeader() -> HTTPHeaders{
        return HTTPHeaders([
            "accept": "text/plain",
            "entity": "ed0t4n$3!",
            "Referer": AppBaseURLs.baseURL //+ "/quiz/"
            
            
        ])
    }
    
    static private func getDefaultHeader() -> HTTPHeaders {
        if GamingHubCards.isLoggedIn{
            let params = HTTPHeaders([
                "accept": "text/plain",
                "entity": "ed0t4n$3!",
                "Authorization" :  "Bearer " + (GamingHubCards.user.token?.token ?? ""),
                "Referer": AppBaseURLs.baseURL //+ //"/quiz/" //+ "gaming-pre.uefa.com/quiz/" "https://gaming.uefa.com"
            ])
            return params
        }else{
            let params = HTTPHeaders([
                "accept": "text/plain"
            ])
            return params
        }
        
    }
    
    
    
    
}

