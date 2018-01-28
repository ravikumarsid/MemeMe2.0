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
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var topToolBar: UIToolbar!
    
    var generatedMemeImage : UIImage? = nil
    
    let memeTextAttributes:[String:Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -5
        
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        configure(textField: topTextField, withText: "TOP")
        configure(textField: bottomTextField, withText: "BOTTOM")
        self.toolBar.clipsToBounds = true
        subscribeToKeyboardNotifications()
        shareButton.isEnabled = imagePickerView.image != nil
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, orignalImage: imagePickerView.image! , memedImage: self.generatedMemeImage!)
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func configure(textField: UITextField, withText text: String){
        textField.defaultTextAttributes = memeTextAttributes
        textField.delegate = self
        textField.textAlignment = .center
        textField.text = text
    }
    
    //Generate memed Image
    func generateMemedImage() -> UIImage {
        //Hide toolbar and navbar
        hideTopAndBottomBars(true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        //Show toolbar and navbar
        hideTopAndBottomBars(false)
        return memedImage
    }
    
    //Text Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
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
            self.view.frame.origin.y = -getKeyboardHeight(notification)
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
        NotificationCenter.default.removeObserver(self)
    }
    
    func hideTopAndBottomBars(_ hide: Bool) {
        self.toolBar.isHidden = hide
        self.topToolBar.isHidden = hide
        self.navigationController?.isNavigationBarHidden = hide
    }
    
    func defaultMemeScreen() {
        configure(textField: topTextField, withText: "TOP")
        configure(textField: bottomTextField, withText: "BOTTOM")
        imagePickerView.contentMode = UIViewContentMode.scaleAspectFit
        imagePickerView.image = nil
        shareButton.isEnabled = false
    }
    
    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        presentImagePickerWith(sourceType: .camera)
    }
    
    @IBAction func pickAnImage(_ sender: Any) {
        presentImagePickerWith(sourceType: .photoLibrary)
    }
    
    @IBAction func shareImage(_ sender: Any) {
        self.generatedMemeImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [generatedMemeImage!], applicationActivities: nil)
        controller.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                return
            }
            self.save()
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func cancelMeme(_ sender: Any) {
        defaultMemeScreen()
        self.dismiss(animated: true, completion: nil)
    }
}

