//
//  MyTopVC.swift
//  TopOfTopSoccer
//
//  Created by Jay on 27/10/22.
//

import UIKit
class cellMyTopTeamHeader:UITableViewCell {
    //MARK: - IBOutlets
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var vwBg: UIView!
}
class cellMyTopTopTeam:UITableViewCell {
    //MARK: - IBOutlets
    @IBOutlet weak var lblTeamName: UILabel!
    @IBOutlet weak var imgTeam: UIImageView!
    @IBOutlet weak var lblTeamRating: UILabel!
    @IBOutlet weak var vwRatingBg: UIView!
    @IBOutlet weak var vwBg: UIView!
}
class cellMyTopPlayerHeader:UITableViewCell {
    //MARK: - IBOutlets
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var vwBg: UIView!
}
class cellMyTopTopPlayer:UITableViewCell {
    //MARK: - IBOutlets
    @IBOutlet weak var lblTeamName: UILabel!
    @IBOutlet weak var imgTeam: UIImageView!
    @IBOutlet weak var lblTeamRating: UILabel!
    @IBOutlet weak var vwRatingBg: UIView!
    @IBOutlet weak var vwBg: UIView!
}
class MyTopVC: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var topPlayerTableview: UITableView!
    @IBOutlet weak var tblTopTeams: UITableView!
    @IBOutlet weak var vwTopTeams: UIView!
    @IBOutlet weak var vwTopPlayers: UIView!

    //MARK: - Global Variables
    var arrTopPlayers = [[String:Any]]()
    var arrTopTeams = [[String:Any]]()
    var objTopTeams = [String:Any]()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topPlayerTableview.isHidden = false
        self.tblTopTeams.isHidden = true
        self.vwTopPlayers.backgroundColor = UIColor.fromHex(hexString: "#BC2013")
        self.vwTopTeams.backgroundColor = UIColor.fromHex(hexString: "#DB3821")
        self.api_getTopPlayersList()
        self.api_getTopTeams()
    }
    
    
    //MARK: - IBActions
    @IBAction func btnTopPlayersAction(_ sender: UIButton) {
        self.topPlayerTableview.isHidden = false
        self.tblTopTeams.isHidden = true
        self.vwTopPlayers.backgroundColor = UIColor.fromHex(hexString: "#BC2013")
        self.vwTopTeams.backgroundColor = UIColor.fromHex(hexString: "#DB3821")
    }
    @IBAction func btnTopTeamsSection(_ sender: UIButton) {
        self.topPlayerTableview.isHidden = true
        self.tblTopTeams.isHidden = false
        self.vwTopTeams.backgroundColor = UIColor.fromHex(hexString: "#BC2013")
        self.vwTopPlayers.backgroundColor = UIColor.fromHex(hexString: "#DB3821")
    }
    @IBAction func btnBackSection(_ sender: UIButton) {
        APP_DELEGATE.appNavigation?.popViewController(animated: true)
    }
}

//MARK: - UITableViewDataSource,UITableViewDelegate
extension MyTopVC: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.topPlayerTableview {
            return self.arrTopPlayers.count
        } else {
            return self.arrTopTeams.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.topPlayerTableview {
            let cell = self.topPlayerTableview.dequeueReusableCell(withIdentifier: "cellMyTopTopPlayer") as! cellMyTopTopPlayer
            if let obj = self.arrTopPlayers[indexPath.row] as? [String:Any] {
                cell.lblTeamRating.text = obj["formattedValue"] as? String ?? ""
                if let player = obj["player"] as? [String:Any] {
                    cell.lblTeamName.text = player["name"] as? String ?? ""
                    cell.imgTeam.sd_setImage(with: URL.init(string: "https://api.sofascore.com/api/v1/player/" + "\((player["id"] as? NSNumber ?? 0))" + "/image"), placeholderImage: UIImage.init(named: "ic_club_placeholder"))
                }
            }
            return cell
        } else {
            let cell = self.tblTopTeams.dequeueReusableCell(withIdentifier: "cellMyTopTopTeam") as! cellMyTopTopTeam
            if let team = self.arrTopTeams[indexPath.row] as? [String:Any] {
                if let obj = team["team"] as? [String:Any] {
                    cell.lblTeamName.text = obj["name"] as? String ?? ""
                    cell.imgTeam.sd_setImage(with: URL.init(string: "https://api.sofascore.com/api/v1/team/" + "\((obj["id"] as? NSNumber ?? 0))" + "/image"), placeholderImage: UIImage.init(named: "ic_club_placeholder"))
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57.0
    }
}

//MARK: - API Calling Methods
extension MyTopVC {
    func api_getTopPlayersList() {
        showLoaderHUD()
        let url = URL(string: "https://api.sofascore.com/mobile/v4/unique-tournament/35/season/42268/top-players")
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
                    let parsedDictionaryArray = try JSONSerialization.jsonObject(with: data!) as! [[String:AnyObject]]
                    DispatchQueue.main.async {
                        if let arr = parsedDictionaryArray as? [[String:Any]] {
                            for i in 0 ..< arr.count {
                                if let arr1 = arr[i]["topPlayers"] as? [[String:Any]] {
                                    for j in 0 ..< arr1.count {
                                        if let obj = arr1[j] as? [String:Any] {
                                            if let player = obj["player"] as? [String:Any] {
                                                if APP_DELEGATE.selectedPlayersIds.contains(player["id"] as? NSNumber ?? 0) {
                                                    self.arrTopPlayers.append(obj)
                                                }
                                            }
                                        }
                                    }
                                    break
                                }
                            }
                            self.topPlayerTableview.reloadData()
                        }
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        }.resume()
    }
    func api_getTopTeams() {
        showLoaderHUD()
        let url = URL(string: "https://api.sofascore.com/api/v1/unique-tournament/35/season/42268/top-teams/overall")
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
                    let parsedDictionary = try JSONSerialization.jsonObject(with: data!) as! [String:AnyObject]
                    DispatchQueue.main.async {
                        if let dictTopPlayer = parsedDictionary as? [String:Any] {
                            if let dict = dictTopPlayer["topTeams"] as? [String:Any] {
                                if let arr = dict["avgRating"] as? [[String:Any]] {
                                    for i in 0 ..< arr.count {
                                        if let obj = arr[i] as? [String:Any] {
                                            if let team = obj["team"] as? [String:Any] {
                                                if APP_DELEGATE.selectedTeamsIds.contains(team["id"] as? NSNumber ?? 0) {
                                                    self.arrTopTeams.append(obj)
                                                }
                                            }
                                        }
                                    }
                                }
                                self.tblTopTeams.reloadData()
                            }
                        }
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        }.resume()
    }
}
