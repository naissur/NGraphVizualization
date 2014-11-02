#ifndef NGRAPH_H
#define NGRAPH_H

#include <QString>
#include <QHash>
#include <QPair>

#define NG_THRESHOLD 1

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

class NDoublePoint{
public:
    NDoublePoint(){m_x = 0; m_y = 0;}
    NDoublePoint(double x, double y){ m_x = x; m_y = y;}
    double getX(){ return m_x;}
    double getY(){ return m_y;}
    void setX(double val){ m_x = val; }
    void setY(double val){ m_y = val; }
private:
    double m_x;
    double m_y;
};

class NGraph {

public:
    NGraph();
    ~NGraph();

    void setScale(double val);
    double getScale();

    void addNode(double x, double y, QString label);
    void addEdge(QString id1, QString id2, double weight, QString label);

    void moveNode(double x, double y, QString label);

    void stabilize(double dt, double scale);

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
