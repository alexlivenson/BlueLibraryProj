//
//  HTTPClient.swift
//  BlueLibraryProj
//
//  Created by alex livenson on 9/9/15.
//  Copyright (c) 2015 alex livenson. All rights reserved.
//

import UIKit

class HTTPClient: NSObject {

    func getRequest(url: String) -> AnyObject? {
        return nil
    }
    
    func postRequest(url: String, body: String) -> AnyObject? {
        return nil
    }
    
    func downloadImage(url: String) -> UIImage? {
        if let nsUrl = NSURL(string: url) {
            if let data = NSData(contentsOfURL: nsUrl) {
                return UIImage(data: data)
            }
        }
        
        return nil
    }
}
