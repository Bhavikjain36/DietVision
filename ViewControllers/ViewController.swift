//
//  LoginViewController.swift
//  iOS_Project_DietVision
//
//  Created by Bhavik Jain on 2020-03-09.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController,UITextFieldDelegate {

    //Fields to take user input of email and password for login.
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPass: UITextField!

    //Calling App Delegate
    var mainDelegate:AppDelegate!
   
    //viewDidload method for displaying content on page load.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //assigning app delagate to mainDelegate for use in the current file.
        mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //Having google sign to be on view controller.
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        //Attaching text fields to delegate
        txtEmail.delegate=self
        txtPass.delegate=self
        // Do any additional setup after loading the view.
    }
    
    //Method to return the keyboard on enter.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    //Method to login after verifying the user credentials from database.
    @IBAction func onLoginButtonPress(sender: UIButton) {
        print("TESTING USER LOGIN")
        //Calling method from app delegate to check whether user is registered or not.
        let foundUser = mainDelegate.findByEmailAndPassword(email: txtEmail.text!, password: txtPass.text!)
        
        //If credentials are incorrect display a alert.
        if(foundUser.id == -1) {
            print("NO USER FOUND WITH EMAIL AND PASSWORD")

            let alert = UIAlertController(title: "Incorrect credentials", message: "Incorrect email/password \n Please try again", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true)

        } else {
            print("USER FOUND")
            //Credentials found will allow user to redirect to home page.
            print("\(foundUser.id) | \(foundUser.fname) | \(foundUser.lname) | \(foundUser.email) | \(foundUser.age)")
            mainDelegate.loggedUser=foundUser
            
            //Segue for redirection to home page
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
