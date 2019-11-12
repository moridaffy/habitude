//
//  HabitListViewModel.swift
//  habitude
//
//  Created by Maxim Skryabin on 13.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import RxCocoa

class HabitListViewModel {
  
  let habits = BehaviorRelay<[Habit]>(value: [])
  
  init() {
    reloadHabits()
  }
  
  func reloadHabits() {
    let habits = Array(DBManager.shared.getObjects(type: Habit.self, predicate: nil))
    self.habits.accept(habits)
  }
}
