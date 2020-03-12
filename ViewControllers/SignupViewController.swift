//
//  SignupViewController.swift
//  iOS_Project_DietVision
//
//  Created by Rohan Patel on 2020-03-09.
//  Copyright © 2020 Rohan Patel. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UITextFieldDelegate {

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


    var db: DBHelper = DBHelper()

    var usersList: [User] = []


    override func viewDidLoad() {
        super.viewDidLoad()

        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true

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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    @IBAction func onAgeSliderChange(sender: UISlider) {
        ageDisplay.text = String(Int(age.value))
    }

    @IBAction func onSignupClickButton(sender: UIButton) {
        print("SIGNUP BUTTON CLICKED")

        if(password.text != confirmPassword.text) {
            let alert = UIAlertController(title: "Password does not match", message: "Please check the password", preferredStyle: .alert)

            let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true)
        }
        else {
            print("PASSWORD MATCHED")
            insertUserToDatabase()
            displayDatabaseContent()
        }
    }

    func insertUserToDatabase() {


        if(db.findByEmail(email: txtEmail.text!)) {
            let alert = UIAlertController(title: "Account already exist", message: "There is already an account with the email provided.", preferredStyle: .alert)

            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true)
        } else {
            //does not exist
            db.insert(fname: txtFirstName.text!, lname: txtLastName.text!, email: txtEmail.text!, age: Int(age.value), password: password.text!)
            performSegue(withIdentifier: "SignupToLogin", sender: self)
        }
        
    }

    func displayDatabaseContent() {
        usersList = db.read()
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
