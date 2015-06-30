//
//  NotesTableViewController.swift
//  ParseStarterProject
//
//  Created by Tyler Weitzman on 6/27/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ParseUI

class NotesTableViewController: PFQueryTableViewController {
    var selectedNote : (String, String)?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.parseClassName = ParseConstants.NotesClass
//        self.tableView.delegate = self
    }
    @IBAction func logOut(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) -> Void in
//            
            var delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            delegate.displayWindow()
            println("hello")
        }
    }
    
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: ParseConstants.NotesClass)
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.orderByDescending("createdAt")
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {

        var cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath) as! PFTableViewCell

        if let obj = object {
            cell.textLabel?.text = obj["title"] as? String
            if let content = obj["content"] as? String {
//                if content != nil {
                    let time = Speech.defaultLengthForString(content)
                    cell.detailTextLabel?.text = time
//                }
            }

//          obj["content"] as? String
        }
        
        return cell
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowExistingNote" {
            var vc = segue.destinationViewController as! ListenViewController
            let indexPath = tableView.indexPathForSelectedRow()
            if let obj = self.objectAtIndexPath(indexPath) {
                if let title = obj["title"] as? String, let content = obj["content"] as? String {
                    selectedNote = (title, content)
                    vc.note = selectedNote
                    vc.obj = obj
                    if let cursor : Double = obj.objectForKey("cursor") as! Double? {
                        //                speech.cursor = cursor
                        vc.cursor = cursor
                        //                speech.pause()
                    }
                    println(selectedNote!.1)
                    
                } else {
                    // Casting unsuccessful
                }
            }

        }
    }
    /*
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
if segue.identifier == "ShowExistingNote" {
var vc = segue.destinationViewController as! ListenViewController
let indexPath = tableView.indexPathForSelectedRow()
if let obj = self.objectAtIndexPath(indexPath) {
if let title = obj["title"], let content = obj["content"] {
selectedNote = (title as! String, content as! String)
vc.note = selectedNote
vc.obj = obj
if let cursor : Double = obj.objectForKey("cursor") as! Double? {
//                speech.cursor = cursor
vc.cursor = cursor
//                speech.pause()
}
println(selectedNote!.1)

}
}

}
}*/


}

