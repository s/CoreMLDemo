//
//  ViewController.swift
//  CoreMLDemo
//
//  Created by Said Ozcan on 06/06/2017.
//  Copyright © 2017 Said Ozcan. All rights reserved.
//

import UIKit

class SinglePhotoViewController: UIViewController {
    
    //MARK: Properties
    fileprivate let manager = PredictionService()
    fileprivate let dataSource = PredictionsDataSource()
    fileprivate var isInPredictionMode : Bool {
        didSet {
            self.imageView.isHidden = !isInPredictionMode
            self.tableView.isHidden = !isInPredictionMode
            self.predictionsLabel.isHidden = !isInPredictionMode
        }
    }
    
    fileprivate lazy var imagePickerController : UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate =  self
        return imagePicker
    }()
    
    fileprivate lazy var addPhotoAlertController : UIAlertController = {
        let action1 = UIAlertAction(title: "Choose from Camera Roll", style: .default, handler: { [unowned self] (action) -> Void in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        })
        
        let action2 = UIAlertAction(title: "Take a photo", style: .default, handler: { (action) -> Void in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true, completion: nil)
        })
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        
        let alert = UIAlertController(title: "Add photo",
                                      message: "",
                                      preferredStyle: .actionSheet)
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(cancel)
        return alert
    }()
    
    
    //MARK: IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBAction func addNewPhoto(_ sender: Any) {
        present(addPhotoAlertController, animated: true, completion: nil)
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var predictionsLabel: UILabel!
    
    
    //MARK: Lifecycle
    required init?(coder aDecoder: NSCoder) {
        self.isInPredictionMode = false
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Single Photo"
        self.tableView.dataSource = self.dataSource
        self.tableView.tableFooterView = UIView()
        self.isInPredictionMode = false
    }
    
    //MARK: Private
    fileprivate func didChoose(image:UIImage) {
        self.imageView.image = image
        self.isInPredictionMode = true
        
        if let predictions = self.manager.predict(image: image) {
            self.dataSource.items = predictions
            self.tableView.reloadData()
        }
    }
}

extension SinglePhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        self.didChoose(image: image)
    }
}
