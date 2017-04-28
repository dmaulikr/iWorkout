//
//  WorkoutListViewController.swift
//  PlankStopWatch
//
//  Created by Kireet Agrawal on 3/23/17.
//  Copyright © 2017 Kireet Agrawal. All rights reserved.
//

import UIKit
import Alamofire

class WorkoutListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let API_KEY = "AIzaSyBCLB0hgrfZfTlKHadr69U4ZHitDWxLo-U"
    var videoId: String?
    
    var passedWorkouts: [Workout] = []
    var day: Day?
    var motivationMode = false
    @IBOutlet weak var motivationButton: UIButton!
    
    @IBAction func changeMotivationMode(_ sender: Any) {
        self.motivationMode = !self.motivationMode
    }
    
    @IBAction func editOrder(_ sender: Any) {
        workoutTableView.isEditing = !workoutTableView.isEditing
    }
    @IBOutlet weak var workoutTableView: UITableView!
    
    
    //let testWorkout = Workout("Monday", ["Back pull downs", "biceps curls"])
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var savedWorkouts: [Workout] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.motivationButton.layer.cornerRadius = 5
        workoutTableView.delegate = self
        workoutTableView.dataSource = self
        updatePassedWorkouts()
        //fetchWorkoutsFromCoreData()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //fetchWorkoutsFromCoreData()
        updatePassedWorkouts()
        workoutTableView.reloadData()
        
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.black
        let backgroundImage = UIImage(named: "fire")
        let imageView = UIImageView(image: backgroundImage)
        workoutTableView.backgroundView = imageView
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        workoutTableView.insertSubview(blurView, at: 0)
        
        //workoutTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    @IBAction func addWorkout(_ sender: Any) {
        performSegue(withIdentifier: "addWorkout", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchURL = "https://www.googleapis.com/youtube/v3/search"
        let workoutTitle = passedWorkouts[indexPath.row].title!
        var workoutParam = workoutTitle
        if motivationMode {
            workoutParam = "motivation " + workoutTitle
        }
        print(workoutParam)
        let params = ["part": "snippet", "q": workoutParam, "safeSearch": "moderate", "key": API_KEY, "maxResults": "1"]
        
        Alamofire.request(searchURL, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if let JSON = response.result.value {
                
                if let dictionary = JSON as? NSDictionary {
                    print(dictionary)
                    for item in dictionary["items"] as! NSArray {
                        self.videoId = (item as AnyObject).value(forKeyPath: "id.videoId") as! String
                        // TODO Create video objects off of the JSON response
                        print(self.videoId)
                        
                    }
                    if (self.videoId != nil) {
                        self.performSegue(withIdentifier: "showYoutubeVideo", sender: self)
                    }
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(passedWorkouts.count)
        return passedWorkouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = workoutTableView.dequeueReusableCell(withIdentifier: "workoutDayCell") as? WorkoutListTableViewCell {
            //let workout = savedWorkouts[indexPath.row]
            let workout = passedWorkouts[indexPath.row]
            cell.titleLabel.text = workout.title
            cell.activityLabel.text = workout.activity
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //let workout = savedWorkouts[indexPath.row]
            let workout = passedWorkouts[indexPath.row]
            context.delete(workout)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            //fetchWorkoutsFromCoreData()
            updatePassedWorkouts()
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.1
    }
    
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var itemToMove = passedWorkouts[sourceIndexPath.row]
        passedWorkouts.remove(at: sourceIndexPath.row)
        passedWorkouts.insert(itemToMove, at: destinationIndexPath.row)
        workoutTableView.reloadData()
    }
    
    func fetchWorkoutsFromCoreData() {
        do {
            savedWorkouts = try context.fetch(Workout.fetchRequest())
        } catch {
            print("Failed to obtain the workouts boi")
        }
    }
    
    func updatePassedWorkouts() {
        do {
            if (day != nil) {
                passedWorkouts = try (Array(day!.workouts!) as! [Workout])
            }
        } catch {
            print("Failed to update passed workouts ")
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier! == "addWorkout") {
            if let nextVC = segue.destination as? AddWorkoutViewController {
                if let day = day {
                    nextVC.day = day
                }
            }
        } else if (segue.identifier! == "showYoutubeVideo") {
            if let nextVC = segue.destination as? YoutubeVideoViewController {
                if let video = self.videoId {
                    nextVC.videoId = video
                }
            }
        }
    }
 

}
