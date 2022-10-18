//
//  Responses.swift
//  notesapp
//
//  Created by Rehan Sarwar on 10/12/22.
//  Copyright © 2020 Confiz. All rights reserved.
//

import Foundation
struct LoginRes: Codable {
  let token: String?
  let error: String?
}
