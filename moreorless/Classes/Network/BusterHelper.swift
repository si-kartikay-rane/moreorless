//
//  BusterHelper.swift
//  UEFAQuizSDK
//
//  Created by Vishal Vijayvargiya on 24/08/23.
//

import Foundation

class BusterHelper{
    
    static let shared = BusterHelper()
    
    private var FiftyFifty : String
    private var VarSneakPeak : String
    private var Leaderboard : String
    
    
    enum BusterType{
        case FIFTYFIFTY
        case VARSNEAKPEAK
        case LEADERBOARD
    }
    
    
    init() {
        FiftyFifty = ""
        VarSneakPeak = ""
        Leaderboard = ""
        
        
        FiftyFifty = getBusterUpdateValue()
        VarSneakPeak = getBusterUpdateValue()
        Leaderboard =  getBusterUpdateValue()
    }
    
    private func getBusterUpdateValue() -> String{
        return  Date().timeIntervalSince1970.rounded().toString()
    }
    
    func updateBuster(type: BusterType? , types : [BusterType] = []) {
        if types.count == 0, let type = type {
            switch type {
            case .FIFTYFIFTY:
                FiftyFifty = getBusterUpdateValue()
            case .VARSNEAKPEAK:
                VarSneakPeak = getBusterUpdateValue()
            case .LEADERBOARD:
                Leaderboard =  getBusterUpdateValue()
            }
        }else{
            types.forEach { type in
                switch type {
                case .FIFTYFIFTY:
                    FiftyFifty = getBusterUpdateValue()
                case .VARSNEAKPEAK:
                    FiftyFifty = getBusterUpdateValue()
                case .LEADERBOARD:
                    Leaderboard = getBusterUpdateValue()
                }
            }
        }
    }
    
    func getBusterFor(type: BusterType) -> String{
        switch type {
        case .FIFTYFIFTY:
            return FiftyFifty
        case .VARSNEAKPEAK:
            return VarSneakPeak
        case .LEADERBOARD:
            return Leaderboard
        }
    }
}
