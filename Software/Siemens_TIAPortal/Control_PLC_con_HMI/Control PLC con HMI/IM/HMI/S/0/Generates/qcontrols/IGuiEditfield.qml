import QtQuick 2.0
Rectangle
{
    id: qEditField

    property int qm_EditFieldObjid: 0
    property int qm_EditFieldBorderWidth: 1
    property int qm_EditFieldMarginLeft: 1
    property int qm_EditFieldMarginTop: 1
    property bool qm_EditFieldPasswordMode: false
    property color qm_EditFieldTextColor: "#000000"
    property int qm_EditFieldTextAlignmentHorizontal : Text.AlignLeft
    property int qm_EditFieldTextAlignmentVertical : Text.AlignTop
    property string qm_EditFieldText : ""
    property bool qm_IsCursorPosChangedAfterClick: false
    property bool qm_IsRemoteClientActive: false

    signal editModeOff();

    function handleParentData (parentData)
    {
         qm_EditFieldText = parentData
    }

    TextInput
    {
        id: qEditFieldTextInput
        objectName: "qEditFieldTextInput"

        property int currentCursorPosition: qEditFieldTextInput.text.length

        x: qm_EditFieldMarginLeft + qm_EditFieldBorderWidth
        y: qm_EditFieldMarginTop + qm_EditFieldBorderWidth
        height: parent.height - (qm_EditFieldMarginTop + qm_EditFieldBorderWidth)
        width: parent.width - (qm_EditFieldMarginTop + qm_EditFieldBorderWidth)
        color: qm_EditFieldTextColor
        clip: true

        text: qm_EditFieldText
        font: qm_Font
		renderType: Text.NativeRendering
        passwordCharacter: "*"
        echoMode: (qm_EditFieldPasswordMode) ? TextInput.Password : TextInput.Normal
        cursorVisible: false
        horizontalAlignment: qm_EditFieldTextAlignmentHorizontal
        verticalAlignment: qm_EditFieldTextAlignmentVertical

        onCursorPositionChanged: {
            if(qm_IsCursorPosChangedAfterClick)
            {
                qm_IsCursorPosChangedAfterClick = false
                utilProxy.cursorPositionChanged(qm_EditFieldObjid, qEditFieldTextInput.cursorPosition)
                if(qEditFieldTextInput.cursorPosition == 0)
                    qEditFieldTextInput.select(qEditFieldTextInput.cursorPosition,qEditFieldTextInput.cursorPosition+1)
                else
                    qEditFieldTextInput.select(qEditFieldTextInput.cursorPosition-1,qEditFieldTextInput.cursorPosition)
            }
        }

        function init(objectIdentifier)
        {
           qm_EditFieldObjid = objectIdentifier
           qEditFieldTextInput.select(currentCursorPosition-1,currentCursorPosition)
        }

        function setValue(value)
        {
           qm_IsCursorPosChangedAfterClick = false
           qm_EditFieldText = value
        }

        function setFocus()
        {
            qEditFieldTextInput.forceActiveFocus()
            qEditFieldTextInput.focus = true
        }

        function doStopEditMode()
        {
            qEditField.editModeOff();
        }

        function setSmartClientStatus(value)
        {
            qm_IsRemoteClientActive = value
        }

        function setCursorValue(value)
        {
            qm_IsCursorPosChangedAfterClick = false
            currentCursorPosition = value
            qEditFieldTextInput.cursorPosition = currentCursorPosition
            qEditFieldTextInput.select(currentCursorPosition,currentCursorPosition+1)
        }


        MouseArea
        {
            id: mouseArea
            anchors.fill: parent
            onPressed: {
                utilProxy.lButtonDown(qm_EditFieldObjid, mouse.x, mouse.y)                
                if (qm_IsRemoteClientActive && (qEditFieldTextInput.positionAt(mouse.x, mouse.y, 0) > 0)) {
                    qEditFieldTextInput.cursorPosition = 0
                    mouse.accepted = false
                    qm_IsCursorPosChangedAfterClick = true
                }
                else {
                    mouse.accepted = true
                }
            }
            onReleased: {
                if(containsMouse)
                {
                    utilProxy.lButtonUp(qm_EditFieldObjid, mouse.x, mouse.y)
                    if ((qm_IsRemoteClientActive) && (qEditFieldTextInput.positionAt(mouse.x, mouse.y, 0) > 0)) {
                        mouse.accepted = false
                    }
                    else {
                        mouse.accepted = true
                    }
                }
            }
            onPositionChanged: {
                 utilProxy.handleMouseMove(qm_EditFieldObjid, mouse.x, mouse.y)
                mouse.accepted = true
            }
        }

        Keys.onPressed:
        {
            var isCtrlPressed = (event.modifiers & Qt.ControlModifier)
            var isAltPressed = (event.modifiers & Qt.AltModifier)
            utilProxy.keyHandler(qm_EditFieldObjid, event.key, true, event.text,event.isAutoRepeat, isCtrlPressed, isAltPressed);
            event.accepted = true;
        }

        Keys.onReleased:
        {
            utilProxy.keyHandler(qm_EditFieldObjid, event.key, false, event.text, event.isAutoRepeat);
            event.accepted = true;
        }
    }

    Component.onCompleted:
    {
        qEditFieldTextInput.setFocus()
    }
}
