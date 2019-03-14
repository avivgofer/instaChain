//
//  Post.swift
//  Instagram
//
//  Created by admin on 02/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class Post {
    var caption: String?
    var photoUrl: String?
    var uid: String?
    
    init(uid: String, caption: String, photoUrl: String) {
        self.caption = caption
        self.photoUrl = photoUrl
        self.uid = uid
    }
    
    init(json:[String:Any]) {
        uid = json["uid"] as? String
        photoUrl = json["photoUrl"] as? String
        caption = json["caption"] as? String
    }
    
}
