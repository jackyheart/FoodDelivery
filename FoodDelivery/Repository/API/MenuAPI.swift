//
//  MenuAPI.swift
//  FoodDelivery
//
//  Created by Jacky Tjoa on 28/3/21.
//  Copyright © 2021 Jacky Tjoa. All rights reserved.
//

import Moya
import Alamofire

enum MenuAPI {
    case getMenuList()
}

extension MenuAPI: TargetType {
    
    var baseURL: URL {
        let url = "http://www.urlpathtotheresource.com/api"
        return URL(string: url)!
    }
    
    var path: String {
        switch self {
        case .getMenuList():
            return "/menu"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var sampleData: Data {
        
        guard let path = Bundle.main.path(forResource: "menu", ofType: "json") else {
            return Data()
        }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url)
            return data
            
        } catch {
            print(error)
        }
        
        return Data()
    }
}
