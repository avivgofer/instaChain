//
//  SignUpViewController.swift
//  Instagram
//
//  Created by admin on 19/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import ProgressHUD

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var selectedImage: UIImage?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImage.layer.cornerRadius = 40
        profileImage.clipsToBounds = true
        
        let tapTarget = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.handelSelectProfileImageView))
        profileImage.addGestureRecognizer(tapTarget)
        profileImage.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
        
      
        
    }
    @objc func handelSelectProfileImageView(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController,animated: true, completion: nil)
    }
    
    

    @IBAction func signupTapped(_ sender: Any) {
        ProgressHUD.show("Sign in..", interaction: false)
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) {user, error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            let ref = Database.database().reference()
            let uid = Model.instance.getCurrentUserId()
            
            
            
            var data = Data()
            data = self.profileImage.image!.pngData()!
            
            
            let imageRef = Storage.storage().reference(forURL: "gs://instagram-753b8.appspot.com/").child("profileImage").child(uid!)
            _ = imageRef.putData(data, metadata: nil, completion: {(metadata, error) in
                if error != nil {
                    return
                }
                _ = imageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {  return }// Uh-oh, an error occurred!
                    
                    let url = downloadURL.absoluteString
                    let userRef = ref.child("users")
                    let newUserRef = userRef.child(uid!)
                    newUserRef.setValue(["uid": uid, "username": self.usernameTextField.text!, "email": self.emailTextField.text!, "profileImageUrl": url])
                    print("signed in")
                    ProgressHUD.showSuccess("Success")
                    self.performSegue(withIdentifier: "backToSignIn", sender: self)
                    }
                
                })
        }
    }
    
    
    @IBAction func dismissOnClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}


extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            selectedImage = image
            profileImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
