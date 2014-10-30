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
                        graphMouseArea.z = 0
                        var childrenList = graphNodeContainer.children
                        for(var i= 0; i < childrenList.length; i++){
                            if(childrenList[i].objectName === "NGraphNode"){
                                childrenList[i].dragEnabled = true
                                console.debug("Set "+childrenList[i].label+" drag state")
                            }
                        }
                    }
                }
            },
            State{
                name: "ADDING_EDGES"
                StateChangeScript{
                    name: "ADDING_EDGES_SCRIPT"
                    script: {
                        graphMouseArea.z = 2
                        var childrenList = graphNodeContainer.children
                        for(var i= 0; i < childrenList.length; i++){
                            if(childrenList[i].objectName === "NGraphNode"){
                                childrenList[i].dragEnabled = false
                                console.debug("Set "+childrenList[i].label+" drag state")
                            }
                        }
                    }
                }
            }
        ]

        objectName: "graphArea"

        signal addNodeToModel(double x, double y)
        signal moveNodeInModel(double x, double y, string label)
        signal addEdgeToModel(string label1, string label2, double weight, string label);

        function startCreatingEdge(label){
            if(graphArea.state == "ADDING_EDGES"){
                var childrenList = graphNodeContainer.children
                var soughtNode;
                for(var i= 0; i < childrenList.length; i++){
                    if(childrenList[i].objectName === "NGraphNode"){
                        if(childrenList[i].label == label){
                            soughtNode = childrenList[i] 					///////// OPTIMIZE
                        }
                    }
                }
                if(!soughtNode){
                    console.debug("Node "+label+" not fount"); return
                }

                var newEdge = graphArea.edgeFactory.createObject(
                    graphEdgeContainer, {"x1" : soughtNode.x, "y1" : soughtNode.y,
                                 "x2" : graphMouseArea.mouseX, "y2" : graphMouseArea.mouseY,
                                 "label" : "tempEdge", "weight" : 1, "height" : 3,
                                 "z": 0});
                graphMouseArea.xyChanged.connect(newEdge.setXY2);  			// binds coords change
                console.debug("Creaded temporary edge... x = "+x+" y = "+y);
            }
        }

        function finishCreatingEdge(x, y, label){
            var endNode = graphNodeContainer.childAt(x, y)
            var tempEdgeObj = null
            var startNode = null
            var edgeList = graphEdgeContainer.children
            for(var i= 0; i < edgeList.length; i++){
                if(edgeList[i].objectName === "NGraphEdge"){
                    if(edgeList[i].label == "tempEdge"){
                        console.debug("Found temp edge!");
                        tempEdgeObj = edgeList[i]
                        startNode = graphNodeContainer.childAt(edgeList[i].x1,   // OPTIMIZE
                                                               edgeList[i].y1)
                    }
                }
            }

            if(tempEdgeObj!=null && startNode!=null){
                if(endNode){
                    graphMouseArea.xyChanged.disconnect(tempEdgeObj.setXY2);
                    console.debug("Created edge from "+startNode.label+" to "+endNode.label)
                    tempEdgeObj.destroy();
                    addEdgeToModel(startNode.label, endNode.label, 1, "Edge "+startNode.label+" "+endNode.label);   ///////////////CHANGE EDGE DATA
                }else{
                    graphMouseArea.xyChanged.disconnect(tempEdgeObj.setXY2);
                    console.debug("Cancelled adding edge");
                    tempEdgeObj.destroy();
                }
            }
        }
//        onMoveNodeInModel: {
            //console.debug("Node " +label+" moved!");
//        }

        property var nodeFactory: { Qt.createComponent("qrc:/qml/NGraphNode.qml") }
        property var edgeFactory: { Qt.createComponent("qrc:/qml/NGraphEdge.qml") }

        function addNodeToGraphView(x, y, label){
            console.debug("QMLView: nodeComponent.createComponent()");

            var newNode = graphArea.nodeFactory.createObject(
                graphNodeContainer, {"x" : x, "y" : y,
                                 "label" : label, "width": 50, "height" : 50,
                                 //"canvas": canvas,
                                 "dragEnabled": true,
                                 "z": 0});
            newNode.moved.connect(moveNodeInModel);
            newNode.moved.connect(moveNodeInModel);
            //newNode.mousePressed.connect(function(s){console.debug("Pressed node "+s)});
            //newNode.mousePressed.connect(startCreatingEdge);
            //newNode.mouseReleased.connect(function(x,y,s){console.debug("Released node "+s)});
            //newNode.mouseReleased.connect(finishCreatingEdge);
        }

        function addEdgeToGraphView(label1, label2, label, weight){
            console.debug("QMLView: edgeComponent.createComponent()");

            var nodeList = graphNodeContainer.children
            var startNode = null
            var endNode = null
            for(var i= 0; i < nodeList.length; i++){
                if(nodeList[i].objectName === "NGraphNode"){
                    if(nodeList[i].label == label1){
                        startNode = nodeList[i]
                    }else
                    if(nodeList[i].label == label2){
                        endNode = nodeList[i]
                    }
                }
            }

            var newEdge = graphArea.edgeFactory.createObject(
                graphEdgeContainer, {"x1" : startNode.x, "y1" : startNode.y,
                                     "x2" : endNode.x, "y2" : endNode.y,
                                     "label" : label, "weight" : weight, "height" : 3,
                                     "z": 0});
            startNode.moved.connect(newEdge.setXY1);
            endNode.moved.connect(newEdge.setXY2);
        }

        function moveNodeInGraphView(x, y, label){
            var childrenList = graphNodeContainer.children
            for(var i= 0; i < childrenList.length; i++){
                if(childrenList[i].objectName === "NGraphNode"){
                    if(childrenList[i].label === label){
                        childrenList[i].x = x
                        childrenList[i].y = y
                        return
                    }
                }
            }
            console.debug("No node with label "+label);
        }

        function moveEdgeInGraphView(x1, y1, x2, y2, label){
            console.debug("Moving "+label+"..."+" to x = "+x1+" y = "+y1+" x2 = "+x2+" y2 = "+y2);
            var childrenList = graphEdgeContainer.children
            for(var i= 0; i < childrenList.length; i++){
                if(childrenList[i].objectName === "NGraphEdge"){
                    if(childrenList[i].label === label){
                        childrenList[i].x1 = x1
                        childrenList[i].y1 = y1
                        childrenList[i].x2 = x2
                        childrenList[i].y2 = y2
                        return
                    }
                }
            }
        }

        color: "#FAFAFA"
        anchors.margins: 5
        width:parent.width*2/3
        height: parent.height-10
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left

        /*Canvas{
            id: canvas
            anchors.fill: parent
            width: 400
            height: parent.height
            contextType: "2d"
            onPaint: {
            }
        }*/

        MouseArea{
            id: graphMouseArea
            anchors.fill: parent
            hoverEnabled: true

            signal xyChanged(int x, int y);

            onPressed:{ /*canvas.requestPaint();*/
                if(graphArea.state == "MOVING_ADDING_NODES"){   // Create new node
                    console.debug("QMLView: Need to create a node! Emmiting signal...")
                    graphArea.addNodeToModel(mouseX, mouseY);
                }else if(graphArea.state == "ADDING_EDGES"){    // Start Creating New Edge
                    var nodeToBeClicked = graphNodeContainer.childAt(mouseX, mouseY)
                    if(nodeToBeClicked){
                        console.debug("Clicking node "+nodeToBeClicked.label);
                        graphArea.startCreatingEdge(nodeToBeClicked.label);
                    }else{
                    }
                }
            }

            onReleased: {
                if(graphArea.state == "ADDING_EDGES"){
                    graphArea.finishCreatingEdge(mouseX, mouseY);
                }else{

                }

            }
            onPositionChanged: {
                xyChanged(mouseX, mouseY);
            }

            //onMouseXChanged: {
                //console.debug("Moved in graphMouseArea");
            //}

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
            Item{
                id: graphNodeContainer
                z: 1
            }
            Item{
                id: graphEdgeContainer
                z: 0
            }
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
