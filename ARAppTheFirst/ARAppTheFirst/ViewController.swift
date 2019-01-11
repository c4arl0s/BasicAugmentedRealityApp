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
        
        createValve()
        
    }
    func loadValveScene() {
        let valveScene = SCNScene(named: "Art.scnassets/978NSP-200-JD-55M-16IP.dae")!
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
    func createValve(x: Float = 0, y: Float = 0, z: Float = -1.0) {
        guard let valveScene = SCNScene(named: "978NSP-200-JD-55M-16IP.dae") else { return }
        let valveNode = SCNNode()
        let valveSceneChildNodes = valveScene.rootNode.childNodes
        
        for childNode in valveSceneChildNodes {
            valveNode.addChildNode(childNode)
        }
        
        valveNode.position = SCNVector3(x, y, z)
        valveNode.scale = SCNVector3(1, 1, 1)
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
