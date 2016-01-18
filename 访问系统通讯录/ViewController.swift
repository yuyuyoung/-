//
//  ViewController.swift
//  访问系统通讯录
//
//  Created by yangyu on 16/1/18.
//  Copyright © 2016年 YangYiYu. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class ViewController: UIViewController, CNContactPickerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    //直接调用系统的通讯录
    @IBAction func action_ToSystemAddressButtonPressed(sender: AnyObject) {
        
        let contactPicker: CNContactPickerViewController = CNContactPickerViewController()
        //设置代理
        contactPicker.delegate = self
        //添加详细界面过滤条件
        contactPicker.displayedPropertyKeys = [CNContactPhoneNumbersKey, CNContactPhoneticFamilyNameKey]
        //添加可选项目的过滤条件
        contactPicker.predicateForEnablingContact = NSPredicate(format: "emailAddresses.@count > 0", argumentArray: nil)
        self.presentViewController(contactPicker, animated: true) { () -> Void in
            
        }
    }
    
    @IBAction func goback(segue: UIStoryboardSegue) {
    }
    
    func contactPicker(picker: CNContactPickerViewController, didSelectContactProperty contactProperty: CNContactProperty) {
        
        let contact = contactProperty.contact
        let phoneNumber = contactProperty.value as! CNPhoneNumber
        
        print(contact.givenName)
        print(phoneNumber.stringValue)
    }
    
    func getContacts() -> [CNContact] {
        let store = CNContactStore()
        
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName), CNContactImageDataKey, CNContactPhoneNumbersKey, CNContactFamilyNameKey]
        
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
        
        var contacts = [CNContact]()
        do {
            try store.enumerateContactsWithFetchRequest(fetchRequest, usingBlock: { (let contact, let stop) -> Void in
                contacts.append(contact)
            })
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        return contacts
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //从系统通讯录中获取信息显示
        
        if segue.identifier == "GetAddress" {
            
            if let toViewController = segue.destinationViewController as? NewViewController {
                
                toViewController.dataSource = self.getContacts()
                
            }
        }
    }

}

