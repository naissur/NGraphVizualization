#include "ngraphmodel.h"


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


void NGraphModel::addNodeToModel(double x, double y){

    qDebug("Generating label...");
    int i = 1;

    while( m_ngraph->getNode(QString::number(i)) ){
        i++;
    }

    QString label = QString::number(i); //GERENATE LABEL

    qDebug(QString("NGraphModel: Added node ").append(label).toStdString().c_str());

    m_ngraph->addNode(x, y, label);

    QList<NGraphNode *> nodes_list = m_ngraph->getNodeList();

    /*foreach (NGraphNode* node, nodes_list){
    qDebug(QString("NGraphModel: Holding node ").append(node->getLabel()).
            append(QString(" x = ")).append(QString::number(node->getX())).
            append(QString(" y = ")).append(QString::number(node->getY())).
            toStdString().c_str());
    }*/



    emit addNodeToView(x, y, label);
}

void NGraphModel::moveNodeInModel(double x, double y, QString label){
    foreach (NGraphNode* node, m_ngraph->getNodeList()){
        if( node->getLabel() == label ){
            node->setX(x);
            node->setY(y);
            qDebug(QString("NGraphModel: Set ").append(label).append(" coord to x = ").
                    append(QString::number(x)).append(QString(" y = ")).
                    append(QString::number(y)).toStdString().c_str());
            return;
        }
    }
    qDebug("NGraphModel: Hasn't found a node to move");
}

NGraphModel::~NGraphModel(){
    delete m_ngraph;
}
