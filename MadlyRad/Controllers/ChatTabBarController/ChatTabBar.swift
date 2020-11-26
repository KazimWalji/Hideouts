

import UIKit
import Firebase
import ImagePicker



class ChatTabBar: UITabBarController{
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var itemBackgroundView = UIView()
    let contactsImage = UIImage(systemName: "person.fill")
    let chatsImage = UIImage(systemName: "message.fill")
    let settingsImage = UIImage(systemName: "gear")
    let homepageImage = UIImage(systemName: "house.fill")
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        tabBar.barTintColor = UIColor(red: 132/255, green: 96/255, blue: 240/255, alpha: 1)
        //UIColor(displayP3Red: 107/255, green: 50/255, blue: 168/255, alpha: 1)
        tabBar.tintColor = .white
        self.tabBar.unselectedItemTintColor = .opaqueSeparator
        //delegate = self

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let index = -(tabBar.items?.firstIndex(of: tabBar.selectedItem!)?.distance(to: 0))!
        let frame = frameForTabAtIndex(index: index)
        itemBackgroundView.center.x = frame.origin.x + frame.width/2
        itemBackgroundView.alpha = 1
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        let numberOfItems = CGFloat(tabBar.items!.count)
        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems - 20, height: tabBar.frame.height)
        var yValue: CGFloat = 44
        if tabBarItemSize.height < 50 {
            yValue = 40
       }
        itemBackgroundView = UIView(frame: CGRect(x: tabBarItemSize.width / 2, y: yValue, width: 6, height: 6))
        itemBackgroundView.backgroundColor = .white
        itemBackgroundView.layer.cornerRadius = 3
        itemBackgroundView.alpha = 0
        tabBar.addSubview(itemBackgroundView)
   }
 
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = -(tabBar.items?.firstIndex(of: item)?.distance(to: 0))!
            let frame = frameForTabAtIndex(index: index)
            let completedFrame = frame.origin.x + frame.width/2
            let icon = tabBar.subviews[index+1].subviews.first as! UIImageView
            itemBackgroundView.transform = CGAffineTransform(scaleX: 0.3, y: 2)
            if icon.image == settingsImage {
                icon.transform = CGAffineTransform(rotationAngle: 2)
            }else if icon.image == contactsImage{
                icon.transform = CGAffineTransform(scaleX: 0.5, y: 1)
            }else{
                icon.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.itemBackgroundView.center.x = completedFrame
                self.itemBackgroundView.alpha = 0.5
                self.itemBackgroundView.transform = .identity
                icon.transform = .identity
            }) { (true) in
                self.itemBackgroundView.alpha = 1
            }
        }
 
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
 
    private func frameForTabAtIndex(index: Int) -> CGRect {
        var frames = tabBar.subviews.compactMap { (view:UIView) -> CGRect? in
            if let view = view as? UIControl {
                for item in view.subviews {
                    if let image = item as? UIImageView {
                        return image.superview!.convert(image.frame, to: tabBar)
                    }
                }
                return view.frame
            }
            return nil
        }
        frames.sort { $0.origin.x < $1.origin.x }
        if frames.count > index {
            return frames[index]
        }
        return frames.last ?? CGRect.zero
    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupVC(){
        let home = UINavigationController(rootViewController: HomeViewController())
        let chats = UINavigationController(rootViewController: ConversationsVC())
        let contacts = UINavigationController(rootViewController: ContactsVC())
        let settings = UINavigationController(rootViewController: SettingsVC())
        let images = [homepageImage, chatsImage, contactsImage, settingsImage]
        let controllers = [home, chats, contacts, settings]
        
        for c in 0..<controllers.count{
            let navBar = controllers[c].navigationBar
            navBar.barTintColor = UIColor(red: 132/255, green: 96/255, blue: 240/255, alpha: 1)
            //UIColor(displayP3Red: 107/255, green: 50/255, blue: 168/255, alpha: 1)
    //UIColor(displayP3Red: 151/255, green: 119/255, blue: 248/255, alpha: 1)
            navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            controllers[c].tabBarItem.image = images[c]
        }
        viewControllers = controllers
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
         override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
             let service = LocalStoreImagesService()
             service.load(id: LocalImages.first.name) { [weak self] (image) in
                 if image == nil {
                     self?.showImagePicker()
                 } else {
                     self?.showImagesPopup()
                 }
             }
         }

     }

     extension ChatTabBar {
         func showImagePicker() {
             var configuration = Configuration()
             configuration.doneButtonTitle = "Save"
             configuration.noImagesTitle = "Sorry! There are no images here!"
             configuration.recordLocation = false

             let imagePickerController = ImagePickerController(configuration: configuration)
             imagePickerController.imageLimit = 3
             imagePickerController.delegate = self
             present(imagePickerController, animated: true, completion: nil)
         }
         
         func showImagesPopup() {
             let uploadPopup = UploadPhotosPopup(nibName: "UploadPhotosPopup", bundle: nil)
             uploadPopup.modalPresentationStyle = .overFullScreen
             uploadPopup.onUpload = { [weak self] in
                 uploadPopup.dismiss(animated: true, completion: nil)
                 self?.showImagePicker()
             }
             self.viewControllers?.first?.present(uploadPopup, animated: false, completion: nil)
         }
     }
     extension ChatTabBar: UITabBarControllerDelegate{
         func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

              guard let fromView = selectedViewController?.view, let toView = viewController.view else {
                return false // Make sure you want this as false
              }

              if fromView != toView {
                UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
              }

              return true
          }
     }
     extension ChatTabBar: ImagePickerDelegate {
         func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
             
         }
         
         func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
             imagePicker.dismiss(animated: true, completion: nil)
             DispatchQueue.global(qos: .userInitiated).async {
                 let service = LocalStoreImagesService()
                 for (index,image) in images.enumerated() {
                     var id = ""
                     switch index {
                     case 0:
                         id = LocalImages.first.name
                     case 1:
                         id = LocalImages.second.name
                     case 2:
                         id = LocalImages.third.name
                     default:
                         break
                     }
                     service.cacheImage(image: image, id: id)
                 }
             }
         }
         
         func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
             imagePicker.dismiss(animated: true, completion: nil)
         }
     }

