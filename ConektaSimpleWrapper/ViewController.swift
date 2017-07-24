//
//  ViewController.swift
//  ConektaSimpleWrapper
//
//  Created by Felipe Díaz on 24/07/17.
//  Copyright © 2017 FDM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let conektaAPI = Conekta(currentDelegate: self, apiKEY: "key_AAABBBCCCDDDEEEFFFGGGHHH")
        conektaAPI.collectDevice()
        conektaAPI.currentCard = ConektaCard(number: "CARD_NUMBER",
                                             andName: "CARD_HOLDER_NAME",
                                             securityCode: "SECURITY_CODE",
                                             expMonth: "EXPIRATION_MONTH",
                                             expYear: "EXPIRATION_YEAR")
        
        conektaAPI.generateToken(successBlock:
            { (data:Dictionary<String, Any>) in
                let token = data["id"] as? String
        }, errorBlock: { (error:Error) in
            print("This will fail: \(error.localizedDescription)")
        })

    }


}

