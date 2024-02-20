//
//  DataManager.swift
//  Cosas
//
//  Created by Антон Пеньков on 19.02.2024.
//

import Foundation

final class DataManager {
    static let shared = DataManager()
    
    private let storageManager = StorageManager.shared
    
    private init() {}
    
    func createTempData(completion: @escaping () -> Void) {
        let newTask = ToDoTask()
        newTask.title = "Here is a new task"
        newTask.note = "Put your notes here"
        
        let tryTask = ToDoTask()
        tryTask.title = "Tap on me!"
        tryTask.note = "Try editing title and note of the task"
        
        let swipeTask = ToDoTask()
        swipeTask.title = "Swipe me!"
        swipeTask.note = "Try editing title and note of the task"
        
        DispatchQueue.main.async { [unowned self] in
            storageManager.save([newTask, tryTask, swipeTask])
            completion()
        }
    }
}
