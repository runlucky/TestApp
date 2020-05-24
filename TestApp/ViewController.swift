//
//  ViewController.swift
//  TestApp
//
//  Created by Daichi Tanaka on 2020/05/19.
//  Copyright © 2020 Daichi Tanaka. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate {
    
    @IBOutlet weak var todoTextFiled: UITextField!
    @IBOutlet weak var todoTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var removeAllButton: UIButton!
    var itemList: Results<TodoModel>!
    
    // Add ボタンをクリックした際に実行する処理
    @IBAction func tapAddButton(_ sender: Any) {
        let instancedTodoModel:TodoModel = TodoModel()
        instancedTodoModel.todo = self.todoTextFiled.text
        
        // テキストフィールドに入力した文字をコンソールに出力
        print(self.todoTextFiled.text)
        
        let realmInstance = try! Realm()
        try! realmInstance.write{
            realmInstance.add(instancedTodoModel)
        }
        self.todoTableView.reloadData()
    }
    
    // Remove All ボタンをクリックした際に実行する処理
    @IBAction func tapRemoveAllButton(_ sender: Any) {
        let realmInstance = try! Realm()
        try! realmInstance.write{
            realmInstance.deleteAll()
        }
        self.todoTableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UITableViewDataSource を self に設定
        self.todoTableView.dataSource = self
        // UITableViewDelegate を self に設定
        self.todoTableView.delegate = self
        
        // ボタンの角を丸くする設定
        addButton.layer.cornerRadius = 5
        removeAllButton.layer.cornerRadius = 5
        
        let realmInstance = try! Realm()
        self.itemList = realmInstance.objects(TodoModel.self)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("セル\(indexPath)が選択されました")
        showAlertController(indexPath)
    }
    
    // テーブルビューのセルをクリックしたら、アラートコントローラを表示する処理
    func showAlertController(_ indexPath: IndexPath){
        let alertController: UIAlertController = UIAlertController(title: "\(String(indexPath.row))番目の ToDo を編集", message: itemList[indexPath.row].todo, preferredStyle: .alert)
        // アラートコントローラにテキストフィールドを表示 テキストフィールドには入力された情報を表示させておく処理
        alertController.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.text = self.itemList[indexPath.row].todo})
        // アラートコントローラに"OK"ボタンを表示 "OK"ボタンをクリックした際に、テキストフィールドに入力した文字で更新する処理を実装
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            (action) -> Void in self.updateAlertControllerText(alertController,indexPath)
        }))
        // アラートコントローラに"Cancel"ボタンを表示
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // "OK"ボタンをクリックした際に、テキストフィールドに入力した文字で更新
    func updateAlertControllerText(_ alertcontroller:UIAlertController, _ indexPath: IndexPath) {
        // guard を利用して、nil チェック
        guard let textFields = alertcontroller.textFields else {return}
        guard let text = textFields[0].text else {return}
        
        // UIAlertController に入力された文字をコンソールに出力
        print(text)
        
        // Realm に保存したデータを UIAlertController に入力されたデータで更新
        let realmInstance = try! Realm()
        try! realmInstance.write{
            itemList[indexPath.row].todo = text
        }
        self.todoTableView.reloadData()
    }
}

