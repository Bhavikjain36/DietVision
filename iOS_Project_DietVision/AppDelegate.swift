//
//  AppDelegate.swift
//  iOS_Project_DietVision
//
//  Created by Rohan Patel, Bhavik Jain, Nishit Amin
//

import UIKit
import GoogleSignIn
import SQLite3
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    var foodItem = NutritionInfo()
    var loggedUser = User(id: -1, fname: "", lname: "", email: "", age: -1, password: "")
    var allItems:[NutritionInfo] = []

    var databaseName: String? = "Dietdb.db"
    var databasePath: String?

    // Bhavik Jain
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //Client ID or API key from google develoeprs to use google sign in project
        GIDSignIn.sharedInstance().clientID = "415037608196-tmogeptqlpeaq9nof1l21vbjlcn86ghs.apps.googleusercontent.com"
        //Assiging to delegate
        GIDSignIn.sharedInstance().delegate = self

        //loading database file
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDir = documentPath[0]
        databasePath = documentDir.appending("/" + databaseName!)
        checkAndCreateDatabase()
        read()

        return true
    }

    
    // Bhavik Jain
    
    //method to allow user to sign in using google gmail.
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    //Bhavik Jain
    
    //Method when user is signed in using google, retrieves all the user details to be used on home page.
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")

            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        
        //Assigning user details to be the current logged in user to use for the project.
        loggedUser = User(id: 0, fname: user.profile.givenName, lname: user.profile.familyName, email: user.profile.email, age: 0, password: "")

        //calling method to redirect user to home page when logged in using google sign in.
        self.login()
        // Perform any operations on signed in user here.

        //All user details who is logged in using google sign in
        let userId = user.userID // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        // ...

        print("\(loggedUser.fname) || \(loggedUser.lname)")

    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...

    }

    //method to redirect user to home page when logged in using google sign in.
    func login () {
        // refer to our Main.storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainPage = storyboard.instantiateViewController(withIdentifier: "HomePage")
        // present tabBar that is storing in tabBar var
        window?.rootViewController = mainPage
    }



    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    // Rohan Patel
    
    //Method to check db file is loaded and database is created
    func checkAndCreateDatabase() {
        var success = false
        let fileManager = FileManager.default
        success = fileManager.fileExists(atPath: databasePath!)
        if success {
            return
        }
        let databasePathFromApp = Bundle.main.resourcePath?.appending("/" + databaseName!)
        try? fileManager.copyItem(atPath: databasePathFromApp!, toPath: databasePath!)
        return
    }

    
    //Rohan Patel
    
    //method for new account or signup for user details to be stored in the system.
    func insert(fname: String, lname: String, email: String, age: Int, password: String)
    {
        var db: OpaquePointer? = nil
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            let insertStatementString = "INSERT INTO users ( fname,lname,email,age,password) VALUES (?, ?, ?, ?, ?);"
            var insertStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                sqlite3_bind_text(insertStatement, 1, (fname as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, (lname as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 3, (email as NSString).utf8String, -1, nil)
                sqlite3_bind_int(insertStatement, 4, Int32(age))
                sqlite3_bind_text(insertStatement, 5, (password as NSString).utf8String, -1, nil)

                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    print("Successfully inserted row.")
                } else {
                    print("Could not insert row.")
                }
                sqlite3_finalize(insertStatement)
            } else {
                print("INSERT statement could not be prepared.")
            }
            sqlite3_close(db)
        }
        else {
            print("Could not open database")
        }
       // sqlite3_close(db)

    }

    
    // Rohan Patel
    
    //Function to retrieve all the user details from the database.
    func read() -> [User] {
        var db: OpaquePointer? = nil

        let queryStatementString = "SELECT * FROM users;"
        var queryStatement: OpaquePointer? = nil
        var psns: [User] = []
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    let id = sqlite3_column_int(queryStatement, 0)
                    let fname = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                    let lname = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                    let email = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                    let age = sqlite3_column_int(queryStatement, 4)
                    let password = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                    psns.append(User(id: Int(id), fname: fname, lname: lname, email: email, age: Int(age), password: password))
                    print("Query Result:")
                    print("\(id) | \(fname) | \(lname)  | \(email) | \(age)")
                    
                }
                sqlite3_finalize(queryStatement)
            } else {
                print("SELECT statement could not be prepared")
            }
            sqlite3_close(db)
        }
        else {
            print("Could not open database")
        }

        return psns
    }


    // Bhavik Jain
    
    //Method to find that user login details exists in the database or not, to be used on view controller file or login controller.
    func findByEmailAndPassword(email: String, password: String) -> User {
        var db: OpaquePointer? = nil
        let queryStatementString = "SELECT * FROM users WHERE email='" + email + "' AND password='" + password + "';"
        var queryStatement: OpaquePointer? = nil
        var user = User(id: -1, fname: "", lname: "", email: "", age: -1, password: "")
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    let id = sqlite3_column_int(queryStatement, 0)
                    let fname = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                    let lname = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                    let email = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                    let age = sqlite3_column_int(queryStatement, 4)
                    let password = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                    user = User(id: Int(id), fname: fname, lname: lname, email: email, age: Int(age), password: password)
                    sqlite3_finalize(queryStatement)
                    return user
                }
            } else {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("Error: \(errmsg)")
                print("SELECT statement could not be prepared")
            }
            
            sqlite3_close(db)
        }
        else {
            print("Could not open database")
        }
        return user
    }


    // Rohan Patel
    
    //Find user email to check that email is already used or not for signup page.
    func findByEmail(email: String) -> Bool {
        var db: OpaquePointer? = nil
        let queryStatementString = "SELECT * FROM users WHERE email='" + email + "';"
        var queryStatement: OpaquePointer? = nil
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    sqlite3_finalize(queryStatement)
                    return true
                }
                
            } else {
                print("SELECT statement could not be prepared")
            }
        sqlite3_close(db)
        }
        else {
            print("Could not open database")
        }
        return false
    }

    
    // Nishit Amin
    
    //Find the user by email, to retrieve only the food which belong to particular user, to be called on the stored view items controller.
    func findAllItems(email: String){
        self.allItems.removeAll()
        print("Finding all items for user \(email)")
        var db: OpaquePointer? = nil
        let queryStatementString = "SELECT * FROM items WHERE email='" + email + "';"

        var queryStatement: OpaquePointer? = nil
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {

                while sqlite3_step(queryStatement) == SQLITE_ROW {

                    let id = sqlite3_column_int(queryStatement, 0)
                    let food_name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                    let calories = sqlite3_column_double(queryStatement, 2)
                    let fat = sqlite3_column_double(queryStatement, 3)
                    let potassium = sqlite3_column_double(queryStatement, 4)
                    let sodium = sqlite3_column_double(queryStatement, 5)
                    let protein = sqlite3_column_double(queryStatement, 6)
                    let carbs = sqlite3_column_double(queryStatement, 7)
                    let sugar = sqlite3_column_double(queryStatement, 8)

                    let item: NutritionInfo = NutritionInfo()
                    item.food_name = food_name
                    item.calories = Float(calories)
                    item.fat = Float(fat)
                    item.potassium = Float(potassium)
                    item.sodium = Float(sodium)
                    item.protine = Float(protein)
                    item.totalCarbs = Float(carbs)
                    item.sugars = Float(sugar)

                    print("\(food_name)")
                    self.allItems.append(item)

                }
                sqlite3_finalize(queryStatement)
            } else {
                print("SELECT statement could not be prepared")
            }
            sqlite3_close(db)
        } else {
            print("Could not open database")
        }
        
    }

    
    // Bhavik Jain
    
    //Method to insert all the items for one food scanned by the user and to store it in the database for user to keep record of food nutrition.
    func insertItems(food_name: String, calories: Double, fat: Double, potassium: Double, sodium: Double, protine: Double, carbs: Double, sugar: Double, email: String) {

        var db: OpaquePointer? = nil
        let insertStatementString = "INSERT INTO items ( food_name,calories,fat,potassium,sodium,protein,carbohydrates,sugar,email) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                sqlite3_bind_text(insertStatement, 1, (food_name as NSString).utf8String, -1, nil)
                sqlite3_bind_double(insertStatement, 2, Double(calories))
                sqlite3_bind_double(insertStatement, 3, Double(fat))
                sqlite3_bind_double(insertStatement, 4, Double(potassium))
                sqlite3_bind_double(insertStatement, 5, Double(sodium))
                sqlite3_bind_double(insertStatement, 6, Double(protine))
                sqlite3_bind_double(insertStatement, 7, Double(carbs))
                sqlite3_bind_double(insertStatement, 8, Double(sugar))
                sqlite3_bind_text(insertStatement, 9, (email as NSString).utf8String, -1, nil)


                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    print("Successfully inserted row.")
                } else {
                    let errmsg = String(cString: sqlite3_errmsg(db))
                                   print("Error: \(errmsg)")
                    print("Could not insert row.")
                }
                sqlite3_finalize(insertStatement)
            } else {
                print("INSERT statement could not be prepared.")
            }
            sqlite3_close(db)
        } else {
            print("Could not open database")
        }
      //  sqlite3_close(db)
    }
}

