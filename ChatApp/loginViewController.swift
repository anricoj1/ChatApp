//
//  loginViewController.swift
//  ChatApp
//
//  Created by Towsif Uddin on 11/26/18.
//  Copyright © 2018 Towsif Uddin. All rights reserved.
//

var email = String()
var password = String()

import UIKit

class loginViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func loginButton(_ sender: Any) {
        
       loginRequest()
        
        
    }
    
    func loginRequest(){
        
        guard let url = URL(string: "http://dreamteam.x10host.com/login.php?email=\(emailTextfield.text!)&password=\(passwordTextfield.text!)") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                //print(jsonResponse) //Response result
                
                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                    return
                }
                //print(jsonArray)
                //Now get title value
                let outputValue = jsonArray[0]["output"] as? String
                
                if (outputValue == "Successfully logged in!"){
                    
                    print("success")
                    
                    DispatchQueue.main.sync(){
                        email = self.emailTextfield.text!
                        password = self.passwordTextfield.text!
                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    }
                    
                } else {
                    print("invalid username password")
                }
                
               
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
        
    }
    
}
