//
//  OutfitCollectionViewCell.swift
//  ClosetStyle
//
//  Created by Wayne Mosley on 4/20/19.
//  Copyright © 2019 Wayne Mosley. All rights reserved.
//

import UIKit

class OutfitCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var outfitImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //containerView.layer.cornerRadius = 6
        //containerView.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = self.frame.size.width * 0.08
        /*
         self.contentView.layer.borderColor = UIColor.clear.cgColor
         self.contentView.layer.masksToBounds = false
         self.layer.shadowRadius = self.frame.size.width * 0.08
         self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
         self.layer.shadowColor = UIColor.lightGray.cgColor
         self.layer.shadowOpacity = 1.0
         self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
         */
        
        /*
         outfitCell.contentView.layer.borderWidth = 1.0
         outfitCell.contentView.layer.borderColor = UIColor.clear.cgColor
         outfitCell.contentView.layer.masksToBounds = true
         outfitCell.layer.shadowRadius = outfitCell.layer.cornerRadius
         outfitCell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
         outfitCell.layer.shadowColor = UIColor.lightGray.cgColor
         outfitCell.layer.shadowOpacity = 1.0
         outfitCell.layer.shadowPath = UIBezierPath(roundedRect: outfitCell.bounds, cornerRadius: outfitCell.contentView.layer.cornerRadius).cgPath
         */
    }
    
}
