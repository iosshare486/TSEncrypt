# TSEncrypt





## Description

数据简单加密与解密

## Function
1. RSA私钥签名
2. AES cbc模式加密
3. URL encode & decode
4. Base64-encode & decode
5. MD5


## Usage
<pre>
	let ss = "string"
	
	// RSA 签名
	ss.ts_encrypt.RSASign(privateKey: "private key")
	
	// AES cbc模式加密
	ss.ts_encrypt.aesCBCEncrypt(key: "key", iv: "iv")
	
	// url Encode
	ss.ts_encrypt.urlEncoded()
	
	// url Encode for Alamofire
	ss.ts_encrypt.escapeForAlamofire()

	// url Decode
	ss.ts_encrypt.urlDecoded()
	
	// base64Encoding
	ss.ts_encrypt.base64Encoding()
	
	// base64Decoding
	ss.ts_encrypt.base64Decoding()
	
	// MD5
	ss.ts_encrypt.md5()
</pre>

## RSA使用资料
[iOS RSA加解密签名和验证] (https://www.jianshu.com/p/81b0b54436b8)

