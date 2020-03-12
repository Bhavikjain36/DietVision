//
//  Users.swift
//  iOS_Project_DietVision
//
//  Created by Rohan Patel on 2020-03-09.
//  Copyright © 2020 Rohan Patel. All rights reserved.
//

import Foundation

class User {
    var id:Int=0
    var fname:String=""
    var lname:String=""
    var email:String=""
    var age:Int=0
    var password:String=""
    
    init(id:Int,fname:String,lname:String,email:String,age:Int,password:String) {
        self.id=id
        self.fname=fname
        self.lname=lname
        self.email=email
        self.age=age
        self.password=password
            }
}
