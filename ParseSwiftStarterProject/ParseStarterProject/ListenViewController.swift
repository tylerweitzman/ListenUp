//
//  ListenViewController.swift
//  ParseStarterProject
//
//  Created by Tyler Weitzman on 6/27/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import MediaPlayer
import Parse
import CoreLocation
class ListenViewController: UIViewController {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var percentLabel : UILabel!
    @IBOutlet weak var scrubSlider: UISlider!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    
    @IBOutlet var controlView: UIView!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var sliderView: UISlider!
    var location = CLLocationManager()
    
    var speech = Speech()
    var cursor : Double = 0
    var commandCenter = MPRemoteCommandCenter.sharedCommandCenter()
    var backgroundTask : UIBackgroundTaskIdentifier?
    var note : (String, String)?
    var obj : PFObject? {
        didSet {
            if let cursor = obj?.objectForKey("cursor") as? Double {
//                speech.cursor = cursor
                speech.restartWithPercent(cursor)
//                speech.pause()
            }
        }
    }
    var saveConstraints : [AnyObject]?
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        scrubSlider.value = (Float)(cursor)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.saveConstraints = controlView.constraints()
        // Do any additional setup after loading the view.
        sliderTouchUp(sliderView)
        pauseButton.enabled = false
//        pauseButton.width = 0
        
        location.requestAlwaysAuthorization()
        location.requestWhenInUseAuthorization()
        //        location.reque
        //        location.delegate = self
        location.desiredAccuracy = kCLLocationAccuracyBest
        location.startUpdatingLocation()
        backgroundTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
            UIApplication.sharedApplication().endBackgroundTask(self.backgroundTask!)
            
        }
        
        commandCenter = MPRemoteCommandCenter.sharedCommandCenter()
        commandCenter.playCommand.addTarget(self, action: Selector("play"))
//        commandCenter.playCommand.enabled = false
        commandCenter.pauseCommand.addTarget(self, action: Selector("play"))
        commandCenter.togglePlayPauseCommand.addTarget(self, action: Selector("play"))
        commandCenter.skipForwardCommand.addTarget(self, action: Selector("forwards"))
        commandCenter.skipBackwardCommand.addTarget(self, action: Selector("backwards"))
        var infoCenter = MPNowPlayingInfoCenter.defaultCenter()
        var item = MPMediaItem()
//        item.title = "Title"
        let stringTitle = note?.0 ?? " "
        titleLabel.text = stringTitle
        
        infoCenter.nowPlayingInfo = [MPMediaItemPropertyTitle as NSObject: stringTitle as AnyObject!]
//        commandCenter.
//        commandCenter.playCommand.enabled = false
//        UISlider.appearance().setThumbImage(UIImage(), forState: UIControlState.Normal)
        let scrubSlider = UISlider.appearance()
        scrubSlider.setThumbImage(UIImage(), forState: UIControlState.Normal)
//        scrubSlider.backgroundColor = UIColor
        scrubSlider.setThumbImage(UIImage(named: "Pink_Player_Rectangle_Icon2.png"), forState: UIControlState.Normal)
        scrubSlider.minimumTrackTintColor = StyleConstants.pinkColor
        scrubSlider.maximumTrackTintColor = UIColor.clearColor()
//        speed
        self.scrubSlider.setThumbImage(UIImage(named: "Pink_Player_Rectangle_Icon.png"), forState: UIControlState.Normal)
            
        self.view.setNeedsLayout()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    @IBAction func backwards() {
        speech.backwards()
    }
    @IBAction func forwards() {
        speech.forwards()
    }
    /*
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
            let heightConstraint = NSLayoutConstraint(item: controlView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 0)
            controlView.addConstraint(heightConstraint)
            
            self.view.setNeedsUpdateConstraints()
//            self.view.remove
//            self.view.setNeedsLayout()
//            selcontrolView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(<#format: String#>, options: <#NSLayoutFormatOptions#>, metrics: <#[NSObject : AnyObject]?#>, views: <#[NSObject : AnyObject]#>))
        } else {
            self.view.addSubview(controlView)
            controlView.addConstraints(self.saveConstraints!)
            self.view.setNeedsLayout()
//            self.view.setNeedsDisplay()
//            self.view.setNeedsUpdateConstraints()
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }*/


    @IBAction func play() {

        if !pauseButton.enabled {
            speech.delegate = self
            var str = note?.1 ?? " "
            speech.speak(str)
            
            pauseButton.enabled = true
            playButton.setImage(UIImage(named: "Pause.png"), forState: UIControlState.Normal)
//            playButton.enabled = false
            endLabel.text = ".."
            
        } else {
            speech.pause()
            playButton.setImage(UIImage(named: "Play.png"), forState: UIControlState.Normal)
            pauseButton.enabled = false
//            playButton.enabled = true
        }
//        commandCenter.playCommand.enabled = playButton.enabled
//        commandCenter.pauseCommand.enabled = pauseButton.enabled

//        var button : UIBarButtonItem = sender as UIBarButtonItem
//      
        
        
    }
    /*
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation
    {
        return UIInterfaceOrientation.LandscapeLeft
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return (Int)(UIInterfaceOrientationMask.Landscape.rawValue)
    }
    
    override func shouldAutorotate() -> Bool {
        return UIInterfaceOrientationIsLandscape(self.interfaceOrientation)
    }*/



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func scrubValueChanged(sender: UISlider) {
        percentLabel.text = String(format: "%.0f", 100*sender.value) + "%"
        speech.pause()
//        println("pause")
    }
    @IBAction func sliderValueChanged(sender: UISlider) {
        speedLabel.text = NSString(format: "Speed %.01fx", sender.value) as String
    }
    override func viewWillDisappear(animated: Bool) {
                speech.stopSpeaking()
    }
    @IBAction func sliderTouchUp(sender: UISlider) {
        speedLabel.text = NSString(format: "Speed %.01fx", sender.value) as String
        speech.scaledRate = sender.value
//        speech.pause()
        endLabel.text = ".."
        println("Changed rate")
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ListenViewController : SpeechDelegate {
    func wordWillBeSpoken(word: String) {
//        wordLabel.text = word
//        1 letter = first, up to 5 including 5 is the second, over 5 is the third
        var i = 1
        switch count(word) {
            case 1:
                i = 1
            case 2...5:
                i = 2
            case 5...9999999:
                i = 3
            default:
                i = 1
        }
        var w = word
        for x in 0...i {
            w = " " + word
        }
        
        var str = NSMutableAttributedString(string: w)
        str.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSMakeRange(i-1, 1))
//        wordLabel.attributedText = NSAttributedString(string: word)
        wordLabel.attributedText = str
        
    }
    
    func didFinish() {
        pauseButton.enabled = false
        playButton.enabled = true
        
        playButton.setImage(UIImage(named: "Play.png"), forState: UIControlState.Normal)
        
    }
    
    @IBAction func scrubberTouchUp(sender: UISlider) {
//        speech.continueSpeaking()
        speech.restartWithPercent((Double)(sender.value))
    }
    func updateTimeRemaining(time: Double, percentComplete: Double) {
//        endLabel.text = NSString(format: "%2d", (NSTimeInterval)(time)) as String
//        startLabel.text ?.insert(<#newElement: Character#>, atIndex: <#String.Index#>)
        
        let estimatedTotal = speech.estimatedLength
        if estimatedTotal > 0 {
            endLabel.text = Speech.formatTime(estimatedTotal)
            endLabel.text = "~" + endLabel.text!
            var startTime = estimatedTotal - time
            startLabel.text = Speech.formatTime(startTime)
            startLabel.text = "~" + startLabel.text!
            self.scrubSlider.value = (Float)(startTime / estimatedTotal)
            self.percentLabel.text = String(format: "%.0f", 100*scrubSlider.value) + "%"
            obj?.setValue(scrubSlider.value, forKey: "cursor")
            obj?.saveInBackground()
            
        }
        
        

        

        
    }
}