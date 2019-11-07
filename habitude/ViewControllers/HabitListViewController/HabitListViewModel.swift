//
//  HabitListViewModel.swift
//  habitude
//
//  Created by Maxim Skryabin on 13.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import RxSwift

class HabitListViewModel {
  
  let habits = Variable([] as [Habit])
  
  init() {
    reloadHabits()
  }
  
  func reloadHabits() {
    self.habits.value = Array(DBManager.shared.getObjects(type: Habit.self, predicate: nil))
  }
}
