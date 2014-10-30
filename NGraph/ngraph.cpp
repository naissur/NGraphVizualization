#include "ngraph.h"


NGraphNode::NGraphNode(){
    m_x = 0;
    m_y = 0;
    m_label = QString("");
}

NGraphNode::NGraphNode(double x, double y, QString label){
    m_x = x;
    m_y = y;
    m_label = label;
}

double NGraphNode::getX() { return m_x; }
double NGraphNode::getY() { return m_y; }
QString NGraphNode::getLabel() { return m_label; }

void NGraphNode::setX(double x) { m_x = x; }
void NGraphNode::setY(double y) { m_y = y; }
void NGraphNode::setLabel(QString label) { m_label = label; }


NGraph::NGraph() {
//    qDebug("NGraph: Created NGraph instance");
    m_graph = new QHash< NGraphNode* , QHash<NGraphNode*, QPair<QString, double>* >* >;
}

void NGraph::addNode(double x, double y, QString label){
    NGraphNode *newNode = new NGraphNode(x, y, label);

    m_graph->insert(newNode, new QHash<NGraphNode*, QPair<QString, double>* >);
    /*qDebug(QString("NGraph: added node ").append(label).append(
            QString(" x = ")).append(QString::number(newNode->getX())).append(
            QString(" y = ")).append(QString::number(newNode->getY())).toStdString().c_str());
            */
//    qDebug(toString().toStdString().c_str());
}

QList<NGraphNode*> NGraph::getNodeList(){
    return m_graph->keys();
}

QList<NGraphNode*> NGraph::getAdjecentNodes(QString label){
    if(getNode(label)){
        return m_graph->value(getNode(label))->keys();
    }
    return QList<NGraphNode* >();
}

void NGraph::addEdge(QString id1, QString id2, double weight, QString label){
    NGraphNode* node1 = getNode(id1);
    NGraphNode* node2 = getNode(id2);
    if( (node1 != NULL) & (node2 != NULL) ){
        QPair<QString, double>* newPair = new QPair<QString,double>(label,weight);
        m_graph->value(node1)->insert(node2, newPair);
    }else{
        return;
    }
    /*qDebug(QString("NGraph: added edge ").append(id1).append(QString(" -> ")).append(id2).
           append(QString(" w = ")).
           append(QString::number(weight)).toStdString().c_str());*/
//    qDebug(toString().toStdString().c_str());
}

NGraphNode* NGraph::getNode(QString label){
    foreach (NGraphNode* node, m_graph->keys()){
        if(node->getLabel() == label){
            return node;
        }
    }
    return NULL;
}

QString NGraph::toString(){
    QString res;
    res += "[ ";
    foreach (NGraphNode* node1, m_graph->keys()){
        res += " \" ";
        res += node1->getLabel();
        if(m_graph->value(node1)->keys().count() > 0){
            res += " \" : [ ";
            foreach (NGraphNode* node2, m_graph->value(node1)->keys()){
                res += "( \"";
                res += node2->getLabel();
                res += "\" : ";

                res += "\"";
                res += QString(m_graph->value(node1)->value(node2)->first);
                res += "\", ";

                res += QString::number(m_graph->value(node1)->value(node2)->second);
                res += " )";
            }
            res += " ] ";
        }else{
            res += " \" , ";
        }
    }
    res += " ]";
    return res;
}

void NGraph::moveNode(double x, double y, QString label){ // Also has to move all adjacent edges coordinates
    foreach (NGraphNode* node, getNodeList()){
        if( node->getLabel() == label ){
            node->setX(x);
            node->setY(y);
//            qDebug(QString("NGraph: Set ").append(label).append(" coord to x = ").
//                    append(QString::number(x)).append(QString(" y = ")).
//                    append(QString::number(y)).toStdString().c_str());
            return;
        }
    }
}

QPair<QString, double>* NGraph::getEdge(QString labelStart, QString labelEnd){
    if(getNode(labelStart) != NULL && getNode(labelEnd)){
        if(m_graph->value(getNode(labelStart))->keys().contains(getNode(labelEnd))){
            //return new QPair<QString*, NGraphNode*>(getNode(labelStart), getNode(labelEnd));
            return m_graph->value(getNode(labelStart))->value(getNode(labelEnd));
        }
    }
    return NULL;
}

QPair<QString, double>* NGraph::getEdge(QString label){
    foreach (NGraphNode* nodeStart, getNodeList()){
        foreach (NGraphNode* nodeEnd, getAdjecentNodes(nodeStart->getLabel())){
            if(m_graph->value(nodeStart)->value(nodeEnd)->first == label){
//                return new QPair<NGraphNode*, NGraphNode*>(nodeStart, nodeEnd);
                return m_graph->value(nodeStart)->value(nodeEnd);
            }
        }
    }
    return NULL;
}

NGraph::~NGraph(){
    delete m_graph;
}
