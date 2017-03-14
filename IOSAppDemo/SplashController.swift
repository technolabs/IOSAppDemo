//
//  SplashController.swift
//  LisViewDemo
//
//  Created by Ajay Saini on 23/01/17.
//

import UIKit

class SplashController: UIViewController {

    @IBOutlet weak var splashLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.splashLogo.image = UIImage(named:"defalutIcon")
        
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { timer in
                self.performSegue(withIdentifier: "showStudentsList", sender: nil)
            }
        } else {
            // Fallback on earlier versions
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
