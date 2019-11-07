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
  
  // MARK: - Generic functions
  
  func getObject<T: Object>(_ type: T.Type, forKey key: String) -> T? {
    do {
      let realm = try Realm()
      return realm.object(ofType: T.self, forPrimaryKey: key)
    } catch {
      fatalError("🔥 Error at DBManager (getObject): \(error.localizedDescription)")
    }
  }
  
  func getObjects<T: Object>(type: T.Type, predicate: NSPredicate?) -> Results<T> {
    do {
      let realm = try Realm()
      if let predicate = predicate {
        return realm.objects(T.self).filter(predicate)
      } else {
        return realm.objects(T.self)
      }
    } catch {
      fatalError("🔥 Error at DBManager (getObjects): \(error.localizedDescription)")
    }
  }
  
  // MARK: - Working with habits
  
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
  
  func deleteHabit(_ habit: Habit) {
    dbQueue.sync {
      do {
        let realm = try Realm()
        try realm.write {
          realm.delete(habit)
          try realm.commitWrite()
        }
      } catch let error {
        fatalError("🔥 Error at DBManager (deleteHabit): \(error.localizedDescription)")
      }
    }
  }
  
  func updateHabit(habit: Habit, activationToSave: HabitActivation? = nil, activationToDelete: HabitActivation? = nil) {
    dbQueue.sync {
      do {
        let realm = try Realm()
        try realm.write {
          if let activationToSave = activationToSave {
            if let existingActivation = habit.activations.first(where: { $0.id == activationToSave.id }) {
              existingActivation.isActive = true
            } else {
              habit.activations.append(activationToSave)
            }
          }
          if let activationToDelete = activationToDelete, let index = habit.activations.firstIndex(where: { $0.id == activationToDelete.id }) {
            let activationToDelete = habit.activations[index]
            if activationToDelete.isAutomatic {
              habit.activations[index].isActive = false
            } else {
              habit.activations.remove(at: index)
              realm.delete(activationToDelete)
            }
          }
          try realm.commitWrite()
        }
      } catch let error {
        fatalError("🔥 Error at DBManager (updateHabit): \(error.localizedDescription)")
      }
    }
  }
  
  // MARK: - Working with activations
  
  func deleteActivation(_ activation: HabitActivation) {
    dbQueue.sync {
      do {
        let realm = try Realm()
        try realm.write {
          if let habit = realm.object(ofType: Habit.self, forPrimaryKey: activation.habitId),
            let activationIndex = habit.activations.firstIndex(where: { $0.id == activation.id }) {
            habit.activations.remove(at: activationIndex)
          }
          realm.delete(activation)
          try realm.commitWrite()
        }
      } catch let error {
        fatalError("🔥 Error at DBManager (deleteActivation): \(error.localizedDescription)")
      }
    }
  }
}
