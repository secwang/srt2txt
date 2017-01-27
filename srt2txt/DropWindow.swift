//
//  DropWindow.swift
//  srt2txt
//
//  Created by secwang on 27/01/2017.
//  Copyright © 2017 secwang. All rights reserved.
//

import Foundation
import Cocoa

class DropWindow: NSWindow {
    
    override init(contentRect: NSRect, styleMask style: NSWindowStyleMask, backing bufferingType: NSBackingStoreType, defer flag: Bool){
        
        super.init(contentRect: contentRect, styleMask:style.union(.fullSizeContentView), backing: NSBackingStoreType.buffered, defer: false)
        
        self.titlebarAppearsTransparent = true
        self.titleVisibility = .hidden
    }
}
