#ifndef NGRAPHVIEW_H
#define NGRAPHVIEW_H

#include <QObject>
#include <QQuickView>

#define STD_WIDTH 640
#define STD_HEIGHT 480


class NGraphView : public QObject {

    Q_OBJECT
public:
    explicit NGraphView(QObject *parent = 0);
    NGraphView(int width, int height, QObject *parent = 0);
    ~NGraphView();

    void show();

signals:
    void addNodeToModel(double x, double y);
    void moveNodeInModel(double x, double y, QString label);
    void addEdgeToModel(QString startLabel, QString endLabel, double weight, QString edgeLabel);
    void stabilizeGraphModel(double dt, double scale);

    // QML signals declared here
    void addNodeToGraphView(QVariant x, QVariant y, QVariant label);
    void addEdgeToGraphView(QVariant startLabel, QVariant endLabel, QVariant label, QVariant weight);

    void moveNodeInGraphView(QVariant x, QVariant y, QVariant label);
    //void moveEdgeInGraphView(QVariant x1, QVariant y1,
                             //QVariant x2, QVariant y2, QVariant label);

public slots:
    void addNodeToView(double x, double y, QString label);
    void moveNodeInView(double x, double y, QString label);

    void addEdgeToView(QString labelStart, QString labelEnd, QString label, double weight);
    //void moveEdgeInView(double x1, double y1, double x2, double y2, QString label);

private:
    QQuickView *m_window;

};

#endif // NGRAPHVIEW_H
