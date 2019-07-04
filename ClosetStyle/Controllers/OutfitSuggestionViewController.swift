//
//  OutfitSuggestionViewController.swift
//  ClosetStyle
//
//  Created by Wayne Mosley on 6/14/19.
//  Copyright © 2019 Wayne Mosley. All rights reserved.
//

import UIKit
import Vision

class OutfitSuggestionViewController: UIViewController {
    var outfits = OutfitCloset()
  
    
    @IBOutlet weak var suggestFitImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        outfits.loadCloset()
        displayRandomOutfit()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        displayRandomOutfit()
    }
    
    func displayRandomOutfit(){
        let randomFit = outfits.getOutfitForCell(index: Int.random(in: 0...outfits.count()-1))
        suggestFitImage.image = randomFit.imageFromData()
        
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
