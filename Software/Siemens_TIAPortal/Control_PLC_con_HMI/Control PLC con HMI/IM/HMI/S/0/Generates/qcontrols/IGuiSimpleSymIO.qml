import QtQuick 2.0
import SmartSymIOComponent 1.0
Rectangle
{
    id:qSimpleSymIO

    property int qm_objID : 0
    property string qm_DisplayText:"ABC"
    objectName: "qSimpleSymioObj"
    border.color:"black"
    property int qm_NoOfVisibleRows:3

    ///@brief data for  touchpad component and object
    property variant staticTouchComponent: undefined
    property variant staticTouchComponentObj: undefined

    ///@brief List Control properties
    property color qm_ListCtrlSelBackColor
    property color qm_ListCtrlSelForeColor
    property color qm_ListCtrlAlternateRowColor
    property color qm_ListCtrlRowColor
    property int qm_listHeight:0
    
    /// @brief text color
    property color qm_TextColor

    /// @brief horizontal alignment
    property int qm_ValueVarTextAlignmentHorizontal: Text.AlignLeft
    /// @brief vertical alignment
    property int qm_ValueVarTextAlignmentVertical: Text.AlignVCenter
    /// @brief text margin left
    property int qm_MarginLeft: 2
    /// @brief text margin right
    property int qm_MarginRight: 2
    /// @brief text margin top
    property int qm_MarginTop: 2
    /// @brief text margin bottom
    property int qm_MarginBottom:2
    /// @brief: To store the font
    property font qm_Font
    /// @brief data for background color
    property color qm_FillColor : "white"    
    /// @brief Image ID for sym IO
    property string qm_SymIOImagePath : "pics/Down.png"
    property int qm_touchpadY: 0
    property int qm_pageHeight : 0
    property int qm_viewYPosition: 0
    property int qm_listCtrlPosition : 0
    property bool qm_hasScrollIndicator: false

    signal editModeOff();
    function init(objid)
    {
       qSimpleSymIO.qm_objID = objid
       qSimpleSymIO.color = qSimpleSymIO.qm_ListCtrlSelBackColor
	   qDisplayText.color = qSimpleSymIO.qm_ListCtrlSelForeColor
    }

    function setFocus()
    {
        qSimpleSymIO.forceActiveFocus()
        qSimpleSymIO.focus = true
    }

    function handleParentData(symIOData)
    {
        qm_DisplayText = symIOData
    }

    onQm_FillColorChanged: {
        qSimpleSymIO.color = qm_FillColor
    }

    onQm_TextColorChanged: {
        qDisplayText.color = qm_TextColor;
    }

    /// load edit field QML
    function startEditMode(editFieldRef,editFieldValue, editFieldType, passwordMode, highlightText)
    {
        qSimpleSymIO.z = 256
        staticTouchComponent = Qt.createComponent("IGuiTouchpad.qml")
        qSmartSymio.calculateListControlheight();
        qSmartSymio.calculateAndSetTouchpadPositionY();
        staticTouchComponentObj = staticTouchComponent.createObject(qSmartSymio.qm_TouchpadParent,
                                                                    {
                                                                        "qm_TouchpadInputQml":"IGuiSymioListEdit.qml",
                                                                        "qm_TouchPadXposition":qSmartSymio.qm_touchpadX,
                                                                        "qm_TouchPadYposition":qSmartSymio.qm_touchpadY,
                                                                        "qm_TouchPadType":editFieldType,
                                                                        "qm_TouchPadWidth": qSimpleSymIO.width,
                                                                        "qm_TouchPadHeight":qSmartSymio.qm_listHeight,
                                                                        "qm_TouchPadcolor": qSimpleSymIO.qm_ListCtrlRowColor,
                                                                        "qm_TouchPadBorderColor":qSimpleSymIO.border.color,
                                                                        "qm_TextColor":qSimpleSymIO.qm_TextColor,
                                                                        "qm_TextVAlign":qSimpleSymIO.qm_ValueVarTextAlignmentVertical,
                                                                        "qm_TextHAlign":qSimpleSymIO.qm_ValueVarTextAlignmentHorizontal,
                                                                        "qm_TextMarginLeft":qSimpleSymIO.qm_MarginLeft,
                                                                        "qm_TextMarginRight":qSimpleSymIO.qm_MarginRight,
                                                                        "qm_TextMarginTop":qSimpleSymIO.qm_MarginTop,
                                                                        "qm_TextMarginBottom":qSimpleSymIO.qm_MarginBottom,
                                                                        "qm_TextRowHeight":qSmartSymio.qm_tableRowHeight,
                                                                        "qm_Font":qSimpleSymIO.qm_Font,
                                                                        "qm_NoOfVisibleRows":qSmartSymio.qm_NoOfVisibleRows,
                                                                        "qm_ListCtrlSelBackColor":qSimpleSymIO.qm_ListCtrlSelBackColor,
                                                                        "qm_ListCtrlSelForeColor":qSimpleSymIO.qm_ListCtrlSelForeColor,
                                                                        "qm_ListCtrlAlternateRowColor":qSimpleSymIO.qm_ListCtrlAlternateRowColor,
                                                                        "qm_hasScrollIndicator": qm_hasScrollIndicator
                                                                    })
        qDisplayText.color = qm_TextColor;
        qSimpleSymIO.color = qm_FillColor;
    }

    IGuiSmartSymIO{
        id:qSmartSymio
        parent:qSimpleSymIO
        qm_Font:qSimpleSymIO.qm_Font
        qm_NoOfVisibleRows:qSimpleSymIO.qm_NoOfVisibleRows
        qm_NoOfVisibleEntries:qSimpleSymIO.qm_NoOfVisibleRows
        qm_NoOfSymIoTextListItems:qSimpleSymIO.qm_NoOfVisibleRows
        qm_MarginTop:{return qSimpleSymIO.qm_MarginTop}
        qm_MarginBottom: {return qSimpleSymIO.qm_MarginBottom}
        qm_SymioHeight:{ return qSimpleSymIO.height}
    }

    /// unload edit field QML
    function doStopEditMode()
    {
        qSimpleSymIO.z = 0

        if(staticTouchComponentObj !== undefined)
        {
            staticTouchComponentObj.doStopEditMode()
            staticTouchComponentObj.objectName = ""
            staticTouchComponentObj.destroy ()
            staticTouchComponentObj = undefined
            staticTouchComponent.destroy()
            staticTouchComponent = undefined
        }
        qSimpleSymIO.forceActiveFocus()
        qSimpleSymIO.editModeOff()
    }

    //Function to unload simple symio
    function doStopSimpleSymIO()
    {
        qSimpleSymIO.z = 0

        if(staticTouchComponentObj !== undefined)
        {
            staticTouchComponentObj.doStopEditMode()
            staticTouchComponentObj.objectName = ""
            staticTouchComponentObj.destroy ()
            staticTouchComponentObj = undefined
            staticTouchComponent.destroy()
            staticTouchComponent = undefined
        }
        qSimpleSymIO.forceActiveFocus()
        qDisplayText.color = qm_ListCtrlSelForeColor;
        qSimpleSymIO.color = qm_ListCtrlSelBackColor;
    }

    ///Function to set the Value of the text
    function setValue(text)
    {
        qm_DisplayText = text;
    }

    Rectangle
    {
        id:qDownButtonRect
        x: {return (0.8 * qSimpleSymIO.width)}
        height:{return qSimpleSymIO.height}
        width:{ return (qSimpleSymIO.width) - (0.8 * qSimpleSymIO.width)}
        color:"transparent"
        border.color: "transparent"

        Image
        {
            id:qDownArrowImage
            source: qm_SymIOImagePath
            anchors.centerIn: qDownButtonRect
            smooth:false
        }

        MouseArea{
            anchors.fill: qDownButtonRect
            onPressed: {
                utilProxy.lButtonDown(qm_objID, mouse.x, mouse.y);
                mouse.accepted = true;
            }
            onReleased: {
                if(containsMouse)
                {
                    utilProxy.lButtonDown(qm_objID, mouse.x, mouse.y);
                }
                mouse.accepted = true;
            }
        }
    }

    TextInput
    {
        id:qDisplayText
        height:{ return qSimpleSymIO.height}
        width:{ return (0.8 * qSimpleSymIO.width)}
        text:qm_DisplayText

        color: qSimpleSymIO.qm_TextColor
        anchors.bottomMargin: {return qSimpleSymIO.qm_MarginBottom + qSimpleSymIO.qm_BorderWidth}
        anchors.leftMargin: {return qSimpleSymIO.qm_MarginLeft + qSimpleSymIO.qm_BorderWidth}
        anchors.rightMargin: {return qSimpleSymIO.qm_MarginRight + qSimpleSymIO.qm_BorderWidth}
        anchors.topMargin: {return qSimpleSymIO.qm_MarginTop + qSimpleSymIO.qm_BorderWidth}
        horizontalAlignment: {return qSimpleSymIO.qm_ValueVarTextAlignmentHorizontal}
        verticalAlignment: {return qSimpleSymIO.qm_ValueVarTextAlignmentVertical}
        font: qm_Font
		renderType: Text.NativeRendering
        cursorVisible: false
        clip:true
        readOnly: true        
        autoScroll: false
    }
    MouseArea
    {
        anchors.fill: parent
        onPressed: {
            utilProxy.lButtonDown(qm_objID, mouse.x, mouse.y);
            mouse.accepted = true;
        }
        onReleased: {
            if(containsMouse)
            {
                utilProxy.lButtonUp(qm_objID, mouse.x, mouse.y);
            }
            mouse.accepted = true;
        }
    }
    Keys.onPressed:
    {
        utilProxy.keyHandler(qm_objID, event.key, true, event.text, event.isAutoRepeat);
        event.accepted = true;
    }

    Keys.onReleased:
    {
        utilProxy.keyHandler(qm_objID, event.key, false, event.text, event.isAutoRepeat);
        event.accepted = true;
    }
    Component.onCompleted: {
      qSimpleSymIO.forceActiveFocus();        
    }
}
