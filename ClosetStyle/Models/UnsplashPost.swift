//
//  UnsplashPost.swift
//  ClosetStyle
//
//  Created by Wayne Mosley on 5/23/19.
//  Copyright © 2019 Wayne Mosley. All rights reserved.
//

import Foundation

struct UnsplashPost: Codable{
    let id: String
    let created_at: String
    let updated_at: String
    let width: Int
    let height: Int
    let color: String
    let description: String?
    let alt_description: String?
    let urls: [String:String]
    let links: [String:String]
    /*let categories:[CurrentUserCollection]
    let sponsored: Bool
    let sponsored_by: SponsoredBy? //This is a type with a more complicated structure
    let sponsored_impressions_id: String?
    let likes: Int
    let liked_by_user: Bool
    let current_user_collections:[CurrentUserCollection]*/
    let user: User //This is a type with a more complicated structure.
    //let sponsorship: Sponsorship
}

struct CurrentUserCollection: Codable{
    let id: Int
    let title: String
    let published_at: String
    let updated_at: String
    let curated: Bool
    let cover_photo: String
    let user: String
}
struct SponsoredBy: Codable{
    let id: String
    let updated_at: String
    let username: String
    let name: String
    let first_name: String
    let last_name: String?
    let twitter_username: String
    let portfolio_url: String
    let bio: String
    let location: String
    let links: [String:String]
    let profile_image: [String:String]
    let instagram_username: String
    let total_collections: Int
    let total_likes: Int
    let total_photos: Int
    let accepted_tos: Bool
}

struct User: Codable{
    let id: String
    let updated_at: String
    let username: String
    let name: String
    let first_name: String
    let last_name: String?
   /* let twitter_username: String?
    let portfolio_url: String
    let bio: String
    let location: String
    let links: [String:String]
    let profile_image: [String:String]
    let instagram_username: String
    let total_collections: Int
    let total_likes: Int
    let total_photos: Int
    let accepted_tos: Bool*/
}

struct Sponsorship: Codable{
    let impressions_id: String
    let tagline: String
    let sponsor: Sponsor
}

struct Sponsor: Codable{
    let id: String
    let updated_at: String
    let username: String
    let name: String
    let first_name: String
    let last_name: String?
    let twitter_username: String
    let portfolio_url: String
    let bio: String
    let location: String
    let links: [String:String]
    let profile_image: [String:String]
    let instagram_username: String
    let total_collections: Int
    let total_likes: Int
    let total_photos: Int
    let accepted_tos: Bool
}

struct DownloadLink: Codable{
    let url: String
}
