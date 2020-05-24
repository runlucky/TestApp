## TestApp
モバイル向けデータベース管理システム **Realm** を利用した、ToDo アプリの開発
![スクリーンショット 2020-05-24 13.05.26.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/199441/605dbc4b-4988-8be4-fa58-a6d4e0b9ddc1.png)


## 参考にした記事
[Realmを使ってTODOアプリを作ってみよう！/ Swift(Realmの使い方、初級編)](https://qiita.com/pe-ta/items/616e0dbd364179ca284b)

## 開発したアプリ
前掲の記事を参考にして、ToDo を追加しテーブルビューで表示することに加えて下記機能を実装した。

・**Remove All ボタン** をクリックすると、ToDo を全て削除

<img width="200" alt="Simulator Screen Shot - iPhone SE (2nd generation) - 2020-05-24 at 12.47.27.png" src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/199441/d4158fb4-2a2e-a338-67bc-4c08eb0189d3.png">
<img width="200" alt="Simulator Screen Shot - iPhone SE (2nd generation) - 2020-05-24 at 12.47.33.png" src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/199441/3205daa6-c8ab-e000-23c2-1a0b03189f6f.png">

・ToDo を表示しているテーブルビューのセルを左にスライドすると、その ToDo のみを削除

<img width="200" alt="Simulator Screen Shot - iPhone SE (2nd generation) - 2020-05-24 at 12.47.11.png" src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/199441/7e35901f-a185-3873-b22e-d53a5ba43d2e.png">

・ToDo を表示しているテーブルビューのセルをクリックすると、ToDo を編集するためのアラートコントローラを表示

<img width="200" alt="Simulator Screen Shot - iPhone SE (2nd generation) - 2020-05-24 at 12.47.19.png" src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/199441/e5dc65cf-a6ee-e8de-9ea3-5412b1251a2c.png">


・アラートコントローラの **OKボタン** をクリックすると、ToDo を更新

<img width="200" alt="Simulator Screen Shot - iPhone SE (2nd generation) - 2020-05-24 at 12.47.23.png" src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/199441/39292f27-cc64-c0c4-a832-6cae51b41383.png">
<img width="200" alt="Simulator Screen Shot - iPhone SE (2nd generation) - 2020-05-24 at 12.47.27.png" src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/199441/db33386c-bd74-784d-1fec-29663e70c7a3.png">


## 前提条件
① CocoaPods Realmの導入、テキストボックスに入力した文字を保存する処理を実装する方法は前掲の記事を参照してください。

② 今回のアプリは、Realm の利用方法を確認するために開発しました。その為、 Apple が策定した **Human Interface Guidelines** は考慮していません。


## 開発環境

|項目||
|---|---|
| PC | MacBook Air 2017 |
| IDE | Xcode Ver. 11.4.1 |
|言語| Swift 5.2.2 |
|データベース| Realm |
|コード管理| GitHub|

## Realm とは
モバイル向けデータベース管理システム

## Main.storyboard

|項目|属性|備考|
|---|---|---|
| ViewCotroller | UIViewController | ViewCotroller.swift と紐付け|
| Navigation Bar | UINavigationBar | Title を **"TestApp"** と設定 | 
|ToDoTextField| UITextField | このテキストフィールドに入力した文字を ToDo として保存 |
| Add Button | UIButton  |ボタンの色：青 角は丸く|
| Remove All Button | UIButton  |ボタンの色：赤 角は丸く|
|ToDoTableView| UITableView | 保存されている ToDo を表示|
|testCell| UITableViewCell | Identifier を **"testCell"** と設定|




## コード
```Swift:ToDoModel.swift
import Foundation
import RealmSwift

class TodoModel: Object{
    @objc dynamic var todo: String? = nil
}
```

```Swift:ViewCotroller.swift
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
            let realmInstance = try! Realm()
            try! realmInstance.write {
                realmInstance.delete(itemList[indexPath.row])
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
```

## 実装のポイント
・テーブルビューのセルを削除するだけでは、それに紐づく Realm に保存したデータは削除されない。そのため、セルとデータをそれぞれ削除する処理を実装する必要がある。

