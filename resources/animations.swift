import Foundation

class Animations {
    
    // Each animation has to be registered here.
    static var animations: [String: Animation] = ["Disco": Disco(), "Snake": Snake()]
    
    static func getAnimationNames() -> [String] {
        return Array(animations.keys)
    }
    
}
