//
//  Extension.swift
//  AR-X
//
//  Created by okMAC on 13/07/19.
//  Copyright © 2019 PRABHAKAR JHA. All rights reserved.
//

import Foundation
import ARKit
extension ARPlaneAnchor {

var widthInMeter: Float{ return self.extent.x  }

var lengthInMeter: Float{ return self.extent.y  }

var heightInMeter: Float{ return self.extent.z }

}
