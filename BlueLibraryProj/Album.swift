//
//  Album.swift
//  BlueLibraryProj
//
//  Created by alex livenson on 9/9/15.
//  Copyright (c) 2015 alex livenson. All rights reserved.
//

import UIKit

class Album: NSObject, NSCoding {
    let title: String
    let artist: String
    let genre: String
    let coverUrl: String
    let year: String
    
    init(title: String, artist: String, coverUrl: String, year: String, genre: String) {
        self.title = title
        self.artist = artist
        self.coverUrl = coverUrl
        self.year = year
        self.genre = genre
        
        super.init()
    }
    
    // pragma mark - NSCoding (required init cannot be in an extension)
    required convenience init?(coder aDecoder: NSCoder) {
        guard let year = aDecoder.decodeObjectForKey("year") as? String,
            let title = aDecoder.decodeObjectForKey("title") as? String,
            let artist = aDecoder.decodeObjectForKey("artist") as? String,
            let coverUrl = aDecoder.decodeObjectForKey("coverUrl") as? String,
            let genre = aDecoder.decodeObjectForKey("genre") as? String
            else {
                return nil
        }
        
        self.init(
            title: title,
            artist: artist,
            coverUrl: coverUrl,
            year: year,
            genre: genre
        )
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(year, forKey: "year")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(artist, forKey: "artist")
        aCoder.encodeObject(coverUrl, forKey: "coverUrl")
        aCoder.encodeObject(genre, forKey: "genre")
    }
}

// Album+TableRepresentation
extension Album {
    func tr_tableRepresentation() -> [String: [String]] {
        return [
            "titles" : [ "Artist", "Album", "Genre", "Year"],
            "values": [self.artist, self.title, self.genre, self.year]
        ]
    }
}