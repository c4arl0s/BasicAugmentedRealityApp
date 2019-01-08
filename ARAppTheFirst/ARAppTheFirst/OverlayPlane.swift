//
//  OverlayPlane.swift
//  ARAppTheFirst
//
//  Created by Carlos Santiago Cruz on 1/8/19.
//  Copyright © 2019 Carlos Santiago Cruz. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class OverlayPlane: SCNNode {
    var planeGeometry: SCNPlane?
    var planeAnchor: ARPlaneAnchor
    init(planeAnchor: ARPlaneAnchor) {
        self.planeAnchor = planeAnchor
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setup(){
        planeGeometry = SCNPlane(width: CGFloat(planeAnchor.extent.x),
                                 height: CGFloat(planeAnchor.extent.z))
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "gridTexture")
        planeGeometry?.materials = [material]
        let planeNode = SCNNode(geometry: planeGeometry)
        planeNode.position = SCNVector3Make(planeAnchor.center.x, 0.0, planeAnchor.center.z)
        
//        planeNode.transform = SCNMatrix4MakeRotation(Float(-Float.pi/2), 1, 0, 0)
        
        self.addChildNode(planeNode)
    }
}
