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
  
  var aboutAlertBodyText: String {
    return """
    Thank you for downloading my simple app for creating positive habits and getting rid of negative ones. I hope that you are already trying to upgrade to a better version of yourself with the help of Habitude.

    My name is Maxim Skryabin, I'm an iOS developer of this and several other apps in the Apple App Store. You can check them out on my website (although it's fully in Russian at the moment). Please, feel free to contact me using my email, App Store reviews or my website.

    PS: This app is opensourced (v1.0) so it's source code can be downloaded from Github repository. It's nothing fancy so I don't know why would you even want to download or fork it, but you have an option to do so.

    PSS: If you found this app a tiny bit useful, please leave a review in the App Store, it really helps a lot :)
    """
  }
}
