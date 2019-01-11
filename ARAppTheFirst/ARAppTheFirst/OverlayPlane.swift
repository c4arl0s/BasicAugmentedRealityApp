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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var planeGeometry : SCNPlane?
    var planeAnchor : ARPlaneAnchor
    
    init(planeAnchor : ARPlaneAnchor) {
        self.planeAnchor = planeAnchor
        super.init()
        setup()
    }
    
    private func setup(){
        planeGeometry = SCNPlane(width: CGFloat(planeAnchor.extent.x),
                                 height: CGFloat(planeAnchor.extent.z))
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "grid_texture")
        
        planeGeometry?.materials = [material]
        
        let planeNode = SCNNode(geometry: planeGeometry)
        planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
        
        //va a rotar sobre el eje de x
        //es pi negativo porque si esta positivo no vamos a poder ver la textura
        
        planeNode.transform = SCNMatrix4MakeRotation(Float(-Float.pi/2), 1, 0, 0)
        planeNode.physicsBody = SCNPhysicsBody(type: .static,
                                               shape: SCNPhysicsShape(geometry: planeGeometry!,
                                                                      options: nil))
        planeNode.physicsBody?.isAffectedByGravity = false
        
        self.addChildNode(planeNode)
        
    }
    
    func update(planeAnchor: ARPlaneAnchor){
        planeGeometry?.width = CGFloat(planeAnchor.extent.x)
        planeGeometry?.height = CGFloat(planeAnchor.extent.z)
        
        self.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
        let planeNode = self.childNodes.first
        planeNode?.physicsBody = SCNPhysicsBody(type: .static,
                                                shape: SCNPhysicsShape(geometry: planeGeometry!,
                                                                       options: nil))
        planeNode?.physicsBody?.isAffectedByGravity = false
        
    }
    
}
