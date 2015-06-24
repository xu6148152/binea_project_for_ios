//
//  DetailViewController.swift
//  ToDoListDemo
//
//  Created by Binea Xu on 15/2/24.
//  Copyright (c) 2015年 Binea Xu. All rights reserved.
//

import UIKit


class DetailViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var childButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var shoppingCartButton: UIButton!
    @IBOutlet weak var travelButton: UIButton!
    @IBOutlet weak var todoItem: UITextField!
    @IBOutlet weak var todoDate: UIDatePicker!
    
    var image = ""
    
    var todo: ToDoBean?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        todoItem.delegate = self
        
        if todo == nil {
            childButton.selected = true
            navigationController?.title = "新建Todo"
        }
        else {
            navigationController?.title = "修改Todo"
            if todo?.image == "child-selected"{
                childButton.selected = true
                image = "child-selected"
            }
            else if todo?.image == "phone-selected"{
                phoneButton.selected = true
                image = "phone-selected"
            }
            else if todo?.image == "shopping-cart-selected"{
                shoppingCartButton.selected = true
                image = "shopping-cart-selected"
            }
            else if todo?.image == "travel-selected"{
                travelButton.selected = true
                image = "travel-selected"
            }
            
            todoItem.text = todo?.title
            todoDate.setDate((todo?.date)!, animated: false)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        todoItem.resignFirstResponder()
    }
    
    func resetButtons() {
        childButton.selected = false
        phoneButton.selected = false
        shoppingCartButton.selected = false
        travelButton.selected = false
    }
    
    @IBAction func childTapped(sender: AnyObject) {
        resetButtons()
        childButton.selected = true
        image = "child-selected"
    }
    
    @IBAction func phoneTapped(sender: AnyObject) {
        resetButtons()
        phoneButton.selected = true
        image = "phone-selected"
    }
    
    @IBAction func shoppingCartTapped(sender: AnyObject) {
        resetButtons()
        shoppingCartButton.selected = true
        image = "shopping-cart-selected"
    }
    
    @IBAction func travelTapped(sender: AnyObject) {
        resetButtons()
        travelButton.selected = true
        image = "travel-selected"
    }
    
    // Save the todo item
    @IBAction func okTapped(sender: AnyObject) {
        
        if todo == nil {
            let uuid = NSUUID().UUIDString
        
            var todo = ToDoBean(id: uuid, image: image, title: todoItem.text, date: todoDate.date)
        
            todos.append(todo)
        }else{
            todo?.image = image
            todo?.title = todoItem.text
            todo?.date = todoDate.date
        }
    }

}
