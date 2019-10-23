//
//  SushiPiece.swift
//  SushiTower
//
//  Created by ME
//  Copyright © 2019 Parrot. All rights reserved.
//

import Foundation
import SpriteKit

// A custom SpriteNode class.
// Used to represent a piece of sushi in the tower.
class SushiPiece: SKSpriteNode {
    
    // MARK: Variables
    // --------------------------------
    
    
    // MARK: Constructor - required nonsense
    // --------------------------------
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    // Required nonsense
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Mark:  Functions
    // --------------------------------
}
