//
//  ViewController.swift
//  TestApp
//
//  Created by Daichi Tanaka on 2020/05/19.
//  Copyright © 2020 Daichi Tanaka. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var todoTextFiled: UITextField!
    @IBOutlet weak var todoTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var removeAllButton: UIButton!
    
    var itemList: Results<TodoModel>!
    
    @IBAction func tapAddButton(_ sender: Any) {
        let instancedTodoModel:TodoModel = TodoModel()
        instancedTodoModel.todo = self.todoTextFiled.text
        
        let realmInstance2 = try! Realm()
        try! realmInstance2.write{
            realmInstance2.add(instancedTodoModel)
        }
        self.todoTableView.reloadData()
        print(itemList)
    }
    
    @IBAction func tapRemoveAllButton(_ sender: Any) {
        let realmInstance3 = try! Realm()
        try! realmInstance3.write{
            realmInstance3.deleteAll()
        }
        self.todoTableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // データソースを self に設定する必要あり
        self.todoTableView.dataSource = self
        addButton.layer.cornerRadius = 5
        removeAllButton.layer.cornerRadius = 5
        
        let realmInstance1 = try! Realm()
        self.itemList = realmInstance1.objects(TodoModel.self)
        self.todoTableView.reloadData()
    }
}


extension ViewController: UITableViewDataSource{
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemList.count
    }
            
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let testCell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "testCell")!
        let item: TodoModel = self.itemList[(indexPath as NSIndexPath).row]
        testCell.textLabel?.text = item.todo
        return testCell
    }
}

