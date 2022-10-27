//
//  Constants.swift
//
//  Created by C237 on 30/10/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import UIKit


let GET = "GET"
let POST = "POST"
let MEDIA = "MEDIA"

//MARK:- RESPONSE KEY
let kData    = "data"
let kMessage = "message"
let kStatus  = "status"
let kToken   = "token"
let kCode    = "code"
let kSuccess = "success"
let kErrors  = "errors"
let kMac     = "mac"
let kValue   = "value"

//MARK:- Encription-decription
let APP_ENC_KEY        = "pjgCAj2ciOmyqdjFN8MLWW1Daol7esKV"
let APP_ENCRYPT_VI_KEY = "XaBBQIAxp9IDJotZ"
let APP_DEC_KEY        = "U08u7RV36IInEH3n5vgHFk12qksVreuC"
let APP_DECRYPT_VI_KEY = "ORrsjvgMGIsjvgU0"


let DEFAULT_TIMEOUT:TimeInterval = 60.0
let Fetch_Data_Limit:NSInteger = 50

let URL_Image = "https://spoyer.com/api/icons/countries/"
let URL_Domain =  "https://spoyer.com/api/en/get.php?login=ayna&token=12784-OhJLY5mb3BSOx0O&sport=soccer&"

let API_LiveData = URL_Domain+"task=livedata"
