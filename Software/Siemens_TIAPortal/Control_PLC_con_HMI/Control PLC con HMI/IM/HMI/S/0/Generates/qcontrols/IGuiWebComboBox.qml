
import QtQuick 2.0

Rectangle {
    x:0
    y:0
    id: rect
    color:  "#80000000"
    property int listItemheight: 30
    property int listSetectedIndex: 0
    property int scrollBarwidth:0
    property int scrollBarSliderWidth:0
    property var scrollObj: undefined
    property int startindex: 0
    property int listItemsPerPage : (listRect.height/rect.listItemheight)
    property font comboFont
    property bool hasScrollIndicator : false

    function setModelItems(comboBoxText, currentIndex)
    {
        for (var i=0; i < comboBoxText.length; i++)
        {
                     modelListData.append({"comboBoxListItem": comboBoxText[i]})
        }
        comboBoxList.currentIndex = currentIndex;
        listSetectedIndex = currentIndex;
        if(comboBoxList.currentIndex >= listItemsPerPage)
        {
            startindex = comboBoxList.currentIndex - (listItemsPerPage - 1);
        }

    }
    signal selectedItem(var ItemIndex);
    MouseArea
    {
        id: rectMouseArea;
        anchors.fill: {return parent}
        acceptedButtons:  Qt.LeftButton
        onClicked:
        {
            rect.selectedItem(-1)
        }
    }



    function comboBoxKeyEvents(keyCode, isKeySimulated)
    {

        if(keyCode === Qt.Key_PageDown)
        {
            if(comboBoxList.count < listItemsPerPage)
            {
                comboBoxList.currentIndex = comboBoxList.count - 1;
            }
            else if((comboBoxList.currentIndex - startindex) < (listItemsPerPage - 1))
            {
                comboBoxList.currentIndex = startindex + (listItemsPerPage - 1);
            }
            else
            {
                startindex = comboBoxList.currentIndex + 1;
                comboBoxList.currentIndex = startindex + (listItemsPerPage - 1);
                if(comboBoxList.currentIndex > (comboBoxList.count - 1))
                {
                    comboBoxList.currentIndex = (comboBoxList.count - 1);
                    startindex = comboBoxList.currentIndex - (listItemsPerPage - 1);
                }
            }
        }
        else if(keyCode === Qt.Key_PageUp)
        {
            if(comboBoxList.currentIndex == startindex)
            {
                comboBoxList.currentIndex = startindex - listItemsPerPage;
                startindex = comboBoxList.currentIndex;
            }
            else
            {
                comboBoxList.currentIndex = startindex;
            }

            if(comboBoxList.currentIndex < 0)
            {
                comboBoxList.currentIndex = startindex = 0;
            }
        }
        else if(keyCode === Qt.Key_Home)
        {
            startindex = 0;
            comboBoxList.currentIndex = 0;
        }
        else if(keyCode === Qt.Key_End)
        {
            comboBoxList.currentIndex = comboBoxList.count -1;
            if(comboBoxList.count < listItemsPerPage)
                startindex = 0;
            else
                startindex = comboBoxList.count -listItemsPerPage;
        }
        else if(keyCode === Qt.Key_Up)
        {
            if (comboBoxList.currentIndex > 0)
            {
                if(startindex == comboBoxList.currentIndex)
                    startindex--;
                if(isKeySimulated === true)
                    comboBoxList.currentIndex--;
            }
        }
        else if(keyCode === Qt.Key_Down)
        {
            if (comboBoxList.currentIndex < (comboBoxList.count - 1))
            {
                if(comboBoxList.currentIndex == (startindex +(listItemsPerPage - 1)))
                    startindex++;
                if(isKeySimulated === true)
                   comboBoxList.currentIndex++;
            }
        }
    }

    Rectangle
    {
        id:comboboxRect
        color: "white"
        width: 270
        height: 270
        anchors.centerIn: {return parent}
        property int qm_scrollBarSize  : scrollBarwidth
        property int qm_scrollBarSliderSize  : scrollBarSliderWidth
        property int headerHeight : 0
        property color qm_scrollBarBackColor: "white"
        property color qm_scrollBarForeColor:"black"

        function getFlickablePosition(scrollBarOrientation){
            return (1)
        }

        function setFocus() {

        }

        function onScrollButtonUp()
        {
            //Move the list view context. Not the Selection
            var scrollContext = comboBoxList.contentY - listItemheight;
            if(scrollContext >= 0)
                comboBoxList.contentY = scrollContext;
        }

        function onScrollButtonDown()
        {
            var scrollContext = comboBoxList.contentY + listItemheight;
            if(scrollContext <= comboBoxList.contentHeight - (listItemsPerPage * listItemheight))
                comboBoxList.contentY = scrollContext;
        }

        function onScrollPageUp()
        {
            var scrollContext = comboBoxList.contentY - listItemsPerPage * listItemheight;
            if(scrollContext >= 0)
                comboBoxList.contentY = scrollContext;
            else
                comboBoxList.contentY = 0
        }

        function onScrollPageDown()
        {
            var scrollContext = comboBoxList.contentY + listItemsPerPage * listItemheight;
            if(scrollContext <= comboBoxList.contentHeight - (listItemsPerPage * listItemheight))
                comboBoxList.contentY = scrollContext;
            else
                comboBoxList.contentY = comboBoxList.contentHeight - (listItemsPerPage * listItemheight);
        }

        function scrollListView (newContentPos, scrollBarOrientation)
        {
            var denomimator = 0.0
            if(hasScrollIndicator)
                denomimator = (comboBoxList.height - 6.0)
            else
                denomimator = (comboBoxList.height - closeRect.height) - 2 * qm_scrollBarSize

            var nScrollRowIndex = Math.round((newContentPos / denomimator) * modelListData.count)
            if(nScrollRowIndex > (modelListData.count - listItemsPerPage))
                nScrollRowIndex = modelListData.count - listItemsPerPage;
            comboBoxList.contentY = nScrollRowIndex * listItemheight;
        }

        function stopEditMode()
        {
            //bummy Function
        }
        function createScrollbar()
        {
            var scrollBarComp = Qt.createComponent("IGuiVerticalScrollBar.qml")

            if(scrollBarComp.status === Component.Ready) {
                if(scrollObj !== undefined)
                {
                    scrollObj.destory()
                    scrollObj = undefined
                }

                scrollObj = scrollBarComp.createObject(rect,
                                                          {
                                                              "smartListObj" : comboboxRect,
                                                              "height": listRect.height,
                                                              "scrollXOffset": qm_scrollBarSize,
                                                              "scrollYOffset": (-1 * closeRect.height),
                                                              "totalContentHeight":comboBoxList.contentHeight,
                                                              "scrollBarSize": qm_scrollBarSize,
                                                              "scrollSliderSize":qm_scrollBarSliderSize
                                                          }
                                                          )
            }

        }


        function createScollIndicator()
        {
            var scrollIndicatorComp = Qt.createComponent("IGuiScrollIndicator.qml")
            if(scrollIndicatorComp.status === Component.Ready) {
                if(scrollObj !== undefined)
                {
                    scrollObj.destory()
                    scrollObj = undefined
                }
                scrollObj = scrollIndicatorComp.createObject(listRect,
                                                          {
                                                              "x" : listRect.width - qm_scrollBarSize,
                                                              "smartListObj" : comboboxRect,
                                                              "height": (listRect.height - qm_scrollBarSliderSize),
                                                              "width": qm_scrollBarSize,
                                                              "scrollIndicatorOrientation": Qt.Vertical,
                                                              "totalContentHeight":comboBoxList.contentHeight,                                                              
                                                              "scrollHotZoneArea": qm_scrollBarSize
                                                          }
                                                          )
            }
        }

        Rectangle
        {
            id: closeRect
            width: {return listRect.width}
            height: 25
            color: "#ff3e414f"
            anchors.top: {return comboboxRect.top}
            anchors.right: {return comboboxRect.right}
            anchors.left: {return comboboxRect.left}
            MouseArea
            {
                x:0; y:0;
                width: closeRect.width - colseButtonImage.width
                height: closeRect.height
            }
            Image
            {
                id: colseButtonImage
                source: "./pics/Kb_ButtonClose_normal.png"
                height: 25
                width: 25
                anchors.right: {return closeRect.right}
                smooth:false
            }
        }

        Rectangle
        {
            id: listRect
            color: "white"
            anchors.top: {return closeRect.bottom}
            anchors.right: {return comboboxRect.right}
            anchors.left: {return comboboxRect.left}
            anchors.bottom: {return comboboxRect.bottom}


            ListView
            {
                id: comboBoxList;
                clip: true;
                currentIndex: -1;
                boundsBehavior: Flickable.StopAtBounds

                onContentHeightChanged:{
                    if ( (contentHeight > 0) && (contentHeight > (comboboxRect.height - closeRect.height)))
                    {
                        if(hasScrollIndicator)
                            comboboxRect.createScollIndicator()
                        else
                            comboboxRect.createScrollbar()
                    }
                }

                onContentYChanged: {
                    scrollObj.positionSlider(comboBoxList.contentY,Qt.Vertical);
                }

                model: ListModel
                {
                id: modelListData;
                }

                delegate: Item
                {
                id: listItem;
                height: {return listItemheight}
                anchors {
                    left: {return parent.left;}
                    right: {return parent.right;}
                }

                property bool isCurrent : (model.index === comboBoxList.currentIndex);
                onIsCurrentChanged:
                {
                    if (isCurrent)
                    {
                        input.forceActiveFocus ();
                    }
                    else
                    {
                        input = false;
                    }
                }
                Text
                {
                    id: label;
                    text: model.comboBoxListItem;
                    font:comboFont
                    visible: !listItem.isCurrent;

                    anchors
                    {
                        left: parent.left;
                        margins: 5;
                        verticalCenter: {return parent.verticalCenter;}
                    }
                }
                Text
                {
                    id: input;
                    text: {return model.comboBoxListItem;}
                    font:comboFont
                    visible: listItem.isCurrent;
                    anchors
                    {
                        left: {return parent.left;}
                        margins: 5;
                        verticalCenter: {return parent.verticalCenter;}
                    }
                    Rectangle
                    {
                        z: {return parent.z -1;}
                        x: {return 2 - parent.x;}
                        y: {return 2 - parent.y;}
                        height: {return listItemheight - 4;}
                        width: {return listRect.width - 4;}
                        border.color: "#A0DCFF"
                        color: "#A5EFFF"
                        border.width: 3
                        radius: 3
                    }
                }
                MouseArea
                {
                    id: clicker;
                    anchors.fill: {return parent}
                    onClicked:
                    {
                        if(listSetectedIndex !== model.index)
                        {
                            comboBoxList.currentIndex = model.index;
                            rect.selectedItem(comboBoxList.currentIndex)
                        }
                        else
                        {
                            rect.selectedItem(-1)
                        }
                    }

                }

                Rectangle
                {
                    id: rowSplitter
                    height: 1;
                    color: "lightgray";
                    anchors
                    {
                        left: {return parent.left}
                        right: {return parent.right}
                        bottom: {return parent.bottom}
                    }
                }
            }
            anchors.fill: {return parent}
            Keys.onPressed:
            {
                comboBoxKeyEvents(event.key , false)
            }


            Keys.onEnterPressed:
            {
                if(listSetectedIndex !== comboBoxList.currentIndex)
                    rect.selectedItem(comboBoxList.currentIndex)
                else
                    rect.selectedItem(-1)

            }
            Keys.onReturnPressed:
            {
                if(listSetectedIndex !== comboBoxList.currentIndex)
                    rect.selectedItem(comboBoxList.currentIndex)
                else
                    rect.selectedItem(-1)
            }
            Keys.onEscapePressed:
            {
                rect.selectedItem(-1)
            }
            onFocusChanged:
            {
                if(focus == false)
                {
                    rect.selectedItem(-2)
                }
            }

          }
        }
Component.onDestruction: {
    if(scrollObj !== undefined)
    {
        scrollObj.destroy()
        scrollObj = undefined
    }
}
    }

}
