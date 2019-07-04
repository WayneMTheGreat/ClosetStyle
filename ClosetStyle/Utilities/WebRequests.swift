//
//  WebRequests.swift
//  ClosetStyle
//
//  Created by Wayne Mosley on 5/16/19.
//  Copyright © 2019 Wayne Mosley. All rights reserved.
//

import Foundation


class WebRequests{
    private let session = URLSession(configuration: .default)
    private var apiURLComponents = URLComponents()
    private let apiKey = ""
    
    
    func getUnsplashPhotoURL(completion: @escaping (DownloadLink?, UnsplashPost)->()){
        apiURLComponents.scheme = "https"
        apiURLComponents.host = "api.unsplash.com"
        apiURLComponents.path = "/photos/random"
        apiURLComponents.queryItems = [
            URLQueryItem(name: "client_id", value: apiKey),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "query", value: "streetwear")
        ]
        let url = apiURLComponents.url
        let request = session.dataTask(with: url!){ data,response,error in
            
            guard let data = data else {return}
    
            do{
                let jsonDecoder = JSONDecoder()
                let unSplashPost = try jsonDecoder.decode(UnsplashPost.self, from: data)
                let firstLink = unSplashPost.links["download_location"]
                /*
                 
                 The below string of function calls grabs the data for the desired image that we want to display from Unsplash.
                 To enable the data to propagate up the call stack we have to use closures so that the "environment" can be set up in the correct order.
                 This is possible because closures are called once the originally called function completes its task. This is a bit confusing and can
                 possibly be simplified. Come back to this.
                 
                 */
                self.getdownloadLink(from: firstLink!){
                    downloadLink in
                    OperationQueue.main.addOperation {
                        completion(downloadLink, unSplashPost)//Re-write this to handle the no internet connection error.
                    }
                }
            }catch {let error = error
                print("\(error)")
            }
        }
        request.resume()
        
    }
    
    func getdownloadLink(from: String, completion: @escaping  (DownloadLink?) -> ()){
        var photoDownloadLink: DownloadLink?
        let request = session.dataTask(with: URL(string: from + "?client_id=d48f45965f8fa8cabfd6d06f35b15b7550c4fc915adb7c02eb69d52a3315bebc")!){ data, response, error in
            guard let data = data else {return}
            let jsonDecoder = JSONDecoder()
            photoDownloadLink = try? jsonDecoder.decode(DownloadLink.self, from: data)
            completion(photoDownloadLink)
        }
        request.resume()
    }
}
