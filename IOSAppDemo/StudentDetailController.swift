//
//  StudentDetailController.swift
//  LisViewDemo
//
//  Created by Ajay Saini on 24/01/17.
//

import UIKit
import Alamofire
import SwiftLoader

class StudentDetailController: UIViewController ,UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    var student : String = ""
    var fixedURL : String = "http://52.57.141.10:5000/student"
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var s_name: UILabel!
    @IBOutlet weak var s_email: UILabel!
    
    @IBOutlet weak var s_description: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let data = NSData(contentsOf: NSURL(string:"https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcQc9ACqWfbNe9MBkKCXxEcraQcIpjqITPTpj-ndDZ6gKoP4W2L2" ) as! URL) {
            profilePic?.image = UIImage(data: data as Data)
        }
         getStudent(id: student)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setValues(n : String ,e : String , d : String){
        self.s_name.text = n
        self.s_email.text = e
        self.s_description.text = d
    }
    
    @IBAction func openCamera(_ sender: Any) {
        let alert = UIAlertController(title: "Select Image From", message: "", preferredStyle: .actionSheet)
        let C_Action = UIAlertAction(title: "Camera", style: .default, handler: selectCamera)
        let G_Action = UIAlertAction(title: "Gallery", style: .default, handler: selectGallery)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeletePlanet)
        
        alert.addAction(C_Action)
        alert.addAction(G_Action)
        alert.addAction(CancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func selectCamera(alertAction: UIAlertAction!){
       imgPicker(camera: true)
    }
    func selectGallery(alertAction: UIAlertAction!){
        imgPicker(camera: false)
    }
    func cancelDeletePlanet(alertAction: UIAlertAction!) {

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        profilePic.image = image
        self.dismiss(animated: true, completion: nil);
    }
    
    func imgPicker(camera : Bool){
        if(camera){
            print("camera")
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }else{
            print("photoLibrary")
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }

        }
    }
    
    func getStudent(id : String){
        SwiftLoader.show(title: "loading...", animated: true)
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
