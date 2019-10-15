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
  }
  
  static let shared = DataManager()
  
  func getHabitId() -> String {
    let lastCreatedHabitId = getInt(forKey: .lastCreatedHabitId) ?? 1
    setValue(forKey: .lastCreatedHabitId, value: lastCreatedHabitId + 1)
    return "\(lastCreatedHabitId)"
  }
  
  func getString(forKey key: Keys) -> String? {
    return UserDefaults.standard.value(forKey: key.rawValue) as? String
  }
  
  func getInt(forKey key: Keys) -> Int? {
    return UserDefaults.standard.value(forKey: key.rawValue) as? Int
  }
  
  func setValue(forKey key: Keys, value: Any?) {
    UserDefaults.standard.set(value, forKey: key.rawValue)
  }
}
