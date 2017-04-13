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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        daysCollectionView.dataSource = self
        daysCollectionView.delegate = self
        fetchDaysFromCoreData()
        
        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(gesture:)))
        lpgr.minimumPressDuration = 1.0
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = true
        self.daysCollectionView?.addGestureRecognizer(lpgr)
        // Do any additional setup after loading the view.
    }
    
    /*func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){
        
        if (gestureRecognizer.state != UIGestureRecognizerState.ended){
            return
        }
        
        let p = gestureRecognizer.location(in: self.daysCollectionView)
        
        if let indexPath : NSIndexPath = (self.daysCollectionView?.indexPathForItem(at: p))! as NSIndexPath? {
            let day = savedDays[indexPath.row]
            context.delete(day)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            fetchDaysFromCoreData()
            daysCollectionView.reloadData()
            
        }
        
    }*/
    
    @objc func handleLongPress(gesture : UILongPressGestureRecognizer!) {
        if gesture.state != .ended {
            return
        }
        let p = gesture.location(in: self.daysCollectionView)
        
        if let indexPath = self.daysCollectionView.indexPathForItem(at: p) {
            
            let day = savedDays[indexPath.row]
            context.delete(day)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            fetchDaysFromCoreData()
            daysCollectionView.reloadData()
            
        } else {
            print("couldn't find index path")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchDaysFromCoreData()
        daysCollectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "dayToExercises", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedDays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = daysCollectionView.dequeueReusableCell(withReuseIdentifier: "dayCollectionViewCell", for: indexPath) as? DaysCollectionViewCell {
            //let workout = savedWorkouts[indexPath.row]
            cell.dayLabel.text = "Hello"
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
