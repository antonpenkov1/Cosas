//
//  StorageManager.swift
//  Cosas
//
//  Created by Антон Пеньков on 19.02.2024.
//

import Foundation
import RealmSwift

final class StorageManager {
    static let shared = StorageManager()
    
    private let realm: Realm
    
    private init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }
    
    // MARK: - Task List
    func fetchTaskList() -> Results<ToDoTask> {
        realm.objects(ToDoTask.self)
    }
    
    func save(_ tasks: [ToDoTask]) {
        write {
            realm.add(tasks)
        }
    }
    
    func save(_ task: String, withNote note: String) {
        write {
            let task = ToDoTask(value: [task, note])
            realm.add(task)
        }
    }
    
    func delete(_ task: ToDoTask) {
        write {
            realm.delete(task)
        }
    }
    
    func edit(_ task: ToDoTask, newTitle: String, newNote: String) {
        write {
            task.title = newTitle
            task.note = newNote
        }
    }
    
    func done(_ task: ToDoTask) {
        write {
            task.isDone.toggle()
        }
    }
    
    // MARK: - Private methods
    private func write(completion: () -> Void) {
        do {
            try realm.write {
                completion()
            }
        } catch {
            print(error)
        }
    }
}
