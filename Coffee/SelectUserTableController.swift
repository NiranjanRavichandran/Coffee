//
//  SelectUserTableController.swift
//  Coffee
//
//  Created by Niranjan Ravichandran on 10/19/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

protocol SelectUserDelegate {
    func didSelectUser(user: String)
    func didSelectUsers(users: [String])
}

class SelectUserTableController: UITableViewController {
    
    var isSignleUser: Bool?
    var userList: [String]!
    var userDelegate: SelectUserDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelAction))
        if isSignleUser == nil {
            isSignleUser = false
        }
        if !isSignleUser! {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneAction))
            tableView.allowsMultipleSelection = true
        }
    }
    
    func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func doneAction() {
        self.dismiss(animated: true) {
            if let indexes = self.tableView.indexPathsForSelectedRows {
                var selectedUsers: [String] = []
                for item in indexes {
                    selectedUsers.append(self.userList[item.row])
                }
                self.userDelegate?.didSelectUsers(users: selectedUsers)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! ShowUserTableCell
        cell.userLabel.text = userList[indexPath.row]
        cell.userImageView.image = UIImage(named: userList[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! ShowUserTableCell
        selectedCell.selectImageView.alpha = 1
        if isSignleUser! {
            self.dismiss(animated: true, completion: {
                self.userDelegate?.didSelectUser(user: self.userList[indexPath.row])
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let deselectedCell = tableView.cellForRow(at: indexPath) as! ShowUserTableCell
        deselectedCell.selectImageView.alpha = 0
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
