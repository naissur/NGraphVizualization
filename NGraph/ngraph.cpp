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
    qDebug("NGraph: Created NGraph instance");
    m_graph = new QHash< NGraphNode* , QHash<NGraphNode*, double>* >;
}

void NGraph::addNode(double x, double y, QString label){
    NGraphNode *newNode = new NGraphNode(x, y, label);

    m_graph->insert(newNode, new QHash<NGraphNode*, double>);
    qDebug(QString("NGraph: added node ").append(label).append(
            QString(" x = ")).append(QString::number(newNode->getX())).append(
            QString(" y = ")).append(QString::number(newNode->getY())).toStdString().c_str());
}

QList<NGraphNode*> NGraph::getNodeList(){
    return m_graph->keys();
}

QList<NGraphNode*> NGraph::getAdjecentNodes(QString label){

}

void NGraph::addEdge(QString id1, QString id2, double weight){
    NGraphNode* node1 = getNode(id1);
    NGraphNode* node2 = getNode(id2);
    if( (node1 != NULL) & (node2 != NULL) ){
        m_graph->value(node1)->insert(node2, weight);
    }else{
        return;
    }
    qDebug(QString("NGraph: added edge ").append(id1).append(QString(" -> ")).append(id2).
           append(QString(" w = ")).
           append(QString::number(weight)).toStdString().c_str());
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
                res += QString::number(m_graph->value(node1)->value(node2));
                res += " ) ";
            }
            res += " ] ";
        }else{
            res += " \" , ";
        }
    }
    res += " ]";
    return res;
}

NGraph::~NGraph(){
    delete m_graph;
}
