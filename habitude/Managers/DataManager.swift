//
//  DataManager.swift
//  habitude
//
//  Created by Maxim Skryabin on 15.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import Foundation

class DataManager {
  
  enum Keys: String {
    case lastCreatedHabitId = "ru.mskr.habitude.lastCreatedHabitId"
    case themeSettingValue = "ru.mskr.habitude.themeSettingValue"
    case badgeSettingValue = "ru.mskr.habitude.badgeSettingValue"
  }
  
  static let shared = DataManager()
  
  // MARK: - Generic methods
  
  func getString(forKey key: Keys) -> String? {
    return UserDefaults.standard.value(forKey: key.rawValue) as? String
  }
  
  func getInt(forKey key: Keys) -> Int? {
    return UserDefaults.standard.value(forKey: key.rawValue) as? Int
  }
  
  func setValue(forKey key: Keys, value: Any?) {
    UserDefaults.standard.set(value, forKey: key.rawValue)
  }
  
  // MARK: - Specific methods
  
  func getHabitId() -> String {
    let lastCreatedHabitId = getInt(forKey: .lastCreatedHabitId) ?? 1
    setValue(forKey: .lastCreatedHabitId, value: lastCreatedHabitId + 1)
    return "\(lastCreatedHabitId)"
  }
  
  // MARK: - Constant values
  
  static var githubUrlString: String { return "https://github.com/moridaffy/habitude" }
  static var mskrUrlString: String { return "http://mskr.name" }
  
  static var habitIcons: [HabitIcon] {
    return [
      HabitIcon(code: "icon_habit_water"),
      HabitIcon(code: "icon_habit_tooth"),
      HabitIcon(code: "icon_habit_meditate"),
      HabitIcon(code: "icon_habit_nojunkfood"),
      HabitIcon(code: "icon_habit_nomilk"),
      HabitIcon(code: "icon_habit_book"),
      HabitIcon(code: "icon_habit_takepills"),
      HabitIcon(code: "icon_habit_sunrise"),
      HabitIcon(code: "icon_habit_healthyfood"),
      HabitIcon(code: "icon_habit_music"),
      HabitIcon(code: "icon_habit_feeddog"),
      HabitIcon(code: "icon_habit_feedcat"),
      HabitIcon(code: "icon_habit_clean"),
      HabitIcon(code: "icon_habit_noalcohol"),
      HabitIcon(code: "icon_habit_gym"),
      HabitIcon(code: "icon_habit_nocoffee")
    ]
  }
  
  static var habitColors: [HabitColor] {
    return [
      HabitColor(code: "2EC4B6"),
      HabitColor(code: "38A700"),
      HabitColor(code: "1975FF"),
      HabitColor(code: "E8AA14"),
      HabitColor(code: "FF5714"),
      HabitColor(code: "FE404F"),
      HabitColor(code: "C114E8"),
      HabitColor(code: "96D1C7"),
      HabitColor(code: "6E0D25"),
      HabitColor(code: "A34A28"),
      HabitColor(code: "FFA069"),
      HabitColor(code: "B3679B"),
      HabitColor(code: "7CA982"),
      HabitColor(code: "243E36"),
      HabitColor(code: "00818A"),
      HabitColor(code: "083D77")
    ]
  }
}

extension DataManager {
  // MARK: - App settings
  
  enum ThemeSetting: Int {
    case light
    case dark
    case automatic
    
    static var current: ThemeSetting {
      get {
        let value = DataManager.shared.getInt(forKey: .themeSettingValue)
        if let value = value {
          return ThemeSetting(rawValue: value) ?? .automatic
        } else if #available(iOS 13.0, *) {
          return .automatic
        } else {
          return .light
        }
      }
      set {
        let value = newValue.rawValue
        DataManager.shared.setValue(forKey: .themeSettingValue, value: value)
      }
    }
  }
  
  enum BadgeSetting: Int {
    case none
    case activated
    case nonactivated
    
    static var current: BadgeSetting {
      get {
        let value = DataManager.shared.getInt(forKey: .badgeSettingValue) ?? 0
        return BadgeSetting(rawValue: value) ?? .none
      }
      set {
        let value = newValue.rawValue
        DataManager.shared.setValue(forKey: .badgeSettingValue, value: value)
      }
    }
  }
}
