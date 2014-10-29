#ifndef NGRAPH_H
#define NGRAPH_H

#include <QString>
#include <QHash>

class NGraphNode{

public:
    NGraphNode();
    NGraphNode(double x, double y, QString label);

    double getX();
    double getY();
    QString getLabel();

    void setX(double);
    void setY(double);
    void setLabel(QString);

private:
    double m_x;
    double m_y;
    QString m_label;
};

class NGraph {

public:
    NGraph();
    ~NGraph();
    void addNode(double x, double y, QString id);
    NGraphNode* getNode(QString label);
    void addEdge(QString id1, QString id2, double weight);
    QList<NGraphNode*> getAdjecentNodes(QString id);
    QList<NGraphNode*> getNodeList();

    QString toString();

private:
    QHash<NGraphNode*, QHash<NGraphNode*, double>* > *m_graph;
        // node           adjacent node    weight
};

#endif // NGRAPH_H
