//
//  EncryptionController.swift
//  LeMessenger
//
//  Created by Arthur Davletshin on 12/14/16.
//  Copyright © 2016 Kaspersky. All rights reserved.
//

import Security

class EncryptionController: NSObject {

    var publicKey: SecKey?
    var privateKey: SecKey?
    let tagPublic = "com.kaspersky.lemessenger"
    let tagPrivate = "com.kaspersky.lemessenger"
    
    static let shared : EncryptionController = {
        let instance = EncryptionController()
        return instance
    }()
    
    func generateKeyPair(completion: @escaping (SecKey?) -> Void) {
        let privateKeyAttr: [NSString: AnyObject] = [
            kSecAttrIsPermanent: kCFBooleanTrue,
            kSecAttrApplicationTag: tagPrivate as AnyObject
        ]
        let publicKeyAttr: [NSString: AnyObject] = [
            kSecAttrIsPermanent: kCFBooleanTrue,
            kSecAttrApplicationTag: tagPublic as AnyObject
        ]
        let parameters: [String: AnyObject] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits as String: 1024 as AnyObject,
            kSecPrivateKeyAttrs as String: privateKeyAttr as AnyObject,
            kSecPublicKeyAttrs as String: publicKeyAttr as AnyObject
        ]
        let status = SecKeyGeneratePair(parameters as CFDictionary, &publicKey, &privateKey)
        guard status == noErr else {
            print("SecKeyGeneratePair error: \(status.description)")
            return
        }
        completion(publicKey)
        print(publicKey)
        print("\n\n\n\n")
        print(privateKey)
    }
    
    
    func encrypt(messageData: Data!, publicKey: Data!) -> Data {
        
        return messageData
    }
    
    func decrypt(messageData: Data!) -> Data {
        
        return messageData
    }
    
}
