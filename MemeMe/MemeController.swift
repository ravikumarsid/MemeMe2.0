//
//  ViewController.swift
//  MemeMe
//
//  Created by Ravi Kumar Venuturupalli on 1/18/18.
//  Copyright © 2018 Ravi Kumar Venuturupalli. All rights reserved.
//

import UIKit

struct Meme {
    var topText: String
    var bottomText: String
    var orignalImage: UIImage
    var memedImage: UIImage
}

class MemeController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var topToolbar: UIToolbar!
    
    let memeTextAttributes:[String:Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -5
        
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        self.topTextField.backgroundColor = UIColor.clear
        self.bottomTextField.backgroundColor = UIColor.clear
        self.topTextField.borderStyle = UITextBorderStyle.none
        self.bottomTextField.borderStyle = UITextBorderStyle.none
        self.toolBar.clipsToBounds = true
        subscribeToKeyboardNotifications()
        shareButton.isEnabled = imagePickerView.image == nil ? false : true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        defaultMemeScreen()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func save() {
        _ = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, orignalImage: imagePickerView.image! , memedImage: generateMemedImage())
    }
    
    //Generate memed Image
    func generateMemedImage() -> UIImage {
        //TODO: Hide toolbar and navbar
        self.toolBar.isHidden = true
        self.shareButton.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //TODO: Show toolbar and navbar
         self.toolBar.isHidden = false
         self.shareButton.isHidden = false
        
        return memedImage
    }
    
    //Text Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text!.elementsEqual("TOP") || textField.text!.elementsEqual("BOTTOM") {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Move the view whent the keyboard covers the text field
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            self.view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    //Move the view back down when keyboard is dismissed
    @objc func keyboardWillHide(_ notification: Notification) {
         if bottomTextField.isFirstResponder {
        self.view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat{
        let userinfo = notification.userInfo
        let keyboardSize = userinfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func defaultMemeScreen() {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        imagePickerView.contentMode = UIViewContentMode.scaleAspectFit
        
        self.topTextField.textAlignment = .center
        self.bottomTextField.textAlignment = .center
        imagePickerView.image = nil
        shareButton.isEnabled = false
    }

    @IBAction func pickImageFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImage(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        self.present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func shareImage(_ sender: Any) {
        let generatedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [generatedImage], applicationActivities: nil)
        self.present(controller, animated: true, completion: save)
    }
    
    @IBAction func cancelMeme(_ sender: Any) {
        defaultMemeScreen()
    }
}

