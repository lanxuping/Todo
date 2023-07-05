//
//  ViewController.swift
//  Todo
//
//  Created by Lan Xuping on 2023/7/4.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var itemArray:[Item] = [Item]()
    var userDefault = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()

//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first)
        loadItems()
    }

    @IBAction func click(_ sender: UIBarButtonItem) {
        var textF = UITextField()
        let alert = UIAlertController(title: "add", message: "new", preferredStyle: .alert)
        let action = UIAlertAction(title: "add item", style: .default) { ac in
            let newItem = Item(context: self.context)
            newItem.title = textF.text!
            newItem.done = false
            self.itemArray.append(newItem)
            self.saveItems()
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
        do {
            try context.save()
        } catch {
            print("err : saveItems \(error)")
        }
        self.tableView.reloadData()
    }
    //设置一个默认值，假设没有传递参数则使用默认参数
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("err : loadItems \(error)")
        }
    }
    func deleteItems(indexPath: IndexPath) {
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
    }
}

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[CD] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request)//传递参数替换默认参数
        self.tableView.reloadData()
    }
}





//MARK: - NSCoder filemanager (plist)
/*
let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
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
func saveItems() {
        let decode = PropertyListEncoder()
        do {
            let data = try decode.encode(itemArray)
            try data.write(to: filePath!)
        } catch {
            print(error)
        }
}
*/
