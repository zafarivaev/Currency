import Foundation
import Alamofire
import SwiftyJSON

class APIClient: NSObject {
    
    var baseURL: URL?
    
    static let shared = { APIClient(baseURL: Manager.shared.apiURL) }()
    
    required init(baseURL: String){
        self.baseURL = URL(string: baseURL)
    }
    
    func get(_ urlString: String, success: @escaping (Int, JSON) -> (), failure:  @escaping (Int) -> ()) {
        
        let URL = NSURL(string: urlString, relativeTo: self.baseURL as URL?)
        
        let urlString = URL?.absoluteString!
        
        Alamofire.request(urlString!)
            .responseJSON { (response) -> Void in
            
            if (response.response != nil && response.result.value != nil && (response.response?.statusCode == 200 || response.response?.statusCode == 201)){
                debugPrint("Response - ", response.result.value ?? "")
                success(response.response!.statusCode, JSON(response.result.value!))
            } else if (response.response?.statusCode == 401){
                debugPrint("Not authorized: \(String(describing: response.response?.statusCode))")
            } else{
                debugPrint("Error: \(String(describing: response.response?.statusCode))")
            }
            
        }
    }
}
