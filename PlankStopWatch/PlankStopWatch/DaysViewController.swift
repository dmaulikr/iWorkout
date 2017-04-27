//
//  DaysViewController.swift
//  PlankStopWatch
//
//  Created by Kireet Agrawal on 4/12/17.
//  Copyright © 2017 Kireet Agrawal. All rights reserved.
//

import UIKit
import CoreData

class DaysViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var daysCollectionView: UICollectionView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var savedDays: [Day] = []
    var daySender: Day?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        daysCollectionView.dataSource = self
        daysCollectionView.delegate = self
        fetchDaysFromCoreData()
        daysCollectionView.reloadData()
        
        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(gesture:)))
        lpgr.minimumPressDuration = 1.0
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = true
        self.daysCollectionView?.addGestureRecognizer(lpgr)
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchDaysFromCoreData()
        daysCollectionView.reloadData()
        
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.black
        let backgroundImage = UIImage(named: "rain")
        let imageView = UIImageView(image: backgroundImage)
        daysCollectionView.backgroundView = imageView
        
        /*let blur = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.view.bounds
        daysCollectionView.insertSubview(blurView, at: 0)*/
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleLongPress(gesture : UILongPressGestureRecognizer!) {
        //Used to delete a day from the collection view.
        if gesture.state != .ended {
            return
        }
        let p = gesture.location(in: self.daysCollectionView)
        
        if let indexPath = self.daysCollectionView.indexPathForItem(at: p) {
            
            let alert = UIAlertController(title: "Delete your day", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.default, handler:
                { action in
                    let day = self.savedDays[indexPath.row]
                    self.context.delete(day)
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    self.fetchDaysFromCoreData()
                    self.daysCollectionView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            
        } else {
            print("couldn't find index path")
        }
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        daySender = savedDays[indexPath.row]
        performSegue(withIdentifier: "dayToExercises", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedDays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = daysCollectionView.dequeueReusableCell(withReuseIdentifier: "dayCollectionViewCell", for: indexPath) as? DaysCollectionViewCell {
            let day = savedDays[indexPath.row]
            cell.dayLabel.text = day.dayTitle
            cell.backgroundColor = UIColor.init(colorLiteralRed: 0.96, green: 0.95, blue: 0.95, alpha: 1.0)
            
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 2.0
            cell.layer.cornerRadius = 10
            return cell
        }
        return UICollectionViewCell()
    }
    
    @IBAction func addDay(_ sender: Any) {
        performSegue(withIdentifier: "addDaySegue", sender: self)
    }

    func fetchDaysFromCoreData() {
        do {
            savedDays = try context.fetch(Day.fetchRequest())
        } catch {
            print("Failed to obtain the workouts boi")
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier! == "dayToExercises") {
            if let nextVC = segue.destination as? WorkoutListViewController {
                if let daySender = daySender {
                    nextVC.day = daySender
                    nextVC.passedWorkouts = Array(daySender.workouts!) as! [Workout]
                }
            }
        }
    }
    

}
