//
//  Shot.swift
//  DribbbleBar
//
//  Created by Jirat Ki. on 11/5/2559 BE.
//  Copyright © 2559 Jirat Ki. All rights reserved.
//

import Foundation

struct Shot {
    var id = 0
    var title = ""
    var hidpiImage: String?
    var normalImage = ""
    var teaserImage = ""
    
    init(json: AnyObject) {
        guard json is [String: AnyObject] else {
            return
        }
        
        id = json["id"] as! Int
        title = json["title"] as! String
        if let images = json["images"] as? [String: AnyObject] {
            hidpiImage = images["hidpi"] as? String ?? ""
            normalImage = images["normal"] as? String ?? ""
            teaserImage = images["teaser"] as? String ?? ""
        }   
    }
}

