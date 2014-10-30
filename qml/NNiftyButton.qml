import QtQuick 2.0

Rectangle {
    id: niftyButton
    width: 100
    height: 20
    radius: height/4

    gradient: defaultGradient

    signal clicked()
//    onClicked:  console.debug("Nifty Button Clicked!")

    property string buttonText: "Click"
    property var textColor: "#FFFFFF"

    property var topGradientColor: "#33bdef"
    property var topHoverGradientColor: "#94def7"
    property var bottomGradientColor: "#019ad2"
    property var borderColor: "#057fd0"


    property var defaultGradient:
        Gradient {
            GradientStop { position: 0.0; color: topGradientColor }
            GradientStop { position: 1.0; color: bottomGradientColor }
        }

    property var hoverGradient:
        Gradient {
            GradientStop { position: 0.0; color: topHoverGradientColor }
            GradientStop { position: 1.0; color: bottomGradientColor }
        }

    property var pressGradient:
        Gradient {
            GradientStop { position: 0.0; color: bottomGradientColor }
            GradientStop { position: 1.0; color: topGradientColor }
        }

    border.color: "blue"
    border.width: 1

    Text{
        anchors.centerIn: parent
        //anchors.fill: parent
        //anchors.margins: 5

        text: niftyButton.buttonText
        color: niftyButton.textColor
        styleColor: "#000000"
        font.family: "Verdana"
        style: Text.Sunken
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        width: parent.width - parent.radius
        height: parent.height - 5
        font.pixelSize: height/3
        elide: Text.ElideRight
    }

    MouseArea{
        id: buttonMouseArea
        anchors.fill: parent
        hoverEnabled: true
        onPressed: {
            niftyButton.gradient = niftyButton.pressGradient
        }
        onReleased: {
            niftyButton.gradient = (niftyButton.gradient === niftyButton.pressGradient) ?
                                    (niftyButton.hoverGradient) : (niftyButton.defaultGradient)
            //niftyButton.onClicked();
        }
        onExited: {
            niftyButton.gradient = niftyButton.defaultGradient
        }
        onEntered: {
            niftyButton.gradient = niftyButton.hoverGradient
        }
        onClicked:{
            niftyButton.clicked();
        }
    }
}
