//
//  AddOutfitViewController.swift
//  ClosetStyle
//
//  Created by Wayne Mosley on 4/7/19.
//  Copyright © 2019 Wayne Mosley. All rights reserved.
//

import UIKit
import CoreML
import Vision
import ImageIO

class AddOutfitViewController: UIViewController {
    
    // MARK: - Properties
    var outfit: Outfit?
    let imagePicker = UIImagePickerController()
    var shouldEdit = false
    let fashionMachineModel = FashionImageClassifier()
    
    lazy var classificationRequest: VNCoreMLRequest = {
        let model = try? VNCoreMLModel(for: fashionMachineModel.model)
        let request = VNCoreMLRequest(model: model!, completionHandler: { [weak self] request, error in
            self?.processClassifications(for: request, error: error)
        })
        request.imageCropAndScaleOption = .centerCrop
        return request
    }()
    
    // MARK: - Outlets
    @IBOutlet weak var outfitImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ratingTextField: UITextField!
    @IBOutlet weak var eventTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var outfitCategory: UILabel!
    
    
    // MARK: - Actions
    @IBAction func saveOutfit(_ sender: Any) {
        guard let name = nameTextField.text,
            let ratingString = ratingTextField.text,
            let rating = Int(ratingString),
            let event = eventTextField.text,
            let image = outfitImage.image?.jpegData(compressionQuality: 1.0) else {return}
            let date = datePicker.date
        
        outfit = Outfit(date: date, name: name, image: image, event: event, rating: rating)
        performSegue(withIdentifier: "Unwind", sender: self)
    }
    
    // MARK: - View Lifecycle Methods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        becomeTextFieldDelegate()
        updateViews()
        
        /* Configuring tap recognizer and adding it to image view. */
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddOutfitViewController.openImagePicker))
        tapRecognizer.numberOfTapsRequired = 1
        outfitImage.isUserInteractionEnabled = true
        outfitImage.backgroundColor = .clear
        outfitImage.addGestureRecognizer(tapRecognizer)
        addShadowToView(view: outfitImage)
        
        registerForKeyboardNotifications()
        
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - Helper Functions
    func updateViews(){
        /* Check if there is a valid Outfit to use. If so populate the text fields with that Outfit's information. Other wise leave the entries blank. */
        
        if let outfit = outfit{
            nameTextField.text = outfit.name
            ratingTextField.text = String(describing: outfit.rating)
            eventTextField.text = outfit.event
            datePicker.date = outfit.date
            outfitImage.image = outfit.imageFromData()
             self.updateClassifications(for: outfit.imageFromData())
            
        }else{
            print("Need to create an outfit first")
        }
    }
    
    // MARK: - Avoid big viewdidload functions
    fileprivate func becomeTextFieldDelegate() {
        imagePicker.delegate = self
        nameTextField.delegate = self
        ratingTextField.delegate = self
        eventTextField.delegate = self
    }
    
    func addShadowToView(view: UIImageView){
        view.layer.cornerRadius = 2.0
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.clear.cgColor
        view.clipsToBounds = false
        view.layer.masksToBounds = false
        view.layer.shadowRadius = view.layer.cornerRadius
        view.layer.shadowOffset = CGSize(width: 0, height: 9.0)
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
    }
    
    
    
    func registerForKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasHidden(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    
    @objc func keyboardWasShown(notification: Notification){
        scrollView.isScrollEnabled = true
        if let info = notification.userInfo {
            let keyboardSize = info[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            let keyboardInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            scrollView.contentInset = keyboardInsets
            var viewRect = self.scrollView.frame
            viewRect.size.height -= keyboardSize.height
            if keyboardSize.contains(eventTextField.frame.origin){
                scrollView.scrollRectToVisible(eventTextField.frame, animated: true)
            }else if keyboardSize.contains(ratingTextField.frame){
                scrollView.scrollRectToVisible(eventTextField.frame, animated: true)
                
            }
        }
        
    }
    
    
    @objc func keyboardWasHidden(notification: Notification){
        let scrollViewInsets = UIEdgeInsets.zero
        scrollView.contentInset = scrollViewInsets
        scrollView.scrollIndicatorInsets = scrollViewInsets
        scrollView.isScrollEnabled = false
        
    }
}

extension AddOutfitViewController: UITextFieldDelegate{
    
    // TODO: Text Validation etc.
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if  textField === ratingTextField{
            if textField.text == nil{
                print("You have to enter the rating for the outfit.")
            }else if Int(textField.text!) ?? 0 > 5 || Int(textField.text!) ?? 0 < 0 || textField.text == nil{
                print("Ratings should be between 0 & 5")
                textField.text = ""
            }
            else{
                print("Everything is good to go.")
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
}

// TODO: - Add code to raise the keyboard when textfield is clicked so that it isnt blocked.

extension AddOutfitViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @objc func openImagePicker(){
        imagePicker.allowsEditing = false //cant edit images before using them.
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.sourceType = .photoLibrary //get the pictures from your photo library.
            present(imagePicker, animated: true) {  //present the picker and print a message.
                print("I've loaded the image picker shawty.")
            }
            
            //        }else{
            //            imagePicker.sourceType = .photoLibrary //get the pictures from your photo library.
            //            present(imagePicker, animated: true) //present the picker and print a message.
            //            print("I've loaded the image picker shawty.")
            //
            //
            //
            //        }
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        outfitImage.image = image
        outfitImage.backgroundColor = .clear
        self.updateClassifications(for: image)
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


extension AddOutfitViewController{
    
    /* Handle CoreML work here. */
    func updateClassifications(for image: UIImage) {
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: .up)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                print( "Unable to classify image.\n\(error!.localizedDescription)")
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]
            
            if classifications.isEmpty {
                print("Nothing recognized.")
            } else {
                // Display top classifications ranked by confidence in the UI.
                let topClassifications = classifications.prefix(2)
                let descriptions = topClassifications.map { classification in
                    // Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
                    return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
                }
                print("\(descriptions)")
                self.outfitCategory.text = String(format:   /*(%.2f) */"%@", /*classifications.first!.confidence,*/ classifications.first!.identifier)
                //self.classificationLabel.text = "Classification:\n" + descriptions.joined(separator: "\n")
            }
        }
    }
}
