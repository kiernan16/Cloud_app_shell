//
//  VideoPlayerViewController.swift
//  Nielsen Cloud App
//
//  Created by Nielsen on 4/9/17.
//  Copyright © 2017 Nielsen. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoPlayerViewController: UIViewController {
    @IBOutlet weak var playerFrame: UIView!
    var player = AVPlayer()
    let avpController = AVPlayerViewController()
    var timer: DispatchSourceTimer?
    
    var currentItem: AVPlayerItem!
    
    var nielsenSessionID = ""
    var isFirstTime = true
    var isComplete = false
    
    override func viewWillAppear(_ animated: Bool) {
    

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/bipbop_4x3_variant.m3u8")
        
        player = AVPlayer(url: url!)
        
        avpController.player = player
        avpController.view.frame = playerFrame.frame
        self.addChildViewController(avpController)
        self.view.addSubview(avpController.view)
        
        currentItem = player.currentItem!
        
        player.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions.new, context: nil)

        
        player.play()

    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if player.rate > 0.0 {
            if (isFirstTime == true) {
                sessionID = String(Int(NSTimeIntervalSince1970)*Int(arc4random()/332))
                isFirstTime = false
            }
            
            //Set total length
            let duration : CMTime = player.currentItem!.asset.duration
            let seconds = String(Int(CMTimeGetSeconds(duration)))
            length = seconds
            
            isComplete = false
            startTimer()
        }
        
        if player.rate < 1.0 {
            timer?.cancel()
            
            var playhead = self.getTime()
            NielsenCloud(Cloud_Event: "playhead", Playhead_Time: playhead, Content_Type: "content")
        
            if(playhead == length) {
                NielsenCloud(Cloud_Event: "complete", Playhead_Time: playhead, Content_Type: "content")
                isComplete = true
            }
        }
    }

     func startTimer() {
        let queue = DispatchQueue(label: "com.firm.app.timer", attributes: .concurrent)
        
        timer?.cancel()        // cancel previous timer if any
        
        timer = DispatchSource.makeTimerSource(queue: queue)
        
        timer?.scheduleRepeating(deadline: .now(), interval: .seconds(10), leeway: .milliseconds(100))
        
        timer?.setEventHandler {  // `[weak self]` only needed if you reference `self` in this closure and you want to prevent strong reference cycle
            
           NielsenCloud(Cloud_Event: "playhead", Playhead_Time: self.getTime(), Content_Type: "content")
        }
        
        timer?.resume()
    }
    
    
    func getTime() -> String {
        let t1 = Float(self.player.currentTime().value)
        let t2 = Float(self.player.currentTime().timescale)
        
        return String(Int(t1 / t2))
    }
    

    
    @IBAction func exitPlayer(_ sender: UIButton) {
        timer?.cancel()
        if (isComplete == false) {
            NielsenCloud(Cloud_Event: "playhead", Playhead_Time: self.getTime(), Content_Type: "content")
        }
        NielsenCloud(Cloud_Event: "delete", Playhead_Time: "", Content_Type: "content")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
