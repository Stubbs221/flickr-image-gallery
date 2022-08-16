//
//  Request.swift
//  flickr-image-viewing
//
//  Created by MAC on 10.08.2022.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import Kingfisher

let apiKey = "e09f767500029106d4c53e0adf56c8c2"

class NetworkService {
    
    class func searchFlickr(for searchTerm: String, completion: @escaping (Result<FlickrSearchResults, Swift.Error>) -> Void) {
        guard let searchURL = flickrSearchURL(for: searchTerm) else {
            completion(.failure(Error.unknownAPIResponse))
            return
        }
        
        AF.request(searchURL).responseObject { (response: AFDataResponse<FlickrSearchResults>) in
            switch response.result {
            case .success(let photoArray):
                let photoReceived = photoArray.searchResults
                let flickrPhotos = self.getPhotosURL(photoData: photoReceived)
                var searchResults = FlickrSearchResults(searchTerm: searchTerm, searchResults: flickrPhotos) ?? photoArray
                
                completion(.success(searchResults))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    class func getPhotosURL(photoData: [FlickrPhoto]) -> [FlickrPhoto] {
        let photos: [FlickrPhoto] = photoData.compactMap { photoObject in

            var flickrPhoto: FlickrPhoto = FlickrPhoto(photoID: photoObject.photoID, farm: photoObject.farm, server: photoObject.server, secret: photoObject.secret, title: photoObject.title) ?? photoObject
            guard let url = flickrImageURL(for: flickrPhoto),
                let largeImageURL = flickrImageURL("b", for: flickrPhoto)
            else { return photoObject }

            flickrPhoto.thumbnailURL = url
            flickrPhoto.largeImageURL = largeImageURL
            return flickrPhoto
        }
        
        return photos
    }
    
    class func flickrImageURL(_ size: String = "m", for image: FlickrPhoto) -> URL? {
        return URL(string: "https://farm\(image.farm).staticflickr.com/\(image.server)/\(image.photoID)_\(image.secret)_\(size).jpg")
    }
    
    class func flickrSearchURL(for searchTerm: String) -> URL? {
        guard let escapedTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else { return nil }
        
        let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(escapedTerm)&per_page=20&format=json&nojsoncallback=1"

        return URL(string: URLString)
    }
}
