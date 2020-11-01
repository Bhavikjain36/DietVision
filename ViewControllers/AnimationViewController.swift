//
//  AnimationViewController.swift
//  iOS_Project_DietVision
//
//  Created by Nishit Amin on 2020-03-23.
//

import UIKit
import AVFoundation

class AnimationViewController: UIViewController {

    //Creates a CALayer field to perform animation
    var fadeLayer : CALayer?
    //UI Slider to hold the volume of the music
    @IBOutlet var volSlider : UISlider!
    //To play the sound
    var soundPlayer : AVAudioPlayer?
    var spinLayer : CALayer?
    
    //Assigns the volume to be used to play audio
    @IBAction func volumeDidChnage(sender : UISlider){
        soundPlayer?.volume = volSlider.value
    }
    
    //method used when the page appears starts playing audio in the desired volume
    override func viewWillAppear(_ animated: Bool) {
        let soundURL = Bundle.main.path(forResource: "Cinematic Motivational Music", ofType: "mp3")
        let url = URL(fileURLWithPath: soundURL!)
        
        self.soundPlayer = try! AVAudioPlayer.init(contentsOf: url)
        self.soundPlayer?.currentTime = 0
        self.soundPlayer?.volume = volSlider.value
        self.soundPlayer?.numberOfLoops = -1
        self.soundPlayer?.play()
    }
    
    //Stop the music when user exits the view
    override func viewDidDisappear(_ animated: Bool) {
        self.soundPlayer?.stop()
    }
     //viewDidload method for displaying content on page load.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //Load the image for performing animation
        let fadeImage = UIImage(named: "try.png")
        //start doing the animation page loads
        fadeLayer = CALayer.init()
        fadeLayer?.contents = fadeImage?.cgImage
        //assigns height and width for image animation
        fadeLayer?.bounds = CGRect(x: 0,y: 0,width: 200,height: 200)
        fadeLayer?.position = CGPoint(x: 200, y: 170)
        self.view.layer.addSublayer(fadeLayer!)
        
        //Does the fade Animation which is basically opacity animation.
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        fadeAnimation.fromValue = NSNumber.init(value: 1.0)
        fadeAnimation.toValue = NSNumber.init(value: 0.0)
        
        fadeAnimation.isRemovedOnCompletion = false
        //Duration for animation to happen
        fadeAnimation.duration = 3.0
        fadeAnimation.beginTime = 1.0
        fadeAnimation.isAdditive = false
        //No. of times animation will be performed
        fadeAnimation.repeatCount = Float.infinity
        fadeLayer?.add(fadeAnimation, forKey: nil)
        
        //perform spin view animation
        let spinImage = UIImage(named: "Star.jpg")
        spinLayer = CALayer.init()
        spinLayer?.contents = spinImage?.cgImage
        spinLayer?.bounds = CGRect(x: 0,y: 0,width: 100,height: 100)
        spinLayer?.position = CGPoint(x: 200, y: 515)
        self.view.layer.addSublayer(spinLayer!)
        
        //Performs rotate animation
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        rotateAnimation.fromValue = 0
        rotateAnimation.toValue = 2 * Double.pi
        
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = 4.0
        rotateAnimation.repeatCount = Float.infinity
        spinLayer?.add(rotateAnimation, forKey: nil)
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
