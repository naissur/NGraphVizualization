import QtQuick 2.0

Rectangle{
    id: node

    property string label
    property int x_pos
    property int y_pos
    property var canvas

    property bool dragEnabled
    dragEnabled: true

    signal mousePressed()
    signal mouseReleased(int x, int y)

    signal moved(int x, int y, string label)   // View Signal
    onMoved:{
        //console.debug(label+" : emitting move signal");
    }

//    x_pos: x + width/2
//    y_pos: y + height/2

    onXChanged: {
        moved(x+width/2, y+height/2, label)
    }
    onYChanged: {
        moved(x+width/2, y+height/2, label)
    }

    /*onX_posChanged: {
        x = x_pos - width / 2
    }
    onY_posChanged: {
        y = y_pos - height / 2
    }*/

    width: 30
    height: 30
    //x: x_pos - width/2
    //y: y_pos - height/2

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
        anchors.fill: parent
        drag.target: node
        onMouseXChanged: {
            canvas.requestPaint();
        }
        onMouseYChanged: {
            canvas.requestPaint();
        }
        onPressed:{
            console.debug(node.label, " drag has started");
            node.mousePressed()
        }
        onReleased: {
            console.debug(node.label, " drag has finished");
            node.mouseReleased(mouseX, mouseY)
        }
        onDoubleClicked: {
            console.debug(parent.x.toString()+" "+
                          parent.y.toString());
        }
    }
}
