
import UIKit

class AlbumViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate,UICollectionViewDelegateFlowLayout {
    
    // MARK: Create Outlets and Proprty.
    //*****************************************************************
     @IBOutlet weak var AlbumCollection:UICollectionView!
     @IBOutlet weak var SearchText:UITextField!
    
     var sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
     var searches = [FlickrSearchResults]()
     var flickr = Flickr()
     var flickrPhoto:FlickrPhoto!
    
    // MARK: ViewDidLoad
    //*****************************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SearchText.delegate = self
        let dismiss: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(dismiss)

    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    // MARK: UITextField Delegate Method.
    //*****************************************************************
    func DismissKeyboard(){
        view.endEditing(true)
        SearchText.resignFirstResponder()
    }
    func textFieldDidEndEditing(textField: UITextField) {
        SearchText.resignFirstResponder()
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if(string == "\n"){
            SearchText.resignFirstResponder()
            return false
        }
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        
        let searchStr:String = SearchText.text!
        flickr.searchFlickrForTerm(searchStr) {
            results, error in
            
            activityIndicator.removeFromSuperview()
            
            if error != nil {
                print("Error searching : \(error)")
                let alert:UIAlertView = UIAlertView(title: "Error", message: "Something went wrong please try again.", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
            
            if results != nil {
                print("Found \(results!.searchResults.count) matching \(results!.searchTerm)")
                self.searches.insert(results!, atIndex: 0)
                self.AlbumCollection?.reloadData()
            }
        }
        SearchText.text = nil
        SearchText.resignFirstResponder()
        return true
    }
    
    // Get index path of filtered image from Flickr.
    func photoForIndexPath(indexPath: NSIndexPath) -> FlickrPhoto {
        return searches[indexPath.section].searchResults[indexPath.row]
    }
    // MARK: CollectionView DataSource and Delegate Method.
    //*****************************************************************
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return searches.count
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searches[section].searchResults.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : CollectionCell = AlbumCollection.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CollectionCell
        flickrPhoto = photoForIndexPath(indexPath)
        cell.backgroundColor = UIColor.blackColor()
        cell.ImageView.image = flickrPhoto.thumbnail
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
      flickrPhoto = photoForIndexPath(indexPath)
        self.performSegueWithIdentifier("fullimage", sender: indexPath)
    }
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // Navigate to FullViewController for show full image.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "fullimage")
        {
            let ObjVC = segue.destinationViewController as! FullViewController
            ObjVC.image = flickrPhoto.thumbnail
        }
    }
}



















