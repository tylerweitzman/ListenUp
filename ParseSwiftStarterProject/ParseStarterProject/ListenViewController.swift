//
//  ListenViewController.swift
//  ParseStarterProject
//
//  Created by Tyler Weitzman on 6/27/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class ListenViewController: UIViewController {

    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var toolbarView: UIToolbar!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var sliderView: UISlider!
    var speech = Speech()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sliderTouchUp(sliderView)
        pauseButton.enabled = false
//        pauseButton.width = 0
        
    }
    @IBAction func play(sender: AnyObject) {
        if !pauseButton.enabled {
            speech.delegate = self
            speech.speak("banana banana banana banana banana")
            pauseButton.enabled = true
            playButton.enabled = false
        } else {
            speech.pause()
            pauseButton.enabled = false
            playButton.enabled = true
        }
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
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        speedLabel.text = NSString(format: "Speed %.01fx", sender.value) as String
    }

    @IBAction func sliderTouchUp(sender: UISlider) {
        speedLabel.text = NSString(format: "Speed %.01fx", sender.value) as String
        speech.scaledRate = sender.value
        
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
    }
}