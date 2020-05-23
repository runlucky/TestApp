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
        
        // 格納さているデータをコンソールに出力
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
        
        // 格納されているデータをコンソールに表示
        print(itemList[0].todo)
        print(itemList[1].todo)
        print(itemList[2].todo)
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
    
    // テーブルビューの編集を許可
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // テーブルビューのセルとデータを削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            // データを削除
            let realmInstance4 = try! Realm()
            try! realmInstance4.write {
                realmInstance4.delete(itemList[indexPath.row])
            }
            // セルを削除
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
    }
}

