import QtQuick 2.0

Rectangle {
    id: edge
    objectName: "NGraphEdge"

    property alias x1: edge.x
    property alias y1: edge.y

    property real x2: edge.x
    property real y2: edge.y

    function setXY1(v_x, v_y){ x1 = v_x; y1 = v_y }
    function setXY2(v_x, v_y){ x2 = v_x; y2 = v_y }

    //property string labelStart: "1"
    //property string labelEnd: "2"
    property string label
    property double weight: 1

    color: "black"
    height: 3
    smooth: true;

    transformOrigin: Item.TopLeft;

    width: getWidth(x1,y1,x2,y2);
    rotation: getSlope(x1,y1,x2,y2);

    function getWidth(sx1,sy1,sx2,sy2)
    {
        var w=Math.sqrt(Math.pow((sx2-sx1),2)+Math.pow((sy2-sy1),2));
        //console.debug("W: "+w);
        return w;
    }

    function getSlope(sx1,sy1,sx2,sy2)
    {
        var a,m,d;
        var b=sx2-sx1;
        //if (b===0)
            //return Math.PI;
        a=sy2-sy1;
        if(b == 0){
            if(a > 0){
                d = 90
            }else{
                d = -90
            }
        }else{
            m=a/b;
            d=Math.atan(m)*180/Math.PI;
        }
        //d=Math.atan2(a,b)*180/Math.PI;

        if (a<0 && b<0)
            return d+180;
        else if (a>=0 && b>=0)
            return d;
        else if (a<0 && b>=0)
            return d;
        else if (a>=0 && b<0)
            return d+180;
        else
            return 0;
    }
}
