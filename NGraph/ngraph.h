#ifndef NGRAPH_H
#define NGRAPH_H

#include <QString>
#include <QHash>
#include <QPair>

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
    void addNode(double x, double y, QString label);
    void addEdge(QString id1, QString id2, double weight, QString label);

    void moveNode(double x, double y, QString label);

    NGraphNode* getNode(QString label);
    QPair<QString, double>* getEdge(QString labelStart, QString labelEnd);
    QPair<QString, double>* getEdge(QString label);

    QList<NGraphNode*> getAdjecentNodes(QString id);
    QList<NGraphNode*> getNodeList();

    QString toString();

private:
    QHash<NGraphNode*, QHash<NGraphNode*, QPair<QString, double>* >* > *m_graph;
        // node           adjacent node     	 label   weight
};

#endif // NGRAPH_H
