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
  
  init(code: String) {
    self.code = code
  }
}
