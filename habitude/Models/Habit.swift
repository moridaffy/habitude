//
//  Habit.swift
//  habitude
//
//  Created by Maxim Skryabin on 15.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import Foundation
import RealmSwift

class Habit: Object {
  @objc dynamic var id: String = ""
  @objc dynamic var name: String = ""
  @objc private dynamic var iconCode: String = ""
  @objc private dynamic var colorCode: String = ""
  
  convenience init(name: String, icon: HabitIcon, color: HabitColor) {
    self.init()
    self.iconCode = icon.code
    self.colorCode = color.code
  }
}
