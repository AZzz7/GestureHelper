//
//  GesutreRespndViewController.swift
//  GestureHelper
//
//  Created by AZ on 2018/7/25.
//  Copyright © 2018年 AZ. All rights reserved.
//

import UIKit

class GesutreRespndViewController: UIViewController {

    fileprivate var mLabel : UILabel!
    fileprivate var mGestureHelper : GestureHelper?
    var index : NSInteger = 0
    fileprivate var mBasicGestureTypes : Array<GestureType> = [.G_SELECT_TAP,.G_MENU_TAP,.G_PLAY_PAUSE_TAP]
    fileprivate var mTouchSurfaceSwipeTypes : Array<GestureType> = [.G_UP_SWIPE,.G_DOWN_SWIPE,.G_LEFT_SWIPE,.G_RIGHT_SWIPE]
    fileprivate var mTouchSurfaceSingleTapTypes : Array<GestureType> = [.G_UP_ARROW_SINGLE_TAP,.G_DOWN_ARROW_SINGLE_TAP,.G_LEFT_ARROW_SINGLE_TAP,.G_RIGHT_ARROW_SINGLE_TAP]
    fileprivate var mTouchSurfaceDoubleTapTypes : Array<GestureType> = [.G_UP_ARROW_DOUBLE_TAP,.G_DOWN_ARROW_DOUBLE_TAP,.G_LEFT_ARROW_DOUBLE_TAP,.G_RIGHT_ARROW_DOUBLE_TAP]
    fileprivate var mCustomDefinePressTypes : Array<GestureType> = [.G_UP_ARROW_LONG_PRESS,.G_DOWN_ARROW_LONG_PRESS,.G_LEFT_ARROW_LONG_PRESS,.G_RIGHT_ARROW_LONG_PRESS,]
    override func viewDidLoad() {
        super.viewDidLoad()
        mLabel = UILabel.init(frame: CGRect.init(x: 100, y: 100, width: 1000, height: 100))
        mLabel.textColor = UIColor.black
        mLabel.textAlignment = .center
        mLabel.backgroundColor = UIColor.orange
        view.addSubview(mLabel)
        mLabel.text = "Test"
        initializeGestureHelper()
        addGestures()
    }
    
    fileprivate func initializeGestureHelper(){
        mGestureHelper = GestureHelper.init(targetView: self.view)
        mGestureHelper?.gestureDelegate = self
    }
    
    fileprivate func addGestures(){
        switch index {
        case 0:
            addBasicGestures()
        case 1:
            addTouchSurfaceGestures()
        case 2:
            addCustomDefieGestures()
        case 3:
            addAllGesures()
        default:
            break
        }
    }
    
    deinit {
        mGestureHelper?.clean()
        print("GesutreRespndViewController Deinit")
    }

}

extension GesutreRespndViewController{
    
    fileprivate func addBasicGestures(){
        mGestureHelper?.addGestureTypes(mBasicGestureTypes)
    }
    
    fileprivate func removeBasicGestures(){
        mGestureHelper?.removeGestureTypes(mBasicGestureTypes)
    }
    
    fileprivate func addTouchSurfaceGestures(){
        let newArray = mTouchSurfaceSwipeTypes + mTouchSurfaceSingleTapTypes + mTouchSurfaceDoubleTapTypes
        mGestureHelper?.addGestureTypes(newArray)
    }
    
    fileprivate func removeAllGestures(){
        mGestureHelper?.removeAllGestures()
    }
    
    fileprivate func addCustomDefieGestures(){
        mGestureHelper?.addGestureTypes(mCustomDefinePressTypes)
    }
    
    fileprivate func addAllGesures(){
        let newArray = mBasicGestureTypes + mTouchSurfaceSwipeTypes + mTouchSurfaceSingleTapTypes + mTouchSurfaceDoubleTapTypes + mCustomDefinePressTypes
        mGestureHelper?.addGestureTypes(newArray)
    }
}

extension GesutreRespndViewController : GestureHelperDelegate{
    
    // GESTURE SHOULD RESPOND
    func gestureShouldBegin(_ gesture: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // BASIC GESTURES
    func didSelectTappGesture() {
        mLabel.text = #function
    }
    
    func didMenuTapGesture() {
        mLabel.text = #function
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func didPlayPaseTapGesture() {
        mLabel.text = #function
    }
    
    // TouchSurface GESTURE
    // SWIPE
    func didSwipeGesture(_ direction: UISwipeGestureRecognizerDirection) {

    }
    
    func didUpSwipeGesture() {
        mLabel.text = #function
    }
    
    func didDownSwipeGesture() {
        mLabel.text = #function
    }
    
    func didLeftSwipeGesture() {
        mLabel.text = #function
    }
    
    func didRightSwipeGesture() {
        mLabel.text = #function
    }
    
    // SINGLE TAP
    func didUpArrowSingleTapGesture() {
        mLabel.text = #function
    }
    
    func didDownArrowSingleTapGesture() {
        mLabel.text = #function
    }
    
    func didLeftArrowSingleTapGesture() {
        mLabel.text = #function
    }
    
    func didRightArrowSingleTapGesture() {
        mLabel.text = #function
    }
    
    // DOUBLE TAP
    func didUpArrowDoubleTapGesture() {
        mLabel.text = #function
    }
    
    func didDownArrowDoubleTapGesture() {
        mLabel.text = #function
    }
    
    func didLeftArrowDoubleTapGesture() {
        mLabel.text = #function
    }
    
    func didRightArrowDoubleTapGesture() {
        mLabel.text = #function
    }
    // CUSTOM DEFINE LONG PRESS
    func didLongPressGesture(_ direction: PressGestureRecognizerDirection) {

    }
    
    func didLongPressBegin(_ direction: PressGestureRecognizerDirection) {
        mLabel.text = #function + "\(direction.rawValue)"
    }
    
    func didLongPressEnd(_ timeInterVal: TimeInterval) {
        mLabel.text = #function + "\(timeInterVal)Seconds"
    }
    
    func didLongPressFailed() {
        
    }

    
}

