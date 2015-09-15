//
//  ViewController.swift
//  BlueLibraryProj
//
//  Created by alex livenson on 9/9/15.
//  Copyright (c) 2015 alex livenson. All rights reserved.
//

import UIKit

// TODO: Alex L create a view controller with a view that has a table view
class ViewController: UIViewController {
    
    private var dataTable: UITableView!
    private var allAlbums: [Album] = []
    private var currentAlbumData: [String: [String]]?
    private var currentAlbumIndex = 0
    private var scroller: HorizontalScroller!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.76, green: 0.81, blue: 0.87, alpha: 1)
        allAlbums = LibraryAPI.sharedInstance.getAlbums()
        
        // create data table
        let tableFrame = CGRectMake(0, 120, self.view.frame.width, self.view.frame.height - 120)
        dataTable = UITableView(frame: tableFrame, style: UITableViewStyle.Grouped)
        dataTable.delegate = self
        dataTable.dataSource = self
        dataTable.backgroundView = nil
        
        // create scroller 
        let scrollerFrame = CGRectMake(0, 20, self.view.frame.size.width, 130)
        scroller = HorizontalScroller(frame: scrollerFrame)
        scroller.backgroundColor = UIColor(red: 0.24, green: 0.35, blue: 0.49, alpha: 1)
        scroller.delegate = self
        
        view.addSubview(dataTable)
        view.addSubview(scroller)
        
        showDataForAlbumAtIndex(currentAlbumIndex)
        reloadScroller()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadScroller() {
        allAlbums = LibraryAPI.sharedInstance.getAlbums()
        
        if currentAlbumIndex < 0 {
            currentAlbumIndex = 0
        } else if (currentAlbumIndex >= allAlbums.count) {
            currentAlbumIndex = allAlbums.count - 1
        }
        
        scroller?.reload()
        showDataForAlbumAtIndex(currentAlbumIndex)
    }
}

// pragma mark - UITableViewDelegate, UITableViewDataSource methods
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let titles: [String] = currentAlbumData?["titles"] {
            return titles.count
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        
        var cell = tableView .dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
        }
        
        if let array = currentAlbumData?["titles"] as [String]? {
            cell?.textLabel?.text = array[indexPath.row]
        }
        
        if let array = currentAlbumData?["values"] as [String]? {
            cell?.detailTextLabel?.text = array[indexPath.row]
        }
        
        return cell!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }

    func showDataForAlbumAtIndex(albumIndex: Int) {
        if albumIndex < allAlbums.count {
            var album = allAlbums[albumIndex]
            currentAlbumData = album.tr_tableRepresentation()
        } else {
            currentAlbumData = nil
        }
        
        dataTable.reloadData()
    }
}

// pragma mark - HorizontalScrollerDelegate methods
extension ViewController: HorizontalScrollerDelegate {
    
    func horizontalScroller(scroller: HorizontalScroller, clickedViewAtIndex index: Int) {
        currentAlbumIndex = index
        showDataForAlbumAtIndex(index)
    }

    func numberOfViewsForHorizontalScroller(scroller: HorizontalScroller) -> Int {
        return allAlbums.count
    }
    
    func horizontalScroller(scroller: HorizontalScroller, viewAtIndex index: Int) -> UIView {
        var album = allAlbums[index]
        return AlbumView(frame: CGRectMake(0, 0, 100, 100), albumCover: album.coverUrl)
    }
}
