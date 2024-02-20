//
//  ToDoTask.swift
//  Cosas
//
//  Created by Антон Пеньков on 17.02.2024.
//

import Foundation
import RealmSwift

final class ToDoTask: Object {
    @Persisted var title: String = ""
    @Persisted var note: String = ""
    @Persisted var isDone: Bool = false
}

enum Mode: String {
    case save = "New Task"
    case edit = "Edit Task"
}
