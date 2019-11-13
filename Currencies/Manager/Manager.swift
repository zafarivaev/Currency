import Foundation

class Manager {
    
    static let shared = { Manager() }()
    
    lazy var apiURL: String = {
       return "https://api.exchangeratesapi.io/latest/"
    }()
}
