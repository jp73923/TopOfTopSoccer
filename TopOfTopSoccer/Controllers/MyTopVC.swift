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
class cellEmptyTeam:UITableViewCell {
}
class cellEmptyPlayer:UITableViewCell {
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
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.topPlayerTableview {
            return self.arrTopPlayers.count
        } else {
            return self.objTopTeams.map({ $0.key }).count
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.topPlayerTableview {
            return 3
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.topPlayerTableview {
            if let arr = self.arrTopPlayers[indexPath.section]["topPlayers"] as? [[String:Any]] {
                if let obj = arr[indexPath.row] as? [String:Any] {
                    if let player = obj["player"] as? [String:Any] {
                        if let id = player["id"] as? NSNumber {
                            if APP_DELEGATE.selectedPlayersIds.contains(id) {
                                let cell = self.topPlayerTableview.dequeueReusableCell(withIdentifier: "cellMyTopTopPlayer") as! cellMyTopTopPlayer
                                cell.lblTeamRating.text = obj["formattedValue"] as? String ?? ""
                                cell.lblTeamName.text = player["name"] as? String ?? ""
                                cell.imgTeam.sd_setImage(with: URL.init(string: "https://api.sofascore.com/api/v1/player/" + "\((player["id"] as? NSNumber ?? 0))" + "/image"), placeholderImage: UIImage.init(named: "ic_club_placeholder"))
                                return cell
                            } else {
                                let cell = self.topPlayerTableview.dequeueReusableCell(withIdentifier: "cellEmptyPlayer") as! cellEmptyPlayer
                                return cell
                            }
                        }
                    }
                }
            }
            return UITableViewCell()
        } else {
            if let arr = self.objTopTeams.map({ $0.value })[indexPath.section] as? [[String:Any]] {
                if let obj = arr[indexPath.row] as? [String:Any] {
                    if let team = obj["team"] as? [String:Any] {
                        if let id = team["id"] as? NSNumber {
                            if APP_DELEGATE.selectedTeamsIds.contains(id) {
                                let cell = self.tblTopTeams.dequeueReusableCell(withIdentifier: "cellMyTopTopTeam") as! cellMyTopTopTeam
                                cell.lblTeamName.text = team["name"] as? String ?? ""
                                cell.imgTeam.sd_setImage(with: URL.init(string: "https://api.sofascore.com/api/v1/team/" + "\((team["id"] as? NSNumber ?? 0))" + "/image"), placeholderImage: UIImage.init(named: "ic_club_placeholder"))
                                if let statistics = obj["statistics"] as? [String:Any] {
                                    if let rating = statistics[self.objTopTeams.map({ $0.key })[indexPath.section]] as? NSNumber {
                                        if self.objTopTeams.map({ $0.key })[indexPath.section].contains("avgRating") || self.objTopTeams.map({ $0.key })[indexPath.section].contains("averageBallPossession"){
                                            if let rating1 = statistics[self.objTopTeams.map({ $0.key })[indexPath.section]] as? Double {
                                                cell.lblTeamRating.text = String.init(format: "%0.1f", rating1)
                                            }
                                        } else {
                                            cell.lblTeamRating.text = "\(rating)"
                                        }
                                    }
                                }
                                return cell
                            } else {
                                let cell = self.tblTopTeams.dequeueReusableCell(withIdentifier: "cellEmptyTeam") as! cellEmptyTeam
                                return cell
                            }
                        }
                    }
                }
            }
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.topPlayerTableview {
            let cell = self.topPlayerTableview.dequeueReusableCell(withIdentifier: "cellMyTopPlayerHeader") as! cellMyTopPlayerHeader
            if let obj = self.arrTopPlayers[section] as? [String:Any] {
                cell.lblHeader.text = obj["name"] as? String ?? ""
            }
            return cell.contentView
        } else {
            let cell = self.tblTopTeams.dequeueReusableCell(withIdentifier: "cellMyTopTeamHeader") as! cellMyTopTeamHeader
            cell.lblHeader.text = self.objTopTeams.map({ $0.key })[section].capitalizingFirstLetter()
            return cell.contentView
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 42.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 25
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = loadVC(strStoryboardId: SB_MAIN, strVCId: idMyTopSelectionVC) as! MyTopSelectionVC
        if self.topPlayerTableview.isHidden == true {
            vc.isFromMyTeamSelction = true
        } else {
            vc.isFromMyTeamSelction = false
        }
        if tableView == self.topPlayerTableview {
            if let obj = self.arrTopPlayers[indexPath.section] as? [String:Any] {
                vc.strTile = obj["name"] as? String ?? ""
            }
            if let arr = self.arrTopPlayers[indexPath.section]["topPlayers"] as? [[String:Any]] {
                vc.arrTopPlayers = arr
            }
        } else {
            vc.strTile = self.objTopTeams.map({ $0.key })[indexPath.section].capitalizingFirstLetter()
            if let arr = self.objTopTeams.map({ $0.value })[indexPath.section] as? [[String:Any]] {
                vc.arrTopTeams = arr
            }
        }
        vc.delegate = self
        APP_DELEGATE.appNavigation?.present(vc, animated: true, completion: nil)
    }
}

//MARK: - delegateSeletionDone
extension MyTopVC:delegateSeletionDone {
    func didFinishSelectionDone() {
        self.tblTopTeams.reloadData()
        self.topPlayerTableview.reloadData()
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
                            self.arrTopPlayers = arr
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
                                self.objTopTeams = dict
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
