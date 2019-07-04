//
//  OutfitsCollectionViewController.swift
//  ClosetStyle
//
//  Created by Wayne Mosley on 4/7/19.
//  Copyright © 2019 Wayne Mosley. All rights reserved.
//

import UIKit

private let reuseIdentifier = "OutfitCell"


class OutfitsCollectionViewController: UICollectionViewController/*, UICollectionViewDelegateFlowLayout*/ {
    
    var outfits = OutfitCloset()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        outfits.loadCloset()
        createBlurView()
        collectionView.isPagingEnabled = false
        collectionView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) //color hex code 1F9F9C
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(deleteCollectionViewCell))
        doubleTap.numberOfTapsRequired = 2
        
        
        collectionView.addGestureRecognizer(doubleTap)
        /*if traitCollection.forceTouchCapability == .available{
         registerForPreviewing(with: self, sourceView: view)
         }*/
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        //self.collectionView!.register(OutfitCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        
        // Do any additional setup after loading the view.z
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        outfits.saveCloset()
        collectionView!.reloadData()
        collectionView!.collectionViewLayout.invalidateLayout()
        
    }
    
    @IBAction func prepareForUnwindSegue(segue: UIStoryboardSegue){
        if let sourceController = segue.source as? AddOutfitViewController{
            guard let outfit = sourceController.outfit else {return}
            if sourceController.isEditing == false{
                outfits.addOutfitToCloset(outfit: outfit)
                collectionView.reloadData()
            }else{
                outfits.replaceOutfitForCell(outfit: outfit, index: collectionView.indexPathsForSelectedItems!.first!.item)
                sourceController.isEditing =  false
                collectionView.reloadData()
            }
        }
    }
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "CollectionEditOutfit"{
            if let sender = sender as? OutfitCollectionViewCell{
                print("Here")
                let selectedOutfit = outfits.getOutfitForCell(index: collectionView.indexPath(for: sender)!.item)
                if let destination = segue.destination as? AddOutfitViewController{
                    destination.outfit = selectedOutfit
                    destination.isEditing = true
                    print("Here")
                }
            }
            
        }
        else if segue.identifier == "collectionAddOutfit"{
            print("we adding.")
        }
        
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return outfits.count()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        if let outfitCell = cell as? OutfitCollectionViewCell{
            
            // Configure the cell
            let image = outfits.getOutfitForCell(index: indexPath.item).imageFromData()
            outfitCell.outfitImage.image = image
            outfitCell.descriptionLabel.text = outfits.getDescriptionForOutfit(at: indexPath.item)
            //print("\(outfitCell.outfitImage.image?.averageColor)")
            guard let dominantColor = outfitCell.outfitImage.image?.averageColor else {return UICollectionViewCell()}
            outfitCell.backgroundColor = dominantColor
            addShadowToCell(outfitCell: outfitCell)
            
            return outfitCell
        }
        
        
        
        return cell
    }
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
    
    
    // MARK: Helper Functions
    
    func createBlurView(){
        guard let collectionView = collectionView else {return}
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = collectionView.bounds
        collectionView.backgroundColor = .white
        //collectionView.backgroundView = blurView
        
        
    }
    
    func addShadowToCell(outfitCell: OutfitCollectionViewCell){
        outfitCell.contentView.layer.borderWidth = 1.0
        outfitCell.contentView.layer.borderColor = UIColor.clear.cgColor
        outfitCell.clipsToBounds = false
        outfitCell.contentView.layer.masksToBounds = false
        outfitCell.layer.shadowRadius = outfitCell.layer.cornerRadius
        outfitCell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        outfitCell.layer.shadowColor = UIColor.lightGray.cgColor
        outfitCell.layer.shadowOpacity = 0.5
        outfitCell.layer.shadowPath = UIBezierPath(roundedRect: outfitCell.bounds, cornerRadius: outfitCell.contentView.layer.cornerRadius).cgPath
    }
    
    @objc func deleteCollectionViewCell(recognizer: UILongPressGestureRecognizer){
        guard let indexPath = collectionView.indexPathForItem(at: recognizer.location(in: self.collectionView)) else {return}
        collectionView.performBatchUpdates({
            outfits.removeOutfitFromCloset(at: indexPath.row)
            self.collectionView.deleteItems(at: [indexPath])
        }) { (finished) in
            self.collectionView.reloadData()
        }
    }
}




// TODO: - Figure Out How to Properly Work this Force Touch Capability


/*extension OutfitsCollectionViewController: UIViewControllerPreviewingDelegate{
 func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
 
 guard let cellLocation = collectionView.indexPathForItem(at: location) else {return UIViewController()}
 if let cell = collectionView.cellForItem(at: cellLocation){
 
 guard let detailViewController = storyboard?.instantiateViewController(withIdentifier: "AddOutfitViewController") as? AddOutfitViewController else { return nil }
 
 /*
 Set the height of the preview by setting the preferred content size of the detail view controller.
 Width should be zero, because it's not used in portrait.
 */
 detailViewController.preferredContentSize = CGSize(width: 0, height: 400)
 detailViewController.outfit = outfits.getOutfitForCell(index: cellLocation.item)
 detailViewController.isEditing = true
 
 // Set the source rect to the cell frame, so surrounding elements are blurred.
 previewingContext.sourceRect = cell.frame
 
 return detailViewController
 }
 return nil
 }
 
 func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
 show(viewControllerToCommit, sender: self)
 }
 
 }*/
