

import UIKit

class InfluencerDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoTextView: UITextView!
    
    @IBOutlet weak var instaButton: UIButton!
    @IBOutlet weak var tiktokButton: UIButton!
    
    var data: InfluencerData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard data != nil else {
            return
        }

        imageView.image = UIImage(named: data!.image)
        nameLabel.text = data!.name
        infoTextView.text = data!.info
        instaButton.isHidden = data!.instaLink.count < 5
        tiktokButton.isHidden = data!.tiktokLink.count < 5
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onImageTap))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
    }


    @IBAction func onTiktokHandler(_ sender: Any) {
        guard let link = data?.tiktokLink, let url = URL(string: link) else { return }
        UIApplication.shared.open(url)
    }
    @IBAction func onInstaHandler(_ sender: Any) {
        guard let link = data?.instaLink, let url = URL(string: link) else { return }
        UIApplication.shared.open(url)
    }
    
    @objc
    func onImageTap(_ sender: Any) {
        if let link = data?.imageLink, let url = URL(string: link) {
            UIApplication.shared.open(url)
        }
    }
    
}
