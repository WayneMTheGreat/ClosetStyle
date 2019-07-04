//
//  OutfitCloset.swift
//  ClosetStyle
//
//  Created by Wayne Mosley on 4/7/19.
//  Copyright © 2019 Wayne Mosley. All rights reserved.
//

import Foundation

struct OutfitCloset:Codable{
    
    private var outfits: [Outfit]
    
    init(){
        self.outfits = [Outfit]()
    }
    
    mutating private func append(outfit: Outfit){
        outfits.append(outfit)
    }
    
    mutating func addOutfitToCloset(outfit: Outfit){
        append(outfit: outfit)
    }
    
    func count() -> Int{
        return self.outfits.count
    }
    
    func getOutfitForCell(index: Int) -> Outfit{
        return outfits[index]
    }
    
    mutating func replaceOutfitForCell(outfit: Outfit, index: Int){
        outfits[index] = outfit
    }
    
    mutating func removeOutfitFromCloset(at: Int){
        outfits.remove(at: at)
    }
    
    func getDescriptionForOutfit(at: Int) -> String{
        return outfits[at].description
    
    }
    
    func saveCloset(){
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentDirectory.appendingPathComponent("OutfitArray").appendingPathExtension("plist")
        let propertyListEncoder = PropertyListEncoder()
        let encodedCloset = try? propertyListEncoder.encode(outfits)
        try? encodedCloset?.write(to: archiveURL, options: .noFileProtection)
    }
    
    mutating func loadCloset(){
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentDirectory.appendingPathComponent("OutfitArray").appendingPathExtension("plist")
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedOutfitsData = try? Data(contentsOf: archiveURL),
            let decodedOutfits = try? propertyListDecoder.decode(Array<Outfit>.self, from: retrievedOutfitsData){
            outfits = decodedOutfits
        }
        
    }
}
