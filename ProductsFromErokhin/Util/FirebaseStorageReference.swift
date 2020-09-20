//
//  FirebaseStorageReference.swift
//  ProductsFromErokhin
//
//  Created by Alexander Satunin on 20.09.2020.
//  Copyright © 2020 Alexander Satunin. All rights reserved.
//

import Foundation
import FirebaseStorage
import SwinjectStoryboard

/** - Returns: Referense for path from Firebase Storage */
func storageReference(path: String) -> StorageReference {
    SwinjectStoryboard.defaultContainer.resolve(StorageReference.self)!.child(path)
}
