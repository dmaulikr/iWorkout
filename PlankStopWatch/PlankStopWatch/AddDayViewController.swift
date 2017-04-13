//
//  AddDayViewController.swift
//  PlankStopWatch
//
//  Created by Kireet Agrawal on 4/12/17.
//  Copyright © 2017 Kireet Agrawal. All rights reserved.
//

import UIKit
import CoreData

class AddDayViewController: UIViewController {

    var dayTitle: String?
    @IBOutlet weak var dayField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hue: 0.5389, saturation: 1, brightness: 0.92, alpha: 1.0)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateDay(_ sender: Any) {
        dayTitle = dayField.text
    }
    
    @IBAction func cancelDay(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    @IBAction func saveWorkoutDay(_ sender: Any) {
        
        if (dayTitle != nil || dayField.text != nil) {
            dayTitle = dayField.text
            let appDel = UIApplication.shared.delegate
                as! AppDelegate
            let context = appDel.persistentContainer.viewContext
            let day = Day(context: context)
            day.dayTitle = dayTitle
            
            appDel.saveContext()
            
            //performSegue(withIdentifier: "saveWorkout", sender: "save")
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
        }

        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
