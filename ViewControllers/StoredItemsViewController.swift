
// Created by Nishit Amin
import UIKit

class StoredItemsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
     //assigning app delagate to mainDelegate for use in the current file.
     var mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
     //viewDidload method for displaying content on page load.
       override func viewDidLoad() {
            super.viewDidLoad()
        //using method createed in app delegate to display the data from database by user email for particular user
        mainDelegate.findAllItems(email: mainDelegate.loggedUser.email)
           // Do any additional setup after loading the view.
       }
    
    //Counts the total items in db and creates row dynamically to display
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainDelegate.allItems.count
    }
    
    //Display the content in the table cell of table view.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? Cell ?? Cell(style: .default, reuseIdentifier: "cell")
        let rowNum = indexPath.row
        
        //Display all the food for the particular user which user saved in to the database storage.
        cell.txtName.text = mainDelegate.allItems[rowNum].food_name
        
        return cell
    }
    
    //assigns height for table cell to display data
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    //method to redirect the user to view info view controller page when clicked on food name table cell.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainDelegate.foodItem = mainDelegate.allItems[indexPath.row]
        performSegue(withIdentifier: "SavedDataToViewData", sender: self)
    }
    

     
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
