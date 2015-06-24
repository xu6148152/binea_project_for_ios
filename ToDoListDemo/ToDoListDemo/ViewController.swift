//
//  ViewController.swift
//  ToDoListDemo
//
//  Created by Binea Xu on 15/2/24.
//  Copyright (c) 2015年 Binea Xu. All rights reserved.
//

import UIKit

var todos: [ToDoBean] = []
var filterTodos: [ToDoBean] = []

func dateFromString(dateStr: String)->NSDate?{
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let date = dateFormatter.dateFromString(dateStr)
    return date
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        todos = [ToDoBean(id: "1", image: "child-selected", title: "1. 去游乐场", date: dateFromString("2014-10-20")!),
            ToDoBean(id: "2", image: "shopping-cart-selected", title: "2. 购物", date: dateFromString("2014-10-28")!),
            ToDoBean(id: "3", image: "phone-selected", title: "3. 打电话", date: dateFromString("2014-10-30")!),
            ToDoBean(id: "4", image: "travel-selected", title: "4. Travel to Europe", date: dateFromString("2014-10-31")!)]
        
        tableView.dataSource = self
        
        navigationItem.leftBarButtonItem = editButtonItem()
        
        // hide the search bar
        var contentOffset = tableView.contentOffset
        contentOffset.y += searchDisplayController!.searchBar.frame.size.height
        tableView.contentOffset = contentOffset

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView == searchDisplayController?.searchResultsTableView{
            return filterTodos.count
        }
        return todos.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = self.tableView.dequeueReusableCellWithIdentifier("todoCell") as UITableViewCell
        var todo : ToDoBean
        
        if tableView == searchDisplayController?.searchResultsTableView{
            todo = filterTodos[indexPath.row] as ToDoBean
        }else{
            todo = todos[indexPath.row] as ToDoBean
        }
        var image = cell.viewWithTag(101) as UIImageView
        var title = cell.viewWithTag(102) as UILabel
        var date = cell.viewWithTag(103) as UILabel

        image.image = UIImage(named: todo.image)
        title.text = todo.title

        let locale = NSLocale.currentLocale()
        let dateFormat = NSDateFormatter.dateFormatFromTemplate("yyyy-MM-dd ", options: 0, locale: locale)
        
        let dateFormatter =  NSDateFormatter()
        
        dateFormatter.dateFormat = dateFormat
        
        date.text = dateFormatter.stringFromDate(todo.date)
        return cell
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete{
            todos.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    //edit
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: true)
    }
    
    @IBAction func close(segue: UIStoryboardSegue){
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditTodo" {
            var vc = segue.destinationViewController as DetailViewController
            // var indexPath = tableView.indexPathForCell(sender as UITableViewCell)
            var indexPath = tableView.indexPathForSelectedRow()
            if let index = indexPath {
                vc.todo = todos[index.row]
            }
        }
    }
    
    // Move the cell
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return self.editing
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let todo = todos.removeAtIndex(sourceIndexPath.row)
        todos.insert(todo, atIndex: destinationIndexPath.row)
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        
        filterTodos = todos.filter(){$0.title.rangeOfString(searchString) != nil}
        return true
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }

}

