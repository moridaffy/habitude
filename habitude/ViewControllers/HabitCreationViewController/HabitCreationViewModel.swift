//
//  HabitCreationViewModel.swift
//  habitude
//
//  Created by Maxim Skryabin on 13.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import UIKit
import RxSwift

class HabitCreationViewModel {

  let icons: [HabitIcon]
  let colors: [HabitColor]
  let selectedHabitIcon: Variable<HabitIcon>
  let selectedHabitColor: Variable<HabitColor>
  
  var createButtonConfigured: Bool = false
  
  init() {
    self.icons = DataManager.habitIcons.shuffled()
    self.colors = DataManager.habitColors.shuffled()
    self.selectedHabitIcon = Variable(self.icons[0])
    self.selectedHabitColor = Variable(self.colors[0])
  }
  
  func getColorForIconPreview(at row: Int) -> HabitColor {
    guard row < colors.count else { return HabitColor(code: "CCCCCC") }
    return colors[row]
  }
  
  func getHabitName(textFieldValue: String?) -> String {
    guard let textFieldValue = textFieldValue, !textFieldValue.isEmpty else { return selectedHabitIcon.value.placeholder }
    return textFieldValue
  }
  
  func saveHabit(name: String, type: Habit.HabitType) {
    let habit = Habit(name: name, icon: selectedHabitIcon.value, color: selectedHabitColor.value, type: type)
    DBManager.shared.saveHabit(habit)
  }
}
