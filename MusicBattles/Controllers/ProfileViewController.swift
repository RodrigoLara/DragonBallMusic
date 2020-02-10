//
//  ProfileViewController.swift
//  MusicBattles
//
//  Created by Rodrigo Lara Ruano on 08/02/20.
//  Copyright © 2020 Rodrigo Lara Ruano. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var photoUserImage: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var descField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Perfil de Usuario"

        photoUserImage.layer.cornerRadius = photoUserImage.frame.width/2
        photoUserImage.layer.borderWidth = 1
        photoUserImage.layer.borderColor = UIColor.lightGray.cgColor
        photoUserImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectPhoto)))
        
        saveButton.layer.cornerRadius = 8
        
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))

        registerForKeyboardNotifications()
        
        setupCustomNavigationBackButton()
        loadData()
    }
    
    func loadData() {
        guard let user = User.data() else { return }
        
        if let profileImage = self.loadImage() {
            self.photoUserImage.image = profileImage
        }
        
        nameField.text = user.name
        lastNameField.text = user.lastName
        descField.text = user.desc
    }
    
    @IBAction func save(_ sender: UIButton) {
        saveProfile()
    }
    
    func saveProfile() {
        guard let name = nameField.validatedText(),
            let lastName = lastNameField.validatedText(),
            let desc = descField.validatedText()
            else {
                showAlert(title: "Error", message: "Uno o mas campos están vacíos, es necesario completar tu perfil para continuar.")
                
                return
            }
        
        if let profileImage = self.photoUserImage.image {
            self.saveImage(image: profileImage)
        }
        
        // Save Realm
        if let user = User.data() {
            user.update(photo: "profile.jpg", name: name, lastName: lastName, desc: desc)
            
            showAlert(title: "Perfil", message: "Datos guardados correctamente")
        } else {
            User().save(photo: "profile.jpg", name: name, lastName: lastName, desc: desc)
            
            if UserDefaults.isFirstTimeApp() {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

                appDelegate.window?.rootViewController = UINavigationController(rootViewController: PlaylistViewController(nibName: "PlaylistViewController", bundle: nil))
                
                UserDefaults.saveFirstTimeApp(firstTime: false)
            }
        }
    }
    
    @objc func selectPhoto() {
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let choosePhotoAction = UIAlertAction(title: "Seleccionar desde galería", style: .default) { (action) in
            self.profilePhoto(sourceType: .photoLibrary)
        }
        
        let takePhotoAction = UIAlertAction(title: "Usar camara", style: .default) { (action) in
            self.profilePhoto(sourceType: .camera)
        }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(cancelAction)
        alertController.addAction(choosePhotoAction)
        alertController.addAction(takePhotoAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Keyboard
    
    @objc func hideKeyboard() {
        contentView.endEditing(true)
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardDidShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: UIResponder.keyboardDidHideNotification , object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc func onKeyboardAppear(_ notification: NSNotification) {
        let info = notification.userInfo!
        let rect: CGRect = info[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
        let kbSize = rect.size
        
        let insets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
        
        var aRect = self.view.frame;
        aRect.size.height -= kbSize.height;
        
        let activeField: UITextField? = [nameField, lastNameField, descField].first { $0.isFirstResponder }
        if let activeField = activeField {
            if aRect.contains(activeField.frame.origin) {
                let scrollPoint = CGPoint(x: 0, y: activeField.frame.origin.y-kbSize.height)
                scrollView.setContentOffset(scrollPoint, animated: true)
            }
        }
    }
    
    @objc func onKeyboardDisappear(_ notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        self.photoUserImage.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func profilePhoto(sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = sourceType
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: {
                imagePicker.navigationBar.topItem?.rightBarButtonItem?.tintColor = .black
            })
        }
    }
}
