//
//  NumberExtension.swift
//  Countries
//
//  Created by Rupali on 24/08/2020.
//  Copyright © 2020 James Weatherley. All rights reserved.
//

import Foundation
//MARK:- Added by Rupali - Function to format Number into comma separated string.
extension NSNumber {
    var formattedValue: String? {
        get {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.locale = Locale(identifier: "en_GB")

            return formatter.string(from: self)
        }
    }
}
