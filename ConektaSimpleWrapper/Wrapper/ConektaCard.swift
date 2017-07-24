//
//  ConektaCard.swift
//
//  Created by Felipe Díaz on 19/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class ConektaCard: NSObject
{
    let resourceURL:String = "/cards"
    
    var cardNumber:String
    var holderName:String
    var securityCode:String
    var expirationMonth:String
    var expirationYear:String
    
    init(number:String, andName name:String, securityCode: String, expMonth:String, expYear:String)
    {
        self.cardNumber = number
        self.holderName = name
        self.securityCode = securityCode
        self.expirationMonth = expMonth
        self.expirationYear = expYear
    }

    func generateJSONDataUsing(deviceFingerprint:String) -> Data
    {
        let stringJSON:String = "{\"card\":{\"name\": \"\(self.holderName)\", \"number\":  \"\(self.cardNumber)\", \"cvc\": \"\(self.securityCode)\", \"exp_month\":  \"\(self.expirationMonth)\", \"exp_year\": \"\(self.expirationYear)\", \"device_fingerprint\": \"\(deviceFingerprint)\" } }"
        
        return stringJSON.data(using: .utf8, allowLossyConversion: true)!
    }
}
