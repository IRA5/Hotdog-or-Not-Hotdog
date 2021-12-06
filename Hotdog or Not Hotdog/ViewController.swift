//
//  ViewController.swift
//  Hotdog or Not Hotdog
//
//  Created by Irtaza Ali on 12/5/21.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
    let imagePicker = UIImagePickerController()
    
    let result : [VNClassificationObservation] = []
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        }
    
    @IBAction func cameraPressed(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            
            imageView.image = image
            
            imagePicker.dismiss(animated : true, completion : nil)
                    
            guard let ciImage = CIImage(image: image) else {return}
                    
            detect(image : ciImage)
        }
    }
        
}
    
    func detect(image: CIImage) {
        
        if let model = try? VNCoreMLModel(for: InceptionV3().model){
            
            let request = VNCoreMLRequest(model: model,) { request, errof in
                
                let results = request.results as? [VNClassificationObservation], let topResult = results.first  else {return}
                
                if topResult.identifier.contains("Hotdog") {
                    
                    DispatchQueue.main.async {
                        self.navigationItem.title = "Hotdog"
                        
                    }
                }
                
                else {
                    
                    DispatchQueue.main.async {
                        self.navigationItem.title = "Not Hotdog"
                        
                    }
                }
                
                let handler  = VNImageRequestHandler(ciImage : image)
                do {
                    try handler.perform[(request)]
                }
                
                catch {
                    print(error)
                }
                
                
            }
            
            
        }
        
    }

