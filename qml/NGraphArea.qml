import QtQuick 2.0


Rectangle{
    id: graphArea
    objectName: "graphArea"

    color: "#FAFAFA"
    width: 100
    height: 100

    property bool pinchable: false// NOT YET IMPLEMENTED!

    state: "MOVING_ADDING_NODES"
    states: [
        State{
            name: "MOVING_ADDING_NODES"
            StateChangeScript{
                name: "MOVING_ADDING_NODES_SCRIPT"
                script: {
                    graphMouseArea.drag.target = null
                    graphMouseArea.z = 0
                    graphPinchArea.z = 0
                    graphArea.setNodesDragState(true)
                }
            }
        },
        State{
            name: "ADDING_EDGES"
            StateChangeScript{
                name: "ADDING_EDGES_SCRIPT"
                script: {
                    graphMouseArea.drag.target = null
                    graphMouseArea.z = 2
                    graphPinchArea.z = 2
                    graphArea.setNodesDragState(false)
                }
            }
        },
        State{
            name: "SCALING"
            StateChangeScript{
                name: "SCALING"
                script: {
                    graphMouseArea.drag.target = graphContainer
                    graphMouseArea.z = 0
                    graphPinchArea.z = 2
                    graphArea.setNodesDragState(false)
                }
            }
        }
    ]

    signal addNodeToModel(double x, double y)
    signal moveNodeInModel(double x, double y, string label)
    signal addEdgeToModel(string label1, string label2, double weight, string label);

    signal stabilizeGraphModel(double dt, double scale);

    function startCreatingEdge(label){
        if(graphArea.state == "ADDING_EDGES"){
            var childrenList = graphNodeContainer.children
            var soughtNode;
            for(var i= 0; i < childrenList.length; i++){
                if(childrenList[i].objectName === "NGraphNode"){
                    if(childrenList[i].label == label){
                        soughtNode = childrenList[i]
                        break
                    }
                }
            }
            if(!soughtNode){
                console.debug("Node "+label+" not fount"); return
            }

            var newEdge = graphArea.edgeFactory.createObject(
                graphEdgeContainer, {"x1" : soughtNode.x, "y1" : soughtNode.y,
                             "x2" : graphMouseArea.mouseX-graphContainer.x, "y2" : graphMouseArea.mouseY-graphContainer.y,
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
                    startNode = graphNodeContainer.childAt(edgeList[i].x1,
                                                           edgeList[i].y1)
                    break
                }
            }
        }

        if(tempEdgeObj!=null && startNode!=null){
            if(endNode){
                graphMouseArea.xyChanged.disconnect(tempEdgeObj.setXY2);
                console.debug("Created edge from "+startNode.label+" to "+endNode.label)
                addEdgeToModel(startNode.label, endNode.label, 1, "Edge "+startNode.label+" "+endNode.label);   ///////////////CHANGE EDGE DATA
                tempEdgeObj.destroy();
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


    function setNodesDragState(val){
        var nodesList = graphNodeContainer.children
        for(var i= 0; i < nodesList.length; i++){
            if(nodesList[i].objectName === "NGraphNode"){
                nodesList[i].dragEnabled = true
                //console.debug("Set "+nodesList[i].label+" drag state")
            }
        }
        console.debug("Set nodes drag state to "+val)
    }

    function addNodeToGraphView(x, y, label){
        console.debug("QMLView: nodeComponent.createComponent()");

        var newNode = graphArea.nodeFactory.createObject(
            graphNodeContainer, {"x" : x, "y" : y,
                             "label" : label, "width": 50, "height" : 50,
                             //"canvas": canvas,
                             "dragEnabled": true,
                             "z": 0});
        newNode.nodeDragged.connect(moveNodeInModel);
        newNode.nodeDragged.connect(moveNodeInModel);
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

        if((startNode != null) && (endNode != null)){
            var newEdge = graphArea.edgeFactory.createObject(
                graphEdgeContainer, {"x1" : startNode.x, "y1" : startNode.y,
                                     "x2" : endNode.x, "y2" : endNode.y,
                                     "label" : label, "weight" : weight, "height" : 3,
                                     "z": 0});
            startNode.nodeMoved.connect(newEdge.setXY1);
            endNode.nodeMoved.connect(newEdge.setXY2);
        }
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


    /*function moveEdgeInGraphView(x1, y1, x2, y2, label){
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
    }*/


    /*Canvas{
        id: canvas
        anchors.fill: parent
        width: 400
        height: parent.height
        contextType: "2d"
        onPaint: {
        }
    }*/

    PinchArea{
        id: graphPinchArea
        anchors.fill: parent

        property int xpoint
        property int ypoint
        property int pinchscale
        property int pinchrotation
        enabled: true
        pinch.target: graphContainer
        pinch.dragAxis: Pinch.XandYAxis
        pinch.minimumScale: 0.5
        pinch.maximumScale: 2
        pinch.minimumX: -graphArea.width
        pinch.maximumX: graphArea.width
        pinch.minimumY: -graphArea.height
        pinch.maximumY: graphArea.height
        pinch.minimumRotation: 0
        pinch.maximumRotation: 0
        onPinchUpdated: {
            xpoint = pinch.center.x;
            //rect.x = xpoint;
            ypoint = pinch.center.y;
            //rect.y = ypoint;
            pinchrotation = pinch.rotation;
            //rect.rotation = pinchrotation
            pinchscale = pinch.scale
            //rect.scale = pinchscale
        }

        MouseArea{
            id: graphMouseArea
            anchors.fill: parent
            hoverEnabled: true

            signal xyChanged(int x, int y);

            onPressed:{ /*canvas.requestPaint();*/
                if(graphArea.state == "MOVING_ADDING_NODES"){   // Create new node
                    console.debug("QMLView: Need to create a node! Emmiting signal...")
                    graphArea.addNodeToModel(mouseX-graphContainer.x, mouseY-graphContainer.y);
                }else if(graphArea.state == "ADDING_EDGES"){    // Start Creating New Edge
                    var nodeToBeClicked = graphNodeContainer.childAt(mouseX-graphContainer.x, mouseY-graphContainer.y)
                    if(nodeToBeClicked){
                        console.debug("Clicking node "+nodeToBeClicked.label);
                        graphArea.startCreatingEdge(nodeToBeClicked.label);
                    }else{
                    }
                }
            }

            onReleased: {
                if(graphArea.state == "ADDING_EDGES"){
                    graphArea.finishCreatingEdge(mouseX-graphContainer.x, mouseY-graphContainer.y);
                    // Relative to what? Try passing these first
                }else{

                }

            }
            onPositionChanged: {
                xyChanged(mouseX-graphContainer.x, mouseY-graphContainer.y);
                // Pass coordinates relative to graphcontainer, think it'll work
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
    }

    Item{   // contains all nodes and edges
        id: graphContainer
        transformOrigin: Item.Center
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
