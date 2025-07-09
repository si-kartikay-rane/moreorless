//
//  LocalDataHelper.swift
//  UEFAQuizSDK
//
//  Created by Vishal Vijayvargiya on 24/08/23.
//

import UIKit
import Alamofire
import SwiftyJSON

class LocalDataHelper{
    static var currentGameID: String? = "uclquiz"

       static var guestdata: String {
           return "GuestData"
       }
    
    enum LocalDataType: String {
        case Translation = "TransData"
        case GuestData

        var rawValue: String {
            switch self {
            case .Translation:
                return "TransData"
            case .GuestData:
                return guestdata
            }
        }
    }
    
    func saveDataToLocal(type: LocalDataType){
        switch type {
        
        case .Translation:
            JSONFileHelper().writeToJSONFile(type: type.rawValue, model: QuizzGameSDk.game.store.getTranslations())
        case .GuestData:
            UserDefaultsData.shared.setCodableDataToUserDefaults(codableData: QuizzGameSDk.game.store.getGuestData(), forKey: type.rawValue + (MOLTheme.currentGameID ?? "uclquiz"))
            JSONFileHelper().writeToJSONFile(type: type.rawValue + (MOLTheme.currentGameID ?? "uclquiz"), model: QuizzGameSDk.game.store.getGuestData())
        }
    }
    
    func deleteDataFromLocal(type: LocalDataType) {
            JSONFileHelper().deleteFile(filename: type.rawValue)
        }
    
    func readDataFromLocal<T: Codable>(type: LocalDataType) -> T?{
        return JSONFileHelper().readDataFromJSONFile(filename: type.rawValue)
    }
    
    private class JSONFileHelper{
        ///to get the url from documents directory
        private func getFileURLfromDirectory(filename: String) -> URL?{
            let manager = FileManager.default
            let urls = manager.urls(for: .documentDirectory, in: .userDomainMask)
            if let url = urls.first{
                let fileURL = url.appendingPathComponent(filename+".txt")
                return fileURL
            }
            return nil
        }
        
        func writeToJSONFile<T:Codable>(type: LocalDataType.RawValue,  model: T) -> Bool{
            guard let fileURL = getFileURLfromDirectory(filename: type) else {
                return false
            }
            
            //get string by using codable from the model, and write the string to the file
            guard let jsondata = getJSONDataFromModel(type: type, model: model) else {return false}
            
            do {
                try jsondata.write(to: fileURL, atomically: true, encoding: .utf8)//write(to: fileURL)
                return true
            } catch  {
               
            }
            
            return false
        }
        
        //read the json file
        func readDataFromJSONFile<T: Codable>(filename:String) -> T?{
            guard let fileURL = getFileURLfromDirectory(filename: filename) else {
                return nil
                
            }
            
            do {
                //get string from the path and then using Codable protocol, get the model created
                let savedString = try String(contentsOf: fileURL, encoding: .utf8)
                let model: T? = getModelDataFromString(string: savedString)
                return model
            } catch {

            }
            return nil
        }
        
        
        //MARK: Helper
        private func getJSONDataFromModel<T: Codable>(type: LocalDataType.RawValue , model: T) -> String?{
            do{
                let codedjson = try JSONEncoder().encode(model)
                let json = String(data: codedjson, encoding: .utf8)
                //                let jsonEncoder = JSONEncoder()
                //                let jsonData = json?.data(using: .utf8)
                return json
                
            }
            catch{
                
            }
            return nil
        }
        
        func getModelDataFromString<T:Codable>(string: String) -> T?{
            do{
                guard let jsonData = string.data(using: .utf8) else { return nil }
                let model = try JSONDecoder().decode(T.self, from: jsonData)
                return model
            }
            catch{
             
            }
            return nil
            
        }
        
        func deleteFile(filename: String) {
            guard let fileURL = getFileURLfromDirectory(filename: filename) else {
                return
            }
            
            do {
                try FileManager.default.removeItem(at: fileURL)
            } catch {

            }
        }
        
    }
}

