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

// MARK: - Test data

extension DataManager {
  func getTestHabits() -> [Habit] {
    return [
      Habit(name: NSLocalizedString("Drink water", comment: ""), icon: HabitIcon(code: "icon_habit_water"), color: HabitColor(code: "FE404F")),
      Habit(name: NSLocalizedString("Brush your teeth", comment: ""), icon: HabitIcon(code: "icon_habit_tooth"), color: HabitColor(code: "FE404F")),
      Habit(name: NSLocalizedString("Meditate", comment: ""), icon: HabitIcon(code: "icon_habit_meditate"), color: HabitColor(code: "FE404F")),
      Habit(name: NSLocalizedString("No junk food", comment: ""), icon: HabitIcon(code: "icon_habit_nojunkfood"), color: HabitColor(code: "FE404F")),
      Habit(name: NSLocalizedString("No milk", comment: ""), icon: HabitIcon(code: "icon_habit_nomilk"), color: HabitColor(code: "FE404F")),
      Habit(name: NSLocalizedString("Read a book", comment: ""), icon: HabitIcon(code: "icon_habit_book"), color: HabitColor(code: "FE404F")),
      Habit(name: NSLocalizedString("Take pills", comment: ""), icon: HabitIcon(code: "icon_habit_takepills"), color: HabitColor(code: "FE404F")),
      Habit(name: NSLocalizedString("Wake up early", comment: ""), icon: HabitIcon(code: "icon_habit_sunrise"), color: HabitColor(code: "FE404F")),
      Habit(name: NSLocalizedString("Healthy food", comment: ""), icon: HabitIcon(code: "icon_habit_healthyfood"), color: HabitColor(code: "FE404F")),
      Habit(name: NSLocalizedString("Play some music", comment: ""), icon: HabitIcon(code: "icon_habit_music"), color: HabitColor(code: "FE404F")),
      Habit(name: NSLocalizedString("Feed your dog", comment: ""), icon: HabitIcon(code: "icon_habit_feeddog"), color: HabitColor(code: "FE404F")),
      Habit(name: NSLocalizedString("Feed your cat", comment: ""), icon: HabitIcon(code: "icon_habit_feedcat"), color: HabitColor(code: "FE404F")),
      Habit(name: NSLocalizedString("Clean up", comment: ""), icon: HabitIcon(code: "icon_habit_clean"), color: HabitColor(code: "FE404F")),
      Habit(name: NSLocalizedString("No alcohol", comment: ""), icon: HabitIcon(code: "icon_habit_noalcohol"), color: HabitColor(code: "FE404F")),
      Habit(name: NSLocalizedString("Go to gym", comment: ""), icon: HabitIcon(code: "icon_habit_gym"), color: HabitColor(code: "FE404F")),
      Habit(name: NSLocalizedString("No coffee", comment: ""), icon: HabitIcon(code: "icon_habit_nocoffee"), color: HabitColor(code: "FE404F"))
    ]
  }
}
