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

    signal nodeMoved(int x, int y, string label)   // View Signal
    signal nodeDragged(int x, int y, string label)   // View Signal
    onNodeMoved:{
        //console.debug(label+" : emitting move signal");
    }

    onXChanged: {
        nodeMoved(x, y, label);
    }
    onYChanged: {
        nodeMoved(x, y, label);
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
            node.nodeDragged(node.x, node.y, label)
        }
        onMouseYChanged: {
            //canvas.requestPaint();
            node.nodeDragged(node.x, node.y, label)
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
