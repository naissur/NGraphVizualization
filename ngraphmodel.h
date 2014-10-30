#ifndef NGRAPHMODEL_H
#define NGRAPHMODEL_H

#include <QObject>
#include "NGraph/ngraph.h"

class NGraphModel : public QObject {

    Q_OBJECT
public:
    explicit NGraphModel(QObject *parent = 0);
    void init();
    ~NGraphModel();

signals:
    void addNodeToView(double x, double y, QString label);
    void addEdgeToView(QString labelStart, QString labelEnd, QString label, double weight);

    void moveNodeInView(double x, double y, QString label);
    //void moveEdgeInView(double x1, double y1, double x2, double y2, QString label); // Model does not move edges

public slots:
    void addNodeToModel(double x, double y, QString label = QString(""));
    void moveNodeInModel(double x, double y, QString label);

    void addEdgeToModel(QString labelStart, QString labelEnd, double weight = 1, QString label = QString("") );

private:
    NGraph* m_ngraph;

};

#endif // NGRAPHMODEL_H
