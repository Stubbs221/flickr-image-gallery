//
//  PhotoFeedModel.swift
//  flickr-image-viewing
//
//  Created by MAC on 10.08.2022.
//

import Foundation
import ObjectMapper

struct FlickrSearchResults: Mappable {
    
    var searchTerm: String = ""
    var searchResults: [FlickrPhoto] = []
    
    init?(map: Map) { }
    
    init?(searchTerm: String, searchResults: [FlickrPhoto]) {
        
        self.searchTerm = searchTerm
        self.searchResults = searchResults
    }
    
    mutating func mapping(map: Map) {
        searchResults <- map["photos.photo"]
    }
    
}

struct FlickrPhoto: Mappable {
    
    
    var thumbnail: UIImageView!
    var largeImage: UIImageView!
    var thumbnailURL: URL!
    var photoID: String = ""
    var farm: Int = 0
    var server: String = ""
    var secret: String = ""
    
    func flickrImageURL(_ size: String = "m") -> URL? {
        return URL(string:
            "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_\(size).jpg")
    }
    
    init?(map: Map) {
        
    }
    
    init?(photoID: String, farm: Int, server: String, secret: String) {
        self.photoID = photoID
        self.farm = farm
        self.server = server
        self.secret = secret
    }
    mutating func mapping(map: Map) {
        photoID <- map["id"]
        farm <- map["farm"]
        server <- map["server"]
        secret <- map["secret"]
    }
}

struct Flickr {
    
}

enum Error: Swift.Error {
    case invalidURL
    case noData
    case unknownAPIResponse
    case generic
}
