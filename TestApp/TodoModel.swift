//
//  TodoModel.swift
//  TestApp
//
//  Created by Daichi Tanaka on 2020/05/19.
//  Copyright © 2020 Daichi Tanaka. All rights reserved.
//

import Foundation
import RealmSwift

class TodoModel: Object{
    @objc dynamic var todo: String? = nil
}
