//
//  DropView.swift
//  srt2txt
//
//  Created by secwang on 20/01/2017.
//  Copyright © 2017 secwang. All rights reserved.
//

import Cocoa

class DropView: NSView {
    
    var filePath: String?
    var newFile: String?
    let expectedExt = ["srt"]  //file extensions allowed for Drag&Drop
    
    var banner:NSString = "Drag Srt File Here"

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.gray.cgColor
    
     
        
        register(forDraggedTypes: [NSFilenamesPboardType, NSURLPboardType])
    }
    
    

    override func draw(_ dirtyRect: NSRect) {
        
        let font = NSFont(name: "Georgia", size: 36.0)
        let textStyle = NSMutableParagraphStyle.default().mutableCopy() as! NSMutableParagraphStyle
        textStyle.alignment = NSTextAlignment.center
        let textColor = NSColor.black
        
        
        let textFontAttributes = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: textColor,
            NSParagraphStyleAttributeName: textStyle
        ]
//        var center = CGPoint(x:self.bounds.size.width / 2.0, y:self.bounds.size.height / 2.0)
        let centerRect =  CGRect(x: self.frame.width/4 , y: (self.frame.height/4) , width: self.frame.width / 2, height: self.frame.height / 2)
        
        banner.draw(in: centerRect, withAttributes: textFontAttributes)
        
        
        super.draw(dirtyRect)
        // Drawing code here.
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        NSApp.activate(ignoringOtherApps: true)

        if checkExtension(sender) == true {
            self.banner = "Release Now"
            self.setNeedsDisplay((self.layer?.bounds)!)
            
            return .copy
        } else {
            self.banner = "Only Srt File Supported"
            self.setNeedsDisplay((self.layer?.bounds)!)

            return NSDragOperation()
        }
    }
    
    func splitFilename(str: String) -> (directory: String, filenameOnly: String, ext: String) {
        let url = URL(fileURLWithPath: str)
        return (url.deletingLastPathComponent().path, url.deletingPathExtension().lastPathComponent, url.pathExtension)
    }
    
    fileprivate func checkExtension(_ drag: NSDraggingInfo) -> Bool {
        guard let board = drag.draggingPasteboard().propertyList(forType: "NSFilenamesPboardType") as? NSArray,
            let path = board[0] as? String
            else { return false }
        
        let suffix = URL(fileURLWithPath: path).pathExtension
        for ext in self.expectedExt {
            if ext.lowercased() == suffix {
                return true
            }
        }
        return false
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        self.banner = "Drag Srt File Here"
        self.setNeedsDisplay((self.layer?.bounds)!)

    }
    
    override func draggingEnded(_ sender: NSDraggingInfo?) {
        self.banner = "Drag Srt File Here"
        self.setNeedsDisplay((self.layer?.bounds)!)

    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {

        guard let pasteboard = sender.draggingPasteboard().propertyList(forType: "NSFilenamesPboardType") as? NSArray,
            let path = pasteboard[0] as? String
            else { return false }
        
        //GET YOUR FILE PATH !!
        self.filePath = path
        Swift.print("FilePath: \(filePath)")
        var text2 = ""
        let fileUrl = URL(fileURLWithPath: filePath!)

        
        if (self.filePath!.isEmpty){
           Swift.print("finish job")
        } else {
            
            do {
                text2 = try String(contentsOf: fileUrl, encoding: String.Encoding.utf8)
                
                if text2.range(of:"\r\n") != nil{
                     text2 = text2.replacingOccurrences(of: "\r\n", with: "\n")
                }

                
                
                let x = SrtParser(text: text2)
                text2 = x.returnFiltedString()
                
            }
            catch {
                Swift.print("Error info: \(error)")
            }
        }
        
        if(text2 != ""){
            let savePanel = NSSavePanel()
            savePanel.allowedFileTypes = ["txt"]
            
            let newFileName = fileUrl.deletingPathExtension().lastPathComponent

            savePanel.nameFieldStringValue = newFileName
            let current = NSApplication.shared().mainWindow


            savePanel.beginSheetModal(for: current!, completionHandler: { (result) in
                if result == NSFileHandlingPanelOKButton {
                    let writePath = savePanel.url
                    
                    do {
                        try text2.write(to: writePath! , atomically: false, encoding: String.Encoding.utf8)
                    }
                    catch {
                        Swift.print("error is \(error)")
                    }
                }
            })
        }
        
        self.banner = "Coverting"
        self.setNeedsDisplay((self.layer?.bounds)!)

        
        return true
    }
    
}
