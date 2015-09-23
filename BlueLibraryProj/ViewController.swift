//
//  ViewController.swift
//  BlueLibraryProj
//
//  Created by alex livenson on 9/9/15.
//  Copyright (c) 2015 alex livenson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var dataTable: UITableView!
    private var toolbar: UIToolbar!
    private var scroller: HorizontalScroller!
    
    // We will use this array as a stack to push/pop operation for undo option
    // TODO: Use memento pattern to undo/save actions of an operation
    private var undoStack: [AnyObject] = []
    
    private var allAlbums: [Album] = []
    private var currentAlbumData: [String: [String]]?
    private var currentAlbumIndex = 0
    
    private let memento: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    private let notificationCenter = NSNotificationCenter.defaultCenter()
    private let libraryAPI = LibraryAPI.sharedInstance
    
    private let currentAlbumIndexKey = "currentAlbumIndex"
    
    // NOTE: Frame size set in viewDidLoad isn't final
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.76, green: 0.81, blue: 0.87, alpha: 1)
        allAlbums = libraryAPI.getAlbums()
        
        createTableView()
        createScroller()
        createToolBar()
        
        loadPreviousState()
        
        view.addSubview(dataTable)
        view.addSubview(scroller)
        view.addSubview(toolbar)
        
        showDataForAlbumAtIndex(currentAlbumIndex)
        reloadScroller()
        
        registerObservers()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func createToolBar() {
        toolbar = UIToolbar()
        let undoItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.Undo,
            target: self,
            action: "undoAction")
        undoItem.enabled = false
        let space = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace,
            target: nil,
            action: nil)
        let delete = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.Trash,
            target: self,
            action: "deleteAlbum")
        toolbar.setItems([undoItem, space, delete], animated: true)
    }
    
    private func createTableView() {
        let tableFrame = CGRectMake(0, 120, self.view.frame.width, self.view.frame.height - 120)
        dataTable = UITableView(frame: tableFrame, style: UITableViewStyle.Grouped)
        dataTable.delegate = self
        dataTable.dataSource = self
        dataTable.backgroundView = nil
    }
    
    private func createScroller() {
        let scrollerFrame = CGRectMake(0, 20, self.view.frame.size.width, 130)
        scroller = HorizontalScroller(frame: scrollerFrame)
        scroller.backgroundColor = UIColor(red: 0.24, green: 0.35, blue: 0.49, alpha: 1)
        scroller.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let height = self.view.frame.size.height
        let width = self.view.frame.size.width
        toolbar.frame = CGRectMake(0, height - 44, width, 44)
    }
    
    func addAlbum(album: Album, atIndex index: Int) {
        libraryAPI.addAlbum(album, index: index)
        currentAlbumIndex = index
        reloadScroller()
    }
    
    // NOTE: NSInvocation is not allowed in swift, need to rething (use memento?)
    func deleteAlbum() {

    }
    
    func undoAction() {
        
    }
    
    func reloadScroller() {
        allAlbums = libraryAPI.getAlbums()
        
        if currentAlbumIndex < 0 {
            currentAlbumIndex = 0
        } else if (currentAlbumIndex >= allAlbums.count) {
            currentAlbumIndex = allAlbums.count - 1
        }
        
        scroller?.reload()
        showDataForAlbumAtIndex(currentAlbumIndex)
    }
    
    func saveCurrentState() {
        /*
            When user leave the app, then comes back again, he wants the exact same state he
            left it in. In order to do this we need to save the currently displayed album.
            Since it's only one piece of info we can user NSUserDefaults
        */
        memento.setInteger(currentAlbumIndex, forKey: currentAlbumIndexKey)
        libraryAPI.saveAlbums()
    }
    
    func loadPreviousState() {
        currentAlbumIndex = memento.integerForKey(currentAlbumIndexKey)
        showDataForAlbumAtIndex(currentAlbumIndex)
    }
    
    func registerObservers() {
        notificationCenter.addObserver(
            self,
            selector: "saveCurrentState",
            name: UIApplicationDidEnterBackgroundNotification,
            object: nil)
    }
    
    func deRegisterObservers() {
        notificationCenter.removeObserver(self)
    }
    
    deinit {
        deRegisterObservers()
    }
}

// PRAGMA MARK: - UITableViewDelegate, UITableViewDataSource methods
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let titles: [String] = currentAlbumData?["titles"] {
            return titles.count
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
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
            let album = allAlbums[albumIndex]
            currentAlbumData = album.tr_tableRepresentation()
        } else {
            currentAlbumData = nil
        }
        
        dataTable.reloadData()
    }
}

// PRAGMA MARK: - HorizontalScrollerDelegate methods
extension ViewController: HorizontalScrollerDelegate {
    
    func horizontalScroller(scroller: HorizontalScroller, clickedViewAtIndex index: Int) {
        currentAlbumIndex = index
        showDataForAlbumAtIndex(index)
    }

    func numberOfViewsForHorizontalScroller(scroller: HorizontalScroller) -> Int {
        return allAlbums.count
    }
    
    func horizontalScroller(scroller: HorizontalScroller, viewAtIndex index: Int) -> UIView {
        let album = allAlbums[index]
        return AlbumView(frame: CGRectMake(0, 0, 100, 100), albumCover: album.coverUrl)
    }
    
    func initialViewIndexForHorizontalScroller(scroller: HorizontalScroller) -> Int {
        return currentAlbumIndex
    }
}
