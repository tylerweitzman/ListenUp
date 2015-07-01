//
//  ListenViewController.swift
//  ParseStarterProject
//
//  Created by Tyler Weitzman on 6/27/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//
import AVFoundation
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
//    var location = CLLocationManager()
    
    var speech : Speech = Speech()
    var cursor : Double = 0
    var commandCenter = MPRemoteCommandCenter.sharedCommandCenter()
    var backgroundTask : UIBackgroundTaskIdentifier?
    var note : (String, String)?
    var lastSearch : String?
    var obj : PFObject? {
        didSet {
//            speech.restartWithPercent(0.5)
            /*
            if let cursor = obj?.objectForKey("cursor") as? Double {
//                speech.cursor = cursor
                speech.restartWithPercent(cursor)
//                speech.pause()
            }*/
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
        pauseButton.enabled = false
//        pauseButton.width = 0
        
//        location.requestAlwaysAuthorization()
//        location.requestWhenInUseAuthorization()
        //        location.reque
        //        location.delegate = self
//        location.desiredAccuracy = kCLLocationAccuracyBest
//        location.startUpdatingLocation()
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        
        backgroundTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
            UIApplication.sharedApplication().endBackgroundTask(self.backgroundTask!)
            
        }
        
        commandCenter = MPRemoteCommandCenter.sharedCommandCenter()
        commandCenter.playCommand.addTarget(self, action: Selector("play"))
//        commandCenter.playCommand.enabled = false
        commandCenter.pauseCommand.addTarget(self, action: Selector("play"))
       commandCenter.togglePlayPauseCommand.addTarget(self, action: Selector("play"))
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        commandCenter.skipForwardCommand.addTarget(self, action: Selector("forwards"))
        commandCenter.skipBackwardCommand.addTarget(self, action: Selector("backwards"))
        var infoCenter = MPNowPlayingInfoCenter.defaultCenter()
        var item = MPMediaItem()
//        item.title = "Title"
        let stringTitle = note?.0 ?? " "
        titleLabel.text = stringTitle
        self.title = stringTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: Selector("search"))
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
        play()
        if let speed = NSUserDefaults.standardUserDefaults().objectForKey("Speed") as? Float {
            println("speed set at \(speed)")
            sliderView.value = speed
        }
        self.sliderTouchUp(sliderView)
        if let obj = self.obj {
            if let loc = obj.objectForKey("cursor") as? Float {
                speech.restartWithPercent((Double)(loc))
                scrubSlider.value = loc
            }
        }
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
//            speech.scanToWord("girlfriend")
            
//            pauseButton.enabled = true
//            playButton.setImage(UIImage(named: "Pause.png"), forState: UIControlState.Normal)
//            playButton.enabled = false
            endLabel.text = ".."
            
        } else {
            speech.pause()
//            playButton.setImage(UIImage(named: "Play.png"), forState: UIControlState.Normal)
//            pauseButton.enabled = false
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
    
    func search() {
        var alert = UIAlertController(title: "Search", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler { (textField :UITextField!) -> Void in
            textField.text = self.lastSearch ?? ""
            textField.autocorrectionType = UITextAutocorrectionType.Yes
        }
        alert.addAction(UIAlertAction(title: "Search", style: UIAlertActionStyle.Default, handler: { (alertAction: UIAlertAction!) -> Void in
            if let textField = alert.textFields?.first as? UITextField {
                self.speech.scanToWord(textField.text)
                self.lastSearch = textField.text
            }
        }))
        self.speech.stopSpeaking()
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func scrubValueChanged(sender: UISlider) {
        percentLabel.text = String(format: "%.0f", 100*sender.value) + "%"
        Speech.formatTime((Double)(sender.value) * speech.estimatedLength)
        speech.pause()
//        println("pause")
    }
    @IBAction func sliderValueChanged(sender: UISlider) {
        speedLabel.text = NSString(format: "Speed %.01fx", sender.value) as String
    }
    override func viewWillDisappear(animated: Bool) {
                speech.stopSpeaking()
        speech.totalString = nil
        speech.utterance = nil
    }
    @IBAction func sliderTouchUp(sender: UISlider) {
        speedLabel.text = NSString(format: "Speed %.01fx", sender.value) as String
        speech.scaledRate = sender.value
//        speech.pause()
        endLabel.text = ".."
        println("Changed rate. Speed set at \(sender.value)")
        NSUserDefaults.standardUserDefaults().setObject(sender.value, forKey: "Speed")
        NSUserDefaults.standardUserDefaults().synchronize()


        

        
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
    func playing() {
        println("Starting")
        pauseButton.enabled = true
//        playButton.enabled = false
        
        playButton.setImage(UIImage(named: "Pause.png"), forState: UIControlState.Normal)
    }
    func paused() {
        didFinish()
    }
    
    func stopped() {
        didFinish()
    }
    func wordWillBeSpoken(word: String) {
//        wordLabel.text = word
//        1 letter = first, up to 5 including 5 is the second, over 5 is the third
        var i = 0
        switch count(word) {
            case 1:
                i = 0
            case 2...5:
                i = 1
            case 5...9999999:
                i = 2
            default:
                i = 1
        }
        
        var w = word
        /*
        for x in 0...i {
            w = " " + word
        }*/
        
        var str = NSMutableAttributedString(string: w)
        str.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSMakeRange(i, 1))
//        wordLabel.attributedText = NSAttributedString(string: word)
        wordLabel.attributedText = str
        
    }
    
    func didFinish() {
        println("Finish")
        pauseButton.enabled = false
//        playButton.enabled = true
        
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