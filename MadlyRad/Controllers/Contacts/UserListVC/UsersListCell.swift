import UIKit

class UsersListCell: UITableViewCell {

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    let userName = UILabel()
    let userEmail = UILabel()
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //s
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //setupImage()
        //setupNameLabel()
        setupEmailLabel()
        //let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
     //   backgroundImage.image = UIImage(named: "backgroundimageforhideouts.png")
      //  backgroundImage.contentMode = UITableViewCell.ContentMode.scaleAspectFill
        //self.view.insertSubview(backgroundImage, at: 0)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
   
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupEmailLabel(){
        addSubview(userEmail)
        userEmail.numberOfLines = 0
        userEmail.adjustsFontSizeToFitWidth = true
        userEmail.textColor = .black
        userEmail.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            userEmail.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            userEmail.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupNameLabel(){
        addSubview(userName)
        userName.numberOfLines = 0
        userName.adjustsFontSizeToFitWidth = true
        userName.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            userName.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            userName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15)
        ]
        NSLayoutConstraint.activate(constraints)
    }
 
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}
