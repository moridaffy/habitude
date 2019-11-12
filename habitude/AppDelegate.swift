//
//  AppDelegate.swift
//  habitude
//
//  Created by Maxim Skryabin on 13.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    HabitHelper.shared.configure()
    updateThemeOptions()
    
    print("🔥 \(NSHomeDirectory())")
    
    return true
  }
  
  private func updateThemeOptions() {
    guard #available(iOS 13.0, *) else { return }
    switch DataManager.ThemeSetting.current {
    case .automatic:
      break
    case .light:
      window?.overrideUserInterfaceStyle = .light
    case .dark:
      window?.overrideUserInterfaceStyle = .dark
    }
  }
}

