import QtQuick 2.0
import SmartPolygonComponent 1.0
// Horizontal scroll bar
Rectangle {
    id: scrollBar
    //ScrollBar parameters
    property var smartListObj: undefined
    property int scrollBarSize: 0    //Scrollbar size (in pixels)
    property int scrollSliderSize: 0        //Slider or thumb size (in pixels)   
    property int sliderMinSize:20           //Minimum size slider
    property int horizontalDisplacement:20  //displacement value for horizontal left and right button clicks

    property real totalContentHeight: 0     //Total number of rows interms of pixels
    property real totalContentWidth: 0      //Total number of columns interms of pixels

    width: (smartListObj.width - scrollBarSize)
    height: scrollBarSize
    color: smartListObj.qm_scrollBarBackColor

    // Button to handle click event on Left button press
    Rectangle {
        id: btnItem1
        height : scrollBarSize
        width : ((scrollBar.width<=2*scrollBarSize)? (scrollBar.width/2):scrollBarSize)
        color: smartListObj.qm_scrollBarBackColor
        
        property bool isPressed : false
        //To draw triangle on button
        IGuiSmartPolygon {
            id: smartPolygonComponent
            width: btnItem1.width
            height: btnItem1.height
            fillColor: smartListObj.qm_scrollBarForeColor
            borderWidth:0
            pointList: [(Qt.point(((5/8)*width) + 1,((3/4)*height) + 1)),
                        (Qt.point(((3/8)*width) + 1,((1/2)*height) + 1)),
                        (Qt.point(((5/8)*width) + 1,((1/4)*height) + 1))]
        }
    }
    // To handle click event on right button press
    Rectangle {
        id: btnItem2
        height: scrollBarSize
        width: ((scrollBar.width<=2*scrollBarSize)? (scrollBar.width/2):scrollBarSize)
        color: smartListObj.qm_scrollBarBackColor
        x: (scrollBar.width-btnItem2.width)
        y: 0

        property bool isPressed : false
        //To draw triangle on button
        IGuiSmartPolygon {
            id: smartPolygonComponent2
            width: btnItem2.width
            height: btnItem2.height
            fillColor: smartListObj.qm_scrollBarForeColor
            borderWidth:0
            pointList: [(Qt.point(((3/8)*width) + 1,((1/4)*height) + 1)),
                        (Qt.point(((5/8)*width) + 1,((1/2)*height) + 1)),
                         (Qt.point(((3/8)*width) + 1,((3/4)*height) + 1))]
        }
    }
    //scroll slider
    Item {
        id: scrollSliderContainer

        property bool bPressed : false
        width: scrollBarSlider.width
        height: scrollBarSize
        x: scrollBarSize
        y: 0
        //visibility of slider depends on the scrollbar dimensions
        visible: ((scrollBar.width <= (2*scrollBarSize+sliderMinSize))? false:scrollBar.visible)
        enabled: scrollSliderContainer.visible


        Rectangle {
            id: scrollBarSlider
            property int parentContentHeight: totalContentHeight
            // Minimum slider height limited to sliderMinSize px.
            // If number of list rows increase such that the slider height decreases below sliderMinSize, the original height is preserved.
            property real sliderActualHeight: scrollSliderSize

            width: ((scrollBar.width-(2*scrollBarSize))/ (totalContentWidth / smartListObj.width))
            height: scrollSliderSize
            color: smartListObj.qm_scrollBarForeColor
            onParentContentHeightChanged: {
                //calculation of slider height w.r.t to the ratio of total content to display height
                scrollBarSlider.sliderActualHeight = (scrollBarSize / (parentContentHeight / smartListObj.height))
                height = parent.height

                //On totalContentHeight change, adjust the slider position accordingly
                positionSlider(smartListObj.getFlickablePosition(Qt.Horizontal))
            }
        }
        // drag of slider/thumb
    }
    function setScrollBarSliderPositions () {
        scrollBar.x = smartListObj.x
        scrollBar.y = smartListObj.y + smartListObj.height
        scrollBarSlider.x = 0
        scrollBarSlider.y = ((scrollBarSize - scrollBarSlider.height)/2)
    }
    
    //Reposition the slider to appropriate location depending on current content position
    function positionSlider (scrollPosition) {
        //Normalized ratio w.r.t total content width
        var newSliderPosition = (scrollPosition) / (totalContentWidth - smartListObj.width)
        //Adjusting slider/thumb in scrollLimitArea for horizontal scrollBar
        scrollSliderContainer.x = (newSliderPosition * ((scrollBar.width-(2*scrollBarSize)) - scrollBarSlider.width))+scrollBarSize;
        var maxX = scrollBar.width - scrollBarSlider.width - scrollBarSize
        //Boundary conditions
        if (scrollSliderContainer.x < scrollBarSize){
            scrollSliderContainer.x  = scrollBarSize
        }else if (scrollSliderContainer.x > maxX)
        {
            scrollSliderContainer.x = maxX
        }
    }

    //Update the content w.r.t slider position
    function scrollContent () {
        //displacement calculation for horizontal scroll bar w.r.t total content width
        var newContentPos = (((scrollSliderContainer.x - scrollBarSize) * (totalContentWidth - smartListObj.width))/((scrollBar.width-(2*scrollBarSize)) - scrollSliderContainer.width));
        smartListObj.scrollListView(newContentPos, Qt.Horizontal)
    }

    //Function will return true if the mouse x,y is within the rectangle
    function isMouseClickInsideRect(mouseX, mouseY, rectObj) {
        if((mouseX >= rectObj.x) && (mouseX <= (rectObj.x + rectObj.width))) {
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
        else if(isMouseClickInsideRect(mouseX, mouseY, btnItem2))  {
                return 2
        }
        else if(isMouseClickInsideRect(mouseX, mouseY, scrollSliderContainer))  {
                return 3
        }
        else if((mouseX >= scrollBarSize) && (mouseX <= scrollSliderContainer.x) &&
                (scrollSliderContainer.enabled))  {
                return 4
        }
        else if((mouseX >= (scrollSliderContainer.x + scrollBarSlider.width)) &&
                (mouseX <= (scrollBar.width - scrollBarSize)) &&
                (scrollSliderContainer.enabled))   {
                return 5
        }
        else  {
            return 6
        }
    }

    //Function to update scroll button properties
    function updateScrollButton(button, smartPolyComp, smartPolyCompColor, buttonColor, isPressed)   {
        smartPolyComp.fillColor = smartPolyCompColor
        smartPolyComp.update()
        button.color = buttonColor
        button.isPressed = isPressed
    }
    
    MouseArea{
        height: parent.height
        width: parent.width
        preventStealing: true
        drag.target: ((scrollSliderContainer.enabled===true) && (scrollSliderContainer.bPressed))?scrollSliderContainer:undefined
        drag.axis: Drag.XAxis
        drag.maximumX: (scrollBar.width-scrollBarSize - scrollBarSlider.width)
        drag.maximumY: 0
        drag.minimumY: 0
        drag.minimumX: scrollBarSize

        onMouseXChanged: {
                scrollContent ()
        }
        onReleased: {
            if(scrollSliderContainer.bPressed)
            {                
                scrollSliderContainer.bPressed = false
            }
            var clickedArea = getClickedArea(mouseX, mouseY)
            if((clickedArea === 1) || btnItem1.isPressed)//release on button up
            {
                //Update color to original color on release
                updateScrollButton(btnItem1, smartPolygonComponent, smartListObj.qm_scrollBarForeColor,
                                   smartListObj.qm_scrollBarBackColor, false)
            }
            if((clickedArea === 2) || btnItem2.isPressed) //release on button down
            {
                //Update color to original color on release
                updateScrollButton(btnItem2, smartPolygonComponent2, smartListObj.qm_scrollBarForeColor,
                                   smartListObj.qm_scrollBarBackColor, false)
            }
        }

        onClicked: {
            smartListObj.initListScroll()
            var displacement = 0.0
            var clickedArea = getClickedArea(mouseX, mouseY)
            if(clickedArea === 4)//click on scroll above
            {
                // displacement of horizontal slider
                displacement = smartListObj.qm_smartLstView.contentX - smartListObj.width
                smartListObj.scrollListView(((displacement > 0) ? displacement :0), Qt.Horizontal)
            }
            else if(clickedArea === 5)//click on scroll below
            {
                    // displacement of horizontal slider
                    displacement = smartListObj.qm_smartLstView.contentX + smartListObj.width
                    smartListObj.scrollListView(((displacement > 0) ? displacement :0), Qt.Horizontal)
            }
        }

        onPressed: {
            smartListObj.initListScroll()
            var clickedArea = getClickedArea(mouseX, mouseY)
            if((clickedArea === 1) && (smartListObj.getFlickablePosition(Qt.Horizontal)>0))//press on button up
            {
                //Get Flickable position from ListView
                var displacement = smartListObj.qm_smartLstView.contentX - horizontalDisplacement
                smartListObj.scrollListView(((displacement) > 0 ? displacement :0), Qt.Horizontal)

                //Update color to show button pressed
                updateScrollButton(btnItem1, smartPolygonComponent, smartListObj.qm_scrollBarBackColor,
                                   smartListObj.qm_scrollBarForeColor, true)
            }
           else if((clickedArea === 2)
                   && (smartListObj.getFlickablePosition(Qt.Horizontal)<(totalContentWidth-smartListObj.width)))//press on button down
            {
                //Horizontal button scrolling
                smartListObj.scrollListView((smartListObj.qm_smartLstView.contentX + horizontalDisplacement),Qt.Horizontal)
                //Update color to show button pressed
                updateScrollButton(btnItem2, smartPolygonComponent2, smartListObj.qm_scrollBarBackColor,
                                   smartListObj.qm_scrollBarForeColor, true)
            }
            else if(clickedArea === 3) //press on slider
            {
                scrollSliderContainer.bPressed = true
            }
        }
    }
    Component.onCompleted: {
        setScrollBarSliderPositions()
    }
}
