
import UIKit

class FullViewController: UIViewController {

    @IBOutlet var SaveBtn: UIButton!
    @IBOutlet var FullImageView: UIImageView!

    var image:UIImage!
    // MARK: ViewDidLoad
    //*****************************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SaveBtn.layer.shadowOffset = CGSizeMake(0, 0.5)
        self.SaveBtn.layer.shadowOpacity = 0.7
        self.FullImageView.image = image
        // Do any additional setup after loading the view.
    }
    // MARK: Save Image Action To Device.
    //*****************************************************************
    @IBAction func SaveImageAction(sender: AnyObject) {
        if(image == nil){
            let alert:UIAlertView = UIAlertView(title: "Error", message: "No image found to save.", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }else{
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            let alert:UIAlertView = UIAlertView(title: "Success", message: "Image Saved Successfully", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    @IBAction func BackBtnAction(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
