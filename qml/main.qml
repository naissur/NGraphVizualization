import QtQuick 2.3

Rectangle{
    anchors.fill: parent
    color: "#AFAFAF"

    NGraphArea{
        id: graphArea
        pinchable: false
        width: parent.width/3*2-10
        height: parent.height-10
        x: 5
        anchors.verticalCenter: parent.verticalCenter
    }

    Rectangle{
        color: "#FAFAFA"
        anchors.margins: 5
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: graphArea.right

        Column{
            spacing: 10
            anchors.margins: 10
            anchors.fill: parent

            NNiftyButton{
                width:parent.width
                height: parent.height/5
                buttonText: "Move and add nodes"
                onClicked:{
                    graphArea.state = "MOVING_ADDING_NODES"
                }
            }
            NNiftyButton{
                width: parent.width
                height: parent.height/5
                buttonText: "Add edges"
                onClicked:{
                    graphArea.state = "ADDING_EDGES"
                }
            }
            NNiftyButton{
                width: parent.width
                height: parent.height/5
                buttonText: "Move view"
                onClicked:{
                    graphArea.state = "SCALING"
                }
            }
            Timer{
                id: stabilizeTimer;
                interval: 10; running: false; repeat: true;
                onTriggered:{
                    graphArea.stabilizeGraphModel(0.01, 0.005);   //Dt and Scale
                    }
            }
            NNiftyButton{
                width:parent.width
                height: parent.height/5
                buttonText: "Stabilize"
                onClicked: stabilizeTimer.running = !stabilizeTimer.running;
            }
        }
    }
}
