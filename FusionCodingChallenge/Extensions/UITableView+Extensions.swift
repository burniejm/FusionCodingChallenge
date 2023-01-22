//
//  UITableView+Extensions.swift
//  FusionCodingChallenge
//
//  Created by John Macy on 1/21/23.
//

import UIKit

extension UITableView {

    func dequeue<T: UITableViewCell>(cellForRowAt indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: "\(T.self)", for: indexPath) as! T
    }

}
