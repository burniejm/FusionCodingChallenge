//
//  UIStoryboard+Extensions.swift
//  FusionCodingChallenge
//
//  Created by John Macy on 1/20/23.
//

import UIKit

extension UIStoryboard {
    
    class var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: .main)
    }

    func getVC<T: UIViewController>() -> T {
        return self.instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }
}
