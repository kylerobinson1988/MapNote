//
//  MenuViewController.swift
//  MapNote
//
//  Created by Kyle Brooks Robinson on 7/29/16.
//  Copyright © 2016 Kyle Brooks Robinson. All rights reserved.
//

import UIKit
import CoreLocation

class MenuModel {
    
    var users: [[String:AnyObject]] = []
    
    
    
    

    init(users: [[String:AnyObject]]) {
        
        self.users = users
        
    }
    
}

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var users: [[String:AnyObject]] = [
        //Insert fake data
    
    
    
    ]
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: return 1
        default: return users.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("menuAddCell") as! MenuAddCell
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("menuItemCell") as! MenuItemCell
            cell.nameLabel.text = users[indexPath.row]["name"] as? String
            cell.noteNumberLabel.text = users[indexPath.row]["notesNumber"] as? String
            return cell
        }
        
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showMapView" {
            //Setup
            
            
        }
        
    }

}









