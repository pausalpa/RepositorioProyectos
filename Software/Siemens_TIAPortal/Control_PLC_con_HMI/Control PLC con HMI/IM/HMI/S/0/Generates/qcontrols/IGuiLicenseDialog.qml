import QtQuick 2.0
Rectangle
{
        id: licenseDialog
        property Style style : Style { }
        property string screenHeight: licensedialogcontext.getScreenHeight();
        property string screenWidth: licensedialogcontext.getScreenWidth();
        property string orientation: licensedialogcontext.getLayoutMode();
        property int licenseDialogHeight:style.licenseDialogHeight
        property int licenseDialogWidth:style.licenseDialogWidth
        x:(screenWidth-licenseDialogWidth)/2
        y:(screenHeight-licenseDialogHeight)/2
        width: licenseDialogWidth
        height: licenseDialogHeight
        border.color:style.qTitlebarcolor
        border.width: 1
        z:240
        IGuiModality{
            x: -5000
            y: -5000
            width: 12800
            height: 12800
        }
        rotation:orientation=="landscape"?0:90
        MouseArea
        {
           anchors.fill: licenseDialog
           drag.target: licenseDialog
           drag.axis: Drag.XAndYAxis
           drag.minimumX: orientation=="landscape"?0:-35
           drag.minimumY: orientation=="landscape"?0:35
           drag.maximumX: orientation=="landscape"?screenWidth-licenseDialogWidth:screenWidth-licenseDialogHeight-35
           drag.maximumY: orientation=="landscape"?screenHeight-licenseDialogHeight:screenHeight-licenseDialogWidth+35
        }
        Rectangle
        {
           x: 0
           y: 0
           width: licenseDialogWidth
           height: style.licenseDialogHeaderFooter
           color: style.qTitlebarcolor
           Text
           {
               id: dialogTitle
               x:10
               y:10
               text: licensedialogcontext.getDialogTitle()
               font.family:style.textInputFontFamily
               font.pixelSize:14//style.licensedialogFontSize
               color:"#ffffff"
           }
        }
        Text
        {
            id: licenseDialogMessage
            x:10
            width: parent.licenseDialogWidth-15
            height:parent.licenseDialogHeight
            text: licensedialogcontext.getLicenseMessage()
            font.family:style.textInputFontFamily
            font.pixelSize:14//style.licensedialogFontSize
            color: style.textInputTextColor
            horizontalAlignment: Text.AlignJustify
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap

        }

        Rectangle
        {
           x: 0
           y: 165
           width: licenseDialogWidth
           height: style.licenseDialogHeaderFooter
           color: style.qTitlebarcolor
           Button
           {
              id:notedbutton
              text: licensedialogcontext.getButtonText()
              fontsize: 10
              height: 35
              width: 70
              x:104
              y:0
              focus: true	
              onClicked: licensedialogcontext.closeDialog();
              onFocusChanged: {
                forceActiveFocus()
              }  
              Keys.onPressed: {
                if ((Qt.Key_Return == event.key) || (Qt.Key_Enter == event.key))
                    licensedialogcontext.triggerCloseDialog()
              }
           }
        }
}

