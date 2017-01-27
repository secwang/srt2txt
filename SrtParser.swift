//
//  SrtParser.swift
//  srt2txt
//
//  Created by secwang on 20/01/2017.
//  Copyright © 2017 secwang. All rights reserved.
//

import Foundation


class SrtParser: NSObject {
    var text : String?
    
    init(text:String) {
        self.text = text
    }
    
    func returnFiltedString() -> String{
        var data = ""
        if((self.text) != nil){
            let textArr = self.text!.components(separatedBy: "\n\n")
            for x in textArr{
               var contentArr = x.components(separatedBy: "\n")
                contentArr  = Array(contentArr.dropFirst(2))
                var content = contentArr.joined(separator: "\n")
                content += "\n"
                data = data + content
            }
        }
        return data;
    }
    
}
