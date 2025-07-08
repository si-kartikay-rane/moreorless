//
//  NetworkHelper.swift
//  UEFAQuizSDK
//
//  Created by Vishal Vijayvargiya on 24/08/23.
//

import UIKit
import SwiftyJSON

class NetworkHelper{
    static func getDecodedData<T:Decodable>(from responseJson: JSON) -> T{
        do{
            //get rawdata from json
            let data =  try responseJson.rawData()
            var decodableData = data
            //get string from rawdata
            if let string = String(data: data, encoding: .utf8){
                //remove space encoding (%20) from entire json string
                if let dataString = string.removingPercentEncoding {
                    if let encodedData = dataString.data(using: .utf8) {
                        //assign data for decoding
                        decodableData = encodedData
                    }
                }
            }
            let decoder = JSONDecoder()
            decoder.dataDecodingStrategy = .deferredToData
            let returnedResponse = try decoder.decode(T.self, from: decodableData)
            return returnedResponse
        } catch let DecodingError.dataCorrupted(context) {
            if Constants.isLogEnable() {
                print(context)
            }
        } catch let DecodingError.keyNotFound(key, context) {
            if Constants.isLogEnable() {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            }
        } catch let DecodingError.valueNotFound(value, context) {
            if Constants.isLogEnable() {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            }
        } catch let DecodingError.typeMismatch(type, context)  {
            if Constants.isLogEnable() {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            }
        } catch {
            if Constants.isLogEnable() {
                print("error: ", error.localizedDescription)
            }
        }
        return T.self as! T

    }
    
    static func getSafeDecodedData<T:Decodable>(from responseJson: JSON) -> T?{
           do{
               //get rawdata from json
               let data =  try responseJson.rawData()
               var decodableData = data
               //get string from rawdata
               if let string = String(data: data, encoding: .utf8){
                   //remove space encoding (%20) from entire json string
                   if let dataString = string.removingPercentEncoding {
                       if let encodedData = dataString.data(using: .utf8) {
                           //assign data for decoding
                           decodableData = encodedData
                       }
                   }
               }
               let decoder = JSONDecoder()
               decoder.dataDecodingStrategy = .deferredToData
               let returnedResponse = try decoder.decode(T.self, from: decodableData)
               return returnedResponse
           } catch let DecodingError.dataCorrupted(context) {
               if Constants.isLogEnable() {
                   print(context)
               }
           } catch let DecodingError.keyNotFound(key, context) {
               if Constants.isLogEnable() {
                   print("Key '\(key)' not found:", context.debugDescription)
                   print("codingPath:", context.codingPath)
               }
           } catch let DecodingError.valueNotFound(value, context) {
               if Constants.isLogEnable() {
                   print("Value '\(value)' not found:", context.debugDescription)
                   print("codingPath:", context.codingPath)
               }
           } catch let DecodingError.typeMismatch(type, context)  {
               if Constants.isLogEnable() {
                   print("Type '\(type)' mismatch:", context.debugDescription)
                   print("codingPath:", context.codingPath)
               }
           } catch {
               if Constants.isLogEnable() {
                   print("error: ", error)
               }
           }
           return nil

       }
    
    static func getErrorMessageFromTranslation(retVal: Int, from type: NetworkConstants.PostErrorKeysType ) -> String{
        
        guard let configData = Constants.configData else {
            return "someErrorOccurred".getTranslationValue(default: "Some error occured")
        }
        
        if type == .none{
            //no internet error
            if retVal == 1000{
                return "unableToConnected".getTranslationValue(default: "No Internet Connection")
            }
            
            return "someErrorOccurred".getTranslationValue(default: "Some error occured")
        }
        
        if retVal == 1000{
            return "unableToConnected".getTranslationValue(default: "No Internet Connection")
        }else{
            return ""
        }
        
    }
    
}
