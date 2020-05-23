//
//  showDetailViewController.swift
//  BreedInfo
//
//  Created by Yulia Malaya on 18.05.2020.
//  Copyright © 2020 Yulia Malaya. All rights reserved.
//

import UIKit

class ShowDetailViewController: UIViewController {
    
    @IBOutlet private weak var showLabel: UILabel!
    @IBOutlet private weak var showImage: UIImageView!
    @IBOutlet private weak var tableView : UITableView!
    
    var breed:Breeds?
    var breedViewData = [BreedViewModel]()
    let iconNames = ["Icon", "Weigher", "Ruler", "Origin"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 75
        self.tableView.rowHeight = 75
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.createBreedDetailViewData()
        
        let breedName = self.breed?.name
        showImage.image = UIImage(named: breedName!)
        showLabel.text = breed?.name
    }
    
    func convertNumberToMedals(number: Int) -> String{
        var str = String()
        for _ in 0...number-1{
            str += "🎖"
        }
        return str
    }
    
    func createBreedDetailViewData(){
        var obj = BreedViewModel(firstKey: "Lifespan", firstValue: (breed?.life_span)!, secondKey: "Affection level", secondValue: convertNumberToMedals(number: (breed?.affection_level)!))
        breedViewData.append(obj)
        obj = BreedViewModel(firstKey: "Imperial", firstValue: (breed?.weight?.imperial)!, secondKey: "Grooming", secondValue: convertNumberToMedals(number: (breed?.grooming)!))
        breedViewData.append(obj)
        obj = BreedViewModel(firstKey: "Metric", firstValue: (breed?.weight?.metric)!, secondKey: "Helth issues", secondValue: convertNumberToMedals(number: (breed?.health_issues)!))
        breedViewData.append(obj)
        obj = BreedViewModel(firstKey: "Origin", firstValue: (breed?.origin)!, secondKey: "Intelligence", secondValue: convertNumberToMedals(number: (breed?.intelligence)!))
        breedViewData.append(obj)
    }
    
}

// MARK: UITableView EXTENSION
extension ShowDetailViewController:  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breedViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! ShowDetailTableViewCell
        cell.icon.image = UIImage(named: iconNames[indexPath.row])
        cell.firstTextKey.text = breedViewData[indexPath.row].firstKey
        cell.firstTextValue.text = breedViewData[indexPath.row].firstValue
        cell.secondTextKey.text = breedViewData[indexPath.row].secondKey
        cell.secondTextValue.text = breedViewData[indexPath.row].secondValue
        
        return cell
    }
}

struct BreedViewModel {
    var firstKey:String
    var firstValue:String
    var secondKey:String
    var secondValue:String
    
    init(firstKey:String, firstValue:String, secondKey:String, secondValue:String) {
        self.firstKey = firstKey
        self.firstValue = firstValue
        self.secondKey = secondKey
        self.secondValue = secondValue
    }
}
