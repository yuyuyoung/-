//
//  NewViewController.swift
//  访问系统通讯录
//
//  Created by yangyu on 16/1/18.
//  Copyright © 2016年 YangYiYu. All rights reserved.
//

import UIKit
import Contacts

class NewViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    internal var dataSource: [CNContact]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataSource!.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var numberArray: [String] = [String]()
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let contact = self.dataSource![indexPath.row] as CNContact
        
        for number in contact.phoneNumbers {
            let phoneNumber = number.value as! CNPhoneNumber
            numberArray.append(phoneNumber.stringValue)
        }
        
        let numberString = numberArray.joinWithSeparator(",")
        
        cell.textLabel?.text = "\(contact.givenName)  \(numberString)"
        return cell
        
    }
    
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
        print(segue.identifier)
    }
    */
    

}
