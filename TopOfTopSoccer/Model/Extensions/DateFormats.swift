//
//  DateFormats.swift
//  SwiftDemo
//


import Foundation

public let GLOBAL_DATE_FORMAT: String = "yyyy-MM-dd HH:mm:ss"
public let GLOBAL_DATE_FORMAT1: String = "MMMM dd, yyyy hh:mm:ss"//"yyyy-MM-dd HH:mm:ss"
public let FULL_DATE_FORMAT11: String = "MMMM dd, yyyy hh:mm a"//"dd/MM/yyyy hh:mm a"
public let GLOBAL_APP_DATE_FORMAT: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
public let ONLY_DATE_FORMAT: String = "yyyy-MM-dd"
public let ONLY_DATE_FORMAT1: String = "dd-MM-yyyy"
public let ONLY_TIME_FORMAT: String = "HH:mm:00"
public let ONLY_DATE_TIME_FORMAT: String = "yyyy-MM-dd HH:mm:00"
public let BIRTH_DATE_FORMAT: String = "yyyy-MM-dd"
public let ONLY_DATE_MONTH_FORMAT: String = "dd/MM"
public let FULL_DATE_FORMAT: String = "dd MMM yyyy hh:mm a"
public let FULL_DATE_FORMAT1: String = "dd MMMM, yyyy"
public let FB_BIRTH_DATE_FORMAT: String = "MM/dd/yyyy"
public let DIFF_DATE_FORMAT: String = "EEE d MMM yyyy"
public let DIFF_DATE_FORMAT1: String = "d MMMM, yyyy, EEEE"
public let ONLY_TIME_FORMAT_12HRS: String = "hh:mm a"
public let DATE_FOR_CHAT: String = "MMM dd, yyyy"
public let DATE_FOR_WHOLE_APP: String = "MMMM dd, yyyy"
//public let DATE_TIME_12HRS_FORMAT:String = "hh:mm a, dd MMMM yyyy"
public let DATE_TIME_12HRS_FORMAT:String = "hh:mm a, MMMM dd, yyyy"//"hh:mm a, MMM dd yyyy"
public let DATE_TIME_12HRS_FORMAT_2:String = "MMM dd yyyy hh:mm a"
public let DATE_TIME_12HRS_FORMAT_3:String = "MMM dd, yyyy hh:mm a"
public let DATE_TIME_12HRS_FORMAT_4:String = "hh:mm a, dd MMM, yyyy"
public let FULL_DATE_FORMAT2: String = "MMM dd, yyyy"
public let FULL_DATE_FORMAT3: String = "MMM dd yyyy"
public let FULL_DATE_FORMAT4: String = "MMM dd, yy"
public let FULL_DATE_FORMAT5: String = "dd MMM, yy"
public let FULL_DATE_FORMAT6: String = "MM/dd/yy"
public let MONTH_YEAR:String = "MMMM yyyy"
public let MONTH_YEAR1:String = "MMMyyyy"
public let MONTH_YEAR2:String = "MM-yyyy" //Remaining
public let MONTH_YEAR3:String = "MMM yyyy"
public let MONTH_YEAR4:String = "MM/yyyy"
public let DATE_MONTH:String = "dd MMM"
public let DATE_MONTH1:String = "MMMM dd"//"MMM dd"
public let ONLY_MONTH:String = "MMMM"//"MMM"
public let ONLY_DATE:String = "dd"
public let DIFF_DATE_FORMAT11: String = "EEEE MMMM dd"
public let DIFF_DATE_FORMAT111: String = "MMMM dd, yyyy"
public let ONLY_TIME_FORMAT_24HRS:String = "HH:ss a"

class DateFormater {
    
    private static let sharedInstance = DateFormater()
    private var gameScore: Int = 0
    var sharedDateFormat : DateFormatter? = nil
    // METHODS
    private init() {
        self.sharedDateFormat = DateFormatter()
        self.sharedDateFormat!.timeZone = NSTimeZone.system
        let enUSPOSIXLocale: NSLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        self.sharedDateFormat!.locale = enUSPOSIXLocale as Locale?
    }

    
    
    //MARK:- WHOLE APP DATE FORMAT
    class func getChatDateFromString(dategiven:String) -> NSDate{
        let strDate = dategiven//.replacingOccurrences(of: "", with: "T")
//        if strDate.components(separatedBy: ".").count < 2{
//            strDate = "\(strDate).000Z"
//        }
        
        //        let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateFormat = "yyyy-MM-dd HH:mm:ss"
        
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
    
//    class func convertDateAccordingDeviceTime1(dategiven:String, withOutputFormat: String) -> NSDate
    class func convertDateAccordingDeviceTime1(dategiven:String, withOutputFormat: String) -> String

    {
        let dateFormat = GLOBAL_DATE_FORMAT
        let inputTimeZone = NSTimeZone(abbreviation: "UTC")
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.timeZone = inputTimeZone as TimeZone?
        inputDateFormatter.dateFormat = dateFormat
        let date = inputDateFormatter.date(from: dategiven)
        let outputTimeZone = NSTimeZone.local
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.timeZone = outputTimeZone
        outputDateFormatter.dateFormat = withOutputFormat //dateFormat
        let outputString = outputDateFormatter.string(from: date ?? Date())
        return outputString //outputDateFormatter.date(from: outputString)! as NSDate
    }
    
    class func convertDateToLocalTimeZoneForDateFromString_new(givenDate: String) -> NSDate {
        if givenDate.contains("T") {
            self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_APP_DATE_FORMAT //PV
        }
        else {
            self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        }
        
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        //SET TIME ZONE FORMAT OF SERVER HERE
        return self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
    }

    
    class func newGetFullDateStringFromString99(givenDate: String) -> String {
        if givenDate != ""
        {
            self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
                   self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_DATE_FORMAT
                   let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
                   self.sharedInstance.sharedDateFormat!.dateFormat = DATE_FOR_WHOLE_APP
                   return self.sharedInstance.sharedDateFormat!.string(from: date as Date)
        }
        else
        {
            return ""
        }
    }
    
    //MARK: Convert To Local TimeZone
    class func convertDateToLocalTimeZone(givenDate: String) -> String {
        var final_date: String
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        //SET TIME ZONE FORMAT OF SERVER HERE
        let ts_utc: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        final_date = self.sharedInstance.sharedDateFormat!.string(from: ts_utc as Date)
        return final_date
    }
    
    class func convertDateForChatMessage(givenDate: String) -> String{
        var final_date: String
        self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_DATE_FORMAT
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        //SET TIME ZONE FORMAT OF SERVER HERE
        let ts_utc: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = "MMMM dd, yyyy"
        final_date = self.sharedInstance.sharedDateFormat!.string(from: ts_utc as Date)
        return final_date
    }
    
    class func getMessageDate(givenDate:String)->Date
    {
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        if givenDate.contains("null") == false
        {
            if givenDate.count > 0
            {
                let ts_utc = self.sharedInstance.sharedDateFormat!.date(from: givenDate)!
                return ts_utc
            }
            else
            {
                let ts_utc = self.sharedInstance.sharedDateFormat!.date(from: self.sharedInstance.sharedDateFormat!.string(from: Date()))!
                return ts_utc
            }
        }
        else
        {
            let ts_utc = self.sharedInstance.sharedDateFormat!.date(from: self.sharedInstance.sharedDateFormat!.string(from: Date()))!
            return ts_utc
        }
    }
    
    class func convertDateToLocalTimeZoneForDate(givenDate: NSDate) -> NSDate {
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        //SET TIME ZONE FORMAT OF SERVER HERE
        let strDate: String = self.sharedInstance.sharedDateFormat!.string(from: givenDate as Date)
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.local
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        return self.sharedInstance.sharedDateFormat!.date(from: strDate)! as NSDate
    }
    
    class func convertDateToLocalTimeZoneForDateFromString(givenDate: String) -> NSDate {
        if givenDate.contains("T") {
            self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_APP_DATE_FORMAT
        }
        else {
            self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        }
    
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        return self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
    }
    
    class func convertLocalDateTimeToServerTimeZone1(givenDate: String) -> String {
        let final_date: String
        if givenDate.contains("T") {
            self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_APP_DATE_FORMAT
        }
        else {
            self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        }
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        let ts_utc: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = FULL_DATE_FORMAT11
        final_date = self.sharedInstance.sharedDateFormat!.string(from: ts_utc as Date)
        return final_date
    }
    
    
    class func convertLocalDateTimeToServerTimeZone11(givenDate: String) -> String {
        let final_date: String
        if givenDate.contains("T") {
            self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_APP_DATE_FORMAT
        }
        else {
            self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        }
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        let ts_utc: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_DATE_FORMAT
        final_date = self.sharedInstance.sharedDateFormat!.string(from: ts_utc as Date)
        return final_date
    }
    
    class func convertLocalDateTimeToServerTimeZone111(givenDate: String) -> String {
        let final_date: String
        if givenDate.contains("T") {
            self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_APP_DATE_FORMAT //PV
        }
        else {
            self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        }
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        let ts_utc: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = DATE_FOR_WHOLE_APP
        final_date = self.sharedInstance.sharedDateFormat!.string(from: ts_utc as Date)
        return final_date
    }
    
    class func convertLocalDateTimeToServerTimeZone(givenDate: String) -> String {
        let final_date: String
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        let ts_utc: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        final_date = self.sharedInstance.sharedDateFormat!.string(from: ts_utc as Date)
        return final_date
    }
    
    class func generateDateForGivenDateToServerTimeZone(givenDate: NSDate) -> String {
        self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_DATE_TIME_FORMAT
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        //SET TIME ZONE FORMAT OF SERVER HERE
        return self.sharedInstance.sharedDateFormat!.string(from: givenDate as Date)
    }
    
    class func getUTCDateFromUTCString(givenDate: String) -> NSDate {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        return self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
    }
    
    class func convertDateAccordingDeviceTime(dategiven:String) -> NSDate
    {
        let dateFormat = GLOBAL_DATE_FORMAT
        let inputTimeZone = NSTimeZone(abbreviation: "UTC")
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.timeZone = inputTimeZone as TimeZone?
        inputDateFormatter.dateFormat = dateFormat
        let date = inputDateFormatter.date(from: dategiven)
        let outputTimeZone = NSTimeZone.local
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.timeZone = outputTimeZone
        outputDateFormatter.dateFormat = dateFormat
        let outputString = outputDateFormatter.string(from: date!)
        return outputDateFormatter.date(from: outputString)! as NSDate
    }
    class func convertDateAccordingDeviceTimeString(dategiven:String) -> String
    {
        let inputDateFormatter = DateFormatter()
        let outputDateFormatter = DateFormatter()
        
        let dateFormat = GLOBAL_DATE_FORMAT
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
    
    //MARK: Common Formats
    class func getStringFromDateString(givenDate: String) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        return self.sharedInstance.sharedDateFormat!.string(from: date as Date)
    }
    
    class func getMonthYearStringFromDateString(givenDate: String) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = MONTH_YEAR2
        return self.sharedInstance.sharedDateFormat!.string(from: date as Date)
    }
    
    class func getMonthYearStringFromDateString2(givenDate: String) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = MONTH_YEAR3
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = MONTH_YEAR2
        return self.sharedInstance.sharedDateFormat!.string(from: date as Date)
    }
    
    class func getMonthYearStringFromDateString1(givenDate: String) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = MONTH_YEAR3
        return self.sharedInstance.sharedDateFormat!.string(from: date as Date)
    }
    
    class func getDayMonthYearStringFromDateString11(givenDate: String) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_DATE_FORMAT
        return self.sharedInstance.sharedDateFormat!.string(from: date as Date)
    }
    
    class func generateMonthYearFullForGivenDate(strDate: NSDate) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = MONTH_YEAR2
        let tm: String = self.sharedInstance.sharedDateFormat!.string(from: strDate as Date)
        return "\(tm)"
    }
    
    class func generateMonthYearFullForGivenDate1(strDate: NSDate) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = MONTH_YEAR//MONTH_YEAR4
        let tm: String = self.sharedInstance.sharedDateFormat!.string(from: strDate as Date)
        return "\(tm)"
    }
    
    class func generateMonthYearFullForGivenDate11(strDate: NSDate) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = MONTH_YEAR4
        let tm: String = self.sharedInstance.sharedDateFormat!.string(from: strDate as Date)
        return "\(tm)"
    }
    
    class func generateMonthYearFullForGivenDate111(strDate: NSDate) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = MONTH_YEAR4
        let tm: String = self.sharedInstance.sharedDateFormat!.string(from: strDate as Date)
        return "\(tm)"
    }
    
    class func generateDayMonthYearFullForGivenDate(strDate: NSDate) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_DATE_FORMAT
        let tm: String = self.sharedInstance.sharedDateFormat!.string(from: strDate as Date)
        return "\(tm)"
    }
    
    class func getStringFromDate(givenDate: NSDate) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        return self.sharedInstance.sharedDateFormat!.string(from: givenDate as Date)
    }
    
    class func getFullDateStringFromDate(givenDate: NSDate) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        return self.sharedInstance.sharedDateFormat!.string(from: givenDate as Date)
    }
    
    
    class func getFullDateStringFromDate_FullFormat(givenDate: NSDate) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = FULL_DATE_FORMAT11//FULL_DATE_FORMAT
        return self.sharedInstance.sharedDateFormat!.string(from: givenDate as Date)
    }
    
    class func getFullDateStringFromDate_FullFormat1(givenDate: NSDate) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = DATE_MONTH1//DATE_MONTH
        return self.sharedInstance.sharedDateFormat!.string(from: givenDate as Date)
    }
    
    class func getFullDateStringFromString(givenDate: String) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = FULL_DATE_FORMAT
        return self.sharedInstance.sharedDateFormat!.string(from: date as Date)
    }
    
    class func getFullDateStringFromString2(givenDate: String) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = DATE_FOR_WHOLE_APP//FULL_DATE_FORMAT2
        return self.sharedInstance.sharedDateFormat!.string(from: date as Date)
    }

    class func getFullDateStringFromString21(givenDate: String) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = DATE_FOR_WHOLE_APP//FULL_DATE_FORMAT4
        return self.sharedInstance.sharedDateFormat!.string(from: date as Date)
    }
    
    class func getFullDateStringFromString211(givenDate: String) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = FULL_DATE_FORMAT4
        return self.sharedInstance.sharedDateFormat!.string(from: date as Date)
    }
    
    class func getFullDateStringFromString22(givenDate: String) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = DATE_FOR_WHOLE_APP//FULL_DATE_FORMAT4
        return self.sharedInstance.sharedDateFormat!.string(from: date as Date)
    }
    
    class func getFullDateStringFromString222(givenDate: String) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = FULL_DATE_FORMAT4
        return self.sharedInstance.sharedDateFormat!.string(from: date as Date)
    }
    
    class func getFullDateStringFromString23(givenDate: String) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_DATE
        return self.sharedInstance.sharedDateFormat!.string(from: date as Date)
    }
    
    class func getFullDateStringFromString24(givenDate: String) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = DATE_FOR_WHOLE_APP//FULL_DATE_FORMAT5
        return self.sharedInstance.sharedDateFormat!.string(from: date as Date)
    }
    
    class func getFullDateStringFromString25(givenDate: String) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = DATE_FOR_WHOLE_APP//FULL_DATE_FORMAT6
        return self.sharedInstance.sharedDateFormat!.string(from: date as Date)
    }
    
    class func getFullDateStringFromString3(givenDate: String) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = DATE_FOR_WHOLE_APP//FULL_DATE_FORMAT3
        return self.sharedInstance.sharedDateFormat!.string(from: date as Date)
    }
    
    class func getFullDateStringFromString4(givenDate: String) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = DATE_MONTH1//DATE_MONTH
        return self.sharedInstance.sharedDateFormat!.string(from: date as Date)
    }
    
    class func getFullDateStringFromString5(givenDate: String) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_DATE_FORMAT1
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = DATE_FOR_WHOLE_APP//FULL_DATE_FORMAT3
        return self.sharedInstance.sharedDateFormat!.string(from: date as Date)
    }
    
    class func getFullDateStringFromString55(givenDate: String) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_DATE_FORMAT1
        return self.sharedInstance.sharedDateFormat!.string(from: date as Date)
    }
    
    class func getFullDateStringFromString6(givenDate: String) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = DATE_FOR_WHOLE_APP//FULL_DATE_FORMAT2
        return self.sharedInstance.sharedDateFormat!.string(from: date as Date)
    }
    
    class func getFullDateStringFromString66(givenDate: String) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = FULL_DATE_FORMAT2
        return self.sharedInstance.sharedDateFormat!.string(from: date as Date)
    }
    
    class func getFullDateStringFromString666(givenDate: String) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = FULL_DATE_FORMAT2
        return self.sharedInstance.sharedDateFormat!.string(from: date as Date)
    }
    
    class func getFullDateStringFromString7(givenDate: String) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_DATE_FORMAT
//        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
//        self.sharedInstance.sharedDateFormat!.dateFormat = DATE_MONTH1
        self.sharedInstance.sharedDateFormat!.dateFormat = DATE_FOR_WHOLE_APP//DATE_FOR_CHAT
        return self.sharedInstance.sharedDateFormat!.string(from: date as Date)
    }
    
    class func getFullDateStringFromString77(givenDate: String) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_DATE_FORMAT
        //        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = DATE_MONTH1
        return self.sharedInstance.sharedDateFormat!.string(from: date as Date)
    }
    
    class func getFullDateStringFromString8(givenDate: String) -> Date {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        return date as Date
    }
    
    class func getFullDateStringFromString88(givenDate: String) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_DATE_FORMAT
        //        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        //        self.sharedInstance.sharedDateFormat!.dateFormat = DATE_MONTH1
        self.sharedInstance.sharedDateFormat!.dateFormat = FULL_DATE_FORMAT2
        return self.sharedInstance.sharedDateFormat!.string(from: date as Date)
    }
    
    class func getFullDateStringFromString9(givenDate: String) -> Date {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        return date as Date
    }
    
    class func getFullDateStringFromString99(givenDate: String) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = DATE_FOR_WHOLE_APP
        return self.sharedInstance.sharedDateFormat!.string(from: date as Date)
    }
    
    class func getFullDateStringFromString999(givenDate: String) -> Date {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        return date as Date
    }
    
    class func getFullDateStringFromString1(givenDate: String) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = DATE_FOR_WHOLE_APP//FULL_DATE_FORMAT1
        return self.sharedInstance.sharedDateFormat!.string(from: date as Date)
    }
    
    class func getFullDateStringFromString_new(givenDate: String) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = FULL_DATE_FORMAT1
        return self.sharedInstance.sharedDateFormat!.string(from: date as Date)
    }
    
    class func getDateFromStringInLocalTimeZone(givenDate: String) -> NSDate
    {
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        return self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
    }
    
    class func getDateFromString(givenDate: String) -> NSDate
    {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.local //NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        return self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
    }
    
    class func getDateFromString1(givenDate: String) -> NSDate
    {
        //self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        return self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
    }
    
    class func getDateFromDate(givenDate: NSDate) -> NSDate {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        let strDate: String = self.sharedInstance.sharedDateFormat!.string(from: givenDate as Date)
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        return self.sharedInstance.sharedDateFormat!.date(from: strDate)! as NSDate
    }
    
    //MARK: Timestamp Formats
    class func getTimestampUTC() -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone(name:"UTC") as TimeZone?
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        return self.sharedInstance.sharedDateFormat!.string(from: NSDate() as Date)
    }
    
    class func getTimestampFromGivenDate(givenDate: String) -> NSDate {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone(name:"UTC") as TimeZone?
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        return self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
    }
    
    //MARK: Generate Date
    class func generateDateForGivenDate(strDate: NSDate, andTime strTime: NSDate) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_DATE_FORMAT
        let dt: String = self.sharedInstance.sharedDateFormat!.string(from: strDate as Date)
        self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_TIME_FORMAT
        let tm: String = self.sharedInstance.sharedDateFormat!.string(from: strTime as Date)
        return "\(dt) \(tm)"
    }
    
    //MARK: Generate Date
    class func generateDateForGivenDateforInput1(strDate: NSDate) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_DATE//ONLY_DATE_FORMAT
        let tm: String = self.sharedInstance.sharedDateFormat!.string(from: strDate as Date)
        return "\(tm)"
    }
    
    class func generateDateForGivenDateforInput(strDate: NSDate) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_TIME_FORMAT
        let tm: String = self.sharedInstance.sharedDateFormat!.string(from: strDate as Date)
        return "\(tm)"
    }
    
    class func generateTimeForGivenDate(strDate: NSDate) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_TIME_FORMAT_12HRS
        let tm: String = self.sharedInstance.sharedDateFormat!.string(from: strDate as Date)
        return "\(tm)"
    }
    
    class func generateDateForGivenDate(strDate: NSDate) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_DATE_TIME_FORMAT
        return self.sharedInstance.sharedDateFormat!.string(from: strDate as Date)
    }
    
    class func generateDateWithFormatFromGivenDatestring(strDate: String) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: strDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = DATE_TIME_12HRS_FORMAT
        let dt: String = self.sharedInstance.sharedDateFormat!.string(from: date as Date)
        return "\(dt)"
    }
    
    class func generateDateWithFormatFromGivenDatestring1(strDate: String) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: strDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = DATE_TIME_12HRS_FORMAT
        let dt: String = self.sharedInstance.sharedDateFormat!.string(from: date as Date)
        return "\(dt)"
    }
    
    class func generateDateWithFormatFromGivenDatestring11(strDate: String) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: strDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = DATE_TIME_12HRS_FORMAT_4
        let dt: String = self.sharedInstance.sharedDateFormat!.string(from: date as Date)
        return "\(dt)"
    }
    
    class func generateDateWithFormat2FromGivenDatestring(strDate: String) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: strDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = DATE_TIME_12HRS_FORMAT_2
        let dt: String = self.sharedInstance.sharedDateFormat!.string(from: date as Date)
        return "\(dt)"
    }
    
    class func getStringDateFromFormat(str:String,toformat:String,ofdate:String) -> String
    {
       if ofdate != "0000-00-00 00:00:00"
       {
            self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
            self.sharedInstance.sharedDateFormat!.dateFormat = str
            let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: ofdate)! as NSDate
            self.sharedInstance.sharedDateFormat!.dateFormat = toformat
            let dt: String = self.sharedInstance.sharedDateFormat!.string(from: date as Date)
            return "\(dt)"
        }
        else
        {
            return ""
        }
    }
    class func generateProfileDateForGivenString(strDate: String) -> Date {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = BIRTH_DATE_FORMAT
        return self.sharedInstance.sharedDateFormat!.date(from: strDate)!
    }
    
    //MARK: Birth Date
    class func getBirthDateFromString(givenDate: String) -> NSDate {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_DATE_FORMAT
        return self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
    }
    
//    class func getBirthDateStringFromDateString(givenDate: String) -> String {
//        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
//        self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_DATE_FORMAT
//        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
//        self.sharedInstance.sharedDateFormat!.dateFormat = DIFF_DATE_FORMAT
//        return self.sharedInstance.sharedDateFormat!.string(from: date as Date)
//    }
//    
    class func getHomeDateStringFromDateString(givenDate: String) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = DIFF_DATE_FORMAT111//DIFF_DATE_FORMAT11
        return self.sharedInstance.sharedDateFormat!.string(from: date as Date)
    }
    
    class func birthdayConstraintForUser(givenDate: NSDate) -> NSDate {
        
        let dateComponents: NSDateComponents = NSDateComponents()
        dateComponents.year = -2
        
        let expirationDate = NSCalendar.current.date(byAdding: dateComponents as DateComponents, to: givenDate as Date)
        return expirationDate! as NSDate
    }
    
    class func minBirthdayConstraintForUser(givenDate: NSDate) -> NSDate {
        let dateComponents: NSDateComponents = NSDateComponents()
        dateComponents.year = -100
        let expirationDate = NSCalendar.current.date(byAdding: dateComponents as DateComponents, to: givenDate as Date)
        return expirationDate! as NSDate
    }
    
    class func minViolationDateConstraintForUser(givenDate: NSDate) -> NSDate {
        let dateComponents: NSDateComponents = NSDateComponents()
        dateComponents.year = -1
        let expirationDate = NSCalendar.current.date(byAdding: dateComponents as DateComponents, to: givenDate as Date)
        return expirationDate! as NSDate
    }
    
    class func calculateAge(birthdate: Date) -> Int {
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdate, to: now, options: [])
        let age = calcAge.year
        return age!
    }
    
    class func generateBirthDateForGivenDate(strDate: NSDate) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = BIRTH_DATE_FORMAT
        return self.sharedInstance.sharedDateFormat!.string(from: strDate as Date)
    }
    
    class func generateBirthDateForGivenFacebookDate(strDate: String) -> NSDate {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = FB_BIRTH_DATE_FORMAT
        return self.sharedInstance.sharedDateFormat!.date(from: strDate)! as NSDate
    }
    
    class func getStringDateWithSuffix1(givenDate: String) -> String {
        //Convert EEE dd MMM yyyy formate
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = DIFF_DATE_FORMAT1
        var strDate: String = self.sharedInstance.sharedDateFormat!.string(from: date as Date)
        //To get only date from string
        let monthDayFormatter: DateFormatter = DateFormatter()
        monthDayFormatter.formatterBehavior = .behavior10_4
        
        monthDayFormatter.dateFormat = "d"
        let date_day: Int = Int(monthDayFormatter.string(from: date as Date))!
        monthDayFormatter.dateFormat = "yyyy"
//        let date_year: Int = Int(monthDayFormatter.string(from: date as Date))!
//        strDate = strDate.replacingOccurrences(of: "\(date_year)", with: "")
        //Add suffix
        var suffix: NSString?
        let ones: Int = date_day % 10
        let tens: Int = (date_day / 10) % 10
        if tens == 1 {
            suffix = "th"
        }
        else if ones == 1 {
            suffix = "st"
        }
        else if ones == 2 {
            suffix = "nd"
        }
        else if ones == 3 {
            suffix = "rd"
        }
        else {
            suffix = "th"
        }
        
        let arr =  strDate.components(separatedBy: ",")
        if arr.count > 0 {
            var strdateval = arr[0]
            strdateval = strdateval.replacingOccurrences(of: "\(date_day)", with: "\(date_day)\(suffix ?? "th")")
            strDate = "\(strdateval), \(arr[1]), \(arr[2])"
        }
//        strDate = "\(strDate)\(date_year)"
//        strDate = "\(strDate)"
        return strDate
    }
    
    class func getStringDateWithSuffix(givenDate: String) -> String {
        //Convert EEE dd MMM yyyy formate
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = DIFF_DATE_FORMAT
        var strDate: String = self.sharedInstance.sharedDateFormat!.string(from: date as Date)
        //To get only date from string
        let monthDayFormatter: DateFormatter = DateFormatter()
        monthDayFormatter.formatterBehavior = .behavior10_4
        
        monthDayFormatter.dateFormat = "d"
        let date_day: Int = Int(monthDayFormatter.string(from: date as Date))!
        monthDayFormatter.dateFormat = "yyyy"
        let date_year: Int = Int(monthDayFormatter.string(from: date as Date))!
        strDate = strDate.replacingOccurrences(of: "\(date_year)", with: "")
        //Add suffix
        var suffix: NSString?
        let ones: Int = date_day % 10
        let tens: Int = (date_day / 10) % 10
        if tens == 1 {
            suffix = "th"
        }
        else if ones == 1 {
            suffix = "st"
        }
        else if ones == 2 {
            suffix = "nd"
        }
        else if ones == 3 {
            suffix = "rd"
        }
        else {
            suffix = "th"
        }
        
        strDate = strDate.replacingOccurrences(of: "\(date_day)", with: "\(date_day)\(suffix ?? "th")")
        strDate = "\(strDate)\(date_year)"
        return strDate
        
    }
    
    class func convertFaceBookDateIntoString(givenDate: String) -> String {
        
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = FB_BIRTH_DATE_FORMAT
        let date: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_DATE_FORMAT
        return self.sharedInstance.sharedDateFormat!.string(from: date as Date)
    }
    
    class func convertdateIntoArabic(givenDate: String) -> String {
        
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        
        // initialize formatter and set input date format
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // read input date string as NSDate instance
        let date = DateFormater.getDateFromString(givenDate: givenDate)
        
        // set locale to "ar_DZ" and format as per your specifications
        formatter.locale = NSLocale(localeIdentifier: "ar_DZ") as Locale?
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let outputDate = formatter.string(from: date as Date)
        
        return outputDate
    }
    
    func timeAgoSinceDate(_ dateStr:String, numericDates:Bool) -> String
    {
        let calendar = Calendar.current
        let now = NSDate()
        let currentDate = calendar.date(byAdding: .second, value: 3, to: now as Date)
        
        let date = DateFormater.getDateFromString(givenDate: dateStr)
        let earliest = (now as NSDate).earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest as Date, options: NSCalendar.Options())
        
        
        if(date.compare(currentDate! as Date) == .orderedDescending)
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM"
            return dateFormatter.string(from: date as Date)
        }
        else if(date.compare(currentDate! as Date) == .orderedSame)
        {
            return "Just now"
        }
        else
        {
            if (components.year! >= 2)
            {
                return "\(components.year!) yrs ago"
            }
            else if (components.year! >= 1)
            {
                if (numericDates)
                {
                    return "1 yr ago"
                }
                else
                {
                    return "Last year"
                }
            }
            else if (components.month! >= 2)
            {
                return "\(components.month!) mnths ago"
            }
            else if (components.month! >= 1)
            {
                if (numericDates)
                {
                    return "1 month ago"
                }
                else
                {
                    return "Last month"
                }
            }
            else if (components.weekOfYear! >= 2)
            {
                return "\(components.weekOfYear!) weeks ago"
            }
            else if (components.weekOfYear! >= 1)
            {
                if (numericDates)
                {
                    return "1 week ago"
                }
                else
                {
                    return "Last week"
                }
            }
            else if (components.day! >= 2)
            {
                return "\(components.day!) days ago"
            }
            else if (components.day! >= 1)
            {
                if (numericDates)
                {
                    return "1 day ago"
                }
                else
                {
                    return "Yesterday"
                }
            }
            else if (components.hour! >= 2)
            {
                return "\(components.hour!) hrs ago"
            }
            else if (components.hour! >= 1)
            {
                if (numericDates)
                {
                    return "1 hr ago"
                } else {
                    return "An hr ago"
                }
            }
            else if (components.minute! >= 2)
            {
                return "\(components.minute!) mins ago"
            }
            else if (components.minute! >= 1)
            {
                if (numericDates)
                {
                    return "1 min ago"
                } else {
                    return "A min ago"
                }
            }
            else if (components.second! >= 3)
            {
                return "\(components.second!) secs ago"
            }
            else
            {
                return "Just now"
            }
        }
    }
    
    class func generateMonthYearForGivenDate(strDate: NSDate) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = MONTH_YEAR
        let tm: String = self.sharedInstance.sharedDateFormat!.string(from: strDate as Date)
        return "\(tm)"
    }
    
    class func generateMonthYearForGivenDate1(strDate: NSDate) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = MONTH_YEAR//MONTH_YEAR1
        let tm: String = self.sharedInstance.sharedDateFormat!.string(from: strDate as Date)
        return "\(tm)"
    }
    
    class func generateMonthYearForGivenDate2(strDate: NSDate) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = MONTH_YEAR2
        let tm: String = self.sharedInstance.sharedDateFormat!.string(from: strDate as Date)
        return "\(tm)"
    }
    
    class func generateMonthYearForGivenDate3(strDate: NSDate) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = MONTH_YEAR//MONTH_YEAR3
        let tm: String = self.sharedInstance.sharedDateFormat!.string(from: strDate as Date)
        return "\(tm)"
    }
    
    class func generateMonthForGivenDate(strDate: NSDate) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = ONLY_MONTH
        let tm: String = self.sharedInstance.sharedDateFormat!.string(from: strDate as Date)
        return "\(tm)"
    }
    
    //MARK: ANKIT ADDED
    class func convertDateToLocalTimeZone(givenDate: String,fromFormat:String,toFormat:String) -> String {
        var final_date: String
        self.sharedInstance.sharedDateFormat!.dateFormat = fromFormat
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        //SET TIME ZONE FORMAT OF SERVER HERE
        let ts_utc: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        self.sharedInstance.sharedDateFormat!.dateFormat = toFormat
        final_date = self.sharedInstance.sharedDateFormat!.string(from: ts_utc as Date)
        return final_date
    }
    
    class func convertDateToLocalTimeZone(givenDate: String,toFormat:String) -> String {
        var final_date: String
        self.sharedInstance.sharedDateFormat!.dateFormat = GLOBAL_DATE_FORMAT
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        //SET TIME ZONE FORMAT OF SERVER HERE
        let ts_utc: NSDate = self.sharedInstance.sharedDateFormat!.date(from: givenDate)! as NSDate
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone.system
        self.sharedInstance.sharedDateFormat!.dateFormat = toFormat
        final_date = self.sharedInstance.sharedDateFormat!.string(from: ts_utc as Date)
        return final_date
    }
    
    class func getStringFromDate(givenDate: NSDate , toFormate:String) -> String {
        self.sharedInstance.sharedDateFormat!.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        self.sharedInstance.sharedDateFormat!.dateFormat = toFormate
        return self.sharedInstance.sharedDateFormat!.string(from: givenDate as Date)
    }
}
