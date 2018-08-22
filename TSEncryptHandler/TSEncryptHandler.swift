//
//  TSEncryptHandler.swift
//  TSEncrypt
//
//  Created by 彩球 on 2018/6/21.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit
import SwiftyRSA
import CryptoSwift


public protocol TSEncryptCompatible {
    
    associatedtype Compatible
    var ts_encrypt: Compatible { get }
    
}

extension String: TSEncryptCompatible {
    
    public var ts_encrypt: TSEncryptString {
        get { return TSEncryptString(self) }
    }
}


public final class TSEncryptString {
    
    private let base: String
    public init (_ base: String) {
        self.base = base
    }
    
}

public extension TSEncryptString {
    
    // MARK: - RSA
    
    /// RSA签名
    ///
    /// - Parameter privateKey: 私钥
    /// - Returns: 签名后字符串数据
    public func RSASign(privateKey: String) -> String? {
        
        guard  let privateKey = try?PrivateKey(pemEncoded: privateKey) else {
            debugPrint("TSEncryptHandler: private key is invalid")
            return nil
        }
        guard let clearMsg = try?ClearMessage(string: self.base, using: .utf8)  else {
            debugPrint("TSEncryptHandler: content transfer data get error")
            return nil
        }
        guard let signature = try?clearMsg.signed(with: privateKey, digestType: .sha1) else {
            debugPrint("TSEncryptHandler: sign error")
            return nil
        }
        return signature.base64String
    }
    
    // MARK: - AES
    
    /// AES加密 CBC模式
    ///
    /// - Parameters:
    ///   - key: 解密 key
    ///   - iv: iv
    /// - Returns: 加密后数据
    public func aesCBCEncrypt(key: String, iv: String) -> String? {
        return TS_AES.Endcode_AES_CBC(strToEncode: self.base, key: key, iv: iv)
    }
    
    
    
    // MARK: - Base64 Encode&Decode
    /// encode Base64
    public func base64Encoding() -> String
    {
        let plainData = self.base.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        return base64String!
    }
    /// decode Base64
    public func base64Decoding()->String {
        
        let decodedData = NSData(base64Encoded: self.base, options: NSData.Base64DecodingOptions.init(rawValue: 0))
        let decodedString = NSString(data: decodedData! as Data, encoding: String.Encoding.utf8.rawValue)! as String
        return decodedString
    }
    
    // MARK: - URL Encode&Decode
    
    /// 将原始的url编码为合法的url
    public func urlEncoded() -> String {
        if let encodeUrlString = self.base.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed) {
            let resultString = encodeUrlString.replacingOccurrences(of: "+", with: "%2b").replacingOccurrences(of: "/", with: "%2f").replacingOccurrences(of: "=", with: "%3d")
            return resultString
        } else {
            return ""
        }
        
    }
    
    /// 将编码后的url转换回原始的url
    public  func urlDecoded() -> String {
        return self.base.removingPercentEncoding ?? ""
    }
    
    /// MD5加密
    
    public func md5() -> String {
        return MD5(self.base)
    }
}


class TS_AES: NSObject {
    
    //  MARK:  AES-CBC加密
    class func Endcode_AES_CBC(strToEncode:String, key: String, iv: String) -> String? {
        // 从String 转成data
        let data = strToEncode.data(using: String.Encoding.utf8)
        
        guard data != nil else {
            debugPrint("string to data is error")
            return nil
        }
        // byte 数组
        var encrypted: [UInt8] = []
        let cbc_iv = CBC(iv: Array(iv.utf8))
        let cbc_key = Array(key.utf8)
        do {
            encrypted = try AES(key: cbc_key, blockMode: cbc_iv, padding: .pkcs7).encrypt(data!.bytes)
        } catch {
            debugPrint("encrypt is error")
        }
        
        let encoded =  Data(encrypted)
        //加密结果要用Base64转码
        return encoded.base64EncodedString()
    }
    
    //  MARK:  AES-CBC解密
    class func Decode_AES_CBC(strToDecode:String, key: String, iv: String)->String {
        //decode base64
        let data = NSData(base64Encoded: strToDecode, options: NSData.Base64DecodingOptions.init(rawValue: 0))
        
        // byte 数组
        var encrypted: [UInt8] = []
        let count = data?.length
        
        // 把data 转成byte数组
        for i in 0..<count! {
            var temp:UInt8 = 0
            data?.getBytes(&temp, range: NSRange(location: i,length:1 ))
            encrypted.append(temp)
        }
        // decode AES
        var decrypted: [UInt8] = []
        let cbc_iv = CBC(iv: Array(iv.utf8))
        let cbc_key = Array(key.utf8)
        do {
            decrypted = try AES(key: cbc_key, blockMode: cbc_iv, padding: .pkcs7).decrypt(encrypted)
        } catch {
            debugPrint("decrypted is error")
        }
        
        // byte 转换成NSData
        let encoded = Data(decrypted)
        var str = ""
        //解密结果从data转成string
        str = String(bytes: encoded.bytes, encoding: .utf8)!
        return str
    }
}


