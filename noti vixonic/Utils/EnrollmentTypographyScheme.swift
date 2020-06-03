//
//  VixonicTypographyScheme.swift
//  noti vixonic
//
//  Created by Kevin Torres on 13-04-20.
//  Copyright © 2020 Kevin Torres. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons

class VixonicTypographyScheme: NSObject, MDCTypographyScheming {
    var useCurrentContentSizeCategoryWhenApplied: Bool
    
    var mdc_adjustsFontForContentSizeCategory: Bool
    
    var headline1: UIFont
    
    var headline2: UIFont
    
    var headline3: UIFont
    
    var headline4: UIFont
    
    var headline5: UIFont
    
    var headline6: UIFont
    
    var subtitle1: UIFont
    
    var subtitle2: UIFont
    
    var body1: UIFont
    
    var body2: UIFont
    
    var caption: UIFont
    
    var button: UIFont
    
    var overline: UIFont
    
    override init() {
        self.headline1 = UIFont.h1Font
        self.headline2 = UIFont.h2Font
        self.headline3 = UIFont.h3Font
        self.headline4 = UIFont.h4Font
        self.headline5 = UIFont.h5Font
        self.headline6 = UIFont.h6Font
        self.subtitle1 = UIFont.subtitle1
        self.subtitle2 = UIFont.subtitle2
        self.body1 = UIFont.body1
        self.body2 = UIFont.body2
        self.caption = UIFont.caption
        self.button = UIFont.button
        self.overline = UIFont.caption
        self.mdc_adjustsFontForContentSizeCategory = false
        self.useCurrentContentSizeCategoryWhenApplied = false
    }
}
