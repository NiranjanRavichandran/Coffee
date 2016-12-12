//
//  JoinTableViewController.swift
//  Coffee
//
//  Created by Niranjan Ravichandran on 10/16/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class JoinTableViewController: UITableViewController, UITextFieldDelegate, SelectUserDelegate, PickerValueChangedDelegate {
    
    let contentOne = ["First Name", "Last Name", "User ID", "Password"]
    var selectedUser: [String] = []
    var currentCell: IndexPath?
    var firstName: String?
    var lastName: String?
    var password: String?
    var userID: String?
    var studyID: Int = 3
    var userList = ["None", "Parent", "Sibling", "Co-worker", "Spouse", "Friend"]
    
    var userone: String = ""
    var userTwo: String = ""
    var userThree: String = ""
    var userFour: String = ""
    var userFive: String = ""
    var userSix: String = ""
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SIGN UP"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.dismissView))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Finish", style: .done, target: self, action: #selector(self.signupAction))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .none
        tableView.preservesSuperviewLayoutMargins = false
        tableView.cellLayoutMarginsFollowReadableWidth = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func dismissView() {
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func signupAction() {
        if let _ = userID, let _ = firstName, let _ = lastName, let _ = password {
            //Save user details to server
            appdelegate.userId = userID!
            appdelegate.studyNumber = studyID
            appdelegate.password = password!
            
            NetworkManager.sharedManager.signUpUser(userID: userID!, groupID: appdelegate.studyNumber, password: password!, lname: lastName!, fname: firstName!, user1: self.appdelegate.selectedUsers[0], user2: self.appdelegate.selectedUsers[1], user3: self.appdelegate.selectedUsers[2], user4: self.appdelegate.selectedUsers[3], user5: self.appdelegate.selectedUsers[4], user6: self.appdelegate.selectedUsers[5], handler: { (signupStatus) in
                if signupStatus {
                    
                    //Reset defaults for newly created user
                    self.appdelegate.appDefaults.set(false, forKey: "isTouchID")
                    self.appdelegate.appDefaults.set(false, forKey: "isLogin")
                    
                    let alert = UIAlertController(title: "Success", message: "Sign Up success. Please go back and SIGN IN", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                        self.dismissView()
                    }))
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                }else {
                    DispatchQueue.main.async {
                        Utility.showAlert(withTitle: "Error", withMessage: "Username already exists. Please try another username.", from: self)
                    }
                }
            })
            
        }else {
            Utility.showAlert(withTitle: "Error", withMessage: "Please fill all the fields.", from: self)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if selectedUser.count > 0 {
            return 4
        }else {
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return contentOne.count
        }else if section == 1 || section == 3{
            return 1
        }else {
            return selectedUser.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as! TextFieldTableCell
            cell.backgroundColor = UIColor.clear
            cell.textField.placeholder = contentOne[indexPath.row]
            cell.textField.tag = 100 + indexPath.row
            cell.textField.delegate = self
            if indexPath.row == 3 {
                cell.textField.isSecureTextEntry = true
            }
            return cell
            
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = "List the people with fingerprint access to your device"
            cell.accessoryType = .disclosureIndicator
            return cell
        }else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PickerTableCell", for: indexPath) as! PickerTableCell
            cell.delegate = self
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            //            if indexPath.row == 0 {
            //                cell.orderLabel.text = "First"
            //            }else if indexPath.row == 1 {
            //                cell.orderLabel.text = "Second"
            //            }else if indexPath.row == 2 {
            //                cell.orderLabel.text = "Third"
            //            }else if indexPath.row == 3 {
            //                cell.orderLabel.text = "Fourth"
            //            }else if indexPath.row == 4 {
            //                cell.orderLabel.text = "Fifth"
            //            }else {
            //                cell.orderLabel.text = "Sixth"
            //            }
            //            cell.userLabel.text = "Select"
            cell.textLabel?.text = appdelegate.selectedUsers[indexPath.row]
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 45))
        let title = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.bounds.width - 20, height: 25))
        if section == 0 {
            title.text = "Personal Information"
        }else if section == 2{
            title.text = "Rank the users based on Trust"
            
            let editButton = UIButton(frame: CGRect(x: tableView.bounds.width - 200, y: 2, width: 180, height: 40))
            editButton.addTarget(self, action: #selector(self.editTableView(sender:)), for: .touchUpInside)
            editButton.setTitle("Rank users", for: .normal)
            editButton.setTitleColor(UIColor.white, for: .normal)
            editButton.layer.cornerRadius = 20
            editButton.backgroundColor = Utility.greenColor
            headerView.addSubview(editButton)
        }else if section == 3 {
            title.text = "Group Number"
        }
        title.textColor = Utility.greenColor
        title.center.y = headerView.center.y
        headerView.addSubview(title)
        return headerView
    }
    
    func editTableView(sender: UIButton) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            sender.setTitle("Rank Users", for: .normal)
        }else {
            tableView.setEditing(true, animated: true)
            sender.setTitle("Finish Ranking", for: .normal)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3 {
            return 110
        }else {
            return 60
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            currentCell = indexPath
            let selectUserVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectUsers") as! SelectUserTableController
            selectUserVC.userList = userList
            //            if indexPath.section == 2 {
            //                selectUserVC.isSignleUser = true
            //                selectUserVC.userList = selectedUser
            //            }
            selectUserVC.userDelegate = self
            let presentVC = UINavigationController(rootViewController: selectUserVC)
            presentVC.modalPresentationStyle = .formSheet
            self.present(presentVC, animated: true, completion: nil)
        }
        
        if indexPath.section != 2 {
            tableView.endEditing(true)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 2 {
            return true
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.none
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 2 {
            return true
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //reordering values in the selcted list
        let value = appdelegate.selectedUsers[sourceIndexPath.row]
        appdelegate.selectedUsers.remove(at: sourceIndexPath.row)
        appdelegate.selectedUsers.insert(value, at: destinationIndexPath.row)
        print("@@@@", appdelegate.selectedUsers)
    }
    
    func didSelectUser(user: String) {
        
        //*** currently not beig used****
        if appdelegate.selectedUsers.contains(user) {
            Utility.showAlert(withTitle: "Error", withMessage: "You have already selected \(user), please select a different option", from: self)
        }else {
            let cell = tableView.cellForRow(at: currentCell!) as! UserTableCell
            cell.userLabel.text = user
            appdelegate.selectedUsers.insert(user, at: currentCell!.row)
            
            if currentCell?.row == 0 {
                userone = user
            }else if currentCell?.row == 1 {
                userTwo = user
            }else if currentCell?.row == 2 {
                userThree = user
            }else if currentCell?.row == 3 {
                userFour = user
            }else if currentCell?.row == 4 {
                userFive = user
            }
            
        }
        self.clearSelection()
    }
    
    func didSelectUsers(users: [String]) {
        selectedUser = users
        appdelegate.selectedUsers = Array<String>(repeating: "None", count: 5)
        for item in users {
            appdelegate.selectedUsers.insert(item, at: 0)
        }
        if users.count == 1 && users.contains("None") {
            appdelegate.isDisplayAll = true
        }else {
            appdelegate.isDisplayAll = false
        }
        tableView.reloadData()
        //tableView.isEditing = true
        //self.clearSelection()
    }
    
    func clearSelection() {
        tableView.deselectRow(at: currentCell!, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != "" {
            if textField.tag == 100 {
                self.firstName = textField.text
            }else if textField.tag == 101 {
                self.lastName = textField.text
            }else if textField.tag == 102 {
                self.userID = textField.text
            }else {
                self.password = textField.text
            }
        }
    }
    
    //MARK: - Picker calue changed delegate
    
    func valueChanged(value: Int) {
        self.studyID = value
    }
    
}
