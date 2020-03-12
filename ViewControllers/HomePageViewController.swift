//
//  HomePageViewController.swift
//  iOS_Project_DietVision
//
//  Created by Rohan Patel on 2020-03-07.
//  Copyright © 2020 Rohan Patel. All rights reserved.
//
import UIKit
import AVKit
import Vision
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

    let foodItem = NutritionInfo()
    let captureSession = AVCaptureSession()
    var scanningStarted: Bool = false
    var mainDelegate: AppDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        mainDelegate = UIApplication.shared.delegate as! AppDelegate
        userName.title = String(mainDelegate.loggedUser.fname)
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

        print("tapped")
        performSegue(withIdentifier: "HomeToViewInfo", sender: self)
    }
    @IBAction func unwindToHomePageVC(segue: UIStoryboardSegue) {

    }

    @IBAction func onDetectedItemClick(sender: UIView) {

    }
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

    @IBAction func onLogoutPress(sender: UIButton) {
        mainDelegate.loggedUser = User(id: -1, fname: "", lname: "", email: "", age: -1, password: "")
        performSegue(withIdentifier: "HomeToLogin", sender: self)

    }
    @IBAction func textInputFieldReturn(sender: UITextField) {
        fetchFoodDetails()


    }

    func fetchFoodDetails() {
        let headers: HTTPHeaders = ["x-app-id": "b82bbd59", "x-app-key": "24a07abb3fa97bc24be50bc74dff9bf6"]
        AF.request("https://trackapi.nutritionix.com/v2/natural/nutrients", method: .post, parameters: ["query": inputFoodTextField.text], headers: headers).responseJSON { response in
            //debugPrint(response.result)
            let JSONData = JSON(try? response.result.get())

            if(JSONData["message"].string == nil) {
                print("MATCH FOUND")



                let foodData = JSONData["foods"][0]

                //debugPrint(JSONData)
                self.foodItem.food_name = foodData["food_name"].string!
                self.foodItem.weight = foodData["serving_weight_grams"].float!
                self.foodItem.calories = foodData["nf_calories"].float!
                self.foodItem.photo = foodData["photo"]["thumb"].url!

                self.mainDelegate.foodItem = self.foodItem
                self.setDetectedItem()
                debugPrint(self.foodItem.calories)
            } else {
                print("MATCH NOT FOUND")
                self.displayNoMatchFoundMessage()
            }

        }
    }
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
    func setDetectedItem() {
        self.detectedItemView.isHidden = false
        let data = try? Data(contentsOf: self.foodItem.photo)
        let image = UIImage(data: data!)
        self.detectedItemImg.image = image

        self.detectedItemLbl.text = self.foodItem.food_name.uppercased()
    }
    func displayNoMatchFoundMessage() {
        self.detectedItemView.isHidden = true

        let alert = UIAlertController(title: "No match found", message: "We cannot find the item you searched for.\n Please try again", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
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
