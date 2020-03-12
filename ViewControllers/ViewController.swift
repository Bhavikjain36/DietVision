//
//  LoginViewController.swift
//  iOS_Project_DietVision
//
//  Created by Rohan Patel on 2020-03-09.
//  Copyright © 2020 Rohan Patel. All rights reserved.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPass: UITextField!

    var mainDelegate:AppDelegate!
    var db: DBHelper = DBHelper()
    override func viewDidLoad() {
        super.viewDidLoad()
        mainDelegate = UIApplication.shared.delegate as! AppDelegate
        GIDSignIn.sharedInstance()?.presentingViewController = self

        txtEmail.delegate=self
        txtPass.delegate=self
        // Do any additional setup after loading the view.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    @IBAction func onLoginButtonPress(sender: UIButton) {
        print("TESTING USER LOGIN")
        let foundUser = db.findByEmailAndPassword(email: txtEmail.text!, password: txtPass.text!)
        if(foundUser.id == -1) {
            print("NO USER FOUND WITH EMAIL AND PASSWORD")

            let alert = UIAlertController(title: "Incorrect credentials", message: "Incorrect email/password \n Please try again", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true)

        } else {
            print("USER FOUND")
            print("\(foundUser.id) | \(foundUser.fname) | \(foundUser.lname) | \(foundUser.email) | \(foundUser.age)")
            mainDelegate.loggedUser=foundUser
            performSegue(withIdentifier: "LoginToHome", sender: self)
        }
    }
    @IBAction func unwindToMainVc(_segue:UIStoryboardSegue){
        
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
