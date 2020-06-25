//
//  AddUserViewController.swift
//  Task
//
//  Created by Bhanuja Tirumareddy on 25/06/20.
//  Copyright © 2020 Bhanuja Tirumareddy. All rights reserved.
//

import UIKit

class AddUserViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profilePicButton: UIButton!
    @IBOutlet weak var adressTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    var addUserVM: AddUserViewModel!
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
       addUserVM = AddUserViewModel()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loadImages(_ sender: Any) {
        //For now showing only gallery
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        profileImage.image = selectedImage
        dismiss(animated:true, completion: nil)
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {self.dismiss(animated: true, completion: nil)
    }

    @IBAction func saveDetails(_ sender: Any) {
        let data: Data = profileImage.image!.jpegData(compressionQuality: 1.0)!
        let user = User(name: nameTextField.text!, phoneNumber: phoneNumberTextField.text!, address: adressTextField.text!, profilePic: data)
        CoreDataWrapper().saveUser(user) { [weak self] (flag) in
            if flag == true {
                Utility.Shared.showSimpleAlert(OnViewController: self, Message: "Data Saved")
                addUserVM.clearData()
                self?.nameTextField.text = addUserVM.txtUserName
                 self?.phoneNumberTextField.text = addUserVM.txtUserName
                 self?.adressTextField.text = addUserVM.txtUserName
                guard let imageData = addUserVM.dataProfilePic else {return
                    
                }
                self?.profileImage.image = UIImage(data:imageData)
                
            }
        }
    }
}
