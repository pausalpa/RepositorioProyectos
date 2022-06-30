import QtQuick 2.0
import SmartWidget 2.0
//import SmartScale 2.0

IGuiViewBitmap
{
    id:qIGuiTrendView
    clip: true
    property string rulerColor: "#000000"
    property int qm_TrendXPos: 0
    property int qm_TrendYPos: 0
    property int qm_TrendWidth: 0
    property int qm_TrendHeight: 0
    property bool rulerVisibility: false


    // Trend Vertical Scale
    IGuiTrendScale
    {
        id:trendVerticalRScale
        color: trendArea.m_TrendForeGrndColor
        isHorizontalScale : false
        isVerticalRightScale: true
        width: {return parent.width}
        height: {return parent.height}
        pViewID: {return objId}
    }
    IGuiTrendScale
    {
        id:trendVerticalLScale
        color: trendArea.m_TrendForeGrndColor
        isHorizontalScale : false
        isVerticalRightScale: false
        width: {return parent.width}
        height: {return parent.height}
        pViewID: {return objId}
    }

    // Trend Horizontal Scale
    IGuiTrendScale
    {
        id:trendHorizontalScale
        color: trendArea.m_TrendForeGrndColor
        isHorizontalScale: true
        width: {return parent.width}
        height: {return parent.height}
        pViewID: {return objId}
    }
    //Trend Area
    IGuiTrendArea
    {
        id: trendArea
        pViewID: {return objId}
        //set Default Values will be changed in The Qt Code
        x: {return qm_TrendXPos}
        y:{return qm_TrendYPos}
        width: {return qm_TrendWidth}
        height: {return qm_TrendHeight;}
        objectName: "trendArea"
        isRulerVisible: rulerVisibility
        m_ptrendVerticalRScale: {return trendVerticalRScale}
        m_ptrendVerticalLScale: {return trendVerticalLScale}
        m_ptrendHorizontalScale: {return trendHorizontalScale}

    }
    Rectangle{
        id: trendRuler
        x: trendArea.RulerPosition
        y: {return qm_TrendYPos}
        height: trendArea.TrendHeight
        visible: trendArea.isRulerVisible
        width: 1
        color: rulerColor
    }
    /* Un-Commented it for Test Mouse Click Position in Trend Area*/
//    Text {
//        id: debugMouseClick
//        x:0;
//        y: parent.height - 20
//        text: qsTr("x = " + trendViewMouseArea.mouseX + " y = " + trendViewMouseArea.mouseY)
//    }

}
