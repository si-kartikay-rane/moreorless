//
//  UIFont+Extension.swift
//  QuizeApp
//
//  Created by Vishal Vijayvargiya on 21/08/23.
//

import SwiftUI

extension Font {
    
    enum CustomFont: String {
        case SF_UI_Regular = "SFUIText-Regular"
        case SF_UI_Light = "SFUIText-Light"
        case SF_UI_Medium = "SFUIText-Medium"
        case SF_UI_Bold = "SFUIText-Bold"
        case SF_UI_SemiBold = "SFUIText-Semibold"

        case Champions_Light = "champions_light"
        case ChampionsWeb_Regular = "champions"
        case Champions_Bold = "Champions-Bold"
        case Champions_ExtraBold = "champions_extrabold"
        case Champions_Display = "Champions-Display"
        case Champions_Display_Refracted = "ChampionsDisplay-Refracted"
        
        case UEFAEuro_Book = "UEFAEuro-Book"
        case UEFAEuro_BookNarrow = "UEFAEuro-BookNarrow"
        case UEFAEuro_LightNarrow = "UEFAEuro-LightNarrow"
        case UEFAEuro_MediumNarrow = "UEFAEuro-MediumNarrow"
        case UEFAEuro_Bold = "UEFAEuro-Bold"
        case UEFAEuro_HeavyExtended = "UEFAEuro-HeavyExtended"
        case UEFAEuro_HeavyNarrow = "UEFAEuro-HeavyNarrow"
        
        case PFBeauSansPro_Bold = "PFBeauSansPro-Bold"
        case PFBeauSansPro_Light = "PFBeauSansPro-Light"
        case PFBeauSansPro_Reg = "PFBeauSansPro-Reg"
        case PFBeauSansPro_SeBold = "PFBeauSansPro-SeBold"
    }
    
    enum CustomFontNames: String, CaseIterable {
        case Champions_Display = "Champions-Display"
        case UEFAEuro_Book = "UEFAEuro-Book"
        case UEFAEuro_BookNarrow = "UEFAEuro-BookNarrow"
        case UEFAEuro_LightNarrow = "UEFAEuro-LightNarrow"
        case UEFAEuro_MediumNarrow = "UEFAEuro-MediumNarrow"
        case UEFAEuro_Bold = "UEFAEuro-Bold"
        case UEFAEuro_HeavyExtended = "UEFAEuro-HeavyExtended"
        case UEFAEuro_HeavyNarrow = "UEFAEuro-HeavyNarrow"
        case Champions_Bold = "Champions-Bold"
        case Champions_Display_Refracted = "ChampionsDisplay-Refracted"
        case PFBeauSansPro_Bold = "PFBeauSansPro-Bold"
        case PFBeauSansPro_Light = "PFBeauSansPro-Light"
        case PFBeauSansPro_Reg = "PFBeauSansPro-Reg"
        case PFBeauSansPro_SeBold = "PFBeauSansPro-SeBold"
        var name: String { self.rawValue }
    }
    
    enum CustomFontsNew: String, CaseIterable {
           case Champions_Display_Refracted = "ChampionsDisplay-Refracted"
           var name: String { self.rawValue }
       }
    
    static func swiftUICustomFont(customFont: CustomFont, size: CGFloat) -> Font {
        var font: Font? = nil
        switch customFont {
        case .SF_UI_Regular:
            font = Font.system(size: size, weight: .regular)//UIFont.systemFont(ofSize: size, weight: .regular)
        case .SF_UI_Light:
            font = Font.system(size: size, weight: .light)//UIFont.systemFont(ofSize: size, weight: .light)
        case .SF_UI_Medium:
            font = Font.system(size: size, weight: .medium)//UIFont.systemFont(ofSize: size, weight: .medium)
        case .SF_UI_Bold:
            font = Font.system(size: size, weight: .bold)//UIFont.systemFont(ofSize: size, weight: .bold)
        case .SF_UI_SemiBold:
            font = Font.system(size: size, weight: .semibold)//UIFont.systemFont(ofSize: size, weight: .semibold)
        case .Champions_Light, .ChampionsWeb_Regular, .Champions_ExtraBold, .Champions_Bold,.Champions_Display, .Champions_Display_Refracted:
                    font = Font.custom(customFont.rawValue, size: size)
         //UIFont(name: customFont.rawValue, size: size)
        case .UEFAEuro_Book,.UEFAEuro_BookNarrow,.UEFAEuro_LightNarrow,.UEFAEuro_MediumNarrow,.UEFAEuro_Bold,.UEFAEuro_HeavyExtended,.UEFAEuro_HeavyNarrow:
            font = Font.custom(customFont.rawValue, size: size)

        case .PFBeauSansPro_Light, .PFBeauSansPro_Bold, .PFBeauSansPro_Reg, .PFBeauSansPro_SeBold:
            font = Font.custom(customFont.rawValue, size: size)
        }
  
        if let font = font {
            return font
        }
        else {
            return Font.system(size: size)
        }
    }
}

extension Font {
    static func QSDkregisterFont(bundle: Bundle, fontName: String, fontExtension: String) -> Bool {
        
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension) else {
            fatalError("Couldn't find font \(fontName)")
        }
        
        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
            fatalError("Couldn't load data from the font \(fontName)")
        }
        
        guard let font = CGFont(fontDataProvider) else {
            fatalError("Couldn't create font from data")
        }
        
        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterGraphicsFont(font, &error)
        guard success else {
            
            return false
        }
        
        return true
    }
    
    static func printFonts() {
        for family in UIFont.familyNames {
            let name = UIFont.fontNames(forFamilyName: family)
            
        }
    }
    
    static func customFont(customFont : CustomFontNames, size: CGFloat) -> Font {
        var font: Font? = Font.custom(customFont.name, size: size)
        if let font = font {
            return font
        } else {
            return Font.system(size: size)
        }
    }
    
    // Uncomment to check for the font - [ Local Check ]
//    static func customFont(customFont : CustomFontsNew, size: CGFloat) -> Font {
//        var font: Font? = Font.custom(customFont.name, size: size)
//        if let font = font {
//            return font
//        } else {
//            return Font.system(size: size)
//        }
//    }
    
    static func QSDKregisterFonts() {
        CustomFontsNew.allCases.forEach { font in
            let _ = Font.QSDkregisterFont(bundle: MOLTheme.currentBundle ?? .main, fontName: font.name, fontExtension: "ttf")
        }
    }
}
