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
    habits.value = DataManager.shared.getTestHabits()
  }
}
