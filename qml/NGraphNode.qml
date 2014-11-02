import QtQuick 2.0

Rectangle{
    id: node
    objectName: "NGraphNode";

    property string label
    //property var canvas

    property bool dragEnabled
    dragEnabled: true
    onDragEnabledChanged:{
        if(dragEnabled){
            nodeMouseArea.drag.target = node
        }else{
            nodeMouseArea.drag.target = null
        }
    }

    transform: Translate{ x: -height/2; y: -width/2 }

    signal mousePressed(string label)
    signal mouseReleased(int x, int y, string label)

    signal moved(int x, int y, string label)   // View Signal
    onMoved:{
        //console.debug(label+" : emitting move signal");
    }

    onXChanged: {
        moved(x, y, label)
    }
    onYChanged: {
        moved(x, y, label)
    }

    width: 30
    height: 30

    radius: height/2
    color: "black"


    onLabelChanged: {
        labelText.font.pointSize = node.width/(label.length); /////////REDO!!!
    }

    Text{
        id: labelText
        anchors.centerIn: parent
        color: "white"
        text: node.label
    }


    MouseArea{
        enabled: node.dragEnabled
        id: nodeMouseArea
        objectName: "NGraphNodeMouseArea"

        anchors.fill: parent
        drag.target: node
        onMouseXChanged: {
            //canvas.requestPaint();
        }
        onMouseYChanged: {
            //canvas.requestPaint();
        }
        onPressed:{
            //console.debug(node.label, " had mouse Pressed");
            node.mousePressed(node.label)
        }
        onReleased: {
//            console.debug(node.label, " had mouse Pressed");
            node.mouseReleased(mouseX, mouseY, node.label)
        }
        onDoubleClicked: {
            //console.debug(parent.x.toString()+" "+
                          //parent.y.toString());
        }
    }
}
