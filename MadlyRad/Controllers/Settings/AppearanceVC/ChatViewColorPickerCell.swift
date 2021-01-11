

import UIKit

class ChatViewColorPickerCell: UICollectionViewCell {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    let viewLabel = UILabel()
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViewLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupViewLabel() {
        addSubview(viewLabel)
        viewLabel.translatesAutoresizingMaskIntoConstraints = false
        viewLabel.font = UIFont.boldSystemFont(ofSize: 13)
        let constraints = [
            viewLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            viewLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
