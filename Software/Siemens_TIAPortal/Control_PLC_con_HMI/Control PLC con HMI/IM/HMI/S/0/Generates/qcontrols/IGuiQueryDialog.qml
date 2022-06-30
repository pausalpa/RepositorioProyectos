import QtQuick 2.0
Rectangle
{
        id: queryDialog
        objectName: "queryDialog"
        
        property string clientIP: ""
        property var clientAddress:0;
        property Style style : Style { }
        property string screenHeight: querydialogcontext.getScreenHeight();
        property string screenWidth: querydialogcontext.getScreenWidth();
        property string orientation: querydialogcontext.getLayoutMode();
        property int queryDialogHeight:style.queryDialogHeight
        property int queryDialogWidth:style.queryDialogWidth
        property int queryTimeout: querydialogcontext.getQueryTimeout();
        property string defaultAction: querydialogcontext.getDefaultAction();
        property var lastFocusItem: list_view

        x:(screenWidth-queryDialogWidth)/2
        y:(screenHeight-queryDialogHeight)/2
        width: queryDialogWidth
        height: queryDialogHeight
        border.color:style.qTitlebarcolor
        border.width: 1
        z:239

        Component.onCompleted:
        m1.clear();

        function addClientData(ipaddress, action, queryTime, value,claddr)
        {
           m1.append({IP:ipaddress,Action: action, time:queryTime, RemoveQuery:value, clAddress:claddr});
        }
        IGuiModality{
            x: -5000
            y: -5000
            width: 12800
            height: 12800
        }
        rotation:orientation=="landscape"?0:90
        MouseArea
        {
           anchors.fill: queryDialog
           drag.target: queryDialog
           drag.axis: Drag.XAndYAxis
           drag.minimumX: orientation=="landscape"?0:-35
           drag.minimumY: orientation=="landscape"?0:35
           drag.maximumX: orientation=="landscape"?screenWidth-queryDialogWidth:screenWidth-queryDialogHeight-35
           drag.maximumY: orientation=="landscape"?screenHeight-queryDialogHeight:screenHeight-queryDialogWidth+35
        }
        Rectangle
        {
           id: queryHeader
           x: 0
           y: 0
           width: queryDialogWidth
           height: style.queryDialogHeaderHeight
           color: style.qTitlebarcolor
           Text
           {
               id: dialogTitle
               x:10
               y:10
               text: "Accept Sm@rtClient Connection?"
               font.family:style.textInputFontFamily
               font.pixelSize:12
               color:"#ffffff"
           }
        }
        Component
        {
            id: queryDelegate
            Item
            {
                id: queryDelegateItem
                width: list_view.width; 
                height: style.queryDelegateHeight
                function updateTime()
                {
                	m1.setProperty(index,"time",(m1.get(index).time)-1);
            		if (0 === parseInt(m1.get(index).time))
                    	{
                      		querydialogcontext.queryTimeout(m1.get(index).clAddress);
                       		list_view.removeQuery(index);
                        }
                }
                function queryProcessed(nIndex)
                {
                    if((nIndex === index) && (list_view.removeFlag === 0))
                    {
                    	if(index !== (list_view.count -1))
                            list_view.removeFlag = 1;
                        list_view.removeProcessedQuery(index);
                    }
                    if(index === (list_view.count -1))
                    {
                        list_view.removeFlag = 0;
                    }
                }

                Column
                {
                    width:list_view.width
                    Text
                    {
                      anchors
                        {
                            left:parent.left
                            right:parent.right
                        }
                        anchors.leftMargin: 5
                        anchors.rightMargin: 5
                        clip: true
                        text: "Sm@rtServer has received an incoming"
                        font.family:style.textInputFontFamily
                        font.pixelSize:12
                        color: style.textInputTextColor
                    }
                    Text
                    {
                        anchors
                        {
                            left:parent.left
                            right:parent.right
                        }
                        anchors.leftMargin: 5
                        anchors.rightMargin: 5
                        clip: true
                        text: "connection from " + IP
                        font.family:style.textInputFontFamily
                        font.pixelSize:12
                        color: style.textInputTextColor
                    }
                    Text
                    {
                        anchors
                        {
                          left:parent.left
                          right:parent.right
                        }
                        anchors.leftMargin: 5
                        anchors.rightMargin: 5
                        //width: list_view.width
                        clip:true
                        text: Action + " " + time
                        font.family: style.textInputFontFamily
                        font.pixelSize:12
                        color: style.textInputTextColor
                        horizontalAlignment: Text.AlignRight
                    }
                }
                Component.onCompleted:
                {
                   btnRect.buttonPressed.connect(queryProcessed);
                   queryTimer.triggered.connect(updateTime);
                }
            }
        }

        Rectangle
        {
            id:rect_listview
            x:0
            y:34
            width: parent.queryDialogWidth
            height:122
            border.color: style.qTitlebarcolor
            clip: true
            ListView
            {
                id: list_view
                anchors.fill:parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                anchors.topMargin: 5
                focus: true
                model: m1
                delegate:queryDelegate
                clip: true

                onFocusChanged: 
                {
                     if (false == querydialogcontext.isLicenseDialogExists())
                        {
                         	list_view.forceActiveFocus();
                        }
                }
                property int removeFlag:0
                property int listIndex:0
                function removeProcessedQuery(curIndex)
                {
                   m1.remove(curIndex);
                    checkandCloseQueryDialog();
                }
                function removeQuery(nIndex)
                {
                    m1.remove(nIndex);
                    checkandCloseQueryDialog();
                }
                function checkandCloseQueryDialog()
                {
                    if((0 === list_view.count) || (-1 === list_view.currentIndex))
                    {
                        queryTimer.running = false;
                        list_view.focus = false;
                        querydialogcontext.closeQueryDialog();
                    }
                }
                MouseArea
                {
                    anchors.fill:parent
                    onClicked:
                    {
                        list_view.focus = true;
                        list_view.listIndex = parseInt((mouseY + list_view.contentY)/style.queryDelegateHeight);
                        if(list_view.listIndex < list_view.count)
                        {
                            list_view.currentIndex = list_view.listIndex;
                        }
                    }
                }
                highlight: Rectangle
                {
                    color: style.queryHighlightColor; radius: 3
                }

                Timer
                {
                    id: queryTimer
                    interval:1000;
                    running: false;
                    repeat:true;
                    property int index;
                }
                ListModel
                {
                    id: m1
                    ListElement
                    {
                        IP: ""
                        Action: ""
                        time: 120
                        RemoveQuery: 0
                        clAddress: 0
                    }
                }
            }
        }

        Rectangle
        {
            id: btnRect
            x: 0
            y: 156
            width: queryDialogWidth
            height: 44
            color: style.qTitlebarcolor
            signal buttonPressed(int curIndex)

           Button
           {
               id:accept_button
               x:5
               y:5
               height:style.queryButtonHeight
               width:75

               text: "Accept"

               backgroundImagePath: "pics/Kb_Space_normal.png"
               fontsize: style.queryButtonFontSize
               onClicked:
               {
                   querydialogcontext.acceptClient(m1.get(list_view.currentIndex).clAddress);
                   btnRect.buttonPressed(list_view.currentIndex);
               }
           }

           Button
           {
               id:acceptWithoutPwd
               x:93
               y:5
               height:style.queryButtonHeight
               width:86
               text: "Accept without\n     Password"
               backgroundImagePath: "pics/Kb_Space_normal.png"
               disabled: !(querydialogcontext.getAuthentication())
               enabled: querydialogcontext.getAuthentication()
               fontsize: style.queryButtonFontSize
                onClicked:
               {
                   querydialogcontext.acceptWithoutPassword(m1.get(list_view.currentIndex).clAddress);
                   btnRect.buttonPressed(list_view.currentIndex);

               }
           }
           Button
           {
               id: reject_button
               x:192
               y:5
               height:style.queryButtonHeight
               width:75
               text: "Reject"
               backgroundImagePath: "pics/Kb_Space_normal.png"
               fontsize: style.queryButtonFontSize
               onClicked:
               {
                   querydialogcontext.rejectClient(m1.get(list_view.currentIndex).clAddress);
                   btnRect.buttonPressed(list_view.currentIndex);
               }
           }
        }
        function addClientQuery()
        {
            queryDialog.addClientData(clientIP, defaultAction, queryTimeout, 0,clientAddress);
            queryTimer.running = true;
        }
        function setClientIP(clIP)
        {
            clientIP = clIP;
        }
        function setClientAddress(clAddress)
        {
            clientAddress = clAddress;
        }

}

