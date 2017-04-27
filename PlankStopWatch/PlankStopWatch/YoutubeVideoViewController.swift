//
//  YoutubeVideoViewController.swift
//  PlankStopWatch
//
//  Created by Kireet Agrawal on 4/25/17.
//  Copyright © 2017 Kireet Agrawal. All rights reserved.
//

import UIKit
import YouTubePlayer

class YoutubeVideoViewController: UIViewController {

    var videoId: String?
    var videoPlayer: YouTubePlayerView!
    
    @IBOutlet weak var wv: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadYoutube(videoID: self.videoId!)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func loadYoutube(videoID:String) {
        guard
            let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)")
            else { return }
        wv.loadRequest( URLRequest(url: youtubeURL) )
    }
    
    /*func loadYoutube(videoID:String) {
        guard
            let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)")
            else { return }
        let width = self.view.widthAnchor
        let height = self.view.heightAnchor
        let frameRequest: NSString = "<iframe width=\(width) height =\(height) src=\(youtubeURL) allowfullscreen></iframe" as NSString;
        
        wv.loadHTMLString(frameRequest as String, baseURL: nil)
        //webView.loadRequest( URLRequest(url: youtubeURL) )
    }*/
    
    /* override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        let playerFrame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        let videoPlayer = YouTubePlayerView(frame: playerFrame)
        /*videoPlayer.playerVars = [
            "playsinline": "1" as AnyObject,
            "controls": "0" as AnyObject,
            "showinfo": "0" as AnyObject
        ]*/
        //if (videoId != nil) {
          //  print("here1")
            //videoPlayer.loadVideoID(videoId!)
            //print("here")
        //}
        print("success")
        print(videoPlayer)
        
        self.view.addSubview(videoPlayer)
        
        // Do any additional setup after loading the view.
    }
    
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        print("Player Ready")
        videoPlayer.loadVideoID(videoId!)
    }
    
    @IBAction func playButton(_ sender: Any) {
        if videoPlayer != nil {
            //if videoPlayer.ready {
                if videoPlayer.playerState != YouTubePlayerState.Playing {
                    videoPlayer.play()
                    playButton.setTitle("Pause", for: .normal)
                } else {
                    videoPlayer.pause()
                    playButton.setTitle("Play", for: .normal)
                }
            //}
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
