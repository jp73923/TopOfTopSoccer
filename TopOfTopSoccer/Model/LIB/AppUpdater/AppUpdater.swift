//
//  AppUpdater.swift
//  AppUpdater
//
//  Created by YiSeungyoun on 2017. 12. 17..
//  Copyright © 2017년 SeungyounYi. All rights reserved.
//

import UIKit

public class AppUpdater: NSObject {
    public static let shared = AppUpdater()
    
    public class func versionAndDownloadUrl() -> (version: String, downloadUrl: String)? {
        guard
            let identifier:String = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)&country=in")
        else { return nil }
        guard
            let data = try? Data(contentsOf: url),
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
            let results = json["results"] as? [[String: Any]],
            results.count > 0,
            let version = results[0]["version"] as? String,
            let downLoadUrl = results[0]["trackViewUrl"] as? String
        else {
            return nil
        }
        return (version, downLoadUrl)
    }
    
    public class func isUpdateAvailable() -> Bool {
        guard let data = versionAndDownloadUrl() else { return false }
        return compare(appstoreVersion: data.version)
    }
    
    private class func compare(appstoreVersion: String) -> Bool {
        guard let deviceVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else { return false }
        if appstoreVersion.compare(deviceVersion, options: .numeric) == .orderedDescending {
            return true
        } else {
            return false
        }
    }
    
    public class func showUpdateAlert(isForce:Bool = false) {
        guard let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String, let data = versionAndDownloadUrl() else { return }
        var alert: UIAlertController?
        if compare(appstoreVersion: data.version) {
            alert = UIAlertController(title: nil, message: "\(appName) (\(data.version)) is available on the AppStore.\nPlease update the version.", preferredStyle: .alert)
            alert?.addAction(UIAlertAction(title: "Update", style: .destructive, handler: { action in
                guard let url = URL(string: data.downloadUrl) else { return }
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                    exit(0)
                })
            }))
            if !isForce {
                alert?.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            }
        } else {
            if !isForce {
                alert = UIAlertController(title: "\(APPNAME)", message: "Version \(data.version) is the latest version on the AppStore", preferredStyle: .alert)
                alert?.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            }
        }
        guard let _alert = alert else { return }
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.present(_alert, animated: true, completion: {})
    }
    
    public class func goToAppstore() {
        guard let data = versionAndDownloadUrl() else { return }
        if compare(appstoreVersion: data.version) {
            guard let url = URL(string: data.downloadUrl) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: { (success) in exit(0) })
        }
    }
}

