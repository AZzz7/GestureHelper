//
//  GestureHelper.swift
//  GestureHelper
//
//  Created by TianGeng on 2018/7/23.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass
import GameController

/// GestureType
// LongPress Gesture Will Effect SelectTap Gesture
enum GestureType : String{
    case G_SELECT_TAP = "G_SELECT_TAP"
    case G_MENU_TAP = "G_MENU_TAP"
    case G_PLAY_PAUSE_TAP = "G_PLAY_PAUSE_TAP"
    case G_UP_SWIPE = "G_UP_SWIPE"
    case G_DOWN_SWIPE = "G_DOWN_SWIPE"
    case G_LEFT_SWIPE = "G_LEFT_SWIPE"
    case G_RIGHT_SWIPE = "G_RIGHT_SWIPE"
    case G_UP_ARROW_SINGLE_TAP = "G_UP_ARROW_SINGLE_TAP"
    case G_DOWN_ARROW_SINGLE_TAP = "G_DOWN_SINGLE_ARROW_TAP"
    case G_LEFT_ARROW_SINGLE_TAP = "G_LEFT_ARROW_SINGLE_TAP"
    case G_RIGHT_ARROW_SINGLE_TAP = "G_RIGHT_ARROW_SINGLE_TAP"
    case G_UP_ARROW_DOUBLE_TAP = "G_UP_ARROW_DOUBLE_TAP"
    case G_DOWN_ARROW_DOUBLE_TAP = "G_DOWN_SINGLE_DOUBLE_TAP"
    case G_LEFT_ARROW_DOUBLE_TAP = "G_LEFT_ARROW_DOUBLE_TAP"
    case G_RIGHT_ARROW_DOUBLE_TAP = "G_RIGHT_ARROW_DOUBLE_TAP"
    case G_UP_ARROW_LONG_PRESS = "G_UP_ARROW_LONG_PRESS"
    case G_DOWN_ARROW_LONG_PRESS = "G_DOWN_ARROW_LONG_PRESS"
    case G_LEFT_ARROW_LONG_PRESS = "G_LEFT_ARROW_LONG_PRESS"
    case G_RIGHT_ARROW_LONG_PRESS = "G_RIGHT_ARROW_LONG_PRESS"
}

// MARK: - GestureHelperDelegate
@objc protocol GestureHelperDelegate: NSObjectProtocol {
    // remote button tap delegate
    @objc optional func didSelectTappGesture()
    @objc optional func didMenuTapGesture()
    @objc optional func didPlayPaseTapGesture()
    // swipe gesutre delegate
    @objc optional func didSwipeGesture(_ direction:UISwipeGestureRecognizerDirection)
    @objc optional func didUpSwipeGesture()
    @objc optional func didDownSwipeGesture()
    @objc optional func didLeftSwipeGesture()
    @objc optional func didRightSwipeGesture()
    // remote arrow button single click delegate
    @objc optional func didUpArrowSingleTapGesture()
    @objc optional func didDownArrowSingleTapGesture()
    @objc optional func didLeftArrowSingleTapGesture()
    @objc optional func didRightArrowSingleTapGesture()
    // remote arrow button double click delegate
    @objc optional func didUpArrowDoubleTapGesture()
    @objc optional func didDownArrowDoubleTapGesture()
    @objc optional func didLeftArrowDoubleTapGesture()
    @objc optional func didRightArrowDoubleTapGesture()
    // remote pressed
    @objc optional func didLongPressGesture(_ direction:PressGestureRecognizerDirection)
    @objc optional func didLongPressBegin(_ direction:PressGestureRecognizerDirection)
    @objc optional func didLongPressEnd(_ timeInterVal:TimeInterval)
    @objc optional func didLongPressFailed()
    // gesture shouldBegin
    @objc optional func gestureShouldBegin(_ gesture:UIGestureRecognizer) -> Bool
}
class GestureHelper: NSObject {
    fileprivate static let G_TYPE_KEY = UnsafeRawPointer.init(bitPattern: "G_TYPE_KEY".hashValue)!
    fileprivate var mTargetView : UIView?
    fileprivate var mGestureTypes = Array<GestureType>()
    fileprivate var mGestures = Array<UIGestureRecognizer>()
    weak var gestureDelegate : GestureHelperDelegate?
    
    init(targetView:UIView?, _ types:Array<GestureType>? = nil) {
        mTargetView = targetView
        super.init()
        if let mTypes = types{
            mGestureTypes = mTypes
            for type in mTypes{
                addGestureType(type)
            }
        }
    }
    
    func addGestureTypes(_ types:Array<GestureType>){
        for type in types{
            addGestureType(type)
        }
    }
    
    private func addGestureType(_ type:GestureType) {
        switch type {
        case .G_SELECT_TAP,.G_MENU_TAP,.G_PLAY_PAUSE_TAP,
             .G_UP_ARROW_SINGLE_TAP,.G_DOWN_ARROW_SINGLE_TAP,.G_LEFT_ARROW_SINGLE_TAP,.G_RIGHT_ARROW_SINGLE_TAP,
             .G_UP_ARROW_DOUBLE_TAP,.G_DOWN_ARROW_DOUBLE_TAP,.G_LEFT_ARROW_DOUBLE_TAP,.G_RIGHT_ARROW_DOUBLE_TAP:
            addTapGesture(type)
        case .G_UP_SWIPE,.G_DOWN_SWIPE,.G_LEFT_SWIPE,.G_RIGHT_SWIPE:
            addSwipeGesture(type)
        case .G_UP_ARROW_LONG_PRESS,.G_DOWN_ARROW_LONG_PRESS,.G_LEFT_ARROW_LONG_PRESS,.G_RIGHT_ARROW_LONG_PRESS:
            addLongPressGesture(type)
        default:
            break
        }
    }
    
    func removeGestureTypes(_ types:Array<GestureType>){
        for type in types{
            removeGestureType(type)
        }
    }
    
    private func removeGestureType(_ type:GestureType) {
        if let gesture = getGestureWithType(type){
            mTargetView?.removeGestureRecognizer(gesture)
        }
    }
    
    func removeAllGestures() {
        for gesture in mGestures {
            mTargetView?.removeGestureRecognizer(gesture)
        }
        mGestureTypes.removeAll()
        mGestures.removeAll()
    }
    
    func clean(){
        removeAllGestures()
        mTargetView = nil
        gestureDelegate = nil
    }
}
//MARK:- ADD GESTURES
extension GestureHelper{
    
    fileprivate func addTapGesture(_ type:GestureType){
        var pressType = UIPressType(rawValue: -1)
        switch type {
        case .G_SELECT_TAP:
            pressType = .select
        case .G_MENU_TAP:
            pressType = .menu
        case .G_PLAY_PAUSE_TAP:
            pressType = .playPause
        case .G_UP_ARROW_SINGLE_TAP,.G_UP_ARROW_DOUBLE_TAP:
            pressType = .upArrow
        case .G_DOWN_ARROW_SINGLE_TAP,.G_DOWN_ARROW_DOUBLE_TAP:
            pressType = .downArrow
        case .G_LEFT_ARROW_SINGLE_TAP,.G_LEFT_ARROW_DOUBLE_TAP:
            pressType = .leftArrow
        case .G_RIGHT_ARROW_SINGLE_TAP,.G_RIGHT_ARROW_DOUBLE_TAP:
            pressType = .rightArrow
        default:
            break
        }
        if let pType = pressType{
            if type == .G_RIGHT_ARROW_DOUBLE_TAP || type == .G_LEFT_ARROW_DOUBLE_TAP || type == .G_DOWN_ARROW_DOUBLE_TAP || type == .G_UP_ARROW_DOUBLE_TAP{ // DOUBLE TAP
                addExactTapGesture(pType, type, 2)
            }else{
                addExactTapGesture(pType, type)
            }
        }
    }

    fileprivate func addSwipeGesture(_ type:GestureType) {
        var direction = UISwipeGestureRecognizerDirection(rawValue: 0)
        switch type {
        case .G_UP_SWIPE:
            direction = .up
        case .G_DOWN_SWIPE:
            direction = .down
        case .G_LEFT_SWIPE:
            direction = .left
        case .G_RIGHT_SWIPE:
            direction = .right
        default:
            break
        }
        if direction.rawValue != 0{
            addExactSwipeGesture(direction, type)
        }
    }
    
    fileprivate func addLongPressGesture(_ type:GestureType) {
        var direction : PressGestureRecognizerDirection = .unknown
        switch type {
        case .G_UP_ARROW_LONG_PRESS:
            direction = .up
        case .G_DOWN_ARROW_LONG_PRESS:
            direction = .down
        case .G_LEFT_ARROW_LONG_PRESS:
            direction = .left
        case .G_RIGHT_ARROW_LONG_PRESS:
            direction = .right
        default:
            break
        }
        addExactLongPressGesture(direction, type)
    }

    fileprivate func addExactSwipeGesture(_ direction:UISwipeGestureRecognizerDirection, _ type:GestureType) {
        print(#function,direction,type.rawValue)
        let swipeGesutre = UISwipeGestureRecognizer(target: self, action: .didSwipe)
        swipeGesutre.direction = direction
        swipeGesutre.g_type = type
        swipeGesutre.delegate = self
        mTargetView?.addGestureRecognizer(swipeGesutre)
        mGestures.append(swipeGesutre)
    }
    
    fileprivate func addExactTapGesture(_ pressType:UIPressType, _ type:GestureType, _ numberOfTapsRequired:Int = 1) {
        print(#function,pressType,type.rawValue)
        let tapGesture = UITapGestureRecognizer(target: self, action: .didTap)
        tapGesture.allowedPressTypes = [NSNumber(value: pressType.rawValue)]
        tapGesture.g_type = type
        tapGesture.delegate = self
        tapGesture.numberOfTapsRequired = numberOfTapsRequired
        mTargetView?.addGestureRecognizer(tapGesture)
        mGestures.append(tapGesture)
        judgeResponseGestureConflit(type)
    }
    
    fileprivate func addExactLongPressGesture(_ direction:PressGestureRecognizerDirection, _ type:GestureType) {
        print(#function,direction.rawValue,type.rawValue)
        let pressGesture = PressGestureRecognizer.init(target: self, action: .didPress, direction: direction)
        pressGesture.mListener = self
        pressGesture.g_type = type
        mTargetView?.addGestureRecognizer(pressGesture)
        mGestures.append(pressGesture)
    }
    
    fileprivate func judgeResponseGestureConflit(_ type:GestureType) {
        if type == .G_UP_ARROW_SINGLE_TAP || type == .G_UP_ARROW_DOUBLE_TAP{
            if let doubleUpArrowTap = getGestureWithType(.G_UP_ARROW_DOUBLE_TAP),let singleUpArrowTap = getGestureWithType(.G_UP_ARROW_SINGLE_TAP){
                singleUpArrowTap.require(toFail: doubleUpArrowTap)
            }
        }else if type == .G_DOWN_ARROW_SINGLE_TAP || type == .G_DOWN_ARROW_DOUBLE_TAP{
            if let doubleDownArrowTap = getGestureWithType(.G_DOWN_ARROW_DOUBLE_TAP),let singleDownArrowTap = getGestureWithType(.G_DOWN_ARROW_SINGLE_TAP){
                singleDownArrowTap.require(toFail: doubleDownArrowTap)
            }
        }else if type == .G_LEFT_ARROW_SINGLE_TAP || type == .G_LEFT_ARROW_DOUBLE_TAP{
            if let doubleLeftArrowTap = getGestureWithType(.G_LEFT_ARROW_DOUBLE_TAP),let singleLeftArrowTap = getGestureWithType(.G_LEFT_ARROW_SINGLE_TAP){
                singleLeftArrowTap.require(toFail: doubleLeftArrowTap)
            }
        }else if type == .G_RIGHT_ARROW_SINGLE_TAP || type == .G_RIGHT_ARROW_DOUBLE_TAP{
            if let doubleRightArrowTap = getGestureWithType(.G_RIGHT_ARROW_DOUBLE_TAP),let singleRigthArrowTap = getGestureWithType(.G_RIGHT_ARROW_SINGLE_TAP){
                singleRigthArrowTap.require(toFail: doubleRightArrowTap)
            }
        }

    }
    
    fileprivate func getGestureWithType(_ type:GestureType) -> UIGestureRecognizer? {
        var mGesture : UIGestureRecognizer?
        for gesture in mGestures{
            if gesture.g_type == type{
                mGesture = gesture
                break
            }
        }
        return mGesture
    }
    
}
//MARK:- GESTURE RESPOND
extension GestureHelper {

    @objc fileprivate func gestureDidSwipe(_ sender:UISwipeGestureRecognizer) {
        print(#function,sender.direction)
        switch sender.direction {
        case .up:
            gestureDelegate?.didUpSwipeGesture?()
        case .down:
            gestureDelegate?.didDownSwipeGesture?()
        case .left:
            gestureDelegate?.didLeftSwipeGesture?()
        case .right:
            gestureDelegate?.didRightSwipeGesture?()
        default:
            break
        }
        gestureDelegate?.didSwipeGesture?(sender.direction)
    }
    
    @objc fileprivate func gestureDidTap(_ sender:UITapGestureRecognizer) {
        if let type = sender.g_type{
            switch type {
            case GestureType.G_SELECT_TAP:
                gestureDelegate?.didSelectTappGesture?()
            case GestureType.G_MENU_TAP:
                gestureDelegate?.didMenuTapGesture?()
            case GestureType.G_PLAY_PAUSE_TAP:
                gestureDelegate?.didPlayPaseTapGesture?()
            case GestureType.G_UP_ARROW_SINGLE_TAP:
                gestureDelegate?.didUpArrowSingleTapGesture?()
            case GestureType.G_DOWN_ARROW_SINGLE_TAP:
                gestureDelegate?.didDownArrowSingleTapGesture?()
            case GestureType.G_LEFT_ARROW_SINGLE_TAP:
                gestureDelegate?.didLeftArrowSingleTapGesture?()
            case GestureType.G_RIGHT_ARROW_SINGLE_TAP:
                gestureDelegate?.didRightArrowSingleTapGesture?()
            case GestureType.G_UP_ARROW_DOUBLE_TAP:
                gestureDelegate?.didUpArrowDoubleTapGesture?()
            case GestureType.G_DOWN_ARROW_DOUBLE_TAP:
                gestureDelegate?.didDownArrowDoubleTapGesture?()
            case GestureType.G_LEFT_ARROW_DOUBLE_TAP:
                gestureDelegate?.didLeftArrowDoubleTapGesture?()
            case GestureType.G_RIGHT_ARROW_DOUBLE_TAP:
                gestureDelegate?.didRightArrowDoubleTapGesture?()
            default:
                break
            }
        }
    }
    
    @objc fileprivate func gestureDidLongPress(_ sender:UIGestureRecognizer, _ direction:PressGestureRecognizerDirection) {
        gestureDelegate?.didLongPressGesture?(direction)
    }
}


// MARK: - UIGestureRecognizerDelegate
extension GestureHelper : UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool{
        
        return gestureDelegate?.gestureShouldBegin?(gestureRecognizer) ?? true
    }
}

extension GestureHelper : PressGestureRecognizerListener{
    func onGesturePressBegin(_ direction: PressGestureRecognizerDirection) {
        gestureDelegate?.didLongPressBegin?(direction)
    }
    
    func onGesturePressEnd(_ timeInterVal: TimeInterval) {
        gestureDelegate?.didLongPressEnd?(timeInterVal)
    }
    
    func onGesturePressFailed() {
        gestureDelegate?.didLongPressFailed?()
    }
}


// MARK: - Selector Extension
fileprivate extension Selector {
    static let didSwipe = #selector(GestureHelper.gestureDidSwipe(_:))
    static let didTap = #selector(GestureHelper.gestureDidTap(_:))
    static let didPress = #selector(GestureHelper.gestureDidLongPress(_:_:))
}

// MARK: - UIGestureRecognizer Extension
extension UIGestureRecognizer{
    var g_type: GestureType? {
        set {
            objc_setAssociatedObject(self, GestureHelper.G_TYPE_KEY, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, GestureHelper.G_TYPE_KEY) as? GestureType
        }
    }
}

@objc public enum PressGestureRecognizerDirection: Int {
    case unknown = 0
    case up = 1
    case down = 2
    case left = 3
    case right = 4
}

public class PressGestureRecognizer: UIGestureRecognizer {
    
    private var edgeThreshold: Float = 0.5
    fileprivate var directionToRecognize: PressGestureRecognizerDirection = .unknown
    private var siriRemotePad: GCMicroGamepad?
    private var beginTime : TimeInterval = 0.0
    private var endTime : TimeInterval = 0.0
    weak var mListener : PressGestureRecognizerListener?
    
    init(target: AnyObject?, action: Selector, direction: PressGestureRecognizerDirection, edgeThreshold: Float = 0.5) {
        super.init(target: target, action: action)
        self.directionToRecognize = direction
        self.edgeThreshold = edgeThreshold
        setupRemoteControlPad()
    }
    
    override public func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent) {
        for press in presses {
            switch press.type {
            case .select:
                self.beginTime = NSDate().timeIntervalSince1970
                self.endTime = 0
                var edgeCondition: Bool
                if let remotePadXValue = siriRemotePad?.dpad.xAxis.value,
                    let remotePadYValue = siriRemotePad?.dpad.yAxis.value {
                    switch directionToRecognize {
                    case PressGestureRecognizerDirection.up:
                        edgeCondition = remotePadYValue > edgeThreshold
                    case PressGestureRecognizerDirection.down:
                        edgeCondition = remotePadYValue < -edgeThreshold
                    case PressGestureRecognizerDirection.right:
                        edgeCondition = remotePadXValue > edgeThreshold
                    case PressGestureRecognizerDirection.left:
                        edgeCondition = remotePadXValue < -edgeThreshold
                    case PressGestureRecognizerDirection.unknown:
                        edgeCondition = false
                        break
                    }
                    if edgeCondition {
                        state = .began
                        mListener?.onGesturePressBegin?(directionToRecognize)
                    } else {
                        state = .failed
                        mListener?.onGesturePressFailed?()
                    }
                }
                
            default:
                print("clicked something else")
                state = .failed
            }
        }
    }
    
    override public func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent) {
        super.pressesEnded(presses, with: event)
        self.endTime = NSDate().timeIntervalSince1970
        state = .ended
        let interval = endTime - beginTime
        mListener?.onGesturePressEnd?(interval)
    }
    
    override public func pressesChanged(_ presses: Set<UIPress>, with event: UIPressesEvent) {
        super.pressesChanged(presses, with: event)
        endTime = NSDate().timeIntervalSince1970
        state = .changed
    }
    
    override public func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent) {
        super.pressesCancelled(presses, with: event)
        endTime = NSDate().timeIntervalSince1970
        state = .cancelled
    }
    
    private func setupRemoteControlPad() {
        let controllerList = GCController.controllers()
        if controllerList.count < 1 {
            print("No controller found: PressGestureRecognizer will not work")
        } else {
            if let pad = controllerList.first?.microGamepad {
                siriRemotePad = pad
                siriRemotePad!.reportsAbsoluteDpadValues = true
            }
        }
    }
}

@objc protocol PressGestureRecognizerListener : NSObjectProtocol{
    @objc optional func onGesturePressBegin(_ direction:PressGestureRecognizerDirection)
    @objc optional func onGesturePressEnd(_ timeInterVal:TimeInterval)
    @objc optional func onGesturePressFailed()
}
