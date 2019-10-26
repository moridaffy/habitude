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

extension DataManager {
  func getHabitIcons() -> [HabitIcon] {
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
  
  func getHabitColors() -> [HabitColor] {
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
