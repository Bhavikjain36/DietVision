//
//  HomePageViewController.swift
//  iOS_Project_DietVision
//
//  Created by Rohan Patel on 2020-03-07.
//
import UIKit
import AVKit
import Vision

// Nishit Amin researched ALAMOFIRE, Swifty JSON and implemented it in my part
import Alamofire
import SwiftyJSON


class HomePageViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, UITextFieldDelegate {

    @IBOutlet var objView: UIView!
    @IBOutlet var scanningButton: UIButton!
    @IBOutlet var viewInputFood: UIView!
    @IBOutlet var inputFoodTextField: UITextField!
    @IBOutlet var detectedItemView: UIView!
    @IBOutlet var detectedItemImg: UIImageView!
    @IBOutlet var detectedItemLbl: UILabel!
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var userName: UIBarButtonItem!
    var tapGesture = UITapGestureRecognizer()

    //Assigning the Nutrition Info object file for use in the current view controller
    let foodItem = NutritionInfo()
    let captureSession = AVCaptureSession()
    var scanningStarted: Bool = false
    
    //Calling app delegate
    var mainDelegate: AppDelegate!
    //viewDidload method for displaying content on page load.
    override func viewDidLoad() {
        super.viewDidLoad()
        //assigning app delagate to mainDelegate for use in the current file.
        mainDelegate = UIApplication.shared.delegate as! AppDelegate
       //to display logged user name in top of page.
        userName.title = String(mainDelegate.loggedUser.fname)+" "+String(mainDelegate.loggedUser.lname)
        
        //Calling method for layout of view controller.
        changeUI()

        startScanningFood()

        // adding tap gesture to UIView
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.myviewTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        detectedItemView.addGestureRecognizer(tapGesture)
        detectedItemView.isUserInteractionEnabled = true

    }

    @objc func myviewTapped(_ sender: UITapGestureRecognizer) {
        
        //when food name is tapped will redirect to view info page.
        print("tapped")
        performSegue(withIdentifier: "HomeToViewInfo", sender: self)
    }
    
    //Going back to home page
    @IBAction func unwindToHomePageVC(segue: UIStoryboardSegue) {

    }

    @IBAction func onDetectedItemClick(sender: UIView) {

    }
    
    //Method when user wants to stop scannng
    @IBAction func onStopButtonPressed(sender: UIButton) {
        print("CLICKED BUTTON")
        if(scanningStarted) { //scanning is on and user want to stop it
            scanningButton.backgroundColor = UIColor(hue: 0.25, saturation: 0.66, brightness: 0.66, alpha: 1)
            scanningButton.setTitle("Start scanning", for: .normal)
            self.captureSession.stopRunning()
            self.scanningStarted = false
            print("CLICKED SCANNING STOPED")
            fetchFoodDetails()
        }
        else {
            scanningButton.backgroundColor = UIColor.red
            scanningButton.setTitle("Stop Scanning", for: .normal)
            self.captureSession.startRunning()
            self.scanningStarted = true
            print("CLICKED SCANNINE STARTED")
        }
    }

    //Method when user log out return back to home page and reset all credentials fields
    @IBAction func onLogoutPress(sender: UIButton) {
        mainDelegate.loggedUser = User(id: -1, fname: "", lname: "", email: "", age: -1, password: "")
        performSegue(withIdentifier: "HomeToLogin", sender: self)

    }
    @IBAction func textInputFieldReturn(sender: UITextField) {
        fetchFoodDetails()

    }

    //Getting all the scanned or entered food details
    func fetchFoodDetails() {
        
        //API request credentials to fetch data from NutritionX
        let headers: HTTPHeaders = ["x-app-id": "b82bbd59", "x-app-key": "24a07abb3fa97bc24be50bc74dff9bf6"]
        //request for food
        AF.request("https://trackapi.nutritionix.com/v2/natural/nutrients", method: .post, parameters: ["query": inputFoodTextField.text], headers: headers).responseJSON { response in
            //debugPrint(response.result)
            //Resturned data from API in json
            let JSONData = JSON(try? response.result.get())

            //Method to store fetched food data
            if(JSONData["message"].string == nil) {
                print("MATCH FOUND")


                //Storing all the fetched data here
                let foodData = JSONData["foods"][0]

                //debugPrint(JSONData)
                //Stores all the fetched data into variables for future use.
                self.foodItem.food_name = foodData["food_name"].string!
                self.foodItem.weight = foodData["serving_weight_grams"].float!
                self.foodItem.calories = foodData["nf_calories"].float!
                self.foodItem.photo = foodData["photo"]["thumb"].url!
                
                self.foodItem.potassium = foodData["nf_potassium"].float!
                self.foodItem.totalCarbs = foodData["nf_total_carbohydrate"].float!
                self.foodItem.protine = foodData["nf_protein"].float!
                self.foodItem.fat = foodData["nf_total_fat"].float!
                self.foodItem.sugars = foodData["nf_sugars"].float!
                self.foodItem.sodium = foodData["nf_sodium"].float!
             

                self.mainDelegate.foodItem = self.foodItem
                self.setDetectedItem()
                debugPrint(self.foodItem.calories)
            } else {
                //If food is not recognized or invalid
                print("MATCH NOT FOUND")
                self.displayNoMatchFoundMessage()
            }

        }
    }
    //Method to set the layout of home page
    func changeUI() {
        //adding border/shadow to search bar
        viewInputFood.layer.shadowColor = UIColor.black.cgColor
        viewInputFood.layer.shadowOpacity = 0.6
        viewInputFood.layer.shadowOffset = .zero
        viewInputFood.layer.shadowRadius = 10

        //adding shadow to detected item view
        detectedItemView.isHidden = true
        detectedItemView.layer.shadowColor = UIColor.black.cgColor
        detectedItemView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        detectedItemView.layer.shadowOpacity = 0.2
        detectedItemView.layer.shadowRadius = 3

        //making navigation bar transparent
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true

    }
    //To set the detected food data text and image on home page in uppercase
    func setDetectedItem() {
        self.detectedItemView.isHidden = false
        let data = try? Data(contentsOf: self.foodItem.photo)
        let image = UIImage(data: data!)
        self.detectedItemImg.image = image

        self.detectedItemLbl.text = self.foodItem.food_name.uppercased()
    }
    //Method to display when message is not found
    func displayNoMatchFoundMessage() {
        self.detectedItemView.isHidden = true

        let alert = UIAlertController(title: "No match found", message: "We cannot find the item you searched for.\n Please try again", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
    
    //Method to return the keyboard on enter.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func startScanningFood() {

        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try?AVCaptureDeviceInput(device: captureDevice) else { return }
        self.captureSession.addInput(input)

        let previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)

        previewLayer.frame.size = self.objView.frame.size
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.objView.layer.addSublayer(previewLayer)


        let dataoutput = AVCaptureVideoDataOutput()
        dataoutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videQueue"))
        self.captureSession.addOutput(dataoutput)


    }
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {

        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }


        guard let model = try? VNCoreMLModel(for: ImageClassifier().model) else { return }
        let request = VNCoreMLRequest(model: model)
        { (finishReq, err) in


            guard let result = finishReq.results as? [VNClassificationObservation] else { return }

            guard let firstObservation = result.first else { return }


            print(firstObservation.identifier.split(separator: ",")[0])
            print(String(firstObservation.confidence))

            DispatchQueue.main.async {
                self.inputFoodTextField.text = String(firstObservation.identifier.split(separator: ",")[0])
            }

        }

        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }

}
