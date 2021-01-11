import Foundation

var gopherName = ["normalGopher", "tripleGopher", "girlGopher", "hole"] //change to fit new game

class Gopher
{
    private var point: Int
    private var name: String
    
    init()
    {
        name = gopherName[3]
        point = 0
    }
    
    func getName() -> String {
        return name
    }
    
    func getPoint() -> Int {
        return point
    }
    
    func randomChangeType() {
        let type = Int.random(in: 0...2)
        name = gopherName[type]
        point = ((type * 2) + 1) * 12
    }
    
    func setAsBurrow()
    {
        name  = gopherName[3]
        point = 0
    }
}
