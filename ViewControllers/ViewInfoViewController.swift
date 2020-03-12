//
//  ViewInfoViewController.swift
//  iOS_Project_DietVision
//
//  Created by Rohan Patel on 2020-03-08.
//  Copyright © 2020 Rohan Patel. All rights reserved.
//

import UIKit

class ViewInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
 let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        debugPrint(mainDelegate.foodItem.food_name)
        print(mainDelegate.foodItem.calories)
        // Do any additional setup after loading the view.
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
