// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 2.0

IGuiView{

    id: qPictogram

    // Pictogram properties

    visible: false

    property int pictogram_imageid

    // for loading pictogram image
    Image
    {
        source: "image://QSmartImageProvider/" + 
                                       pictogram_imageid    + "#" +        // image id
                                       1                    + "#" +        // streaching info
                                       4                    + "#" +        // horizontal alignment info
                                       128                  + "#" +        // vertical alignment info
                                       qm_LanguageIndex     + "#" +        // language index
                                       0                                   // cache info
        anchors.fill: parent
        smooth:false
        sourceSize.width: {return qPictogram.width}
        sourceSize.height: {return qPictogram.height}
    }
    MouseArea
    {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }
}




