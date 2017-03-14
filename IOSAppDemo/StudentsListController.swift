//
//  StudentsListController.swift
//  LisViewDemo
//
//  Created by Ajay Saini on 18/01/17.
//

import UIKit
import Alamofire
import SwiftLoader


class StudentsListController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var fixedURL : String = "http://52.57.141.10:5000/student"
    
    var swiftBlogs = Array<AnyObject>()
    var deletePlanetIndexPath: NSIndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loaderConfig();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStudents()
    }
    
    func loaderConfig(){
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.spinnerLineWidth = 2.0
        config.spinnerColor = .red
        config.foregroundColor = .black
        config.foregroundAlpha = 0.8
        SwiftLoader.setConfig(config: config)
    }
    
    // MARK:  UITextFieldDelegate Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func newStudent(_ sender: Any) {
        self.gotoForm(edit: false,index: 11)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swiftBlogs.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "student", for: indexPath)
        
        let row = indexPath.row
        let student = swiftBlogs[row] as! [String : AnyObject]

        cell.textLabel?.text = student["name"] as? String
        cell.detailTextLabel?.text = student["email"] as? String
        //cell.imageView?.image = UIImage(named: "defalutIcon")
        if let data = NSData(contentsOf: NSURL(string:"https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcQc9ACqWfbNe9MBkKCXxEcraQcIpjqITPTpj-ndDZ6gKoP4W2L2" ) as! URL) {
            cell.imageView?.image = UIImage(data: data as Data)
        }
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let studentDetailController = self.storyboard?.instantiateViewController(withIdentifier: "StudentDetailController") as! StudentDetailController
        let student = self.swiftBlogs[row] as! [String : AnyObject]
        studentDetailController.student = student["_id"] as! String
        self.navigationController?.pushViewController(studentDetailController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "DELETE"){(UITableViewRowAction,NSIndexPath) -> Void in
            self.deletePlanetIndexPath = indexPath as NSIndexPath?
            let student = self.swiftBlogs[indexPath.row] as! [String : AnyObject]
            self.confirmDelete(student: student["name"] as! String)
            tableView.setEditing(false, animated: true)
        }
        
        let edit = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "EDIT"){(UITableViewRowAction,NSIndexPath) -> Void in
            self.gotoForm(edit: true,index: indexPath.row)
        }
        
        edit.backgroundColor = UIColor.black
        delete.backgroundColor = UIColor.red
        return [delete,edit]
    }
    
    // Delete Confirmation and Handling
    func confirmDelete(student: String) {
        let alert = UIAlertController(title: "Delete Student", message: "Are you sure you want to permanently delete \(student)?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeletePlanet)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeletePlanet)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleDeletePlanet(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deletePlanetIndexPath {
            let student = self.swiftBlogs[indexPath.row] as! [String : AnyObject]
            deleteStudent(id: student["_id"] as! String){ (result) -> () in
                if(result){
                    self.tableView.beginUpdates()
                    self.swiftBlogs.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
                    self.deletePlanetIndexPath = nil
                    self.tableView.endUpdates()
                }
            }
        }
    }
    
    func cancelDeletePlanet(alertAction: UIAlertAction!) {
        deletePlanetIndexPath = nil
    }
    
    func gotoForm(edit : Bool,index:intptr_t){
        let studentFormController = self.storyboard?.instantiateViewController(withIdentifier: "StudentFormController") as! StudentFormController
        if(edit){
            let student = self.swiftBlogs[index] as! [String : AnyObject]
            studentFormController.student = student["_id"] as! String
            tableView.setEditing(false, animated: true)
        }
        
        studentFormController.edit = edit
        
        self.navigationController?.pushViewController(studentFormController, animated: true)
    }
    
    func getStudents(){
        SwiftLoader.show(title: "loading...", animated: true)
        Alamofire.request(fixedURL).responseJSON { response in
            SwiftLoader.hide()
            if let error = response.result.error {
                print(error)
            } else {
                if let JSON = response.result.value {
                    let postsJSON = JSON as! NSArray
                    self.swiftBlogs = postsJSON as! [Any] as Array<AnyObject>
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func deleteStudent(id:String,completion: @escaping (_ result: Bool)->()){
        SwiftLoader.show(title: "delete...", animated: true)
        Alamofire.request(fixedURL+"/"+id, method: .delete).responseJSON { response in
                SwiftLoader.hide()
                if response.result.error != nil {
                    completion(false)
                } else {
                    completion(true)
                }
        }
    }

    
    
}
