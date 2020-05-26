//
//  ViewController.swift
//  TestApp
//
//  Created by Daichi Tanaka on 2020/05/19.
//  Copyright © 2020 Daichi Tanaka. All rights reserved.
//

import UIKit

internal class ViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate {
    @IBOutlet private weak var todoTextFiled: UITextField!
    @IBOutlet private weak var todoTableView: UITableView!
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var removeAllButton: UIButton!
    private var itemList: [TodoModel] = []
    
    private var db: ILocalDatabase!

    // Add ボタンをクリックした際に実行する処理
    @IBAction private func tapAddButton(_ sender: Any) {
        try! db.add(todo: TodoModel(text: self.todoTextFiled.text))
        reload()
    }
    
    // Remove All ボタンをクリックした際に実行する処理
    @IBAction private func tapRemoveAllButton(_ sender: Any) {
        try! db.deleteTodoList()
        reload()
    }
    
    private func reload() {
        itemList = try! db.getTodoList()
        todoTableView.reloadData()
    }
    
    internal func initialize(database: ILocalDatabase) {
        self.db = database
    }
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        // UITableViewDataSource を self に設定
        self.todoTableView.dataSource = self
        // UITableViewDelegate を self に設定
        self.todoTableView.delegate = self
        
        // ボタンの角を丸くする設定
        addButton.layer.cornerRadius = 5
        removeAllButton.layer.cornerRadius = 5
        
        reload()
    }
}

extension ViewController: UITableViewDataSource{
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { itemList.count }
            
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let testCell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "testCell")!
        let item: TodoModel = self.itemList[(indexPath as NSIndexPath).row]
        testCell.textLabel?.text = item.text
        return testCell
    }
    
    // テーブルビューの編集を許可
    internal func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { true }
    
    // テーブルビューのセルとデータを削除
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            try! db.delete(todo: itemList[indexPath.row])
            reload()
        }
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("セル\(indexPath)が選択されました")
        showAlertController(indexPath)
    }
    
    // テーブルビューのセルをクリックしたら、アラートコントローラを表示する処理
    private func showAlertController(_ indexPath: IndexPath){
        let alertController: UIAlertController = UIAlertController(title: "\(String(indexPath.row))番目の ToDo を編集", message: itemList[indexPath.row].text, preferredStyle: .alert)
        // アラートコントローラにテキストフィールドを表示 テキストフィールドには入力された情報を表示させておく処理
        alertController.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.text = self.itemList[indexPath.row].text})
        // アラートコントローラに"OK"ボタンを表示 "OK"ボタンをクリックした際に、テキストフィールドに入力した文字で更新する処理を実装
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            (action) -> Void in self.updateAlertControllerText(alertController,indexPath)
        }))
        // アラートコントローラに"Cancel"ボタンを表示
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // "OK"ボタンをクリックした際に、テキストフィールドに入力した文字で更新
    private func updateAlertControllerText(_ alertcontroller:UIAlertController, _ indexPath: IndexPath) {
        // guard を利用して、nil チェック
        guard let textFields = alertcontroller.textFields else {return}
        guard let text = textFields[0].text else {return}
        
        // UIAlertController に入力された文字をコンソールに出力
        print(text)
        
        // Realm に保存したデータを UIAlertController に入力されたデータで更新
        let old = itemList[indexPath.row]
        let newValue = TodoModel(id: old.id, text: text)
        try! db.update(todo: newValue)
        
        reload()
    }
}

