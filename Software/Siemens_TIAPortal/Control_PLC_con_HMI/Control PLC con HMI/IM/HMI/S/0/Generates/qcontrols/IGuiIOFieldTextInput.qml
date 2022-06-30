
import QtQuick 2.0

TextInput
{
    id:qTextInput
    height: {return qText.height}
    width : {return qText.width}
    x: {return qText.x}
    y : {return qText.y}
    font: qm_Font
	renderType: Text.NativeRendering
    horizontalAlignment: {return qText.horizontalAlignment}
    verticalAlignment: {return qText.verticalAlignment}
    antialiasing : true


    cursorVisible:  false
    clip:true
    readOnly: true
    autoScroll: false

    MouseArea
    {
        id: mouseArea
        anchors.fill: parent

        onPressed: {
            proxy.lButtonDown(qIOFieldView.objId, mouse.x, mouse.y)
            mouse.accepted = true
        }

        onReleased: {
            if(containsMouse)
            {
                proxy.lButtonUp(qIOFieldView.objId, mouse.x, mouse.y)
                mouse.accepted = true
            }
        }
    }

    Component.onCompleted:
    {
        qTextInput.selectAll();
    }

    onDisplayTextChanged:
    {
        qTextInput.selectAll();
    }
}
