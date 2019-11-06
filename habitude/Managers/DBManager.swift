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
  
  func getHabits() -> [Habit] {
    do {
      let realm = try Realm()
      return Array(realm.objects(Habit.self))
    } catch let error {
      fatalError("🔥 Error at DBManager (getAllHabits): \(error.localizedDescription)")
    }
  }
  
  func updateHabit(habit: Habit, activations: [HabitActivation] = []) {
    dbQueue.sync {
      do {
        let realm = try Realm()
        try realm.write {
          if !activations.isEmpty {
            habit.activations.removeAll()
            habit.activations.append(objectsIn: activations)
          }
          try realm.commitWrite()
        }
      } catch let error {
        fatalError("🔥 Error at DBManager (updateHabit): \(error.localizedDescription)")
      }
    }
  }
  
  func addHabitActivation(_ activation: HabitActivation) {
    dbQueue.sync {
      do {
        let realm = try Realm()
        guard let habit = realm.object(ofType: Habit.self, forPrimaryKey: activation.habitId),
          !habit.activations.contains(where: { $0.id == activation.id }) else { return }
        
        try realm.write {
          habit.activations.append(activation)
          try realm.commitWrite()
        }
      } catch let error {
        fatalError("🔥 Error at DBManager (addHabitActivation): \(error.localizedDescription)")
      }
    }
  }
  
  func updateHabit(habit: Habit, activationToSave: HabitActivation? = nil, activationToDelete: HabitActivation? = nil) {
    dbQueue.sync {
      do {
        let realm = try Realm()
        try realm.write {
          if let activationToSave = activationToSave, !habit.activations.contains(where: { $0.id == activationToSave.id }) {
            habit.activations.append(activationToSave)
          }
          if let activationToDelete = activationToDelete, let index = habit.activations.firstIndex(where: { $0.id == activationToDelete.id }) {
            let activationToDelete = habit.activations[index]
            habit.activations.remove(at: index)
            realm.delete(activationToDelete)
          }
          try realm.commitWrite()
        }
      } catch let error {
        fatalError("🔥 Error at DBManager (updateHabit): \(error.localizedDescription)")
      }
    }
  }
}
