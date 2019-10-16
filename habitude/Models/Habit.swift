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
  @objc private dynamic var iconCode: String = ""
  @objc private dynamic var colorCode: String = ""
  
  private var habitIcon: HabitIcon { return HabitIcon(code: iconCode) }
  private var habitColor: HabitColor { return HabitColor(code: colorCode) }
  
  var color: UIColor { return habitColor.color }
  var icon: UIImage? { return habitIcon.icon }
  var iconColor: UIColor { return habitColor.isDark ? UIColor.white : UIColor.black }
  
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
