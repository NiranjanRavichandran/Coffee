//
//  NetworkManager.swift
//  Coffee
//
//  Created by Niranjan Ravichandran on 10/18/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class NetworkManager {
    
    static let sharedManager = NetworkManager()
    
    //isPass 1 === TRUE && 0 === FALSE
    //Using custom network calls for self learning purpose
    
    func saveTime(userID: String, actionId: Int, timeTaken: Double, dialogTime: Double, studyID: Int, isPass: Int,handler completion: @escaping (_ status: Bool)-> Void) {
        /*
        var request = URLRequest(url: URL(string: "http://52.89.68.106:3000/api/save")!)
        request.httpMethod = "POST"
        let postData = "appId=\(2)&token=bazzinga&actionId=\(actionId)&time=\(timeTaken)&studyId=\(studyID)&isPassword=\(isPass)&userId=\(userID)&dialogTime=\(dialogTime)"
        
            request.httpBody = postData.data(using: .utf8)
        self.makePostRequest(with: request) { (status) in
            completion(status)
        }
         */
        let ref = FIRDatabase.database().reference()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH-mm-ssZ"
        ref.child("Tasks").child(dateFormatter.string(from: Date())).setValue(["UserID": userID, "ActionID": actionId, "TimeTaken": timeTaken, "DialogTime": dialogTime, "StudyID": studyID, "isPassword": isPass]) { (error, dbRef) in
            if error == nil {
                completion(true)
            }else {
                completion(false)
            }
        }
        
    }
    
    func signUpUser(userID: String, groupID: Int, password: String, lname: String, fname: String, user1: String, user2: String, user3: String, user4: String, user5: String, user6: String, handler completion: @escaping (_ status: Bool)-> Void) {
        /*
        var request = URLRequest(url: URL(string: "http://52.89.68.106:3000/api/Users")!)
        request.httpMethod = "POST"
        let postData = "appId=\(2)&token=bazzinga&userId=\(userID)&password=\(password)&user1=\(user1)&user2=\(user2)&user3=\(user3)&user4=\(user4)&user5=\(user5)&user6=\(user6)&groupId=\(groupID)&fname=\(fname)&lname=\(lname)"
        
        request.httpBody = postData.data(using: .utf8)
        self.makePostRequest(with: request) { (status) in
            completion(status)
        }
         */
        let ref = FIRDatabase.database().reference()
        ref.child("Users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                completion(false)
            }else {
                ref.child("Users").child(userID).setValue(["UserID": userID, "Password": password, "GroupID": groupID, "FirstName": fname, "LastName": lname, "User1": user1, "User2": user2, "User3": user3, "User4": user4, "User5": user5, "User6": user6 ]) { (error, dbRef) in
                    if error == nil {
                        completion(true)
                    }else {
                        completion(false)
                    }
                }
            }
        })

    }
    
    func loginUser(username: String, password: String, completion: @escaping (_ status: Bool)-> Void) {
        /*
        var request = URLRequest(url: URL(string: "http://52.89.68.106:3000/api/login")!)
        request.httpMethod = "POST"
        let postData = "userId=\(username)&password=\(password)"
        request.httpBody = postData.data(using: .utf8)
        self.makePostRequest(with: request) { (status) in
            completion(status)
        }
         */
        let ref = FIRDatabase.database().reference()
        ref.child("Users").child(username).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                completion(true)
            }else {
                completion(false)
            }
        })
        
    }
    
    func makePostRequest(with request: URLRequest, completion: @escaping (_ status: Bool)-> Void) {
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                completion(false)
            }else {
                
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(responseString)")
                completion(true)
            }
            
        }
        task.resume()
    }
    
    func getUser(forID userId: String, completion: @escaping (NSDictionary?) ->  Void) {
        var request = URLRequest(url: URL(string: "http://52.89.68.106:3000/api/getUser")!)
        request.httpMethod = "POST"
        let postData = "userId=\(userId)&appId=\(2)"
        request.httpBody = postData.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                completion(nil)
            }else {
                
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(responseString)")
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let status = (jsonResponse as? NSDictionary)?["error"] as? Int {
                        if status == 0 {
                            completion((jsonResponse as? NSDictionary)?["data"] as? NSDictionary)
                        }else {
                            completion(nil)
                        }
                    }else {
                        completion(nil)
                    }
                }catch let error {
                    print("Error:", error.localizedDescription)
                }
            }
            
        }
        task.resume()
    }
}
