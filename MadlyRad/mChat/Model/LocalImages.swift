
import Foundation


enum LocalImages: String {
    case first = "firstImage"
    case second = "secondImage"
    case third = "thirdImage"
    var name: String {
        return self.rawValue
    }
}
