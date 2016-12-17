//
//  SwiftRequest.swift
//  SwiftRequestTest
//
//  Created by Ricky Robinett on 6/20/14.
//  Copyright (c) 2015 Ricky Robinett. All rights reserved.
//

import Foundation

public class SwiftRequest {
    var session = URLSession.shared
    
    public init() {
        // we should probably be preparing something here...
    }
    
    // GET requests
    public func get(url: String, auth: [String: String] = [String: String](), params: [String: String] = [String: String](), callback: ((_ err: NSError?, _ response: HTTPURLResponse?, _ body: AnyObject?)->())? = nil) {
        let qs = dictToQueryString(data: params)
        request(options: ["url" : url, "auth" : auth, "querystring": qs ], callback: callback )
    }
    
    // POST requests
    public func post(url: String, data: [String: String] = [String: String](), auth: [String: String] = [String: String](), callback: ((_ err: NSError?, _ response: HTTPURLResponse?, _ body: AnyObject?)->())? = nil) {
        let qs = dictToQueryString(data: data)
        request(options: ["url": url, "method" : "POST", "body" : qs, "auth" : auth] , callback: callback)
    }
    
    // Actually make the request
    func request(options: [String: Any], callback: ((_ err: NSError?, _ response: HTTPURLResponse?, _ body: AnyObject?)->())?) {
        if( options["url"] == nil ) { return }
        
        var urlString = options["url"] as! String
        if( options["querystring"] != nil && (options["querystring"] as! String) != "" ) {
            let qs = options["querystring"] as! String
            urlString = "\(urlString)?\(qs)"
        }
        
        let url = NSURL(string:urlString)
        let urlRequest = NSMutableURLRequest(url: url! as URL)
        
        if( options["method"] != nil) {
            urlRequest.httpMethod = options["method"] as! String
        }
        
        if( options["body"] != nil && options["body"] as! String != "" ) {
            var postData = (options["body"] as! String).data(using: String.Encoding.ascii, allowLossyConversion: true)
            urlRequest.httpBody = postData
            urlRequest.setValue("\(postData!.count)", forHTTPHeaderField: "Content-length")
        }
        
        // is there a more efficient way to do this?
        if( options["auth"] != nil && (options["auth"] as! [String: String]).count > 0) {
            var auth = options["auth"] as! [String: String]
            if( auth["username"] != nil && auth["password"] != nil ) {
                let username = auth["username"]
                let password = auth["password"]
               // var authEncoded = "\(username!):\(password!)".dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)!.base64EncodedStringWithOptions(NSData.Base64EncodingOptions.allZeros);
                let authEncoded = "\(username!):\(password!)".data(using: String.Encoding.ascii, allowLossyConversion: true)!.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
              //  print(username)
            //    print(password)
                print(authEncoded.characters)
                let authValue = "Basic \(authEncoded)"
                urlRequest.setValue(authValue, forHTTPHeaderField: "Authorization")
            }
        }
        
        let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: {body, response, err  in
            let resp = response as! HTTPURLResponse?
            
            if( err == nil) {
                if(response?.mimeType == "text/html") {
                    let bodyStr = NSString(data: body!, encoding:String.Encoding.utf8.rawValue)
                    return callback!(err as NSError?, resp, bodyStr)
                } else if(response?.mimeType == "application/json") {
//                    let localError: NSError?
                    var json:AnyObject?
                    do {
                        json = try JSONSerialization.jsonObject(with: body! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    }catch{
                        print(err ?? "hello")
                    }
                    return callback!(err as NSError?, resp, json);
                }
            }
            
            return callback!(err as NSError?, resp, body as AnyObject?)
        })
        
        task.resume()
    }
    
    func request(url: String, callback: ((_ err: NSError?, _ response: HTTPURLResponse?, _ body: AnyObject?)->())? = nil) {
        request(options: ["url" : url ], callback: callback )
    }

    private func dictToQueryString(data: [String: String]) -> String {

        var qs = ""
        for (key, value) in data {
            let encodedKey = encode(value: key)
            let encodedValue = encode(value: value)
            qs += "\(encodedKey)=\(encodedValue)&"
        }
        return qs
    }
    
    private func encode(value: String) -> String {
        let queryCharacters =  NSCharacterSet(charactersIn:" =\"#%/<>?@\\^`{}[]|&+").inverted
        
     //   let encodedValue:String =  value.stringByAddingPercentEncodingWithAllowedCharacters(queryCharacters)!
        let encodedValue:String = value.addingPercentEncoding(withAllowedCharacters: queryCharacters)!
        return encodedValue
    }
}
