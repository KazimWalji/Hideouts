

import UIKit

class RestoreToDefaultColorsCell: UITableViewCell {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    let restoreLabel = UILabel()
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupRestoreLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupRestoreLabel() {
        addSubview(restoreLabel)
        restoreLabel.text = "Restore To Default Settings"
        restoreLabel.translatesAutoresizingMaskIntoConstraints = false
        restoreLabel.font = UIFont.boldSystemFont(ofSize: 14)
        restoreLabel.textColor = .red
        let constraints = [
            restoreLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            restoreLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
