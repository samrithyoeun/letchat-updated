//
//  Result.swift
//  let's chat
//
//  Created by PM Academy 3 on 7/24/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(String)
}
