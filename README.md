# BasicAugmentedRealityApp

Basic Augmented Reality App

# Detecting Planes

# ViewController.swift

``` swift
//
//  ViewController.swift
//  ARAppTheFirst
//
//  Created by Carlos Santiago Cruz on 1/7/19.
//  Copyright © 2019 Carlos Santiago Cruz. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    var planes: [OverlayPlane] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        
        sceneView.showsStatistics = true
        sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
        sceneView.delegate = self
        sceneView.session.run(configuration, options: [])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tap.numberOfTapsRequired = 1
        sceneView.addGestureRecognizer(tap)
        
        let dobleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        dobleTap.numberOfTapsRequired = 2
        sceneView.addGestureRecognizer(dobleTap)
        
        tap.require(toFail: dobleTap)
    }

    func loadValveScene() {
        let valveScene = SCNScene(named: "Art.scnassets/978NSP-200-JD-55M-16IP.scn")!
        sceneView.scene = valveScene

    }
    func loadGameScene() {
        let gameScene = SCNScene(named: "Art.scnassets/sceneGame.scn")!
        sceneView.scene = gameScene
    }
    func createBox(hitResult:ARHitTestResult) -> SCNNode{
        let box = SCNBox(width: 0.3, height: 0.3, length: 0.3, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "woodMaterial")
        box.materials = [material]
        let boxNode = SCNNode(geometry: box)
        boxNode.position = SCNVector3(x: hitResult.worldTransform.columns.3.x,
                                      y: hitResult.worldTransform.columns.3.y + Float(box.height/2) + 0.30,
                                      z: hitResult.worldTransform.columns.3.z)
        
        boxNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        boxNode.physicsBody?.isAffectedByGravity = true
        return boxNode
    }
    
    func createSphere(hitResult: ARHitTestResult, radius:CGFloat, color:UIColor) -> SCNNode{
        let sphere =  SCNSphere(radius: radius)
        let material  =  SCNMaterial()
        material.diffuse.contents = color
        sphere.materials = [material]
        let sphereNode  = SCNNode(geometry: sphere)
        sphereNode.position = SCNVector3(x: hitResult.worldTransform.columns.3.x,
                                         y: hitResult.worldTransform.columns.3.y + 0.30,
                                         z: hitResult.worldTransform.columns.3.z)
        sphereNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        sphereNode.physicsBody?.isAffectedByGravity = true
        
        return sphereNode
        
    }
    
    func createShip(hitResult:ARHitTestResult) -> SCNNode{
        guard
            let shipScene = SCNScene(named: "Art.scnassets/ship-2.scn"),
            let shipNode = shipScene.rootNode.childNode(withName: "ship-2",
                                                        recursively: false) else {return SCNNode()}
        shipNode.position = SCNVector3(x: hitResult.worldTransform.columns.3.x,
                                       y: hitResult.worldTransform.columns.3.y,
                                       z: hitResult.worldTransform.columns.3.z)
        shipNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        shipNode.physicsBody?.isAffectedByGravity = true
        return shipNode
        
    }
    
    func createShip2(hitResult:ARHitTestResult) -> SCNNode{
        guard
            let shipScene = SCNScene(named: "Art.scnassets/ship-2.scn"),
            let shipNode = shipScene.rootNode.childNode(withName: "ship-2", recursively: false)
            else {return SCNNode()}
        shipNode.position = SCNVector3(x: hitResult.worldTransform.columns.3.x,
                                       y: hitResult.worldTransform.columns.3.y,
                                       z: hitResult.worldTransform.columns.3.z)
        shipNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        shipNode.physicsBody?.isAffectedByGravity = true
        return shipNode
        
    }
    
    @objc func tapped(recognizer:UIGestureRecognizer){
        print("one tap")
        let touchLocation = recognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
        if let hitResult = hitResults.first{
            let node = createShip(hitResult: hitResult)
            sceneView.scene.rootNode.addChildNode(node)
            
        }
    }
    @objc func doubleTapped(recognizer:UIGestureRecognizer){
        print("twice")
        let touchLocation = recognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(touchLocation, options: [:])
        if let hitResult = hitResults.first{
            let node = hitResult.node
            node.physicsBody?.applyForce(SCNVector3(x: hitResult.worldCoordinates.x * 14.0,
                                                    y: hitResult.worldCoordinates.y * 14.0,
                                                    z: hitResult.worldCoordinates.z * 14.0),
                                         asImpulse: true)
        }
    }
    func createValve(x: Float = 0, y: Float = 0, z: Float = -3) {
        guard
            let valveScene = SCNScene(named: "art.scnassets/978NSP-200-JD-55M-16IP.scn"),
            let valveNode = valveScene.rootNode.childNode(withName: "completeValve", recursively: true)
            else {
                print("we couldn create the valve scene")
                return }
        
        valveNode.position = SCNVector3(x, y, z)
        valveNode.scale = SCNVector3(0.5, 0.5, 0.5)
        sceneView.scene.rootNode.addChildNode(valveNode)
    }
}



//MARK: SceneView delegate
extension ViewController : ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        // planeAnchor is passed to constructor OverlayPlay to get a a plane and this setup geometry, material, rotation and physics. it returns a
        let plane = OverlayPlane(planeAnchor: planeAnchor)
        planes.append(plane)
        node.addChildNode(plane)
        print("A new plane has been discovered")
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        for plane in planes {
            if planeAnchor.identifier == plane.planeAnchor.identifier{
                plane.update(planeAnchor: planeAnchor)
            }
        }

    }
    
}
```

# OverlayPlane.swift

``` swift
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
```


    
    


