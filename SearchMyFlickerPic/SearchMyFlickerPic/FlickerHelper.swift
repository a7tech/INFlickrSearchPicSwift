
    import Foundation
    import UIKit

    // MARK: Define Flicker API Key Here.
    //*****************************************************************
    let FLICKR_API_KEY = "YOUR_FLICKR_API_KEY_HERE"

    struct FlickrSearchResults {
        let searchTerm : String
        let searchResults : [FlickrPhoto]
    }

    // MARK: Create Init Class For Flicker Photo.
    //*****************************************************************
    class FlickrPhoto : Equatable {
        var thumbnail : UIImage?
        var largeImage : UIImage?
        let photoID : String
        let farm : Int
        let server : String
        let secret : String
        
        
        init (photoID:String,farm:Int, server:String, secret:String) {
            self.photoID = photoID
            self.farm = farm
            self.server = server
            self.secret = secret
        }
        
        // MARK: Call function for each image URL.
        //*****************************************************************
        func flickrImageURL(size:String = "m") -> NSURL {
            return NSURL(string: "http://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_\(size).jpg")!
        }
        // MARK: Call the function for Large image.
        //*****************************************************************
        func loadLargeImage(completion: (flickrPhoto:FlickrPhoto, error: NSError?) -> Void) {
            let loadURL = flickrImageURL("b")
            let imageview:UIImageView = UIImageView()
            imageview.sd_setImageWithURL(loadURL, placeholderImage: UIImage(named: ""))
            self.largeImage = imageview.image
            completion(flickrPhoto: self, error: nil)
        }
        
        func sizeToFillWidthOfSize(size:CGSize) -> CGSize {
            if thumbnail == nil {
                return size
            }
            let imageSize = thumbnail!.size
            var returnSize = size
            let aspectRatio = imageSize.width / imageSize.height
            returnSize.height = returnSize.width / aspectRatio
            if returnSize.height > size.height {
                returnSize.height = size.height
                returnSize.width = size.height * aspectRatio
            }
            return returnSize
        }
    }

    func == (lhs: FlickrPhoto, rhs: FlickrPhoto) -> Bool {
        return lhs.photoID == rhs.photoID
    }


    // MARK: Create Class of Flicker API.
    //*****************************************************************

    class Flickr {
        
        // MARK: make a function for getting search responce from Flickr.
        //*****************************************************************
        func searchFlickrForTerm(searchTerm: String, completion : (results: FlickrSearchResults?, error : NSError?) -> Void){
            let searchURL = flickrSearchURLForSearchTerm(searchTerm)
            let urlString = searchURL.absoluteString
            let manager = AFHTTPRequestOperationManager(baseURL: searchURL)
            manager.requestSerializer = AFHTTPRequestSerializer()
            manager.responseSerializer = AFHTTPResponseSerializer()
            manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json") as Set<NSObject>
            manager.GET(urlString, parameters: nil, success: { (operation:AFHTTPRequestOperation, data:AnyObject) -> Void in
                do{
                    let jsonResult:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data as! NSData, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                    
                    switch (jsonResult["stat"] as! String) {
                    case "ok":
                        print("Results processed OK")
                    case "fail":
                        let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:jsonResult["message"]!])
                        completion(results: nil, error: APIError)
                        return
                    default:
                        let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Uknown API response"])
                        completion(results: nil, error: APIError)
                        return
                    }
                    
                    let photosContainer = jsonResult["photos"] as! NSDictionary
                    let photosReceived = photosContainer["photo"] as! [NSDictionary]
                    let flickrPhotos : [FlickrPhoto] = photosReceived.map {
                        photoDictionary in
                        let photoID = photoDictionary["id"] as? String ?? ""
                        let farm = photoDictionary["farm"] as? Int ?? 0
                        let server = photoDictionary["server"] as? String ?? ""
                        let secret = photoDictionary["secret"] as? String ?? ""
                        let flickrPhoto = FlickrPhoto(photoID: photoID, farm: farm, server: server, secret: secret)
                        let imageData = NSData(contentsOfURL: flickrPhoto.flickrImageURL())
                        flickrPhoto.thumbnail = UIImage(data: imageData!)
                        return flickrPhoto
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(results:FlickrSearchResults(searchTerm: searchTerm, searchResults: flickrPhotos), error: nil)
                    })
                }catch{
                }
                }) { (oertaion:AFHTTPRequestOperation?, error:NSError) -> Void in
                    print(error.localizedDescription)
            }
        }
    }

    // Create Search flickr URL
    private func flickrSearchURLForSearchTerm(searchTerm:String) -> NSURL {
        let encodedTerm = (searchTerm as NSString).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let searchURLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(FLICKR_API_KEY)&text=\(encodedTerm)&format=json&nojsoncallback=1"
        return NSURL(string: searchURLString)!
    }



