//
//  DBManager.swift
//  habitude
//
//  Created by Maxim Skryabin on 27.10.2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import Foundation
import RealmSwift

class DBManager {
  
  static let shared = DBManager()
  
  private let dbQueue = DispatchQueue(label: "ru.sportmaster.ios.driven.orzim.RealmQueue")
  
  func saveHabit(_ habit: Habit) {
    dbQueue.sync {
      do {
        let realm = try Realm()
        try realm.write {
          realm.add(habit, update: .modified)
          try realm.commitWrite()
        }
      } catch let error {
        fatalError("🔥 Error at DBManager (saveHabit): \(error.localizedDescription)")
      }
    }
  }
  
  func getHabits() -> [Habit] {
    do {
      let realm = try Realm()
      return Array(realm.objects(Habit.self))
    } catch let error {
      fatalError("🔥 Error at DBManager (getAllHabits): \(error.localizedDescription)")
    }
  }
  
  func getHabit(id: String) -> Habit? {
    return getHabits().first(where: { $0.id == id })
  }
}
