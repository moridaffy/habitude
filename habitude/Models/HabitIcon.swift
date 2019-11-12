//
//  HabitIcon.swift
//  habitude
//
//  Created by Maxim Skryabin on 15.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import UIKit

struct HabitIcon {
  let code: String
  var icon: UIImage? { return UIImage(named: code)?.withRenderingMode(.alwaysTemplate) }
  var placeholder: String {
    switch code {
    case "icon_habit_water":
      return NSLocalizedString("Drink 1l of water", comment: "")
    case "icon_habit_tooth":
      return NSLocalizedString("Clean your teeth", comment: "")
    case "icon_habit_meditate":
      return NSLocalizedString("Meditate", comment: "")
    case "icon_habit_nojunkfood":
      return NSLocalizedString("Don't eat junk food", comment: "")
    case "icon_habit_nomilk":
      return NSLocalizedString("Don't drink milk", comment: "")
    case "icon_habit_book":
      return NSLocalizedString("Read a book", comment: "")
    case "icon_habit_takepills":
      return NSLocalizedString("Take pills", comment: "")
    case "icon_habit_sunrise":
      return NSLocalizedString("Wake up early", comment: "")
    case "icon_habit_healthyfood":
      return NSLocalizedString("Eat healthy food", comment: "")
    case "icon_habit_music":
      return NSLocalizedString("Play musical instrument", comment: "")
    case "icon_habit_feeddog":
      return NSLocalizedString("Feed your dog", comment: "")
    case "icon_habit_feedcat":
      return NSLocalizedString("Feed your cat", comment: "")
    case "icon_habit_clean":
      return NSLocalizedString("Clean up", comment: "")
    case "icon_habit_noalcohol":
      return NSLocalizedString("Don't drink alcohol", comment: "")
    case "icon_habit_gym":
      return NSLocalizedString("Go to gym", comment: "")
    case "icon_habit_nocoffee":
      return NSLocalizedString("Don't drink coffee", comment: "")
    default:
      fatalError("Unknown icon code passed: \(code)")
    }
  }
  
  init(code: String) {
    self.code = code
  }
}
