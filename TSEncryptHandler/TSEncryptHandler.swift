//
//  TSEncryptHandler.swift
//  TSEncrypt
//
//  Created by 彩球 on 2018/6/21.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit
import SwiftyRSA


public protocol TSEncryptCompatible {
    
    associatedtype Compatible
    var ts: Compatible { get }
    
}

extension String: TSEncryptCompatible {
    
    public var ts: TSEncryptString {
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
    public func aesCBCEncrypt(key: String, iv: String?) -> String? {
        guard let encryptData = self.base.aesCBCEncrypt(key, iv: iv) else {
            debugPrint("encry error")
            return nil
        }
        return encryptData.base64String
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
        let encodeUrlString = self.base.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        
        let tmpString = encodeUrlString!.replacingOccurrences(of: "/", with: "%2f")
        let resultString = (tmpString as NSString).replacingOccurrences(of: "+", with: "%2b")
        return resultString
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


