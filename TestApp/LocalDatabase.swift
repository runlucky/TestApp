//
//  LocalDatabase.swift
//  TestApp
//
//  Created by 福田走 on 2020/05/25.
//  Copyright © 2020 Daichi Tanaka. All rights reserved.
//

import Foundation
import RealmSwift

internal protocol ILocalDatabase {
    func add(todo: TodoModel) throws
    func delete(todo: TodoModel) throws
    func deleteTodoList() throws
    func getTodoList() throws -> [TodoModel]
    func update(todo: TodoModel) throws
}

internal class RealmManager: ILocalDatabase {
    internal static let shared = RealmManager()
    private let realmInstance = try! Realm()
    private var todoList: Results<TodoModelRealm> { realmInstance.objects(TodoModelRealm.self) }
    
    private init() {}
    
    internal func add(todo: TodoModel) throws {
        try realmInstance.write {
            realmInstance.add(todo.toRealmObject())
        }
    }
    
    internal func delete(todo: TodoModel) throws {
        try realmInstance.write {
            let target = todoList.filter("id == %@", todo.id)
            realmInstance.delete(target)
        }
    }

    internal func deleteTodoList() throws {
        try realmInstance.write {
            realmInstance.delete(todoList)
        }
    }
    
    internal func getTodoList() throws -> [TodoModel] {
        todoList.sorted(byKeyPath: "id").map { todo in
            TodoModel(id: todo.id, text: todo.text)
        }
    }
    
    internal func update(todo: TodoModel) throws {
        guard let target = todoList
            .filter("id == %@", todo.id)
            .first else { return }
        
        try realmInstance.write {
            target.text = todo.text
        }
    }
}
