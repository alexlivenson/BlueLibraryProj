//
//  AlbumView.swift
//  BlueLibraryProj
//
//  Created by alex livenson on 9/9/15.
//  Copyright (c) 2015 alex livenson. All rights reserved.
//

import UIKit

class AlbumView: UIView {
    
    private var coverImage: UIImageView!
    private var indicator: UIActivityIndicatorView!
    private let notificationCenter = NSNotificationCenter.defaultCenter()
    private let imageKeyPath = "image"

    init(frame: CGRect, albumCover: String) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.blackColor()
        
        // This will give the coverImage 5px margin
        coverImage = UIImageView(frame: CGRectMake(5, 5, frame.size.width - 10, frame.size.height - 10))
        addSubview(coverImage)
        
        indicator = UIActivityIndicatorView()
        indicator.center = center
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        indicator.startAnimating()
        addSubview(indicator)
        
        // KVO
        coverImage.addObserver(
            self,
            forKeyPath: imageKeyPath,
            options: NSKeyValueObservingOptions.Prior,
            context: nil)
        
        // Create notification
        let userInfo = [
            "imageView": coverImage,
            "coverUrl": albumCover
        ]
        
        notificationCenter
            .postNotificationName(
                "BLDownloadImageNotification",
                object: self,
                userInfo: userInfo)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        coverImage.removeObserver(self, forKeyPath: imageKeyPath)
        
    }
    
    // Must implement this method for every class acting as observer
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if let path = keyPath {
            if path == imageKeyPath {
                indicator.stopAnimating()
            }
        }
    }
}
