import QtQuick 2.0

Item{
    id: scrollCtrlId
    // Scroll Indicator parent object
    property variant smartListObj : parent  // Parent object (smartList)

    // horizontal scroll Indicator qml object
    property variant horizontalScrollObj : undefined

    // vertical scroll Indicator qml object
    property variant verticalScrollObj: undefined

    // TODO: Hot zone area size changes from device to device
    property int scrollIndicatorSize: 32    //ScrollIndicator size (in pixels)

    property int scrollIndicatorHeight: 0   //Scroll Indicator height

     function createScrollComponent() {

        if (horizontalScrollObj !== undefined) {
            horizontalScrollObj.opacity = horizontalScrollObj.enabled = (smartListObj.qm_smartLstView.focus === true)
        }
        else {
            /// @brief create horizontal scroll Indicator only if required
            createHorizontalScrollIndicator()
        }
        if (verticalScrollObj !== undefined) {
            verticalScrollObj.opacity = verticalScrollObj.enabled = (smartListObj.qm_smartLstView.focus === true)
        }
        else {
            /// @brief create vertical scroll Indicator only if required
            createVerticalScrollIndicator()
        }
    }

    function resizeScrollComponent () {
        if ((smartListObj.totalContentHeight <= smartListObj.height) && (verticalScrollObj != undefined)) {
            verticalScrollObj.destroy()
            verticalScrollObj = undefined
            // if vertical scroll Indicator is destroyed, increase horizontal scroll Indicator , if exists
            if (horizontalScrollObj !== undefined && scrollIndicatorHeight !== smartListObj.height) {
                horizontalScrollObj.width += 6.0
            }
        } else if (verticalScrollObj != undefined) {
            verticalScrollObj.opacity = verticalScrollObj.enabled = (smartListObj.qm_smartLstView.focus === true)
            verticalScrollObj.totalContentHeight = smartListObj.totalContentHeight
        }
         else {
            createVerticalScrollIndicator()
        }
        if (horizontalScrollObj != undefined) {
            horizontalScrollObj.opacity = horizontalScrollObj.enabled = (smartListObj.qm_smartLstView.focus === true)
       }
    }

    function createVerticalScrollIndicator() {
        if (smartListObj.qm_hasVerticalScrollBar) {
            if ((smartListObj.totalContentHeight > smartListObj.height) && (verticalScrollObj === undefined)) {
                var verticalScrollIndicatorComp = Qt.createComponent("IGuiScrollIndicator.qml")
                if (verticalScrollIndicatorComp.status === Component.Ready) {
                    scrollIndicatorHeight = (horizontalScrollObj !== undefined ) ? (smartListObj.height - 6) : smartListObj.height
                    var verticalScrollIndicatorHeight = smartListObj.height
                    if (horizontalScrollObj !== undefined) {
                        verticalScrollIndicatorHeight -= 6.0
                        horizontalScrollObj.width -= 6.0  // Resize Vertical Scroll Indicator by 6 px
                    }
                    verticalScrollObj = verticalScrollIndicatorComp.createObject(smartListObj,
                                                                          {
                                                                              "x": smartListObj.width - scrollIndicatorSize,
                                                                              "smartListObj": smartListObj,
                                                                              "scrollCtrlObj" : scrollCtrlId,
                                                                              "width": scrollIndicatorSize,
                                                                              "height": verticalScrollIndicatorHeight,
                                                                              "opacity": (smartListObj.qm_smartLstView.focus === true),
                                                                              "enabled": (smartListObj.qm_smartLstView.focus === true),
                                                                              "scrollIndicatorOrientation": Qt.Vertical,
                                                                              "totalContentHeight": smartListObj.totalContentHeight,
                                                                              "scrollHotZoneArea": scrollIndicatorSize
                                                                          }
                                                                         )
                    smartListObj.updateSelectedRow()
                    // Update slider position based on buffer start position
                    verticalScrollObj.positionSlider(smartListObj.qm_flickLstView.contentY +
                                                       (smartListObj.qm_smartLstView.bufferStartOffset * smartListObj.qm_RowHeight),
                                                       Qt.Vertical)
                }
            }
        }
    }

    function createHorizontalScrollIndicator() {
        if (smartListObj.qm_hasHorizontalScrollBar) {
            if (smartListObj.totalColumnWidth > smartListObj.width) {
                var horizontalScrollIndicatorComp = Qt.createComponent("IGuiScrollIndicator.qml");
                if (horizontalScrollIndicatorComp.status === Component.Ready) {
                    var horizontalScrollIndicatorWidth = smartListObj.width
                    if (verticalScrollObj !== undefined) {
                        horizontalScrollIndicatorWidth -= 6.0
                        verticalScrollObj.height -= 6.0  // Resize Vertical Scroll Indicator by 6 px
                    }
                    horizontalScrollObj = horizontalScrollIndicatorComp.createObject(smartListObj,
                                                                                  {

                                                                                      "width": horizontalScrollIndicatorWidth,
                                                                                      "opacity": (smartListObj.qm_smartLstView.focus === true),
                                                                                      "enabled": (smartListObj.qm_smartLstView.focus === true),
                                                                                      "smartListObj": smartListObj,
                                                                                      "scrollCtrlObj" : scrollCtrlId,
                                                                                      "headerHeight" : smartListObj.headerHeight,
                                                                                      "scrollIndicatorOrientation": Qt.Horizontal,
                                                                                      "scrollHotZoneArea": scrollIndicatorSize,
                                                                                      "totalContentWidth": smartListObj.totalColumnWidth
                                                                                  }
                                                                                 )
                }
            }
            else if ((smartListObj.totalColumnWidth <= smartListObj.width) && (horizontalScrollObj != undefined)) {
                horizontalScrollObj.destroy()
                horizontalScrollObj = undefined
                if (verticalScrollObj !== undefined && verticalScrollObj.height !== smartListObj.height)
                    verticalScrollObj.height += 6.0   // if horizontal scroll Indicator is destroyed, increase vertical scroll Indicator, if it exists and was resized earlier
            }
        }
        else
        {
            smartListObj.readjustTotalColumnWidth()
        }
    }

    function reAdjustScrollComponent(differentialHeight)
    {
        if(horizontalScrollObj !== undefined)
        {
            horizontalScrollObj.setScrollIndicatorSliderPositions()            
        }
        if(verticalScrollObj !== undefined)
        {
            verticalScrollObj.resetScrollBarHeight()
            verticalScrollObj.setScrollIndicatorSliderPositions()
        }
    }
    //Function to position slider
    function positionSlider(scrollObj, scrollPosition)
    {
        if(scrollObj !== undefined)
        {
            scrollObj.positionSlider(scrollPosition, scrollObj.scrollIndicatorOrientation)
        }
    }

    Component.onDestruction: {
        if (verticalScrollObj !== undefined){
            verticalScrollObj.destroy()
            verticalScrollObj = undefined
        }
        if (horizontalScrollObj !== undefined){
            horizontalScrollObj.destroy()
            horizontalScrollObj = undefined
        }
    }
}
