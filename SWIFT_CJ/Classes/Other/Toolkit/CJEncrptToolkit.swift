//
//  CJEncrptToolkit.swift
//  SWIFT_CJ
//
//  Created by CoderChenJun on 2018/4/17.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation
import UIKit

class CJEncrptToolkit: NSObject {
    
    public static func getMD5UppercaseFromString(_ string: String) -> String {
        let str = string.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(string.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02X", result[i])
        }
        //result.deinitialize()
        result.deinitialize(count: digestLen)
        return String(format: hash.uppercased as String)
    }
    public static func getMD5LowerCaseFromString(_ string: String) -> String {
        let str = string.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(string.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02X", result[i])
        }
        //result.deinitialize()
        result.deinitialize(count: digestLen)
        return String(format: hash.lowercased as String)
    }
    
    
    
    
    
    
    
    
    /**
     *  string -> base64String
     */
    public static func base64Encrption(_ stringEncrption: String?) -> String? {
        let data: Data? = stringEncrption?.data(using: .utf8)
        return data?.base64EncodedString(options: [])
    }
    /**
     *  base64String -> string
     */
    public static func base64Decoded(_ stringDecoded: String?) -> String? {
        if stringDecoded != nil {
            let data = Data(base64Encoded: stringDecoded ?? "", options: [])
            var decodedString: String? = nil
            if let aData = data {
                decodedString = String(data: aData, encoding: .utf8)
            }
            return decodedString
        }
        return nil
    }
    
    
    
    
    
    
    /**
     *  image -> base64String
     */
    public static func base64Encrption(_ imageEncrption: UIImage?) -> String? {
        guard let imageData = UIImagePNGRepresentation(imageEncrption!) else {
            return nil
        }
        return imageData.base64EncodedString(options: .endLineWithLineFeed)
    }
    /**
     * base64String -> image
     */
    public static func base64Decoded(imageDecoded: String?) -> UIImage? {
        if NSString.isBlankString(imageDecoded) {
            return nil
        } else {
            let imageData = Data(base64Encoded: imageDecoded ?? "", options: .ignoreUnknownCharacters)
            if let aData = imageData {
                return UIImage(data: aData)
            }
            return nil
        }
    }

    
    
    
    
    
    /**
     *  dictionary -> string
     */
    public static func getJSONStringFromDictionary(_ dictionary: NSDictionary) -> String {
        
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try! JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData?
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
    /**
     *  string -> dictionary
     */
    public static func getDictionaryFromJSONString(_ jsonString: String?) -> NSDictionary {
        
        let jsonData: Data = jsonString!.data(using: .utf8)!
        
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
    
    
    
    
    
    
    /**
     *  array -> string
     */
    public static func getJSONStringFromArray(_ array: NSArray) -> String {
        
        if (!JSONSerialization.isValidJSONObject(array)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try! JSONSerialization.data(withJSONObject: array, options: []) as NSData?
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
    /**
     *  string -> array
     */
    public static func getArrayFromJSONString(_ jsonString: String?) -> NSArray {
        
        let jsonData:Data = jsonString!.data(using: .utf8)!
        
        let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if array != nil {
            return array as! NSArray
        }
        return NSArray()
    }
    
    
    
    
    
    
    /**
     *  data -> string
     */
    public static func getJSONStringFromData(_ data: NSData?) -> String? {
        return String(data: data! as Data, encoding: .utf8)
        //return (NSString(data: data! as Data, encoding: String.Encoding.utf8.rawValue))! as String // UTF8转String
    }
    /**
     *  string -> data
     */
    public static func getDataFromJSONString(_ jsonString: String?) -> NSData? {
        if NSString.isBlankString(jsonString) {
            return nil
        } else {
            return jsonString!.data(using: String.Encoding.utf8)! as NSData // String转UTF8
        }
    }
    
    
    
    
    
    
    
    
    
    
}








