##Contacts Framework 学习笔记

iOS9 新的知识，应该算是代替之前的备受嫌弃的AddressBook framework，参考<https://www.shinobicontrols.com/blog/ios9-day-by-day-day7-contacts-framework>，本文语言Swift2.0，工具 XCode 7.2


###开始
首先我们要在头部引入 Contacts 和 ContactsUI 框架

    import Contacts

    import ContactsUI
    
然后我们写一个方法来获取所有的联系人信息，将其放入一个数组中
    
    let store = CNContactStore()

*CNContactStore* 是一个用来读取和保存联系人的新的类，当我们有了这个联系人数据库的引用后，我们需要创建一个指定条件的请求，通过这个去获取某些结果。创建一个 *CNContactFetchRequest*，我们可以通过设置 contact keys 的数组，来获取我们需要的结果。有趣的是，我们可以通过*CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName)* 来格式化。这是*CNContactFormattter*的一个非常方便的方法，*CNContactFormatter* 需要很多不同的 keys，如果不使用 *descriptorForRequiredKeysForStyle* 方法，我们需要手动设置以下的 keys。

    [CNContactGivenNameKey, CNContactNamePrefixKey, CNContactNameSuffixKey, CNContactMiddleNameKey, CNContactFamilyNameKey, CNContactTypeKey...] 

关键代码：

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
        
之后在应该的时候调用这个方法，最后根据获得的联系人数组，可通过*tableView*等方式显示在界面上

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var numberArray: [String] = [String]()
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let contact = self.dataSource![indexPath.row] as CNContact
        
        for number in contact.phoneNumbers {
            let phoneNumber = number.value as! CNPhoneNumber
            numberArray.append(phoneNumber.stringValue)
        }
        //拼接一下获得的号码
        let numberString = numberArray.joinWithSeparator("/")
        
        cell.textLabel?.text = "\(contact.givenName)  \(numberString)"
        return cell
        
    }

    
除此之外苹果直接给了我们一个可用的*CNContactPickerViewController*，通过它我们可以直接访问系统的通讯录，让用户选择某个电话号码，并且保存起来，通过代理 *CNContactPickerDelegate* 方法得到用户选择的数据。

Demo中我直接在viewController中添加一个button，按钮事件为：

	@IBAction func action_ToSystemAddressButtonPressed(sender: AnyObject) {
        
        let contactPicker: CNContactPickerViewController = CNContactPickerViewController()
        //设置代理
        contactPicker.delegate = self
        //添加过滤条件
        contactPicker.displayedPropertyKeys = [CNContactPhoneNumbersKey, CNContactPhoneticFamilyNameKey]
         //添加可选项目的过滤条件
        contactPicker.predicateForEnablingContact = NSPredicate(format: "emailAddresses.@count > 0", argumentArray: nil)
        //推出picker
        self.presentViewController(contactPicker, animated: true) { () -> Void in
            //推送完成后要做的事
        }
    }

之后我们来实现代理方法，一共有五个可选的代理方法，其中有两对分别用于处理单选和多选，在Demo中只实现了其中一个单选的方法：

	func contactPicker(picker: CNContactPickerViewController, didSelectContactProperty contactProperty: CNContactProperty) {
        
        let contact = contactProperty.contact
        let phoneNumber = contactProperty.value as! CNPhoneNumber
        //获取所需的属性
        print(contact.givenName)
        print(phoneNumber.stringValue)
    }

![](http://ww1.sinaimg.cn/large/a83274d0gw1f040cpg9auj20dw0mj3zg.jpg)

