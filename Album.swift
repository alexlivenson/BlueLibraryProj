//
//  Album.swift
//  BlueLibraryProj
//
//  Created by alex livenson on 9/9/15.
//  Copyright (c) 2015 alex livenson. All rights reserved.
//

import UIKit

class Album: NSObject {
    let title: String
    let artist: String
    let genre: String
    let coverUrl: String
    let year: String
   
    init(title: String, artist: String, coverUrl: String, year: String) {
        self.title = title
        self.artist = artist
        self.coverUrl = coverUrl
        self.year = year
        self.genre = "Pop"
    }
}
