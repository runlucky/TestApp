//
//  TodoModel.swift
//  TestApp
//
//  Created by Daichi Tanaka on 2020/05/19.
//  Copyright © 2020 Daichi Tanaka. All rights reserved.
//

import Foundation
import RealmSwift

internal struct TodoModel {
    internal let id: String
    internal let text: String?
    
    internal init(text: String?) {
        self.id = Date().timeIntervalSince1970.description
        self.text = text
    }
    
    internal init(id: String, text: String?) {
        self.id = id
        self.text = text
    }
    
    internal func toRealmObject() -> TodoModelRealm {
        TodoModelRealm(self)
    }
}

internal class TodoModelRealm: Object {
    @objc internal dynamic var id = Date().timeIntervalSince1970.description
    @objc internal dynamic var text: String? = nil
    
    internal required init() {}
    
    internal init(_ todo: TodoModel) {
        self.id = todo.id
        self.text = todo.text
    }

    override internal static func primaryKey() -> String? { "id" }
}
