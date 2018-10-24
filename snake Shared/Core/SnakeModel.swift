//
//  SnakeModel.swift
//  snake
//
//  Created by Astemir Eleev on 24/10/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import CoreGraphics

class SnakeModel {
    
    // MARK: - Properties
    
    private let movement: MovementProtocol
    private let worldSize: WorldSize
    
    private(set) var points: Array<CGPoint> = []
    private(set) var direction: Direction = .left
    private(set) var length = 0
    private(set) var directionLocked = false
    
    // MARK: - Initializers
    
    init(worldSize: WorldSize, length: Int) {
        movement = CellMovement(startingDirection: direction)
        
        self.worldSize = worldSize
        self.length = length
        
        let x:Int = self.worldSize / 2
        let y:Int = self.worldSize / 2
        
        for i in 0...self.length {
            let p = CGPoint(x:x + i, y: y)
            self.points.append(p)
        }
    }
    
    // MARK: - Methods
    
    func move() {
        self.points.removeLast()
        let head = movement.move(point: points[0], withRespectTo: self.worldSize)
        self.points.insert(head, at: 0)
    }
    
    func change(direction: Direction) {
        if directionLocked { return }
        if self.direction.isAbleToSwitch(toNew: direction) {
            self.direction = direction
        }
    }
    
    func increaseLength(_ newLenght:Int) {
        let lastPoint = points[points.count-1]
        let theOneBeforeLastPoint = points[points.count-2]
        var x = lastPoint.x - theOneBeforeLastPoint.x
        var y = lastPoint.y - theOneBeforeLastPoint.y
        
        let newWorldSize = (worldSize - 1).toCGFloat
        
        if lastPoint.x == 0, theOneBeforeLastPoint.x == newWorldSize {
            x = 1
        }
        if lastPoint.x == newWorldSize, theOneBeforeLastPoint.x == 0 {
            x = -1
        }
        if lastPoint.y == 0, theOneBeforeLastPoint.y == newWorldSize {
            y = 1
        }
        if lastPoint.y == newWorldSize, theOneBeforeLastPoint.y == 0 {
            y = -1
        }
        
        for i in 0..<newLenght {
            let incrementedI = (i + 1).toCGFloat
            
            let x = (lastPoint.x + x * incrementedI).toInt % worldSize
            let y = (lastPoint.y + y * incrementedI).toInt % worldSize
            points += [CGPoint(x: x, y: y)]
        }
    }
    
    func isHeadHitBody() -> Bool {
        let headPoint = points[0]
        
        for bodyPoint in points[1..<points.count] {
            if (bodyPoint.x == headPoint.x &&
                bodyPoint.y == headPoint.y) {
                return true
            }
        }
        return false
    }
    
    func lockDirection() {
        self.directionLocked = true
    }
    
    func unlockDirection() {
        self.directionLocked = false
    }
}
