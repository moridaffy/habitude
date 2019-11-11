//
//  UIColor+AdditionalColors.swift
//  habitude
//
//  Created by Maxim Skryabin on 26.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import UIKit

extension UIColor {
  static var additionalRed: UIColor {
    return UIColor(red: 0.94, green: 0.22, blue: 0.25, alpha: 1.0)
  }
  
  static var additionalGrayLight: UIColor {
    guard #available(iOS 13.0, *) else { return UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0) }
    return UIColor.systemGray5
  }
}
