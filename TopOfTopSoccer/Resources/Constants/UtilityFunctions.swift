//
//  constant.swift

import Foundation
import UIKit
import CoreLocation
import SystemConfiguration
import AVFoundation
import SwiftMessages
import IQKeyboardManagerSwift
import SDWebImage

struct DIRECTORY_NAME
{
    public static let IMAGES = "Images"
    public static let VIDEOS = "Videos"
    public static let DOWNLOAD_VIDEOS = "Download_videos"
}

public let isSimulator: Bool = {
    var isSim = false
    #if arch(i386) || arch(x86_64)
        isSim = true
    #endif
    return isSim
}()

var myDeviceToken: String = "testDeviceToken"
var myDeviceType: String =  "0" //0=iOS, 1=Android
var appEnvironment: String = "local" //production=Enc/Dec, local=without enc/dec
var currentCountry = ""

var CurrentAddress = ""
var DataLimitPerPage: Int = 10
var LEFT_PADDING: CGFloat = 15.0 //10.0
var MIN_PASSWRD_LENGTH = 6

//MARK:- iOS Versions and screens

public var appDisplayName: String? {
    return Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
}
public var appBundleID: String? {
    return Bundle.main.bundleIdentifier
}
public func IOS_VERSION() -> String {
    return UIDevice.current.systemVersion
}

public var applicationIconBadgeNumber: Int {
    get {
        return UIApplication.shared.applicationIconBadgeNumber
    }
    set {
        UIApplication.shared.applicationIconBadgeNumber = newValue
    }
}
public var appVersion: String? {
    return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
}
public func SCREENWIDTH() -> CGFloat
{
    let screenSize = UIScreen.main.bounds
    return screenSize.width
}

public func SCREENHEIGHT() -> CGFloat
{
    let screenSize = UIScreen.main.bounds
    return screenSize.height
}
//MARK:-  Get VC
public func getStoryboard(storyboardName: String) -> UIStoryboard {
    return UIStoryboard(name: storyboardName, bundle: nil)
}

public func loadVC(strStoryboardId: String, strVCId: String) -> UIViewController {
    
    let vc = getStoryboard(storyboardName: strStoryboardId).instantiateViewController(withIdentifier: strVCId)
    return vc
}

public func hideBanner() {
     SwiftMessages.hide()
}

//Loader
public func showLoaderHUD() {
    LoadingHUD.showHUD()
}

public func showError(_ message:String) {
    showErrorMessage(message)
}

public func hideLoaderHUD() {
    LoadingHUD.dismissHUD()
}

//MARK:- Number
public func suffixNumber(number:NSNumber) -> NSString  {
    
    /*var num:Double = number.doubleValue;
     let sign = ((num < 0) ? "-" : "" );
     
     num = fabs(num);
     if (num < 1000.0){
     return "\(sign)\(num)" as NSString;
     }
     let exp:Int = Int(log10(num) / 3.0 ); //log10(1000));
     let units:[String] = ["K","M","G","T","P","E"];
     let roundedNum:Double = round(10 * num / pow(1000.0,Double(exp))) / 10;
     return "\(sign)\(roundedNum)\(units[exp-1])" as NSString;*/
    
    let number = number.doubleValue
    let thousand = number / 1000
    let million = number / 1000000
    if million >= 1.0 {
        return "\(round(million*10)/10)M" as NSString
    }
    else if thousand >= 1.0 {
        return "\(round(thousand*10)/10)K" as NSString
    }
    else {
        return "\(Int(number))" as NSString
    }
}

//MARK:- Validation
public func TRIM(string: Any) -> String
{
    return (string as AnyObject).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
}

public func validateTxtLength(_ txtVal: String, withMessage msg: String) -> Bool {
    if TRIM(string: txtVal).count == 0
    {
        showMessage(msg)
        return false
    }
    return true
}

public func validateTxtFieldLength(_ txtVal: UITextField, withMessage msg: String) -> Bool
{
    if TRIM(string: txtVal.text ?? "").count == 0
    {
        txtVal.shake()
        showMessage(msg)
        return false
    }
    return true
}

public func validateTxtViewLength(_ txtVal: UITextView, withMessage msg: String) -> Bool
{
    if TRIM(string: txtVal.text ?? "").count == 0
    {
        txtVal.shake()
        showMessage(msg)
        return false
    }
    return true
}


public func validateMinTxtFieldLength(_ txtVal: UITextField, lenght:Int, msg: String) -> Bool
{
    if TRIM(string: txtVal.text ?? "").count < lenght
    {
        txtVal.shake()
        showMessage(msg)
        return false
    }
    return true
}

public func validateMaxTxtFieldLength(_ txtVal: UITextField, lenght:Int,msg: String) -> Bool
{
    if TRIM(string: txtVal.text ?? "").count > lenght
    {
        txtVal.shake()
        showMessage(msg)
        return false
    }
    return true
}

public func validateEqualTxtFieldLength(_ txtVal: UITextField, lenght:Int,msg: String) -> Bool
{
    if TRIM(string: txtVal.text ?? "").count != lenght
    {
        txtVal.shake()
        showMessage(msg)
        return false
    }
    return true
}

public func passwordMismatch(_ txtVal: UITextField, _ txtVal1: UITextField, withMessage msg: String) -> Bool
{
    if TRIM(string: txtVal.text ?? "") != TRIM(string: txtVal1.text ?? "")
    {
        txtVal.shake()
        showMessage(msg)
        return false
    }
    return true
}

public func validateAmount(_ txtVal: UITextField, withMessage msg: String) -> Bool {
    var amount : Double = 0
    if let txt = txtVal.text?.trimmed,txt.count > 0 {
        amount = Double(txt.replacedArabicDigitsWithEnglish) ?? 0
    }
    if amount <= 0 {
        txtVal.text = TRIM(string: txtVal.text ?? "")
        txtVal.shake()
        showMessage(msg)
        return false
    }
    return true
}

public func validateEmailAddress(_ txtVal: UITextField, withMessage msg: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    if(emailTest.evaluate(with: txtVal.text) != true)
    {
        txtVal.shake()
        showMessage(msg)
        return false
    }
    return true
}

public func validatePhoneNumber(_ txtVal: UITextField, withMessage msg: String) -> Bool {
    let phoneRegEx = "^[075,077,078,079]{3}\\d{8}$"
    let phoneTest = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
    if(phoneTest.evaluate(with: txtVal.text) != true) {
        txtVal.shake()
        showMessage(msg)
        return false
    }
    return true
}

public func validatePassword(_ txtVal: UITextField ,withMessage msg: String) -> Bool {
    let testStr = txtVal.text ?? ""
    let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$&*]).{8,}")
    if(passwordTest.evaluate(with: testStr) != true) {
        txtVal.shake()
        showMessage(msg)
        return false
    }
    return true
}

public func validateYoutubeUrl(_ txtVal: String) -> Bool {
    if txtVal.contains("youtube") || txtVal.contains("youtu.be") {
        return true
    }
    return false
}

public func isBase64(stringBase64:String) -> Bool
{
    let regex = "([A-Za-z0-9+/]{4})*" + "([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)"
    let test = NSPredicate(format:"SELF MATCHES %@", regex)
    if(test.evaluate(with: stringBase64) != true)
    {
        return false
    }
    return true
}

/*public func isValidURL(stringURL:String) -> Bool {
    let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
    if let match = detector.firstMatch(in: stringURL, options: [], range: NSRange(location: 0, length: self.endIndex.encodedOffset)) {
        // it is a link, if the match covers the whole string
        return match.range.length == stringURL.endIndex.encodedOffset
    }
    return false
}*/

//MARK:- Check Internet connection
func isConnectedToNetwork() -> Bool
{
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    })
        else
    {
        return false
    }
    
    var flags : SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
        return false
    }
    
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    let available =  (isReachable && !needsConnection)
    if(available)
    {
        return true
    }
    else
    {
        showMessage(InternetNotAvailable)
        return false
    }
}

//MARK:- Helper
public func TableEmptyMessage(modulename:String, tbl:UITableView)
{
    let uiview = UIView(frame: Frame_XYWH(0, 0, tbl.frame.size.width, tbl.frame.size.height))
    let messageLabel = UILabel(frame: Frame_XYWH(0, 0, tbl.frame.size.width, 50))
    messageLabel.font = UIFont.init(name: FT_Regular, size: 15)
    messageLabel.text = "\("No " + modulename + " Available.")"
    messageLabel.textColor = UIColor.lightGray
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = .center;
    if(modulename.count > 0)
    {
        messageLabel.setViewBottomBorder(borderColor: UIColor.lightGray)
    }
    uiview.addSubview(messageLabel)
    tbl.backgroundView = uiview;
    //tbl.separatorStyle = .singleLine;
}
func checkSearchBarActive(searchFriends:UISearchBar) -> Bool
{
    if searchFriends.isFirstResponder && searchFriends.text != "" {
        return true
    }
    else if(searchFriends.text != "")
    {
        return true
    }
    else {
        return false
    }
}
//MARK:-  Check Device is iPad or not

public  var isPad: Bool {
    return UIDevice.current.userInterfaceIdiom == .pad
}

public var isPhone: Bool {
    return UIDevice.current.userInterfaceIdiom == .phone
}


public var mostTopViewController: UIViewController? {
    get {
        return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
    }
    set {
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController = newValue
    }
}

//MARK:- Random str
func randomString(length: Int) -> String
{
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let len = UInt32(letters.length)
    var randomString = ""
    for _ in 0 ..< length {
        let rand = arc4random_uniform(len)
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
    }
    return randomString
}

func randomString() -> String
{
    var text = ""
    text = text.appending(CurrentTimeStamp)
    text = text.replacingOccurrences(of: ".", with: "")
    return text
}
//MARK:- Font
public func FontWithSize(_ fname: String,_ fsize: Int) -> UIFont
{
    return UIFont(name: fname, size: CGFloat(fsize))!
}

//MARK:- Color
public func Color_RGBA(_ R: Int,_ G: Int,_ B: Int,_ A: Int) -> UIColor
{
    return UIColor(red: CGFloat(R)/255.0, green: CGFloat(G)/255.0, blue: CGFloat(B)/255.0, alpha :CGFloat(A))
}
public func RGBA(_ R: Int,_ G: Int,_ B: Int,_ A: CGFloat) -> UIColor
{
    return UIColor(red: CGFloat(R)/255.0, green: CGFloat(G)/255.0, blue: CGFloat(B)/255.0, alpha :A)
}
public func Color_Hex(hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

public func Color_Hex_Alpha(hex:String, withAlpha: CGFloat) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: withAlpha
    )
}

public func createGradientLayer(view:UIView,colorset:[UIColor],framerect:CGRect)
{
    let layer = CAGradientLayer()
    layer.frame = framerect
    layer.colors = colorset
    view.layer.addSublayer(layer)
}

public func hideMessage() {
     SwiftMessages.hide()
}

public func showMessageInAlert(_ bodymsg:String, myVC: UIViewController)
{
    let alert = UIAlertController(title: nil, message: bodymsg, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
    alert.addAction(okAction)
     alert.view.tintColor = themeBrownColor
    myVC.present(alert, animated: true, completion: nil)
}

public func showMessageWithRetry(_ bodymsg:String ,_ msgtype:Int,buttonTapHandler: ((_ button: UIButton) -> Void)?) {
    hideMessage()
    let view = MessageView.viewFromNib(layout: .cardView)
    view.configureContent(title: "", body: bodymsg, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "Retry", buttonTapHandler: buttonTapHandler)
    view.configureDropShadow()
    view.configureContent(body: bodymsg)
    view.layoutMarginAdditions = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    view.configureTheme(backgroundColor: themeBrownColor, foregroundColor: .white, iconImage: nil, iconText: "")
    view.bodyLabel?.font = FontWithSize(FT_Bold, 16)
    view.titleLabel?.isHidden = true
    view.button?.isHidden = false
    view.iconLabel?.isHidden = true
    SwiftMessages.defaultConfig.preferredStatusBarStyle = .lightContent
    SwiftMessages.show(view: view)
}

public func showInfoMessage(_ bodymsg:String) {
    let view = MessageView.viewFromNib(layout: .cardView)
    view.configureDropShadow()
    view.configureContent(body: bodymsg)
    view.layoutMarginAdditions = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    view.configureTheme(backgroundColor: themeBrownColor, foregroundColor: .white, iconImage: UIImage.init(named: "ic_info"), iconText: "")
    view.bodyLabel?.font = FontWithSize(FT_Bold, 16)
    view.titleLabel?.isHidden = true
    view.button?.isHidden = true
    view.iconLabel?.isHidden = true
    SwiftMessages.defaultConfig.preferredStatusBarStyle = .lightContent
    SwiftMessages.show(view: view)
}

public func showMessage(_ bodymsg:String) {
    let view = MessageView.viewFromNib(layout: .cardView)
    view.configureDropShadow()
    view.configureContent(body: bodymsg)
    view.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    view.configureTheme(backgroundColor: themeBrownColor, foregroundColor: .white, iconImage: UIImage.init(named: "warningIcon"), iconText: "")
    view.bodyLabel?.font = FontWithSize(FT_Bold, 16)
    view.titleLabel?.isHidden = true
    view.button?.isHidden = true
    view.iconLabel?.isHidden = true
    SwiftMessages.defaultConfig.preferredStatusBarStyle = .lightContent
    SwiftMessages.show(view: view)
}

public func showMessageSuccess(_ bodymsg:String) {
    let view = MessageView.viewFromNib(layout: .cardView)
    view.configureContent(title: "", body: bodymsg, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "Hide", buttonTapHandler: { _ in SwiftMessages.hide() })
    view.configureDropShadow()
    var config = SwiftMessages.defaultConfig
    config.duration = .seconds(seconds: 3)
    view.configureTheme(backgroundColor: UIColor.green, foregroundColor: .white, iconImage: UIImage.init(named: ""), iconText: "")
    view.configureTheme(.success, iconStyle: .default)
    view.titleLabel?.isHidden = true
    view.button?.isHidden = true
    view.iconImageView?.isHidden = false
    view.iconLabel?.isHidden = true
    view.bodyLabel?.textColor = .white
    view.bodyLabel?.font = FontWithSize(FT_Bold, 16)
    SwiftMessages.show(config: config, view: view)
}


public func showErrorMessage(_ bodymsg:String) {
    let view = MessageView.viewFromNib(layout: .cardView)
    view.configureDropShadow()
    view.configureContent(body: bodymsg)
    view.layoutMarginAdditions = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    view.configureTheme(backgroundColor: themeBrownColor, foregroundColor: .white, iconImage: UIImage.init(named: "warningIcon"), iconText: "")
    view.bodyLabel?.font = FontWithSize(FT_Bold, 16)
    view.titleLabel?.isHidden = true
    view.button?.isHidden = true
    view.iconLabel?.isHidden = true
    SwiftMessages.defaultConfig.preferredStatusBarStyle = .lightContent
    SwiftMessages.show(view: view)
}

/* func showNotificationMessage(strFriendName:String,strMessage:String,img:UIImage,date:String) {
    var attributes: EKAttributes
    attributes = .topFloat
    attributes.displayMode = .inferred
    attributes.roundCorners = .all(radius: 10)
    attributes.entryBackground = .gradient(
        gradient: .init(
            colors: [EKColor(red: 255, green: 203, blue: 49), EKColor(red: 251, green: 225, blue: 148)],
            startPoint: .zero,
            endPoint: CGPoint(x: 1, y: 1)
        )
    )
    attributes.popBehavior = .animated(
        animation: .init(
            translate: .init(duration: 3.0),
            scale: .init(from: 1, to: 0.7, duration: 0.7)
        )
    )
    attributes.shadow = .active(
        with: .init(
            color: .black,
            opacity: 0.5,
            radius: 10
        )
    )
    attributes.statusBar = .dark
    attributes.scroll = .enabled(
        swipeable: true,
        pullbackAnimation: .easeOut
    )
    
    let title = EKProperty.LabelContent(
        text: strFriendName,
        style: .init(
            font: UIFont(name: FT_Regular, size: 16)!,
            color: .black
        )
    )
    let description = EKProperty.LabelContent(
        text: strMessage,
        style: .init(
            font: UIFont(name: FT_Regular, size: 14)!,
            color: .black
        )
    )
    let time = EKProperty.LabelContent(
        text: date,
        style: .init(
            font: UIFont(name: FT_Regular, size: 12)!,
            color: .black
        )
    )
    var image: EKProperty.ImageContent?
    image = EKProperty.ImageContent(
        //image: UIImage(named: "chatLogo")!.withRenderingMode(.alwaysOriginal),
        image: img.withRenderingMode(.alwaysOriginal),
        size: CGSize(width: 35, height: 35),
        makesRound: true
    )
    let simpleMessage = EKSimpleMessage(
        image: image,
        title: title,
        description: description
    )
    let notificationMessage = EKNotificationMessage(
        simpleMessage: simpleMessage,
        auxiliary: time
    )
    let contentView = EKNotificationMessageView(with: notificationMessage)
    SwiftEntryKit.display(entry: contentView, using: attributes)
}

func customMessagePopup(strFriendName:String,strMessage:String) {
    let attributes = EKAttributes.topToast
    let title = EKProperty.LabelContent(
        text: strFriendName,
        style: .init(
            font: UIFont(name: FT_ExtraBold, size: 16)!,
            color: .white,
            displayMode: .light
        )
    )
    let description = EKProperty.LabelContent(
        text: strMessage,
        style: .init(
            font: UIFont(name: FT_ExtraBold, size: 14)!,
            color: .white,
            displayMode: .light
        )
    )
    let image = EKProperty.ImageContent.thumb(
        with: "chatLogo",
        edgeSize: 35
    )
    let simpleMessage = EKSimpleMessage(
        image: image,
        title: title,
        description: description
    )
    let notificationMessage = EKNotificationMessage(
        simpleMessage: simpleMessage
    )
    let contentView = EKNotificationMessageView(with: notificationMessage)
    contentView.backgroundColor = UIColor.darkGray
    SwiftEntryKit.display(entry: contentView, using: attributes)
} */

//MARK:- Frames
public func Frame_XYWH(_ originx: CGFloat,_ originy: CGFloat,_ fwidth: CGFloat,_ fheight: CGFloat) -> CGRect
{
    return CGRect(x: originx, y:originy, width: fwidth, height: fheight)
}

public func randomColor() -> UIColor
{
    let r: UInt32 = arc4random_uniform(255)
    let g: UInt32 = arc4random_uniform(255)
    let b: UInt32 = arc4random_uniform(255)
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
}

//MARK:- Platform
struct Platform
{
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}

//MARK:- Time Processing
fileprivate var GlobalFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = GLOBAL_APP_DATE_FORMAT
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    return formatter
}()
    
fileprivate var chatDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeZone = NSTimeZone.system
    formatter.dateFormat = "MMM dd yyyy HH:mm"
    return formatter
}()

fileprivate var chatTimeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeZone = NSTimeZone.system
    formatter.dateFormat = "h:mm a"
    return formatter
}()

func setChatDate(str:String) -> String {
    if let dt = GlobalFormatter.date(from: str) {
        return chatDateFormatter.string(from: dt)
    }
    return ""
}

func setChatTime(str:String) -> String {
    if let dt = GlobalFormatter.date(from: str) {
        return chatDateFormatter.string(from: dt)
    }
    return ""
}

func covertTimeToLocalZone(time:String) -> NSDate
{
    let dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
    let inputTimeZone = NSTimeZone(abbreviation: "UTC")
    let inputDateFormatter = DateFormatter()
    inputDateFormatter.timeZone = inputTimeZone as TimeZone?
    inputDateFormatter.dateFormat = dateFormat
    let date = inputDateFormatter.date(from: time)
    let outputTimeZone = NSTimeZone.local
    let outputDateFormatter = DateFormatter()
    outputDateFormatter.timeZone = outputTimeZone
    outputDateFormatter.dateFormat = dateFormat
    let outputString = outputDateFormatter.string(from: date!)
    return outputDateFormatter.date(from: outputString)! as NSDate
}

func chatHeaderTime(strDate:String)-> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
    
    if let APIDt = dateFormatter.date(from: strDate){
        dateFormatter.timeZone =  NSTimeZone.system
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: APIDt)
    }
    return strDate
}

func notyHeaderTime(strDate:String)-> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
    
    if let APIDt = dateFormatter.date(from: strDate){
        dateFormatter.timeZone =  NSTimeZone.system
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: APIDt)
    }
    return strDate
}

public var CurrentTimeStamp: String
{
    return "\(NSDate().timeIntervalSince1970 * 1000)"
}

//MARK:- Time Ago Function

func timeAgoSinceStrDate(strDate:String, numericDates:Bool) -> String{
    
    /*let formato = DateFormatter()
     formato.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
     formato.timeZone = NSTimeZone(name: "UTC")! as TimeZone
     formato.formatterBehavior = .default
     let date = formato.date(from: strDate)!*/
    
    let date = convertDateAccordingDeviceTime(dategiven: strDate)
    
    //PV
    return timeAgoSinceDateNew(date: date as Date, numericDates: numericDates)
//    return timeAgoSinceDate1(date: date as Date, numericDates: numericDates)

    //return DateFormater.generateTimeForGivenDate(strDate: date)
}

func timeAgoSinceDate1(date:Date, numericDates:Bool) -> String
{
    let calendar = NSCalendar.current
    let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
    let now = NSDate()
    let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now as Date, options: [])
    
    if (components.day! > 7) {
        return DateFormater.getFullDateStringFromDate_FullFormat(givenDate: date as NSDate)
        //"\(components.day!)" + " days"
    } else if (components.day! >= 2) {
        return "\(components.day!)" + " days ago"
        
    } else if (components.day! >= 1) {
        if (numericDates){
            return "1 day ago"
        } else {
            return "Yesterday"
        }
    }
    else if (components.hour! >= 2) {
        return "\(components.hour!)" + " hours ago"
    }
    else if (components.hour! >= 1) {
        if (numericDates){
            return "1 hour ago"
        } else {
            return "An hour ago"
        }
    }
    else if (components.minute! >= 2)
    {
        return "\(components.minute!)" + " mins ago"
    } else if (components.minute! > 1){
        if (numericDates){
            return "1 min ago"
        } else {
            return "A min ago"
        }
    }
    else if (components.second! >= 3) {
        return "\(components.second!)" + " secs ago"
    } else {
        return "Just now"
    }
}

func timeAgoSinceDateNew(date:Date, numericDates:Bool) -> String
{
    let calendar = NSCalendar.current
    let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
    let now = NSDate()
    let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now as Date, options: [])
    if (components.year! >= 2)
    {
        return "\(components.year!)" + " years ago"
    }
    else if (components.year! >= 1)
    {
        if (numericDates){
            return "1 year ago"
        } else {
            return "Last year"
        }
    }
    else if (components.month! >= 2) {
        return "\(components.month!)" + " months ago"
    }
    else if (components.month! >= 1){
        if (numericDates){
            return "1 month ago"
        } else {
            return "Last month"
        }
    }
    else if (components.weekOfYear! >= 2) {
        return "\(components.weekOfYear!)" + " weeks ago"
    }
    else if (components.weekOfYear! >= 1){
        if (numericDates){
            return "1 week ago"
        } else {
            return "Last week"
        }
    }
    else if (components.day! >= 2) {
        return "\(components.day!)" + " days ago"
    }
    else if (components.day! >= 1){
        if (numericDates){
            return "1 day ago"
        } else {
            return "Yesterday"
        }
    }
    else if (components.hour! >= 2) {
        return "\(components.hour!)" + " hours ago"
    }
    else if (components.hour! >= 1){
        if (numericDates){
            return "1 hour ago"
        } else {
            return "An hour ago"
        }
    }
    else if (components.minute! >= 2)
    {
        return "\(components.minute!)" + " mins ago"
    } else if (components.minute! > 1){
        if (numericDates){
            return "1 min ago"
        } else {
            return "A minute ago"
        }
    }
    else if (components.second! >= 3) {
        return "\(components.second!)" + " secs ago"
    } else {
        return "Just now"
    }
}

func timeAgoSinceDate(date:Date, numericDates:Bool) -> String
{
    let calendar = NSCalendar.current
    let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
    let now = NSDate()
    let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now as Date, options: [])
    if (components.year! >= 2)
    {
        return "\(components.year!)" + " years"
    }
    else if (components.year! >= 1)
    {
        if (numericDates){
            return "1 year"
        } else {
            return "Last year"
        }
    }
    else if (components.month! >= 2) {
        return "\(components.month!)" + " months"
    }
    else if (components.month! >= 1){
        if (numericDates){
            return "1 month"
        } else {
            return "Last month"
        }
    }
    else if (components.weekOfYear! >= 2) {
        return "\(components.weekOfYear!)" + " weeks"
    }
    else if (components.weekOfYear! >= 1){
        if (numericDates){
            return "1 week"
        } else {
            return "Last week"
        }
    }
    else if (components.day! >= 2) {
        return "\(components.day!)" + " days"
    }
    else if (components.day! >= 1){
        if (numericDates){
            return "1 day"
        } else {
            return "Yesterday"
        }
    }
    else if (components.hour! >= 2) {
        return "\(components.hour!)" + " hours"
    }
    else if (components.hour! >= 1){
        if (numericDates){
            return "1 hour"
        } else {
            return "An hour"
        }
    }
    else if (components.minute! >= 2)
    {
        return "\(components.minute!)" + " mins"
    } else if (components.minute! > 1){
        if (numericDates){
            return "1 min"
        } else {
            return "A min"
        }
    }
    else if (components.second! >= 3) {
        return "\(components.second!)" + " sec"
    } else {
        return "Just now"
    }
}

func convertDateAccordingDeviceTime(dategiven:String) -> NSDate
{
    if dategiven.contains("null") == false
    {
        var strDate = dategiven.replacingOccurrences(of: " ", with: "T")
        if strDate.components(separatedBy: ".").count < 2{
            strDate = "\(strDate).000Z"
        }
        
        let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        /*if dategiven.contains("'") == false{
         dateFormat = "yyyy-MM-ddTHH:mm:ss.SSSZ"
         }*/
        let inputTimeZone = NSTimeZone(abbreviation: "UTC")
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.timeZone = inputTimeZone as TimeZone?
        inputDateFormatter.dateFormat = dateFormat
        let date = inputDateFormatter.date(from: strDate)
        let outputTimeZone = NSTimeZone.local
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.timeZone = outputTimeZone
        outputDateFormatter.dateFormat = dateFormat
        
        let outputString = outputDateFormatter.string(from: date!)
        
        return outputDateFormatter.date(from: outputString)! as NSDate
    }
    else
    {
        return Date() as NSDate
    }
}

func convertDateAccordingDeviceTimeString(dategiven:String) -> String
{
    let inputDateFormatter = DateFormatter()
    let outputDateFormatter = DateFormatter()
    
    let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
    let inputTimeZone = NSTimeZone(abbreviation: "UTC")
    
    inputDateFormatter.timeZone = inputTimeZone as TimeZone?
    inputDateFormatter.dateFormat = dateFormat
    let date = inputDateFormatter.date(from: dategiven)
    let outputTimeZone = NSTimeZone.local
    
    outputDateFormatter.timeZone = outputTimeZone
    outputDateFormatter.dateFormat = dateFormat
    let outputString = outputDateFormatter.string(from: date!)
    return outputString
}

//MARK:- Animation
func addActivityIndicatior(activityview:UIActivityIndicatorView,button:UIButton)
{
    activityview.isHidden = false
    activityview.startAnimating()
     button.isEnabled = false
    button.backgroundColor = RGBA(181, 131, 0, 0.4)
}
func hideActivityIndicatior(activityview:UIActivityIndicatorView,button:UIButton)
{
    activityview.isHidden = true
    activityview.stopAnimating()
    button.isEnabled = true
    button.backgroundColor = RGBA(181, 131, 0, 1.0)
}


//MARK:- Country code
func setDefaultCountryCode(strCountryName: String) -> String
{
//    let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String
    return getCountryPhonceCode(strCountryName)
}

//MARK:- Image/Video Processing
public func Set_Local_Image(imageName :String) -> UIImage
{
    return UIImage(named:imageName)!
}
func getVideoThumbnail(videoURL:URL,withSeconds:Bool = false) -> UIImage?
{
    let timeSeconds = 2
    let asset = AVAsset(url: videoURL)
    let imageGenerator = AVAssetImageGenerator(asset: asset)
    imageGenerator.appliesPreferredTrackTransform = true
    
    var time = asset.duration
    
    if(withSeconds) {
        time.value = min(time.value, CMTimeValue(timeSeconds))
    }
    else {
        time = CMTimeMultiplyByFloat64(time, multiplier: 0.5)
    }
    
    do {
        //let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
        let imageRef = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
        return UIImage(cgImage: imageRef)
    }
    catch _ as NSError {
        return nil
    }
}

func fixOrientationOfImage(image: UIImage) -> UIImage?
{
    if image.imageOrientation == .up
    {return image}
    var transform = CGAffineTransform.identity
    switch image.imageOrientation
    {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: image.size.width, y: image.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0)
            transform = transform.rotated(by:  CGFloat(Double.pi / 2))
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: image.size.height)
            transform = transform.rotated(by:  -CGFloat(Double.pi / 2))
        default:
            break
    }
    switch image.imageOrientation
    {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: image.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
    }
    guard let context = CGContext(data: nil, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: image.cgImage!.bitsPerComponent, bytesPerRow: 0, space: image.cgImage!.colorSpace!, bitmapInfo: image.cgImage!.bitmapInfo.rawValue) else {
        return nil
    }
    context.concatenate(transform)
    switch image.imageOrientation
    {
    case .left, .leftMirrored, .right, .rightMirrored:
        context.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: image.size.height, height: image.size.width))
    default:
        context.draw(image.cgImage!, in: CGRect(origin: .zero, size: image.size))
    }
    guard let CGImage = context.makeImage() else {
        return nil
    }
    return UIImage(cgImage: CGImage)
}

func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ session: AVAssetExportSession)-> Void)
{
    let urlAsset = AVURLAsset(url: inputURL, options: nil)
    let exportSession = AVAssetExportSession(asset: urlAsset, presetName:AVAssetExportPreset640x480)//AVAssetExportPresetMediumQuality
    exportSession!.outputURL = outputURL
    exportSession!.outputFileType = AVFileType.mp4
    exportSession!.shouldOptimizeForNetworkUse = true
    exportSession!.exportAsynchronously { () -> Void in
        handler(exportSession!)
    }
}

func getCountryPhonceCode (_ country : String) -> String
{
    let countryDictionary  = ["AF":"93",
                              "AL":"355",
                              "DZ":"213",
                              "AS":"1",
                              "AD":"376",
                              "AO":"244",
                              "AI":"1",
                              "AG":"1",
                              "AR":"54",
                              "AM":"374",
                              "AW":"297",
                              "AU":"61",
                              "AT":"43",
                              "AZ":"994",
                              "BS":"1",
                              "BH":"973",
                              "BD":"880",
                              "BB":"1",
                              "BY":"375",
                              "BE":"32",
                              "BZ":"501",
                              "BJ":"229",
                              "BM":"1",
                              "BT":"975",
                              "BA":"387",
                              "BW":"267",
                              "BR":"55",
                              "IO":"246",
                              "BG":"359",
                              "BF":"226",
                              "BI":"257",
                              "KH":"855",
                              "CM":"237",
                              "CA":"1",
                              "CV":"238",
                              "KY":"345",
                              "CF":"236",
                              "TD":"235",
                              "CL":"56",
                              "CN":"86",
                              "CX":"61",
                              "CO":"57",
                              "KM":"269",
                              "CG":"242",
                              "CK":"682",
                              "CR":"506",
                              "HR":"385",
                              "CU":"53",
                              "CY":"537",
                              "CZ":"420",
                              "DK":"45",
                              "DJ":"253",
                              "DM":"1",
                              "DO":"1",
                              "EC":"593",
                              "EG":"20",
                              "SV":"503",
                              "GQ":"240",
                              "ER":"291",
                              "EE":"372",
                              "ET":"251",
                              "FO":"298",
                              "FJ":"679",
                              "FI":"358",
                              "FR":"33",
                              "GF":"594",
                              "PF":"689",
                              "GA":"241",
                              "GM":"220",
                              "GE":"995",
                              "DE":"49",
                              "GH":"233",
                              "GI":"350",
                              "GR":"30",
                              "GL":"299",
                              "GD":"1",
                              "GP":"590",
                              "GU":"1",
                              "GT":"502",
                              "GN":"224",
                              "GW":"245",
                              "GY":"595",
                              "HT":"509",
                              "HN":"504",
                              "HU":"36",
                              "IS":"354",
                              "IN":"91",
                              "ID":"62",
                              "IQ":"964",
                              "IE":"353",
                              "IL":"972",
                              "IT":"39",
                              "JM":"1",
                              "JP":"81",
                              "JO":"962",
                              "KZ":"77",
                              "KE":"254",
                              "KI":"686",
                              "KW":"965",
                              "KG":"996",
                              "LV":"371",
                              "LB":"961",
                              "LS":"266",
                              "LR":"231",
                              "LI":"423",
                              "LT":"370",
                              "LU":"352",
                              "MG":"261",
                              "MW":"265",
                              "MY":"60",
                              "MV":"960",
                              "ML":"223",
                              "MT":"356",
                              "MH":"692",
                              "MQ":"596",
                              "MR":"222",
                              "MU":"230",
                              "YT":"262",
                              "MX":"52",
                              "MC":"377",
                              "MN":"976",
                              "ME":"382",
                              "MS":"1",
                              "MA":"212",
                              "MM":"95",
                              "NA":"264",
                              "NR":"674",
                              "NP":"977",
                              "NL":"31",
                              "AN":"599",
                              "NC":"687",
                              "NZ":"64",
                              "NI":"505",
                              "NE":"227",
                              "NG":"234",
                              "NU":"683",
                              "NF":"672",
                              "MP":"1",
                              "NO":"47",
                              "OM":"968",
                              "PK":"92",
                              "PW":"680",
                              "PA":"507",
                              "PG":"675",
                              "PY":"595",
                              "PE":"51",
                              "PH":"63",
                              "PL":"48",
                              "PT":"351",
                              "PR":"1",
                              "QA":"974",
                              "RO":"40",
                              "RW":"250",
                              "WS":"685",
                              "SM":"378",
                              "SA":"966",
                              "SN":"221",
                              "RS":"381",
                              "SC":"248",
                              "SL":"232",
                              "SG":"65",
                              "SK":"421",
                              "SI":"386",
                              "SB":"677",
                              "ZA":"27",
                              "GS":"500",
                              "ES":"34",
                              "LK":"94",
                              "SD":"249",
                              "SR":"597",
                              "SZ":"268",
                              "SE":"46",
                              "CH":"41",
                              "TJ":"992",
                              "TH":"66",
                              "TG":"228",
                              "TK":"690",
                              "TO":"676",
                              "TT":"1",
                              "TN":"216",
                              "TR":"90",
                              "TM":"993",
                              "TC":"1",
                              "TV":"688",
                              "UG":"256",
                              "UA":"380",
                              "AE":"971",
                              "GB":"44",
                              "US":"1",
                              "UY":"598",
                              "UZ":"998",
                              "VU":"678",
                              "WF":"681",
                              "YE":"967",
                              "ZM":"260",
                              "ZW":"263",
                              "BO":"591",
                              "BN":"673",
                              "CC":"61",
                              "CD":"243",
                              "CI":"225",
                              "FK":"500",
                              "GG":"44",
                              "VA":"379",
                              "HK":"852",
                              "IR":"98",
                              "IM":"44",
                              "JE":"44",
                              "KP":"850",
                              "KR":"82",
                              "LA":"856",
                              "LY":"218",
                              "MO":"853",
                              "MK":"389",
                              "FM":"691",
                              "MD":"373",
                              "MZ":"258",
                              "PS":"970",
                              "PN":"872",
                              "RE":"262",
                              "RU":"7",
                              "BL":"590",
                              "SH":"290",
                              "KN":"1",
                              "LC":"1",
                              "MF":"590",
                              "PM":"508",
                              "VC":"1",
                              "ST":"239",
                              "SO":"252",
                              "SJ":"47",
                              "SY":"963",
                              "TW":"886",
                              "TZ":"255",
                              "TL":"670",
                              "VE":"58",
                              "VN":"84",
                              "VG":"284",
                              "VI":"340"]
    let cname = country.uppercased()
    if countryDictionary[cname] != nil
    {
        return countryDictionary[cname]!
    }
    else
    {
        return cname
    }
}
//MARK:- Check string is available or not
public func isLike(source: String , compare: String) ->Bool
{
    var exists = true
    ((source).lowercased().range(of: compare) != nil) ? (exists = true) :  (exists = false)
    return exists
}

//Mark : string to dictionary
public func convertStringToDictionary(str:String) -> [String: Any]? {
    //let strDecodeMess : String = str.base64Decoded!
    //if let data = strDecodeMess.data(using: .utf8) {
    if let data = str.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}
//Mark : dictionary to string
public func convertDictionaryToJSONString(dic:NSDictionary) -> String? {
    do{
        let jsonData: Data? = try JSONSerialization.data(withJSONObject: dic, options: [])
        var myString: String? = nil
        if let aData = jsonData {
            myString = String(data: aData, encoding: .utf8)
        }
        return myString
    }catch{
    }
    return ""
}

//MARK:- Calculate heght of label
public func calculatedHeight(string :String,withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat
{
    let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
    let boundingBox = string.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    return boundingBox.height
}

public func calculatedWidth(string :String,withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat
{
    let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
    let boundingBox = string.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    return boundingBox.width
}

//MARK:- Mile to Km

public func mileToKilometer(myDistance : Int) -> Float
{
    return Float(myDistance) * 1.60934
}

//MARK:- Kilometer to Mile
public func KilometerToMile(myDistance : Double) -> Double {
    return (myDistance) * 0.621371192
}

public func DegreesToRadians(degrees: Float) -> Float {
    return Float(Double(degrees) * .pi / 180)
}

//MARK:- NULL to NIL
public func NULL_TO_NIL(value : AnyObject?) -> AnyObject? {
    
    if value is NSNull {
        return "" as AnyObject?
    } else {
        return value
    }
}
//MARK:- Log trace
public func DLog<T>(message:T,  file: String = #file, function: String = #function, lineNumber: Int = #line ) {
    #if DEBUG
        if message is String {
            
            //printMsg(val:  "\((file as NSString).lastPathComponent) -> \(function) line: \(lineNumber): \(text)")
        }
    #endif
}

//MARK:- File Manager

func getDocumentsDirectoryURL() -> URL? {
    let fileManager = FileManager.default
    do {
        let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
        return documentDirectory
    }
    catch{
        print(error.localizedDescription)
    }
    return nil
}

func saveFileDataLocally(data:Data, with FileName:String)->Bool{
    let filepath = getDocumentsDirectoryURL()?.appendingPathComponent(FileName)
    do{
        try data.write(to: filepath!, options: .atomic)
        return true
    }catch{
        print(error.localizedDescription)
        return false
    }
}

func getLocallySavedFileData(With FileName:String) -> Data?{
    let filepath = (getDocumentsDirectoryURL()?.appendingPathComponent(FileName))!
    if isFileLocallySaved(fileUrl: filepath){
        return try? Data.init(contentsOf: filepath)
    }else{
        return nil
    }
}

func removeFileFromLocal(_ filename: String) {
    let fileManager = FileManager.default
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let filePath = URL(fileURLWithPath: documentsPath).appendingPathComponent(filename).absoluteString
    
    do{
        try fileManager.removeItem(atPath: filePath)
    }
    catch{
        //printMsg(val:  "Could not delete file -:\(error.localizedDescription) ")
    }
}

func isFileLocallySaved(fileUrl:URL) -> Bool{
    let fileName = fileUrl.lastPathComponent
    let filePath = getDocumentsDirectoryURL()?.appendingPathComponent(fileName)
    let fileManager = FileManager.default
    // Check if file exists
    if fileManager.fileExists(atPath: filePath!.path) {
        return true
    } else {
        return false
    }
}

func getLocallySavedFileURL(with fileUrl:URL) -> URL? {
    if(isFileLocallySaved(fileUrl: fileUrl)){
        let fileName = fileUrl.lastPathComponent
        let filePath = getDocumentsDirectoryURL()?.appendingPathComponent(fileName)
        return filePath
    }
    return nil
}

func timeFormatted(_ totalSeconds: Int) -> String? {
    let seconds: Int = totalSeconds % 60
    let minutes: Int = (totalSeconds / 60) % 60
    let hours: Int = totalSeconds / 3600
    var timeString = ""
    var formatString = ""
    if hours > 0 {
        formatString = hours == 1 ? "%d hour" : "%d hours"
        timeString = timeString + (String(format: formatString, hours))
    }
    if minutes > 0 || hours > 0 {
        formatString = minutes == 1 ? " %d minute" : " %d minutes"
        timeString = timeString + (String(format: formatString, minutes))
    }
    if seconds > 0 || hours > 0 || minutes > 0 {
        formatString = seconds == 1 ? " %d second" : " %d seconds"
        timeString = timeString + (String(format: formatString, seconds))
    }
    
    timeString = "\(hours):\(minutes):\(seconds)"
    timeString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    
    return timeString
}

func postNotification(with Name:String, andUserInfo userInfo:[AnyHashable : Any]? = nil){
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Name), object: nil, userInfo: userInfo)
}

//MARK:-
func isPathForImage(path:String) -> Bool{
    let fileExt = (path.lastPathComponent.components(separatedBy: ".").last!).lowercased()
    
    switch fileExt {
    case "png", "jpg", "jpeg", "gif", "bmp", "tiff", "webp":
        return true
    default:
        return false
    }
}

func isPathForVideo(path:String) -> Bool{
    let fileExt = (path.lastPathComponent.components(separatedBy: ".").last!).lowercased()
    
    switch fileExt {
    case "avi", "flv", "mov", "wmv", "mp4", "m4v", "3gp":
        return true
    default:
        return false
    }
}

func isPathForContact(path:String) -> Bool{
    let fileExt = (path.lastPathComponent.components(separatedBy: ".").last!).lowercased()
    
    switch fileExt {
    case "vcf", "vcard":
        return true
    default:
        return false
    }
}

func isPathForAudio(path:String) -> Bool{
    let fileExt = (path.lastPathComponent.components(separatedBy: ".").last!).lowercased()
    
    switch fileExt {
    case "m4a", "aac", "wav", "mp3":
        return true
    default:
        return false
    }
}





func checkSearchBarActive(searchbar:UISearchBar) -> Bool {
    if searchbar.isFirstResponder && searchbar.text != "" {
        return true
    }
    else if(searchbar.text != "")
    {
        return true
    }
    else {
        return false
    }
}



//Payal mem
func fileSize(url: URL?) -> String {
    
    guard let filePath = url?.path else {
        return "0"
    }
    do {
        let attribute = try FileManager.default.attributesOfItem(atPath: filePath)
        if let size = attribute[FileAttributeKey.size] as? NSNumber
        {
            return "\((size).uint64Value)"
        }
    } catch {
        //printMsg(val:  "Error: \(error)")
    }
    return "0"
}

func fileSizeInMB(_ bts:String) -> String
{
    if (bts == "0") { return "\(0) MB" }
    /*guard let filePath = url?.path else {
        return "\(0) MB"
    }
    do {
        let attribute = try FileManager.default.attributesOfItem(atPath: filePath)
        if let size = attribute[FileAttributeKey.size] as? NSNumber {
            return String(format: "%.2f MB", size.doubleValue / 1000000.0)
        }
    } catch {
        //printMsg(val:  "Error: \(error)")
    }
    return "\(0) MB"*/
    
    //printMsg(val:  "bts: \(bts)")
    //let value = String(format: "%.2f MB", Int(bts).aDoubleOrEmpty() / 1000000.0)
    let bytes : Int64 = Int64(bts)!
    let value = ByteCountFormatter.string(fromByteCount: bytes, countStyle: ByteCountFormatter.CountStyle.binary)
    //printMsg(val:  "value: \(value)")
    return value
}

func fileSizedetail(url: URL?) -> String {
    guard let filePath = url?.path else {
        return "\(0) MB"
    }
    
    do {
        let attribute = try FileManager.default.attributesOfItem(atPath: filePath)
        if let size = attribute[FileAttributeKey.size] as? NSNumber {
            //return String(format: "%.2f MB", size.doubleValue / 1000000.0)
            
            let value = ByteCountFormatter.string(fromByteCount: size.int64Value, countStyle: ByteCountFormatter.CountStyle.binary)
            return value
        }
    } catch {
        //printMsg(val:  "Error: \(error)")
    }
    return "\(0) MB"
}

func getfileCreatedDate(url: URL?) -> String {
    
    guard let filePath = url?.path else {
        return ""
    }
    
    do {
        //let aFileAttributes = try FileManager.default.attributesOfItem(atPath: theFile) as [FileAttributeKey:Any]
        //theCreationDate = aFileAttributes[FileAttributeKey.creationDate] as! Date
        
        let attribute = try FileManager.default.attributesOfItem(atPath: filePath)
        if let date = attribute[FileAttributeKey.creationDate] {
            //printMsg(val:  "date: \(date)")
            
            //return date as! String
            var strDate : String = "\(date)"
            let date = covertTimeToLocalZone(time: strDate)
            //strDate = timeAgoSinceDate(date: date as Date, numericDates: true)
            strDate = DateFormater.generateDateForGivenDateToServerTimeZone(givenDate: date)
            return strDate.count == 0 ? "" : strDate
        }
        
    } catch {
        //printMsg(val:  "file not found \(theError)")
        return ""
    }
    return ""
}

/*
func create_folder(folderName:String, inFolder:URL) -> URL? {
    if (inFolder.absoluteString.count == 0) { return URL(fileURLWithPath: "") }
    
    let fileManager = FileManager.default
    let filePath =  inFolder.appendingPathComponent("\(folderName)")
    if !fileManager.fileExists(atPath: filePath.path) {
        do {
            try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            NSLog("Couldn't create directory")
            return nil
        }
    }
    NSLog("create folder path : \(filePath)")
    return filePath as URL
}

func CreateFolder_inDirectory() {
    let fileManager = FileManager.default
    if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
        let url_WakeUpp : URL = create_folder(folderName: Folder_WakeUpp, inFolder: tDocumentDirectory)!
        UserDefaultManager.setStringToUserDefaults(value: "\(url_WakeUpp)", key: kFolderURL_WakeUpp)
        //printMsg(val:  "url_WakeUpp : \(getURL_WakeUpp_Directory())")
        
        //Group
        runAfterTime(time: 0.10) {
            let url_Group : URL = create_folder(folderName: Folder_Group, inFolder: url_WakeUpp)!
            UserDefaultManager.setStringToUserDefaults(value: "\(url_Group)", key: kFolderURL_Group)
            //printMsg(val:  "url_Group : \(getURL_Group_Directory())")
        }
        
        //Chat
        runAfterTime(time: 0.10) {
            let url_Chat : URL = create_folder(folderName: Folder_Chat, inFolder: url_WakeUpp)!
            UserDefaultManager.setStringToUserDefaults(value: "\(url_Chat)", key: kFolderURL_Chat)
            //printMsg(val:  "url_Chat : \(getURL_Chat_Directory())")
        }
    }
    else {
        showMessage("Something was wrong.")
        //exit(1) //Exit the App OR re-install the app show mess.
    }
}

func getURL_WakeUpp_Directory() -> URL {
    //let dirURL : URL = URL(fileURLWithPath: UserDefaultManager.getStringFromUserDefaults(key: kFolderURL_WakeUpp))
    let dirURL : URL = UserDefaultManager.getStringFromUserDefaults(key: kFolderURL_WakeUpp).url!
    //printMsg(val:  "getURL_WakeUpp_Directory : \(dirURL)")
    return dirURL
}


func getURL_Group_Directory() -> URL {
    let dirURL : URL = UserDefaultManager.getStringFromUserDefaults(key: kFolderURL_Group).url!
    //printMsg(val:  "getURL_Group_Directory : \(dirURL)")
    return dirURL
}

func getURL_Chat_Directory() -> URL {
    //let dirURL : URL = URL(fileURLWithPath: UserDefaultManager.getStringFromUserDefaults(key: kFolderURL_Chat))
    let dirURL : URL = UserDefaultManager.getStringFromUserDefaults(key: kFolderURL_Chat).url!
    //printMsg(val:  "getURL_Chat_Directory : \(dirURL)")
    return dirURL
}

func getURL_ChatWithUser_Directory(countryCode:String, PhoneNo : String) -> URL {
    let strFullContactNo : String = "\(countryCode)\(PhoneNo)"
    if (strFullContactNo.count == 0) { return NSURL.init().baseURL! }
    
    var strFolderName : String = "\(Folder_Chat)_\(strFullContactNo)"
    strFolderName = strFolderName.replacingOccurrences(of: " ", with: "")
    
    let chatBackupFolderURL : URL = create_folder(folderName: strFolderName, inFolder:getURL_Chat_Directory())!
    
    return chatBackupFolderURL
}


func getURL_GroupChat_Directory(groupID:String) -> URL {
    let strGroupName : String = "\(groupID)"
    if (strGroupName.count == 0) { return NSURL.init().baseURL! }
    
    var strFolderName : String = "\(Folder_Group)_\(strGroupName)"
    strFolderName = strFolderName.replacingOccurrences(of: " ", with: "")
    
    let groupChatBackupFolderURL : URL = create_folder(folderName: strFolderName, inFolder:getURL_Group_Directory())!
    return groupChatBackupFolderURL
}

//MARK:
func isFileLocallyExist(fileName:String, inDirectory:URL) -> Bool {
    let filePath = inDirectory.appendingPathComponent(fileName)
    let fileManager = FileManager.default
    
    // Check if file exists
    if fileManager.fileExists(atPath: filePath.path) { return true }
    else { return false }
}

func getURL_LocallyExistFileURL(fileName:String, inDirectory:URL) -> URL {
    if isFileLocallyExist(fileName: fileName, inDirectory: inDirectory) == true {
        let filePath = inDirectory.appendingPathComponent(fileName)
        return filePath
    }
    return NSURL.init() as URL
}

func removeFile_onURL(fileURL:URL) {
    let fileManager = FileManager.default
    if fileManager.fileExists(atPath: fileURL.path) {
        do {
            //try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
            try fileManager.removeItem(at: fileURL)
            NSLog("SUCCESS : Remove file")
        } catch {
            NSLog("Error : Remove file.")
        }
    }
    //NSLog("SUCCESS : Remove file")
}

func getAllContent_inDir(dirURL:URL) -> Array<URL> {
    var arrData : [URL] = []
    
    do {
        let directoryContents = try FileManager.default.contentsOfDirectory(at: dirURL, includingPropertiesForKeys: nil, options: [])
        //printMsg(val:  "getAllContent_inDir Total : \(directoryContents.count)")
        for filePath : URL in directoryContents {
            arrData.append(filePath)
            //printMsg(val:  "getAllContent_inDir - FilePath: \(filePath)")
        }
    }
    catch {
        //printMsg(val:  "Error for getting dir content: \(error)")
        //printMsg(val:  "Error: \(error.localizedDescription)")
    }
    return arrData
}


func get_fileName_asCurretDateTime() -> String {
    var strName : String = ""
    
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMdd_HHmmss"
    strName = formatter.string(from: date)
    
    return strName
}

func get_RandomNo(noOfDigit : Int ) -> String {
    var number = ""
    for i in 0..<noOfDigit {
        var randomNumber = arc4random_uniform(10)
        while randomNumber == 0 && i == 0 { randomNumber = arc4random_uniform(10) }
        number += "\(randomNumber)"
    }
    return number
}
*/

func timeAgoSinceStrDate1(strDate:String, numericDates:Bool,isFutur:Bool = false) -> String{
    
    /*let formato = DateFormatter()
     formato.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
     formato.timeZone = NSTimeZone(name: "UTC")! as TimeZone
     formato.formatterBehavior = .default
     let date = formato.date(from: strDate)!*/
    
    let date = convertDateAccordingDeviceTime(dategiven: strDate)
    
    if(isFutur == true)
    {
        return timeAgoSinceDateFuture(date: date as Date, numericDates: numericDates)
    }
    else
    {
        return timeAgoSinceDate(date: date as Date, numericDates: numericDates)
    }
    //PV
    
    //return DateFormater.generateTimeForGivenDate(strDate: date)
}

func timeAgoSinceDateFuture(date:Date, numericDates:Bool) -> String
{
    let calendar = NSCalendar.current
    let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
    let now = NSDate()
    let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now as Date, options: [])
    if (abs(components.year!) >= 2)
    {
        return "\(abs(components.year!))" + " years from now"
    }
    else if (abs(components.year!) >= 1)
    {
        if (numericDates){
            return "\(abs(components.year!)) year from now"
        } else {
            return "Next year"
        }
    }
    else if (abs(components.month!) >= 2) {
        return "\(abs(components.month!))" + " months from now"
    }
    else if (abs(components.month!) >= 1){
        if (numericDates){
            return "\(abs(components.month!)) month from now"
        } else {
            return "Next month"
        }
    }
    else if (abs(components.weekOfYear!) >= 2) {
        return "\(abs(components.weekOfYear!))" + " weeks from now"
    }
    else if (abs(components.weekOfYear!) >= 1){
        if (numericDates){
            return "\(abs(components.weekOfYear!)) week from now"
        } else {
            return "Next week"
        }
    }
    else if (abs(components.day!) >= 2) {
        return "\(abs(components.day!))" + " days from now"
    }
    else if (abs(components.day!) >= 1){
        if (numericDates){
            return "\(abs(components.day!)) day from now"
        } else {
            return "Tomorrow"
        }
    }
    else if (abs(components.hour!) >= 2) {
        return "\(abs(components.hour!))" + " hours from now"
    }
    else if (abs(components.hour!) >= 1){
        if (numericDates){
            return "\(abs(components.hour!)) hour from now"
        } else {
            return "An hour from now"
        }
    }
    else if (abs(components.minute!) >= 2)
    {
        return "\(abs(components.minute!))" + " min from now"
    } else if (abs(components.minute!) > 1){
        if (numericDates){
            return "\(abs(components.minute!)) min from now"
        } else {
            return "A min from now"
        }
    }
    else if (abs(components.second!) >= 3) {
        return "\(abs(components.second!))" + " sec from now"
    } else {
        return "Just now"
    }
}

//MARK:- Mutable String Method
func makeAttributedString(firstString: String, secondString: String, fontSize: CGFloat, firstColor: UIColor, secondColor: UIColor) -> NSMutableAttributedString {
    let str = "\(firstString) \(secondString)"
    var myMutableString = NSMutableAttributedString()
    myMutableString = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font:UIFont(name: FT_Medium, size: fontSize)!])
    let attributedFont = UIFont(name: FT_Bold, size: fontSize)
    myMutableString.addAttribute(NSAttributedString.Key.font, value: attributedFont as Any, range: NSRange(location:0,length:firstString.count))
    let range = (str as NSString).range(of: secondString)
    myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: secondColor , range: range)
    let range1 = (str as NSString).range(of: firstString)
    myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: firstColor , range: range1)
    return myMutableString
}

func makeAttributedString1(firstString: String, secondString: String, fontSize: CGFloat, firstColor: UIColor, secondColor: UIColor) -> NSMutableAttributedString {
    let str = "\(firstString) \(secondString)"
    var myMutableString = NSMutableAttributedString()
    myMutableString = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font:UIFont(name: FT_Medium, size: fontSize)!])
    let attributedFont = UIFont(name: FT_Bold, size: fontSize)
    myMutableString.addAttribute(NSAttributedString.Key.font, value: attributedFont as Any, range: NSRange(location:firstString.count+1,length:secondString.count)) //+1 is for space
    let range = (str as NSString).range(of: secondString)
    myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: secondColor , range: range)
    let range1 = (str as NSString).range(of: firstString)
    myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: firstColor , range: range1)
    return myMutableString
}

func makeAttributedString11(firstString: String, secondString: String, fontSize: CGFloat, firstColor: UIColor, secondColor: UIColor) -> NSMutableAttributedString {
    let str = "\(firstString)\n\(secondString)"
    var myMutableString = NSMutableAttributedString()
    myMutableString = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font:UIFont(name: FT_Medium, size: fontSize)!])
    let attributedFont = UIFont(name: FT_Bold, size: fontSize)
    myMutableString.addAttribute(NSAttributedString.Key.font, value: attributedFont as Any, range: NSRange(location:firstString.count+1, length:secondString.count)) //+1 is for space
    let range = (str as NSString).range(of: secondString)
    myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: secondColor , range: range)
    let range1 = (str as NSString).range(of: firstString)
    myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: firstColor , range: range1)
    return myMutableString
}


func makeAttributedString2(firstString: String, secondString: String, fontSize: CGFloat, firstColor: UIColor, secondColor: UIColor) -> NSMutableAttributedString {
    let str = "\(firstString)\(secondString)"
    var myMutableString = NSMutableAttributedString()
    myMutableString = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font:UIFont(name: FT_Medium, size: fontSize)!])
    let attributedFont = UIFont(name: FT_Bold, size: fontSize)
    myMutableString.addAttribute(NSAttributedString.Key.font, value: attributedFont as Any, range: NSRange(location:0,length:firstString.count))
    let range = (str as NSString).range(of: secondString)
    myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: secondColor , range: range)
    let range1 = (str as NSString).range(of: firstString)
    myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: firstColor , range: range1)
    return myMutableString
}

func makeAttributedString22(firstString: String, secondString: String, fontSize1: CGFloat, fontSize2: CGFloat, firstColor: UIColor, secondColor: UIColor) -> NSMutableAttributedString {
    let str = "\(firstString)\(secondString)"
    var myMutableString = NSMutableAttributedString()
    myMutableString = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font:UIFont(name: FT_Medium, size: fontSize1)!])
    let attributedFont = UIFont(name: FT_Regular, size: fontSize2)
    myMutableString.addAttribute(NSAttributedString.Key.font, value: attributedFont as Any, range: NSRange(location:firstString.count,length:secondString.count))
    let range = (str as NSString).range(of: secondString)
    myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: secondColor , range: range)
    let range1 = (str as NSString).range(of: firstString)
    myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: firstColor , range: range1)
    return myMutableString
}

func makeAttributedString222(firstString: String, secondString: String, fontSize1: CGFloat, fontSize2: CGFloat, firstColor: UIColor, secondColor: UIColor) -> NSMutableAttributedString {
    let str = "\(firstString)\(secondString)"
    var myMutableString = NSMutableAttributedString()
    myMutableString = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font:UIFont(name: FT_Medium, size: fontSize1)!])
    let attributedFont = UIFont(name: FT_Bold, size: fontSize2)
    myMutableString.addAttribute(NSAttributedString.Key.font, value: attributedFont as Any, range: NSRange(location:firstString.count,length:secondString.count))
    let range = (str as NSString).range(of: secondString)
    myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: secondColor , range: range)
    let range1 = (str as NSString).range(of: firstString)
    myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: firstColor , range: range1)
    return myMutableString
}

func makeAttributedString3(firstString: String, secondString: String, thirdString: String, fontSize: CGFloat, firstColor: UIColor, secondColor: UIColor, thirdColor: UIColor) -> NSMutableAttributedString {
    let str = "\(firstString) \(secondString) \(thirdString)"
    var myMutableString = NSMutableAttributedString()
    myMutableString = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font:UIFont(name: FT_Regular, size: fontSize)!])
    let attributedFont = UIFont(name: FT_Bold, size: fontSize)
    let attributedFont1 = UIFont(name: FT_Medium, size: fontSize)
    myMutableString.addAttribute(NSAttributedString.Key.font, value: attributedFont as Any, range: NSRange(location:0,length:firstString.count))
    myMutableString.addAttribute(NSAttributedString.Key.font, value: attributedFont1 as Any, range: NSRange(location:firstString.count+1+secondString.count+1,length:thirdString.count))

    let range2 = (str as NSString).range(of: thirdString)
    myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: thirdColor , range: range2)
    let range = (str as NSString).range(of: secondString)
    myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: secondColor , range: range)
    let range1 = (str as NSString).range(of: firstString)
    myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: firstColor , range: range1)
    return myMutableString
}

func makeAttributedString4(firstString: String, secondString: String, fontSize1: CGFloat, fontSize2: CGFloat, firstColor: UIColor, secondColor: UIColor) -> NSMutableAttributedString {
    let str = "\(firstString) \(secondString)"
    var myMutableString = NSMutableAttributedString()
    myMutableString = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font:UIFont(name: FT_Regular, size: fontSize1)!])
    let attributedFont = UIFont(name: FT_Bold, size: fontSize1)
    myMutableString.addAttribute(NSAttributedString.Key.font, value: attributedFont as Any, range: NSRange(location:0,length:firstString.count))
    let attributedFont1 = UIFont(name: FT_Regular, size: fontSize2)
    myMutableString.addAttribute(NSAttributedString.Key.font, value: attributedFont1 as Any, range: NSRange(location:firstString.count+1,length:secondString.count))
    let range = (str as NSString).range(of: secondString)
    myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: secondColor , range: range)
    let range1 = (str as NSString).range(of: firstString)
    myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: firstColor , range: range1)
    return myMutableString
}

func makeMediumItalicAttributedString(firstString: String, secondString: String) -> NSMutableAttributedString {
    let str = "\(firstString) \(secondString)"
    
    var myMutableString = NSMutableAttributedString()
    myMutableString = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font:UIFont(name: FT_Medium, size: 18)!])
    let attributedFont = UIFont(name: FT_Medium, size: 18)
    myMutableString.addAttribute(NSAttributedString.Key.font, value: attributedFont as Any, range: NSRange(location:0,length:firstString.count))
    let attributedFont1 = UIFont(name: FT_Regular, size: 15)
    myMutableString.addAttribute(NSAttributedString.Key.font, value: attributedFont1 as Any, range: NSRange(location:firstString.count+1,length:secondString.count))
    let range = (str as NSString).range(of: secondString)
    myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: themeBrownColor, range: range)
    let range1 = (str as NSString).range(of: firstString)
    myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: range1)
    return myMutableString
}

//MARK:- Remove All Notifications From Notification Center
func removeAllNotificationsFromCenter() {
    let center = UNUserNotificationCenter.current()
    center.removeAllDeliveredNotifications() // To remove all delivered notifications
    center.removeAllPendingNotificationRequests()
}

//MARK:- Colorful Slider Method
func setSlider(slider:UISlider) {
//    print("slidervalue : \(slider.value)")
    let tgl = CAGradientLayer()
    let frame = CGRect(x: 0.0, y: 0.0, width: slider.bounds.width, height: 12.0 )
    tgl.frame = frame
    
    /*
     background: linear-gradient(90deg, #1AC0FF 0%, #FFB717 75.46%, #EF3E25 99.99%);
     */
    if slider.value == 1.0 {
        tgl.colors = [Color_Hex(hex: "#1AC0FF").cgColor, Color_Hex(hex: "#FFB717").cgColor, Color_Hex(hex: "#EF3E25").cgColor]
    } else if slider.value > 0.0 {
        tgl.colors = [Color_Hex(hex: "#1AC0FF").cgColor, Color_Hex(hex: "#FFB717").cgColor, Color_Hex(hex: "#EF3E25").cgColor, Color_Hex_Alpha(hex: "#FFFFFF", withAlpha: 0.0).cgColor]
    } else {
        tgl.colors = [UIColor.white.cgColor]
    }
//    tgl.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor, UIColor.green.cgColor]
//    tgl.colors = [Color_Hex(hex: "#1AC0FF").cgColor, Color_Hex(hex: "#FFB717").cgColor, Color_Hex(hex: "#EF3E25").cgColor]

    tgl.borderWidth = 1.5
    tgl.borderColor = UIColor.black.cgColor

    tgl.startPoint = CGPoint(x: 0.0, y: 1.0)
    tgl.endPoint = CGPoint(x: CGFloat(slider.value)+0.1, y: 1.0)

//    tgl.endPoint = CGPoint(x: 1.0, y:  1.0)
    tgl.masksToBounds = true
    tgl.cornerRadius = 6.0
        
    UIGraphicsBeginImageContextWithOptions(tgl.frame.size, false, 0.0)
    tgl.render(in: UIGraphicsGetCurrentContext()!)
    let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
//        let padding:CGFloat = 1.5
//        backgroundImage = backgroundImage?.imageWithInsets(insets: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))

    UIGraphicsEndImageContext()
    DispatchQueue.main.async {
        slider.setMaximumTrackImage(backgroundImage?.resizableImage(withCapInsets: .zero, resizingMode: .stretch),  for: .normal)
        slider.setMinimumTrackImage(backgroundImage?.resizableImage(withCapInsets:.zero, resizingMode: .stretch),  for: .normal)
    }

    let layerFrame = CGRect(x: 0, y: 0, width: 25.0, height: 25.0)

    let shapeLayer = CAShapeLayer()
    shapeLayer.path = CGPath(rect: layerFrame, transform: nil)
    shapeLayer.fillColor = UIColor.white.cgColor

    let thumb = CALayer.init()
    thumb.frame = layerFrame
    thumb.cornerRadius = layerFrame.width / 2
    thumb.addSublayer(shapeLayer)

    UIGraphicsBeginImageContextWithOptions(thumb.frame.size, false, 0.0)

    thumb.render(in: UIGraphicsGetCurrentContext()!)
    var thumbImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    thumbImage = thumbImage!.rounded(with: themeBrownColor, width: 1.5)
    slider.setThumbImage(thumbImage, for: .normal)
    slider.setThumbImage(thumbImage, for: .highlighted)
    slider.clipsToBounds = true
    
}

//MARK:- Load WEBP Image Method
//func loadProfileWebpImage(withURL: URL, placeholderImg: UIImage) -> UIImage {
//    var myImage: UIImage = placeholderImg
//    SDWebImageManager.shared.loadImage(with: withURL, options: .refreshCached, progress: nil) { (myimg, mydata, myerror, mycache, success, myurl) in
//        if success {
//            if let newimg = myimg {
//                myImage = newimg
//            }
//        }
//    }
//    return myImage
//}
//
//func loadWebpImage(withURL: URL, placeholderImg: UIImage) -> UIImage {
//    var myImage: UIImage = placeholderImg
//    SDWebImageManager.shared.loadImage(with: withURL, options: .refreshCached, progress: nil) { (myimg, mydata, myerror, mycache, success, myurl) in
//        if success {
//            if let newimg = myimg {
//                myImage = newimg
//            }
//        }
//    }
//    return myImage
//}
//
//func loadWebpImageWithoutPlaceholder(withURL: URL, withImgvw: UIImageView) { //-> UIImage? {
//    SDWebImageManager.shared.loadImage(with: withURL, options: .refreshCached, progress: nil) { (myimg, mydata, myerror, mycache, success, myurl) in
//        if success {
//            if let newimg = myimg {
//                withImgvw.image = newimg
//            }
//        }
//    }
//}

func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
    DispatchQueue.global().async { //1
        let asset = AVAsset(url: url) //2
        let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
        avAssetImageGenerator.appliesPreferredTrackTransform = true //4
//        let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
        do {
            let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbImage = UIImage(cgImage: cgThumbImage) //7
            DispatchQueue.main.async { //8
                completion(thumbImage) //9
            }
        } catch {
            print("error in thumb generation : \(error.localizedDescription)") //10
            DispatchQueue.main.async {
                completion(nil) //11
            }
        }
    }
}

//func getThumbnailImage(forUrl url: URL) -> UIImage? {
//    let asset: AVAsset = AVAsset(url: url)
//    let imageGenerator = AVAssetImageGenerator(asset: asset)
//
//    do {
//        let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
//        return UIImage(cgImage: thumbnailImage)
//    } catch let error {
//        print(error)
//    }
//
//    return nil
//}

//MARK:- Load Image from Base64 String Method
func base64ToImage(withStr: String) -> UIImage? {
    if let dataDecoded = NSData(base64Encoded: withStr, options: NSData.Base64DecodingOptions(rawValue: 0)) {
        if let decodedimage = UIImage(data: dataDecoded as Data) {
            return decodedimage
        }
    }
    return nil
}

func changeKeyboardTintColor() {
    DispatchQueue.main.async {
        UITextField.appearance().tintColor = themeBrownColor
        UITextView.appearance().tintColor = themeBrownColor
        IQKeyboardManager.shared.toolbarTintColor = themeBrownColor
    }
}

func es_blackcolor() -> UIColor {
    if #available(iOS 13.0, *),
        UIScreen.main.traitCollection.userInterfaceStyle == .dark {
        return .white
    } else {
        return .black
    }
}

func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
  guard let rating = starRating?.doubleValue else {
    return nil
  }
  if rating >= 5 {
    return UIImage(named: "stars_5")
  } else if rating >= 4.5 {
    return UIImage(named: "stars_4_5")
  } else if rating >= 4 {
    return UIImage(named: "stars_4")
  } else if rating >= 3.5 {
    return UIImage(named: "stars_3_5")
  } else {
    return nil
  }
}
extension NSMutableAttributedString{
    func setColorForText(_ textToFind: String, with color: UIColor) {
        let range = self.mutableString.range(of: textToFind, options: .caseInsensitive)
        if range.location != NSNotFound {
            addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
    }
}

//MARK:- Poll Timer Methods
func setupPollTimer(withLaunchDate: String, withCurrentDateTime: String, withDuration: String) -> String {
    let dt = DateFormatter.init()
    dt.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dt.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    if let datelaunch = dt.date(from: withLaunchDate) {
        print("date launch : \(datelaunch)")
        
        dt.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        if let currentdatetime = dt.date(from: withCurrentDateTime) {
            print("currentdatetime : \(currentdatetime)")
            
            let minsbetwn = minutesBetweenDates(datelaunch, currentdatetime)
            print("minsbetwn : \(minsbetwn)")
            
            let mainmins = withDuration.cgFloat() ?? 0.00
            if minsbetwn <= mainmins {
                let diff = Int(mainmins - minsbetwn)
                let seconds = diff*60
                let cntdays = seconds / 86400
                let cnthrs = (seconds % 86400) / 3600
                let cntmins = (seconds % 3600) / 60
                var finalDuration = "" //"\(cntdays) Days \(cnthrs) Hrs \(cntmins) Mins"
                if cntdays > 0 {
                    if cntdays == 1 {
                        finalDuration = "\(cntdays) Day"
                    } else {
                        finalDuration = "\(cntdays) Days"
                    }
                }
                if cnthrs > 0 {
                    if cnthrs == 1 {
                        finalDuration = finalDuration + " \(cnthrs) Hr"
                    } else {
                        finalDuration = finalDuration + " \(cnthrs) Hrs"
                    }
                }
                if cntmins > 0 {
                    if cntmins == 1 {
                        finalDuration = finalDuration + " \(cntmins) Min"
                    } else {
                        finalDuration = finalDuration + " \(cntmins) Mins"
                    }
                }
                print("finalDuration : \(finalDuration)")
                
                return finalDuration
                
            } else {
                return "Ended"
            }
        }
    }
    return ""
}

func minutesBetweenDates(_ oldDate: Date, _ newDate: Date) -> CGFloat {
    //get both times sinces refrenced date and divide by 60 to get minutes
    let newDateMinutes = newDate.timeIntervalSinceReferenceDate/60
    let oldDateMinutes = oldDate.timeIntervalSinceReferenceDate/60
    
    //then return the difference
    return CGFloat(newDateMinutes - oldDateMinutes)
}
