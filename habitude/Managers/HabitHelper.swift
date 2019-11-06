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
    for habit in habits {
      switch habit.type {
      case .positive:
        updatePositiveHabit(habit)
      case .negative:
        updateNegativeHabit(habit)
      }
//      habit.updateStreakCount()
    }
  }
  
  func checkIfActivatedToday(habit: Habit) -> Bool {
    return habit.sortedActivations.first?.isToday ?? false
  }
  
  func checkIfActivatedYesterday(habit: Habit) -> Bool {
    let todayDay = DateHelper.getGlobalDay()
    let yesterdayDay = todayDay - 1
    return yesterdayDay == habit.sortedActivations.first?.globalDay
  }
  
  
  /// Activate habit or cancel it's activation
  /// - Parameter habit: selected habit
  /// - Parameter activate: if false -> will try to delete today's activation of passed habit
  func activateHabit(habit: Habit, activate: Bool = true) {
    let day = DateHelper.getDay()
    let year = DateHelper.getYear()
    
    if activate {
      let activation = HabitActivation(habitId: habit.id, year: year, day: day)
      DBManager.shared.updateHabit(habit: habit, activationToSave: activation)
    } else {
      let activation = HabitActivation(habitId: habit.id, year: year, day: day)
      DBManager.shared.updateHabit(habit: habit, activationToDelete: activation)
    }
  }
  
  private func updatePositiveHabit(_ habit: Habit) {
    
  }
  
  private func updateNegativeHabit(_ habit: Habit) {
    guard !habit.activations.contains(where: { $0.automatic || $0.isToday }) else { return }
    activateHabit(habit: habit)
  }
}
