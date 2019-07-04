//
//  FashionScreenTabBarController.swift
//  ClosetStyle
//
//  Created by Wayne Mosley on 5/16/19.
//  Copyright © 2019 Wayne Mosley. All rights reserved.
//

import UIKit

class FashionScreenTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.items?[0].title = "Closet"
        self.tabBar.items?[1].title = "Inspo"
        self.tabBar.items?[2].title = "Suggestion"
        self.tabBar.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.6235294118, blue: 0.6117647059, alpha: 1) //color hex code 1F9F9C
        
        // Do any additional setup after loading the view.
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
