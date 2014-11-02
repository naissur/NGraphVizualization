#include "ngraphmodel.h"

#include <QtDebug>

NGraphModel::NGraphModel(QObject *parent) :
    QObject(parent) {

    qDebug("NGraphModel: Created a NGraphModel instance");
    m_ngraph = new NGraph();
    //addNodeToModel(100, 200);    //Testing purposes
    //addNodeToModel(200, 300);
    //addNodeToModel(400, 300);
    //addNodeToModel(500, 300);
    //m_ngraph->addEdge("1", "2", 10);
    //m_ngraph->addEdge("1", "3", 30);
    //m_ngraph->addEdge("1", "4", 20);
    //m_ngraph->addEdge("3", "4", -10);
    //qDebug(m_ngraph->toString().toStdString().c_str());
}

void NGraphModel::init(){
}


void NGraphModel::addNodeToModel(double x, double y, QString label){

    QString resLabel = label;

    if (label.isEmpty()){
        qDebug("NGraphModel: Generating node label...");
        int i = 1;
        while( m_ngraph->getNode(QString::number(i)) ){
            i++;
        }
        resLabel = QString::number(i); //GERENATE LABEL
    }

    qDebug() << "NGraphModel: Added node " << label;

    m_ngraph->addNode(x, y, resLabel);

    //QList<NGraphNode *> nodes_list = m_ngraph->getNodeList();

    /*foreach (NGraphNode* node, nodes_list){
    qDebug(QString("NGraphModel: Holding node ").append(node->getLabel()).
            append(QString(" x = ")).append(QString::number(node->getX())).
            append(QString(" y = ")).append(QString::number(node->getY())).
            toStdString().c_str());
    }*/



    emit addNodeToView(x, y, resLabel);
}

void NGraphModel::moveNodeInModel(double x, double y, QString label){
    /*foreach (NGraphNode* node, m_ngraph->getNodeList()){
        if( node->getLabel() == label ){
            node->setX(x);
            node->setY(y);
            qDebug(QString("NGraphModel: Set ").append(label).append(" coord to x = ").
                    append(QString::number(x)).append(QString(" y = ")).
                    append(QString::number(y)).toStdString().c_str());
            return;
        }
    }*/
    m_ngraph->moveNode(x, y, label);
    //qDebug(QString("NGraphModel: Moved node ").append(label).toStdString().c_str());

    /*foreach (NGraphNode* endNode, m_ngraph->getAdjecentNodes(label)){
        qDebug(QString("NGraphModel: Moving edge ").append(QString(label)).append(QString(" -> ")).append(
                QString(endNode->getLabel())).toStdString().c_str() );

        QString edgeLabel = m_ngraph->getEdge(label, endNode->getLabel())->first;
        //qDebug(QString("Label: ").append(label)
        emit moveEdgeInView(x, y, endNode->getX(), endNode->getY(), edgeLabel);
    }

    foreach (NGraphNode* startNode, m_ngraph->getNodeList() ){
        if( m_ngraph->getAdjecentNodes(startNode->getLabel()).contains(m_ngraph->getNode(label)) ){
            QString edgeLabel = m_ngraph->getEdge(startNode->getLabel(), label)->first;
            qDebug(QString("Label: ").append(edgeLabel).toStdString().c_str());

            qDebug(QString("NGraphModel: Moving edge ").append(QString(startNode->getLabel())).
                   append(QString(" -> ")).append(QString(label)).toStdString().c_str() );

            emit moveEdgeInView(startNode->getX(), startNode->getY(), x, y, edgeLabel);
        }
}*/
    //qDebug("NGraphModel: Hasn't found a node to move");
}

void NGraphModel::addEdgeToModel(QString labelStart, QString labelEnd, double weight, QString label){
    /*if(m_ngraph->getNode(labelStart) == NULL || m_ngraph->getNode(labelEnd) == NULL){
        return;
    }*/ // NGraph handles this condition

    QString resLabel = label;

    if(label.isEmpty()){
        qDebug("NGraphModel: Generating edge label...");
        int i = 1;
        while( m_ngraph->getEdge(QString(label).append(QString::number(i)) )){
            i++;
        }
        resLabel = QString("Edge ").append(QString::number(i)); //GERENATE LABEL
    }

    m_ngraph->addEdge(labelStart, labelEnd, weight, resLabel);
    qDebug() << "NGraphModel: Added edge " << resLabel;

    /*if(m_ngraph->getEdge("Edge1")){
        qDebug(" Edge1 exists");
    }else{
        qDebug(" Edge1 does not exist");
    }*/

    emit addEdgeToView(labelStart, labelEnd, resLabel, weight);
}

void NGraphModel::stabilizeGraphModel(double dt, double scale){
    m_ngraph->stabilize(dt, scale);
    updateGraphInView();
    //qDebug("Stabilized!");
}

void NGraphModel::updateGraphInView(){
    foreach(NGraphNode* node, m_ngraph->getNodeList()){
        emit moveNodeInView(node->getX(), node->getY(), node->getLabel());
    }
}


NGraphModel::~NGraphModel(){
    delete m_ngraph;
}
