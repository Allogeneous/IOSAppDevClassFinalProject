//
//  LocationViewController.swift
//  LocalExplorer
//
//  Created by Joshua Marriott on 4/11/19.
//  Copyright © 2019 Joshua Marriott. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionField: UITextView!
    
    var imagePicker = UIImagePickerController()
    
    var lwLocationData: LWLocationData?
    
    var index: Int?
    
    var currentSession:LWSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        if currentSession != nil {
            lwLocationData = LWLocationData()
            lwLocationData!.name = currentSession!.lwSearchResult.getName()
            nameField.text = lwLocationData!.name
            imageView.image = lwLocationData!.image
        }else{
            nameField.text = lwLocationData!.name
            descriptionField.text = lwLocationData!.description
            imageView.image = lwLocationData!.image
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onCameraClick(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func onGalleryClick(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        
        picker .dismiss(animated: true, completion: nil)
        imageView.image=info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
        
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
