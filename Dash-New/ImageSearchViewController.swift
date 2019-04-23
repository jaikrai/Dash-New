//
//  ImageSearchViewController.swift
//  Dash-New
//
//  Created by Jared Breedlove on 4/22/19.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

class ImageSearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate{

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    var callback : ((String) -> Void)?
    var links: [String] = []
    var thumbs: [String] = []
    var initialSearchTerm: String = "Test"
    var searchApiLink = "https://www.googleapis.com/customsearch/v1?key=AIzaSyB9TxUvfg1ssTGcB2AF1LuJU86yuP9EnmE&cx=005539455595144501025:iybcemmquou&searchType=image&q="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImages(querry: initialSearchTerm.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil))
        self.navigationController?.setToolbarHidden(true, animated: true)
        title = "Add An Image"
        searchBar.text = initialSearchTerm
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        collectionView.reloadData()
    }
    
    func fetchImages(querry: String){
        guard let url = URL(string: searchApiLink + querry) else {
            print("Invalid Search Term")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                self.links.removeAll()
                self.thumbs.removeAll()
                guard let jsonResponse = try JSONSerialization.jsonObject(with:dataResponse, options: []) as? [String: Any] else{return}
                let test = jsonResponse as NSDictionary
                let testing = test["items"] as? [NSDictionary]
                for image in testing!{
                    let temp = image["image"] as? NSDictionary
                    self.thumbs.append((temp!["thumbnailLink"] as? String)!)
                    self.links.append((image["link"] as? String)!)
                    print(self.links.count)
                }
                print(self.links.count)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch let parsingError {
                    print("Error", parsingError)
            }
        }
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return links.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let url = URL(string: thumbs[indexPath.item])
        imageView.load(url: url!)
        cell.insertSubview(imageView, at: 5)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        callback?(self.links[indexPath.item])
        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if(searchBar.text != ""){
            fetchImages(querry: searchBar.text!.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil))
        }
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                     self?.image = image
                    }
                }
            }
        }
    }
}
