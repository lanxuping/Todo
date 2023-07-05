//
//  ViewController.swift
//  Todo
//
//  Created by Lan Xuping on 2023/7/4.
//

import UIKit

class TodoListViewController: UITableViewController {
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    var itemArray:[Item] = [Item]()
    var userDefault = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }

    @IBAction func click(_ sender: UIBarButtonItem) {
        var textF = UITextField()
        let alert = UIAlertController(title: "add", message: "new", preferredStyle: .alert)
        let action = UIAlertAction(title: "add item", style: .default) { ac in
//            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let newItem = Item()
            newItem.title = textF.text!
            self.itemArray.append(newItem)
            self.saveItems()
            self.tableView.reloadData()
        }
        alert.addTextField { textField in
            textF = textField
            textField.placeholder = "normal"
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.todoItemCell, for: indexPath)
        let model = itemArray[indexPath.row]
        cell.textLabel?.text = model.title
        cell.accessoryType = model.done ? .checkmark : .none
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func saveItems() {
        let decode = PropertyListEncoder()
        do {
            let data = try decode.encode(itemArray)
            try data.write(to: filePath!)
        } catch {
            print(error)
        }
    }
    
    func loadItems(){
        do {
            if let data = try? Data(contentsOf: filePath!) {
                let decoder = PropertyListDecoder()
                itemArray = try decoder.decode([Item].self, from: data)
            }
        } catch {
            print(error)
        }
    }
}

