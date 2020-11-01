//
//  SignupViewController.swift
//  iOS_Project_DietVision
//
//  Created by Rohan Patel on 2020-03-09.
//  Copyright © 2020 Rohan Patel. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UITextFieldDelegate {

    //Variables to take user input for signup account.
    @IBOutlet var fnameView: UIView!
    @IBOutlet var lnameView: UIView!
    @IBOutlet var emailView: UIView!
    @IBOutlet var passView: UIView!
    @IBOutlet var confPassView: UIView!
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var txtLastName: UITextField!
    @IBOutlet var age: UISlider!
    @IBOutlet var ageDisplay: UILabel!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var confirmPassword: UITextField!


    
    var usersList: [User] = []
    //Assigning app delegate to main delegate for use in current file
    var mainDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate

    //viewDidload method for displaying content on page load.
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setting sign up page UI
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true

        //Attaching input fields to the delegate
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtEmail.delegate = self
        password.delegate = self
        confirmPassword.delegate = self

        addShadow(viewName: fnameView)
        addShadow(viewName: lnameView)
        addShadow(viewName: emailView)
        addShadow(viewName: passView)
        addShadow(viewName: confPassView)
        // Do any additional setup after loading the view.
    }


    func addShadow(viewName: UIView) {
        viewName.layer.shadowColor = UIColor.black.cgColor
        viewName.layer.shadowOpacity = 0.4
        viewName.layer.shadowOffset = .zero
        viewName.layer.shadowRadius = 7
    }
    
    //Method to return the keyboard on enter.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    //Assigning age from slider to label
    @IBAction func onAgeSliderChange(sender: UISlider) {
        ageDisplay.text = String(Int(age.value))
    }

    //On click method when Sign Up Button is pressed.
    @IBAction func onSignupClickButton(sender: UIButton) {
        print("SIGNUP BUTTON CLICKED")

        //Checking whether password and confirm password are same =, if not display a alert.
        if(password.text != confirmPassword.text) {
            let alert = UIAlertController(title: "Password does not match", message: "Please check the password", preferredStyle: .alert)

            let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true)
        }
        else {
            
            print("PASSWORD MATCHED")
            //If password matched will store the user to database.
            insertUserToDatabase()
            displayDatabaseContent()
        }
    }

    //Method to store user credentials to database.
    func insertUserToDatabase() {

        //Checks if user with same email exists already.
        if(mainDelegate.findByEmail(email: txtEmail.text!)) {
            let alert = UIAlertController(title: "Account already exist", message: "There is already an account with the email provided.", preferredStyle: .alert)

            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true)
        } else {
            //if does not exist stores user.
            mainDelegate.insert(fname: txtFirstName.text!, lname: txtLastName.text!, email: txtEmail.text!, age: Int(age.value), password: password.text!)
            performSegue(withIdentifier: "SignupToLogin", sender: self)
        }
        
    }

    //Method to refresh the list as user new user is entered.
    func displayDatabaseContent() {
        usersList = mainDelegate.read()
        print("FETCHED USER LIST")
        for u in usersList {
            print("\(u.id) | \(u.fname) | \(u.lname) | \(u.email) | \(u.age) | \(u.password)")
        }


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
