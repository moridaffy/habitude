//
//  DateHelper.swift
//  habitude
//
//  Created by Maxim Skryabin on 28.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import Foundation

class DateHelper {
  static func getDay(from date: Date = Date()) -> Int {
    let calendar = Calendar.current
    return calendar.ordinality(of: .day, in: .year, for: date)!
  }
  
  static func getYear(from date: Date = Date()) -> Int {
    let calendar = Calendar.current
    return calendar.component(.year, from: date)
  }
  
  static func getGlobalDay(from date: Date = Date()) -> Int {
    let day = getDay(from: date) 
    let year = getYear(from: date)
    return year * 365 + day
  }
}
