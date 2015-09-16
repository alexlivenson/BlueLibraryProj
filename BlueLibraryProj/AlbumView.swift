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
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
