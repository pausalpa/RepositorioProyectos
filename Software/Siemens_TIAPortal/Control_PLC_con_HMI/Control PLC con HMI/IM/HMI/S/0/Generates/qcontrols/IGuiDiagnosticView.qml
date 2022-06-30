import QtQuick 2.0

IGuiViewBitmap {
    id: qmDiagnosticView

    property string listObjName: {return "qu" + objId}

    //TODO: Check with es2rt as header for diagnostic view will be removed
    property color qm_headerTextColor: "#ff000000"
    property color qm_headerBackColor: "#ababab"
    property int qm_headerValueVarTextAlignmentHorizontal: Text.AlignLeft
    property int qm_headerValueVarTextAlignmentVertical: Text.AlignVCenter
    property int qm_headerValueVarTextOrientation: 0
    property int qm_headerMarginLeft: 0
    property int qm_headerMarginRight: 0
    property int qm_headerMarginBottom: 0
    property int qm_headerMarginTop: 0

    property int qm_headerTextPosX: 0
    property int qm_headerTextPosY: 0
    property int qm_headerTextWidth: 0
    property int qm_headerTextHeight: 0

    property int qm_diagViewToolbarPosX: 0
    property int qm_diagViewToolbarPosY: 0
    property int qm_diagViewToolbarWidth: 576
    property int qm_diagViewToolbarHeight: 30
    property color qm_toolBarBackColor: "transparent"    
    property real qm_diagViewCornerRadius: 0

    property variant pageObj: undefined

    property list<Component> qm_DiagnosticListComponent   

    function setHeaderTextParam(xpos, ypos, textWidth, textHeight)
    {
        headerRect.x = xpos;
        headerRect.y = ypos;
        headerRect.width = textWidth;
        headerRect.height = textHeight;

        if (undefined != pageObj)
            pageObj.resizeListControlData(headerRect.y + headerRect.height)
    }
    clip: true

    Rectangle {
        x: {return qm_diagViewToolbarPosX}
        y: {return qm_diagViewToolbarPosY}
        width: {return qm_diagViewToolbarWidth}
        height: {return qm_diagViewToolbarHeight}
        color: {return qm_toolBarBackColor}
    }

    Rectangle {
        id: headerRect

        x: {return qm_headerTextPosX}
        y: {return qm_headerTextPosY}
        width: {return qm_headerTextWidth}
        height: {return qm_headerTextHeight}
        color: {return qm_headerBackColor}
        radius: {return qm_diagViewCornerRadius}

        Text {
            id: headerText

            anchors.fill: parent
            text:qm_DisplayText
            color: {return qm_headerTextColor}
            horizontalAlignment: {return qm_headerValueVarTextAlignmentHorizontal}
            verticalAlignment: {return qm_headerValueVarTextAlignmentVertical}
            anchors.leftMargin: {return qm_headerMarginLeft}
            anchors.topMargin: {return qm_headerMarginTop}
            anchors.rightMargin: {return qm_headerMarginRight}
            anchors.bottomMargin: {return qm_headerMarginBottom}
            elide: Text.ElideRight
            wrapMode: Text.WordWrap
            font: qm_Font
			renderType: Text.NativeRendering
        }
    }

    function loadConfigurationPage (pageType) {
        pageObj = qm_DiagnosticListComponent[pageType].createObject(qmDiagnosticView,
                                                                    {
                                                                        "objectName": listObjName,
                                                                        "enabled": qm_Selectable
                                                                    }
                                                                     )
    }

    function unloadConfigurationPage () {     
        if ((pageObj !== undefined) && (pageObj !== null)) {
            if (pageObj.objectName !== undefined) {
                pageObj.objectName = ""
            }
            pageObj.visible = false
            pageObj.enabled = false
            pageObj.destroy()
        }
    }
}
