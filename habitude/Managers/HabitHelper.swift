//
//  HabitHelper.swift
//  habitude
//
//  Created by Maxim Skryabin on 28.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import Foundation

class HabitHelper {
  
  static let shared = HabitHelper()
  
  func updateStreakCount() {
    let habits = DBManager.shared.getHabits()
    for habit in habits where habit.streakCount > 0 && !habit.isActivatedToday && !habit.isActivatedYesterday {
      DBManager.shared.updateHabit(habit: habit, streakCount: 0, activationDate: "")
    }
  }
  
  func checkIfActivatedToday(habit: Habit) -> Bool {
    guard let activationDate = DateHelper.getDate(from: habit.latestActivationDate, format: .full) else { return false }
    let calendar = Calendar.current
    
    let activationDay = calendar.ordinality(of: .day, in: .year, for: activationDate)
    let currentDay = calendar.ordinality(of: .day, in: .year, for: Date())
    return currentDay == activationDay
  }
  
  func checkIfActivatedYesterday(habit: Habit) -> Bool {
    guard let activationDate = DateHelper.getDate(from: habit.latestActivationDate, format: .full) else { return false }
    let calendar = Calendar.current
    
    let activationDay = calendar.ordinality(of: .day, in: .year, for: activationDate)
    let yesterdayDay = calendar.ordinality(of: .day, in: .year, for: Date().addingTimeInterval(-1 * 60 * 60 * 24))
    return activationDay == yesterdayDay
  }
  
  func activateHabit(habit: Habit) {
    let streakCount = habit.streakCount + 1
    let activationDate = DateHelper.getString(from: Date(), format: .full)
    DBManager.shared.updateHabit(habit: habit, streakCount: streakCount, activationDate: activationDate)
  }
  
  func deactivateHabit(habit: Habit) {
    let streakCount = habit.streakCount - 1
    let calendar = Calendar.current
    let yesterdayDate = calendar.date(byAdding: .day, value: -1, to: Date())!
    let activationDate = DateHelper.getString(from: yesterdayDate, format: .full)
    DBManager.shared.updateHabit(habit: habit, streakCount: streakCount, activationDate: activationDate)
  }
}
