//
//  PlaneNode.swift
//  AR-X
//  Created by okMAC on 13/07/19.
//  Copyright © 2019 PRABHAKAR JHA. All rights reserved.
//

import Foundation
import SceneKit
import ARKit
import UIKit


class Plane: SCNNode {
    var anchor: ARPlaneAnchor!
    
    // geometries
    var plane: SCNPlane!
    var text: SCNText!
    

    init(anchor: ARPlaneAnchor) {
        super.init()
        self.anchor = anchor
        initHelper()
    }
    
    func initHelper() {
    
      self.plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
      
         let material = SCNMaterial()
        material.diffuse.contents = UIColor.blue.withAlphaComponent(0.50)
        self.plane!.materials = [material]
        
        let planeNode = SCNNode(geometry: self.plane)
        planeNode.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1.0, 0.0, 0.0)
        planeNode.name = "plane"
        updatePlaneMaterialDimensions()
    
        self.addChildNode(planeNode)
        
        
        let textMaterial = SCNMaterial();
        textMaterial.diffuse.contents = UIColor.white
        
        let height = anchor.heightInMeter
        var y2 = anchor.lengthInMeter
       
       if height > 0 {
       
       y2 = height
       
        }

         text = SCNText(string: String(format: "%.1f m ", anchor.widthInMeter) + " x " + String(format: "%.1f m ", y2), extrusionDepth: 1)
        
        
        text.font = UIFont.systemFont(ofSize: 10)
        text.materials = [textMaterial]
    
    
    print("width: \(anchor.widthInMeter) length: \(anchor.lengthInMeter)" )
    
    print("area: \(anchor.widthInMeter * y2)")
        let textNode = SCNNode(geometry: text)
        textNode.name = "text"
        textNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
        textNode.transform = SCNMatrix4MakeRotation(Float(-Double.pi / 2.0), 1.0, 0.0, 0.0);
        textNode.scale = SCNVector3Make(0.005, 0.005, 0.005)
        
        addChildNode(textNode)
       
    }
    
    func updateWithNewAnchor(_ anchor: ARPlaneAnchor) {
        // first, we update the extent of the plan, because it might have changed
        self.plane.width = CGFloat(anchor.extent.x)
        self.plane.height = CGFloat(anchor.extent.z)
        
        // now we should update the position (remember the transform applied)
        self.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
        
        // update the material representation for this plane
        updatePlaneMaterialDimensions()
    }
    
    func updatePlaneMaterialDimensions() {
        // get material or recreate
        let material = self.plane.materials.first!
        
        // scale material to width and height of the updated plane
        let width = Float(self.plane.width)
        let height = Float(self.plane.height)
        material.diffuse.contentsTransform = SCNMatrix4MakeScale(width, height, 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


