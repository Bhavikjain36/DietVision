//
//  Users.swift
//  iOS_Project_DietVision
//
//  Created by Rohan Patel on 2020-03-09.
//

import Foundation

class User {
    
    //Object file to hold all fields required for login and signup.
    var id:Int=0
    var fname:String=""
    var lname:String=""
    var email:String=""
    var age:Int=0
    var password:String=""
    
   //Instance of a class(Initialization)
    init(id:Int,fname:String,lname:String,email:String,age:Int,password:String) {
        self.id=id
        self.fname=fname
        self.lname=lname
        self.email=email
        self.age=age
        self.password=password
            }
}
