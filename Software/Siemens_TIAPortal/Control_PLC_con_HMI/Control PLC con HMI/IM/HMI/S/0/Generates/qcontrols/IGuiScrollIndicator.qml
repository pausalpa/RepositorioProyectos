import QtQuick 2.0

// scroll Indicator
Item {
    id: scrollIndicator
    visible: true
    property var smartListObj : parent
    property variant scrollCtrlObj : undefined  //Scroll control object
    property color scrollIndicatorColor: Qt.rgba((211/255),(211/255),(211/255),(255/255))
    property color scrollSliderColor: Qt.rgba((129/255),(129/255),(135/255),(255/255))
    property int scrollIndicatorOrientation
    property int headerHeight: 0           //Header height
    property real totalContentHeight: 0
    property real totalContentWidth: 0

    // TODO: Hot zone area size changes from device to device
    property int scrollHotZoneArea: 32
    property int scrollSliderBackAreaSize: 2
    property int scrollSliderSize: 4
    property int scrollHotZone: 10
    property int scrollLimitAreaSize: 6
    property int scrollSliderMinSize: ((smartListObj.height-smartListObj.headerHeight) <= 20.0) ?
                                          (smartListObj.height/2) : 20.0


    width: (scrollIndicatorOrientation === Qt.Vertical) ? scrollHotZoneArea : (smartListObj.width - scrollLimitAreaSize)
    height: (scrollIndicatorOrientation === Qt.Vertical) ? (smartListObj.height - scrollLimitAreaSize) : scrollHotZoneArea

    Rectangle {
        id: scrollLimitArea

        width: (scrollIndicatorOrientation === Qt.Vertical) ? scrollLimitAreaSize : scrollIndicator.width
        height: (scrollIndicatorOrientation === Qt.Vertical) ? scrollIndicator.height : scrollLimitAreaSize
        color: Qt.rgba((255/255),(255/255),(255/255),(255/255))

        Rectangle {
            id: scrollSliderArea

            width: (scrollIndicatorOrientation === Qt.Vertical) ? scrollSliderBackAreaSize : scrollIndicator.width
            height: (scrollIndicatorOrientation === Qt.Vertical) ? scrollIndicator.height : scrollSliderBackAreaSize
            color: scrollIndicatorColor
        }
    }

    function setScrollIndicatorSliderPositions () {
        if (scrollIndicatorOrientation == Qt.Vertical) {
            scrollIndicator.x = (smartListObj.width - scrollHotZoneArea)
            scrollLimitArea.x = scrollHotZoneArea - (scrollIndicatorSlider.width / 2) - scrollSliderSize
            scrollSliderArea.x = (scrollLimitArea.width / 2) - 1
            scrollIndicatorSlider.x = (scrollHotZoneArea - scrollIndicatorSlider.width - 1)            
        }
        else {

            scrollIndicator.y = (smartListObj.height - (smartListObj.qm_smartListAdjusted ? 0 : smartListObj.headerHeight) - scrollHotZoneArea)
            scrollLimitArea.y = scrollHotZoneArea  - (scrollIndicatorSlider.height / 2) - scrollSliderSize
            scrollSliderArea.y = (scrollLimitArea.height / 2) - 1
            scrollIndicatorSlider.y = (scrollHotZoneArea - scrollIndicatorSlider.height - 1)


        }
    }

    function resetScrollBarHeight()
    {        
       if (scrollIndicatorOrientation == Qt.Vertical) {
            scrollIndicator.height = ((scrollCtrlObj !==undefined) && (scrollCtrlObj.horizontalScrollObj !== undefined)) ?
                                         smartListObj.height - 6.0 : smartListObj.height
            scrollSliderContainer.height = ((scrollIndicatorSlider.sliderActualHeight > scrollSliderMinSize ) ?
                                          (scrollIndicator.height / (smartListObj.totalContentHeight / (scrollIndicator.height))) : scrollSliderMinSize )
       }
    }

    function positionSlider (scrollPosition, IndicatorOrientation) {
        if (IndicatorOrientation === Qt.Vertical) {            
            var newSliderPosition = (scrollPosition) / (/*smartListObj.contentHeight*/totalContentHeight - scrollIndicator.height)
            scrollSliderContainer.y = newSliderPosition * (scrollIndicator.height - scrollIndicatorSlider.height);
        } else {
            var newSliderPosition = (scrollPosition) / (/*smartListObj.contentHeight*/totalContentWidth - scrollIndicator.width)
            scrollSliderContainer.x = newSliderPosition * (scrollIndicator.width - scrollIndicatorSlider.width);
        }
    }

    function scrollContent () {
        var newContentPos = 0.0
        if (scrollIndicator.scrollIndicatorOrientation == Qt.Vertical) {

            newContentPos = scrollSliderContainer.y

            // If slider height is limited to 20 px and if slider reaches bottom of scroll Indicator, use preserved slider height to scroll to end of list,
            if (scrollSliderContainer.y + scrollSliderMinSize === scrollIndicator.height) {
                newContentPos = scrollIndicator.height - scrollIndicatorSlider.sliderActualHeight
            }

            // If slider height is limited to 20 px, recalculate scroll position to unlimited slider's y
            else if (scrollIndicatorSlider.sliderActualHeight <= scrollSliderMinSize) {

                // Max limited slider y range = 0 to (scrollIndicator.height - 20px)
                // Calculate % displacement of limited slider in its range
                var sliderDisplacement = (scrollSliderContainer.y /(scrollIndicator.height - scrollSliderMinSize))

                // Max unlimited slider y range w.r.t limited slider top = 0 to (20 px - preserved height)
                // Relative % displacement of actual height slider in its range is same as that of umlimited slider
                var relativeActualSliderDisplacement = (scrollSliderMinSize - scrollIndicatorSlider.sliderActualHeight) * sliderDisplacement

                // Scroll position = limited slider's y + relative displacement of actual height slider w.r.t limited slider
                newContentPos = scrollSliderContainer.y + relativeActualSliderDisplacement
            }
        }
        else {
            newContentPos = (scrollSliderContainer.x) * (/*smartListObj.contentWidth*/totalContentWidth - smartListObj.width)/(scrollIndicator.width - scrollSliderContainer.width)
        }
        // scroll Indicator height = list Rectangle height - 6; only if horizontalScrollObj is not NULL
        var denomimator = ((scrollCtrlObj !==undefined) && (scrollCtrlObj.horizontalScrollObj !== undefined)) ?
                               smartListObj.height - 6.0 : smartListObj.height
        smartListObj.scrollListView(newContentPos, scrollIndicator.scrollIndicatorOrientation, denomimator)
    }

    //scroll slider
    Item {
        id: scrollSliderContainer

        width: (scrollIndicatorOrientation === Qt.Vertical) ? scrollHotZoneArea : scrollIndicatorSlider.width
        height: (scrollIndicatorOrientation === Qt.Vertical) ? scrollIndicatorSlider.height : scrollHotZoneArea

        Rectangle {
            id: scrollIndicatorSlider

            property int parentContentHeight: totalContentHeight

            // Minimum slider height limited to 20 px.
            // If number of list rows increase such that the slider height decreases below 20, the original height is preserved.
            property real sliderActualHeight: (scrollIndicatorOrientation === Qt.Vertical) ? ((scrollIndicator.height / (parentContentHeight / scrollIndicator.height))) : scrollSliderSize

            width: (scrollIndicatorOrientation === Qt.Vertical) ? scrollSliderSize : (scrollIndicator.width / (totalContentWidth / scrollIndicator.width))
            height: (scrollIndicatorOrientation === Qt.Vertical) ? ((sliderActualHeight > scrollSliderMinSize ) ? (scrollIndicator.height / (parentContentHeight / (scrollIndicator.height))) : scrollSliderMinSize ) : scrollSliderSize
            color: scrollSliderColor
            radius: 2

            onParentContentHeightChanged: {
                var newSliderHeight = (scrollIndicator.height / (parentContentHeight / scrollIndicator.height))
                height = (scrollIndicatorOrientation === Qt.Vertical) ? ((newSliderHeight > scrollSliderMinSize) ? (scrollIndicator.height / (parentContentHeight / scrollIndicator.height)): scrollSliderMinSize) : parent.height
                scrollIndicatorSlider.sliderActualHeight = newSliderHeight
            }
        }

        MouseArea {
            id: scrollIndicatorSliderArea

            width: (scrollIndicatorOrientation === Qt.Vertical) ? scrollHotZoneArea : parent.width
            height: (scrollIndicatorOrientation === Qt.Vertical) ? parent.height : scrollHotZoneArea

            preventStealing: true

            drag.target: scrollSliderContainer
            drag.axis: (scrollIndicatorOrientation === Qt.Vertical) ? Drag.YAxis : Drag.XAxis
            drag.maximumX: (scrollIndicatorOrientation === Qt.Vertical) ? 0 : (scrollIndicator.width - scrollIndicatorSlider.width)
            drag.maximumY: (scrollIndicatorOrientation === Qt.Vertical) ? (scrollIndicator.height - scrollIndicatorSlider.height) :0
            drag.minimumY: 0
            drag.minimumX: 0

            onReleased: {
                if (scrollIndicatorOrientation === Qt.Vertical) {
                    scrollContent ()
                }
                smartListObj.stopEditMode()
            }

            onMouseXChanged: {
                if (scrollIndicatorOrientation !== Qt.Vertical) {
                    scrollContent ()
                }
            }
        }
    }

    // To handle click event above the scrollIndicatorSlider, in the Hot zone
    Item {
        id: scrollIndicatorAbove

        height: (scrollIndicatorOrientation === Qt.Vertical) ? scrollSliderContainer.y : scrollIndicator.height
        width: (scrollIndicatorOrientation === Qt.Vertical) ? scrollIndicator.width : scrollSliderContainer.x

        MouseArea {
            height: parent.height
            width: parent.width

            onClicked: {
                if (scrollIndicatorOrientation === Qt.Vertical) {
                    scrollSliderContainer.y = mouse.y
                }
                else {
                    scrollSliderContainer.x = mouse.x
                }
                scrollContent()
            }
        }
    }

    // To handle click event below the scrollIndicatorSlider, in the Hot zone
    Item {
        id: scrollIndicatorBelow

        height: (scrollIndicatorOrientation === Qt.Vertical) ? (scrollIndicator.height - (scrollSliderContainer.y + scrollIndicatorSlider.height)) : scrollIndicator.height
        width: (scrollIndicatorOrientation === Qt.Vertical) ? scrollIndicator.width : (scrollIndicator.width - (scrollSliderContainer.x + scrollIndicatorSlider.width))

        y: (scrollIndicatorOrientation === Qt.Vertical) ? (scrollSliderContainer.y + scrollIndicatorSlider.height) : 0
        x: (scrollIndicatorOrientation === Qt.Vertical) ? 0 : (scrollSliderContainer.x + scrollIndicatorSlider.width)

        MouseArea {
            height: parent.height
            width: parent.width

            onClicked: {
                // Recalculate scrollSliderContainer.y relative to current vertical slider y position
                if (scrollIndicatorOrientation === Qt.Vertical) {

                    var newY = scrollSliderContainer.y + scrollIndicatorSlider.height + mouse.y
                    var maxY = scrollIndicator.height - scrollIndicatorSlider.height
                    // Ensure new slider Y position does not exceed total scrollIndicator height
                    if (newY > maxY)
                        scrollSliderContainer.y = maxY
                    else
                        scrollSliderContainer.y = newY
                }
                // Recalculate scrollSliderContainer.x relative to curent horizontal slider x position
                else {
                    var newX = scrollSliderContainer.x + scrollIndicatorSlider.width + mouse.x
                    var maxX = scrollIndicator.width - scrollIndicatorSlider.width

                    // Ensure new slider X position does not exceed total scrollIndicator height
                    if (newX > maxX)
                        scrollSliderContainer.x = maxX
                    else
                        scrollSliderContainer.x = newX
                }
                scrollContent()
            }
        }
    }

    Rectangle {
        id: scrollIndicatorTrailer
        color: "#ffffff"
        x: (scrollIndicatorOrientation === Qt.Vertical) ? scrollIndicator.width - scrollLimitAreaSize : scrollIndicator.width
        y: (scrollIndicatorOrientation === Qt.Vertical) ? scrollIndicator.height : scrollIndicator.height - scrollLimitAreaSize
        height: scrollLimitAreaSize
        width: scrollLimitAreaSize
    }
    Component.onCompleted: {
        setScrollIndicatorSliderPositions();

    }
}
