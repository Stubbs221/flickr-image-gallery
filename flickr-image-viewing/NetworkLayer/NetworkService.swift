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

let apiKey = "e09f767500029106d4c53e0adf56c8c2"

class NetworkService {
    
//    func loadLargeImage(flickrPhoto: FlickrPhoto,_ completion: @escaping (Result<FlickrPhoto, Swift.Error>) -> Void) {
//        guard let loadURL = flickrPhoto.flickrImageURL("b") else {
//            DispatchQueue.main.async {
//                completion(.failure(Error.invalidURL))
//            }
//            return
//        }
//
//        let loadRequest = AF.request(loadURL)
//
//        AF.request(loadRequest as! URLRequestConvertible).responseObject { (response: AFDataResponse<FlickrPhoto>) in
//            switch response.result {
//            case .success(let photo):
//
//            }
//        }
//    }
    
    class func searchFlickr(for searchTerm: String, completion: @escaping (Result<FlickrSearchResults, Swift.Error>) -> Void) {
        guard let searchURL = flickrSearchURL(for: searchTerm) else {
            completion(.failure(Error.unknownAPIResponse))
            return
        }
        
        AF.request(searchURL).responseObject { (response: AFDataResponse<FlickrSearchResults>) in
            switch response.result {
            case .success(let photoArray):
                completion(.success(photoArray))
                print(photoArray)
            case .failure(let error):
                completion(.failure(error))
                
            }
        }
    }
    
    class func flickrSearchURL(for searchTerm: String) -> URL? {
        guard let escapedTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else { return nil }
        let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(escapedTerm)&per_page=20&format=json&nojsoncallback=1"
        print(URLString)
        return URL(string: URLString)
    }
}
