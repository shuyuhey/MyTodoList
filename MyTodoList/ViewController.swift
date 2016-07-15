//
//  ViewController.swift
//  MyTodoList
//
//  Created by 高杉秀有平 on 2016/07/14.
//  Copyright © 2016年 高杉秀有平. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!

    private var todoList = [MyTodo]()
    private let alertController :UIAlertController = UIAlertController(title: "TODO追加", message: "TODOを追加してください", preferredStyle: .Alert)
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeAlertController()
        initializeTableContents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initializeAlertController () {
        alertController.addTextFieldWithConfigurationHandler(nil)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: {
            (action: UIAlertAction) in
            if let textField = self.alertController.textFields?.first, text = textField.text {
                let todo = MyTodo(title: text)
                self.todoList.insert(todo, atIndex: 0)
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Right)
                self.syncTodoList()
                textField.text = ""
            }
        })
        alertController.addAction(okAction)
        let cancelAction = UIAlertAction(title: "CANCEL", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
    }

    private func initializeTableContents () {
        if let todoListData = userDefaults.objectForKey("todoList") as? NSData,
            storedTodoList = NSKeyedUnarchiver.unarchiveObjectWithData(todoListData) as? [MyTodo] {
            todoList.appendContentsOf(storedTodoList)
        }
    }
    
    private func syncTodoList () {
        let data :NSData = NSKeyedArchiver.archivedDataWithRootObject(self.todoList)
        self.userDefaults.setObject(data, forKey: "todoList")
        self.userDefaults.synchronize()
    }
    
    @IBAction func tapAddButton(sender: AnyObject) {
        presentViewController(alertController, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("todoCell", forIndexPath: indexPath)
        let todo = todoList[indexPath.row]
        cell.textLabel!.text = todo.todoTitle
        cell.accessoryType = todo.todoDone ? .Checkmark : .None
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            todoList.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            syncTodoList()
        }
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let todo = todoList[indexPath.row]
        todo.todoDone = !todo.todoDone
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        syncTodoList()
    }
}