//
//  HabitHelper.swift
//  habitude
//
//  Created by Maxim Skryabin on 28.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import Foundation

class HabitHelper {
  
  static func checkIfActivatedToday(habit: Habit) -> Bool {
    guard let activationDate = DateHelper.getDate(from: habit.latestActivationDate, format: .full) else { return false }
    let calendar = Calendar.current
    
    let activationDay = calendar.ordinality(of: .day, in: .year, for: activationDate)
    let currentDay = calendar.ordinality(of: .day, in: .year, for: Date())
    return currentDay == activationDay
  }
  
  static func activateHabit(habit: Habit) {
    let streakCount = habit.streakCount + 1
    let activationDate = DateHelper.getString(from: Date(), format: .full)
    DBManager.shared.updateHabit(habit: habit, streakCount: streakCount, activationDate: activationDate)
  }
  
}
