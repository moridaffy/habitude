//
//  DateHelper.swift
//  habitude
//
//  Created by Maxim Skryabin on 28.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import Foundation

class DateHelper {
  
  static func getDate(from string: String, format: DateFormat) -> Date? {
    let formatter = getFormatter(with: format)
    return formatter.date(from: string)
  }
  
  static func getString(from date: Date, format: DateFormat) -> String {
    let formatter = getFormatter(with: format)
    return formatter.string(from: date)
  }
  
  static func getString(from string: String, inputFormat: DateFormat, outputFormat: DateFormat) -> String? {
    guard let date = getDate(from: string, format: inputFormat) else { return nil }
    let formatter = getFormatter(with: outputFormat)
    return formatter.string(from: date)
  }
  
  private static func getFormatter(with format: DateFormat) -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = format.format
    return formatter
  }
}

extension DateHelper {
  enum DateFormat {
    case full
    case human
    
    var format: String {
      switch self {
      case .full:
        return "yyyy-MM-dd'T'HH:mm:ssZ"
      case .human:
        return "dd.MM '\(NSLocalizedString("at", comment: ""))' HH:mm"
      }
    }
  }
}
