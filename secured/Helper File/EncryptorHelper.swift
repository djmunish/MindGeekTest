//
//  EncryptorHelper.swift
//  secured
//
//  Created by Ankur Sehdev on 21/03/20.
//  Copyright © 2020 Munish. All rights reserved.
//

import UIKit
import Foundation
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG


enum defaultsKey:String{
    case encryptedPasscode = "encryptedPasscode"
    case passcodeStatus = "passcodeStatus"
    case passcodeType = "passcodeType"
    case timestampPasscode = "timestampPasscode"

}

class EncryptorHelper: NSObject {
    class func MD5(string: String) -> String {
            let length = Int(CC_MD5_DIGEST_LENGTH)
            let messageData = string.data(using:.utf8)!
            var digestData = Data(count: length)

            _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
                messageData.withUnsafeBytes { messageBytes -> UInt8 in
                    if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                        let messageLength = CC_LONG(messageData.count)
                        CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                    }
                    return 0
                }
            }
            return digestData.base64EncodedString()
        }
}

