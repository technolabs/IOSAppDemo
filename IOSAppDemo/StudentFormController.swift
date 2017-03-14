//
//  StudentFormController.swift
//  LisViewDemo
//
//  Created by Ajay Saini on 18/01/17.
//  Copyright © 2017 Revolution Developers. All rights reserved.
//

import UIKit
import Alamofire
import SwiftLoader

class StudentFormController: UIViewController {
    
    var student : String = ""
    var edit : Bool = false
    var fixedURL : String = "http://52.57.141.10:5000/student"
    
    @IBOutlet weak var name_s: UITextField!
    
    @IBOutlet weak var desc_s: UITextField!
    
    @IBOutlet weak var email_s: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.name_s.text = ""
        self.email_s.text = ""
        self.desc_s.text = ""
        
        if(edit){
            getStudent(id: student)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func saveStudent(_ sender: Any) {
        createOrUpdateStudent();
    }
    
    func createOrUpdateStudent(){
        if(self.name_s.text != ""){
            SwiftLoader.show(title: "saving...", animated: true)
            let data = ["name": self.name_s.text as Any, "email": self.email_s.text as Any, "description": self.desc_s.text as Any] as [String : Any]
            if(edit){
                Alamofire.request(fixedURL+"/"+student, method: .put, parameters: data, encoding:JSONEncoding.default).responseJSON { response in
                    SwiftLoader.hide()
                    if let error = response.result.error {
                        print(error)
                    } else {
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                            _ = self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }else{
                Alamofire.request(fixedURL, method: .post, parameters: data, encoding:JSONEncoding.default).responseJSON { response in
                    SwiftLoader.hide()
                    if let error = response.result.error {
                        print(error)
                    } else {
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                            _ = self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }

        }
    }
    
    func setValues(n : String ,e : String , d : String){
        self.name_s.text = n
        self.email_s.text = e
        self.desc_s.text = d
    }
    
    
    func getStudent(id : String){
        SwiftLoader.show(title: "Loading...", animated: true)
        Alamofire.request(fixedURL+"/"+id).responseJSON { response in
            SwiftLoader.hide()
            if let error = response.result.error {
                print(error)
            } else {
                if let JSON = response.result.value {
                    let postsJSON = JSON as! NSDictionary
                    self.setValues(n: postsJSON.object(forKey: "name") as! String,e: postsJSON.object(forKey: "email") as! String,d: postsJSON.object(forKey: "description") as! String)
                    
                }
            }
        }
    }
    
}
