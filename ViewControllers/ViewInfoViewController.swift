//
//  ViewInfoViewController.swift
//  iOS_Project_DietVision
//
//  Created by Bhavik Jain on 2020-03-18.
//

import UIKit
import SQLite3

class ViewInfoViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    //Assigning app delegate to main delegate for use in current file
    var mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //Creating a tableview
    @IBOutlet weak var tableView: UITableView!
    
    //display content in one row.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //background image for table view page.
    func assignbackground(){
        let background = UIImage(named: "nutritionBack.jpg")

        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.alpha = 1.0
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
     //viewDidload method for displaying content on page load.
    override func viewDidLoad() {
        super.viewDidLoad()
        //assign background to table view on page load.
        assignbackground()
        
        //Attaching table view to delegate for display on runtime
        tableView.delegate = self
        tableView.dataSource = self
       
    }
    
    //Inserting all items to the database to view it on storeditemsviewcontroller
    @IBAction func insertAllItems(sender : Any){
        insertItems()
    }
    
    //setting row height for table cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1200
    }
    
    //Method to display the contents on the table view and current view controller
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Uses the UITableViewCell class to display data on the cell and gets all the fields to be displayed on the page.
          let tableCell : NutritionInfoDetailsCell = tableView.dequeueReusableCell(withIdentifier: "NutritionCell") as? NutritionInfoDetailsCell ?? NutritionInfoDetailsCell(style: .default, reuseIdentifier: "NutritionCell")
        
        tableCell.header.text = "Nutrition Facts"
        tableCell.sHeader.text = "Amount Per Serving"
        
        //Setting received food name
        tableCell.foodName.text = "Food Name: \(mainDelegate.foodItem.food_name.uppercased())"
        tableCell.foodName.textColor = .darkGray
        
        //Setting all the food data from API to their respective fields to be displayed in the table cell.
        tableCell.calories.text =
            "Calories(kCal)".padding(toLength: 25, withPad: "-", startingAt: 0) + " \(mainDelegate.foodItem.calories)"
        tableCell.Fat.text =
            "Fat(g)".padding(toLength: 26, withPad: "-", startingAt: 0) + " \(mainDelegate.foodItem.fat)"
        tableCell.potassium.text =
            "Potassium(mg)".padding(toLength: 22, withPad: "-", startingAt: 0) + " \(mainDelegate.foodItem.potassium)"
        tableCell.Protein.text =
            "Protein(g)".padding(toLength: 26, withPad: "-", startingAt: 0) + " \(mainDelegate.foodItem.protine)"
        tableCell.carbohydrates.text = "Carbohydrates(g)".padding(toLength: 25, withPad: "-", startingAt: 0) + "\(mainDelegate.foodItem.totalCarbs)"
        tableCell.sugar.text =
            "Sugar(g)".padding(toLength: 26, withPad: "-", startingAt: 0) + " \(mainDelegate.foodItem.sugars)"
        tableCell.sodium.text =
            "Sodium(mg)".padding(toLength: 24, withPad: "-", startingAt: 0) + " \(mainDelegate.foodItem.sodium)"
       
        
        return tableCell
    }
   
    //Function to insert the all the items of food scanned by user to database, to be used on stored view controller.
    func insertItems()
    {
        //Variables to store the food items scanned by user
        let food_name = mainDelegate.foodItem.food_name
        let calories = mainDelegate.foodItem.calories
        let fat = mainDelegate.foodItem.fat
        let potassium =  mainDelegate.foodItem.potassium
        let sodium = mainDelegate.foodItem.sodium
        let protine = mainDelegate.foodItem.protine
        let carbs = mainDelegate.foodItem.totalCarbs
        let sugar = mainDelegate.foodItem.sugars
        let email = mainDelegate.loggedUser.email
        
        //Inserting the scanned food data to database using the method created in the swift file.
        mainDelegate.insertItems(food_name: food_name, calories: Double(calories), fat: Double(fat), potassium: Double(potassium), sodium: Double(sodium), protine: Double(protine), carbs: Double(carbs), sugar: Double(sugar), email: email)
    
        var alert = UIAlertController(title: "Success", message: "Item successfully added to database.", preferredStyle: .alert)
        
        var okaction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okaction)
        
        self.present(alert,animated: true)
    }

   
}
