//
//  Conekta.swift
//
//  Created by Felipe Díaz on 19/06/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class Conekta: NSObject
{
    //MARK: - Constantes, Propiedades
    let baseURL = "https://api.conekta.io"
    var publicKey:String = "key_KJysdbf6PotS2ut2"
    
    var delegate:UIViewController?
    
    var currentCard:ConektaCard?
    
    private var _deviceFingerprint:String?
    var deviceFingerprint:String?
    {
        get
        {
            if _deviceFingerprint == nil
            {
                let uuid = UIDevice.current.identifierForVendor?.uuidString
                _deviceFingerprint = uuid?.replacingOccurrences(of: "-", with: "")
            }
            
            return _deviceFingerprint
        }
    }
    
    //MARK: - Init
    init(currentDelegate:UIViewController, apiKEY: String)
    {
        self.publicKey = apiKEY
        self.delegate = currentDelegate
    }
    
    //MARK: - Funciones Auxiliares
    func collectDevice()
    {
        let htmlString = String(format: "<html style=\"background: blue;\"><head></head><body><script type=\"text/javascript\" src=\"https://conektaapi.s3.amazonaws.com/v0.5.0/js/conekta.js\" data-conekta-public-key=\"%@\" data-conekta-session-id=\"%@\"></script></body></html>", self.publicKey, self.deviceFingerprint ?? "")
        
        let webView = UIWebView(frame: CGRect.zero)
        webView.loadHTMLString(htmlString, baseURL: nil)
        webView.scalesPageToFit = true
        
        self.delegate?.view.addSubview(webView)
    }
    
    func generateToken(successBlock: @escaping (Dictionary<String, Any>) -> Void, errorBlock: @escaping (Error) -> Void)
    {
        let urlString = String(format: "%@/tokens", self.baseURL)
        let url = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "POST"
        urlRequest.addValue(String(format: "Basic %@", self.apiKeyBase64()), forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.addValue("application/vnd.conekta-v0.3.0+json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("{\"agent\":\"Conekta iOS SDK\"}", forHTTPHeaderField: "Conekta-Client-User-Agent")
        
        urlRequest.httpBody = self.currentCard!.generateJSONDataUsing(deviceFingerprint: self.deviceFingerprint!)
        
        let task = URLSession.shared.dataTask(with: urlRequest)
        { (data:Data?, respose:URLResponse?, error:Error?) in
            if error != nil
            {
                errorBlock(error!)
                return
            }
            
            let dictionary = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
            successBlock(dictionary!)
        }
        
        task.resume()
    }
    
    private func apiKeyBase64() -> String
    {
        let plainData = self.publicKey.data(using: String.Encoding.utf8)
        let dataBase64 = plainData?.base64EncodedData(options: Data.Base64EncodingOptions.lineLength64Characters)
        return String(data: dataBase64!, encoding: String.Encoding.utf8)!
    }
}
