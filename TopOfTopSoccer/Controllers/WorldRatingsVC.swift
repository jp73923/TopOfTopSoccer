//
//  WorldRatingsVC.swift
//  TopOfTopSoccer
//
//  Created by Jay on 27/10/22.
//

import UIKit
class cellTeamRankings:UITableViewCell {
    //MARK: - IBOutlets
    @IBOutlet weak var lblIndex: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var imgCountry: UIImageView!
}
class WorldRatingsVC: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var worldRatings: UITableView!
    
    //MARK: - Global Variables
    var arrWorldRatings = [[String:Any]]()

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.api_getWorldRankings()
    }
    
    //MARK: - IBActions
    @IBAction func btnBackSection(_ sender: UIButton) {
        APP_DELEGATE.appNavigation?.popViewController(animated: true)
    }

}

//MARK: - UITableViewDataSource,UITableViewDelegate
extension WorldRatingsVC: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrWorldRatings.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.worldRatings.dequeueReusableCell(withIdentifier: "cellTeamRankings") as! cellTeamRankings
        if let objCountry = self.arrWorldRatings[indexPath.row] as? [String:Any]{
            cell.lblIndex.text = "\(indexPath.row + 1)"
            cell.lblName.text = objCountry["rowName"] as? String ?? ""
            cell.lblScore.text = "\(objCountry["points"] as? Double ?? 0.0)"
            cell.lblRating.text = "\(objCountry["ranking"] as? NSNumber ?? 0)"
            if let team = objCountry["team"] as? [String:Any] {
                if let country = team["country"] as? [String:Any] {
                    if let strImg = country["alpha2"] as? String {
                        cell.imgCountry.image = UIImage.init(named: strImg)
                    }
                }
            }
        }
        return cell
    }
}


//MARK: - API Calling Methods
extension WorldRatingsVC {
    func api_getWorldRankings() {
        showLoaderHUD()
        let url = URL(string: "https://api.sofascore.com/api/v1/rankings/type/2")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with:request) { (data, response, error) in
            DispatchQueue.main.async {
                hideLoaderHUD()
            }
            if error != nil {
                print(error ?? "")
            } else {
                do {
                    let parsedDictionaryArray = try JSONSerialization.jsonObject(with: data!) as! [String:AnyObject]
                    DispatchQueue.main.async {
                        if let dict = parsedDictionaryArray as? [String:Any] {
                            if let arr = dict["rankings"] as? [[String:Any]] {
                                self.arrWorldRatings = arr
                            }
                            self.worldRatings.reloadData()
                        }
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        }.resume()
    }
}
