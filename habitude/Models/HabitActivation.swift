//
//  HabitActivation.swift
//  habitude
//
//  Created by Maxim Skryabin on 05.11.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import Foundation
import RealmSwift

class HabitActivation: Object {
  @objc dynamic var id: String = ""
  @objc dynamic var habitId: String = ""
  @objc dynamic var year: Int = 0
  @objc dynamic var day: Int = 0
  @objc dynamic var automatic: Bool = false
  
  var globalDay: Int { return year * 365 + day }
  var isToday: Bool { return globalDay == DateHelper.getGlobalDay() }
  
  convenience init(habitId: String, date: Date, automatic: Bool = false) {
    self.init()
    self.year = DateHelper.getYear(from: date)
    self.day = DateHelper.getDay(from: date)
    self.habitId = habitId
    self.automatic = automatic
    self.id = HabitActivation.getId(habitId: habitId, year: year, day: day)
  }
  
  convenience init(habitId: String, year: Int, day: Int, automatic: Bool = false) {
    self.init()
    self.year = year
    self.day = day
    self.habitId = habitId
    self.automatic = automatic
    self.id = HabitActivation.getId(habitId: habitId, year: year, day: day)
  }
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  func isPreviousFor(_ activation: HabitActivation) -> Bool {
    return (globalDay + 1) == activation.globalDay
  }
  
  func isNextFor(_ activation: HabitActivation) -> Bool {
    return (activation.globalDay + 1) == globalDay
  }
  
  func isConnectedTo(_ activation: HabitActivation) -> Bool {
    return isNextFor(activation) || isPreviousFor(activation)
  }
  
  static func getId(habitId: String, date: Date) -> String {
    let year = DateHelper.getYear(from: date)
    let day = DateHelper.getDay(from: date)
    return "\(habitId)_\(year)_\(day)"
  }
  
  static func getId(habitId: String, year: Int, day: Int) -> String {
    return "\(habitId)_\(year)_\(day)"
  }
}
