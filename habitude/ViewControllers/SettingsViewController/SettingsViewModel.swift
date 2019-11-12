//
//  SettingsViewModel.swift
//  habitude
//
//  Created by Maxim Skryabin on 13.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

class SettingsViewModel {
  var aboutButtonConfigured: Bool = false
  
  var themeSelectedSegmentIndex: Int {
    get {
      return DataManager.ThemeSetting.current.rawValue
    }
    set {
      DataManager.ThemeSetting.current = DataManager.ThemeSetting(rawValue: newValue) ?? .automatic
    }
  }
  
  var badgeSelectedSegmentIndex: Int {
    get {
      return DataManager.BadgeSetting.current.rawValue
    }
    set {
      DataManager.BadgeSetting.current = DataManager.BadgeSetting(rawValue: newValue) ?? .none
    }
  }
}
