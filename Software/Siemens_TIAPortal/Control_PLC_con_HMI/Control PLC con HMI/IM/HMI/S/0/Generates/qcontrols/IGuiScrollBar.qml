import QtQuick 2.0
import SmartPolygonComponent 1.0
// scroll bar
Item {
    id: scrollBar
    visible: true
    //ScrollBar parameters
    property var parentObj:smartList

    property int scrollBarOrientation       // Orientation either Vertical or Horizontal
    property int headerHeight: 0           //Header height
    property int scrollLimitAreaHeight : scrollLimitArea.height
    property int scrollLimitAreaWidth : scrollLimitArea.width
    property int scrollXOffset: 0     //Scroll bar Offset for X axis
    property int scrollYOffset: 0     //Scroll bar Offset for Y axis
    property int buttonDimension:scrollBarSize //Size of button considering square dimension
    property int sliderMinSize:20           //Minimum size slider
    property int horizontalDisplacement:20  //displacement value for horizontal left and right button clicks

    property int scrollBarSize: 0       //Scrollbar size (in pixels)
    property int scrollSliderSize: 0    //Slider or thumb size (in pixels)

    property real totalContentHeight: 0     //Total number of rows interms of pixels
    property real totalContentWidth: 0      //Total number of columns interms of pixels

    //ScrollBar colors
    property color scrollBarColor: parentObj.qm_tableAlternateBackColor
    property color scrollSliderColor: parentObj.qm_tableTextColor

    width: (scrollBarOrientation == Qt.Vertical) ? scrollBarSize : (parentObj.width -scrollBarSize)
    height: (scrollBarOrientation == Qt.Vertical) ? (parentObj.height+headerHeight - scrollBarSize) : scrollBarSize

    //scroll bar rectangle without buttons
    Rectangle {
        id: scrollLimitArea

        width: (scrollBarOrientation === Qt.Vertical) ?scrollBarSize  :(scrollBar.width-(2*buttonDimension))
        height: (scrollBarOrientation === Qt.Vertical) ? (scrollBar.height-(2*buttonDimension)) : scrollBarSize
        color: scrollBarColor
    }

    // Button to handle click event on Up/Left button press
    Rectangle {
        id: btnItem1

        height : (scrollBarOrientation === Qt.Vertical)? ((scrollBar.height<=2*buttonDimension)? (scrollBar.height/2):buttonDimension):buttonDimension
        width :  (scrollBarOrientation === Qt.Vertical)? buttonDimension:((scrollBar.width<=2*buttonDimension)? (scrollBar.width/2):buttonDimension)
        color: scrollBarColor
        
        // triangle points of Button, points value change depending on the button size
        property point traversePoint: (scrollBarOrientation === Qt.Vertical) ? (Qt.point(Math.ceil((1/2)*btnItem1.width),Math.ceil((3/8)*btnItem1.height))):
                                                                               (Qt.point(Math.ceil((3/8)*btnItem1.width),Math.ceil((1/2)*btnItem1.height)))
        property point startPoint:    (scrollBarOrientation === Qt.Vertical) ? (Qt.point(Math.ceil((1/4)*btnItem1.width),Math.ceil((5/8)*btnItem1.height))):
                                                                               (Qt.point(Math.ceil((5/8)*btnItem1.width),Math.ceil((3/4)*btnItem1.height)))
        property point endPoint:      (scrollBarOrientation === Qt.Vertical) ? (Qt.point(Math.ceil((3/4)*btnItem1.width),Math.ceil((5/8)*btnItem1.height))):
                                                                               (Qt.point(Math.ceil((5/8)*btnItem1.width),Math.ceil((1/4)*btnItem1.height)))
        //To draw triangle on button
        IGuiSmartPolygon {
            id: smartPolygonComponent
            width: btnItem1.width
            height: btnItem1.height
            fillColor: scrollSliderColor
            borderWidth:0
            pointList: [btnItem1.startPoint, btnItem1.traversePoint, btnItem1.endPoint]
        }

        MouseArea {
            height: parent.height
            width: parent.width
            onPressed: {
                // Unload the loaded component, if scrolling has been started
                parentObj.stopEditMode()

                if(false ===parentObj.focus)
                    parentObj.setFocus();
                //Get Flickable position from ListView
                if((parentObj.getFlickablePosition(scrollBarOrientation))>0){
                    //Vertical button scrolling
                    if(scrollBarOrientation === Qt.Vertical){
                        parentObj.onScrollButtonUp(scrollBarOrientation);
                    }

                    //Horizontal button scrolling
                    if(scrollBarOrientation === Qt.Horizontal){
                        var displacement = flickListView.contentX - horizontalDisplacement
                        parentObj.scrollListView((((displacement) > 0) ? displacement :0), scrollBar.scrollBarOrientation);
                    }

                    //Update color to show button pressed
                    smartPolygonComponent.fillColor = scrollBarColor
                    smartPolygonComponent.update()
                    btnItem1.color = scrollSliderColor
                }
            }
            onReleased: {
                //Update color to original color on release
                smartPolygonComponent.fillColor = scrollSliderColor
                smartPolygonComponent.update()
                btnItem1.color = scrollBarColor
            }
        }
    }
    // To handle click event on button press
    Rectangle {
        id: btnItem2

        height:(scrollBarOrientation === Qt.Vertical)? ((scrollBar.height<=2*buttonDimension)? (scrollBar.height/2):buttonDimension):buttonDimension
        width: (scrollBarOrientation === Qt.Horizontal)? ((scrollBar.width<=2*buttonDimension)? (scrollBar.width/2):buttonDimension):buttonDimension
        color: scrollBarColor
        x:(scrollBarOrientation === Qt.Vertical) ?  0:(scrollBar.width-btnItem2.width)
        y:(scrollBarOrientation === Qt.Vertical) ? (scrollBar.height-btnItem2.height):0

        // triangle points for Button, points value change depending on the button size
        property point traversePoint: (scrollBarOrientation === Qt.Vertical) ? (Qt.point(Math.ceil((1/2)*btnItem1.width),Math.ceil((5/8)*btnItem1.height))):
                                                                               (Qt.point(Math.ceil((5/8)*btnItem1.width),Math.ceil((1/2)*btnItem1.height)))
        property point startPoint:    (scrollBarOrientation === Qt.Vertical) ? (Qt.point(Math.ceil((3/4)*btnItem1.width),Math.ceil((3/8)*btnItem1.height))):
                                                                               (Qt.point(Math.ceil((3/8)*btnItem1.width),Math.ceil((1/4)*btnItem1.height)))
        property point endPoint:      (scrollBarOrientation === Qt.Vertical) ? (Qt.point(Math.ceil((1/4)*btnItem1.width),Math.ceil((3/8)*btnItem1.height))):
                                                                               (Qt.point(Math.ceil((3/8)*btnItem1.width),Math.ceil((3/4)*btnItem1.height)))
        //To draw triangle on button
        IGuiSmartPolygon {
            id: smartPolygonComponent2
            width: btnItem2.width
            height: btnItem2.height
            fillColor: scrollSliderColor
            borderWidth:0
            pointList: [btnItem2.startPoint, btnItem2.traversePoint, btnItem2.endPoint]
        }

        MouseArea {
            height: parent.height
            width: parent.width
            onPressed: {
                // Unload the loaded component, if scrolling has been started
                parentObj.stopEditMode()

                if(false ===parentObj.focus)
                    parentObj.setFocus();
                //Vertical button scrolling
                if ((parentObj.getFlickablePosition(scrollBarOrientation)<(totalContentHeight-parentObj.height))&&(scrollBarOrientation === Qt.Vertical))
                {
                    parentObj.onScrollButtonDown(scrollBarOrientation);
                    //Update color to show button pressed
                    smartPolygonComponent2.fillColor = scrollBarColor
                    smartPolygonComponent2.update()
                    btnItem2.color = scrollSliderColor
                }
                //Horizontal button scrolling
                if((parentObj.getFlickablePosition(scrollBarOrientation)<(totalContentWidth-parentObj.width))&&(scrollBarOrientation === Qt.Horizontal)) {
                    parentObj.scrollListView(flickListView.contentX + horizontalDisplacement, scrollBar.scrollBarOrientation);
                    //Update color to show button pressed
                    smartPolygonComponent2.fillColor = scrollBarColor
                    smartPolygonComponent2.update()
                    btnItem2.color = scrollSliderColor
                }
            }
            onReleased: {
                //Update color to original color on release
                smartPolygonComponent2.fillColor = scrollSliderColor
                smartPolygonComponent2.update()
                btnItem2.color = scrollBarColor
            }
        }
    }

    function setScrollBarSliderPositions () {
        if (scrollBarOrientation === Qt.Vertical) {
            scrollBar.x = parentObj.x + parentObj.width - scrollXOffset
            scrollBar.y = parentObj.y - headerHeight - scrollYOffset

            //scrollLimitArea.x not required as default starting point is scrollBar.x position
            scrollLimitArea.y = buttonDimension

            scrollBarSlider.x = ((scrollLimitArea.width - scrollBarSlider.width)/2)
            scrollBarSlider.y = 0
        }
        else {
            scrollBar.x = parentObj.x
            scrollBar.y = parentObj.y + parentObj.height

            scrollLimitArea.x = buttonDimension
            //scrollLimitArea.y not required as default starting point is scrollBar.y position

            scrollBarSlider.x = 0
            scrollBarSlider.y = ((scrollLimitArea.height - scrollBarSlider.height)/2)
        }
    }
    
    //Reposition the slider to appropriate location depending on current content position
    function positionSlider (scrollPosition, barOrientation) {
        var newSliderPosition = 0.0;
        if (barOrientation === Qt.Vertical) {

            //Normalized ratio w.r.t total content height
            newSliderPosition = (scrollPosition) / (totalContentHeight - parentObj.height)

            //Adjusting slider/thumb in scrollLimitArea
            scrollSliderContainer.y = (newSliderPosition * (scrollLimitArea.height - scrollBarSlider.height))+buttonDimension;
            var maxY = scrollBar.height - scrollBarSlider.height - buttonDimension
            //Boundary conditions
            if (scrollSliderContainer.y <buttonDimension){
                scrollSliderContainer.y  = buttonDimension
            }else if (scrollSliderContainer.y > maxY)
            {
                scrollSliderContainer.y  = maxY
            }

        } else {

            //Normalized ratio w.r.t total content width
            newSliderPosition = (scrollPosition) / (totalContentWidth - parentObj.width)

            //Adjusting slider/thumb in scrollLimitArea for horizontal scrollBar
            scrollSliderContainer.x = (newSliderPosition * (scrollLimitArea.width - scrollBarSlider.width))+buttonDimension;
            var maxX = scrollBar.width - scrollBarSlider.width - buttonDimension
            //Boundary conditions
            if (scrollSliderContainer.x < buttonDimension){
                scrollSliderContainer.x  = buttonDimension
            }else if (scrollSliderContainer.x > maxX)
            {
                scrollSliderContainer.x = maxX
            }
        }

    }

    //Update the content w.r.t slider position
    function scrollContent () {
        var newContentPos = 0.0
        if (scrollBar.scrollBarOrientation == Qt.Vertical) {
            //slider displacement
            newContentPos = scrollSliderContainer.y-buttonDimension
            // If slider height is limited to sliderMinSize px and if slider reaches bottom of scroll bar, use preserved slider height to scroll to end of list,
            if ((scrollSliderContainer.y + sliderMinSize) >= (scrollBar.height - buttonDimension)) {
                newContentPos = scrollLimitArea.height - scrollBarSlider.sliderActualHeight
            }

            // If slider height is limited to sliderMinSize px, recalculate scroll position to unlimited slider's y
            else if (scrollBarSlider.sliderActualHeight <= sliderMinSize) {
                // Max limited slider y range = buttonDimension to (scrollBar.height - sliderMinSize - buttonDimension)
                // Calculate % displacement of limited slider in its range
                var sliderDisplacement = ((scrollSliderContainer.y-buttonDimension)/(scrollLimitArea.height - sliderMinSize))

                // Max unlimited slider y range w.r.t limited slider top = 0 to (sliderMinSize px - preserved height)
                // Relative % displacement of actual height slider in its range is same as that of umlimited slider
                var relativeActualSliderDisplacement = (sliderMinSize - scrollBarSlider.sliderActualHeight) * sliderDisplacement

                // Scroll position = limited slider's y + relative displacement of actual height slider w.r.t limited slider
                newContentPos = scrollSliderContainer.y - buttonDimension + relativeActualSliderDisplacement
            }

            //total number of rows are less than rows fit
            if(parentObj.totalRowCount <= parentObj.rowsFit)
            {
                //calculation of displacement for dynamic creation of vertical scrollbar(total rows < rows fit )
                flickListView.contentY = (totalContentHeight * (newContentPos/(parentObj.height+parentObj.headerHeight-2*parentObj.qm_scrollBarSize)))
            }
            else
            {
                //send displacement position to list view
                parentObj.scrollListView(newContentPos, scrollBar.scrollBarOrientation);
            }
        }
        else {
            //displacement calculation for horizontal scroll bar w.r.t total content width
            newContentPos = (((scrollSliderContainer.x - buttonDimension) * (totalContentWidth - parentObj.width))/(scrollLimitArea.width - scrollSliderContainer.width));
            parentObj.scrollListView(newContentPos, scrollBar.scrollBarOrientation);
        }
    }
    
    //TODO: remove the function if not used
    function resizeScrollBarWidth(nOffSet) {
        if (scrollBar.scrollBarOrientation === Qt.Horizontal) {
            scrollBar.width = scrollBar.width - nOffSet
        }
    }

    //scroll slider
    Item {
        id: scrollSliderContainer

        width: (scrollBarOrientation === Qt.Vertical) ? scrollBarSize : scrollBarSlider.width
        height: (scrollBarOrientation === Qt.Vertical) ? scrollBarSlider.height : scrollBarSize
        
        x:(scrollBarOrientation === Qt.Vertical) ? 0 :buttonDimension
        y: (scrollBarOrientation === Qt.Vertical) ?buttonDimension:0
        
        //visibility of slider depends on the scrollbar dimensions
        visible:  (scrollBarOrientation === Qt.Vertical) ? ((scrollBar.height <= (2*buttonDimension+sliderMinSize))? false:scrollBar.visible):
                                                           ((scrollBar.width <= (2*buttonDimension+sliderMinSize))? false:scrollBar.visible)
        enabled: scrollSliderContainer.visible
        Rectangle {
            id: scrollBarSlider

            property int parentContentHeight: totalContentHeight

            // Minimum slider height limited to sliderMinSize px.
            // If number of list rows increase such that the slider height decreases below sliderMinSize, the original height is preserved.
            property real sliderActualHeight: (scrollBarOrientation === Qt.Vertical) ? (((parentContentHeight / parentObj.height)!==0)?(scrollLimitAreaHeight / (parentContentHeight / parentObj.height)):0) : scrollSliderSize

            width: (scrollBarOrientation === Qt.Vertical) ? scrollSliderSize : (scrollLimitAreaWidth/ (totalContentWidth / parentObj.width))
            height: (scrollBarOrientation === Qt.Vertical) ? ((sliderActualHeight > sliderMinSize ) ? sliderActualHeight : sliderMinSize ) : scrollSliderSize

            color: scrollSliderColor
            radius: 2
            onParentContentHeightChanged: {
                //calculation of slider height w.r.t to the ratio of total content to display height
                var newSliderHeight = (scrollLimitAreaHeight / (parentContentHeight / parentObj.height))
                height = (scrollBarOrientation === Qt.Vertical) ? ((newSliderHeight > sliderMinSize) ? newSliderHeight: sliderMinSize) : parent.height
                scrollBarSlider.sliderActualHeight = newSliderHeight

                //On totalContentHeight change, adjust the slider position accordingly
                var yposition = (parentObj.getFlickablePosition(scrollBarOrientation));
                positionSlider(yposition,scrollBarOrientation)
            }
        }
        // drag of slider/thumb
        MouseArea {
            id: scrollBarSliderArea

            width: (scrollBarOrientation === Qt.Vertical) ? scrollBarSize : parent.width
            height: (scrollBarOrientation === Qt.Vertical) ? parent.height : scrollBarSize

            preventStealing: true

            drag.target: (enabled===true)?scrollSliderContainer:undefined
            drag.axis: (scrollBarOrientation === Qt.Vertical) ? Drag.YAxis : Drag.XAxis
            drag.maximumX: (scrollBarOrientation === Qt.Vertical) ? 0 : (scrollBar.width-buttonDimension - scrollBarSlider.width)
            drag.maximumY: (scrollBarOrientation === Qt.Vertical) ? (scrollBar.height-buttonDimension - scrollBarSlider.height) :0
            drag.minimumY:(scrollBarOrientation === Qt.Vertical) ? buttonDimension:0
            drag.minimumX:(scrollBarOrientation === Qt.Vertical) ? 0 :buttonDimension

            onPressed: {
                parentObj.stopEditMode()

                if(false ===parentObj.focus)
                    parentObj.setFocus();
            }
            onReleased: {
                if (scrollBarOrientation === Qt.Vertical) {
                    scrollContent ()
                }
            }
            // For horizontal dragging
            onMouseXChanged: {
                if (scrollBarOrientation !== Qt.Vertical) {
                    scrollContent ()
                }
            }
        }
    }

    // To handle click event between the scrollBarSlider and the UP/LEFT button
    Item {
        id: scrollBarAbove

        height: (scrollBarOrientation === Qt.Vertical) ? scrollSliderContainer.y - buttonDimension: scrollBar.height
        width: (scrollBarOrientation === Qt.Vertical) ? scrollBar.width : scrollSliderContainer.x - buttonDimension

        y: (scrollBarOrientation === Qt.Vertical) ? buttonDimension : 0
        x : (scrollBarOrientation === Qt.Vertical) ? 0 : buttonDimension
        enabled: scrollSliderContainer.enabled
        MouseArea {
            height: parent.height
            width: parent.width

            onPressed: {
                // Unload the loaded component, if scrolling has been started
                parentObj.stopEditMode()
            }
            onClicked: {
                if(false ===parentObj.focus)
                    parentObj.setFocus();
                if (scrollBarOrientation === Qt.Vertical) {

                    parentObj.onScrollPageUp();
                }
                else
                {   // displacement of horizontal slider
                    var displacement = flickListView.contentX - parentObj.width
                    parentObj.scrollListView((((displacement) > 0) ? displacement :0), scrollBar.scrollBarOrientation);
                }

            }
        }
    }

    // To handle click event between the scrollBarSlider and the DOWN/RIGHT button
    Item {
        id: scrollBarBelow

        //Calculate the dimensions between slider and Button
        height: (scrollBarOrientation === Qt.Vertical) ? (scrollBar.height - (scrollSliderContainer.y + scrollBarSlider.height+buttonDimension)) : scrollBar.height
        width: (scrollBarOrientation === Qt.Vertical) ? scrollBar.width : (scrollBar.width - (scrollSliderContainer.x + scrollBarSlider.width+buttonDimension))

        y: (scrollBarOrientation === Qt.Vertical) ? (scrollSliderContainer.y + scrollBarSlider.height) : 0
        x: (scrollBarOrientation === Qt.Vertical) ? 0 : (scrollSliderContainer.x + scrollBarSlider.width)
        enabled: scrollSliderContainer.enabled
        MouseArea {
            height: parent.height
            width: parent.width

            onPressed: {
                // Unload the loaded component, if scrolling has been started
                parentObj.stopEditMode()
            }
            onClicked: {
                if(false ===parentObj.focus)
                    parentObj.setFocus();
                if (scrollBarOrientation === Qt.Vertical) {
                    parentObj.onScrollPageDown();
                }
                else
                {
                    // displacement of horizontal slider
                    var displacement = flickListView.contentX + parentObj.width
                    parentObj.scrollListView((((displacement) > 0) ? displacement :0), scrollBar.scrollBarOrientation);
                }
            }
        }
    }
    
    //Intersecting rectangle between horizontal and vertical scrollbar
    Rectangle {
        id: scrollBarTrailer
        color: scrollBarColor

        x:0
        y:scrollBar.height
        //trailer appears when both horizontal and vertical are created
        height:((parentObj.horizontalScrollBarObj!==undefined)&&(scrollBarOrientation === Qt.Vertical))?scrollBarSize:0
        width: ((parentObj.horizontalScrollBarObj!==undefined)&&(scrollBarOrientation === Qt.Vertical))?scrollBarSize:0

        //Intentionally ignore mouse actions
        MouseArea{
            height: parent.height
            width:  parent.width
            onClicked: {}
        }
    }
    Component.onCompleted: {
        setScrollBarSliderPositions();
    }
}


