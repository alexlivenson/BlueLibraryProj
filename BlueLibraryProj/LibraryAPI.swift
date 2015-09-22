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
    private let notificationCenter = NSNotificationCenter.defaultCenter()
    
    override init() {
        super.init()
        
        persistencyManager = PersistencyManager()
        httpClient = HTTPClient()
        
        notificationCenter
            .addObserver(
                self,
                selector: "downloadImage:",
                name: "BLDownloadImageNotification",
                object: nil)
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
    
    func downloadImage(notification: NSNotification) {
        let imageView: UIImageView = notification.userInfo?["imageView"] as! UIImageView
        let coverUrl: String = notification.userInfo?["coverUrl"] as! String
        
        let url = NSURL(fileURLWithPath: coverUrl)
        imageView.image = persistencyManager.getImage(url.lastPathComponent!)
        
        if imageView.image == nil {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                let image = self.httpClient.downloadImage(coverUrl)
                
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    imageView.image = image
                    if let _image = image {
                        self.persistencyManager.saveImage(_image, filename: url.lastPathComponent!)
                    }
                })
            }
        }
    }
    
    func saveAlbums() {
        persistencyManager.saveAlbums()
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
}
