//
//  MealTableViewController.swift
//  RatingControl
//
//  Created by Binea Xu on 10/10/15.
//  Copyright © 2015 Binea Xu. All rights reserved.
//

import UIKit

class MealTableViewController: UITableViewController {

    var meals = [Meal?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.leftBarButtonItem = editButtonItem()
        loadSampleMeals()
    }
    
    func loadSampleMeals() {
        let meal1 = Meal(name: "Capress Salad", photo: nil, rating: 4)
        let meal2 = Meal(name: "Chicken and Potatoes", photo: nil, rating: 5)
        let meal3 = Meal(name: "Pasta with Meatballs", photo: nil, rating: 3)
        
        meals += [meal1, meal2, meal3]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return meals.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "MealTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MealTableViewCell
        
        let meal = meals[indexPath.row]
        cell.nameLabel.text = meal?.name
        cell.photoImageView.image = meal?.photo
        cell.ratingControl.rating = (meal?.rating)!
        
        return cell
    }
    
    // MARK: Navigation
    @IBAction func unWindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? MealViewController, meal = sourceViewController.meal {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                meals[selectedIndexPath.row] = meal
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }else {
                // add a new meal
                let newIndexPath = NSIndexPath(forRow: meals.count, inSection: 0)
                meals.append(meal)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let mealDetailViewController: MealViewController
        
        if segue.identifier == "ShowDetail" {
            mealDetailViewController = segue.destinationViewController as! MealViewController
            if let selectedMealCell = sender as? MealTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedMealCell)
                let selectedMeal = meals[(indexPath?.row)!]
                
                mealDetailViewController.meal = selectedMeal
            }
        }else if segue.identifier == "AddItem" {
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            meals.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        }else if editingStyle == .Insert {
            
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}
