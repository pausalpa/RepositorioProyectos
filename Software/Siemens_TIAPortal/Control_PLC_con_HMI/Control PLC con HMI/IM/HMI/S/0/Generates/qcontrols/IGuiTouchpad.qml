import QtQuick 2.0

Item{
    id:qTouchpad
    objectName: "qtouchpad"

    //Initializer Properties
    property string qm_TouchpadInputQml:""
    property int qm_TouchPadXposition: 0
    property int qm_TouchPadYposition: 0
    property int qm_TouchPadHeight: 0
    property int qm_TouchPadWidth: 0
    property int qm_TouchPadType:0
    property color qm_TouchPadcolor:"transparent"
    property color qm_TouchPadBorderColor:"transparent"
    property color qm_TextColor:"transparent"
    property int  qm_TextVAlign:0
    property int  qm_TextHAlign:0
    property int qm_TextMarginLeft:0
    property int qm_TextMarginRight:0
    property int qm_TextMarginTop:0
    property int qm_TextMarginBottom:0
    property font qm_Font
    property int qm_TextRowHeight: 0    
    property int qm_NoOfVisibleRows:4
    property color qm_ListCtrlSelBackColor:"transparent"
    property color qm_ListCtrlSelForeColor:"transparent"
    property color qm_ListCtrlAlternateRowColor:"transparent"

    property bool qm_Streached : false

    //Internal properties
    property int qm_ObjId: 0
    property variant staticComponent: undefined
    property variant staticComponentObj: undefined

    property variant qm_HostComponentObj: undefined
    property bool qm_hasScrollIndicator: false

    function init(refID)
    {
        qm_ObjId = refID
        staticComponent = Qt.createComponent(qm_TouchpadInputQml)

        if(qm_TouchPadType === 6)
        {
            staticComponentObj = staticComponent.createObject(qTouchpad,
                                                          {
                                                              "x":qm_TouchPadXposition,
                                                              "y":qm_TouchPadYposition,
                                                              "width":qm_TouchPadWidth,
                                                              "height":qm_TouchPadHeight,
                                                              "qm_ImageVAlign":qm_TextVAlign,
                                                              "qm_ImageHAlign":qm_TextHAlign,
                                                              "qm_ImageMarginLeft":qm_TextMarginLeft,
                                                              "qm_ImageMarginRight":qm_TextMarginRight,
                                                              "qm_ImageMarginTop":qm_TextMarginTop,
                                                              "qm_ImageMarginBottom":qm_TextMarginBottom,
                                                              "qm_Streached":qm_Streached,
                                                              "qm_hasScrollIndicator": qm_hasScrollIndicator
                                                          })
          
        }

        if(qm_TouchPadType === 1)
        {
            qTouchpad.z = 255
            staticComponentObj = staticComponent.createObject(qTouchpad,
                                                          {
                                                              "x":qm_TouchPadXposition,
                                                              "y":qm_TouchPadYposition,
                                                              "width":qm_TouchPadWidth,
                                                              "qm_listCtrlHeight":qm_TouchPadHeight,
                                                              "color":qm_TouchPadcolor,
                                                              "border.color":qm_TouchPadBorderColor,
                                                              "qm_TextColor":qm_TextColor,
                                                              "qm_TextVAlign":qm_TextVAlign,
                                                              "qm_TextHAlign":qm_TextHAlign,
                                                              "qm_TextMarginLeft":qm_TextMarginLeft,
                                                              "qm_TextMarginRight":qm_TextMarginRight,
                                                              "qm_TextMarginTop":qm_TextMarginTop,
                                                              "qm_TextMarginBottom":qm_TextMarginBottom,
                                                              "qm_TextRowHeight":qm_TextRowHeight,
                                                              "qm_Font":qm_Font,
                                                              "qm_NoOfVisibleRows":qm_NoOfVisibleRows,
                                                              "qm_ListCtrlSelBackColor":qm_ListCtrlSelBackColor,
                                                              "qm_ListCtrlSelForeColor":qm_ListCtrlSelForeColor,
                                                              "qm_ListCtrlAlternateRowColor":qm_ListCtrlAlternateRowColor,
                                                              "qm_hasScrollIndicator": qm_hasScrollIndicator
                                                             })
          }
    }


    function doStopEditMode()
    {
        if(staticComponentObj !== undefined)
        {
            staticComponentObj.changeObjNameListCtl()
            staticComponentObj.objectName = ""
            qTouchpad.z = 0
            staticComponentObj.destroy()
            staticComponentObj = undefined
        }

        if(staticComponent !== undefined)
        {
            staticComponent.destroy()
            staticComponent = undefined
        }

        if (qm_HostComponentObj !== undefined)
            qm_HostComponentObj.doStopEditMode()

    }
}



