import QtQuick 2.0

Item {
    id: scrollCtrlId
    // host properties
    property variant smartListObj : parent                 // Parent object (smartList)

    // Scroll bar size
    property int scrollBarSize: parent.qm_scrollBarSize    //Scrollbar size (in pixels)

    //Scroll bar slider size
    property int  scrollBarSliderSize : parent.qm_scrollBarSliderSize

    // vertical scroll bar qml object
    property variant verticalScrollObj: undefined

    // horizontal scroll bar qml object
    property variant horizontalScrollObj : undefined

    ///@brief Create horizontal and vertical scroll bar
    function createScrollComponent() {
        /// @brief create horizontal scroll bar only if required
        createHorizontalScrollbar()
        /// @brief create vertical scroll bar only if required
        createVerticalScrollbar()
    }

    ///@brief Resize vertical and horizontal scroll bar when total content height changed
    function resizeScrollComponent () {
        if ((smartListObj.totalContentHeight <= smartListObj.height) && (verticalScrollObj !== undefined)
             || (((smartListObj.totalContentHeight < (smartListObj.height + scrollBarSize)) && (verticalScrollObj !== undefined))
                && ((smartListObj.totalColumnWidth <= (smartListObj.width + scrollBarSize)) && (horizontalScrollObj !== undefined))))
        {
            //destroy vertical scroll bar when total content < display height and increase listview width
            verticalScrollObj.destroy()
            verticalScrollObj = undefined
            smartListObj.width += scrollBarSize
            smartListObj.totalColumnWidth = smartListObj.qm_hasHorizontalScrollBar ?
                        smartListObj.actualTotalColumnWidth : smartListObj.width


            // if vertical scroll bar is destroyed, increase horizontal scroll bar , if exists
            if (horizontalScrollObj !== undefined ) {
                // destroy horizontal scroll bar in total column < display width and increase listview height
                //and update number of rowsfit
                if(smartListObj.totalColumnWidth <= smartListObj.width){
                    horizontalScrollObj.destroy()
                    horizontalScrollObj = undefined
                    smartListObj.height+=scrollBarSize
                    smartListObj.updateRowsFit()
                }
                else{
                    horizontalScrollObj.width = smartListObj.width
                    horizontalScrollObj.positionSlider(smartListObj.qm_flickLstView.contentX)
                }
            }
        } else if (verticalScrollObj !== undefined) {
            verticalScrollObj.totalContentHeight = smartListObj.totalContentHeight
        }
        else{
            createVerticalScrollbar()
        }
    }
    ///@brief Creation of Vertical scrollbar
    function createVerticalScrollbar() {
        if (smartListObj.qm_hasVerticalScrollBar && (verticalScrollObj === undefined)) {
            var scrollVerticalBarComp = Qt.createComponent("IGuiVerticalScrollBar.qml")
            if((smartListObj.totalContentHeight > smartListObj.height) && (scrollVerticalBarComp.status === Component.Ready)) {

                if(smartListObj.width > scrollBarSize){
                    //Reduce the size of smartListObj width
                    smartListObj.width -= scrollBarSize
                    if (horizontalScrollObj !== undefined) {
                        horizontalScrollObj.width = smartListObj.width  // Resize Horizontal Scroll Bar
                    }
                    else {                        
                        createHorizontalScrollbar()
                    }

                    var verticalScrollBarHeight = smartListObj.height + smartListObj.headerHeight

                    //create vertical scroll bar incubator

                    verticalScrollObj = scrollVerticalBarComp.createObject(smartListObj.parent,
                                                                      {
                                                                          "smartListObj": smartListObj,
                                                                          "scrollCtrlObj" : scrollCtrlId,                                                                          
                                                                          "height": verticalScrollBarHeight,
                                                                          "totalContentHeight": smartListObj.totalContentHeight,
                                                                          "scrollBarSize": scrollBarSize,
                                                                          "scrollSliderSize": scrollBarSliderSize,
                                                                          "enabled": smartListObj.enabled
                                                                      }
                                                                      )
                    smartListObj.updateSelectedRow()
                    smartListObj.readjustTotalColumnWidth()
                    //Reinitialze total content height
                    resizeScrollComponent()
                    // Update slider position based on buffer start position
                    verticalScrollObj.positionSlider(((smartListObj.nSelectedRow+smartListObj.qm_smartLstView.bufferStartOffset)
                                                         *  smartListObj.qm_RowHeight))
                }
            }
        }
    }

    ///@brief Creation of Horizontal scrollbar
    function createHorizontalScrollbar () {
        if (smartListObj.qm_hasHorizontalScrollBar && (horizontalScrollObj === undefined)) {
            var scrollHorizontalBarComp = Qt.createComponent("IGuiHorizontalScrollBar.qml")
            if ((smartListObj.totalColumnWidth > smartListObj.width)  && (scrollHorizontalBarComp.status === Component.Ready)) {
                if(smartListObj.height > scrollBarSize){

                    //Reduce the size of smartListObj height
                    smartListObj.height -= scrollBarSize
                    //update rows fit
                    smartListObj.updateRowsFit()

                    if (verticalScrollObj !== undefined) {
                        verticalScrollObj.height = smartListObj.height // Resize Vertical Scroll Bar by width of the scrollbar
                    }
                    var horizontalScrollBarWidth = smartListObj.width
                    //create horizontal scroll bar incubator                    
                    horizontalScrollObj = scrollHorizontalBarComp.createObject(smartListObj.parent,
                                                                        {
                                                                            "smartListObj": smartListObj,
                                                                            "width": horizontalScrollBarWidth,                                                                            
                                                                            "scrollBarSize": scrollBarSize,
                                                                            "totalContentWidth": smartListObj.totalColumnWidth,
                                                                            "scrollSliderSize": scrollBarSliderSize,
                                                                            "enabled": smartListObj.enabled
                                                                        }
                                                                        )
                }
            }
        }
        else
        {
            smartListObj.readjustTotalColumnWidth()
        }
    }

    function reAdjustScrollComponent(differentialHeight)
    {
        if(verticalScrollObj !== undefined)
        {
            verticalScrollObj.setScrollBarSliderPositions(differentialHeight)
        }
        if(horizontalScrollObj !== undefined)
        {
            horizontalScrollObj.setScrollBarSliderPositions()
        }
    }

    //Function to position slider
    function positionSlider(scrollObj, scrollPosition)
    {
        if((scrollObj !== undefined))
        {
            scrollObj.positionSlider(scrollPosition)
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
