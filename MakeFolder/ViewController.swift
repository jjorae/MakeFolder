//
//  ViewController.swift
//  MakeFolder
//
//  Created by 조래혁 on 2016. 1. 4..
//  Copyright © 2016년 JJORAE. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var selectedDirectory: NSTextField!
    @IBOutlet weak var folderFormat: NSTextField!
    @IBOutlet weak var startDate: NSDatePicker!
    @IBOutlet weak var endDate: NSDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // 다음날짜 가져오기
    func next_date(current_date: NSDate) -> NSDate {
        return NSCalendar.currentCalendar().dateByAddingUnit(
            .Day,
            value: 1,
            toDate: current_date,
            options: NSCalendarOptions(rawValue: 0))!
    }
    
    // 디렉토리 생성
    func create_dir(target_dir: String) {
        let path = NSURL(string: selectedDirectory.stringValue)
        
        let add_path = path?.URLByAppendingPathComponent(target_dir)
        
        do {
            try NSFileManager.defaultManager().createDirectoryAtPath(add_path!.path!, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
    }

    // 생성 버튼
    @IBAction func pressButton(sender: NSButton) {
        NSLog("Pressed button!!")
        
        if(!folderFormat.stringValue.isEmpty) {
            var start = startDate.dateValue
            
            while(true) {
                if(start.compare(endDate.dateValue) == NSComparisonResult.OrderedAscending || start.compare(endDate.dateValue) == NSComparisonResult.OrderedSame) {
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = folderFormat.stringValue
                    let start_date = dateFormatter.stringFromDate(start)
                    
                    NSLog("\(start_date)")
                    create_dir(start_date)
                    
                    start = next_date(start)
                } else {
                    break;
                }
            }
            
        }
    }

    // 경로선택 버튼
    @IBAction func chooseDirectory(sender: NSButton) {
        let openPanel = NSOpenPanel()
        openPanel.title = "Choose a directory"
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        openPanel.beginWithCompletionHandler({(result:Int) in
            if(result == NSFileHandlingPanelOKButton) {
                let fileURL = openPanel.URL!
                NSLog(fileURL.absoluteString)
                self.selectedDirectory.stringValue = fileURL.absoluteString
            }
        })
    }
}

