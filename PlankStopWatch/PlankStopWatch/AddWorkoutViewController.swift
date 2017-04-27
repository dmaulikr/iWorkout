//
//  AddWorkoutViewController.swift
//  PlankStopWatch
//
//  Created by Kireet Agrawal on 3/23/17.
//  Copyright © 2017 Kireet Agrawal. All rights reserved.
//

import UIKit
import CoreData

class AddWorkoutViewController: UIViewController {
    
    var titleText: String?
    var activity: String?
    var day: Day?

    @IBOutlet weak var activityTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "rain")!)
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurView, at: 0)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addTitle(_ sender: Any) {
        titleText = titleTextField.text
    }

    @IBAction func addActivity(_ sender: Any) {
        activity = activityTextField.text
    }
    
    @IBAction func saveWorkout(_ sender: Any) {
        //Create Workout Model and save to core data
        if ((activityTextField.text != nil && titleTextField.text != nil) || (titleText != nil) && (activity != nil)) {
            
            if (day != nil) {
                addTitle(self)
                addActivity(self)
                let appDel = UIApplication.shared.delegate
                    as! AppDelegate
                let context = appDel.persistentContainer.viewContext
                let workout = Workout(context: context)
                workout.title = titleText
                workout.activity = activity
                workout.dayOwner = day
                appDel.saveContext()
                
            } else {
                print("save failed")
            }
            
            
            //performSegue(withIdentifier: "saveWorkout", sender: "save")
            if let navController = self.navigationController {
                let workoutListViewController = navController.parent as? WorkoutListViewController
                workoutListViewController?.day = day
                navController.popViewController(animated: true)
            }
        }
        
    }
    
    @IBAction func cancelWorkout(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
        //performSegue(withIdentifier: "cancelWorkout", sender: "cancel")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier! == "saveWorkout") {
            if let nextVC = segue.destination as? WorkoutListViewController {
                
            }
        }

    }
    */

}
