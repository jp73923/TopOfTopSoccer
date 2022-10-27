//
//  HttpRequestManager.swift
//  wakeupp
//
//  Created by E Launch on 01/06/20.
//  Copyright © 2020 ELaunch. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

//Encoding Type
let URL_ENCODING = URLEncoding.default
let JSON_ENCODING = JSONEncoding.default

//Web Service Result
public enum RESPONSE_STATUS : NSInteger {
    case INVALID
    case VALID
    case MESSAGE
}
protocol UploadProgressDelegate {
    func didReceivedProgress(progress:Float)
}
protocol DownloadProgressDelegate {
    func didReceivedDownloadProgress(progress:Float,filename:String)
    func didFailedDownload(filename:String)
}

class HttpRequestManager {
    
    static let shared = HttpRequestManager()
    var uploadRequest: Request?
    var additionalHeader:HTTPHeaders = [HTTPHeader.init(name: "Accept", value: "application/json")]
    var responseObjectDic = Dictionary<String, AnyObject>()
    var repoMessage : String!
    var alamoFireManager = Alamofire.Session.default
    var delegate : UploadProgressDelegate?
    var downloadDelegate : DownloadProgressDelegate?
    
    // METHODS
    init() {
        alamoFireManager.session.configuration.timeoutIntervalForRequest = 120
    }
    
    //MARK:- Cancel Request
    func cancelAllAlamofireRequests(responseData:@escaping ( _ status: Bool?) -> Void) {
        alamoFireManager.session.getTasksWithCompletionHandler {
            dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
            responseData(true)
        }
    }
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    //get token
    func getAPITocken()-> String {
        return  "Bearer "
    }
    func getPushTocken()-> String {
        return "" //UserDefaultManager.getStringFromUserDefaults(key: UD_PushToken)
    }
    
    //MARK:- GET METHOD
    func getRequest(requestURL:String,param:[String: Any],showLoader:Bool,responseData:@escaping(_ error:Error?,_ responseDict:[String: Any]?) -> Void) {
        if isConnectedToNetwork(){
            if showLoader { showLoaderHUD()}
            if requestURL.contains("v5cached/articles") {
                additionalHeader.add(HTTPHeader.init(name: "Authorization", value: "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpYXQiOjE2NTcxMjgxMDcsImV4cCI6MjI4Nzg0ODEwNywidXNlcl9pZCI6MTA4NTk5OTF9.Qu__pA6AXusnK0vDpx2rxMussY0IxzSrhQFGonRXJj6eSGA0PrbwVTmvozmYtZoBpdNUHx4qm5gjL-LSFxXVQzjOs7nU9GhVEuZIeEpeR6P90DIhqpum_WhZlJGOPQ59QonslfS6aP_UzhjKzlly47kIfitOFB37GIXVHGiGWXZpTGmu_sPhnPq5tkJZK3KoZNXqNhUBMOrHSfJ2p43yFBt7nEPBfM9DmWcewdQmGrk6KOlUYh7gmouaYCpIOMSU8Ju2VbKR04jGEtEVUfDrAAKUKO3dUGwtW4ihIct3VkzQZbISC8p8kr8QBZNKbhxSzgbkpnaiOiLvB190HF6suQ"))
            }
            if requestURL.contains("v1/events") {
                additionalHeader.add(HTTPHeader.init(name: "Package", value: "KlUet6y43te8Jg6G9bkDxN36f9X9ZiTkm"))
            }
            
            alamoFireManager.request(requestURL, method: .get, parameters: param, headers: additionalHeader).responseString(completionHandler: { (responseString) in
                if let httpStatusCode = responseString.response?.statusCode {
                    if let strResponse = responseString.value, strResponse.count > 0{
                        let dict = self.convertToDictionary(text: strResponse)
                        self.repoMessage = dict?[kMessage] as? String ?? ServerResponseError
                        switch (httpStatusCode){
                        case 200:
                            hideLoaderHUD()
                            responseData(nil,dict)
                            break
                        case 400,401,403,404,405,408,409,422,423,426,429,500:
                            hideLoaderHUD()
                            if let dicError = dict?[kErrors] as? NSDictionary,dicError.count > 0 {
                                for (_,value) in dicError {
                                    showError("\(value)")
                                    break
                                }
                            }else{
                                showErrorMessage(self.repoMessage)
                            }
                            self.manageStatusCode(statusCode: httpStatusCode)
                            break
                        default :
                            hideLoaderHUD()
                            self.manageStatusCode(statusCode: httpStatusCode)
                            break
                        }
                    }else{
                        hideLoaderHUD()
                        responseData(responseString.error,nil)
                    }
                } else {
                    hideLoaderHUD()
                    showError("Oops! Request timed out!")
                    responseData(nil, nil)
                }
            })
        }
    }
    
    
    //MARK:- Put METHOD
    func putRequest(requestURL:String,param:[String: Any],loaderMessage:String,responseData:@escaping(_ error:Error?,_ responseDict:[String: Any]?) -> Void) {
        if isConnectedToNetwork() {
            if(loaderMessage.count > 0){ showLoaderHUD()}
//            if UserDefaultManager.getBooleanFromUserDefaults(key: UD_IsLoggedIn) { additionalHeader.add(name: "Authorization", value: self.getAPITocken()) }
            alamoFireManager.request(requestURL, method:.put, parameters:param, encoding:JSON_ENCODING ,headers:additionalHeader).responseString(completionHandler: { (responseString) in
                if let httpStatusCode = responseString.response?.statusCode {
                    if let strResponse = responseString.value, strResponse.count > 0{
                        let dict = self.convertToDictionary(text: strResponse)
                        self.repoMessage = dict?[kMessage] as? String ?? ServerResponseError
                        switch (httpStatusCode){
                        case 200:
                            hideLoaderHUD()
                            responseData(nil,dict)
                            break
                        case 400,401,403,404,405,408,409,422,423,426,429,500:
                            if let dicError = dict?[kErrors] as? NSDictionary,dicError.count > 0 {
                                for (_,value) in dicError {
                                    showError("\(value)")
                                    break
                                }
                            }else{
                                showErrorMessage(self.repoMessage)
                            }
                            self.manageStatusCode(statusCode: httpStatusCode)
                            break
                        default :
                            hideLoaderHUD()
                            self.manageStatusCode(statusCode: httpStatusCode)
                            break
                        }
                    }else{
                        hideLoaderHUD()
                        responseData(responseString.error,nil)
                    }
                }  else {
                    hideLoaderHUD()
                    showError("Oops! Request timed out!")
                    responseData(nil, nil)
                }
            })
        }
    }
    
    //MARK:- Delete METHOD
    func deleteRequest(requestURL:String,param:[String:Any],showLoader:Bool,responseData:@escaping(_ error:Error?,_ responseDict:[String: Any]?) -> Void) {
        if isConnectedToNetwork(){
            if showLoader { showLoaderHUD()}
            alamoFireManager.request(requestURL, method:.delete, parameters:param,headers:additionalHeader).responseString(completionHandler: { (responseString) in
                if let httpStatusCode = responseString.response?.statusCode {
                    if let strResponse = responseString.value, strResponse.count > 0{
                        let dict = self.convertToDictionary(text: strResponse)
                        self.repoMessage = dict?[kMessage] as? String ?? ServerResponseError
                        switch (httpStatusCode){
                        case 200:
                            hideLoaderHUD()
                            responseData(nil,dict)
                            break
                        case 400,401,403,404,405,408,409,422,423,426,429,500:
                            if let dicError = dict?[kErrors] as? NSDictionary,dicError.count > 0 {
                                for (_,value) in dicError {
                                    showError("\(value)")
                                    break
                                }
                            }else{
                                showErrorMessage(self.repoMessage)
                            }
                            self.manageStatusCode(statusCode: httpStatusCode)
                            break
                        default :
                            hideLoaderHUD()
                            self.manageStatusCode(statusCode: httpStatusCode)
                            break
                        }
                    }else{
                        hideLoaderHUD()
                        responseData(responseString.error,nil)
                    }
                } else {
                    hideLoaderHUD()
                    showError("Oops! Request timed out!")
                    responseData(nil, nil)
                }
            })
        }
        
    }
    
    // Post METHOD
    func postRequest(requestURL:String,param:[String: Any],showLoader:Bool,responseData:@escaping(_ error:Error?,_ responseDict:[String: Any]?) -> Void) {
        if isConnectedToNetwork() {
            if showLoader{ showLoaderHUD()}
            alamoFireManager.request(requestURL, method:.post, parameters:param, encoding:JSON_ENCODING, headers:additionalHeader).responseString(completionHandler: { (responseString) in
                if let httpStatusCode = responseString.response?.statusCode {
                    if let strResponse = responseString.value , strResponse.count > 0{
                        let dict = self.convertToDictionary(text: strResponse)
                        self.repoMessage = dict?[kMessage] as? String ?? ServerResponseError
                        switch (httpStatusCode){
                        case 200:
                            hideLoaderHUD()
                            responseData(nil,dict)
                            break
                        case 400,401,403,404,405,408,409,422,423,426,429,500:
                            hideLoaderHUD()
                            if let dicError = dict?[kErrors] as? NSDictionary,dicError.count > 0 {
                                for (_,value) in dicError {
                                    showError("\(value)")
                                    break
                                }
                            }else{
                                showErrorMessage(self.repoMessage)
                            }
                            self.manageStatusCode(statusCode: httpStatusCode)
                            break
                        default :
                            hideLoaderHUD()
                            self.manageStatusCode(statusCode: httpStatusCode)
                            break
                        }
                    }else{
                        hideLoaderHUD()
                        responseData(responseString.error,nil)
                    }
                } else {
                    hideLoaderHUD()
                    showError("Oops! Request timed out!")
                    responseData(nil, nil)
                }
            })
        }
    }
    
    
    //Multipart image uploading
     func multipartRequest(requestURL:String,param:[String: Any],loaderMessage:String,responseData:@escaping (_ error:Error?,_ responseDict: [String: Any]?) -> Void){
        if isConnectedToNetwork()  {
            if(loaderMessage.count > 0){ showLoaderHUD()}
            additionalHeader.add(name: "Authorization", value: self.getAPITocken())
            alamoFireManager.upload(multipartFormData:{ multipartFormData in
                for (key, value) in param {
                    if value is Data {
                        multipartFormData.append(value as! Data, withName: key, fileName: "\(Date())jss.jpeg", mimeType: "image/jpeg")
                    } else if value is UIImage{
                        let data:Data = (value as! UIImage).jpegData(compressionQuality: 0.5)!
                        multipartFormData.append(data, withName: "\(key)", fileName: "Thumb"+"\(Date())", mimeType: "image/jpeg")
                    } else {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                    }
                }
            }, to: requestURL,method:.post, headers:additionalHeader).responseJSON(completionHandler: {(responseString) in
                if let httpStatusCode = responseString.response?.statusCode {
                    if let dict = responseString.value as? [String : Any], dict.keys.count > 0{
                        self.repoMessage = dict[kMessage] as? String ?? ServerResponseError
                        switch (httpStatusCode){
                        case 200:
                             hideLoaderHUD()
                             responseData(nil, dict)
                            break
                        case 400,401,403,404,405,408,409,422,423,426,429,500:
                            if let dicError = dict[kErrors] as? NSDictionary,dicError.count > 0 {
                                for (_,value) in dicError {
                                    showError("\(value)")
                                    break
                                }
                            }else{
                                showMessage(self.repoMessage)
                            }
                            self.manageStatusCode(statusCode: httpStatusCode)
                            break
                        default :
                            hideLoaderHUD()
                            self.manageStatusCode(statusCode: httpStatusCode)
                            break
                        }
                    }else{
                        hideLoaderHUD()
                        responseData(responseString.error,nil)
                    }
                } else {
                    hideLoaderHUD()
                    showError("Oops! Request timed out!")
                    responseData(nil, nil)
                }
            })
        }
     }
    
    func multipartRequest(requestURL:String,param:[String: Any],mediaData:[[String:Any]],showLoader:Bool,responseData:@escaping (_ error:Error?,_ responseDict: [String: Any]?) -> Void){
        if isConnectedToNetwork()  {
            if showLoader { showLoaderHUD()}
            additionalHeader.add(name: "Authorization", value: self.getAPITocken())
            alamoFireManager.upload(multipartFormData: { multipartFormData in
                for mdata in mediaData {
                    for (key, value) in mdata {
                        if let imgdata = value as? Data{
                            multipartFormData.append(imgdata, withName: key, fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                        } else if let urlVideo = value as? URL{
                            let fileExt = (urlVideo.lastPathComponent.components(separatedBy: ".").last!).lowercased()
                            var mime = ""
                            
                            switch fileExt{
                            case "jpeg":
                                mime = "image/jpeg"
                                break
                            case "png":
                                mime = "image/png"
                                break
                            case "gif":
                                mime = "image/gif"
                                break
                            case "3gpp":
                                mime = "video/3gpp"
                                break
                            case "3gp":
                                mime = "video/3gpp"
                                break
                            case "ts":
                                mime = "video/mp2t"
                                break
                            case "mp4":
                                mime = "video/mp4"
                                break
                            case "mpeg":
                                mime = "video/mpeg"
                                break
                            case "mpg":
                                mime = "video/mpg"
                                break
                            case "mov":
                                mime = "video/quicktime"
                                break
                            case "webm":
                                mime = "video/webm"
                                break
                            case "flv":
                                mime = "video/x-flv"
                                break
                            case "m4v":
                                mime = "video/x-m4v"
                                break
                            case "mng":
                                mime = "video/x-mng"
                                break
                            case "asx":
                                mime = "video/x-ms-asf"
                                break
                            case "asf":
                                mime = "video/x-ms-asf"
                                break
                            case "wmv":
                                mime = "video/x-ms-wmv"
                                break
                            case "avi":
                                mime = "video/x-msvideo"
                                break
                            default:
                                break
                            }
                            var fileData:Data? = nil
                            do{
                                fileData = try Data.init(contentsOf: urlVideo)
                                multipartFormData.append(fileData!, withName: key, fileName: "\(Date().timeIntervalSince1970).\(fileExt)", mimeType: mime)
                            }catch let error{
                                print("\(error.localizedDescription)")
                            }
                        }else if let _ = value as? String{
                            multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                        }
                    }
                }
                for (key, value) in param {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
            }, to: requestURL,method:.post, headers:additionalHeader).responseJSON(completionHandler: {(responseString) in
                if let httpStatusCode = responseString.response?.statusCode {
                    if let dict = responseString.value as? [String : Any], dict.keys.count > 0{
                        self.repoMessage = dict[kMessage] as? String ?? ServerResponseError
                        switch (httpStatusCode){
                        case 200:
                             hideLoaderHUD()
                             responseData(nil, dict)
                            break
                        case 400,401,403,404,405,408,409,422,423,426,429,500:
                            if let dicError = dict[kErrors] as? NSDictionary,dicError.count > 0 {
                                for (_,value) in dicError {
                                    showError("\(value)")
                                    break
                                }
                            }else{
                                showMessage(self.repoMessage)
                            }
                            self.manageStatusCode(statusCode: httpStatusCode)
                            break
                        default :
                            hideLoaderHUD()
                            self.manageStatusCode(statusCode: httpStatusCode)
                            break
                        }
                    }else{
                        hideLoaderHUD()
                        responseData(responseString.error,nil)
                    }
                } else {
                    hideLoaderHUD()
                    showError("Oops! Request timed out!")
                    responseData(nil, nil)
                }
            })
        }
    }
    
    
    func multipartRequest(requestURL:String,param:[String: Any],imagesData:[Data],showLoader:Bool,responseData:@escaping(_ error:Error?,_ responseDict: [String: Any]?) -> Void) {
        if isConnectedToNetwork() {
            if showLoader { showLoaderHUD()}
            additionalHeader.add(name: "Authorization", value: self.getAPITocken())
            alamoFireManager.upload(multipartFormData:{ multipartFormData in
                for imagedata in imagesData {
                    multipartFormData.append(imagedata, withName: "image[]", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                }
                for (key, value) in param {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
            }, to: requestURL, method:.post, headers:additionalHeader).responseJSON(completionHandler: {(responseString) in
                if let httpStatusCode = responseString.response?.statusCode {
                    if let dict = responseString.value as? [String : Any], dict.keys.count > 0{
                        self.repoMessage = dict[kMessage] as? String ?? ServerResponseError
                        switch (httpStatusCode){
                        case 200:
                             hideLoaderHUD()
                             responseData(nil, dict)
                            break
                        case 400,401,403,404,405,408,409,422,423,426,429,500:
                            if let dicError = dict[kErrors] as? NSDictionary,dicError.count > 0 {
                                for (_,value) in dicError {
                                    showError("\(value)")
                                    break
                                }
                            }else{
                                showMessage(self.repoMessage)
                            }
                            self.manageStatusCode(statusCode: httpStatusCode)
                            break
                        default :
                            hideLoaderHUD()
                            self.manageStatusCode(statusCode: httpStatusCode)
                            break
                        }
                    }else{
                        hideLoaderHUD()
                        responseData(responseString.error,nil)
                    }
                } else {
                    hideLoaderHUD()
                    showError("Oops! Request timed out!")
                    responseData(nil, nil)
                }
            })
        }
    }
    
    
    func cancelUpload() {
        self.uploadRequest = nil
    }
    
    //MARK:- PARSING DATA
    func manageStatusCode(statusCode: Int) {
        if statusCode == 401{
            
        }
    }
}
