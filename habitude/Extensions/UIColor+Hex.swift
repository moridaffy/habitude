//
//  UIColor+Hex.swift
//  habitude
//
//  Created by Maxim Skryabin on 15.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import UIKit

extension UIColor {
  convenience init?(hex: String) {
    var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    if cString.hasPrefix("#") {
      cString.remove(at: cString.startIndex)
    }
    
    guard cString.count == 6 else { return nil }
    var rgbValue: UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
    let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
    let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
    
    self.init(red: red, green: green, blue: blue, alpha: 1.0)
  }
}
