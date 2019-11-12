//
//  NotificationManager.swift
//  habitude
//
//  Created by Maxim Skryabin on 12.11.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationManager {
  
  static let shared = NotificationManager()
  
  func updateBadgeValue(completion: ((Bool) -> Void)?) {
    tryToChangedBadgeSetting(to: DataManager.BadgeSetting.current, completion: { success in
      completion?(success)
    })
  }
  
  private func tryToChangedBadgeSetting(to setting: DataManager.BadgeSetting, completion: @escaping ((Bool) -> Void)) {
    requestAuthorization { (success) in
      if success {
        self.changeBadgeValue(to: setting)
      }
      completion(success)
    }
  }
  
  private func changeBadgeValue(to setting: DataManager.BadgeSetting) {
    switch setting {
    case .none:
      setBadgeNumber(to: 0)
    case .activated:
      let habits = DBManager.shared.getObjects(type: Habit.self, predicate: nil)
      let activatedCount = habits.filter({ $0.isActivatedToday }).count
      setBadgeNumber(to: activatedCount)
    case .nonactivated:
      let habits = DBManager.shared.getObjects(type: Habit.self, predicate: nil)
      let nonactivatedCount = habits.filter({ !$0.isActivatedToday }).count
      setBadgeNumber(to: nonactivatedCount)
    }
  }
  
  private func requestAuthorization(completion: @escaping (Bool) -> Void) {
    UNUserNotificationCenter.current().requestAuthorization(options: [.badge]) { (accessGranted, error) in
      if !accessGranted {
        print("🔥 Error while trying to set badge count: \(error?.localizedDescription ?? "unknown error")")
      }
      completion(accessGranted)
    }
  }
  
  private func setBadgeNumber(to value: Int) {
    DispatchQueue.main.async {
      UIApplication.shared.applicationIconBadgeNumber = value
    }
  }
}
