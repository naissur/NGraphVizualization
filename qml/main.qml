import QtQuick 2.3
import QtQuick.Controls 1.2

Rectangle{
    anchors.fill: parent
    color: "#AFAFAF"

    Rectangle{
        id: graphArea

        state: "MOVING_ADDING_NODES"
        states: [
            State{
                name: "MOVING_ADDING_NODES"
                StateChangeScript{
                    name: "MOVING_ADDING_NODES_SCRIPT"
                    script: {
                        graphMouseArea.enabled = true
                        var nodeList = graphContainer.children
                        for(var i= 0; i < nodeList.length; i++){
                            nodeList[i].dragEnabled = true
                            console.debug("Set "+nodeList[i].label+" drag state")
                        }
                    }
                }
            },
            State{
                name: "ADDING_EDGES"
                StateChangeScript{
                    name: "ADDING_EDGES_SCRIPT"
                    script: {
                        graphMouseArea.enabled = false
                        var nodeList = graphContainer.children
                        for(var i= 0; i < nodeList.length; i++){
                            nodeList[i].dragEnabled = false
                            console.debug("Set "+nodeList[i].label+" drag state")
                        }
                    }
                }
            }
        ]

        objectName: "graphArea"

        signal addNodeToModel(double x, double y)
        signal moveNodeInModel(double x, double y, string label)
//        onMoveNodeInModel: {
            //console.debug("Node " +label+" moved!");
//        }

        property var nodeFactory: { Qt.createComponent("qrc:/qml/NGraphNode.qml") }

        function addNodeToGraphView(x, y, label){
            console.debug("QMLView: nodeComponent.createComponent()");

            var newNode = graphArea.nodeFactory.createObject(
                graphContainer, {"x" : x-50/2, "y" : y-50/2,
                                 "label" : label, "width": 50, "height" : 50,
                                 "canvas": canvas,
                                 "dragEnabled": true});
            newNode.moved.connect(moveNodeInModel);
            newNode.moved.connect(moveNodeInModel);
        }

        function moveNodeInGraphView(x, y, label){
            var nodeList = graphContainer.children
            for(var i= 0; i < nodeList.length; i++){
                if(nodeList[i].label == label){
                    nodeList[i].x = x
                    nodeList[i].y = y
                    return
                }
            }
            console.debug("No node with label "+label);
        }

        color: "#FAFAFA"
        anchors.margins: 5
        width:parent.width*2/3
        height: parent.height-10
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left

        Canvas{
            id: canvas
            anchors.fill: parent
            width: 400
            height: parent.height
            contextType: "2d"
            onPaint: {
            }
        }

        MouseArea{
            id: graphMouseArea
            anchors.fill: parent
            onPressed:{ canvas.requestPaint(); console.debug("QMLView: Need to create a node! Emmiting signal...")
                graphArea.addNodeToModel(mouseX, mouseY);
            }

            /*state: "ENABLED"
            states: [
                State{
                    name: "DISABLED"
                    when: (graphArea.state == "MOVING_ADDING_NODES")
                    PropertyChanges { target: graphMouseArea; enabled: true}
                },
                State{
                    name: "ENABLED"
                    when: (graphArea.state == "ADDING_EDGES")
                    PropertyChanges { target: graphMouseArea; enabled: false}
                }
            ]*/
        }

        Item{   // contains all nodes and edges
            id: graphContainer
        }


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
        }
    }
}
