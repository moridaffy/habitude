//
//  HabitColor.swift
//  habitude
//
//  Created by Maxim Skryabin on 15.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import UIKit

struct HabitColor {
  let code: String
  var color: UIColor { return UIColor(hex: code) ?? .black }
  
  init(code: String) {
    self.code = code
  }
}
