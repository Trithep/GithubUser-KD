//
//  UIFont+Extension.swift
//  Core
//
//  Created by Mananchai Rojamornkul on 7/6/2562 BE.
//  Copyright © 2562 Appsynth. All rights reserved.
//

public extension UIFont {
    
    class func sevenFontRound(_ size: CGFloat) -> UIFont {
        return UIFont(name: "DBAdmanRoundedX", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    class func sevenFontRoundBold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "DBAdmanRoundedX-Bold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    
    class func sevenFontLight(_ size: CGFloat) -> UIFont {
        return UIFont(name: "DBAdmanX-Light", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    class func sevenFontBold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "DBAdmanX-Bold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    
    class func sevenFontRegular(_ size: CGFloat) -> UIFont {
        return UIFont(name: "DBAdmanX", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    class func sevenFontItalic(_ size: CGFloat) -> UIFont {
        return UIFont(name: "DBAdmanRoundedX-Italic", size: size)!
    }
    
    class func sevenFontBoldItalic(_ size: CGFloat) -> UIFont {
        return UIFont(name: "DBAdmanRoundedX-BoldItalic", size: size)!
    }
    
    // -----------------------------
    // Source: https://stackoverflow.com/questions/30507905/xcode-using-custom-fonts-inside-dynamic-framework
    // -----------------------------
    public static func registerFont(withFilename filenameString: String, in bundle: Bundle) {
        
        guard let pathForResourceString = bundle.path(forResource: filenameString, ofType: nil) else {
            print("UIFont+:  Failed to register font - path for resource not found.")
            return
        }
        
        guard let fontData = NSData(contentsOfFile: pathForResourceString) else {
            print("UIFont+:  Failed to register font - font data could not be loaded.")
            return
        }
        
        guard let dataProvider = CGDataProvider(data: fontData) else {
            print("UIFont+:  Failed to register font - data provider could not be loaded.")
            return
        }
        
        guard let font = CGFont(dataProvider) else {
            print("UIFont+:  Failed to register font - font could not be loaded.")
            return
        }
        
        var errorRef: Unmanaged<CFError>? = nil
        if (CTFontManagerRegisterGraphicsFont(font, &errorRef) == false) {
            print("UIFont+:  Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
        }
    }
    
}
