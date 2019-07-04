//
//  Outfit.swift
//  ClosetStyle
//
//  Created by Wayne Mosley on 4/7/19.
//  Copyright © 2019 Wayne Mosley. All rights reserved.
//

import Foundation
import UIKit

struct Outfit: CustomStringConvertible, Codable{
    let date: Date
    var name: String
    var image: Data
    var event: String
    var rating: Int
    
    var description: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: date)
        return "\(name) was worn to \(event) on \(dateString) and had a rating of \(rating)."
    }
    
    //Because UIImage does not directly conform to Codable, I am getting the raw data representation of the image since Data conforms to Codable. Whereever the actual image is required I convert it using the below function.
    
    func imageFromData() -> UIImage{
        guard let image = UIImage(data: self.image) else {return UIImage()}
        return image
    }
    
    
    
}
