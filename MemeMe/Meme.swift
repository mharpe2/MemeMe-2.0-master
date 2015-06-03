//
//  MemeMe.swift
//  TestFieldsExperiments
//
//  Created by Michael Harper on 4/29/15.
//  Copyright (c) 2015 hxx. All rights reserved.
//

import UIKit


class Meme {
    
    //MARK: Memeber Variables
    var topText: String!
    var bottomText: String!
    var originalImage: UIImage!
    var memeImage: UIImage!
    
    
    //MARK: Member funcs
    init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memeImage = memedImage
        
    }
    
    
    
}