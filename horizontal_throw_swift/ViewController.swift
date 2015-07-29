//
//  ViewController.swift
//  horizontal_throw_swift
//
//  Created by Nero Zuo on 15/7/29.
//  Copyright (c) 2015年 Nero Zuo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var animationView: UIView!
    var _animator: UIDynamicAnimator!
    var _gravity: UIGravityBehavior!
    var _collision: UICollisionBehavior!
    var _itemBehavior: UIDynamicItemBehavior!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.horizontalProjectileMotionWithView(self.animationView, referenceView: view, fromPoint: CGPoint(x: 10, y: 10), toPoint: CGPoint(x: 300, y: 300), magnitude: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func horizontalProjectileMotionWithView(motionView: UIView, referenceView: UIView, fromPoint: CGPoint, toPoint: CGPoint, magnitude: CGFloat = 1.0) {
        _animator = UIDynamicAnimator(referenceView: referenceView)
        _collision = UICollisionBehavior(items: [motionView])
        _itemBehavior = UIDynamicItemBehavior(items: [motionView])
        _itemBehavior.elasticity = 0.0
        _itemBehavior.resistance = 0.0
        _collision.collisionDelegate = self
        let screenRect = UIScreen.mainScreen().bounds
        if fromPoint.y == toPoint.y {
            let screenHeight = screenRect.size.height
            let vel = (toPoint.x - fromPoint.x) / 0.35  //0.35 is animation duration
            let boundX = toPoint.x + motionView.frame.size.width
            _collision.addBoundaryWithIdentifier("vertical bounds", fromPoint: CGPoint(x: boundX, y: 0.0), toPoint: CGPoint(x: boundX, y: screenHeight))
            _itemBehavior.addLinearVelocity(CGPoint(x: vel, y: 0), forItem: motionView)
            _animator.addBehavior(_collision)
            _animator.addBehavior(_itemBehavior)
            return
        }
        _gravity = UIGravityBehavior(items: [motionView])
        _gravity.magnitude = magnitude
        let screenWidth = screenRect.size.width
        _collision .addBoundaryWithIdentifier("horizontal bounds", fromPoint: CGPoint(x: -100.0, y: toPoint.y + motionView.frame.size.height), toPoint: CGPoint(x: screenWidth + 100.0, y: toPoint.y + motionView.frame.size.height))
        _animator.addBehavior(_gravity)
        _animator.addBehavior(_collision)
        let vel = CGPoint(x: self.horizontalSpeedFromPoint(fromPoint, toPoint: toPoint), y: 0.0)
        _itemBehavior.addLinearVelocity(vel, forItem: motionView)
        _animator.addBehavior(_itemBehavior)
        
    }
    
    func horizontalSpeedFromPoint(fromPoint: CGPoint, toPoint: CGPoint) -> CGFloat{
        let verticalSpace = toPoint.y - fromPoint.y
        let duration = sqrt(verticalSpace * 2.0 / (1000.0 * _gravity.magnitude))
        let horizontalSpace = toPoint.x - fromPoint.x
        let horizontalSpeed = horizontalSpace / duration
        return horizontalSpeed
    }

}
extension ViewController: UICollisionBehaviorDelegate {
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying, atPoint p: CGPoint) {
        let vel = _itemBehavior.linearVelocityForItem(item)
        _itemBehavior.addLinearVelocity(CGPoint(x: -vel.x, y: -vel.y), forItem: item)//when collision happened make velocity to 0
    }
}

