//
//  NetworkWrapper.swift
//  UEFAQuizSDK
//
//  Created by Vishal Vijayvargiya on 24/08/23.
//

import UIKit
import Alamofire
import SwiftyJSON

//These are the typealias to user completion handlers
typealias OnSuccess = ((JSON)->())
typealias OnFailure = ((Int)->())

/// Resposible to create and manage server request (GET/POST/UPLOAD).
class NetworkWrapper: NSObject {
    
    static let shared = NetworkWrapper()
    private var _baseURL:URL!
    
    var networkReachabilityStatus: NetworkReachabilityManager.NetworkReachabilityStatus?
    var networkReachabilityManager: NetworkReachabilityManager?
    private let logLevel: LogLevel = LogLevel.basic()
    struct LogLevel {
        let enabled: Bool
        let headers: Bool
        let response: Bool
        let responseHeaders: Bool
        static func basic()-> LogLevel {
            return LogLevel(enabled: Constants.isLogEnable(),
                            headers: false,
                            response: Constants.isLogEnable(),
                            responseHeaders: false)
        }
    }
//    private(set) var _manager:Session!
    
    //MARK:- Constructor
    /// This is the constructor method help to create `NetworkWrapper`'s object.
    override init() {
        super.init()
        
        _baseURL = URL.init(string: WSEndPoints.BaseURL)
//        let defaultConfiguration =  URLSessionConfiguration.default
//        defaultConfiguration.httpShouldUsePipelining = true
//        _manager = Session(configuration: defaultConfiguration, startRequestsImmediately: false, interceptor: nil)
        startReachabilityListner()
    }
    
    /// Creates a `GET NetworkCall` to consume the  API url.
    ///  eq. URL : https://demo2722238.mockable.io/getUsers
    ///
    /// - parameter url:            The path of URL. eq. "getUsers".
    /// - parameter params:         The parameters
    /// - parameter onSuccess:      Handler for success
    /// - parameter onFailure:      Handler for Failure. `nil` by default.
    /// - parameter headerType:     Header type.
    func GET(type: URLType = .BASE_URL,
             url:String,
             isMixedAPI: Bool = false,
             onSuccess: OnSuccess?,
             onFailure: OnFailure?=nil,
             headerType:HeaderType = .DEFAULT){
        
        guard NetworkWrapper.isInternerConnected() else {
            onFailure?(1000)
            return
        }
        
        guard let fullURL = getURL(url: url, type: type) else{
            onFailure?(1000)
            return
        }
        if Constants.isLogEnable() {
          //  print(fullURL)
        }
        AF.request(fullURL, method: .get, headers: HeaderInfo.getHeaderData(type: headerType)).responseJSON { response in
            if Constants.isLogEnable() {
//                self.printLog(url: fullURL, response: response)
                print("response---------\(fullURL)",response)
            }
            
            if type != .CONFIG_BASE_URL{
                let data = JSON(response.value)
                let metaData = data[WSEndPoints.WSKeys.meta]
                switch response.result {
                case .success:
                    if  !data.isEmpty {
                        onSuccess?(data)
                    }
                   else{
                       //NotificationCenter.default.post(name: Notification.Name("showErrorAlert"), object: nil, userInfo: ["message":"\(fullURL)\(response)"])
                        onFailure?(metaData[WSEndPoints.WSKeys.retVal].intValue)
                    }
                case .failure(_):
                    onFailure?(metaData[WSEndPoints.WSKeys.retVal].intValue)
                }
            }else{
                let data = JSON(response.value)
                let metaData = data[WSEndPoints.WSKeys.meta]
                onSuccess?(data)
            }
        }.cURLDescription{ curl in
//            print(curl)
        }
    }
    
    
    /// Creates a `POST NetworkCall` to consume the  API url.
    ///  eq. URL : https://demo2722238.mockable.io/getUsers
    ///
    /// - parameter url:            The path of URL. eq. "getUsers".
    /// - parameter params:         The parameters
    /// - parameter onSuccess:      Handler for success
    /// - parameter onFailure:      Handler for Failure. `nil` by default.
    /// - parameter headerType:     Header type.
    func POST<T: Encodable>(type: URLType = .BASE_URL,
                            url:String,
                            params:T? = nil,
                            onSuccess: OnSuccess?,
                            onFailure: OnFailure?=nil,
                            headerType:HeaderType = .DEFAULT){
        
        guard NetworkWrapper.isInternerConnected() else {
            onFailure?(1000)
            return
        }
        
        guard let fullURL = getURL(url: url, type: type) else{
            onFailure?(1000)
            return
        }
        if Constants.isLogEnable() {
            //print(fullURL,HeaderInfo.getHeaderData(type: .DEFAULT))
        }
        do {
            let jsonData = try JSONEncoder().encode(params)
            // Convert JSON data to string
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                if Constants.isLogEnable() {
                    //print("JSON String: \(jsonString)")
                }
            } else {
                if Constants.isLogEnable() {
                    //print("Failed to convert JSON data to string.")
                }
            }
        } catch {
            if Constants.isLogEnable() {
                //print("Error encoding JSON: \(error)")
            }
        }
       
        AF.request(fullURL, method: .post, parameters: params, encoder: JSONParameterEncoder.default, headers: HeaderInfo.getHeaderData(type: headerType)).responseJSON { response in
            if Constants.isLogEnable() {
                print("response---------\(fullURL)",response)
//
//                self.printLog(url: fullURL, response: response)
            }
            let data = JSON(response.value)
            let metaData = data[WSEndPoints.WSKeys.meta]
            switch response.result {
            case .success:
                if metaData[WSEndPoints.WSKeys.success].boolValue == true {
                    onSuccess?(data)
                }
                else{
                    onFailure?(metaData[WSEndPoints.WSKeys.retVal].intValue)
                }
            case .failure(_):
                onFailure?(metaData[WSEndPoints.WSKeys.retVal].intValue)
            }
        }
        
    }
    
    func printLog(url: URL, response: AFDataResponse<Any>) {
        if Constants.isLogEnable() {
            if logLevel.enabled == true {
                //print("================================")
            }
            if logLevel.enabled == true {
                //print(url)
                //print("-------------------------------")
            }
            
            if logLevel.response == true {
                //print("RequestBody======")
                //print(String(data: (response.request?.httpBody ?? Data()), encoding: .utf8) ?? "")
            }
            
            if logLevel.response == true {
                //print("BODY======")
                //print(response.response?.statusCode ?? 0)
                
                //print(String(data: (response.data ?? Data()), encoding: .utf8) ?? "")
            }
            
            if logLevel.enabled == true {
                //print("================================")
            }
        }
    }
    
    /// to check internet is working or not.
    ///
    /// - returns: it will return `True` if internet is working else `False`.
    
    static func isInternerConnected() -> Bool{
        if let instance = NetworkReachabilityManager() {
            return instance.isReachable
        }
        return true
    }
    
    func getURL(url:String, type: URLType = .BASE_URL) -> URL?{
        var urls = url.replacingOccurrences(of: NetworkConstants().urlKeys.competitionType, with: QUIZTheme.currentGameID ?? "uclquiz")
        urls =  urls.replacingOccurrences(of: NetworkConstants().urlKeys.platformId, with: "\(Constants.appData.platformID)")
        urls = urls.replacingOccurrences(of: NetworkConstants().urlKeys.languageCode, with: "\(QuizzGameSDk.game.getAppLanguage())")
        switch type {
        case .BASE_URL:
            //to avoid any mistakes in url as config as urls starting with '/' and without '/' also
            var fullurlString = (_baseURL.absoluteString + urls).replacingOccurrences(of: "//", with: "/")
            if !fullurlString.contains("https://"){
                fullurlString = fullurlString.replacingOccurrences(of: "https:/", with: "https://")
            }
            guard let fullURL = URL(string: fullurlString) else{
                return nil
            }
            
            return fullURL
            
        case .DETAIL_BASE_URL:
            
            let fullURL = URL(string: AppBaseURLs.productionURL + urls)
            return fullURL
            
        case .CONFIG_BASE_URL:
            let fullURL = URL(string: AppBaseURLs.dominURL + urls)
            return fullURL
        
        case .FEEDS_URL:
            let fullURL = URL(string: AppBaseURLs.demo_url + urls)
            return fullURL
            
        case .None:
            return URL(string: urls)
        
        }
    }
    
    enum URLType{
        case BASE_URL
        case DETAIL_BASE_URL
        case CONFIG_BASE_URL
        case None
        case FEEDS_URL
    }

}


extension NetworkWrapper {
    func startReachabilityListner(){
        if let instance = NetworkReachabilityManager() {
            instance.startListening { status in
                self.updateInternetStatus(status: status)
            }
            self.networkReachabilityManager = instance
        }
    }
    func updateInternetStatus(status: NetworkReachabilityManager.NetworkReachabilityStatus) {
//        var notify = false
//        if status != self.networkReachabilityStatus {
//            notify = true
//        }
        self.networkReachabilityStatus = status
//        if notify == true {
            self.notifyNetworkReachabilityStatusUpdate()
//        }
    }
    func notifyNetworkReachabilityStatusUpdate() {
        NotificationCenter.default.post(name: .didUpdateNetworkReachabilityStatus, object: nil, userInfo: nil)
    }
}


public extension Notification.Name{
    
    static let NetworkConnectionAvialable = Notification.Name("notification.NetworkConnectionAvialable")
    
    static let didDeletePrivateLeague = Notification.Name("notification.didDeletePrivateLeague")
    static let didUpdatePrivateLeagueName = Notification.Name("notification.didUpdatePrivateLeagueName")
    static let didUpdateNetworkReachabilityStatus = Notification.Name("notification.didUpdateNetworkReachabilityStatus")

}
    

extension Notification.Name {
    public static let AppTerminationNotification =
        Notification.Name("AppTerminationNotification")
}
