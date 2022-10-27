//
//  KeyNamesConstants.swift
//  ELFramework
//
//  Created by Admin on 14/12/17.
//  Copyright © 2017 EL. All rights reserved.
//

import Foundation
import UIKit

let APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate
let nc = NotificationCenter.default


//MARK:- Google Client ID
public let kGoogleMapAPIKey = ""
public let kGoogleClientID = ""
public let kAppLink = ""

//MARK:- APP NAME
public let APPNAME :String = "YoungSportEvent"
public let VIDEO_LENGTH = 90

//MARK:- STORY BOARD NAMES
public let SB_MAIN :String = "Main"

//MARK:- VIEW CONTROLLER ID
public let idViewController = "ViewController"
public let idTopTeamsPlayersVC = "TopTeamsPlayersVC"
public let idWorldRatingsVC = "WorldRatingsVC"
public let idMyTopVC = "MyTopVC"
public let idMyTopSelectionVC = "MyTopSelectionVC"

//MARK:- USER DEFAULTS KEY
let UD_Favourite         = "UDFavourite"
let UD_DeletedMatches    = "UD_DeletedMatches"

//MARK:- FONT NAMES
let FT_Regular = "Inter-Regular"
let FT_Medium = "Inter-Medium"
let FT_SemiBold = "Inter-SemiBold"
let FT_Bold = "Inter-Bold"
let FT_Black = "Inter-Black"

//MARK:- COLOR NAMES
let themeBrownColor = Color_Hex(hex: "#CF6D15")

//MARK:- MESSAGES
let ServerResponseError = "Server Response Error"
let RetryMessage = "Something went wrong please try again..."
let InternetNotAvailable = "Internet connection appears to be offline."
let EnterMobile = "Please enter mobile number"
let EnterValidMobile = "Please enter valid mobile number"
let EnterVerification = "Please enter verification code"
let EnterFullname = "Please enter full name"
let EnterEmail = "Please enter email"
let ValidateEmail = "Please enter valid email"
let EnterPincode = "Please enter zip code"
let EnterAddress = "Please enter address"
let EnterBirthdate = "Please select date of birth"
let OtpNotMatch = "Your OTP does not match"
let EnterOTP = "Please enter OTP"
let msgLocationService = "Location services are disabled, Please enable from Settings"


//MARK:- Static URLs
let UrlTNC = "https://easysave-app.com/terms-of-use"
let UrlPrivacyPolicy = "https://easysave-app.com/privacy-policy"

//MARK:- Devices
let IS_IPHONE = UIDevice.current.userInterfaceIdiom == .phone
let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad

let is_iPhone678 = (isPhone && UIScreen.main.bounds.size.height == 667.0)
let is_iPhone678Plus = (isPhone && UIScreen.main.bounds.size.height == 736.0)
let is_iPhoneX = (isPhone && UIScreen.main.bounds.size.height == 812.0)
let is_iPhoneXRXmax = (isPhone && UIScreen.main.bounds.size.height == 896.0)
