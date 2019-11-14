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
  
  func configure() {
    updateNegativeHabits()
    deleteInactiveActivations()
  }
  
  func checkIfActivatedToday(habit: Habit) -> Bool {
    return habit.sortedActivations.first(where: { $0.isActive })?.isToday ?? false
  }
  
  /// Activate habit or cancel it's activation
  /// - Parameter habit: selected habit
  /// - Parameter activate: if false -> will try to delete today's activation of passed habit
  func activateHabit(habit: Habit, activate: Bool = true) {
    NotificationManager.shared.updateBadgeValue(completion: nil)
    if activate {
      let activation = HabitActivation(habitId: habit.id, date: Date())
      SoundHelper.shared.playSound(.activation)
      DBManager.shared.updateHabit(habit: habit, activationToSave: activation)
    } else {
      let activation = HabitActivation(habitId: habit.id, date: Date())
      SoundHelper.shared.playSound(.deactivation)
      DBManager.shared.updateHabit(habit: habit, activationToDelete: activation)
    }
  }
  
  private func updateNegativeHabits() {
    let habits = DBManager.shared.getObjects(type: Habit.self, predicate: nil)
    for habit in habits where habit.type == .negative {
      if habit.activations.isEmpty {
        automaticallyActivateNegativeHabit(habit)
      } else if let activation = habit.sortedActivations.first {
        if !activation.isToday {
          automaticallyActivateNegativeHabit(habit)
        }
      }
    }
  }
  
  private func automaticallyActivateNegativeHabit(_ habit: Habit) {
    let activation = HabitActivation(habitId: habit.id, date: Date())
    activation.isAutomatic = true
    DBManager.shared.updateHabit(habit: habit, activationToSave: activation)
  }
  
  private func deleteInactiveActivations() {
    let activations = DBManager.shared.getObjects(type: HabitActivation.self, predicate: nil)
    for activation in activations where !activation.isActive && !activation.isToday {
      DBManager.shared.deleteActivation(activation)
    }
  }
}
