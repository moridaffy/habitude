//
//  HabitListCollectionViewCellModel.swift
//  habitude
//
//  Created by Maxim Skryabin on 14.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

class HabitListCollectionViewCellModel {
  
  let habit: Habit
  var activated: Bool?
  
  init(habit: Habit) {
    self.habit = habit
  }
}
