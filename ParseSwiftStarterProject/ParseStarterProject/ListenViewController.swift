//
//  ListenViewController.swift
//  ParseStarterProject
//
//  Created by Tyler Weitzman on 6/27/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class ListenViewController: UIViewController {

    @IBOutlet weak var wordLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func play(sender: AnyObject) {
        var speech = Speech()
        speech.delegate = self
        speech.speak("Hello")
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
        wordLabel.text = word
    }
}