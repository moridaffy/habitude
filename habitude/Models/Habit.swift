//
//  Habit.swift
//  habitude
//
//  Created by Maxim Skryabin on 15.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class Habit: Object {
  @objc dynamic var id: String = ""
  @objc dynamic var name: String = ""
  @objc private dynamic var habitTypeValue: Int = 0
  @objc private dynamic var iconCode: String = ""
  @objc private dynamic var colorCode: String = ""
  
  let activations = List<HabitActivation>()
  
  /// Habits activations sorted from newest to oldest
  var sortedActivations: [HabitActivation] { return activations.sorted(by: { $0.globalDay > $1.globalDay }) }
  var activeActivations: [HabitActivation] { return activations.filter({ $0.isActive }) }
  var sortedActiveActivations: [HabitActivation] { return activeActivations.sorted(by: { $0.globalDay > $1.globalDay }) }
  
  var color: UIColor { return HabitColor(code: colorCode).color }
  var icon: UIImage? { return HabitIcon(code: iconCode).icon }
  var type: HabitType { return HabitType(rawValue: habitTypeValue) ?? .positive }
  var isActivatedToday: Bool { return HabitHelper.shared.checkIfActivatedToday(habit: self) }
  var streakCount: Int { return Habit.getStreakCount(Array(activations)) }
  
  convenience init(name: String, icon: HabitIcon, color: HabitColor, type: HabitType) {
    self.init()
    self.id = DataManager.shared.getHabitId()
    self.name = name
    self.habitTypeValue = type.rawValue
    self.iconCode = icon.code
    self.colorCode = color.code
  }
  
  override static func primaryKey() -> String? {
    return "id"
  }
}

extension Habit {
  
  /// Get latest streak count for passed activations.
  static func getStreakCount(_ activations: [HabitActivation]) -> Int {
    let todayDay = DateHelper.getGlobalDay()
    let yesterdayDay = todayDay - 1
    if activations.first?.globalDay != todayDay && activations.first?.globalDay != yesterdayDay {
      return 0
    } else if activations.count == 1 {
      return (activations.first?.isActive ?? false) ? 1 : 0
    } else if activations.count == 2, let firstActivation = activations.first, let lastActivation = activations.last {
      return firstActivation.isConnectedTo(lastActivation) ? 2 : 1
    } else {
      var streak: Int = 1
      for i in 0..<(activations.count - 1) {
        let activation = activations[i]
        let previousActivation = activations[i + 1]
        guard activation.isConnectedTo(previousActivation) else {
          return streak
        }
        streak += 1
      }
      return streak
    }
  }
  
  enum HabitType: Int {
    case positive = 0
    case negative = 1
  }
}
