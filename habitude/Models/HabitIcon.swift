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
      return "Drink 1l of water"
    case "icon_habit_tooth":
      return "Clean your teeth"
    case "icon_habit_meditate":
      return "Meditate"
    case "icon_habit_nojunkfood":
      return "Don't eat junk food"
    case "icon_habit_nomilk":
      return "Don't drink milk"
    case "icon_habit_book":
      return "Read a book"
    case "icon_habit_takepills":
      return "Take pills"
    case "icon_habit_sunrise":
      return "Wake up early"
    case "icon_habit_healthyfood":
      return "Eat healthy food"
    case "icon_habit_music":
      return "Play musical instrument"
    case "icon_habit_feeddog":
      return "Feed your dog"
    case "icon_habit_feedcat":
      return "Feed your cat"
    case "icon_habit_clean":
      return "Clean up"
    case "icon_habit_noalcohol":
      return "Don't drink alcohol"
    case "icon_habit_gym":
      return "Go to gym"
    case "icon_habit_nocoffee":
      return "Don't drink coffee"
    default:
      fatalError("Unknown icon code passed: \(code)")
    }
  }
  
  init(code: String) {
    self.code = code
  }
}
