//
//  ViewController.swift
//  PlankStopWatch
//
//  Created by Kireet Agrawal on 3/17/17.
//  Copyright © 2017 Kireet Agrawal. All rights reserved.
//
// Uses Core Motion to analyze current movement with AV Foundation Speech utterances to analyze movement
//

import UIKit
import CoreMotion
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var StartStop: UIButton!
    @IBOutlet weak var lowerWrapper: UIView!
    
    var timer: Timer?
    var currentTimeInMilliSeconds = 0
    
    func createTimer() -> Timer {
        return Timer.scheduledTimer(timeInterval: 0.1, target: self,
                             selector: #selector(ViewController.timerTicked(_:)), userInfo: nil, repeats: true)
    }
    
    func timerTicked(_ timer: Timer) {
        currentTimeInMilliSeconds += 1
        self.TimeLabel.text = self.formattedTimeString(currentTimeInMilliSeconds);
    }
    
    func formattedTimeString(_ totalMilliSeconds: Int) -> String {
        
        let timeString = String(format: "%02d:%02d:%02d", Int((currentTimeInMilliSeconds / 600) % 60), Int((currentTimeInMilliSeconds / 10) % 60), Int(currentTimeInMilliSeconds % 10))
        return timeString
    }
    
    @IBAction func startTimer(_ sender: UIButton) {
        if ((timer != nil)){
            currentTimeInMilliSeconds = 0
        } else {
            timer = self.createTimer()
        }
    }
    
    @IBAction func stopTimer(_ sender: UIButton) {
        if (timer != nil) {
            timer?.invalidate()
        }
        timer = nil
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        if (timer != nil) {
            timer?.invalidate()
            timer = self.createTimer()
        }
        
        currentTimeInMilliSeconds = 0
        self.TimeLabel.text = self.formattedTimeString(currentTimeInMilliSeconds);
    }
    
    
    //Core Motion Instance Variables
    var currentMaxAccelX: Double = 0.0
    var currentMaxAccelY: Double = 0.0
    var currentMaxAccelZ: Double = 0.0
    
    var currentMaxRotX: Double = 0.0
    var currentMaxRotY: Double = 0.0
    var currentMaxRotZ: Double = 0.0
    
    var movementManager = CMMotionManager()
    
    let speechSynth = AVSpeechSynthesizer()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "rainbow")!)
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurView, at: 0)
        
        
        self.lowerWrapper.layer.cornerRadius = 5
        self.lowerWrapper.layer.borderColor = UIColor.black.cgColor
        
        currentMaxAccelX = 0
        currentMaxAccelY = 0
        currentMaxAccelZ = 0
        
        currentMaxRotX = 0
        currentMaxRotY = 0
        currentMaxRotZ = 0
        
        movementManager.gyroUpdateInterval = 1.0
        movementManager.accelerometerUpdateInterval = 1.0
        
        //Start Recording Data
        movementManager.startAccelerometerUpdates(to: OperationQueue.current!) { (accelerometerData: CMAccelerometerData?, NSError) -> Void in
            
            self.outputAccData(acceleration: accelerometerData!.acceleration)
            if(NSError != nil) {
                print("\(NSError)")
            }
        }
        
        movementManager.startGyroUpdates(to: OperationQueue.current!, withHandler: { (gyroData: CMGyroData?, NSError) -> Void in
            self.outputRotData(rotation: gyroData!.rotationRate)
            if (NSError != nil){
                print("\(NSError)")
            }
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func outputAccData(acceleration: CMAcceleration){
        
        if fabs(acceleration.x) > fabs(currentMaxAccelX)
        {
            currentMaxAccelX = acceleration.x
        }
        
        if fabs(acceleration.y) > fabs(currentMaxAccelY)
        {
            currentMaxAccelY = acceleration.y
        }
        
        if fabs(acceleration.z) > fabs(currentMaxAccelZ)
        {
            currentMaxAccelZ = acceleration.z
        }
        
        if (fabs(pow(acceleration.z, 2.0)) + fabs(pow(acceleration.y, 2.0)) + fabs(pow(
            acceleration.x, 2.0)) > 4.5) {
            
            let speech = AVSpeechUtterance(string: "Keep up the Good Work!")
            speech.pitchMultiplier = 0.9
            speechSynth.speak(speech)
        } /* else if (fabs(pow(acceleration.z, 2.0)) + fabs(pow(acceleration.y, 2.0)) + fabs(pow(
            acceleration.x, 2.0)) < 1) {
            
            let speech = AVSpeechUtterance(string: "Keep Moving!")
            speech.pitchMultiplier = 0.9
            speechSynth.speak(speech)
        } */
        
        
    }
    
    
    func outputRotData(rotation: CMRotationRate){
        
        if fabs(rotation.x) > fabs(currentMaxRotX)
        {
            currentMaxRotX = rotation.x
        }
        
        if fabs(rotation.y) > fabs(currentMaxRotY)
        {
            currentMaxRotY = rotation.y
        }
        
        if fabs(rotation.z) > fabs(currentMaxRotZ)
        {
            currentMaxRotZ = rotation.z
        }
        
        if (fabs(pow(rotation.z, 2.0)) + fabs(pow(rotation.y, 2.0)) + fabs(pow(
            rotation.x, 2.0)) > 3) {
            
            print(rotation.z)
            print(rotation.x)
            print(rotation.y)
            let speech = AVSpeechUtterance(string: "Do not rotate!")
            speech.pitchMultiplier = 0.9
            speechSynth.speak(speech)
        } /* else if (fabs(pow(rotation.z, 2.0)) + fabs(pow(rotation.y, 2.0)) + fabs(pow(
            rotation.x, 2.0)) < 0.4) {
            
            print(rotation.z)
            print(rotation.x)
            print(rotation.y)
            let speech = AVSpeechUtterance(string: "Stay Steady and Straight!")
            speech.pitchMultiplier = 0.9
            speechSynth.speak(speech)
        } */
    }
}

