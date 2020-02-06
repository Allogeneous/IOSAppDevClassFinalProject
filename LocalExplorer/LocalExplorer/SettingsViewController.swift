//
//  SettingsViewController.swift
//  LocalExplorer
//
//  Created by Joshua Marriott on 4/8/19.
//  Copyright © 2019 Joshua Marriott. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var radiusField: UITextField!
    var radius:Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        radiusField.text = "\(radius!)"

        // Do any additional setup after loading the view.
    }
    
    
    
    
    
       
        
        
    
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
    }
    */

}
