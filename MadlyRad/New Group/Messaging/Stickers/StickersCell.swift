

import Kingfisher

//-------------------------------------------------------------------------------------------------------------------------------------------------
class StickersCell: UICollectionViewCell {

	@IBOutlet var imageItem: UIImageView!

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func bindData(sticker: String) {

		let url = URL(string: sticker)
		imageItem.kf.setImage(with: url, placeholder: nil)
	}
}
