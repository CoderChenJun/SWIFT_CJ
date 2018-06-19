//
//  CJValidateToolkit.swift
//  SWIFT_CJ
//
//  Created by CoderChenJun on 2018/4/13.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation
import UIKit

class CJValidateToolkit: NSObject {
    
    
    
    /**
     *  验证是否为纯中文
     *
     *  @param chinese 需要验证的 字符串
     *  @return YES为纯中文，NO则不是纯中文
     */
    public static func isValidatePureChinese(_ chinese: String?) -> Bool {
        let regex = "[\u{4e00}-\u{9fa5}]+"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        if !pred.evaluate(with: chinese) {
            //CJLog(@"非纯中文");// 非纯中文
            return false
        } else {
            //CJLog(@"纯中文");// 纯中文
            return true
        }
    }
    
    
    
    /**
     *  验证是否为纯数字
     *
     *  @param str 待验证的字符串
     *
     *  @return YES表示str为纯数字，NO表示str不是纯数字
     */
    public static func isValidatePureNumber(_ str: String?) -> Bool {
        let afterTrim = str?.trimmingCharacters(in: CharacterSet.decimalDigits)
        if (afterTrim?.count ?? 0) == 0 {
            return true
        } else {
            return false
        }
    }
    
    
    
    /**
     *  验证字符串是否包含除英文字母和数字之外的字符
     *
     *  @param str 待验证的字符串
     *
     *  @return YES表示str只包含英文字母与数字，NO反之
     */
    public static func isValidateAlphaAndNumberic(_ str: String?) -> Bool {
        let afterTrim = str?.trimmingCharacters(in: CharacterSet.alphanumerics)
        return (afterTrim?.count ?? 0) == 0 ? true : false
    }
    
    
    
    /**
     *  验证电子邮箱Email格式是否正确
     *
     *  @param email 待验证的字符串
     *
     *  @return YES表示为格式正确的电子邮箱，NO表示电子邮箱格式错误
     */
    public static func isValidateEmailFormat(_ email: String?) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    
    
    /**
     *  验证中国手机号，支持验证中国移动：China，中国联通：China以及中国电信：China
     *
     *  @param phoneNumber 需要验证的手机号码
     *
     *  @return yes为合法的手机号，no为不合法的手机号
     */
    public static func isValidatePhoneNumber(_ phoneNumber: String?) -> Bool {
        var moblieNum: String
        if Int((phoneNumber as NSString?)?.range(of: " ").location ?? 0) != NSNotFound {
            moblieNum = phoneNumber?.uppercased().replacingOccurrences(of: " ", with: "") ?? ""
        } else {
            moblieNum = phoneNumber ?? ""
        }
        let All = "^[1][3,4,5,6,7,8][0-9]{9}$"
        let regextestAll = NSPredicate(format: "SELF MATCHES %@", All)
        if regextestAll.evaluate(with: moblieNum) == true {
            return true
        } else {
            return false
        }
    }
    
    
    
    /**
     *  判断输入的ip地址的合法性
     *
     *  @param ipAddress ip地址
     *  @return 正确or错误
     */
    public static func isValidateIPAddress(_ ipAddress: String?) -> Bool {
        let urlRegEx = """
        ^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.\
        ([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.\
        ([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.\
        ([01]?\\d\\d?|2[0-4]\\d|25[0-5])$
        """
        let urlTest = NSPredicate(format: "SELF MATCHES %@", urlRegEx)
        return urlTest.evaluate(with: ipAddress)
    }
    
    
    
    
//    void (^)(AFHTTPRequestOperation *operation, id responseObject)
    
    
    
    /**
     *  验证身份证号码格式
     *
     *  @param value 待验证的字符串
     *
     *  @return YES表示是格式正确的身份证号码，NO表示不是格式正确的数字
     */
    public static func isValidateIDCardNumber(_ sfz: String?) -> Bool {
        
        let value = sfz?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        var length = 0
        if value == ""{
            return false
        } else {
            length = (value?.count)!
            if length != 15 && length != 18 {
                return false
            }
        }
        
        //省份代码
        let arearsArray = ["11","12", "13", "14",  "15", "21",  "22", "23",  "31", "32",  "33", "34",  "35", "36",  "37", "41",  "42", "43",  "44", "45",  "46", "50",  "51", "52",  "53", "54",  "61", "62",  "63", "64",  "65", "71",  "81", "82",  "91"]
        let valueStart2 = (value! as NSString).substring(to: 2)
        var arareFlag = false
        if arearsArray.contains(valueStart2){
            
            arareFlag = true
        }
        if !arareFlag{
            return false
        }
        var regularExpression = NSRegularExpression()
        
        var numberofMatch = Int()
        var year = 0
        switch (length){
        case 15:
            year = Int((value! as NSString).substring(with: NSRange(location:6,length:2)))!
            if year%4 == 0 || (year%100 == 0 && year%4 == 0){
                do{
                    regularExpression = try NSRegularExpression.init(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$", options: .caseInsensitive) //检测出生日期的合法性
                    
                }catch{
                    
                    
                }
                
                
            }else{
                do{
                    regularExpression =  try NSRegularExpression.init(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$", options: .caseInsensitive) //检测出生日期的合法性
                    
                }catch{}
            }
            
            numberofMatch = regularExpression.numberOfMatches(in: value!, options: .reportProgress, range: NSRange(location: 0, length: (value?.count)!))

            
            
            if(numberofMatch > 0) {
                return true
            }else {
                return false
            }
            
        case 18:
            year = Int((value! as NSString).substring(with: NSRange(location:6,length:4)))!
            if year%4 == 0 || (year%100 == 0 && year%4 == 0){
                do{
                    regularExpression = try NSRegularExpression.init(pattern: "^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$", options: .caseInsensitive) //检测出生日期的合法性
                    
                }catch{
                    
                }
            }else{
                do{
                    regularExpression =  try NSRegularExpression.init(pattern: "^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$", options: .caseInsensitive) //检测出生日期的合法性
                    
                }catch{}
            }
            
//            numberofMatch = regularExpression.numberOfMatchesInString(value, options:NSMatchingOptions.ReportProgress, range: NSMakeRange(0, value.characters.count))
            numberofMatch = regularExpression.numberOfMatches(in: value!, options: .reportProgress, range: NSRange(location: 0, length: (value?.count)!))
            
            if(numberofMatch > 0) {
                let s =
                        (Int((value! as NSString).substring(with: NSRange(location:0,length:1)))! +
                         Int((value! as NSString).substring(with: NSRange(location:10,length:1)))!) * 7 +
                        (Int((value! as NSString).substring(with: NSRange(location:1,length:1)))! +
                         Int((value! as NSString).substring(with: NSRange(location:11,length:1)))!) * 9 +
                        (Int((value! as NSString).substring(with: NSRange(location:2,length:1)))! +
                         Int((value! as NSString).substring(with: NSRange(location:12,length:1)))!) * 10 +
                        (Int((value! as NSString).substring(with: NSRange(location:3,length:1)))! +
                         Int((value! as NSString).substring(with: NSRange(location:13,length:1)))!) * 5 +
                        (Int((value! as NSString).substring(with: NSRange(location:4,length:1)))! +
                         Int((value! as NSString).substring(with: NSRange(location:14,length:1)))!) * 8 +
                        (Int((value! as NSString).substring(with: NSRange(location:5,length:1)))! +
                         Int((value! as NSString).substring(with: NSRange(location:15,length:1)))!) * 4 +
                        (Int((value! as NSString).substring(with: NSRange(location:6,length:1)))! +
                         Int((value! as NSString).substring(with: NSRange(location:16,length:1)))!) *  2 +
                        Int((value! as NSString).substring(with: NSRange(location:7,length:1)))! * 1 +
                        Int((value! as NSString).substring(with: NSRange(location:8,length:1)))! * 6 +
                        Int((value! as NSString).substring(with: NSRange(location:9,length:1)))! * 3
                
                let Y = s%11
                var M = "F"
                let JYM = "10X98765432"
                
                M = (JYM as NSString).substring(with: NSRange(location:Y,length:1))
                if M == (value! as NSString).substring(with: NSRange(location:17,length:1))
                {
                    return true
                }else{return false}
                
                
            }else {
                return false
            }
            
        default:
            return false
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}




















