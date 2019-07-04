//
//  RedditViewController.swift
//  ClosetStyle
//
//  Created by Wayne Mosley on 5/18/19.
//  Copyright © 2019 Wayne Mosley. All rights reserved.
//

import UIKit

class UnsplashViewController: UIViewController{
    
    let unsplashRequester = WebRequests()
    // let unsplashDownloader = DownloadWebRequest()
    lazy var downloadSession: URLSession = {
        URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }()
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var randomOutfit: UIImageView!
    @IBOutlet weak var imageLoadProgress: UIProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
        urlLabel.isHidden = true
        imageLoadProgress.progress = 0.0
        imageLoadProgress.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func makeUnsplashRequest(_ sender: Any) {
        unsplashRequester.getUnsplashPhotoURL(){ downloadLink, unsplashPost in
            //print("\(downloadLink?.url)")
            self.urlLabel.isHidden = false
            self.urlLabel.text = "Photo by: \n" + unsplashPost.user.username + "\nOn Unsplash"
            let url = URL(string: downloadLink!.url)
            let download = self.downloadSession.downloadTask(with: url!)
            download.resume()
        }
        
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


extension UnsplashViewController: URLSessionDownloadDelegate{
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let imageData = try? Data(contentsOf: location)
        print("\(String(describing: imageData))")
        DispatchQueue.main.async {
            self.imageLoadProgress.isHidden = true
            self.randomOutfit.image = UIImage(data: imageData ?? Data())
            print("Here")
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if totalBytesExpectedToWrite > 0 {
            let progress = Float(totalBytesWritten) /
                Float(totalBytesExpectedToWrite)
            DispatchQueue.main.async{
                self.imageLoadProgress.isHidden = false
                self.imageLoadProgress.setProgress(progress, animated: false)
                print("\(progress)")
            }
        }
        
    }
}
