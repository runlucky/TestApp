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
    
    var itemList: Results<TodoModel>!
    
    @IBAction func tapAddButton(_ sender: Any) {
        let instancedTodoModel:TodoModel = TodoModel()
        instancedTodoModel.todo = self.todoTextFiled.text
        
        let realmInstance2 = try! Realm()
        
        try! realmInstance2.write{
            realmInstance2.add(instancedTodoModel)
        }
        
        self.todoTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addButton.layer.cornerRadius = 5
        
        let realmInstance1 = try! Realm()
        self.itemList = realmInstance1.objects(TodoModel.self)
        
        // データソースを self に設定する必要がある。
        self.todoTableView.dataSource = self
        
        self.todoTableView.reloadData()
        
        //print(self.itemList)
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

