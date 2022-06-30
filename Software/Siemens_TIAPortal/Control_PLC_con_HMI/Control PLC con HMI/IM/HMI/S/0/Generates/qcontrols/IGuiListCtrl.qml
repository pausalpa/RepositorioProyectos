// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 2.0
import QtDataModel 1.0
import QtGridline 1.0
import SmartListView 1.0

Rectangle {
    id : smartList

    property int objRef: 0

    /*    //// BORDER STYLE ////
    0: No border should be displayed
    1: Border is solid
    2: Border is solid, 3D on
*/
    // Left Header
    property int qm_leftBorderCornerRadius
    property int qm_leftBorderWidth

    property int qm_leftImageID
    property int qm_leftTileTop
    property int qm_leftTileBottom
    property int qm_leftTileRight
    property int qm_leftTileLeft

    property int qm_middleImageID
    property int qm_middleTileTop
    property int qm_middleTileBottom
    property int qm_middleTileRight
    property int qm_middleTileLeft


    property int qm_rightImageID
    property int qm_rightTileTop
    property int qm_rightTileBottom
    property int qm_rightTileRight
    property int qm_rightTileLeft

    // Table Header text format
    property color qm_tableHeaderTextColor
    property int qm_tableHeaderValueVarTextAlignmentHorizontal
    property int qm_tableHeaderValueVarTextAlignmentVertical
    property int qm_tableHeaderValueVarTextOrientation    // specified in degrees

    property int qm_tableHeaderMarginLeft
    property int qm_tableHeaderMarginRight
    property int qm_tableHeaderMarginBottom
    property int qm_tableHeaderMarginTop

    // All Back Colors
    property color qm_tableBackColor
    property color qm_tableSelectBackColor
    property color qm_tableAlternateBackColor
    property color qm_tableHeaderBackColor

    // Table text format
    property color qm_tableTextColor
    // Selection text format
    property color qm_tableSelectTextColor

    // Alternate row text format
    property color qm_tableAlternateTextColor

    property int qm_tableMarginTop
    property int qm_tableMarginBottom
    property int qm_tableMarginLeft
    property int qm_tableMarginRight

    // Gridline properties
    property int qm_gridLineStyle
    property int qm_gridLineWidth
    property color qm_gridLineColor

    /* Table font information */
    property font qm_tableFont
    property font qm_tableSelectFont

    //List Ctrl Row Height
    property int qm_tableRowHeight

    //List Ctrl Header Height
    property int qm_tableHeaderHeight

    // List control adjusting properties
    property bool qm_hasHeader
    property bool qm_hasGridLines
    property bool qm_hasBorder
    property bool qm_hasDisplayFocusLine
    property bool qm_hasVerticalScrolling
    property bool qm_hasVerticalScrollBar
    property bool qm_hasHorizontalScrollBar
    property bool qm_hasColumnOrdering
    property bool qm_hasHighLightFullRow
    property bool qm_hasVerUpDownPresent
    property bool qm_hasVerPgUpDownPresent
    property bool qm_hasHighlight
    property bool qm_hasUpDownAsPageUpDown
    property bool qm_hasLongAlarmButton
    property bool qm_hasExtraPixelForLineHeight
    property bool qm_hasRowEditable
    property bool qm_hasRowJustification
    property bool qm_hasRowJustificationBottom

    // Number of lines per row
    property int qm_linesPerRow // noOfLines

    //================================
    // Properties used during run time
    //================================
    property int adjustChildModel: 2
    property int gridLineWidth: {return (qm_hasGridLines ? qm_gridLineWidth : 0)}

    // List control header properries
    property variant headerObj: undefined
    property int headerHeight: (qm_hasHeader ? (qm_tableHeaderHeight + qm_tableHeaderMarginTop + qm_tableHeaderMarginBottom) : 0)

    // List control model manager
    property alias modelManager: theDataModel

    ///@brief Scroll bar properties
    property int qm_scrollBarSize: 0
    property int qm_scrollBarSliderSize: 0

    property color qm_scrollBarBackColor:qm_tableAlternateBackColor
    property color qm_scrollBarForeColor:qm_tableTextColor

    ///@brief Total content height(in pixels)
    property int totalContentHeight: 0
    
    property bool scrollWithScrollBar: false
    

    property int nSelectedRow : -1

    // List control column operated properties
    property int qm_noOfColumns
    property int qm_FocusLineWidth: 1 /// @brief Default focus line iwdth for all controls
    property int qm_BorderLineWidth: 1 /// @brief Draw border for the list control
    property int totalColumnWidth: {return smartList.width}
    property int actualTotalColumnWidth: {return smartList.width}
    property int totalRowCount: smartlistview.totalRowCount
    property point qm_moveStartIndex: Qt.point(-1, -1)
    property point qm_moveEndIndex: Qt.point(-1, -1)
    property int qm_RowHeight: ((qm_tableRowHeight * qm_linesPerRow) + (qm_tableMarginTop + qm_tableMarginBottom + gridLineWidth))
    property bool qm_ContentStreached: false

    property variant staticComponent: undefined
    property variant staticComponentObj: undefined

    property variant qm_scrollCtrl : undefined
    property variant qm_smartLstView : smartlistview
    property variant qm_flickLstView : flickListView

    //support for row specific colors
    property bool qm_UseRowSpecificColor : false

    ///@brief Visible row count
    property int visibleRowCount :(smartList.height/qm_RowHeight)

    property bool  qm_smartListAdjusted: false

    ///@brief to store the mouseYPress position
    property int mouseYPress: -1000

    onStaticComponentObjChanged: {
        if (staticComponentObj !== undefined) {
            parent.setLoadedComponentObject(staticComponentObj)
        }
    }

    onFocusChanged: {
        if(focus)
            handleFocus()
    }

    // List control initialization from SMART-RT (invokeMethod)
    function init(refID) {
        objRef = refID;
        updateRowsFit(false);
        actualTotalColumnWidth = totalColumnWidth
        //Initialise ListView
        smartlistview.init();
    }

    function resizeListControlData (nNewYPos)
    {
        qm_smartListAdjusted = true
        var differentialHeight = (smartList.y - headerHeight - nNewYPos);
        smartList.y = nNewYPos + headerHeight;
        smartList.height += differentialHeight;        
        resizeHeaderObj(differentialHeight,true);
    }

    function updateRowsFit(bRowHeightChanged)
    {
        var nRowsFit = 1;
        nRowsFit = (headerObj ? smartList.height : (smartList.height - headerHeight)) / qm_RowHeight        
        smartlistview.rowsFit = Math.round(nRowsFit);
        utilProxy.resizeListCtrl(objRef, smartlistview.rowsFit,bRowHeightChanged)
    }

    // Set/Reset the focus to list control from SMART-RT (invokeMethod)
    function setFocus() {
        if(false === smartlistview.focus)
        {
            utilProxy.handleFocusChange(parent.objId, objRef);
        }
    }

    function handleFocus()
    {
        smartlistview.focus = true;
    }

    function handleFocusLoss()
    {
        smartlistview.focus = false;
    }

    // Utility function required for internal list control operations
    function loadStaticComponent (componentName, rowNumber, columnNumber) {
        var cellPosition = smartlistview.getCellPosition(rowNumber, columnNumber)
        var cellSize = smartlistview.getCellSize(rowNumber, columnNumber)
        var CellData = theDataModel.getCellData(rowNumber, columnNumber)

        if((cellPosition.y + cellSize.height) > smartList.height)
        {
            smartlistview.snapListView(flickListView.contentY + qm_RowHeight)
            utilProxy.updateListData(smartList.objRef, 1)
            cellPosition = smartlistview.getCellPosition(rowNumber, columnNumber)
            cellSize = smartlistview.getCellSize(rowNumber, columnNumber)
        }


        staticComponent = Qt.createComponent(componentName)
        staticComponentObj = staticComponent.createObject(smartList,
                                                          {
                                                              "x": (cellPosition.x - flickListView.contentX),
                                                              "y": cellPosition.y,
                                                              "width": cellSize.width,
                                                              "height": cellSize.height
                                                          }
                                                          )
        staticComponentObj.handleParentData(CellData)
    }

    function unloadStaticComponent () {
        if(staticComponentObj !== undefined)
        {
            staticComponentObj.objectName = ""
            staticComponentObj.destroy ()
            staticComponentObj = undefined
            staticComponent.destroy()
            staticComponent = undefined
        }
    }

    // TODO: replace this method in future
    function stopEditMode () {
        // unload QML static component
        if(staticComponentObj !== undefined)
        {
            utilProxy.stopListCtrlEditMode()
        }
    }

    // Update header data in model manager from SMART-RT (invokeMethod)
    function updateHeaderData(headerData) {
        if (qm_hasHeader && (headerObj == undefined)) {            
            if(!qm_smartListAdjusted){
                smartList.y = smartList.y + headerHeight
                smartList.height = (smartList.height - headerHeight)                
            }
            headerObj = headerComp.createObject(smartList.parent,
                                                {
                                                    "x": smartList.x,
                                                    "y": smartList.y - headerHeight
                                                }
                                                )
        }
        else if (headerObj !== undefined)
        {
            headerObj.updateHeader();
        }
    }

    function setVisibleRows(visibleRowCount) {
        totalColumnWidth = (actualTotalColumnWidth < smartList.width) ? actualTotalColumnWidth : smartList.width
        smartlistview.height = smartList.height = (qm_RowHeight * visibleRowCount)
        smartlistview.update()
    }

    ///@brief Readjusting total column width
    function readjustTotalColumnWidth() {
        if (false == qm_hasHorizontalScrollBar) {
            totalColumnWidth = (actualTotalColumnWidth < smartList.width) ? actualTotalColumnWidth : smartList.width
            flickListView.contentWidth = (totalColumnWidth - 2 * qm_BorderLineWidth)
            flickListView.flickableDirection = qm_hasVerticalScrollBar ? Flickable.HorizontalAndVerticalFlick : Flickable.HorizontalFlick
        }
    }

    function updateFlickContentY(nContentY) {
        smartlistview.updateFlickContentY(nContentY);
    }

    function hasRowFitExceededRowCount() {
        return (smartlistview.rowsFit >= smartList.totalRowCount)
    }
    ///@brief row index calculation for listctrl
    function scrollListView (newContentPos, scrollBarOrientation, denomimator) {
        if ((scrollBarOrientation === Qt.Vertical) && (qm_scrollCtrl.verticalScrollObj !== undefined)) {
            // Disable repositioning of scroll slider
            scrollWithScrollBar = true
            //total number of rows are less than rows fit
            var newContentY = (newContentPos / denomimator)
            if (hasRowFitExceededRowCount())
            {
                //calculation of displacement for dynamic creation of vertical scrollbar(total rows < rows fit)
                updateFlickContentY(smartList.totalContentHeight * newContentY)
            }
            else
            {
                // scroll bar height = list Rectangle height - qm_scrollBarSize; only if horizontalScrollBarObj is not NULL// qm_scrollBarSize is two button dimensions
                var nScrollRowIndex = Math.round(newContentY * totalRowCount)
                utilProxy.scrollListData(smartList.objRef, nScrollRowIndex);
            }
            scrollWithScrollBar = false
        } else if ((scrollBarOrientation === Qt.Horizontal) && (qm_scrollCtrl.horizontalScrollObj !== undefined)) {
            smartlistview.snapListViewColumn(Math.round(newContentPos));
        }
    }

    ///@brief To get Flickable position with respect to total content
    function getFlickablePosition(scrollBarOrientation){
        return ((scrollBarOrientation === Qt.Vertical)?(flickListView.contentY + (smartlistview.bufferStartOffset * qm_RowHeight)):
                                                        (flickListView.contentX))
    }

    function initListScroll()
    {
        //Stop edit mode
        smartList.stopEditMode()
        //set focus to listctrl
        if(false ===smartList.focus)
            smartList.setFocus()
    }

    ///@brief scroll page up
    function onScrollPageUp()
    {
        initListScroll()
        //total number of rows are less than rows fit
        if (hasRowFitExceededRowCount())
        {
            var scrollContentY = (flickListView.contentY - (visibleRowCount * smartList.qm_RowHeight))
            updateFlickContentY((scrollContentY > 0) ? scrollContentY : 0);
        }
        else
        {
            utilProxy.updateListData(smartList.objRef, -visibleRowCount);
        }
    }

    ///@brief scroll page down
    function onScrollPageDown()
    {
        initListScroll()
        //total number of rows are less than rows fit
        if(hasRowFitExceededRowCount())
        {
            var visibleRowHeight = ((visibleRowCount - 1) * smartList.qm_RowHeight)
            var scrollContentY = flickListView.contentY + visibleRowHeight
            var lastPage = (smartList.totalContentHeight - visibleRowHeight)
            updateFlickContentY((scrollContentY > lastPage) ? lastPage : scrollContentY);
        }
        else
        {
            utilProxy.updateListData(smartList.objRef, visibleRowCount);
        }
    }

    ///@brief scroll line up
    function onScrollButtonUp()
    {
        initListScroll()
        //total number of rows are less than rows fit
        if(hasRowFitExceededRowCount())
        {
            var scrollContentY = flickListView.contentY - smartList.qm_RowHeight
            updateFlickContentY((scrollContentY > 0) ? scrollContentY : 0);
        }
        else
        {
            utilProxy.updateListData(smartList.objRef, -1);
        }
    }
    ///@brief scroll line down
    function onScrollButtonDown()
    {
        initListScroll()
        //total number of rows are less than rows fit
        if(hasRowFitExceededRowCount())
        {
            var scrollContentY = flickListView.contentY + smartList.qm_RowHeight
            var lastRow =(smartList.totalContentHeight - smartList.qm_RowHeight)
            updateFlickContentY((scrollContentY > lastRow) ? lastRow : scrollContentY);
        }
        else
        {
            utilProxy.updateListData(smartList.objRef, 1);
        }
    }
    
    ///@brief get selected index
    function getSelectedIndex(mousePosX, mousePosY) {
        var selectedIndex = Qt.point(-1, -1)
        selectedIndex = smartlistview.getIndexAt(mousePosX, mousePosY)
        return selectedIndex;
    }
    
    ///@brief update selected row
    function updateSelectedRow() {
        nSelectedRow = smartlistview.getSelectedRow()
    }

    ///@brief resize header
    function resizeHeaderObj(differentialHeight,bRowHeightChanged)  {
        if (qm_hasHeader) {
            if (headerObj !== undefined) {
                var listHeight = smartList.height + headerHeight;
                var listYPos = smartList.y - headerHeight;

                qm_tableHeaderHeight = smartlistview.tableHeaderHeight;
                smartList.height = listHeight - headerHeight;
                smartList.y = listYPos + headerHeight;
                headerObj.y = smartList.y - headerHeight;
                qm_smartListAdjusted = true
                updateRowsFit(bRowHeightChanged);
            }
            else  {
                qm_tableHeaderHeight = smartlistview.tableHeaderHeight ;                
            }            
        }
        qm_scrollCtrl.reAdjustScrollComponent(differentialHeight)
    }

    clip: true
    color: smartlistview.rowBackColor

    // Data model initialization for list view
    QtDataModel {
        id: theDataModel
        objectName: "mquDataModel"

        Component.onCompleted: {
            // TODO: pass the appropriate col count
            theDataModel.InitializeSourceModel(qm_noOfColumns)
            theDataModel.HeaderDataChanged.connect(smartList.updateHeaderData)
        }
    }

    // Header component
    Component {
        id: headerComp

        Rectangle {
            id: headerItem

            width: {return (smartList.totalColumnWidth < smartList.width) ? smartList.totalColumnWidth : smartList.width }
            height: headerHeight
            color: {return qm_tableHeaderBackColor}
            radius: {return qm_leftBorderCornerRadius}
            clip: true

            signal updateHeader

            Row {
                id: header

                property int newContentX: flickListView.contentX

                onNewContentXChanged: {
                    header.x = -flickListView.contentX;
                }

                Repeater {
                    model: {return qm_noOfColumns}
                    delegate:
                        Item {
                        id: headerDelegate

                        /// @breif Header Image ID
                        property int headerimageId: {return (index == 0) ? qm_leftImageID : ((index + 1 == qm_noOfColumns) ? qm_rightImageID : qm_middleImageID)}
                        /// @brief Image source
                        property string qm_headerimageSrc: {return (headerimageId > 0) ? ("image://QSmartImageProvider/" +
                                                                                          headerimageId     + "#" +       // image id
                                                                                          2                 + "#" +       // tiled image
                                                                                          4                 + "#" +       // horizontal alignment info
                                                                                          128               + "#" +       // vertical alignment info
                                                                                          0                 + "#" +       // language index
                                                                                          0                               // cache info
                                                                                          )
                                                                                       : ""}

                        width: smartList.children[index + adjustChildModel].width
                            height: headerHeight
                        rotation: {return qm_tableHeaderValueVarTextOrientation}

                        /// @brief Loading tiled bitmap image
                        BorderImage {
                            id: headerimage

                            anchors.fill: parent
                            source: {return qm_headerimageSrc}
                            border.left: {return (index == 0) ? qm_leftTileLeft : ((index + 1 == qm_noOfColumns) ? qm_rightTileLeft : qm_middleTileLeft)}
                            border.top: {return (index == 0) ? qm_leftTileTop : ((index + 1 == qm_noOfColumns) ? qm_rightTileTop : qm_middleTileTop)}
                            border.right: {return (index == 0) ? qm_leftTileRight : ((index + 1 == qm_noOfColumns) ? qm_rightTileRight : qm_middleTileRight)}
                            border.bottom: {return (index == 0) ? qm_leftTileBottom : ((index + 1 == qm_noOfColumns) ? qm_rightTileBottom : qm_middleTileBottom)}
                            horizontalTileMode: BorderImage.Repeat
                            verticalTileMode: BorderImage.Repeat
                        }

                        function redrawHeaderData()
                        {
                            headerData.text = theDataModel.getHeaderData(index);
                        }

                        Text {
                            id: headerData

                            //Header font properties
                            font: smartlistview.headerFont

                            anchors.fill: parent
                            anchors.leftMargin: {return qm_tableHeaderMarginLeft}
                            anchors.topMargin: {return qm_tableHeaderMarginTop}
                            anchors.rightMargin: {return qm_tableHeaderMarginRight}
                            anchors.bottomMargin: {return qm_tableHeaderMarginBottom}
                            horizontalAlignment: {return qm_tableHeaderValueVarTextAlignmentHorizontal}
                            verticalAlignment: {return qm_tableHeaderValueVarTextAlignmentVertical}

                            text: theDataModel.getHeaderData(index)
                            color: {return qm_tableHeaderTextColor}

                            wrapMode: Text.WordWrap
                            elide: Text.ElideRight
                        }

                        Component.onCompleted: {
                            headerItem.updateHeader.connect(redrawHeaderData)
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        width: {return smartList.width}
        height: smartList.height
        color: "transparent"
        border.width: {return( (qm_hasBorder) ?  qm_BorderLineWidth : 0)}
        border.color: Qt.rgba((156/255), (157/255), (164/255), (255/255))
        enabled: false
        z: flickListView.z + 1
    }

    Flickable {
        id: flickListView

        x: {return qm_BorderLineWidth}
        y: {return qm_BorderLineWidth}
        width: {return smartList.width - (2 * qm_BorderLineWidth)}
        height: smartList.height - (2 * qm_BorderLineWidth)

        boundsBehavior: Flickable.StopAtBounds
        flickableDirection:  qm_hasVerticalScrollBar ? Flickable.HorizontalAndVerticalFlick : Flickable.HorizontalFlick
        maximumFlickVelocity: 0.1
        //pressDelay: 500 // Should work for press delay to smart list view

        contentY: smartlistview.flickContentY
        contentX: smartlistview.contentX
        contentHeight: {smartlistview.flickContentHeight- (2 * qm_BorderLineWidth)}
        contentWidth: {return totalColumnWidth - (2 * qm_BorderLineWidth)}

        onContentXChanged: {
            qm_scrollCtrl.positionSlider(qm_scrollCtrl.horizontalScrollObj, contentX)
            smartlistview.contentX = contentX // @brief Sometimes flick list view contentX alone has been adjusted seperately.
        }

        onContentYChanged: {
            if((smartList.scrollWithScrollBar !== true) || (contentY == originY))                
                qm_scrollCtrl.positionSlider(qm_scrollCtrl.verticalScrollObj, (contentY + (smartlistview.bufferStartOffset * qm_RowHeight)))            
        }

        IGuiSmartListView {
            id: smartlistview
            objectName: "mquListView"

            width: {return totalColumnWidth}
            height: smartList.height

            onBufferStartOffsetChanged: {
                if(smartList.scrollWithScrollBar !== true)
                    qm_scrollCtrl.positionSlider(qm_scrollCtrl.verticalScrollObj, (flickListView.contentY + (smartlistview.bufferStartOffset * qm_RowHeight)))
            }

            onScrollBarSizeChanged:{
                qm_scrollBarSize = smartlistview.scrollBarSize
                qm_scrollBarSliderSize = smartlistview.scrollBarSliderSize
                qm_scrollCtrl.createScrollComponent()
            }


            onTotalListContentHeightChanged: {                
                totalContentHeight = smartlistview.totalListContentHeight
                qm_scrollCtrl.resizeScrollComponent()

            }
           
            onTableHeaderHeightChanged:{
                resizeHeaderObj(0,true);
            }

            onTableRowHeightChanged:{
                qm_tableRowHeight = smartlistview.tableRowHeight;
                updateRowsFit(true);
            }
            
            rowHeight: qm_RowHeight
            tableRowHeight:qm_tableRowHeight
            tableHeaderHeight:qm_tableHeaderHeight
            linesPerRow: qm_linesPerRow
            rowBackColor: qm_tableBackColor
            altRowBackColor: {return qm_tableAlternateBackColor}
            selectBackColor: {return qm_tableSelectBackColor}
            rowTextColor: {return qm_tableTextColor}
            altRowTextColor: {return qm_tableAlternateTextColor}
            selectTextColor: {return qm_tableSelectTextColor}
            useRowSpecificColor : qm_UseRowSpecificColor
            tableFont: qm_tableFont
            selectFont: qm_tableSelectFont
            dataModel: theDataModel
            listControlObj: {return smartList}
            flickControlObj: {return flickListView}
            gridLineStyle: {return qm_gridLineStyle + 1}
            gridLineColor: {return qm_gridLineColor}
            gridLineWidth: {return smartList.gridLineWidth}
            focusLineWidth: {return qm_FocusLineWidth}
            borderLineWidth: {return qm_BorderLineWidth}
            contentStretched: {return qm_ContentStreached}
            contentTableMargin: {return [qm_tableMarginLeft, qm_tableMarginRight, qm_tableMarginTop, qm_tableMarginBottom]}
            columnOffset: {return adjustChildModel}
            contentY: flickListView.contentY
            visibleAreaWidth : flickListView.width

            MouseArea {
                width:  (flickListView.contentWidth > smartList.width) ? flickListView.contentWidth : smartList.width
                height: (flickListView.contentHeight > smartList.height) ? flickListView.contentHeight : smartList.height

                onWheel: {
                    //To ignore mouse wheel events
                }

                onClicked: {
                    ///Fix for RQ 1640356 check the difference of When mouse pressed and mouse clicked is less than 4
                    if((Math.abs((mouseYPress - mouseY)) <4))
                    {
                        var selectedIndex = getSelectedIndex(mouseX, mouseY)
                        utilProxy.lButtonClick(objRef, selectedIndex.x, selectedIndex.y)
                    }
                    mouseYPress = -1000
                }

                onPressed: {
                    mouseYPress = mouseY
                    var selectedIndex = getSelectedIndex(mouseX, mouseY)
                    utilProxy.lButtonDown(objRef, selectedIndex.x, selectedIndex.y)
                    setFocus ()
                }

                onReleased: {
                    var selectedIndex = getSelectedIndex(mouseX, mouseY)
                    utilProxy.lButtonUp(objRef, selectedIndex.x, selectedIndex.y)
                }

                onDoubleClicked: {
                    var selectedIndex = getSelectedIndex(mouseX, mouseY)
                    utilProxy.lButtonDblClick(objRef, selectedIndex.x, selectedIndex.y)
                }
            }

            Keys.onPressed: {
                utilProxy.keyHandler(objRef, event.key, true, event.text, event.isAutoRepeat)
                event.accepted = true
            }

            Keys.onReleased: {
                utilProxy.keyHandler(objRef, event.key, false, event.text, event.isAutoRepeat)
                event.accepted = true
            }

            Component.onDestruction: {
                if (headerObj != undefined)
                    headerObj.destroy()

                if(qm_scrollCtrl !== undefined)
                    qm_scrollCtrl.destroy()
            }
        }

        onMovementStarted: {
            smartlistview.flickEvent = true

            // Enable repositioning of scroll slider on smooth scrolling
            smartList.scrollWithScrollBar = false

            // Unload the loaded component, if scrolling has been started
            stopEditMode()

            qm_moveStartIndex = smartlistview.getIndexAt(flickListView.contentX, flickListView.contentY)
        }

        onMovementEnded: {
            smartlistview.flickEvent = false

            if(flickableDirection === Flickable.VerticalFlick)
            {
                // Before getting the displacement row count snap row
                smartlistview.snapListView(flickListView.contentY);

                // Get the proper index value after snapping the list view
                qm_moveEndIndex = smartlistview.getIndexAt(flickListView.contentX, flickListView.contentY)

                var nDisplacedRowCount = (qm_moveEndIndex.x - qm_moveStartIndex.x)

                if (0 !== nDisplacedRowCount) {
                    utilProxy.updateListData(smartList.objRef, nDisplacedRowCount)
                }
            }
            else
            {
                smartlistview.snapListViewColumn(flickListView.contentX);
            }

            flickableDirection = qm_hasVerticalScrollBar ? Flickable.HorizontalAndVerticalFlick : Flickable.HorizontalFlick
        }

        onMovingHorizontallyChanged: {
            flickableDirection = Flickable.HorizontalFlick
        }

        onMovingVerticallyChanged: {
            flickableDirection = Flickable.VerticalFlick
        }
    }
}
