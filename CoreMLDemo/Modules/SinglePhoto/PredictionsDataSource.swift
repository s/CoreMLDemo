//
//  PredictionsDataSource.swift
//  CoreMLDemo
//
//  Created by Said Ozcan on 06/06/2017.
//  Copyright © 2017 Said Ozcan. All rights reserved.
//

import UIKit

class PredictionsDataSource: NSObject, UITableViewDataSource {
    
    var items:[PredictionResult] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PredictionCell", for: indexPath)
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.possiblePrediction
        cell.detailTextLabel?.text = String("P:\(item.probability.roundTo(places: 3))")
        
        if indexPath.row == 0 {
            cell.backgroundColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        }
        return cell
    }
}
