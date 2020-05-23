//
//  ViewController.swift
//  SwiftTest
//
//  Created by Yulia Malaya on 18.05.2020.
//  Copyright © 2020 Yulia Malaya. All rights reserved.
//

import UIKit

class BreedsViewController: UIViewController{
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var breeds = [Breeds]()
    var breed: Breeds?
    
    var filteredBreeds = [Breeds]()
    var shouldShowSearchResults = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.breeds.count == 0 {
            loadBreedsData { breeds in
                self.breeds = breeds!
                self.collectionView.reloadData()
                self.activityIndicator.isHidden = true
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            let showDetailVC = segue.destination as! ShowDetailViewController
            showDetailVC.breed = breed
            
            let infoVC = segue.destination as! ShowDetailViewController
            infoVC.breed = breed
        }
    }
    
    func loadBreedsData(completionHandler: @escaping ([Breeds]?) -> Void){
        let url = URL(string: "https://api.thecatapi.com/v1/breeds")
        
        let request = URLRequest(url: url!)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            
            do {
                self.breeds = try JSONDecoder().decode([Breeds].self, from: data)
                DispatchQueue.main.async {
                    completionHandler(self.breeds)
                }
            }
            catch  let error {
                print(error)
            }
        }.resume()
    }
}

//MARK: CollectionView Extension

extension BreedsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return self.filteredBreeds.count
        } else{
            return self.breeds.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if shouldShowSearchResults{
            breed = filteredBreeds[indexPath.row]
        } else{
            breed = breeds[indexPath.row]
        }
        
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! BreedCollectionViewCell
        
        if shouldShowSearchResults{
            breed = self.filteredBreeds[indexPath.row]
            cell.label.text = breed?.name
            cell.imageView.image = UIImage(named: (breed?.name)!)
        } else{
            breed = self.breeds[indexPath.row]
            cell.label.text = breed?.name
            cell.imageView.image = UIImage(named: (breed?.name)!)
        }
        
        cell.layer.cornerRadius = 10
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewWidth = self.view.bounds.width
        return CGSize(width: (viewWidth / 2) - 15, height: 228);
    }
}

//MARK: UISearchBar Extension

extension BreedsViewController:  UISearchBarDelegate{
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        self.collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            self.collectionView.reloadData()
        }
        
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        shouldShowSearchResults = true
        
        filteredBreeds = searchText.isEmpty ? breeds :  breeds.filter { (item : Breeds) -> Bool in
            return (item.name)!.range(of: searchText, options: .anchored, range: nil, locale:  nil) != nil
        }
        self.collectionView.reloadData()
    }
}


