//
//  JoinTableViewController.swift
//  Coffee
//
//  Created by Niranjan Ravichandran on 10/16/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

class JoinTableViewController: UITableViewController, UITextFieldDelegate, SelectUserDelegate {
    
    let contentOne = ["First Name", "Last Name", "Group Number", "User ID", "Password"]
    var selectedUser: [String] = []
    var currentCell: IndexPath?
    var firstName: String?
    var lastName: String?
    var password: String?
    var userID: String?
    var studyID: String?
    var userList = ["Parent", "Sibling", "Co-worker", "Spouse", "Friend"]
    
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
        self.view.endEditing(true)
        if let _ = userID, let _ = studyID, let _ = firstName, let _ = lastName, let _ = password {
            //Save user details to server
            appdelegate.userId = userID!
            if let id = Int(studyID!) {
                appdelegate.studyNumber = id
            }else {
                Utility.showAlert(withTitle: "Error", withMessage: "Group Number must be a numeric value", from: self)
                return
            }
            appdelegate.password = password!
            
            NetworkManager.sharedManager.signUpUser(userID: userID!, groupID: appdelegate.studyNumber, password: password!, lname: lastName!, fname: firstName!, user1: userone, user2: userTwo, user3: userThree, user4: userFour, user5: userFive, user6: userSix, handler: { (signupStatus) in
                if signupStatus {
                    
                    //Reset defaults for newly created user
                    self.appdelegate.appDefaults.set(false, forKey: "isTouchIDSet")
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
            
        }else if selectedUser.count != appdelegate.selectedUsers.count {
            Utility.showAlert(withTitle: "Error", withMessage: "Please rank users with fingerprint access to your device based on Trust.", from: self)
        }else {
            Utility.showAlert(withTitle: "Error", withMessage: "Please fill all the fields.", from: self)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if selectedUser.count > 0 {
            return 3
        }else {
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return contentOne.count
        }else if section == 1{
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
            if indexPath.row == 2 {
                cell.textField.keyboardType = .numberPad
            }else if indexPath.row == 4{
                cell.textField.isSecureTextEntry = true
            }
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = "List the people with fingerprint access to your device"
            cell.accessoryType = .disclosureIndicator
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedUserCell", for: indexPath) as! UserTableCell
            if indexPath.row == 0 {
                cell.orderLabel.text = "First"
            }else if indexPath.row == 1 {
                cell.orderLabel.text = "Second"
            }else if indexPath.row == 2 {
                cell.orderLabel.text = "Third"
            }else if indexPath.row == 3 {
                cell.orderLabel.text = "Fourth"
            }else if indexPath.row == 4 {
                cell.orderLabel.text = "Fifth"
            }else {
                cell.orderLabel.text = "Sixth"
            }
            cell.userLabel.text = "Select"
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
        }
        title.textColor = Utility.greenColor
        title.center.y = headerView.center.y
        headerView.addSubview(title)
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            currentCell = indexPath
            let selectUserVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectUsers") as! SelectUserTableController
            selectUserVC.userList = userList
            if indexPath.section == 2 {
                selectUserVC.isSignleUser = true
                selectUserVC.userList = selectedUser
            }
            selectUserVC.userDelegate = self
            let presentVC = UINavigationController(rootViewController: selectUserVC)
            presentVC.modalPresentationStyle = .formSheet
            self.present(presentVC, animated: true, completion: nil)
        }
    }
    
    func didSelectUser(user: String) {
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
        //tableView.reloadSections(IndexSet(integer: 2), with: .fade)
        tableView.reloadData()
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
                self.studyID = textField.text
            }else if textField.tag == 103 {
                self.userID = textField.text
            }else {
                self.password = textField.text
            }
        }
    }
    
}
