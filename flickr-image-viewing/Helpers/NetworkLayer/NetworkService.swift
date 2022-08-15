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
    
    class func loadLargeImage(_ completion: @escaping (Result<FlickrPhoto, Swift.Error>) -> Void, for image: FlickrPhoto) -> UIImage? {
        guard let loadURL = flickrImageURL("b", for: image) else { DispatchQueue.main.async {
            completion(.failure(Error.invalidURL))
        }
            return UIImage()
        }
        
        let image = UIImageView()
        image.kf.setImage(with: loadURL)
        return image.image
    }
    
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
    
//    class func getPhotos(photoData: [FlickrPhoto]) -> [FlickrPhoto] {
//        let photos: [FlickrPhoto] = photoData.compactMap { photoObject in
////            guard let flickrPhoto = FlickrPhoto(photoID: photoObject.photoID, farm: photoObject.farm, server: photoObject.server, secret: photoObject.secret) else { return photoObject }
//            var flickrPhoto: FlickrPhoto = FlickrPhoto(photoID: photoObject.photoID, farm: photoObject.farm, server: photoObject.server, secret: photoObject.secret) ?? photoObject
//            guard let url = flickrImageURL(for: flickrPhoto) else { return photoObject }
//            print(url)
//            print(flickrPhoto.photoID)
//
//            print(Thread.current)
//            flickrPhoto.thumbnail = UIImageView()
//            flickrPhoto.thumbnail.kf.setImage(with: url)
//            return flickrPhoto
//        }
//
//        return photos
//    }
//
    class func getPhotosURL(photoData: [FlickrPhoto]) -> [FlickrPhoto] {
        let photos: [FlickrPhoto] = photoData.compactMap { photoObject in

            var flickrPhoto: FlickrPhoto = FlickrPhoto(photoID: photoObject.photoID, farm: photoObject.farm, server: photoObject.server, secret: photoObject.secret, title: photoObject.title) ?? photoObject
            guard let url = flickrImageURL(for: flickrPhoto),
                let largeImageURL = flickrImageURL("b", for: flickrPhoto)
            else { return photoObject }
//            print(url)
//            print(flickrPhoto.photoID)

            print(Thread.current)
            flickrPhoto.thumbnailURL = url
            flickrPhoto.largeImageURL = largeImageURL
//            flickrPhoto.thumbnail = UIImageView()
//            flickrPhoto.thumbnail.kf.setImage(with: url)
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
        print(URLString)
        return URL(string: URLString)
    }
}
