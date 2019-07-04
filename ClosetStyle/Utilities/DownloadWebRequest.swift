//
//  DownloadWebRequest.swift
//  ClosetStyle
//
//  Created by Wayne Mosley on 6/8/19.
//  Copyright © 2019 Wayne Mosley. All rights reserved.
//

import Foundation


class DownloadWebRequest{
    let downloadSession = URLSession(configuration: .default, delegate: UnsplashViewController(), delegateQueue: nil)
    
    func downloadImage(from url: URL){
        let download = downloadSession.downloadTask(with: url)
        print("here")
        download.resume()
        
    }
    
}
