//
//  WorkoutListViewController.swift
//  PlankStopWatch
//
//  Created by Kireet Agrawal on 3/23/17.
//  Copyright © 2017 Kireet Agrawal. All rights reserved.
//

import UIKit

class WorkoutListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var workoutTableView: UITableView!
    
    
    //let testWorkout = Workout("Monday", ["Back pull downs", "biceps curls"])
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var savedWorkouts: [Workout] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workoutTableView.delegate = self
        workoutTableView.dataSource = self
        fetchWorkoutsFromCoreData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchWorkoutsFromCoreData()
        workoutTableView.reloadData()
    }
    
    @IBAction func addWorkout(_ sender: Any) {
        performSegue(withIdentifier: "addWorkout", sender: "listView")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(savedWorkouts.count)
        return savedWorkouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = workoutTableView.dequeueReusableCell(withIdentifier: "workoutDayCell") as? WorkoutListTableViewCell {
            let workout = savedWorkouts[indexPath.row]
            cell.titleLabel.text = workout.title
            cell.activityLabel.text = workout.activity
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let workout = savedWorkouts[indexPath.row]
            context.delete(workout)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            fetchWorkoutsFromCoreData()
        }
        tableView.reloadData()
    }
    
    
    func fetchWorkoutsFromCoreData() {
        do {
            savedWorkouts = try context.fetch(Workout.fetchRequest())
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
