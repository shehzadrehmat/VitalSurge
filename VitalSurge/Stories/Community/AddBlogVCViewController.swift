//
//  AddBlogVCViewController.swift
//  VitalSurge
//
//  Created by Shehzad Rehmat on 17/02/2024.
//

import UIKit
import iOSDropDown

class AddBlogVCViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textViewTitle: UITextView!
    @IBOutlet private weak var textViewDescription: UITextView!
    @IBOutlet private weak var buttonUpload: UIButton!
    @IBOutlet private weak var buttonPickImage: UIButton!
    @IBOutlet private weak var queryPicker: DropDown!
    
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    var queries = [String]()

    
    private var image: UIImage?
    private lazy var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradientView()
        queries.removeFirst()
        queryPicker.selectedIndex = 0
        queryPicker.text = queries.first
        queryPicker.optionArray = queries
    }
    
    private func startSpinnerAnimation() {
        spinner.isHidden = false
        spinner.startAnimating()
    }
    
    private func stopSpinnerAnimation() {
        spinner.isHidden = true
        spinner.stopAnimating()
    }
    
    private func publishNow(key: String?) {
        let blog = Blog(title: textViewTitle.text, description: textViewDescription.text, query: queries[queryPicker.selectedIndex ?? 0], image: key)
        FireStoreManager.shared.saveNewBlog(blog: blog) { [weak self] newBlog in
            if let newBlog {
                self?.pop()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewBlog"), object: nil)
            } else {
                self?.showMessageAlert(title: "Error", message: "Please make sure you are connected to active internet connection.")
            }
        }
    }
    
    private func hideButtonUpload(_ isHidden: Bool) {
        buttonUpload.isHidden = isHidden
    }
    
    @IBAction private func pickImageDidPress() {
        if image == nil  {
            pick()
        } else {
            image = nil
            buttonPickImage.setTitle("Upload Picture", for: .normal)
            imageView.contentMode = .center
            imageView.image = UIImage(systemName: "camera")
        }
    }
    
    @IBAction private func publishBlog() {
        hideButtonUpload(true)
        startSpinnerAnimation()
        
        if let image {
            FireStoreManager.shared.uploadImage(image: image) { [weak self] key in
                self?.publishNow(key: key)
            } failure: { [weak self] error in
                self?.stopSpinnerAnimation()
                self?.hideButtonUpload(false)
                self?.showMessageAlert(title: "Error", message: error.localizedDescription)
            }

        } else {
            publishNow(key: nil)
        }
    }
    
    
    @IBAction private func pickImageTap() {
        pick()
    }
    
    private func pick() {
        let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.imagePicker.delegate = self
            self.openCamera()
        }
        alertController.addAction(cameraAction)
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.imagePicker.delegate = self
            self.openPhotoLibrary()
        }
        alertController.addAction(photoLibraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // For iPad, to avoid crash
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        
        present(alertController, animated: true, completion: nil)
    }

    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera not available")
        }
    }
    
    private func openPhotoLibrary() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
}

extension AddBlogVCViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[.originalImage] as? UIImage {
                self.image = pickedImage
                imageView.contentMode = .scaleAspectFill
                imageView.image = pickedImage
                buttonPickImage.setTitle("Remove", for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension AddBlogVCViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        buttonUpload.isHidden = textViewTitle.text == "Write here..." || textViewDescription.text == "Write here..."
    }
}
