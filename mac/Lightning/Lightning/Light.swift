//
//  Light.swift
//  Lightning
//
//  Created by Marcin Maciaszczyk on 10.12.2016.
//  Copyright © 2016 Marcin Maciaszczyk. All rights reserved.
//

import Foundation

class Light {
    
    var area: CGRect
    var color: Color = Color(red: 0, green: 0, blue: 0)
    
    init(area: CGRect) {
        self.area = area
    }
    
}
