//
//  MyTopSelectionVC.swift
//  TopOfTopSoccer
//
//  Created by Jay on 27/10/22.
//

import UIKit
class cellTopSelectionTeam:UITableViewCell {
    //MARK: - IBOutlets
    @IBOutlet weak var lblTeamName: UILabel!
    @IBOutlet weak var imgTeam: UIImageView!
    @IBOutlet weak var lblTeamRating: UILabel!
    @IBOutlet weak var vwRatingBg: UIView!
    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var imgGradientBG: UIImageView!
}
class cellTopSelectionPlayer:UITableViewCell {
    //MARK: - IBOutlets
    @IBOutlet weak var lblTeamName: UILabel!
    @IBOutlet weak var imgTeam: UIImageView!
    @IBOutlet weak var lblTeamRating: UILabel!
    @IBOutlet weak var vwRatingBg: UIView!
    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var imgGradientBG: UIImageView!
}

class MyTopSelectionVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var topPlayerTableview: UITableView!
    @IBOutlet weak var tblTopTeams: UITableView!
    @IBOutlet weak var lblTitle: UILabel!

    //MARK: - Global Variables
    var arrTopPlayers = [[String:Any]]()
    var arrTopTeams = [[String:Any]]()
    var strTile = ""
    var isFromMyTeamSelction = false
    var selectedPlayersIds = [NSNumber]()
    var selectedTeamsIds = [NSNumber]()

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblTitle.text = self.isFromMyTeamSelction ? "Сhoose teams of " + strTile : "Сhoose players of " + strTile
        self.tblTopTeams.reloadData()
        self.topPlayerTableview.reloadData()
        if self.isFromMyTeamSelction {
            self.tblTopTeams.isHidden = false
            self.topPlayerTableview.isHidden = true
        } else {
            self.tblTopTeams.isHidden = true
            self.topPlayerTableview.isHidden = false
        }
    }
    
    //MARK: - IBActions
    @IBAction func btnSelectAction(_ sender: UIButton) {
        APP_DELEGATE.appNavigation?.dismiss(animated: true, completion: nil)
        APP_DELEGATE.selectedTeamsIds = self.selectedTeamsIds
        APP_DELEGATE.selectedPlayersIds = self.selectedPlayersIds
    }
}

//MARK: - UITableViewDataSource,UITableViewDelegate
extension MyTopSelectionVC: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.topPlayerTableview {
            return self.arrTopPlayers.count
        } else {
            return self.arrTopTeams.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.topPlayerTableview {
            let cell = self.topPlayerTableview.dequeueReusableCell(withIdentifier: "cellTopSelectionPlayer") as! cellTopSelectionPlayer
            if let obj = self.arrTopPlayers[indexPath.row] as? [String:Any] {
                cell.lblTeamRating.text = obj["formattedValue"] as? String ?? ""
                if let player = obj["player"] as? [String:Any] {
                    cell.lblTeamName.text = player["name"] as? String ?? ""
                    cell.imgTeam.sd_setImage(with: URL.init(string: "https://api.sofascore.com/api/v1/player/" + "\((player["id"] as? NSNumber ?? 0))" + "/image"), placeholderImage: UIImage.init(named: "ic_club_placeholder"))
                    if self.selectedPlayersIds.contains(player["id"] as? NSNumber ?? 0) {
                        cell.imgGradientBG.image = UIImage.init(named: "SelectedGreenGradient")
                    } else {
                        cell.imgGradientBG.image = UIImage.init(named: "GreenGradient")
                    }
                }
            }
            return cell
        } else {
            let cell = self.tblTopTeams.dequeueReusableCell(withIdentifier: "cellTopSelectionTeam") as! cellTopSelectionTeam
            if let obj = self.arrTopTeams[indexPath.row] as? [String:Any] {
                if let team = obj["team"] as? [String:Any] {
                    cell.lblTeamName.text = team["name"] as? String ?? ""
                    cell.imgTeam.sd_setImage(with: URL.init(string: "https://api.sofascore.com/api/v1/team/" + "\((team["id"] as? NSNumber ?? 0))" + "/image"), placeholderImage: UIImage.init(named: "ic_club_placeholder"))
                    if self.selectedTeamsIds.contains(team["id"] as? NSNumber ?? 0) {
                        cell.imgGradientBG.image = UIImage.init(named: "SelectedGreenGradient")
                    } else {
                        cell.imgGradientBG.image = UIImage.init(named: "GreenGradient")
                    }
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.topPlayerTableview {
            if let obj = self.arrTopPlayers[indexPath.row] as? [String:Any] {
                if let objPlayer = obj["player"] as? [String:Any] {
                    if self.selectedPlayersIds.contains(objPlayer["id"] as? NSNumber ?? 0) {
                        if let index = self.selectedPlayersIds.index(of: objPlayer["id"] as? NSNumber ?? 0) {
                            self.selectedPlayersIds.remove(at: index)
                        }
                    } else {
                        self.selectedPlayersIds.append(objPlayer["id"] as? NSNumber ?? 0)
                    }
                    self.topPlayerTableview.reloadData()
                }
            }
        } else {
            if let obj = self.arrTopTeams[indexPath.row] as? [String:Any] {
                if let team = obj["team"] as? [String:Any] {
                    if self.selectedTeamsIds.contains(team["id"] as? NSNumber ?? 0) {
                        if let index = self.selectedTeamsIds.index(of: team["id"] as? NSNumber ?? 0) {
                            self.selectedTeamsIds.remove(at: index)
                        }
                    } else {
                        self.selectedTeamsIds.append(team["id"] as? NSNumber ?? 0)
                    }
                    self.tblTopTeams.reloadData()
                }
            }
        }
    }
}
