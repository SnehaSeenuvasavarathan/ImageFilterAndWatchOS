//
//  ViewController.swift
//  Exercise7_Seenuvasavarathan_Sneha
//
//  Created by Sneha Seenuvasavarathan on 11/7/22.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var ImageView: UIImageView!
    
    @IBOutlet weak var watchButton: UIButton!
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var downloadButton: UIButton!
    
    
    var originalImage = UIImage(named: "nature1")
    var context = CIContext()
    let picker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        self.title = "Photo Filter App"
        ImageView.image = originalImage
        cameraButton.tintColor = UIColor(red: 45/255, green: 70/255, blue: 185/255, alpha: 1)
        selectButton.tintColor = UIColor(red: 45/255, green: 70/255, blue: 185/255, alpha: 1)
        downloadButton.tintColor = UIColor(red: 45/255, green: 70/255, blue: 185/255, alpha: 1)
        watchButton.tintColor = UIColor(red: 45/255, green: 70/255, blue: 185/255, alpha: 1)
        selectButton.contentVerticalAlignment = .fill
        selectButton.contentHorizontalAlignment = .fill
        downloadButton.contentVerticalAlignment = .fill
        downloadButton.contentHorizontalAlignment = .fill
        watchButton.contentVerticalAlignment = .fill
        watchButton.contentHorizontalAlignment = .fill
        cameraButton.contentVerticalAlignment = .fill
        cameraButton.contentHorizontalAlignment = .fill
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            guard let selectedImage = info[.originalImage] as? UIImage else {
                fatalError("Expected an image, but was provided the following: \(info)")
            }
            
            ImageView.image = selectedImage
            originalImage = selectedImage
            
            dismiss(animated: true, completion: nil)
        }
        
        func openCamera() {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.allowsEditing = false
                picker.sourceType = .camera
                picker.cameraCaptureMode = .photo
                present(picker, animated: true, completion: nil)
            }
        }
        
        func loadImageFromGallery() {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                picker.allowsEditing = false
                picker.sourceType = .photoLibrary
                present(picker, animated: true, completion: nil)
            }
        }
        
        func getFilterFromSegmentIdx(segmentIdx: Int, inputCIImage: CIImage) -> CIFilter {
                if segmentIdx == 2 {
                    return CIFilter(name: "CIPhotoEffectFade", parameters: ["inputImage": inputCIImage])!
                } else if segmentIdx == 1 {
                    return CIFilter(name: "CIColorMonochrome", parameters: ["inputImage": inputCIImage, "inputColor": CIColor(red: 45/255, green: 70/255, blue: 185/255, alpha: 1)])!
                
                } else {
                    return CIFilter(name: "CIPhotoEffectNoir", parameters: ["inputImage": inputCIImage])!
                }
            }
        func filterImage(inputImg : UIImage, segmentIdx: Int) -> UIImage? {
                guard let inputCIImage = CIImage(image: inputImg) else {
                    return nil
                }

                let filter = getFilterFromSegmentIdx(segmentIdx: segmentIdx, inputCIImage: inputCIImage)
           
                guard let ciImageResult = filter.outputImage else {
                    return nil
                }
                
                if let _cgImage = context.createCGImage(ciImageResult, from: ciImageResult.extent) {
                    let originalOrientation = inputImg.imageOrientation
                    let originalScale = inputImg.scale
                    return UIImage(cgImage: _cgImage, scale: originalScale, orientation: originalOrientation)
                }
                
                return nil
        }
    
    
    @IBAction func selectCamera(_ sender: Any) {
        show_camera()
    }
    @IBAction func selectImage(_ sender: Any) {
        show_picker()
    }
    
    @IBAction func sendToWatch(_ sender: Any) {
        
    }
    
    @IBAction func savePhoto(_ sender: Any) {
        guard ImageView.image != nil else {
                    return
                }
                UIImageWriteToSavedPhotosAlbum(ImageView.image!, self, #selector(save_image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction func applyFilter(_ sender: AnyObject) {
        guard let img = self.originalImage else {
                    return
                }

                if sender.selectedSegmentIndex == 0 {
                    self.ImageView.image = img

                } else if let image = self.filterImage(inputImg: img, segmentIdx: sender.selectedSegmentIndex) {
                    self.ImageView.image = image
                }
    }
    
    @objc func save_image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            
            if let error = error {
                let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
                
            } else {
                let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photo gallery", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        }
    func show_picker() {
            let alert = UIAlertController(title: "Photo Source Picker", message: "", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Open Gallery", comment: "Default action"), style: .default, handler: { _ in
                self.loadImageFromGallery()
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .cancel, handler: { _ in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    func show_camera() {
            let alert = UIAlertController(title: "Photo Source Picker", message: "", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Open Camera", comment: "Default action"), style: .default, handler: { _ in
                self.openCamera()
            }))
        
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .cancel, handler: { _ in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }

}

