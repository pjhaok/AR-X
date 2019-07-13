//
//  ViewController.swift
//  AR-X
//
//  Created by okMAC on 13/07/19.
//  Copyright © 2019 PRABHAKAR JHA. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var planesDict = [UUID: Plane]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(rec:)))
        
        sceneView.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = [.horizontal, .vertical]
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // create a 3d plane from the anchor
        if let arPlaneAnchor = anchor as? ARPlaneAnchor {
            let plane = Plane(anchor: arPlaneAnchor)
            self.planesDict[arPlaneAnchor.identifier] = plane
            sceneView.scene.rootNode.addChildNode(plane)
        }
    }
    
    
    
    @objc func handleTap(rec: UITapGestureRecognizer) {
        
        print("tap")
        
        if rec.state == .ended
        {
            let location = rec.location(in: sceneView)
            let hits = self.sceneView.hitTest(location, options: nil)
            if !hits.isEmpty {
                let tappedNode = hits.first?.node
                
                if let plane = tappedNode?.parent as? Plane {
                    let uuid = plane.anchor.identifier
                    planesDict.removeValue(forKey: uuid)
                    
                    plane.removeFromParentNode()
                    print("removed with uuid: \(uuid)")
                    
                }
            }
        }}
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
