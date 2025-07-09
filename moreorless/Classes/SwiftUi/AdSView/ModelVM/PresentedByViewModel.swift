//
//  PresentedByViewModel.swift
//  quiz
//
//  Created by Vishal Vijayvargiya on 31/10/23.
//

import Foundation
import SwiftUI
import Combine

class PresentedByViewModel{
    
    static var share: PresentedByViewModel = PresentedByViewModel()
    private var cancellables: Set<AnyCancellable> = []
    @Published var SponserIntro:String = ""
    @Published var ImageUrl:String? = nil
    @Published var colorcode:String? = nil
    @Published var textcolor:String? = nil
    @Published var linkurl:String? = nil
    @Published var Titile:String? =  nil
    init() {
        sponcerApiCall()
    }
    
    func sponcerApiCall(){
        MolGameSDk.game.$sponsorModel.sink { model in
            if let sponsor = model {
                self.ImageUrl = sponsor.imageUrl ?? ""
                self.SponserIntro = sponsor.introText?[MolGameSDk.game.getAppLanguage().uppercased()] ?? ""
                self.colorcode = sponsor.color ?? ""
                self.textcolor =  sponsor.secondaryColor ?? ""
                self.linkurl = sponsor.links?[MolGameSDk.game.getAppLanguage().uppercased()] ?? ""
                self.Titile = sponsor.name ?? ""
            }
        }.store(in: &cancellables)
    }
}
