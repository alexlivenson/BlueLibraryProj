//
//  LibraryAPI.swift
//  BlueLibraryProj
//
//  Created by alex livenson on 9/9/15.
//  Copyright (c) 2015 alex livenson. All rights reserved.
//

import UIKit

class LibraryAPI: NSObject {
    class var sharedInstance: LibraryAPI {
        struct Static {
            static let sharedInstance: LibraryAPI = LibraryAPI()
        }
        return Static.sharedInstance
    }
}
