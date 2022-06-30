import QtQuick 2.0
import SmartPolygonComponent 1.0
// vertical scroll bar
Rectangle {
    id: scrollBar
    //ScrollBar parameters
    property variant smartListObj: undefined       //Parent object (listctrl object)
    property variant scrollCtrlObj : undefined  //Scroll control object
    property int scrollXOffset: 0               //Scroll bar Offset for X axis
    property int scrollYOffset: 0               //Scroll bar Offset for Y axis
    property int scrollBarSize: 0               //Scrollbar size (in pixels)
    property int scrollSliderSize: 0            //Slider or thumb size (in pixels)
    property int sliderMinSize:20               //Minimum size slider
    property real totalContentHeight: 0         //Total number of rows interms of pixels

    width: scrollBarSize
    height: (smartListObj.height + smartListObj.headerHeight - scrollBarSize)
    color: smartListObj.qm_scrollBarBackColor

    // Button to handle click event on Up button press
    Rectangle {
        id: btnItem1

        height : ((scrollBar.height<=2*scrollBarSize)? (scrollBar.height/2):scrollBarSize)
        width :  scrollBarSize
        color: smartListObj.qm_scrollBarBackColor

        property bool isPressed : false
        //To draw triangle on button
        IGuiSmartPolygon {
            id: smartPolygonComponent
            width: btnItem1.width
            height: btnItem1.height
            fillColor: smartListObj.qm_scrollBarForeColor
            borderWidth:0
            pointList: [(Qt.point(((1/4)*width) + 1,((5/8)*height) + 1)),
                (Qt.point(((1/2)*width) + 1,((3/8)*height) + 1)),
                (Qt.point(((3/4)*width) + 1,((5/8)*height) + 1))]
        }
    }
    // To handle click event on Down button press
    Rectangle {
        id: btnItem2

        height: ((scrollBar.height<=2*scrollBarSize)? (scrollBar.height/2):scrollBarSize)
        width: scrollBarSize
        color: smartListObj.qm_scrollBarBackColor

        x: 0
        y: (scrollBar.height-btnItem2.height)

        property bool isPressed : false
        //To draw triangle on button
        IGuiSmartPolygon {
            id: smartPolygonComponent2
            width: btnItem2.width
            height: btnItem2.height
            fillColor: smartListObj.qm_scrollBarForeColor
            borderWidth:0
            pointList: [(Qt.point(((3/4)*width) + 1,((3/8)*height) + 1)),
                (Qt.point(((1/2)*width) + 1,((5/8)*height) + 1)),
                (Qt.point(((1/4)*width) + 1,((3/8)*height) + 1))]
        }
    }

    //scroll slider
    Item {
        id: scrollSliderContainer
        property bool bPressed : false

        width: scrollBarSize
        height: scrollBarSlider.height
        x: 0
        y: scrollBarSize
        //visibility of slider depends on the scrollbar dimensions
        visible:  ((scrollBar.height <= (2*scrollBarSize+sliderMinSize))? false:scrollBar.visible)
        enabled: scrollSliderContainer.visible

        Rectangle {
            id: scrollBarSlider

            //property int scrollLimitAreaHeight : (scrollBar.height-(2*scrollBarSize))
            property int parentContentHeight: totalContentHeight
            // Minimum slider height limited to sliderMinSize px.
            // If number of list rows increase such that the slider height decreases below sliderMinSize, the original height is preserved.
            property real sliderActualHeight: (((parentContentHeight / smartListObj.height)!==0)?((scrollBar.height-(2*scrollBarSize)) / (parentContentHeight / smartListObj.height)):0)

            width: scrollSliderSize
            height: ((sliderActualHeight > sliderMinSize ) ? sliderActualHeight : sliderMinSize)
            color: smartListObj.qm_scrollBarForeColor            
            onParentContentHeightChanged: {
                //calculation of slider height w.r.t to the ratio of total content to display height
                var newSliderHeight = ((scrollBar.height-(2*scrollBarSize)) / (parentContentHeight / smartListObj.height))
                height = ((newSliderHeight > sliderMinSize) ? newSliderHeight: sliderMinSize)
                scrollBarSlider.sliderActualHeight = newSliderHeight

                //On totalContentHeight change, adjust the slider position accordingly
                positionSlider(smartListObj.getFlickablePosition(Qt.Vertical), Qt.Vertical)
            }
        }
    }

    //Intersecting rectangle between horizontal and vertical scrollbar
    Rectangle {
        id: scrollBarTrailer
        color: smartListObj.qm_scrollBarBackColor

        x:0
        y:scrollBar.height
        //trailer appears when both horizontal and vertical are created
        height: ((scrollCtrlObj !== undefined)&&(scrollCtrlObj.horizontalScrollObj!==undefined))?scrollBarSize:0
        width: ((scrollCtrlObj !== undefined)&&(scrollCtrlObj.horizontalScrollObj!==undefined))?scrollBarSize:0

        //Intentionally ignore mouse actions
        MouseArea{
            height: parent.height
            width:  parent.width
            onClicked: {}
        }
    }
    //Function to set the position of the scroll bar and slider position
    function setScrollBarSliderPositions (differentialHeight) {
        scrollBar.x = smartListObj.x + smartListObj.width - scrollXOffset
        scrollBar.y = smartListObj.y - smartListObj.headerHeight - scrollYOffset
        scrollBarSlider.x = ((scrollBarSize - scrollBarSlider.width)/2)
        scrollBarSlider.y = 0
        scrollBar.height +=differentialHeight
       }
    
    //Reposition the slider to appropriate location depending on current content position
    function positionSlider (scrollPosition) {
        //Normalized ratio w.r.t total content height
        var newSliderPosition = (scrollPosition) / (totalContentHeight - smartListObj.height)

        //Adjusting slider/thumb in scrollLimitArea
        scrollSliderContainer.y = (newSliderPosition * ((scrollBar.height-(2*scrollBarSize)) - scrollBarSlider.height))+scrollBarSize;
        var maxY = scrollBar.height - scrollBarSlider.height - scrollBarSize
        //Boundary conditions
        if (scrollSliderContainer.y <scrollBarSize){
            scrollSliderContainer.y  = scrollBarSize
        }else if (scrollSliderContainer.y > maxY){
            scrollSliderContainer.y  = maxY
        }
    }

    //Update the content w.r.t slider position
    function scrollContent () {
        //slider displacement
        var newContentPos = scrollSliderContainer.y-scrollBarSize
        // If slider height is limited to sliderMinSize px and if slider reaches bottom of scroll bar, use preserved slider height to scroll to end of list,
        if ((scrollSliderContainer.y + sliderMinSize) >= (scrollBar.height - scrollBarSize)) {
            newContentPos = (scrollBar.height-(2*scrollBarSize)) - scrollBarSlider.sliderActualHeight
        }

        // If slider height is limited to sliderMinSize px, recalculate scroll position to unlimited slider's y
        else if (scrollBarSlider.sliderActualHeight <= sliderMinSize) {
            // Max limited slider y range = scrollBarSize to (scrollBar.height - sliderMinSize - scrollBarSize)
            // Calculate % displacement of limited slider in its range
            var sliderDisplacement = ((scrollSliderContainer.y-scrollBarSize)/((scrollBar.height-(2*scrollBarSize)) - sliderMinSize))

            // Max unlimited slider y range w.r.t limited slider top = 0 to (sliderMinSize px - preserved height)
            // Relative % displacement of actual height slider in its range is same as that of umlimited slider
            var relativeActualSliderDisplacement = (sliderMinSize - scrollBarSlider.sliderActualHeight) * sliderDisplacement

            // Scroll position = limited slider's y + relative displacement of actual height slider w.r.t limited slider
            newContentPos = scrollSliderContainer.y - scrollBarSize + relativeActualSliderDisplacement
        }

        // scroll bar height = list Rectangle height - scrollBarSize; only if horizontalScrollObj is not NULL// scrollBarSize is two button dimensions
        var denomimator = (smartListObj.height + smartListObj.headerHeight - 2*scrollBarSize)
        //send displacement position to list view
        smartListObj.scrollListView(newContentPos, Qt.Vertical, denomimator)

    }

    //Function will return true if the mouse x,y is within the rectangle
    function isMouseClickInsideRect(mouseX, mouseY, rectObj) {
        if((mouseY >= rectObj.y) && (mouseY <= ((rectObj.y + rectObj.height)))) {
            return true
        }
        else {
            return false
        }
    }

    function getClickedArea(mouseX, mouseY)  {
        if(isMouseClickInsideRect(mouseX, mouseY, btnItem1))  {
            return 1
        }
        else if(isMouseClickInsideRect(mouseX, mouseY, btnItem2))   {
            return 2
        }
        else if(isMouseClickInsideRect(mouseX, mouseY, scrollSliderContainer))    {
            return 3
        }
        else if((mouseY >= scrollBarSize) && (mouseY <= scrollSliderContainer.y) && (scrollSliderContainer.enabled))   {
            return 4
        }
        else if((mouseY >= (scrollSliderContainer.y + scrollBarSlider.height)) && (mouseY <= (scrollBar.height-scrollBarSize))
                &&(scrollSliderContainer.enabled))  {
            return 5
        }
        else {
            return 6
        }
    }
    //Function to update scroll button properties
    function updateScrollButton(button, smartPolyComp, smartPolyCompColor, buttonColor, isPressed)  {
        smartPolyComp.fillColor = smartPolyCompColor
        smartPolyComp.update()
        button.color = buttonColor
        button.isPressed = isPressed
    }
    //Common mouse area
    MouseArea{
        height: parent.height
        width: parent.width

        preventStealing: true

        drag.target: ((scrollSliderContainer.enabled===true) && (scrollSliderContainer.bPressed))?scrollSliderContainer:undefined
        drag.axis: Drag.YAxis
        drag.maximumX: 0
        drag.maximumY: (scrollBar.height-scrollBarSize - scrollBarSlider.height)
        drag.minimumY: scrollBarSize
        drag.minimumX: 0

        onReleased: {
            if(scrollSliderContainer.bPressed && scrollSliderContainer.enabled)
            {                
                scrollContent ()
                scrollSliderContainer.bPressed = false
            }
            var clickedArea = getClickedArea(mouseX, mouseY)
            if((clickedArea === 1) || btnItem1.isPressed)//release on button up
            {
                //Update color to original color on release
                updateScrollButton(btnItem1, smartPolygonComponent, smartListObj.qm_scrollBarForeColor, smartListObj.qm_scrollBarBackColor, false)
            }
            if((clickedArea === 2) || btnItem2.isPressed)//release on button down
            {
                //Update color to original color on release
                updateScrollButton(btnItem2, smartPolygonComponent2, smartListObj.qm_scrollBarForeColor, smartListObj.qm_scrollBarBackColor, false)
            }
        }

        onClicked: {
            var clickedArea = getClickedArea(mouseX, mouseY)
            if(clickedArea === 4)//click on scrollabove
            {
                smartListObj.onScrollPageUp()
            }
            else if(clickedArea === 5)//click on scrollbelow
            {
                smartListObj.onScrollPageDown()
            }
        }

        onPressed: {            
            var clickedArea = getClickedArea(mouseX, mouseY)
            if((clickedArea === 1) && (smartListObj.getFlickablePosition(Qt.Vertical)>0))//press on button up
            {
                //Vertical button scrolling
                smartListObj.onScrollButtonUp()
                //Update color to show button pressed
                updateScrollButton(btnItem1, smartPolygonComponent, smartListObj.qm_scrollBarBackColor, smartListObj.qm_scrollBarForeColor, true)
            }
            else if((clickedArea === 2) //press on button down
                    && (smartListObj.getFlickablePosition(Qt.Vertical)<(totalContentHeight-smartListObj.height)))
            {
                smartListObj.onScrollButtonDown();
                //Update color to show button pressed
                updateScrollButton(btnItem2, smartPolygonComponent2, smartListObj.qm_scrollBarBackColor, smartListObj.qm_scrollBarForeColor, true)

            }
            else if(clickedArea === 3)  //press on slider
            {
                smartListObj.initListScroll()
                scrollSliderContainer.bPressed = true
            }
        }
    }
    Component.onCompleted: {
        setScrollBarSliderPositions()
    }
}
