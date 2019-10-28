//
//  Habit.swift
//  habitude
//
//  Created by Maxim Skryabin on 15.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class Habit: Object {
  @objc dynamic var id: String = ""
  @objc dynamic var name: String = ""
  @objc dynamic var streakCount: Int = 0
  @objc dynamic var latestActivationDate: String = ""
  @objc private dynamic var iconCode: String = ""
  @objc private dynamic var colorCode: String = ""
  
  private var habitIcon: HabitIcon { return HabitIcon(code: iconCode) }
  private var habitColor: HabitColor { return HabitColor(code: colorCode) }
  
  var color: UIColor { return habitColor.color }
  var icon: UIImage? { return habitIcon.icon }
  
  convenience init(name: String, icon: HabitIcon, color: HabitColor) {
    self.init()
    self.id = DataManager.shared.getHabitId()
    self.name = name
    self.iconCode = icon.code
    self.colorCode = color.code
  }
  
  override static func primaryKey() -> String? {
    return "id"
  }
}
