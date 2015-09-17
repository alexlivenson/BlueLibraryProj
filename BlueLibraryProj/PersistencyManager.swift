//
//  PersistencyManager.swift
//  BlueLibraryProj
//
//  Created by alex livenson on 9/9/15.
//  Copyright (c) 2015 alex livenson. All rights reserved.
//

import UIKit

class PersistencyManager: NSObject {
    
    private var albums: [Album]
    
    override init() {
        albums = [
            Album(title: "Best of Bowie", artist: "David Bowie", coverUrl: "http://s3.amazonaws.com/CoverProject/album/album_david_bowie_pin_ups.png", year: "1992"),
            Album(title: "It's My Life", artist: "No Doubt", coverUrl: "https://upload.wikimedia.org/wikipedia/en/9/93/ItsMyLifeNoDoubtCover.jpg", year: "2003"),
            Album(title: "Nothing Like The Sun", artist: "Sting", coverUrl: "https://upload.wikimedia.org/wikipedia/en/3/30/%E2%80%A6Nothing_Like_the_Sun_(Sting_album_-_cover_art).jpg", year: "1999"),
            Album(title: "Staring at the Sun", artist: "U2", coverUrl: "http://media.u2.com/non_secure/images/20090218/discography/staring_at_the_sun2/600.jpg", year: "2000"),
            Album(title: "American Pie", artist: "Madonna", coverUrl: "http://www.billboard.com/files/styles/promo_650/public/media/madonna-american-pie-video-billboard-650.jpg", year: "2000")
        ]
    }
   
    func getAlbums() -> [Album] {
        return albums
    }
    
    func addAlbum(album: Album, index: Int) {
        if albums.count >= index {
            albums.insert(album, atIndex: index)
        } else {
            albums.append(album)
        }
    }
    
    func deleteAlbum(index: Int) {
        albums.removeAtIndex(index)
    }
    
    func saveImage(image: UIImage, filename: String) {
        let fname = NSHomeDirectory() + "/Documents/" + filename
        let data: NSData? = UIImagePNGRepresentation(image)
        data?.writeToFile(fname, atomically: true)
    }
    
    func getImage(filename: String) -> UIImage? {
        let fname = NSHomeDirectory() + "/Documents/" + filename
        let data: NSData? = NSData(contentsOfFile: fname)
        
        if let _data = data {
            return UIImage(data: _data)
        }
        
        return nil
    }
    
}
