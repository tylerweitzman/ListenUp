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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.parseClassName = ParseConstants.NotesClass
    }
    
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: ParseConstants.NotesClass)
//        query.whereKey("user", equalTo: PFUser.currentUser()!)
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {

        var cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath) as! PFTableViewCell

        if let obj = object {
            cell.textLabel?.text = obj["title"] as? String
            cell.detailTextLabel?.text = obj["content"] as? String
        }
        
        return cell
        
    }


}
    