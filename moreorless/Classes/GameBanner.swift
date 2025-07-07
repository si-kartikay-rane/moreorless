//
//  GameBanner.swift
//  moreorless
//
//  Created by Aurimas Petrevicius on 2021-10-13.
//

import GamesLib
import GoogleMobileAds
import UIKit

let availableLanguages = ["en": "english", "es": "spanish", "fr": "french", "de": "german", "it": "italian", "pt": "portuguese", "ru": "russian"]

extension Game{
 
    func prepareBanner(){
        let bannerView = GADBannerView(frame:CGRect(x: 0, y: 0, width: 320, height: 50))
        bannerView.rootViewController = self
        bannerView.adUnitID = "/5874/ucl.\(availableLanguages[GamingHubCards.environment.language] ?? "english")/section_single"
      
        // add banner
        view.addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bannerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            bannerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            bannerView.widthAnchor.constraint(equalToConstant: 320),
            bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
            ])
        
        // load banner
        let request = GAMRequest()
        request.customTargeting = ["pos": "top"]
        bannerView.load(request)
    }
}
