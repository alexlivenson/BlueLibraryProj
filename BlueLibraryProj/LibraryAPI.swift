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
    
    private var persistencyManager: PersistencyManager!
    private var httpClient: HTTPClient!
    private var isOnline = false
    
    override init() {
        persistencyManager = PersistencyManager()
        httpClient = HTTPClient()
    }
    
    func getAlbums() -> [Album] {
        return persistencyManager.getAlbums()
    }
    
    func addAlbum(album: Album, index: Int) {
        persistencyManager.addAlbum(album, index: index)
        
        if isOnline {
            httpClient.postRequest("/api/addAlbum", body: album.description)
        }
    }
    
    func deleteAlbumAtIndex(index: Int) {
        persistencyManager.deleteAlbum(index)
        
        if isOnline {
            httpClient.postRequest("/api/deleteAlbum", body: "\(index)")
        }
    }
}
