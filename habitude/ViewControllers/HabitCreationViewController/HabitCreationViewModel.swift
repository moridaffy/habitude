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
  var habitTypeAlertBodyText: String {
    return """
    There are two types of habits in this app: positive and negative.

    Positive habits are regular habits which have to be completed everyday. For example, drink 1l of water, go to gym and so on.

    Negative habits are habits, which are automatically activated in the start of your day and must be deactivated if you fail to restrict yourself from doing something. For example, don't smoke, don't drink milk and so on.
    """
  }
  
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
