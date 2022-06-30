import QtQuick 2.0

Item
{
SystemPalette {id: palette}
//image and icon sources
property string closeButtonSource: "pics/Kb_ButtonClose_normal.png"
property string clearButtonSource:"pics/Kb_Icon_Clear.png"
property string capsLockButtonSource:"pics/Kb_Icon_CapsLock.png"
property string shiftButtonSource:"pics/Kb_Icon_Shift.png"
property string backspaceButtonSource:"pics/Kb_Icon_Delete.png"
property string eneterButtonSource:"pics/Kb_Icon_Enter.png"
property string leftarrowButtonSource:"pics/Kb_Icon_Left.png"
property string rightarrowButtonSource:"pics/Kb_Icon_Right.png"
property string enterButtonBackgroundImage:"pics/Kb_Enter_normal.png"
property string spaceButtonBackgroundImage:"pics/Kb_Space_normal.png"

//colors
property color textInputSelectedTextColor:"#ffffff"
property color textInputSelectionColor:"#1c1f30"
property color textInputTextColor:"#1c1f30"
property color textInputBorderColor:"#525d62"
property color virtualKeyboardBackground:"#d1d1d1"
property color qVirtualKeyboardBorderColor:"#000000"
property color qTitlebarcolor:"#3e414f"
property color licenseDialogcolor:"#f4f4f5"
property color queryHighlightColor:"#B0C4DE"
//  general dimensions
property int qTitlebarHeight:30
property int qTitlebarWidth:30
property int closeButtonHeight:30
property int  closeButtonWidth:30
property int clearButtonHeight:20
property int clearButtonWidth:20
property int textInputFontSize:16
property string textInputFontFamily: "Siemens Sans"
property real textInputRoundness:3
property int textInputRectangleHeight:30
property int qVirtualKeyboardWidth:0
property int qVirtualKeyboardHeight:0
property real qbuttonWidth: 40
property real qbuttonHeight:35
property int qMarginBetweenTitleAndTextInput:38
property int qMarginBetweenTextInputAndButtonLayout:40

// dimensions specific to 4" display

property int fourInch_SoftKeypadHeight:276
property int fourInch_SoftKeypadWidth:480
property int fourInch_buttonWidth: 40
property int fourInch_buttonHeight:43
property int fourInch_PortraitMode_buttonWidth: 39
property int fourInch_PortraitMode_buttonHeight:40
property int fourInch_PortraitMode_buttonWidthForNumericKeypad: 50
property int fourInch_PortraitMode_buttonHeightForNumericKeypad: 40
property int fourInch_buttonWidthForNumericKeypad: 46
property int fourInch_buttonHeightForNumericKeypad:38
property int fourInch_buttonLayoutLeftMargin:70
property int fourInch_buttonLayoutTopMargin:11
property int fourInch_MarginBetweenTextInputAndMaxValue:5

// As per HWI the defined mm  per pixel (For width and Height)is as below
/******************************
 * Device * Width  * Height   *
 ******************************
 * 7"     * 0.1926 * 0.179    *
 ******************************
 * 9"     * 0.2475 * 0.232708 *
 ******************************/

// dimensions specific to 7" & 9" display
// Height = (83mm/0.179mm/) = 463.6871508379888 px for 7"
property int sevenToNineInch_SoftKeypadHeight: 400

// Width = (150mm/0.1926mm) = 778.816199376947 px for 7"
property int sevenToNineInch_SoftKeypadWidth: 700

// Width = (12mm/0.1926mm) = 62.30529595015576 px for 7" Landscape
property int sevenToNineInch_LandscapeMode_buttonWidth_ForAlphaNumericKeypad:62

// Height = (12mm/0.179mm/) = 67.0391061452514 px for 7" Lanscape and Potrait
property int sevenToNineInch_LandscapeMode_buttonHeight_ForAlphaNumericKeypad:67

// Width = (12.1338mm/0.1926mm) = 63 px for 7" Potrait
property int sevenToNineInch_PotraitMode_buttonWidth_ForAlphaNumericKeypad:63

// Height = (12mm/0.179mm/) = 67.0391061452514 px for 7" Lanscape and Potrait
property int sevenToNineInch_PotraitMode_buttonHeight_ForAlphaNumericKeypad:67

// Width = (13.5mm/0.1926mm/) = 70.09345794392523 px for 7"
property int sevenToNineInch_LandscapeMode_buttonWidthForNumericKeypad:70

// Height = (10.5mm/0.179mm) = 58.65921787709497 px for 7"
property int sevenToNineInch_LandscapeMode_buttonHeightForNumericKeypad:58

// Width = (15mm/0.1926mm/) = 77.8816199376947 px for 7"
property int sevenToNineInch_PortraitMode_buttonWidthForNumericKeypad:80

// Height = (12mm/0.179mm) = 67.0391061452514 px for 7"
property int sevenToNineInch_PortraitMode_buttonHeightForNumericKeypad:67

property int sevenToNineInch_titleBarHeight:40
property int sevenToNineInch_textInputRectangleHeight:35
property int sevenToNineInch_closeButtonHeight:40
property int sevenToNineInch_closeButtonWidth:40
property int sevenToNineInch_marginBetweenTitleAndTextInput: 50
property int sevenToNineInch_marginBetweenTextInputAndButtonLayout: 50
property int sevenToNineInch_buttonLayoutLeftMargin: -30
property int sevenToNineInch_buttonLayoutTopMargin:12
property int sevenToNineInch_MarginBetweenTextInputAndMaxValue:7

// dimensions specific to 12" display

property int twelveInch_SoftKeypadHeight:368
property int twelveInch_SoftKeypadWidth:588
property int twelveInch_buttonWidth: 50
property int twelveInch_buttonHeight:55
property int twelveInch_PortraitModebuttonWidth: 57
property int twelveInch_PortraitModebuttonHeight:52
property int twelveInch_buttonWidthForNumericKeypad: 61
property int twelveInch_buttonHeightForNumericKeypad:47
property int twelveInch_PortraitMode_buttonWidthForNumericKeypad: 72
property int twelveInch_PortraitMode_buttonHeightForNumericKeypad:54
property int twelveInch_textInputRectangleHeight:44
property int twelveInch_TitlebarHeight: 48
property int twelveInch_closeButtonHeight:48
property int twelveInch_closeButtonWidth:49
property int twelveInch_marginBetweenTitleAndTextInput: 60
property int twelveInch_marginBetweenTextInputAndButtonLayout: 60
property int twelveInch_buttonLayoutLeftMargin:5
property int twelveInch_buttonLayoutTopMargin:15
property int twelveInch_MarginBetweenTextInputAndMaxValue:9


//dimensions specific to license Dialog

property int licenseDialogWidth:272
property int licenseDialogHeight:200
property int licenseDialogHeaderFooter:34

//dimensions specific to query Dialog

property int queryDialogWidth:272
property int queryDialogHeight:200
property int queryDialogHeaderHeight:34
property int queryDialogFooterHeight:44
property int queryButtonHeight:34
property int queryButtonFontSize:8
property int queryDelegateHeight:56
}
