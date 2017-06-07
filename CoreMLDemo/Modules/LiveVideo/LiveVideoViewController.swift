//
//  LiveVideoViewController.swift
//  CoreMLDemo
//
//  Created by Said Ozcan on 06/06/2017.
//  Copyright © 2017 Said Ozcan. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import CoreML

class LiveVideoViewController: UIViewController {
    
    fileprivate let manager = PredictionService()
    fileprivate let dataSource = PredictionsDataSource()
    fileprivate lazy var capturingService : VideoCapturingService = { [unowned self] in
        return VideoCapturingService(previewView: self.previewView, delegate:self)
    }()
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var tableView: UITableView!
    let mlQueue = DispatchQueue(label: "ml.queue")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Video"
        
        self.tableView.tableFooterView = UIView()
        self.tableView.dataSource = self.dataSource
        self.previewView.layer.addSublayer(self.capturingService.previewLayer)
        self.capturingService.run()
    }
}

extension LiveVideoViewController : VideoCapturingServiceDelegate {
    func captureOutputBuffer(buffer: CVImageBuffer) {
        
        self.mlQueue.async {
            if let predictions = self.manager.predict(input: buffer) {
                DispatchQueue.main.async {
                    
                    self.dataSource.items = predictions
                    self.tableView.reloadData()
                }
            }
        }
    }
}
