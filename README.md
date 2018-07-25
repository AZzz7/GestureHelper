# GestureHelper
Easy To Add Gestures On TVOS

You can creat a mGestureHelper like this 

`mGestureHelper = GestureHelper.init(targetView: self.view, [.G_SELECT_TAP,.G_MENU_TAP,.G_PLAY_PAUSE_TAP])
mGestureHelper?.gestureDelegate = self
`


add implementation the GestureHelperDelegate 

    // BASIC GESTURES
    
    
    func didSelectTappGesture() {
    
    }
    
    func didMenuTapGesture() {
       
    }
    
    func didPlayPaseTapGesture() {
    }

