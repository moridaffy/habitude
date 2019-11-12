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
  
  static var themableBackground: UIColor {
    switch DataManager.ThemeSetting.current {
    case .automatic:
      guard #available(iOS 13.0, *) else { return UIColor.white }
      return UIColor.systemBackground
    case .light:
      return UIColor.white
    case .dark:
      return UIColor.black
    }
  }
  
  static var themableSecondaryBackground: UIColor {
    switch DataManager.ThemeSetting.current {
    case .automatic:
      guard #available(iOS 13.0, *) else { return UIColor.white }
      return UIColor.systemGray6
    case .light:
      return UIColor.white
    case .dark:
      return UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.0)
    }
  }
  
  static var themableNavigationBarColor: UIColor {
    switch DataManager.ThemeSetting.current {
    case .automatic:
      guard #available(iOS 13.0, *) else { return UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0) }
      return UIColor.systemGray6
    case .light:
      return UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
    case .dark:
      return UIColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 1.0)
    }
  }
  
  static var themableTextColor: UIColor {
    switch DataManager.ThemeSetting.current {
    case .automatic:
      guard #available(iOS 13.0, *) else { return UIColor.black }
      return UIColor.systemGray
    case .light:
      return UIColor.black
    case .dark:
      return UIColor.white
    }
  }
  
  static var themableSecondaryTextColor: UIColor {
    switch DataManager.ThemeSetting.current {
    case .automatic:
      return UIColor.systemGray
    case .light:
      return UIColor(red: 0.58, green: 0.58, blue: 0.60, alpha: 1.0)
    case .dark:
      return UIColor(red: 0.53, green: 0.53, blue: 0.55, alpha: 1.0)
    }
  }
}
